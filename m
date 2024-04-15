Return-Path: <kvm+bounces-14641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC02D8A4F01
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 14:27:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C09F1F21F08
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 12:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF9D16BFA3;
	Mon, 15 Apr 2024 12:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="DTEXAucD"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FED6BFA1;
	Mon, 15 Apr 2024 12:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713184061; cv=none; b=ZZf02hS71KNGpaECLD+pFs2wVglmr7+bEt1R6+INcU0/OlajFcfdgBZD1bp5gBykTwQaHAN9Ba/do4wp9NlItYQWqBS55mE319EIzbE2aPniLtI7VYEG08fjZqzyQai0V0uqCLkuborvConLCO1Tlh2IISH/XHV+8rgj7eHRorE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713184061; c=relaxed/simple;
	bh=R+1oCIb6sUcNrpF2+mQ87x0FA+lUvT43cnt4auGZ/OI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QTv1zvwwDB6pxtMM1v7eoXliNdThEZ/uIQSQDz/KbJaDKCoUsWM1mDMvlU7YpiVwXH2H2Kk+qHcIhx34+stV5y3wyJFbop/xxal6OSHi0Bi/SGHdqKlj3sL9StrMveKZEGzDvPYx1FUTn9Z8NM0WbruSpn/VkSvjSHRDuzZATyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=DTEXAucD; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1713184054;
	bh=Kg0IaaFvkx0vPahWnl4bGsKUwrTtxLTCmAqwqLLNhTg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=DTEXAucDsJ8VGX3CWQW/+zFc9hYesJ1AQoYC/tgDzYYvxzgwWttp7PwmjONSIIknC
	 voyIOgLBNjIKat/sXBpgag8hT7NbXvQ5zdBhhCXTp9ejd8f+3KuYJeGPDLi/dONU8Z
	 FT19bxOAVbxsILJSynJuocMSKUA/4GeE9bGycq3LrCttC7cObYxFS6vcItJZERXO5f
	 wQhPf3T4PcISwrjwyawazbTwIiEpXZrneAENXkD0xQvstWH1tbQLPC2c2hCn2jTvSQ
	 xurQyggaf4ZdWOzQhAucric3Rb8cBh37xdKCtze3QQ10u78cZjw4WKZL4nys0/J1jr
	 G1l/OvnLUYpgA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4VJ5z968qgz4wcb;
	Mon, 15 Apr 2024 22:27:33 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Vaibhav Jain <vaibhav@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>, Nicholas Piggin
 <npiggin@gmail.com>, Jordan Niethe <jniethe5@gmail.com>, Vaidyanathan
 Srinivasan <svaidy@linux.vnet.ibm.com>, mikey@neuling.org,
 paulus@ozlabs.org, sbhat@linux.ibm.com, gautam@linux.ibm.com,
 kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
 David.Laight@ACULAB.COM
Subject: Re: [PATCH v2] KVM: PPC: Book3S HV nestedv2: Cancel pending DEC
 exception
In-Reply-To: <20240415035731.103097-1-vaibhav@linux.ibm.com>
References: <20240415035731.103097-1-vaibhav@linux.ibm.com>
Date: Mon, 15 Apr 2024 22:27:32 +1000
Message-ID: <8734rmdd57.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Vaibhav Jain <vaibhav@linux.ibm.com> writes:
> This reverts commit 180c6b072bf3 ("KVM: PPC: Book3S HV nestedv2: Do not
> cancel pending decrementer exception") [1] which prevented canceling a
> pending HDEC exception for nestedv2 KVM guests. It was done to avoid
> overhead of a H_GUEST_GET_STATE hcall to read the 'DEC expiry TB' register
> which was higher compared to handling extra decrementer exceptions.
>
> However recent benchmarks indicate that overhead of not handling 'DECR'
> expiry for Nested KVM Guest(L2) is higher and results in much larger exits
> to Pseries Host(L1) as indicated by the Unixbench-arithoh bench[2]

Any reason you chose that benchmark? At least on my system it seems to
compile to an infinite loop incrementing a single register.

Presumably the change is still good, but a more well known benchmark
would be good, even if it's just stress-ng, at least that's a bit more
standard.

cheers

> Metric	    	      | Current upstream    | Revert [1]  | Difference %
> ========================================================================
> arithoh-count (10)    |	3244831634	    | 3403089673  | +04.88%
> kvm_hv:kvm_guest_exit |	513558		    | 152441	  | -70.32%
> probe:kvmppc_gsb_recv |	28060		    | 28110	  | +00.18%
>
> N=1
>
> As indicated by the data above that reverting [1] results in substantial
> reduction in number of L2->L1 exits with only slight increase in number of
> H_GUEST_GET_STATE hcalls to read the value of 'DEC expiry TB'. This results
> in an overall ~4% improvement of arithoh[2] throughput.
>
> [1] commit 180c6b072bf3 ("KVM: PPC: Book3S HV nestedv2: Do not cancel pending decrementer exception")
> [2] https://github.com/kdlucas/byte-unixbench/
>
> Fixes: 180c6b072bf3 ("KVM: PPC: Book3S HV nestedv2: Do not cancel pending decrementer exception")
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
>
> ---
> Changelog:
> Since v1: https://lore.kernel.org/all/20240313072625.76804-1-vaibhav@linux.ibm.com
> * Updated/Corrected patch title and description
> * Included data on test benchmark results for Unixbench-arithoh bench.
> ---
>  arch/powerpc/kvm/book3s_hv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 8e86eb577eb8..692a7c6f5fd9 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -4857,7 +4857,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
>  	 * entering a nested guest in which case the decrementer is now owned
>  	 * by L2 and the L1 decrementer is provided in hdec_expires
>  	 */
> -	if (!kvmhv_is_nestedv2() && kvmppc_core_pending_dec(vcpu) &&
> +	if (kvmppc_core_pending_dec(vcpu) &&
>  			((tb < kvmppc_dec_expires_host_tb(vcpu)) ||
>  			 (trap == BOOK3S_INTERRUPT_SYSCALL &&
>  			  kvmppc_get_gpr(vcpu, 3) == H_ENTER_NESTED)))
> -- 
> 2.44.0

