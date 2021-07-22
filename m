Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6D43D2C5C
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 21:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhGVS0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 14:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhGVS0P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 14:26:15 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8EE9C061757
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 12:06:49 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so702296pjd.0
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 12:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=++YPVeXiRAF0ld70h5PkRREiwYJDuzKVd/QVk5anzyI=;
        b=NVGVo87/x/62KKQnCoWnNE38zR2RAv/5SyUE6lJrHQ9jME3xQRx111X3ANKXUthivS
         a7aZtLfk+6eWZds1G4TTlkWKGTOjBm/M9ei6/lT8tXkwuu6XuAZogplV3SZzlsRcbhgn
         QnSvYJYl1eVr3NfHmaL98oGxfkwpuFOOH78sdYAygF7X27e1aB8LAh/ZbSvlfIAvfn7y
         8c3f6RZPvEbSR0TFz3/+wXDk4CMIXLEx5BM4NDMzd6R60ur7I9/TcVmv1JwUbBOswT5l
         6g/BIcSlzcYJxCOEykc+qa3Z0A5Mt8JEWUeZCX+i8zPOuHGGHoP5YXE7TxegWaMJs4ht
         Y+sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=++YPVeXiRAF0ld70h5PkRREiwYJDuzKVd/QVk5anzyI=;
        b=IXFYmdg6Hx9v1p1d8LH/RLSqlsMyM8ieOWzxtVJkqxnyUubTni1pHymVXOmMDhNoED
         zVJ9QY/cwaPfzvwg9djM4a/xaD0rGpXiq3PsbY6JeODG/KB4uZu5/2aeJ/yp4JPA1dPa
         aWbgq2lUhF4Mbv+Y082yaeJjVhKv8y6bX5kJ9nZNOK4ZIASnCpf/DuLoK0PErUwGxwLj
         3UYjDCrL80k2gsBImk74vkRjFeiksACsJaGz6mRVqbfXeoQsc2yIDZa5dAbFuybNkWWv
         4fYiv9GQIhZdtA7IPK7cFLaz7Z7kVL5UkmbujU8srZlys5CpTYnaSFVlNX8VbUxbawyu
         G1vw==
X-Gm-Message-State: AOAM531Zm/0zmGrcgSv1hPYtWnBvm4aMxkzdgjmfuvI77awytbkEtGYU
        T7fvMT6ym1fIMYO/N6vvWwaAhA==
X-Google-Smtp-Source: ABdhPJwy3y36l+yYrL4TdZXEVl6rH+wUSP+YPktlPCdfcgUIiVmhxhHJB9Cou5pewZmodHBgG9Mc/A==
X-Received: by 2002:a17:90a:4681:: with SMTP id z1mr10512838pjf.156.1626980809201;
        Thu, 22 Jul 2021 12:06:49 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y4sm3762098pjg.9.2021.07.22.12.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 12:06:48 -0700 (PDT)
Date:   Thu, 22 Jul 2021 19:06:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 8/8] KVM: x86: hyper-v: Deactivate APICv only when
 AutoEOI feature is in use
Message-ID: <YPnBxHwMJkTSBHfC@google.com>
References: <20210713142023.106183-1-mlevitsk@redhat.com>
 <20210713142023.106183-9-mlevitsk@redhat.com>
 <c51d3f0b46bb3f73d82d66fae92425be76b84a68.camel@redhat.com>
 <YPXJQxLaJuoF6aXl@google.com>
 <64ed28249c1895a59c9f2e2aa2e4c09a381f69e5.camel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cJIO2yLXCw3oFKw2"
Content-Disposition: inline
In-Reply-To: <64ed28249c1895a59c9f2e2aa2e4c09a381f69e5.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--cJIO2yLXCw3oFKw2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

+Ben

