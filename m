Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1FE634B9E
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 01:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbiKWAUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 19:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234512AbiKWAUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 19:20:37 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEA1D5A0D
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 16:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=mlp8veIal+exzXXUNMI9ARhDb1z9qQxsAhW32IRDmcY=; b=hfMXAvofT6pLU/7jE3YKFuSizs
        YApfrt8JRwrTPromb0Ek+h46oPYQDTfQ+aehtfj4F+2k5mE22i2F2M5llHRtTnaOOVGtzVboLmy8+
        QJA5gC5xnY7OClkQ+pqjlRf98MTy4hkLak+UNAXKhLyJf3p3N16poenFr5TSW+0hJbZ+Y44SMljka
        QkJH4WQAFZsrtRWikyTkB9OYQ+BG1Gcj8mnxMcBQwiXNldL1+UHeHFSZBLr7aAzqHBIjbu7KH7hfh
        GokPKu0MiYiggFk76nwMh+6fKzIPZtE6hDHgaJimxLpF/4XYQqzrsvc/jbWDbVHsaqMZisqY+9iET
        ay0jcTgQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxdVF-006uLD-Jo; Wed, 23 Nov 2022 00:20:37 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxdV8-000O7e-Gr; Wed, 23 Nov 2022 00:20:30 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Michal Luczaj <mhal@rbox.co>, kvm@vger.kernel.org
Subject: [PATCH 1/3] KVM: x86/xen: Validate port number in SCHEDOP_poll
Date:   Wed, 23 Nov 2022 00:20:28 +0000
Message-Id: <20221123002030.92716-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

We shouldn't allow guests to poll on arbitrary port numbers off the end
of the event channel table.

Fixes: 1a65105a5aba ("KVM: x86/xen: handle PV spinlocks slowpath")
[dwmw2: my bug though; the original version did check the validity as a
 side-effect of an idr_find() which I ripped out in refactoring.]
Reported-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Cc: stable@kernel.org
---
 arch/x86/kvm/xen.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 2dae413bd62a..dc2f304f2e69 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -954,6 +954,14 @@ static int kvm_xen_hypercall_complete_userspace(struct kvm_vcpu *vcpu)
 	return kvm_xen_hypercall_set_result(vcpu, run->xen.u.hcall.result);
 }
 
+static inline int max_evtchn_port(struct kvm *kvm)
+{
+	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode)
+		return EVTCHN_2L_NR_CHANNELS;
+	else
+		return COMPAT_EVTCHN_2L_NR_CHANNELS;
+}
+
 static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
 			       evtchn_port_t *ports)
 {
@@ -1042,6 +1050,10 @@ static bool kvm_xen_schedop_poll(struct kvm_vcpu *vcpu, bool longmode,
 			*r = -EFAULT;
 			goto out;
 		}
+		if (ports[i] >= max_evtchn_port(vcpu->kvm)) {
+			*r = -EINVAL;
+			goto out;
+		}
 	}
 
 	if (sched_poll.nr_ports == 1)
@@ -1297,14 +1309,6 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static inline int max_evtchn_port(struct kvm *kvm)
-{
-	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode)
-		return EVTCHN_2L_NR_CHANNELS;
-	else
-		return COMPAT_EVTCHN_2L_NR_CHANNELS;
-}
-
 static void kvm_xen_check_poller(struct kvm_vcpu *vcpu, int port)
 {
 	int poll_evtchn = vcpu->arch.xen.poll_evtchn;
-- 
2.35.3

