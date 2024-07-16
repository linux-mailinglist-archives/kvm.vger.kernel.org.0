Return-Path: <kvm+bounces-21676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10F0F931E5E
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 03:17:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41E4E1C221BD
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 01:17:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF476107B3;
	Tue, 16 Jul 2024 01:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="TvweJxsz"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A039DF6C;
	Tue, 16 Jul 2024 01:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721092641; cv=none; b=SYtr3kGVRkppgEqZvFO//1q8S1ECZCojzaBNRRSw53qxVY7YRwlDcWDvC3bxPSp5EbWMppDTHBqInfYmE60mM0Rad1ITElwq1hd8s9QNXiIuX/azmZq4bAhn6wkyY+ZWVKPiD65mD7c1Mow+udm4DWw2WVQfmai9rQbqhlcLGFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721092641; c=relaxed/simple;
	bh=b/brgE1NdkiBFb9cLdPhtBUH3E9/F6sdQb2O5orbzK4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Dg78MutJjHRMGKytTCu46CJAdrAXbViRn1PKLaSAsaDFRT6ZOS4y22xRBdrpfgvVE2rLO211uEEUypNsGnJc1EK+mS68pCLA89E1zSvGkVFACyRJeBhOpmTbEpOlfx2S6Id3hOfsrTL2UhhyxvhAx8kUTANKyFBQlO4gr/FwKig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=TvweJxsz; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1721092635;
	bh=Q1jIChmgdEnBmrz69/fPODiz0wMaK/AiIWdVBtqH+CU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=TvweJxsz0Rv7qrlm26p9wecfCrPSmIizMcVgyDmBMTCwSOKUpDkaTcaJKSi0pROwO
	 N2VuFdU92RUYU/g3o01OUyFuqjsetjHCky4eATZhFv2pB5g3xTx/DXH6QEKUk5/DZq
	 SrLEEOwvK7X1XNyoBWeTf5ORYTDLZTxnKSswjn+xa4UaCNWm3ughdmd/hn5oy9LYTn
	 SoSiKn8B5OW1+7N6KNqZq7ycf7nBbwpgyTsS0qzLkZbr9P+2E2Z7H6d3NGRGi9i9LU
	 /A61Ri2WTMyg574R8o/mUFuDbPC2q7svsQHBOgS3ZjdQEuL0cTV9HgOkLScpyXJDHX
	 UFdhXLauw+0ag==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4WNLlG6P1dz4wcl;
	Tue, 16 Jul 2024 11:17:14 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Gautam Menghani <gautam@linux.ibm.com>, npiggin@gmail.com,
 christophe.leroy@csgroup.eu, naveen.n.rao@linux.ibm.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/powerpc/kvm: Avoid extra checks when emulating
 HFSCR bits
In-Reply-To: <20240626123447.66104-1-gautam@linux.ibm.com>
References: <20240626123447.66104-1-gautam@linux.ibm.com>
Date: Tue, 16 Jul 2024 11:17:13 +1000
Message-ID: <87v816w2xy.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Gautam Menghani <gautam@linux.ibm.com> writes:
> When a KVM guest tries to use a feature disabled by HFSCR, it exits to
> the host for emulation support, and the code checks for all bits which
> are emulated. Avoid checking all the bits by using a switch case.

The patch looks fine, but I don't know what you mean by "avoid checking
all the bits".

The existing code checks 4 cases, the case statement checks the same 4
cases (plus the default case).

There are other cause values (not bits), but the new and old code don't
check them all anyway. (Which is OK because the default return value is
EMULATE_FAIL)

AFAICS it generates almost identical code.

So I think the change log should just say something like "all the FSCR
cause values are exclusive so use a case statement which better
expresses that" ?

Also please try to copy the existing subject style for the KVM code, for
this file it would be "KVM: PPC: Book3S HV: ...". I agree it's verbose,
and wouldn't be my choice, but thats what's always been used so let's
stick to it.

cheers

> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 99c7ce825..a72fd2543 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -1922,14 +1922,22 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
>  
>  		r = EMULATE_FAIL;
>  		if (cpu_has_feature(CPU_FTR_ARCH_300)) {
> -			if (cause == FSCR_MSGP_LG)
> +			switch (cause) {
> +			case FSCR_MSGP_LG:
>  				r = kvmppc_emulate_doorbell_instr(vcpu);
> -			if (cause == FSCR_PM_LG)
> +				break;
> +			case FSCR_PM_LG:
>  				r = kvmppc_pmu_unavailable(vcpu);
> -			if (cause == FSCR_EBB_LG)
> +				break;
> +			case FSCR_EBB_LG:
>  				r = kvmppc_ebb_unavailable(vcpu);
> -			if (cause == FSCR_TM_LG)
> +				break;
> +			case FSCR_TM_LG:
>  				r = kvmppc_tm_unavailable(vcpu);
> +				break;
> +			default:
> +				break;
> +			}
>  		}
>  		if (r == EMULATE_FAIL) {
>  			kvmppc_core_queue_program(vcpu, SRR1_PROGILL |
> -- 
> 2.45.2

