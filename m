Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966543B9279
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 15:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbhGANvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 09:51:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232241AbhGANvA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 09:51:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27F8A61420;
        Thu,  1 Jul 2021 13:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625147309;
        bh=xq5lgInObWsa70Xiu5Iswt0q2HU0wkkrlQXuVnMsCo4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ni1obni1R2bCfhKrCikDMlNHSVodaAc8ARaPmYETdp5Zl7ssxEgxXjZz100rN0RGt
         LrI2nbs/WlmdHqVvzTVJsU0bh652wq9lqj3DJgUEozyfcS289SzxXnKk1P915HooOE
         +YdIpUg8W0evBQWvjQpsBInL334396gv70OP3t+8XN8kGzz8jXW7k4cKDse1f1Sn52
         pV6ebuMtHttt0ENkQ3UvwM799w302Uex4kgEYxne99sB3eKoJUcljPGeL4Kj8iE/xL
         S2ppHWa4hHvlwRDma85SQ4b1DmOemJHVje85dHZgaJFA+AERqwEcZBDhWYoeeeu/fL
         P1s6ObOE7OJKg==
Date:   Thu, 1 Jul 2021 14:48:23 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: Re: [PATCH v2 08/13] KVM: arm64: Guest exit handlers for nVHE hyp
Message-ID: <20210701134823.GH9757@willie-the-truck>
References: <20210615133950.693489-1-tabba@google.com>
 <20210615133950.693489-9-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615133950.693489-9-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 02:39:45PM +0100, Fuad Tabba wrote:
> Add an array of pointers to handlers for various trap reasons in
> nVHE code.
> 
> The current code selects how to fixup a guest on exit based on a
> series of if/else statements. Future patches will also require
> different handling for guest exists. Create an array of handlers
> to consolidate them.
> 
> No functional change intended as the array isn't populated yet.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 19 ++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/switch.c        | 35 +++++++++++++++++++++++++
>  2 files changed, 54 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index e4a2f295a394..f5d3d1da0aec 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -405,6 +405,18 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> +typedef int (*exit_handle_fn)(struct kvm_vcpu *);
> +
> +exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu);
> +
> +static exit_handle_fn kvm_get_hyp_exit_handler(struct kvm_vcpu *vcpu)
> +{
> +	if (is_nvhe_hyp_code())
> +		return kvm_get_nvhe_exit_handler(vcpu);
> +	else
> +		return NULL;
> +}

nit: might be a bit tidier with a ternary if (?:).

But either way:

Acked-by: Will Deacon <will@kernel.org>

Will
