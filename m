Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C290A658ED2
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 17:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbiL2QOM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 11:14:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiL2QOL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 11:14:11 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C31FF0;
        Thu, 29 Dec 2022 08:14:10 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 88E171EC0622;
        Thu, 29 Dec 2022 17:14:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1672330448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=yiv7ygs+SuK0x+dgF6bq6lJbSdbknPxlHUob4CtNI7I=;
        b=U+ywzFGfQlEWXXsPeZVWUBAI3CV4cBV33gK2O0narbJnFvVhbFNhPZQje1x01QqrasMH3V
        MUpdr2/87oWoNpnkAbXLOCYjk2VEkAfyPdEdqPY8XKhnCBbs4HSaN2gv7OMPgCuhiN5TG2
        WroaVxJLLGmzNIcOGkr0TzHey0VNpSQ=
Date:   Thu, 29 Dec 2022 17:14:03 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org,
        ashish.kalra@amd.com, harald@profian.com
Subject: Re: [PATCH RFC v7 04/64] KVM: x86: Add 'fault_is_private' x86 op
Message-ID: <Y628y6hQK38+IAev@zn.tnic>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-5-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221214194056.161492-5-michael.roth@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 01:39:56PM -0600, Michael Roth wrote:
> This callback is used by the KVM MMU to check whether a #NPF was
> or a private GPA or not.

s/or //

> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/mmu/mmu.c             |  3 +--
>  arch/x86/kvm/mmu/mmu_internal.h    | 40 +++++++++++++++++++++++++++---
>  4 files changed, 39 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index f530a550c092..efae987cdce0 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -132,6 +132,7 @@ KVM_X86_OP(complete_emulated_msr)
>  KVM_X86_OP(vcpu_deliver_sipi_vector)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
>  KVM_X86_OP_OPTIONAL_RET0(private_mem_enabled);
> +KVM_X86_OP_OPTIONAL_RET0(fault_is_private);
>  
>  #undef KVM_X86_OP
>  #undef KVM_X86_OP_OPTIONAL
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9317abffbf68..92539708f062 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1636,6 +1636,7 @@ struct kvm_x86_ops {
>  	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>  			     int root_level);
>  	int (*private_mem_enabled)(struct kvm *kvm);
> +	int (*fault_is_private)(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault);

bool

and then you don't need the silly "== 1" at the call site.

>  
>  	bool (*has_wbinvd_exit)(void);

...

> @@ -261,13 +293,13 @@ enum {
>  };
>  
>  static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> -					u32 err, bool prefetch)
> +					u64 err, bool prefetch)

The u32 -> u64 change of err could use a sentence or two of
clarification in the commit message...

>  {
>  	bool is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault);
>  
>  	struct kvm_page_fault fault = {
>  		.addr = cr2_or_gpa,
> -		.error_code = err,
> +		.error_code = lower_32_bits(err),
>  		.exec = err & PFERR_FETCH_MASK,
>  		.write = err & PFERR_WRITE_MASK,
>  		.present = err & PFERR_PRESENT_MASK,
> @@ -281,8 +313,8 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
>  		.req_level = PG_LEVEL_4K,
>  		.goal_level = PG_LEVEL_4K,
> -		.is_private = IS_ENABLED(CONFIG_HAVE_KVM_PRIVATE_MEM_TESTING) && is_tdp &&
> -				kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
> +		.is_private = is_tdp && kvm_mmu_fault_is_private(vcpu->kvm,
> +								 cr2_or_gpa, err),
>  	};
>  	int r;
>  
> -- 
> 2.25.1
> 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
