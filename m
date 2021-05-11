Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD9837AC1F
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 18:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhEKQkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 12:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbhEKQkP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 12:40:15 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4113C06174A
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 09:39:08 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id b15so4918375plh.10
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 09:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bFTI8zSDkjnfRrp4pddqJA+R4m+BpZrkydiUQ78vx4o=;
        b=QxHK/U0NucnlckkDp56+qA8LXDSaLwYN9N/AmXKnYeJtggPd6Ss4Fc4HNnL/IZnB4a
         2mj8dJG3L0mHCiN/A+4AuQFO9eOPKGqwadY/aG4HbrzYwwydFuT6Xgm6tAx5sxNCorUb
         4jyTmBibzbzfJUaMr/2ITrYoA+LLiN5v0E/ApruvOPoyhMh8ywMwLUSaOayKc/XfcBkn
         /EBOGnCih42xrwcqbFF/qevQKG5s2mIT+xIyJ8NQZGxmtxhaUpSuuNLCAxiXXGby4Tuu
         BSlLQ7xgILtJM8SXiT4AJSOe+0z7CkqCZFgw6BYydxENIs6HYPpR0G0t4I6fXymsDJXw
         OKSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bFTI8zSDkjnfRrp4pddqJA+R4m+BpZrkydiUQ78vx4o=;
        b=A/Qyq0F4sFuItvlA4t1lIHeOIkMF/tNR8NJ0XPAtAvYFuCtBzTetg0PD+O0sGDFRcV
         Fu3PRg7E5DStonotllLEgc4oZZxfzXRFKNedm6MRbaHRcsBFMz/9Wy53F6OJPnDIygSY
         j6unZY48wD1EX90ay/6B0uX/TW0hkWooFH+TJL5jE0svqs6W/Y+sVyf7zRRm8qx7qTkQ
         N/fbHVa6aACvVjfVrztpqzqM9ydYZ5PJpWLht3WNEELFF2PNJqkoswaPFa9x6b6P6HDU
         jGosquWgS2NDWe+dn7hNJPpuTkh6OJAbr+eCMHrpRTwIurfJD+c/22qggJ3irKDgJh+I
         Qnng==
X-Gm-Message-State: AOAM530tzpD4Spqf6V3Jqfw/1TdMAcdT0I+tM+ZuDR6h2G0dHGAenNrY
        s4bTAzHos2l3JmpomEmLtDB3yw==
X-Google-Smtp-Source: ABdhPJyks2yUVlb+ScMYVY2rHW7w8eOFF30A6QmRs3zSCswJQ6IcK20YYudgV1jFoTUmwDdevc3REA==
X-Received: by 2002:a17:90a:d90c:: with SMTP id c12mr6230691pjv.129.1620751148273;
        Tue, 11 May 2021 09:39:08 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id x4sm14249272pfr.160.2021.05.11.09.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 09:39:07 -0700 (PDT)
Date:   Tue, 11 May 2021 16:39:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     linuxppc-dev@lists.ozlabs.org, npiggin@gmail.com,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix kvm_unmap_gfn_range_hv() for
 Hash MMU
Message-ID: <YJqzJyBvU0A8VG9p@google.com>
References: <20210511105459.800788-1-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511105459.800788-1-mpe@ellerman.id.au>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021, Michael Ellerman wrote:
> Commit 32b48bf8514c ("KVM: PPC: Book3S HV: Fix conversion to gfn-based
> MMU notifier callbacks") fixed kvm_unmap_gfn_range_hv() by adding a for
> loop over each gfn in the range.
> 
> But for the Hash MMU it repeatedly calls kvm_unmap_rmapp() with the
> first gfn of the range, rather than iterating through the range.
> 
> This exhibits as strange guest behaviour, sometimes crashing in firmare,
> or booting and then guest userspace crashing unexpectedly.
> 
> Fix it by passing the iterator, gfn, to kvm_unmap_rmapp().
> 
> Fixes: 32b48bf8514c ("KVM: PPC: Book3S HV: Fix conversion to gfn-based MMU notifier callbacks")
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> ---
>  arch/powerpc/kvm/book3s_64_mmu_hv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> I plan to take this via the powerpc fixes branch.

FWIW,

Reviewed-by: Sean Christopherson <seanjc@google.com>

> 
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> index 2d9193cd73be..c63e263312a4 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> @@ -840,7 +840,7 @@ bool kvm_unmap_gfn_range_hv(struct kvm *kvm, struct kvm_gfn_range *range)
>  			kvm_unmap_radix(kvm, range->slot, gfn);
>  	} else {
>  		for (gfn = range->start; gfn < range->end; gfn++)
> -			kvm_unmap_rmapp(kvm, range->slot, range->start);
> +			kvm_unmap_rmapp(kvm, range->slot, gfn);
>  	}
>  
>  	return false;
> -- 
> 2.25.1
> 
