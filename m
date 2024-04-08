Return-Path: <kvm+bounces-13838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7941489B71D
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 07:20:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1ABD91F21F4F
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 05:20:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FC4D79D2;
	Mon,  8 Apr 2024 05:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="NtwXaEjq"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A126FC5;
	Mon,  8 Apr 2024 05:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712553616; cv=none; b=LcVT068aulW9SGSLyRkW/bG/biyHuA69fRyxSjAYssfueE73DE1cUlxcnrJrhRydxv5+z/XHjBrx+JtmmiEc92tbLsg4D8KqOD3WKqN5MeXz9YCfJdAbzcOu2aBXYNnuXFD1QfoK++r671WHy7WlxZfz1vlnNtoiMe0wfPc9ZYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712553616; c=relaxed/simple;
	bh=9LJuWuOpABTv9KgvHhQORrnmPBq13CalFtT6NDkHYyM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=UO663ziMhu/7QwY0wSabdyR0zK+DiDDlntDHuGgoHkSyPtz2qM6xAtxei5X7uMD1VqNXxuhLViT1uBMUAoLIKS7MpjhWKJ77H8BLKY0ul2NI1rKwmzDpV6J3hJVw6+VdKW2bnlXunYH93A/i/q3qoRTEKbN/p8fG/laaB2gVnUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=NtwXaEjq; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1712553612;
	bh=XZu26WoVj+aYiP2HgRzxMGfR6mT0EhwCcY1NLc0eUAI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=NtwXaEjqDnzFWsb+68xwuVHgjWc8ce+M8o1K/NSpjV0/oHq/uhFonP/RqANt0LSZ+
	 CuUt5MniSq6tM1ytEtlx5S6twMM/2+tjnQJSLhJfrJ0dvlkBRJCznN5ukPiOpVeTf6
	 IMsULyM2pdA+EvT500NoWRT01y/0oUsOsjqPltol8pAMS+JeT7mGykB+er9ATz30Fu
	 YD/jvCbeLTDZfBd3kmG+piRw1lIyteeFq+lAKQF2UwNC8DKShMbiF46v/OLuF++nt1
	 gnF49PuVw8b1dyJLf+PEBkd4pSxzDkghJ1UjzocPyOZqCUyxufHbpOUklWxfVtLRHF
	 gd5UfzxksZ2JA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4VCcqJ0WXPz4wcR;
	Mon,  8 Apr 2024 15:20:11 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Thorsten Leemhuis <regressions@leemhuis.info>, Nicholas Piggin
 <npiggin@gmail.com>, Vaibhav Jain <vaibhav@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 kvm-ppc@vger.kernel.org
Cc: Jordan Niethe <jniethe5@gmail.com>, Vaidyanathan Srinivasan
 <svaidy@linux.vnet.ibm.com>, mikey@neuling.org, paulus@ozlabs.org,
 sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.vnet.ibm.com,
 amachhiw@linux.vnet.ibm.com, David.Laight@ACULAB.COM, Linux kernel
 regressions list <regressions@lists.linux.dev>
Subject: Re: [PATCH] KVM: PPC: Book3S HV nestedv2: Cancel pending HDEC
 exception
In-Reply-To: <cb038940-63fd-4348-bed2-13e1b2844b92@leemhuis.info>
References: <20240313072625.76804-1-vaibhav@linux.ibm.com>
 <CZYME80BW9P7.3SC4GLHWCDQ9K@wheely>
 <a4f022e8-1f84-4bbb-b00d-00f1eba1f877@leemhuis.info>
 <87sf007ax6.fsf@mail.lhotse>
 <cb038940-63fd-4348-bed2-13e1b2844b92@leemhuis.info>
Date: Mon, 08 Apr 2024 15:20:11 +1000
Message-ID: <87y19obfck.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Thorsten Leemhuis <regressions@leemhuis.info> writes:
> On 05.04.24 05:20, Michael Ellerman wrote:
>> "Linux regression tracking (Thorsten Leemhuis)"
>> <regressions@leemhuis.info> writes:
>>> Hi, Thorsten here, the Linux kernel's regression tracker. Top-posting
>>> for once, to make this easily accessible to everyone.
>>>
>>> Was this regression ever resolved? Doesn't look like it, but maybe I
>>> just missed something.
>> 
>> I'm not sure how it ended up on the regression list.
>
> That is easy to explain: I let lei search for mails containing words
> like regress, bisect, and revert to become aware of regressions that
> might need tracking. And...
>
>> IMHO it's not really a regression.
>
> ...sometimes I misjudge or misinterpret something and add it to the
> regression tracking. Looks like that happened here.
>
> Sorry for that and the noise it caused!

No worries.

cheers

