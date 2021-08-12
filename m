Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209543EA12F
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 10:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235560AbhHLJAK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 05:00:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235559AbhHLJAJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 05:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BD9160C3F;
        Thu, 12 Aug 2021 08:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628758784;
        bh=srKEXFb7B5Re+3iiWpHXQAcqGzm51k++58eDNACsfIU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iCW5MwZkpLmx7akle39s9ZWQqz9phsrE8gL8DMrSjyYtmlkEzgfFbv2QE0G7KFEWI
         HEMFqcJhUy8HiXsDHb8G+MiEHwAnS4kBpkRxi+WbL6PFIl4V4qfrJbYudoeeSASvE9
         gW+BqHIlUl3/+oJ6jWOeuAQg/0+Ww8EjnEWr+uQFp7MXIwZfbzbcks4O8ADmxN3ny3
         DIZLEyXAPnyuJGSXJprvCuh8mDFkFDj/wSQhcTC1yw4SPMk8wmHd1Bavm6TI2z0A02
         efS8zw2r4MEp3lRYwMIaRz7k5rufqLygdKrafkG+sf9GMeSyXwrkkni2kF3GGJVcGT
         6nn8dL051zK6g==
Date:   Thu, 12 Aug 2021 09:59:39 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: Re: [PATCH v3 08/15] KVM: arm64: Add feature register flag
 definitions
Message-ID: <20210812085939.GF5912@willie-the-truck>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-9-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719160346.609914-9-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 19, 2021 at 05:03:39PM +0100, Fuad Tabba wrote:
> Add feature register flag definitions to clarify which features
> might be supported.
> 
> Consolidate the various ID_AA64PFR0_ELx flags for all ELs.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/cpufeature.h |  4 ++--
>  arch/arm64/include/asm/sysreg.h     | 12 ++++++++----
>  arch/arm64/kernel/cpufeature.c      |  8 ++++----
>  3 files changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 9bb9d11750d7..b7d9bb17908d 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -602,14 +602,14 @@ static inline bool id_aa64pfr0_32bit_el1(u64 pfr0)
>  {
>  	u32 val = cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_EL1_SHIFT);
>  
> -	return val == ID_AA64PFR0_EL1_32BIT_64BIT;
> +	return val == ID_AA64PFR0_ELx_32BIT_64BIT;
>  }
>  
>  static inline bool id_aa64pfr0_32bit_el0(u64 pfr0)
>  {
>  	u32 val = cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_EL0_SHIFT);
>  
> -	return val == ID_AA64PFR0_EL0_32BIT_64BIT;
> +	return val == ID_AA64PFR0_ELx_32BIT_64BIT;
>  }
>  
>  static inline bool id_aa64pfr0_sve(u64 pfr0)
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 326f49e7bd42..0b773037251c 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -784,14 +784,13 @@
>  #define ID_AA64PFR0_AMU			0x1
>  #define ID_AA64PFR0_SVE			0x1
>  #define ID_AA64PFR0_RAS_V1		0x1
> +#define ID_AA64PFR0_RAS_ANY		0xf

This doesn't correspond to an architectural definition afaict: the manual
says that any values other than 0, 1 or 2 are "reserved" so we should avoid
defining our own definitions here.

Will
