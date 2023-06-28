Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915EA74156E
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 17:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbjF1PiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 11:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbjF1Pht (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 11:37:49 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A022110
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 08:37:47 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-666edb1f24aso5072086b3a.2
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 08:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687966667; x=1690558667;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vPkmOZsStIRwjbDOEXaXo6r7N3JQ7QJXcRY6iLzA/Qk=;
        b=DKVopbz40gCodRwuFrblNmczBiV7uP7jTfggZxesVD6svK5lhtuPvapRqniQHtYu2q
         AwHR4RJglp1crZbofE7aQv9RikrC1F/s60aShTh2BqnI6pYDISsNbnAY+NlMIHxoF7eZ
         kxg2BW3pIFYNj3Z/18g/v/CGKeT86MVEyk8EqOQL9t0C09C8Zscjbmlp10OEPGcM4RpY
         3c8jr5w2jN0Dhl1SPbsi6CYQ9Ehvp1civaYDH45BDHQ6cSk/Ae9C4UK/KrmlcL9WLFLZ
         E+AcFAFAYNHXA/NM3/RBU5qgVbB6HcwUjib3XgKZbiH+0F8/2pGcQVLJm/qSaAxKLmjG
         jtKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687966667; x=1690558667;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vPkmOZsStIRwjbDOEXaXo6r7N3JQ7QJXcRY6iLzA/Qk=;
        b=gUoKA/eGJLxuRXiqkRn52SKmVvfjDKqpnAgx9g6NWP5FL1u3O0JKQBXHFtDkb2kHZ5
         BaqI6cTKDLcLc43Nv3SeS3N6LM68XrlBg2Oxj2EObJ3Qrqxj0xmJnnw28lwNZuJh7/pL
         JrO9TQ+LMYpoXWkNlyrfBQ4pLYSsJR9OYcQvlCgWF5QD+vdrmJZmzC0m/bhZiGjrtxxR
         rFa4yyJeoHMpbPbUCCNkW7c4TjKT34/DKsuX1G6tfrt9pNc+1LVeIXncrvcrAtOympqO
         CGmkBLuoyqWMrRebpuLg73bulDiwGiY2yQfNpDdEfj7+49oZvZEZfAQpJQ7TyPRy2XfE
         DY/w==
X-Gm-Message-State: AC+VfDw2YjJTlPk3gsHCUiD+Q3lc1Uw83u85UYUq51JIpYaGHTe42+6Y
        9CHfuhDX0KHzA4AHNxDCgXErEO5xAuc=
X-Google-Smtp-Source: ACHHUZ6Ql/94Qt3z7G/UNZhUNRJWw4KsKpHHwJNc0t4Ibppx6UPzGeVWvleYA0AJjIVkNFaSNhQlLjEp8e8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d94:b0:668:843e:d413 with SMTP id
 fb20-20020a056a002d9400b00668843ed413mr7794157pfb.2.1687966666879; Wed, 28
 Jun 2023 08:37:46 -0700 (PDT)
Date:   Wed, 28 Jun 2023 08:37:45 -0700
In-Reply-To: <20230628071217.71126-1-ishiir@g.ecc.u-tokyo.ac.jp>
Mime-Version: 1.0
References: <20230628071217.71126-1-ishiir@g.ecc.u-tokyo.ac.jp>
Message-ID: <ZJxTTZzZnfbyMVIH@google.com>
Subject: Re: [PATCH] KVM: nVMX: Prevent vmlaunch with EPTP pointing outside
 assigned memory area
From:   Sean Christopherson <seanjc@google.com>
To:     Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>
Cc:     ishiir@g.ecc.u-tokyo.ac.jp, shina@ecc.u-tokyo.ac.jp,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023, Reima Ishii wrote:
> In nested virtualization, if L1 sets an EPTP in VMCS12 that points
> beyond the assigned memory area and initiates a vmlaunch to L2, the
> existing KVM code handles the vmlaunch, and passes the VMCS
> consistency check. However, due to EPTP pointing outside accessible
> memory from the vCPU in mmu_check_root(), it attempts to trigger a
> triple fault.
> 
> As a result, the nested_vmx_triple_fault() and nested_vmx_vmexit() are
> called before the actual vmlaunch to L2 occurs. Despite the vmlaunch
> not actually being executed in L2, KVM attempts a vmexit to L1,
> resulting in a warning in nested_vmx_vmexit() due to the
> nested_run_pending flag.
> 
> This commit resolves the issue by modifying the nested_vmx_check_eptp()
> to return false when EPTP points outside the assigned memory area.
> This effectively prevents a vmlaunch with such an EPTP, thus avoiding
> the unnecessary warning.
> 
> Signed-off-by: Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>
> ---
>  arch/x86/kvm/vmx/nested.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index e35cf0bd0df9..721f98a5dc24 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2727,6 +2727,10 @@ static bool nested_vmx_check_eptp(struct kvm_vcpu *vcpu, u64 new_eptp)
>  			return false;
>  	}
>  
> +	/* Check if EPTP points to an assigned memory area */
> +	if (!kvm_vcpu_is_visible_gfn(vcpu, new_eptp >> PAGE_SHIFT))
> +		return false;

