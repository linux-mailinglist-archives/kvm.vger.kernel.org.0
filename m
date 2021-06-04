Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C0539BAAB
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 16:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhFDOLC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 10:11:02 -0400
Received: from foss.arm.com ([217.140.110.172]:39948 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230124AbhFDOLB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 10:11:01 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6678B2B;
        Fri,  4 Jun 2021 07:09:15 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.6.137])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4CE513F774;
        Fri,  4 Jun 2021 07:09:12 -0700 (PDT)
Date:   Fri, 4 Jun 2021 15:09:09 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Brazdil <dbrazdil@google.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] KVM: arm64: Extend comment in has_vhe()
Message-ID: <20210604140909.GB69333@C02TD0UTHF1T.local>
References: <20210603183347.1695-1-will@kernel.org>
 <20210603183347.1695-3-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603183347.1695-3-will@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 03, 2021 at 07:33:45PM +0100, Will Deacon wrote:
> has_vhe() expands to a compile-time constant when evaluated from the VHE
> or nVHE code, alternatively checking a static key when called from
> elsewhere in the kernel. On face value, this looks like a case of
> premature optimization, but in fact this allows symbol references on
> VHE-specific code paths to be dropped from the nVHE object.
> 
> Expand the comment in has_vhe() to make this clearer, hopefully
> discouraging anybody from simplifying the code.
> 
> Cc: David Brazdil <dbrazdil@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/include/asm/virt.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> index 7379f35ae2c6..3218ca17f819 100644
> --- a/arch/arm64/include/asm/virt.h
> +++ b/arch/arm64/include/asm/virt.h
> @@ -111,6 +111,9 @@ static __always_inline bool has_vhe(void)
>  	/*
>  	 * Code only run in VHE/NVHE hyp context can assume VHE is present or
>  	 * absent. Otherwise fall back to caps.
> +	 * This allows the compiler to discard VHE-specific code from the
> +	 * nVHE object, reducing the number of external symbol references
> +	 * needed to link.
>  	 */
>  	if (is_vhe_hyp_code())
>  		return true;
> -- 
> 2.32.0.rc0.204.g9fa02ecfa5-goog
> 
