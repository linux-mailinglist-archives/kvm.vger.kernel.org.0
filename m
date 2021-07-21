Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3DA3D142C
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 18:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbhGUPqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 11:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235143AbhGUPqm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 11:46:42 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C23C061575
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 09:27:18 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id p36so2578551pfw.11
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 09:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EOyMsqYYxFEJg5167GekGU1nLM6DMcAQaXLUu9iRJuk=;
        b=U8/ZhQ1GBVmiGpxovBk+Jo6oNPpXh4tyTGDvHPNbic392KiTgOBe1xqPWOWjzi2VSC
         iKvU8GS/EqgUjbHTuERAqTyRr0nWfR+VQLdWYZNJyrU1XXBRK751Ln9cba089TDYEWcn
         r1BSFWbAUNCQ6CDmDtPJgrjMaMBOuCknBC9gDZUXUIvFXjm+cV40QeI4ZeJgbNSIvBm/
         TFGBpIi1Br4wA0T1+yFEFwk6nE19KNEyPaX7I7Qou0cJEVMYnX3PPjBC3OpGxFdP89cj
         DV/ebacOEYLg2/0dUiT04/4UbW/KtTnLDB2hnLLMGwKuOEykMh+T9Ba150RZnDEwNDPW
         8n4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EOyMsqYYxFEJg5167GekGU1nLM6DMcAQaXLUu9iRJuk=;
        b=nV50uKIXBvIAXahrwCI4fw+SdeI4vHpUzQH37VME6PojGF+20k6B7k5B/8oVUQPZiW
         Z+guD83DevgByilvcLr+3CUZOvqTyUsRoQvTCo6bxkM9c5KN2DHvauyijWxLahNoo5/o
         jkXnRtaA1bktYCeqk8i5kLVx1/TYWPxmt6HH2rItVmSq04kQ5iantlDciYw39w8yymPQ
         btSUgB9QjG7bH2f9RbBXCbDSX5e9WghV8bBNKN533yz8ZGlJ0NK3aSXpFeV6BppiPOGO
         3LHTi2BfwOs62DV1mkhP5NOB7diC+eyOIhTexoMJaPp+pfw6YpDNR417ZwGoF6S6Jfbb
         TIfQ==
X-Gm-Message-State: AOAM531SojUe3tsujKAhAbYe1CVoCXCtECL8ee4YtJe5eynuMmjZHllA
        aQ7I5Q21NHtXCffMIWuFYG8e4A==
X-Google-Smtp-Source: ABdhPJz+a1l6GyEjbeb1OY9yjcDv2L9ziThUACSvWYeZ7yb7v/OXYS3KXN8jSszbmx9yLLwnjtq/yg==
X-Received: by 2002:a62:804b:0:b029:328:db41:1f47 with SMTP id j72-20020a62804b0000b0290328db411f47mr37344114pfd.43.1626884837588;
        Wed, 21 Jul 2021 09:27:17 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 11sm27397005pfl.41.2021.07.21.09.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 09:27:17 -0700 (PDT)
Date:   Wed, 21 Jul 2021 16:27:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 1/2] kvm: mmu/x86: Remove redundant spte present check in
 mmu_set_spte
Message-ID: <YPhK4axwgv7+N5OG@google.com>
References: <20210721051247.355435-1-mizhang@google.com>
 <20210721051247.355435-2-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721051247.355435-2-mizhang@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 20, 2021, Mingwei Zhang wrote:
> Drop an unnecessary is_shadow_present_pte() check when updating the rmaps
> after installing a non-MMIO SPTE.  set_spte() is used only to create
> shadow-present SPTEs, e.g. MMIO SPTEs are handled early on, mmu_set_spte()
> runs with mmu_lock held for write, i.e. the SPTE can't be zapped between
> writing the SPTE and updating the rmaps.
> 
> Opportunistically combine the "new SPTE" logic for large pages and rmaps.

Heh, except you forgot to actually do this in the code.

> No functional change intended.
> 
> Suggested-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b888385d1933..c45ddd2c964f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2693,12 +2693,10 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  	if (!was_rmapped && is_large_pte(*sptep))
>  		++vcpu->kvm->stat.lpages;
>  
> -	if (is_shadow_present_pte(*sptep)) {
> -		if (!was_rmapped) {
> -			rmap_count = rmap_add(vcpu, sptep, gfn);
> -			if (rmap_count > RMAP_RECYCLE_THRESHOLD)
> -				rmap_recycle(vcpu, sptep, gfn);
> -		}
> +	if (!was_rmapped) {

As above, this should be:

	if (!was_rmapped) {
		if (is_large_pte(*sptep))
			++vcpu->kvm->stat.lpages;

> +		rmap_count = rmap_add(vcpu, sptep, gfn);
> +		if (rmap_count > RMAP_RECYCLE_THRESHOLD)
> +			rmap_recycle(vcpu, sptep, gfn);
>  	}
>  
>  	return ret;
> -- 
> 2.32.0.402.g57bb445576-goog
> 