On Thu, Jul 22, 2021, Maxim Levitsky wrote:
> On Mon, 2021-07-19 at 18:49 +0000, Sean Christopherson wrote:
> > On Sun, Jul 18, 2021, Maxim Levitsky wrote:
> > > I am more inclined to fix this by just tracking if we hold the srcu
> > > lock on each VCPU manually, just as we track the srcu index anyway,
> > > and then kvm_request_apicv_update can use this to drop the srcu
> > > lock when needed.
> > 
> > The entire approach of dynamically adding/removing the memslot seems doomed to
> > failure, and is likely responsible for the performance issues with AVIC, e.g. a
> > single vCPU temporarily inhibiting AVIC will zap all SPTEs _twice_; on disable
> > and again on re-enable.
> > 
> > Rather than pile on more gunk, what about special casing the APIC access page
> > memslot in try_async_pf()?  E.g. zap the GFN in avic_update_access_page() when
> > disabling (and bounce through kvm_{inc,dec}_notifier_count()), and have the page
> > fault path skip directly to MMIO emulation without caching the MMIO info.  It'd
> > also give us a good excuse to rename try_async_pf() :-)
> > 
> > If lack of MMIO caching is a performance problem, an alternative solution would
> > be to allow caching but add a helper to zap the MMIO SPTE and request all vCPUs to
> > clear their cache.
> > 
> > It's all a bit gross, especially hijacking the mmu_notifier path, but IMO it'd be
> > less awful than the current memslot+SRCU mess.
> 
> Hi!
> 
> I am testing your approach and it actually works very well! I can't seem to break it.
> 
> Could you explain why do I need to do something with kvm_{inc,dec}_notifier_count()) ?

Glad you asked, there's one more change needed.  kvm_zap_gfn_range() currently
takes mmu_lock for read, but it needs to take mmu_lock for write for this case
(more way below).

The existing users, update_mtrr() and kvm_post_set_cr0(), are a bit sketchy.  The
whole thing is a grey area because KVM is trying to ensure it honors the guest's
UC memtype for non-coherent DMA, but the inputs (CR0 and MTRRs) are per-vCPU,
i.e. for it to work correctly, the guest has to ensure all running vCPUs do the
same transition.  So in practice there's likely no observable bug, but it also
means that taking mmu_lock for read is likely pointless, because for things to
work the guest has to serialize all running vCPUs.

Ben, any objection to taking mmu_lock for write in kvm_zap_gfn_range()?  It would
effectively revert commit 6103bc074048 ("KVM: x86/mmu: Allow zap gfn range to
operate under the mmu read lock"); see attached patch.  And we could even bump
the notifier count in that helper, e.g. on top of the attached:

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b607e8763aa2..7174058e982b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5568,6 +5568,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)

        write_lock(&kvm->mmu_lock);

+       kvm_inc_notifier_count(kvm, gfn_start, gfn_end);
+
        if (kvm_memslots_have_rmaps(kvm)) {
                for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
                        slots = __kvm_memslots(kvm, i);
@@ -5598,6 +5600,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
        if (flush)
                kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);

+       kvm_dec_notifier_count(kvm, gfn_start, gfn_end);
+
        write_unlock(&kvm->mmu_lock);
 }




Back to Maxim's original question...

Elevating mmu_notifier_count and bumping mmu_notifier_seq will will handle the case
where APICv is being disabled while a different vCPU is concurrently faulting in a
new mapping for the APIC page.  E.g. it handles this race:

 vCPU0                                 vCPU1
                                       apic_access_memslot_enabled = true;
 			               #NPF on APIC
			               apic_access_memslot_enabled==true, proceed with #NPF
 apic_access_memslot_enabled = false 
 kvm_zap_gfn_range(APIC);
                                       __direct_map(APIC)

 mov [APIC], 0 <-- succeeds, but KVM wants to intercept to emulate



The elevated mmu_notifier_count and/or changed mmu_notifier_seq will cause vCPU1
to bail and resume the guest without fixing the #NPF.  After acquiring mmu_lock,
vCPU1 will see the elevated mmu_notifier_count (if kvm_zap_gfn_range() is about
to be called, or just finised) and/or a modified mmu_notifier_seq (after the
count was decremented).

