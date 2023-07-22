Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E283275D874
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 02:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjGVAwc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 20:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjGVAwb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 20:52:31 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC8C26BF;
        Fri, 21 Jul 2023 17:52:29 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1b9c368f4b5so24296985ad.0;
        Fri, 21 Jul 2023 17:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689987149; x=1690591949;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rIlmnhzOg31bqwytQ3fDpCOn4qftSZruBFhap/4V/7U=;
        b=Gk3CS3yQhyw9lzQmNXWtZG8LfBezZQofeuRluJGumxtFM8GG/GK5nIvF0QgPAVijqr
         d3/3IapXL0uOvq/b/MJN00wBOemrrkhYr62/rD8UmHRPvnUpLDNM84omPoA1ITFBe6HN
         3N4eW+CTi07139zmAyZ4jpkFF5YWn4CLf6YUHQ+2LFPC2kQI7q0aU28X4JvCnqzLeFMD
         7su4DQ439lf9TiAFkPrHLKlY2xewkbNVgqgxzMmRYO7JwcJThCxDCfPKVIDfSSHRBIJ+
         ZUaYA2seEr+wF8bvd8DypIDfn7vKRE9gXDOj2TFRCQPIyys4UaWi6nTUhj//wJ1R1KLb
         /drg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689987149; x=1690591949;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rIlmnhzOg31bqwytQ3fDpCOn4qftSZruBFhap/4V/7U=;
        b=capaSSv7NtUocNffuG6BYPN6XkIDW3juCoaUyykJEwQHO1Mm6AxZu1L4TbchYeE9sK
         0Ku34mUBWER4uEGX3AHdinPWbgUxQEr0CPjzNRn5WEnjcfdMIR9eyZJdAXtX2PdFufq6
         zJMnKBGZp9CREWujIhDjb5xsi3+lHTrBEsH80FVXFMA/4JKlMYNjqFSaqdkhH1dxFaoy
         u5UGY3EZrjiBH6aLHhCQ5cD3j13uEF1C55UnjbSbm0TMSbwwzbfjWxcxRqdKusrNWcNM
         qY0QxKa1ksC57LZQUK5kDUk7BQI/BwcAaBEqRBBx41Sbj43IZK4UJCHbWivRqmdOr5pb
         X+WA==
X-Gm-Message-State: ABy/qLY7aEOnmlW3xolxD8nJml90WrLKbmvMgz72/DWuEuCfQoskP3WX
        8YR0ho0ANAgIad7GWvQ42VM=
X-Google-Smtp-Source: APBJJlExc2SsHnyZ4fp5MvAQIVytCE0mfIOvAgJpa0RaqaYWe8oUiTORuW8SJW3+iz+y3ouIqf5USA==
X-Received: by 2002:a17:902:a515:b0:1b9:d38d:efb1 with SMTP id s21-20020a170902a51500b001b9d38defb1mr4092990plq.8.1689987149089;
        Fri, 21 Jul 2023 17:52:29 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id jw20-20020a170903279400b001b8b26fa6a9sm4138036plb.19.2023.07.21.17.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 17:52:28 -0700 (PDT)
Date:   Fri, 21 Jul 2023 17:52:27 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: Re: [RFC PATCH v4 04/10] KVM: x86: Introduce PFERR_GUEST_ENC_MASK to
 indicate fault is private
Message-ID: <20230722005227.GK25699@ls.amr.corp.intel.com>
References: <cover.1689893403.git.isaku.yamahata@intel.com>
 <f474282d701aca7af00e4f7171445abb5e734c6f.1689893403.git.isaku.yamahata@intel.com>
 <ZLqSH/lEbHEnQ9i8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZLqSH/lEbHEnQ9i8@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 21, 2023 at 07:11:43AM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> s/Introduce/Use
