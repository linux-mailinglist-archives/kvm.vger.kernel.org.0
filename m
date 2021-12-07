Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA1846C85D
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 00:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242659AbhLGXrX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 18:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242650AbhLGXrW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 18:47:22 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29EFCC061748
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 15:43:52 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id n26so889838pff.3
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 15:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gYp2DzxK1joVr3jiyTurY0/zwc2R2+PwLXfgju6vouA=;
        b=Ae3LF1Klq9HeyREkoOxoL5jPB3p2i/u1/szy0oSm1JardG5YubXcYPlzRmLbou3ERn
         48x+Ff+n0+2pEA0uF2I7gON8OJZzttboBoOsNg63h1din1Q4OOTORuwLsxOExLvtOhjM
         +T//YSQYUOpqfT3C/aKvPMtaTxxGSfNvPKaO0iV312mdQNRDmYft8wHiN3BjCKCI8NVe
         3gIUWGIkvV7bM8YfI6JhA8rJcij/4T4AfvFYQqYndjtWYsb+hCtsBWY+USLLJbOaxlJq
         8Oh1FV4Ro69cirnNM8TLA8UnGTD0G14KLVTA9wXSPXAKuJTFgCM7j4II+vaRjsQYdpWu
         S6Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gYp2DzxK1joVr3jiyTurY0/zwc2R2+PwLXfgju6vouA=;
        b=caU89pAPOd/kHdRqWIDwz4J4x3SA0KbpUAoURf1fCB9ilU1Pk2q6ZyHXpg9BEGD5pE
         oyo8M3ryfxJLTN/dVRIQxnU9IGK+Tbs5V3bDayKAD93eOk1bm2/LLG0ofvSd+HyFd5zl
         MpV6RsdLlhhg4VFZn1reAAmrZgdCGtfroRWEJsSqD0Y3f53CjgjURbUth6/bfCdzAb9K
         hi6sJuh0BF+NMb1vLIEx1mHaHWvxZOQjj7fiUwAuAWySHdNPDqDUqzD6vvz6VCatc/+V
         /FPhZ9YU8+QaFNkE65+DXrOj38echwu1C+2F5DdXwMRNoZTHsLEGzr08FTHoSvvcAs8Q
         SPvQ==
X-Gm-Message-State: AOAM530swpNi0CJPiHWMAnMkTu2Fi955Gzqwn8GiePctrETLk40FaWdU
        FBEbj7T6Lw6w3yevO2CUk1A+aQ==
X-Google-Smtp-Source: ABdhPJxmkkxGmdyO/JpGqq2H28H9dDLraA9Ntf1o//ODVHEaLAifAouREYlZPB7NSPmU0xwN373BvQ==
X-Received: by 2002:a05:6a00:1412:b0:4a7:ec46:29d1 with SMTP id l18-20020a056a00141200b004a7ec4629d1mr2454569pfu.16.1638920631504;
        Tue, 07 Dec 2021 15:43:51 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z22sm906718pfe.108.2021.12.07.15.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 15:43:51 -0800 (PST)
Date:   Tue, 7 Dec 2021 23:43:47 +0000
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
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 16/15] KVM: X86: Update mmu->pdptrs only when it is
 changed
Message-ID: <Ya/xsx1pcB0Pq/Pm@google.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
 <20211111144527.88852-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111144527.88852-1-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 11, 2021, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> It is unchanged in most cases.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>  arch/x86/kvm/x86.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6ca19cac4aff..0176eaa86a35 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -828,10 +828,13 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
>  		}
>  	}
>  
> -	memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
> -	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
> -	/* Ensure the dirty PDPTEs to be loaded. */
> -	kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
> +	kvm_register_mark_available(vcpu, VCPU_EXREG_PDPTR);
> +	if (memcmp(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs))) {
> +		memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
> +		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
> +		/* Ensure the dirty PDPTEs to be loaded. */
> +		kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
> +	}

Can this be unqueued until there's sufficient justification that (a) this is
correct and (b) actually provides a meaningful performance optimization?  There
have been far too many PDPTR caching bugs to make this change without an analysis
of why it's safe, e.g. what guarantees the that PDPTRs in the VMCS are sync'd
with mmu->pdptrs?  I'm not saying they aren't, I just want the changelog to prove
that they are.

The next patch does add a fairly heavy unload of the current root for !TDP, but
that's a bug fix and should be ordered before any optimizations anyways.

>  	vcpu->arch.pdptrs_from_userspace = false;
>  
>  	return 1;
> -- 
> 2.19.1.6.gb485710b
> 
