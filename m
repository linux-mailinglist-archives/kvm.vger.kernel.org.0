Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF86A1F9461
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 12:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbgFOKMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 06:12:38 -0400
Received: from foss.arm.com ([217.140.110.172]:44262 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728368AbgFOKMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 06:12:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 008481F1;
        Mon, 15 Jun 2020 03:12:38 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.7.221])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0EC203F71F;
        Mon, 15 Jun 2020 03:12:36 -0700 (PDT)
Date:   Mon, 15 Jun 2020 11:12:34 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kernel-team@android.com
Subject: Re: [PATCH 2/4] KVM: arm64: Allow ARM64_PTR_AUTH when ARM64_VHE=n
Message-ID: <20200615101234.GB773@C02TD0UTHF1T.local>
References: <20200615081954.6233-1-maz@kernel.org>
 <20200615081954.6233-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615081954.6233-3-maz@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 15, 2020 at 09:19:52AM +0100, Marc Zyngier wrote:
> We currently prevent PtrAuth from even being built if KVM is selected,
> but VHE isn't. It is a bit of a pointless restriction, since we also
> check this at run time (rejecting the enabling of PtrAuth for the
> vcpu if we're not running with VHE).
> 
> Just drop this apparently useless restriction.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

I can't recall exactly why we had this limitation to begin with, but
given we now save/restore the keys in common hyp code, I don't see a
reason to forbid this, and agree the limitation is pointless, so:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/Kconfig | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 31380da53689..d719ea9c596d 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1516,7 +1516,6 @@ menu "ARMv8.3 architectural features"
>  config ARM64_PTR_AUTH
>  	bool "Enable support for pointer authentication"
>  	default y
> -	depends on !KVM || ARM64_VHE
>  	depends on (CC_HAS_SIGN_RETURN_ADDRESS || CC_HAS_BRANCH_PROT_PAC_RET) && AS_HAS_PAC
>  	# GCC 9.1 and later inserts a .note.gnu.property section note for PAC
>  	# which is only understood by binutils starting with version 2.33.1.
> @@ -1543,8 +1542,7 @@ config ARM64_PTR_AUTH
>  
>  	  The feature is detected at runtime. If the feature is not present in
>  	  hardware it will not be advertised to userspace/KVM guest nor will it
> -	  be enabled. However, KVM guest also require VHE mode and hence
> -	  CONFIG_ARM64_VHE=y option to use this feature.
> +	  be enabled.
>  
>  	  If the feature is present on the boot CPU but not on a late CPU, then
>  	  the late CPU will be parked. Also, if the boot CPU does not have
> -- 
> 2.27.0
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
