Return-Path: <kvm+bounces-22255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D4AF93C636
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 17:13:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AC511C215DE
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 15:13:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4259D19D880;
	Thu, 25 Jul 2024 15:13:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4EB5FC18
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 15:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721920412; cv=none; b=UTtzcZE1aUnRgfJlEQ1zN4MA9wTxCd5B7G6mkcWY7S7XaNjGc0rvdqWG02EFdKj2mgPjqrKq9i2E7AVI/RmvhTC1/VfVhmEuu7wSzOxzljxCgt3IYHHeFpQPLMjJhERjcsUho6U2aVx2+FiPpQIccBknyZkrpEj7UEJGLQH1+kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721920412; c=relaxed/simple;
	bh=9eoCHet+IopDzEQP32DH0tK9J+v2trZiIbHDcyIR9iA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s4BayWlVKG0wDBfirn0aEpf5ja8qBuJ7+tK8iZQSW24gLduNFryPuupHL7NQNRdKfIzbPiAs8UE6G0mFVcVY/D2P+DbyXoANTj+9a5mrs3a3Nd+ZzWj3rpXZAOgQINk/84wjZ/kEkIvtsbVITaHZk/cMQ7MpOTZ5NcHVU3gazNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FFA01007;
	Thu, 25 Jul 2024 08:13:55 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 62D113F73F;
	Thu, 25 Jul 2024 08:13:28 -0700 (PDT)
Date: Thu, 25 Jul 2024 16:13:25 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 10/12] KVM: arm64: nv: Add SW walker for AT S1 emulation
Message-ID: <ZqJrlcIv2_bWQk2r@raptor>
References: <20240625133508.259829-1-maz@kernel.org>
 <20240708165800.1220065-1-maz@kernel.org>
 <ZqJeLDGJwWEFMKD4@raptor>
 <864j8d35p3.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864j8d35p3.wl-maz@kernel.org>

Hi,

On Thu, Jul 25, 2024 at 03:30:00PM +0100, Marc Zyngier wrote:
> On Thu, 25 Jul 2024 15:16:12 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi Marc,
> > 
> > On Mon, Jul 08, 2024 at 05:57:58PM +0100, Marc Zyngier wrote:
> > > +	if (perm_fail) {
> > > +		struct s1_walk_result tmp;
> > 
> > I was wondering if you would consider initializing 'tmp' to the empty struct
> > here. That makes it consistent with the initialization of 'wr' in the !perm_fail
> > case and I think it will make the code more robust wrt to changes to
> > compute_par_s1() and what fields it accesses.
> 
> I think there is a slightly better way, with something like this:
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index b02d8dbffd209..36fa2801ab4ef 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -803,12 +803,12 @@ static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  	}
>  
>  	if (perm_fail) {
> -		struct s1_walk_result tmp;
> -
> -		tmp.failed = true;
> -		tmp.fst = ESR_ELx_FSC_PERM | wr.level;
> -		tmp.s2 = false;
> -		tmp.ptw = false;
> +		struct s1_walk_result tmp = (struct s1_walk_result){
> +			.failed	= true,
> +			.fst	= ESR_ELx_FSC_PERM | wr.level,
> +			.s2	= false,
> +			.ptw	= false,
> +		};
>  
>  		wr = tmp;
>  	}
> 
> Thoughts?

How about (diff against your kvm-arm64/nv-at-pan-WIP branch, in case something
looks off):

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index b02d8dbffd20..74ebe3223a13 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -802,16 +802,8 @@ static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
                BUG();
        }

-       if (perm_fail) {
-               struct s1_walk_result tmp;
-
-               tmp.failed = true;
-               tmp.fst = ESR_ELx_FSC_PERM | wr.level;
-               tmp.s2 = false;
-               tmp.ptw = false;
-
-               wr = tmp;
-       }
+       if (perm_fail)
+               fail_s1_walk(&wr, ESR_ELx_FSC_PERM | wr.level, false, false);

 compute_par:
        return compute_par_s1(vcpu, &wr);

Thanks,
Alex

