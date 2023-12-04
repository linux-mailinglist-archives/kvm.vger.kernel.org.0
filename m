Return-Path: <kvm+bounces-3359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F0DE4803758
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 15:45:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 823E7B20C48
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 14:45:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63DD828E10;
	Mon,  4 Dec 2023 14:45:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 45654210A
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 06:45:01 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35010152B;
	Mon,  4 Dec 2023 06:45:48 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.44.129])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 00DFF3F5A1;
	Mon,  4 Dec 2023 06:44:58 -0800 (PST)
Date: Mon, 4 Dec 2023 14:44:56 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 0/3] arm64: Drop support for VPIPT i-cache policy
Message-ID: <ZW3l6Bq7ortEGB8I@FVFF77S0Q05N>
References: <20231204143606.1806432-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204143606.1806432-1-maz@kernel.org>

On Mon, Dec 04, 2023 at 02:36:03PM +0000, Marc Zyngier wrote:
> ARMv8.2 introduced support for VPIPT i-caches, the V standing for
> VMID-tagged. Although this looked like a reasonable idea, no
> implementation has ever made it into the wild.
> 
> Linux has supported this for over 6 years (amusingly, just as the
> architecture was dropping support for AIVIVT i-caches), but we had no
> way to even test it, and it is likely that this code was just
> bit-rotting.
> 
> However, in a recent breakthrough (XML drop 2023-09, tagged as
> d55f5af8e09052abe92a02adf820deea2eaed717), the architecture has
> finally been purged of this option, making VIPT and PIPT the only two
> valid options.
> 
> This really means this code is just dead code. Nobody will ever come
> up with such an implementation, and we can just get rid of it.
> 
> Most of the impact is on KVM, where we drop a few large comment blocks
> (and a bit of code), while the core arch code loses the detection code
> itself.
> 
> * From v2:
>   - Fix reserved naming for RESERVED_AIVIVT
>   - Collected RBs from Anshuman an Zenghui
> 
> Marc Zyngier (3):
>   KVM: arm64: Remove VPIPT I-cache handling
>   arm64: Kill detection of VPIPT i-cache policy
>   arm64: Rename reserved values for CTR_EL0.L1Ip

For the series:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Looking forward, we can/should probably replace __icache_flags with a single
ICACHE_NOALIASING or ICACHE_PIPT cpucap, which'd get rid of a bunch of
duplicated logic and make that more sound in the case of races around cpu
onlining.

Mark.

> 
>  arch/arm64/include/asm/cache.h   |  6 ----
>  arch/arm64/include/asm/kvm_mmu.h |  7 ----
>  arch/arm64/kernel/cpuinfo.c      |  5 ---
>  arch/arm64/kvm/hyp/nvhe/pkvm.c   |  2 +-
>  arch/arm64/kvm/hyp/nvhe/tlb.c    | 61 --------------------------------
>  arch/arm64/kvm/hyp/vhe/tlb.c     | 13 -------
>  arch/arm64/tools/sysreg          |  5 +--
>  7 files changed, 4 insertions(+), 95 deletions(-)
> 
> -- 
> 2.39.2
> 
> 