This is why kvm_zap_gfn_range() needs to take mmu_lock for write.  If it's allowed
to run in parallel with the page fault handler, there's no guarantee that the
correct apic_access_memslot_enabled will be observed.

	if (is_tdp_mmu_fault)
		read_lock(&vcpu->kvm->mmu_lock);
	else
		write_lock(&vcpu->kvm->mmu_lock);

	if (!is_noslot_pfn(pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva)) <--- look here!
		goto out_unlock;

	if (is_tdp_mmu_fault)
		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, map_writable, max_level,
				    pfn, prefault);
	else
		r = __direct_map(vcpu, gpa, error_code, map_writable, max_level, pfn,
				 prefault, is_tdp);

--cJIO2yLXCw3oFKw2
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-Revert-KVM-x86-mmu-Allow-zap-gfn-range-to-operate-un.patch"

From 18c4f6445231dfeb355772d1de09d933fe8ef8cf Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 Jul 2021 11:59:15 -0700
Subject: [PATCH] Revert "KVM: x86/mmu: Allow zap gfn range to operate under
 the mmu read lock"

Sean needs to write a changelog.

This effectively reverts commit 6103bc074048876794fa6d21fd8989331690ccbd.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 19 ++++++++-----------
 arch/x86/kvm/mmu/tdp_mmu.c | 15 ++++-----------
 arch/x86/kvm/mmu/tdp_mmu.h | 11 ++++-------
 3 files changed, 16 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b888385d1933..b607e8763aa2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5566,8 +5566,9 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	int i;
 	bool flush = false;
 
+	write_lock(&kvm->mmu_lock);
+
 	if (kvm_memslots_have_rmaps(kvm)) {
-		write_lock(&kvm->mmu_lock);
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 			slots = __kvm_memslots(kvm, i);
 			kvm_for_each_memslot(memslot, slots) {
@@ -5586,22 +5587,18 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 		}
 		if (flush)
 			kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
-		write_unlock(&kvm->mmu_lock);
 	}
 
 	if (is_tdp_mmu_enabled(kvm)) {
-		flush = false;
-
-		read_lock(&kvm->mmu_lock);
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
 			flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start,
-							  gfn_end, flush, true);
-		if (flush)
-			kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
-							   gfn_end);
-
-		read_unlock(&kvm->mmu_lock);
+							  gfn_end, flush);
 	}
+
+	if (flush)
+		kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
+
+	write_unlock(&kvm->mmu_lock);
 }
 
 static bool slot_rmap_write_protect(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index caac4ddb46df..16f4d91deb56 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -773,21 +773,15 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
  * non-root pages mapping GFNs strictly within that range. Returns true if
  * SPTEs have been cleared and a TLB flush is needed before releasing the
  * MMU lock.
- *
- * If shared is true, this thread holds the MMU lock in read mode and must
- * account for the possibility that other threads are modifying the paging
- * structures concurrently. If shared is false, this thread should hold the
- * MMU in write mode.
  */
 bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
-				 gfn_t end, bool can_yield, bool flush,
-				 bool shared)
+				 gfn_t end, bool can_yield, bool flush)
 {
 	struct kvm_mmu_page *root;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, shared)
+	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, false)
 		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush,
-				      shared);
+				      false);
 
 	return flush;
 }
@@ -799,8 +793,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	int i;
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, max_gfn,
-						  flush, false);
+		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, max_gfn, flush);
 
 	if (flush)
 		kvm_flush_remote_tlbs(kvm);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 1cae4485b3bc..ec8b012488fc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -20,14 +20,11 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared);
 
 bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
-				 gfn_t end, bool can_yield, bool flush,
-				 bool shared);
+				 gfn_t end, bool can_yield, bool flush);
 static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
-					     gfn_t start, gfn_t end, bool flush,
-					     bool shared)
+					     gfn_t start, gfn_t end, bool flush)
 {
-	return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush,
-					   shared);
+	return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush);
 }
 static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
@@ -44,7 +41,7 @@ static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	 */
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	return __kvm_tdp_mmu_zap_gfn_range(kvm, kvm_mmu_page_as_id(sp),
-					   sp->gfn, end, false, false, false);
+					   sp->gfn, end, false, false);
 }
 
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
-- 
2.32.0.432.gabb21c7263-goog


--cJIO2yLXCw3oFKw2--
