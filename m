Return-Path: <kvm+bounces-13631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 311B58993BB
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 05:20:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0ED01F230C3
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 03:20:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24F761B299;
	Fri,  5 Apr 2024 03:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="oeh6yhkc"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4A8125C9;
	Fri,  5 Apr 2024 03:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712287227; cv=none; b=Rfa4P6edKJVHyudfvzYyxgPqaF6A5MfoqkosA6PnA/ZSFA99aqWGC8Tksk/AIiJ2ypm+US44zp6P1ETHnM1oJMDWq3MAubxvHeOhWIfzU1LRBMneOIxpEzOPV3kL1cO9XSCsMcOaD5FvVAGhHSyAs48CG9wnfyHfDJJgua/ziLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712287227; c=relaxed/simple;
	bh=iMlwtCluKgt/yru1GplRV6mXGvO5sai8Pz5HQ2wsUcA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=n/pnH9XKZQX8cxOpKI9gKHd2f3RvXYJGFP/rMF3PSq5mcojo6kz+3rF6aCcLdHIoKtmuLRvTtwJ8+0LFKqCN8gfqJgvQwuMyrrEJVIalV3mm6bS9Jc5KKj+yQftSBP3ywymweUQuaS4aleJYQAgOkECWWkc1ggjqBNeCJYzFhGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=oeh6yhkc; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1712287223;
	bh=BzOgV/+Na+A/Ref7N5qSUr8kt2YEgbL91XAVdwt4w18=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=oeh6yhkcpwXKcHmtw6MAbTvlbPXAM/96yJA9sgFi/cSRHxSZU1GOlWjCnNuO+71da
	 aybge/mqP0XmlGCOOBryClA3ybY8Er/3bGlwL9tGjZdh7kAb5qOgmrRs0+9n9uTAAi
	 YHv4pRrhlDmNffTfyCMT0mnEIrCiRpN8MZTQh1ne5zYsvqdu4cHnDcigpAp2Pohx0G
	 K8h0V+AV1fl5Q9OengudjNlIoReVGlTBuSTpYEliUABPpiaz9smSu2g6mr4ffKgEMA
	 5cZbPzKAqmR5pYQmPHQ9NMeEaZMm8I4HcBjzjsslCO7/TkUK/cqj2DGYS7cZDAw17g
	 H+bTqfOwcS4dg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4V9kJQ1GQNz4wcb;
	Fri,  5 Apr 2024 14:20:21 +1100 (AEDT)
From: Michael Ellerman <mpe@ellerman.id.au>
To: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>, Nicholas Piggin <npiggin@gmail.com>, Vaibhav
 Jain <vaibhav@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Cc: Jordan Niethe <jniethe5@gmail.com>, Vaidyanathan Srinivasan
 <svaidy@linux.vnet.ibm.com>, mikey@neuling.org, paulus@ozlabs.org,
 sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.vnet.ibm.com,
 amachhiw@linux.vnet.ibm.com, David.Laight@ACULAB.COM, Linux kernel
 regressions list <regressions@lists.linux.dev>
Subject: Re: [PATCH] KVM: PPC: Book3S HV nestedv2: Cancel pending HDEC
 exception
In-Reply-To: <a4f022e8-1f84-4bbb-b00d-00f1eba1f877@leemhuis.info>
References: <20240313072625.76804-1-vaibhav@linux.ibm.com>
 <CZYME80BW9P7.3SC4GLHWCDQ9K@wheely>
 <a4f022e8-1f84-4bbb-b00d-00f1eba1f877@leemhuis.info>
Date: Fri, 05 Apr 2024 14:20:21 +1100
Message-ID: <87sf007ax6.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

"Linux regression tracking (Thorsten Leemhuis)"
<regressions@leemhuis.info> writes:
> Hi, Thorsten here, the Linux kernel's regression tracker. Top-posting
> for once, to make this easily accessible to everyone.
>
> Was this regression ever resolved? Doesn't look like it, but maybe I
> just missed something.

I'm not sure how it ended up on the regression list. IMHO it's not
really a regression. It was an attempt at a performance optimisation,
which is no longer needed due to changes in (unreleased) firmware.

I haven't merged it because Nick's reply contained several questions for
Vaibhav, so I'm expecting either a reply to those or a new version of
the patch.

cheers

> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> --
> Everything you wanna know about Linux kernel regression tracking:
> https://linux-regtracking.leemhuis.info/about/#tldr
> If I did something stupid, please tell me, as explained on that page.
>
> #regzbot poke
>
> On 20.03.24 14:43, Nicholas Piggin wrote:
>> On Wed Mar 13, 2024 at 5:26 PM AEST, Vaibhav Jain wrote:
>>> This reverts commit 180c6b072bf360b686e53d893d8dcf7dbbaec6bb ("KVM: PPC:
>>> Book3S HV nestedv2: Do not cancel pending decrementer exception") which
>>> prevented cancelling a pending HDEC exception for nestedv2 KVM guests. It
>>> was done to avoid overhead of a H_GUEST_GET_STATE hcall to read the 'HDEC
>>> expiry TB' register which was higher compared to handling extra decrementer
>>> exceptions.
>>>
>>> This overhead of reading 'HDEC expiry TB' register has been mitigated
>>> recently by the L0 hypervisor(PowerVM) by putting the value of this
>>> register in L2 guest-state output buffer on trap to L1. From there the
>>> value of this register is cached, made available in kvmhv_run_single_vcpu()
>>> to compare it against host(L1) timebase and cancel the pending hypervisor
>>> decrementer exception if needed.
>> 
>> Ah, I figured out the problem here. Guest entry never clears the
>> queued dec, because it's level triggered on the DEC MSB so it
>> doesn't go away when it's delivered. So upstream code is indeed
>> buggy and I think I take the blame for suggesting this nestedv2
>> workaround.
>> 
>> I actually don't think that is necessary though, we could treat it
>> like other interrupts.  I think that would solve the problem without
>> having to test dec here.
>> 
>> I am wondering though, what workload slows down that this patch
>> was needed in the first place. We'd only get here after a cede
>> returns, then we'd dequeue the dec and stop having to GET_STATE
>> it here.
>> 
>> Thanks,
>> Nick
>> 
>>>
>>> Fixes: 180c6b072bf3 ("KVM: PPC: Book3S HV nestedv2: Do not cancel pending decrementer exception")
>>> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
>>> ---
>>>  arch/powerpc/kvm/book3s_hv.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>>> index 0b921704da45..e47b954ce266 100644
>>> --- a/arch/powerpc/kvm/book3s_hv.c
>>> +++ b/arch/powerpc/kvm/book3s_hv.c
>>> @@ -4856,7 +4856,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
>>>  	 * entering a nested guest in which case the decrementer is now owned
>>>  	 * by L2 and the L1 decrementer is provided in hdec_expires
>>>  	 */
>>> -	if (!kvmhv_is_nestedv2() && kvmppc_core_pending_dec(vcpu) &&
>>> +	if (kvmppc_core_pending_dec(vcpu) &&
>>>  			((tb < kvmppc_dec_expires_host_tb(vcpu)) ||
>>>  			 (trap == BOOK3S_INTERRUPT_SYSCALL &&
>>>  			  kvmppc_get_gpr(vcpu, 3) == H_ENTER_NESTED)))
>> 

