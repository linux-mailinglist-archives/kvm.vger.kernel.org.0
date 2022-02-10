Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67DC4B0307
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 03:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbiBJCIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 21:08:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235899AbiBJCIn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 21:08:43 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833C6B6B
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 18:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=TqNdvpCfmSXhqFJSoKVWx4TQwHdp3FSWSSRfSqxyXY0=; b=V7Nms1pwSXbtAyYom22/soVSvo
        cohnmRSFlz1JwUS7vYiR58/ecKFcj+TZdv8CXnRU0Mf08TlvF9h/KcLFL+Emg1AkmyCFEDJ/9seX3
        sZQ2r2m9dKBo4xhuWGJa6zdaG7GQxxSgOnFd2JemlLhOe3Mgxw3B7lK+A/S2MB3SD2sOhn5Obvhwb
        +TXVx4SoShwtcV8VXu7vCeJwYfXs2WnJSGJj5uzoZvV1qqI/hmR0rfRK+xoLPxWizuZKeZFlVPq2B
        u8TqXE/RoBdr1wrO2i5MpibWii8a0+6lk960hehwP3gC2LA1U5P5VhxFV/ar8H0dgxCaokCsYWYYP
        RYzdq8fw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHxIy-008YWG-Dl; Thu, 10 Feb 2022 00:27:24 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHxIy-0019DN-5U; Thu, 10 Feb 2022 00:27:24 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
Subject: [PATCH v0 09/15] KVM: x86/xen: handle PV IPI vcpu yield
Date:   Thu, 10 Feb 2022 00:27:15 +0000
Message-Id: <20220210002721.273608-10-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220210002721.273608-1-dwmw2@infradead.org>
References: <20220210002721.273608-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

Cooperative Linux guests after an IPI-many may yield vcpu if
any of the IPI'd vcpus were preempted (i.e. runstate is 'runnable'.)
Support SCHEDOP_yield for handling yield.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/xen.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 909c25521554..3df44c996d66 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -19,6 +19,7 @@
 #include <xen/interface/xen.h>
 #include <xen/interface/vcpu.h>
 #include <xen/interface/event_channel.h>
+#include <xen/interface/sched.h>
 
 #include "trace.h"
 
@@ -800,6 +801,20 @@ static int kvm_xen_hypercall_complete_userspace(struct kvm_vcpu *vcpu)
 	return kvm_xen_hypercall_set_result(vcpu, run->xen.u.hcall.result);
 }
 
+static bool kvm_xen_hcall_sched_op(struct kvm_vcpu *vcpu, int cmd, u64 param, u64 *r)
+{
+	switch (cmd) {
+	case SCHEDOP_yield:
+		kvm_vcpu_on_spin(vcpu, true);
+		*r = 0;
+		return true;
+	default:
+		break;
+	}
+
+	return false;
+}
+
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 {
 	bool longmode;
@@ -840,7 +855,9 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 		if (params[0] == EVTCHNOP_send)
 			handled = kvm_xen_hcall_evtchn_send(vcpu, params[1], &r);
 		break;
-
+	case __HYPERVISOR_sched_op:
+		handled = kvm_xen_hcall_sched_op(vcpu, params[0], params[1], &r);
+		break;
 	default:
 		break;
 	}
-- 
2.33.1

