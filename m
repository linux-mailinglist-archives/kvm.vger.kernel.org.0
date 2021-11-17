Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77AE3454A5D
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 16:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238803AbhKQP7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 10:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhKQP7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 10:59:04 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0910C061764
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 07:56:05 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so2950655pjb.5
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 07:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m9J3GBVAIZFZGi0XXHxUVPqugO9FTJB0JnBQ/K1xQms=;
        b=n3Yg+RFlsYoNf+IeW9+Y0IS9Y85tdUMEvNnklLZ20twSkUzFZl1K+t6UAVXra2Ss8m
         NZrC9cx5JXcgJbQapuIDznZSvV2yUvKZXTxuQPVq7yG5lpBGATWRHP/Y5iuRcKDAhfOa
         ONhGF8KxqB5xro2PENWRZdxgrBFWOWVzbG/X8a/2+KbrfuQVX3b9U9sMnjy9g7lY3nxf
         S7u1CteYISimNVvuz/s6zp1slTFfbcIScmqmuI0r21o/iKytnH+E8R3koNj9fD8IJJvB
         hBsbsU9ulAGltRlvUGjBCpKjWWHlMapjuohePs9hgLKvBtl75klzDMZR97Q/mC2k3m+R
         Lyug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m9J3GBVAIZFZGi0XXHxUVPqugO9FTJB0JnBQ/K1xQms=;
        b=McRU8YA5F+1ZNTtJZdG533bdk1kRIecrUdTOeGJuZ/R1RCvEF7mF1evnDrs8jW8uWN
         VPujbNGVqiF8CxYkT+nlViNTLCP4DRRVhpE6PQHyGW+0XYuF8RNuGlVEE2TKenXrG8TZ
         EhpEjItEGJZP3ng1d+/24v3WVRt7JUY2Y60X8DLtuXsTOMCJGLLsODL6VNq/cP24uUeZ
         nZ4qF1pqhHLXT6sLhgabNcszksh0HHEY4dpBBBRvsX5rV6H/e0kT93SPxdS5ildxN9P4
         BUnK1BIeCPbD2EPgii14EBWs4bw0YMTD53VnuBfhib62pK+unsWpNqPd6RXr5kNDdaLi
         3k2A==
X-Gm-Message-State: AOAM532SMx+wG6ZDccsFON7P418xkOZ2egpPTXl3gMtuDq5mVM/ot2ee
        1ZhXhZFX7XBDDFx8B0j2q5+YqActYUyCvw==
X-Google-Smtp-Source: ABdhPJz2X15ilt4+tq6jfQ6bUTy4rzYV43+NVsGdegDpvtMFGx0QZwaLWYvTs00OhvCoTunsg8+1dw==
X-Received: by 2002:a17:90a:384d:: with SMTP id l13mr848984pjf.104.1637164564540;
        Wed, 17 Nov 2021 07:56:04 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t40sm107973pfg.107.2021.11.17.07.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 07:56:03 -0800 (PST)
Date:   Wed, 17 Nov 2021 15:56:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong93@linux.alibaba.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Skip tlb flush if it has been done in
 zap_gfn_range()
Message-ID: <YZUmEHx6iE9Mr3Ls@google.com>
References: <5e16546e228877a4d974f8c0e448a93d52c7a5a9.1637140154.git.houwenlong93@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e16546e228877a4d974f8c0e448a93d52c7a5a9.1637140154.git.houwenlong93@linux.alibaba.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 17, 2021, Hou Wenlong wrote:
> If the parameter flush is set, zap_gfn_range() would flush remote tlb
> when yield, then tlb flush is not needed outside. So use the return
> value of zap_gfn_range() directly instead of OR on it in
> kvm_unmap_gfn_range() and kvm_tdp_mmu_unmap_gfn_range().
> 
> Fixes: 3039bcc744980 ("KVM: Move x86's MMU notifier memslot walkers to generic code")
> Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
> ---

Ha, I fixed this in my local repo just yesterday :-)

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  arch/x86/kvm/mmu/mmu.c     | 2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 354d2ca92df4..d57319e596a9 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1582,7 +1582,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>  		flush = kvm_handle_gfn_range(kvm, range, kvm_unmap_rmapp);
>  
>  	if (is_tdp_mmu_enabled(kvm))
> -		flush |= kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
> +		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
>  
>  	return flush;
>  }
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7c5dd83e52de..9d03f5b127dc 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1034,8 +1034,8 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
>  	struct kvm_mmu_page *root;
>  
>  	for_each_tdp_mmu_root(kvm, root, range->slot->as_id)

Another issue is that this should be for_each_tdp_mmu_root_yield_safe().  I'll get
a patch out for that later today.

> -		flush |= zap_gfn_range(kvm, root, range->start, range->end,
> -				       range->may_block, flush, false);
> +		flush = zap_gfn_range(kvm, root, range->start, range->end,
> +				      range->may_block, flush, false);
>  
>  	return flush;
>  }
> -- 
> 2.31.1
> 