This is wrong, an EPTP that has a legal GPA but points at non-existent memory
does not trigger VM-Fail.  But the existing behavior isn't correct either
(obviously), because even though a bad EPT will *probably* lead to shutdown,
(a) it's not guaranteed and (b) the CPU won't read the underlying memory until
after VM-Enter succeeds.  E.g. if L1 runs L2 with a VMX preemption timer value
of '0', then architecturally the preemption timer VM-Exit is guaranteed to occur
before the CPU executes any instruction, i.e. before the CPU needs to translate
a GPA to a HPA (so long as there are no injected events with higher priority than
the preemption timer).

Furthermore, KVM applies this logic *only* to the root (and PDPTRs).  E.g. if
a lower level page table points at a KVM-internal memslot, KVM will happily read
the backing memory and use it as the guest PTE value.

The behavior is quite ancient, and unsurprisingly the changelog provides no real
justification for the behavior.

  commit 8986ecc0ef58c96eec48d8502c048f3ab67fd8e2
  Author: Marcelo Tosatti <mtosatti@redhat.com>
  Date:   Tue May 12 18:55:45 2009 -0300

    KVM: x86: check for cr3 validity in mmu_alloc_roots
    
    Verify the cr3 address stored in vcpu->arch.cr3 points to an existant
    memslot. If not, inject a triple fault.

I'm struggling to think of anything that will break (in KVM) if we simply drop the
check, e.g. L1 can already read and write to KVM-internal memslots, so it's not
like the data is sensitive.  The guest is going to have weird behavior, especially
for the APIC access page memslot, but that's more architecturally correct than
injecting a triple fault, e.g. KVM would effectively act like there's a "hidden"
MMIO device at the address.

So I think we should try this:

---
 arch/x86/kvm/mmu/mmu.c   | 19 -------------------
 include/linux/kvm_host.h |  1 -
 virt/kvm/kvm_main.c      | 13 ++-----------
 3 files changed, 2 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 60397a1beda3..e305737edf84 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3671,19 +3671,6 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_free_guest_mode_roots);
 
-
-static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
-{
-	int ret = 0;
-
-	if (!kvm_vcpu_is_visible_gfn(vcpu, root_gfn)) {
-		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
-		ret = 1;
-	}
-
-	return ret;
-}
-
 static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
 			    u8 level)
 {
@@ -3821,9 +3808,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	root_pgd = kvm_mmu_get_guest_pgd(vcpu, mmu);
 	root_gfn = root_pgd >> PAGE_SHIFT;
 
-	if (mmu_check_root(vcpu, root_gfn))
-		return 1;
-
 	/*
 	 * On SVM, reading PDPTRs might access guest memory, which might fault
 	 * and thus might sleep.  Grab the PDPTRs before acquiring mmu_lock.
@@ -3833,9 +3817,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 			pdptrs[i] = mmu->get_pdptr(vcpu, i);
 			if (!(pdptrs[i] & PT_PRESENT_MASK))
 				continue;
-
-			if (mmu_check_root(vcpu, pdptrs[i] >> PAGE_SHIFT))
-				return 1;
 		}
 	}
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d90331f16db1..4645c205a4d1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1234,7 +1234,6 @@ int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
-bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
 void mark_page_dirty_in_slot(struct kvm *kvm, const struct kvm_memory_slot *memslot, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 66c1447d3c7f..61ab6e367397 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1720,9 +1720,8 @@ static void kvm_invalidate_memslot(struct kvm *kvm,
 
 	/*
 	 * From this point no new shadow pages pointing to a deleted, or moved,
-	 * memslot will be created.  Validation of sp->gfn happens in:
-	 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
-	 *	- kvm_is_visible_gfn (mmu_check_root)
+	 * memslot will be created.  Arch MMUs must zap all relevant mappings,
+	 * and must not follow the address of an INVALID memslots.
 	 */
 	kvm_arch_flush_shadow_memslot(kvm, old);
 	kvm_arch_guest_memory_reclaimed(kvm);
@@ -2345,14 +2344,6 @@ bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_is_visible_gfn);
 
-bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
-{
-	struct kvm_memory_slot *memslot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-
-	return kvm_is_visible_memslot(memslot);
-}
-EXPORT_SYMBOL_GPL(kvm_vcpu_is_visible_gfn);
-
 unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	struct vm_area_struct *vma;

base-commit: 88bb466c9dec4f70d682cf38c685324e7b1b3d60
-- 

