Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D4D4C79C5
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 21:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiB1UHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 15:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiB1UGx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 15:06:53 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33602AE06
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 12:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=I72i8FI2BNVkATFBY1K/JwzSpTykKs3E2xpdI3Q66HU=; b=RQgKDS8rEzRdNvHjybRG/ywIhp
        PO66o3/L+5YAqGs6/gmPkueXJWNLlbeGRKSpCg8nErWd2yRshg6vsgW0A4hQpDJTWy/yNkW1ln/Ky
        qoWMTBOWkjEwC4P3B2q/bgXAUvlFd5XXJ+v4QNlfPgubQkCr3u1srXlQ97Brs7D8chrD7u/w+Aia3
        9HiWGXcNB/IxuKJIZFyABjb9KBPDjxYxLvRuhix8KikCg71zJmcYAcG1TmGxiWi98Xr8DGB2vbU2x
        aTB+1njsFgNLsBUGlv1n/tpSWX31GgQw7GtK9FzHOOemYEbGDicfCurf0lCkw96Q5dkdkOPgD9z2N
        FChcEmkg==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nOmHK-00DzoE-KI; Mon, 28 Feb 2022 20:05:54 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nOmHK-000d9j-3i; Mon, 28 Feb 2022 20:05:54 +0000
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
Subject: [PATCH v2 10/17] KVM: x86/xen: handle PV IPI vcpu yield
Date:   Mon, 28 Feb 2022 20:05:45 +0000
Message-Id: <20220228200552.150406-11-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220228200552.150406-1-dwmw2@infradead.org>
References: <20220228200552.150406-1-dwmw2@infradead.org>
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
index ef80f2df1d10..ed6b18e0d31f 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -19,6 +19,7 @@
 #include <xen/interface/xen.h>
 #include <xen/interface/vcpu.h>
 #include <xen/interface/event_channel.h>
+#include <xen/interface/sched.h>
 
 #include "trace.h"
 
@@ -798,6 +799,20 @@ static int kvm_xen_hypercall_complete_userspace(struct kvm_vcpu *vcpu)
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
@@ -838,7 +853,9 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
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

