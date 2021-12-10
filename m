Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CE54705D9
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 17:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243690AbhLJQkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 11:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243671AbhLJQkT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 11:40:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B85C061353
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 08:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=V5ElOkfVRDzjvPfScyHzr/shE5gWQxuaU0C3XbyTCXQ=; b=asCSgKlE4T9QOetZZow1J2xP9L
        P2a3jgmqLE3EYgcUVIP7Jwyv1FgcmmfbFspd0CVZ2r/ooQadzV//kyqCOVNvKBYqy+FSI0hgewhKd
        VksrnK+yCz75p/dLm45FPdJqV8DAwQahmjuVyA7z0zlGoRijdSIKhT2Piq0B5+pnA5FvZugr/4mZ3
        27y3obtRyhWOJ5RH6s8DzXBcYygkUuZQ5s2schCMt0io7nRcNHbIjUMjuTlqYzv+2HKuwhvGvR2i9
        j5mBn6A25rgDqEyU4xk+OrtoOJCdqQ7xrqK2emCeQRPmGtY45135vF6397e0X6YjczEeVR6fOOCx7
        4m2NW23w==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvisk-00AUQx-W7; Fri, 10 Dec 2021 16:36:27 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvisl-0000ln-7m; Fri, 10 Dec 2021 16:36:27 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
Subject: [PATCH v6 5/6] KVM: x86: Fix wall clock writes in Xen shared_info not to mark page dirty
Date:   Fri, 10 Dec 2021 16:36:24 +0000
Message-Id: <20211210163625.2886-6-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211210163625.2886-1-dwmw2@infradead.org>
References: <20211210163625.2886-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

When dirty ring logging is enabled, any dirty logging without an active
vCPU context will cause a kernel oops. But we've already declared that
the shared_info page doesn't get dirty tracking anyway, since it would
be kind of insane to mark it dirty every time we deliver an event channel
interrupt. Userspace is supposed to just assume it's always dirty any
time a vCPU can run or event channels are routed.

So stop using the generic kvm_write_wall_clock() and just write directly
through the gfn_to_pfn_cache that we already have set up.

We can make kvm_write_wall_clock() static in x86.c again now, but let's
not remove the 'sec_hi_ofs' argument even though it's not used yet. At
some point we *will* want to use that for KVM guests too.

Fixes: 629b5348841a ("KVM: x86/xen: update wallclock region")
Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c |  2 +-
 arch/x86/kvm/x86.h |  1 -
 arch/x86/kvm/xen.c | 62 +++++++++++++++++++++++++++++++++++-----------
 3 files changed, 49 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1f254d6d503f..5e7a4982fb90 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2130,7 +2130,7 @@ static s64 get_kvmclock_base_ns(void)
 }
 #endif
 
-void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock, int sec_hi_ofs)
+static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock, int sec_hi_ofs)
 {
 	int version;
 	int r;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 4abcd8d9836d..da7031e80f23 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -301,7 +301,6 @@ static inline bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu)
 	return is_smm(vcpu) || static_call(kvm_x86_apic_init_signal_blocked)(vcpu);
 }
 
-void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock, int sec_hi_ofs);
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
 
 u64 get_kvmclock_ns(struct kvm *kvm);
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index ceddabd1f5c6..0e3f7d6e9fd7 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -25,8 +25,11 @@ DEFINE_STATIC_KEY_DEFERRED_FALSE(kvm_xen_enabled, HZ);
 static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 {
 	struct gfn_to_pfn_cache *gpc = &kvm->arch.xen.shinfo_cache;
+	struct pvclock_wall_clock *wc;
 	gpa_t gpa = gfn_to_gpa(gfn);
-	int wc_ofs, sec_hi_ofs;
+	u32 *wc_sec_hi;
+	u32 wc_version;
+	u64 wall_nsec;
 	int ret = 0;
 	int idx = srcu_read_lock(&kvm->srcu);
 
@@ -35,32 +38,63 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 		goto out;
 	}
 
-	ret = kvm_gfn_to_pfn_cache_init(kvm, gpc, NULL, false, true, gpa,
-					PAGE_SIZE, false);
-	if (ret)
-		goto out;
+	do {
+		ret = kvm_gfn_to_pfn_cache_init(kvm, gpc, NULL, false, true,
+						gpa, PAGE_SIZE, false);
+		if (ret)
+			goto out;
+
+		/*
+		 * This code mirrors kvm_write_wall_clock() except that it writes
+		 * directly through the pfn cache and doesn't mark the page dirty.
+		 */
+		wall_nsec = ktime_get_real_ns() - get_kvmclock_ns(kvm);
+
+		/* It could be invalid again already, so we need to check */
+		read_lock_irq(&gpc->lock);
+
+		if (gpc->valid)
+			break;
+
+		read_unlock_irq(&gpc->lock);
+	} while (1);
 
 	/* Paranoia checks on the 32-bit struct layout */
 	BUILD_BUG_ON(offsetof(struct compat_shared_info, wc) != 0x900);
 	BUILD_BUG_ON(offsetof(struct compat_shared_info, arch.wc_sec_hi) != 0x924);
 	BUILD_BUG_ON(offsetof(struct pvclock_vcpu_time_info, version) != 0);
 
-	/* 32-bit location by default */
-	wc_ofs = offsetof(struct compat_shared_info, wc);
-	sec_hi_ofs = offsetof(struct compat_shared_info, arch.wc_sec_hi);
-
 #ifdef CONFIG_X86_64
 	/* Paranoia checks on the 64-bit struct layout */
 	BUILD_BUG_ON(offsetof(struct shared_info, wc) != 0xc00);
 	BUILD_BUG_ON(offsetof(struct shared_info, wc_sec_hi) != 0xc0c);
 
-	if (kvm->arch.xen.long_mode) {
-		wc_ofs = offsetof(struct shared_info, wc);
-		sec_hi_ofs = offsetof(struct shared_info, wc_sec_hi);
-	}
+	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
+		struct shared_info *shinfo = gpc->khva;
+
+		wc_sec_hi = &shinfo->wc_sec_hi;
+		wc = &shinfo->wc;
+	} else
 #endif
+	{
+		struct compat_shared_info *shinfo = gpc->khva;
+
+		wc_sec_hi = &shinfo->arch.wc_sec_hi;
+		wc = &shinfo->wc;
+	}
+
+	/* Increment and ensure an odd value */
+	wc_version = wc->version = (wc->version + 1) | 1;
+	smp_wmb();
+
+	wc->nsec = do_div(wall_nsec,  1000000000);
+	wc->sec = (u32)wall_nsec;
+	*wc_sec_hi = wall_nsec >> 32;
+	smp_wmb();
+
+	wc->version = wc_version + 1;
+	read_unlock_irq(&gpc->lock);
 
-	kvm_write_wall_clock(kvm, gpa + wc_ofs, sec_hi_ofs - wc_ofs);
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MASTERCLOCK_UPDATE);
 
 out:
-- 
2.31.1

