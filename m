Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9AA481FEB
	for <lists+kvm@lfdr.de>; Thu, 30 Dec 2021 20:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240511AbhL3TbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Dec 2021 14:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237012AbhL3TbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Dec 2021 14:31:00 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1310C061574
        for <kvm@vger.kernel.org>; Thu, 30 Dec 2021 11:31:00 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o63-20020a17090a0a4500b001b1c2db8145so28776260pjo.5
        for <kvm@vger.kernel.org>; Thu, 30 Dec 2021 11:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FYXvglbGqKa6MDTBbtApQcpspIcGTQNntrmktbwch7M=;
        b=q+u3LGjWTXF+/UkU1WEUFXFDVgUnuMGd98HfbtIuFtaohdCzdt1lUbN5XmbY/5A0Pc
         WkRa2/FXd9RP0uvpVenO/q7UTfL3MvHmp68TxNYmX5Atjg7huB0qoxS5800TvmF9hSVW
         MwnYHcWP5TdHI/YuNnMDpFJre/nJor6vhNEolXtYcWFd6zItCBwlOkZ4IOk4eydXyIJr
         jZ6R4cWla/pN3Fy8kjX/bxMwmotBloLDhJnjpNoys5aLPq/kXc5XYv3AeY6QH2IEUzGt
         k7oDX0VR+ABhKp3CynFnyI8H1hVvLh9uM+P/IujXOn6FqcxljG7ZnnXju7UJKLUUcrUk
         NyKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FYXvglbGqKa6MDTBbtApQcpspIcGTQNntrmktbwch7M=;
        b=Fx4wECzO0i/az1Y99x7ts68K73BRikjqbRlY1CYZiwWcWKUVjsK5rcfoe+7Je8l9lC
         YdXuI6/YpWmMQEskM73+kQ/j1ZxlxbGHFb7DiPUkEngWOPlbR3js8GkQTAvlyxiFHTFx
         QKIVW0oKCjJuxl42vcgqHnHaVGPiDECumbl7foJXFzbfzmEIHwyNtAdH9zWcNRH7ymD6
         QGmJ48ppEZe0kQeVDz0rV0UP+KMRoQA5y/YnnU4TvY7BhR7pbsxu0gW07gRVp64W0GNu
         IaOzba/2iHfUfTmSh/es86oNUQ+KIVCXuc7Je9hljRZaqc3Rk9+fpPdD63AdXdrIs+JC
         DAMw==
X-Gm-Message-State: AOAM531NtB/007WqFUI9fW0jRAg4+KeJLvKni+2tEI3MUjIDqbDLZ9lp
        AjUsw8e38OOKulhlRYPGK5SzJQ==
X-Google-Smtp-Source: ABdhPJyYaGGC1njX1Al9c7/uvjjSt874CgyQ2TX9yQVKQldZnTwzxV1a5jQ+vjYlCk1TOSPZQNh8HA==
X-Received: by 2002:a17:90b:20b:: with SMTP id fy11mr39658469pjb.238.1640892659992;
        Thu, 30 Dec 2021 11:30:59 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e9sm23554274pgp.39.2021.12.30.11.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 11:30:59 -0800 (PST)
Date:   Thu, 30 Dec 2021 19:30:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 2/4] KVM: x86/mmu: use gfn_to_pfn_page
Message-ID: <Yc4I8DNgQjomsfrc@google.com>
References: <20211129034317.2964790-1-stevensd@google.com>
 <20211129034317.2964790-3-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129034317.2964790-3-stevensd@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> Covert usages of the deprecated gfn_to_pfn functions to the new
> gfn_to_pfn_page functions.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  arch/x86/kvm/mmu.h             |  1 +
>  arch/x86/kvm/mmu/mmu.c         | 18 +++++++++++-------
>  arch/x86/kvm/mmu/paging_tmpl.h |  9 ++++++---
>  arch/x86/kvm/x86.c             |  6 ++++--
>  4 files changed, 22 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 9ae6168d381e..97d94a9612b6 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -164,6 +164,7 @@ struct kvm_page_fault {
>  	/* Outputs of kvm_faultin_pfn.  */
>  	kvm_pfn_t pfn;
>  	hva_t hva;
> +	struct page *page;
>  	bool map_writable;
>  };
>  
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 04c00c34517e..0626395ff1d9 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2891,6 +2891,9 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	if (unlikely(fault->max_level == PG_LEVEL_4K))
>  		return;
>  
> +	if (!fault->page)
> +		return;
> +
>  	if (is_error_noslot_pfn(fault->pfn) || kvm_is_reserved_pfn(fault->pfn))

These two checks can go away as they're made obsolete by the new !fault->page check.

>  		return;
>  
