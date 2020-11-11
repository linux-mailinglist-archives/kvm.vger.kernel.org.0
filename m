Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876732AFD49
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 02:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgKLBbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 20:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727973AbgKKXqL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 18:46:11 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295BDC0613D1;
        Wed, 11 Nov 2020 15:46:11 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id oq3so5119036ejb.7;
        Wed, 11 Nov 2020 15:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3KAP3Nl0z4nLvFD3AoJReAEabMF3qVl2uypc3vIJttw=;
        b=c4NkUVrsn9E3aTeaXZbM0J7Mk69TCF+R/fSMurkCEc3X2Y9z1hbYlWFv0odwy3JX0R
         2MnXZdFkx1H2KlCQOnkWa6hzaXPJYIvjpNTTI9PHYQFI5qnEnSzWJbS3kvRpsv6p5erf
         fLbSvCYNVKZbAHkL0PGT4eFy/7l78YRJkErbAld1aDkfadxk//54ZW/AP1IOjllgeudR
         SkcYijNE+5V+RMh+Q/zrl+DyCN3SJlTpmbFoSKcE//PYeMnDt9zMFC8R3ous+KoUU2vW
         nb+R6f3jmJXtpfDEqQVunhEuXpdn9j9nTE4VB9XicXxA9f4qxZWQSQFxsQkSE6FfxHy4
         +zFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3KAP3Nl0z4nLvFD3AoJReAEabMF3qVl2uypc3vIJttw=;
        b=KC6XOi3mC0V6o3T3eh7MPqs7C4BgJuVHsKRC3ggkzV/uuo+IvTIdjaoGn/FAoTQMT1
         lhU9K2ksN0XUCRsmyMQ9fZ00C278Cvdm0PWenPEosCn8Ofw2Y5y2MwMDHJWco8XdAfCl
         SUH307dzYLn1tbnTFoalP01KGr56BcTe6CQbmyhVWUgAuZNAIMWCOZ1ba3uwXBBV19Jx
         hH9VCrZVTeZGMcsGx1BmIAR7C4E5agw+eKcFai5Bh+CYumDie1bKZBeWwkDnpUZ6vWPk
         wf7jo5YPwq0QXV5o5zhO9rW+Fpczyun2xNWR8VKiqqwoJUs00xakHa1opZGvxCz/6FRp
         VZeA==
X-Gm-Message-State: AOAM531UriWndvFk7mHoxsb4vgY+Tqg2/bySHubHkGsBTre3SpSYO5A9
        sInzx7+V7HcNCfMfVTEH5Hw=
X-Google-Smtp-Source: ABdhPJzfPG9wCJ4mv/E9+Pl7jafxDs6JwoDjkGTK9sYmwz0pPmrG8j9qirZt9TCI9v90zbv5bO5xLg==
X-Received: by 2002:a17:906:519e:: with SMTP id y30mr26828559ejk.186.1605138369835;
        Wed, 11 Nov 2020 15:46:09 -0800 (PST)
Received: from vm1 (ip-86-49-65-192.net.upcbroadband.cz. [86.49.65.192])
        by smtp.gmail.com with ESMTPSA id a1sm1557208edk.52.2020.11.11.15.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 15:46:09 -0800 (PST)
Date:   Thu, 12 Nov 2020 00:46:06 +0100
From:   Zdenek Kaspar <zkaspar82@gmail.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] kvm: x86/mmu: Fix is_tdp_mmu_check when using PAE
Message-ID: <20201112004606.48c339a6.zkaspar82@gmail.com>
In-Reply-To: <20201111185337.1237383-1-bgardon@google.com>
References: <20201111185337.1237383-1-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 11 Nov 2020 10:53:37 -0800
Ben Gardon <bgardon@google.com> wrote:

> When PAE is in use, the root_hpa will not have a shadow page
> assoicated with it. In this case the kernel will crash with a NULL
> pointer dereference. Add checks to ensure is_tdp_mmu_root works as
> intended even when using PAE.
> 
> Tested: compiles
> 
> Fixes: 02c00b3a2f7e ("kvm: x86/mmu: Allocate and free TDP MMU roots")
> Reported-by: Zdenek Kaspar <zkaspar82@gmail.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 27e381c9da6c..13013f4d98ad 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -49,8 +49,18 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
>  {
>  	struct kvm_mmu_page *sp;
>  
> +	if (WARN_ON(!VALID_PAGE(hpa)))
> +		return false;
> +
>  	sp = to_shadow_page(hpa);
>  
> +	/*
> +	 * If this VM is being run with PAE, the TDP MMU will not be
> enabled
> +	 * and the root HPA will not have a shadow page associated
> with it.
> +	 */
> +	if (!sp)
> +		return false;
> +
>  	return sp->tdp_mmu_page && sp->root_count;
>  }
>  

Fixes is_tdp_mmu_root NULL pointer dereference
Tested on: Intel(R) Core(TM)2 CPU 6600 @ 2.40GHz

Tested-by: Zdenek Kaspar <zkaspar82@gmail.com>
