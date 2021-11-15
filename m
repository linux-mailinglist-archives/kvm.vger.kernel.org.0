Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D46450A17
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 17:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhKOQyB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 11:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbhKOQxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 11:53:42 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAA7C061746
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 08:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=HwiPKnZL4j3tPps0I6gs9w+5zHq9re6+4gY1NvEU4Y8=; b=qEmMfjgFpyuOwdSJ9qvSRMOqct
        55j9V5I/onget/SkeYlVZPKaAwV3uDdxPMHkPMofhMlV32lgFMnt1T5UBuVGhKNJg+O3CZO4dX/0R
        grGopOVE3Sftr+rnFxDrKQqdjPs/c9QXoZN4jVIfB3dPQM59qbLT/HWRfENhpaPpQ916oWKODgPC4
        xiORjBHBE/Xmiqn2BNduTKwgwSocP1eCswsjnnidBVNGzWjbkkVZa9KN3IVBTjlUANEFq2uqSWijI
        9/7480EWlKbP9XrHNdLUAOsEWFLs9y7zb/qaIC4yo+xLGFvpSCLfxiLOkdI5LCQAc6p3vn4EGeIgf
        9TUMkleQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmfBe-005qz1-CD; Mon, 15 Nov 2021 16:50:31 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmfBe-0001we-J4; Mon, 15 Nov 2021 16:50:30 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com
Subject: [PATCH 04/11] KVM: x86/xen: Use sizeof_field() instead of open-coding it
Date:   Mon, 15 Nov 2021 16:50:23 +0000
Message-Id: <20211115165030.7422-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211115165030.7422-1-dwmw2@infradead.org>
References: <95fae9cf56b1a7f0a5f2b9a1934e29e924908ff2.camel@infradead.org>
 <20211115165030.7422-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/xen.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 6dd3d687cf04..565da9c3853b 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -127,9 +127,9 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	state_entry_time = vx->runstate_entry_time;
 	state_entry_time |= XEN_RUNSTATE_UPDATE;
 
-	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->state_entry_time) !=
+	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state_entry_time) !=
 		     sizeof(state_entry_time));
-	BUILD_BUG_ON(sizeof(((struct compat_vcpu_runstate_info *)0)->state_entry_time) !=
+	BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state_entry_time) !=
 		     sizeof(state_entry_time));
 
 	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
@@ -144,9 +144,9 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	 */
 	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=
 		     offsetof(struct compat_vcpu_runstate_info, state));
-	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->state) !=
+	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state) !=
 		     sizeof(vx->current_runstate));
-	BUILD_BUG_ON(sizeof(((struct compat_vcpu_runstate_info *)0)->state) !=
+	BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state) !=
 		     sizeof(vx->current_runstate));
 
 	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
@@ -163,9 +163,9 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 		     offsetof(struct vcpu_runstate_info, time) - sizeof(u64));
 	BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state_entry_time) !=
 		     offsetof(struct compat_vcpu_runstate_info, time) - sizeof(u64));
-	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->time) !=
-		     sizeof(((struct compat_vcpu_runstate_info *)0)->time));
-	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->time) !=
+	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=
+		     sizeof_field(struct compat_vcpu_runstate_info, time));
+	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=
 		     sizeof(vx->runstate_times));
 
 	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
@@ -205,9 +205,9 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 	BUILD_BUG_ON(offsetof(struct vcpu_info, evtchn_upcall_pending) !=
 		     offsetof(struct compat_vcpu_info, evtchn_upcall_pending));
 	BUILD_BUG_ON(sizeof(rc) !=
-		     sizeof(((struct vcpu_info *)0)->evtchn_upcall_pending));
+		     sizeof_field(struct vcpu_info, evtchn_upcall_pending));
 	BUILD_BUG_ON(sizeof(rc) !=
-		     sizeof(((struct compat_vcpu_info *)0)->evtchn_upcall_pending));
+		     sizeof_field(struct compat_vcpu_info, evtchn_upcall_pending));
 
 	/*
 	 * For efficiency, this mirrors the checks for using the valid
-- 
2.31.1

