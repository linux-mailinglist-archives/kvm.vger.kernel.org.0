Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0F346C88D
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 01:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242770AbhLHATV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 19:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242765AbhLHATU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 19:19:20 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC452C061746
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 16:15:49 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id g18so932492pfk.5
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 16:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dpbhMmude6TrSYy/W/IEKSbLw/ojh/ZM0booTmlaN5A=;
        b=QntzNtUmLjQqBF5CnhPBS0aMcGJVADvyHOc7Oc7VegMHHK6TtMy3zmgpSgjg3EYldn
         UTjX1BloCLnw/WUp3ffsg/0cln0Q2vlubERNGXlAM2DTv2tfNB6tETq0pZtCAjLqKmX5
         E9zEjtWCZQmGBBKRnGWhl/uLxCrKiPHJEvnBqt2rADKvbV/17KkUkZ5pG9DwGS/vFJ+T
         MiJxVs0IijjWvKYpfrSeECF7t3DzOF1k9B5H1mA87/P+rB7TIlFeYLy4mrF1txY6RVx5
         tBGuEKxbYXfG55x1xcP8UDzk+2N4lcz3aW18M+b0m70wsoAtWvycp4UxOm/d6WKoAGMZ
         AXFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dpbhMmude6TrSYy/W/IEKSbLw/ojh/ZM0booTmlaN5A=;
        b=pe8KHMdxbKwfjiLrBJe9X6KZhXGYPE57ax434b0MHpcfgRGzAbZqBD6vUvfcERvywV
         TvPRxIXyNEXezM5q6QXwIu7kVRayRZbswOk7nznTzqmyveNk1AcYoOn5UBNQ1mwkbRHB
         DkGpSs2fVcuy0KTpSY2vGvltzxq9pAUHkbetMPNBu+rmuSzekLEFAvSnTHv7WB48sOfr
         bKTu6nUoZFYheNawJzgnnl0cOd6/GsUW+YD+v12Ae7f56QJ1BGphF1+Yj6pfs7CW3l9K
         XNp81Ne2vKhenNtMMwG0prU5t8BvVyIXjedu/2NmgicVc9vW5V3R35b4jPbTjvFWKHP5
         oTHg==
X-Gm-Message-State: AOAM531XT8+NB1LNEhCpxcnItYxJvqqLkNKRUG53F2ag1aZh826mjKqT
        i29cuszBofPzF7ythQfW+Gn8mg==
X-Google-Smtp-Source: ABdhPJz8g/C9Oy5ixea0NmmtbiYfcCVCfeC70Of/0im+WsJI/9oJVYSctgXFGZA7dTlO4PBfYRCyXA==
X-Received: by 2002:aa7:99cf:0:b0:49f:9d3c:ac0f with SMTP id v15-20020aa799cf000000b0049f9d3cac0fmr2536854pfi.39.1638922548800;
        Tue, 07 Dec 2021 16:15:48 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u3sm975156pfk.32.2021.12.07.16.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 16:15:48 -0800 (PST)
Date:   Wed, 8 Dec 2021 00:15:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Xiao Guangrong <guangrong.xiao@linux.intel.com>
Subject: Re: [PATCH 17/15] KVM: X86: Ensure pae_root to be reconstructed for
 shadow paging if the guest PDPTEs is changed
Message-ID: <Ya/5MOYef4L4UUAb@google.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
 <20211111144634.88972-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111144634.88972-1-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 11, 2021, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> For shadow paging, the pae_root needs to be reconstructed before the
> coming VMENTER if the guest PDPTEs is changed.
> 
> But not all paths that call load_pdptrs() will cause the pae_root to be
> reconstructed. Normally, kvm_mmu_reset_context() and kvm_mmu_free_roots()
> are used to launch later reconstruction.
> 
> The commit d81135a57aa6("KVM: x86: do not reset mmu if CR0.CD and
> CR0.NW are changed") skips kvm_mmu_reset_context() after load_pdptrs()
> when changing CR0.CD and CR0.NW.
> 
> The commit 21823fbda552("KVM: x86: Invalidate all PGDs for the current
> PCID on MOV CR3 w/ flush") skips kvm_mmu_free_roots() after
> load_pdptrs() when rewriting the CR3 with the same value.

This isn't accurate, prior to that commit KVM wasn't guaranteed to do
kvm_mmu_free_roots() if it got a hit on the current CR3 or if a previous CR3 in
the cache matched the new CR3 (the "cache" has done some odd things in the past).

So I think this particular flavor would be:

  Fixes: 7c390d350f8b ("kvm: x86: Add fast CR3 switch code path")

> The commit a91a7c709600("KVM: X86: Don't reset mmu context when
> toggling X86_CR4_PGE") skips kvm_mmu_reset_context() after
> load_pdptrs() when changing CR4.PGE.
> 
> Normally, the guest doesn't change the PDPTEs before doing only the
> above operation without touching other bits that can force pae_root to
> be reconstructed.  Guests like linux would keep the PDPTEs unchaged
> for every instance of pagetable.
> 
> Fixes: d81135a57aa6("KVM: x86: do not reset mmu if CR0.CD and CR0.NW are changed")
> Fixes: 21823fbda552("KVM: x86: Invalidate all PGDs for the current PCID on MOV CR3 w/ flush")
> Fixes: a91a7c709600("KVM: X86: Don't reset mmu context when toggling X86_CR4_PGE")
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>  arch/x86/kvm/x86.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0176eaa86a35..cfba337e46ab 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -832,8 +832,14 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
>  	if (memcmp(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs))) {
>  		memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
>  		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
> -		/* Ensure the dirty PDPTEs to be loaded. */
> -		kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
> +		/*
> +		 * Ensure the dirty PDPTEs to be loaded for VMX with EPT
> +		 * enabled or pae_root to be reconstructed for shadow paging.
> +		 */
> +		if (tdp_enabled)
> +			kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
> +		else
> +			kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, KVM_MMU_ROOT_CURRENT);

Shouldn't matter since it's legacy shadow paging, but @mmu should be used instead
of vcpu->arch.mmuvcpu->arch.mmu.

To avoid a dependency on the previous patch, I think it makes sense to have this be:

	if (!tdp_enabled && memcmp(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs)))
		kvm_mmu_free_roots(vcpu, mmu, KVM_MMU_ROOT_CURRENT);

before the memcpy().

Then we can decide independently if skipping the KVM_REQ_LOAD_MMU_PGD if the
PDPTRs are unchanged with respect to the MMU is safe.