> 
> This doesn't "introduce" anything, in the sense that it's an AMD-defined error
> code flag.  That matters because KVM *did* introduce/define PFERR_IMPLICIT_ACCESS.
> 
> On Thu, Jul 20, 2023, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Add two PFERR codes to designate that the page fault is private and that
> > it requires looking up memory attributes.  The vendor kvm page fault
> > handler should set PFERR_GUEST_ENC_MASK bit based on their fault
> > information.  It may or may not use the hardware value directly or
> > parse the hardware value to set the bit.
> > 
> > For KVM_X86_PROTECTED_VM, ask memory attributes for the fault privateness.
> 
> ...
> 
> > +static inline bool kvm_is_fault_private(struct kvm *kvm, gpa_t gpa, u64 error_code)
> > +{
> > +	/*
> > +	 * This is racy with mmu_seq.  If we hit a race, it would result in a
> > +	 * spurious KVM_EXIT_MEMORY_FAULT.
> > +	 */
> > +	if (kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM)
> > +		return kvm_mem_is_private(kvm, gpa_to_gfn(gpa));
> 
> Please synthesize the error code flag for SW-protected VMs, same as TDX, e.g.
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 20e289e872eb..de9e0a9c41e6 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5751,6 +5751,10 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>         if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
>                 return RET_PF_RETRY;
>  
> +       if (vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM &&
> +           kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(cr2_or_gpa)))
> +               error_code |= PFERR_GUEST_ENC_MASK;
> +
>         r = RET_PF_INVALID;
>         if (unlikely(error_code & PFERR_RSVD_MASK)) {
>                 r = handle_mmio_page_fault(vcpu, cr2_or_gpa, direct);
> 
> Functionally it's the same, but I want all VM types to have the same source of
> truth for private versus shared, and I really don't want kvm_is_fault_private()
> to exist.

Here is the updated patch.


From 30c452cd6a94b485eaa5f92dee4c222dd30ebcbe Mon Sep 17 00:00:00 2001
Message-Id: <30c452cd6a94b485eaa5f92dee4c222dd30ebcbe.1689987085.git.isaku.yamahata@intel.com>
In-Reply-To: <ab9d8654bd98ae24de05788a2ecaa4bea6c0c44b.1689987085.git.isaku.yamahata@intel.com>
References: <ab9d8654bd98ae24de05788a2ecaa4bea6c0c44b.1689987085.git.isaku.yamahata@intel.com>
From: Isaku Yamahata <isaku.yamahata@intel.com>
Date: Wed, 14 Jun 2023 12:34:00 -0700
Subject: [PATCH 4/8] KVM: x86: Use PFERR_GUEST_ENC_MASK to indicate fault is
 private

SEV-SNP defines PFERR_GUEST_ENC_MASK (bit 32) in page-fault error bits to
represent the guest page is encrypted.  Use the bit to designate that the
page fault is private and that it requires looking up memory attributes.
The vendor kvm page fault handler should set PFERR_GUEST_ENC_MASK bit based
on their fault information.  It may or may not use the hardware value
directly or parse the hardware value to set the bit.

For KVM_X86_SW_PROTECTED_VM, ask memory attributes for the fault
privateness.  For async page fault, carry the bit and use it for kvm page
fault handler.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
Changes v4 -> v5:
- Eliminate kvm_is_fault_private() by open code the function
- Make async page fault handler to carry is_private bit

Changes v3 -> v4:
- rename back struct kvm_page_fault::private => is_private
- catch up rename: KVM_X86_PROTECTED_VM => KVM_X86_SW_PROTECTED_VM

Changes v2 -> v3:
- Revive PFERR_GUEST_ENC_MASK
- rename struct kvm_page_fault::is_private => private
- Add check KVM_X86_PROTECTED_VM

Changes v1 -> v2:
- Introduced fault type and replaced is_private with fault_type.
- Add kvm_get_fault_type() to encapsulate the difference.
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/mmu/mmu.c          | 32 +++++++++++++++++++++++---------
 arch/x86/kvm/mmu/mmu_internal.h |  2 +-
 3 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c9350aa0da4..a1ae3d881063 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -255,6 +255,7 @@ enum x86_intercept_stage;
 #define PFERR_SGX_BIT 15
 #define PFERR_GUEST_FINAL_BIT 32
 #define PFERR_GUEST_PAGE_BIT 33
+#define PFERR_GUEST_ENC_BIT 34
 #define PFERR_IMPLICIT_ACCESS_BIT 48
 
 #define PFERR_PRESENT_MASK	BIT(PFERR_PRESENT_BIT)
@@ -266,6 +267,7 @@ enum x86_intercept_stage;
 #define PFERR_SGX_MASK		BIT(PFERR_SGX_BIT)
 #define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
 #define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
+#define PFERR_GUEST_ENC_MASK	BIT_ULL(PFERR_GUEST_ENC_BIT)
 #define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
@@ -1770,6 +1772,7 @@ struct kvm_arch_async_pf {
 	gfn_t gfn;
 	unsigned long cr3;
 	bool direct_map;
+	u64 error_code;
 };
 
 extern u32 __read_mostly kvm_nr_uret_msrs;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a2fe091e327a..01e74af48e4c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4285,18 +4285,19 @@ static u32 alloc_apf_token(struct kvm_vcpu *vcpu)
 	return (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
 }
 
-static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-				    gfn_t gfn)
+static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu,
+				    struct kvm_page_fault *fault)
 {
 	struct kvm_arch_async_pf arch;
 
 	arch.token = alloc_apf_token(vcpu);
-	arch.gfn = gfn;
+	arch.gfn = fault->gfn;
 	arch.direct_map = vcpu->arch.mmu->root_role.direct;
 	arch.cr3 = kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
+	arch.error_code = fault->error_code & PFERR_GUEST_ENC_MASK;
 
-	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
-				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
+	return kvm_setup_async_pf(vcpu, fault->addr,
+				  kvm_vcpu_gfn_to_hva(vcpu, fault->gfn), &arch);
 }
 
 void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
