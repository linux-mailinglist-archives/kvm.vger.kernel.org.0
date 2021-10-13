Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A8042C828
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 19:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238230AbhJMR7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 13:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbhJMR7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 13:59:30 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984F3C061749
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 10:57:25 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id q5so3068262pgr.7
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 10:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nYRMF9NLZlIYvCMUzNz88c0C/LYzcmp0YC6IScl8K1M=;
        b=NgG+UbKFXQEeJU+vxIERcV8ISM8vK2GCSApZ6LVvO8Ca4vuob2erFTer8Pjy+LmOlx
         oQNqfc4GDoSc8kBYl2UQuoJCdCPDunS7oChSW89ZvBC0D5H5CPPmiL+ueA8J+Mm8lR4T
         hJJlty1d2LjuoUIDYuT/iG0qDt97u16L7UQrJg/LobgP9fw0Bk0K06xWDbzC+nFmvUR9
         e05rVnnoZXh6SEoemSALmKQmezFDLIf1O9MDVP1nYpxigjBeIyWXGs/Fr4gJGcrY3APT
         lQZGOxPee5B/4281bZcijDSsReBobfryrTBKyzHczFPs3pwj76Rw2G3+tM++U5ijVdOF
         hMgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nYRMF9NLZlIYvCMUzNz88c0C/LYzcmp0YC6IScl8K1M=;
        b=0zyQ2vq3aakYKGCMBDhMu8UMC14Sqf7Fb3NXHqIQ12fpC/ODjhJgH8us/lXdeH0k6o
         MYlUYzgr9X3RQxbrHwHLHJPZDyaByMjU4GBnMIG65axw2DYb+l5s0lHipSKo049zCLNp
         0cszQpb+4L32GJ+tabYh0i4FmsQQUbvc/1fJfwRmMYisBDdeQLkKgcEUtu59Poxxa3i0
         gKJCWA5Q+Jc7ObywNsfkgko/6Exfin2vdDhoV6Y8JBcA/yRzwZgtmuEDM71HG1WENJOO
         5GTt+Rok7n0QJ4NNh84X5wX1N0O7k+V5Bv+fIOVtF8O3so5bCC+iLZMLlkgzWQkovAV2
         A90Q==
X-Gm-Message-State: AOAM530yDyLheS3lS9TgkTzzSKwZikPToRqSvM2HGPFnxHHNZr8Dev3x
        6rYIlsN411ynF41EjuKxixO4zQ==
X-Google-Smtp-Source: ABdhPJyMiVGmUTYUtcdh7bcTvHq4WhqYjQCakcIXj/dCcEixSLcina/nmF5U4pACwtO5b1z16bv7/Q==
X-Received: by 2002:a05:6a00:1344:b0:44c:4cd7:4d4b with SMTP id k4-20020a056a00134400b0044c4cd74d4bmr795524pfu.50.1634147844761;
        Wed, 13 Oct 2021 10:57:24 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z24sm180698pgu.54.2021.10.13.10.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 10:57:24 -0700 (PDT)
Date:   Wed, 13 Oct 2021 17:57:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 41/45] KVM: SVM: Add support to handle the RMP
 nested page fault
Message-ID: <YWceAL4v+zcJFrhU@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-42-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-42-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021, Brijesh Singh wrote:
> When SEV-SNP is enabled in the guest, the hardware places restrictions on
> all memory accesses based on the contents of the RMP table. When hardware
> encounters RMP check failure caused by the guest memory access it raises
> the #NPF. The error code contains additional information on the access
> type. See the APM volume 2 for additional information.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 76 ++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c | 14 +++++---
>  arch/x86/kvm/svm/svm.h |  1 +
>  3 files changed, 87 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 65b578463271..712e8907bc39 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3651,3 +3651,79 @@ void sev_post_unmap_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int token)
>  
>  	srcu_read_unlock(&sev->psc_srcu, token);
>  }
> +
> +void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
> +{
> +	int rmp_level, npt_level, rc, assigned;

Really silly nit: can you use 'r' or 'ret' instead of 'rc'?  Outside of the
emulator, which should never be the gold standard for code ;-), 'rc' isn't used
in x86 KVM.

> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3784d389247b..3ba62f21b113 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1933,15 +1933,21 @@ static int pf_interception(struct kvm_vcpu *vcpu)
>  static int npf_interception(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> +	int rc;
>  
>  	u64 fault_address = svm->vmcb->control.exit_info_2;
>  	u64 error_code = svm->vmcb->control.exit_info_1;
>  
>  	trace_kvm_page_fault(fault_address, error_code);
> -	return kvm_mmu_page_fault(vcpu, fault_address, error_code,
> -			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
> -			svm->vmcb->control.insn_bytes : NULL,
> -			svm->vmcb->control.insn_len);
> +	rc = kvm_mmu_page_fault(vcpu, fault_address, error_code,
> +				static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
> +				svm->vmcb->control.insn_bytes : NULL,
> +				svm->vmcb->control.insn_len);
> +
> +	if (error_code & PFERR_GUEST_RMP_MASK)

Don't think it will matter in the end, but shouldn't this consult 'rc' before
diving into RMP handling?

> +		handle_rmp_page_fault(vcpu, fault_address, error_code);

Similar to my comments on the PSC patches, I think this is backwards.  The MMU
should provide the control logic to convert between private and shared, and vendor
code should only get involved when there are side effects from the conversion.

Once I've made a dent in my review backlog, I'll fiddle with this and some of the
other MMU interactions, and hopefully come up with a workable sketch for the MMU
stuff.  Yell at me if you haven't gotten an update by Wednesday or so.