@@ -4315,7 +4316,8 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	      work->arch.cr3 != kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu))
 		return;
 
-	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true, NULL);
+	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, work->arch.error_code,
+			      true, NULL);
 }
 
 static inline u8 kvm_max_level_for_order(int order)
@@ -4399,8 +4401,12 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			return RET_PF_EMULATE;
 	}
 
-	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn))
-		return kvm_do_memory_fault_exit(vcpu, fault);
+	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
+		if (vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM)
+			return RET_PF_RETRY;
+		else
+			return kvm_do_memory_fault_exit(vcpu, fault);
+	}
 
 	if (fault->is_private)
 		return kvm_faultin_pfn_private(vcpu, fault);
@@ -4418,7 +4424,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			trace_kvm_async_pf_repeated_fault(fault->addr, fault->gfn);
 			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
 			return RET_PF_RETRY;
-		} else if (kvm_arch_setup_async_pf(vcpu, fault->addr, fault->gfn)) {
+		} else if (kvm_arch_setup_async_pf(vcpu, fault)) {
 			return RET_PF_RETRY;
 		}
 	}
@@ -5836,6 +5842,14 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
 		return RET_PF_RETRY;
 
+	/*
+	 * This is racy with updating memory attributes with mmu_seq.  If we
+	 * hit a race, it would result in retrying page fault.
+	 */
+	if (vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM &&
+	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(cr2_or_gpa)))
+		error_code |= PFERR_GUEST_ENC_MASK;
+
 	r = RET_PF_INVALID;
 	if (unlikely(error_code & PFERR_RSVD_MASK)) {
 		r = handle_mmio_page_fault(vcpu, cr2_or_gpa, direct);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 7f9ec1e5b136..3a423403af01 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -295,13 +295,13 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.user = err & PFERR_USER_MASK,
 		.prefetch = prefetch,
 		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
+		.is_private = err & PFERR_GUEST_ENC_MASK,
 		.nx_huge_page_workaround_enabled =
 			is_nx_huge_page_enabled(vcpu->kvm),
 
 		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
-		.is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
 	};
 	int r;
 
-- 
2.25.1



-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
