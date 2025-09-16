Return-Path: <kvm+bounces-57668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D520B58C7F
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 05:52:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D7EDF1BC1A6A
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 03:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 131BA2857EA;
	Tue, 16 Sep 2025 03:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="earyzcES"
X-Original-To: kvm@vger.kernel.org
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F6E285042;
	Tue, 16 Sep 2025 03:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757994763; cv=none; b=UR0JUUa87kiWl4XlIK7Jf8CaVwsoI8T+N6VW+AeoF2ClFwuVyqiikZW9mqR0JLj1D5XJ8rwHtutwyF+DhU4VoMfNUEqDCq57RQVMFqkZdQIRYNXgMqYEnwkPMa4ysgtK4kkhAeLNi/KB84dWvZM5HlA9Xry8GfN7VwRGn65U2ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757994763; c=relaxed/simple;
	bh=/Q31haFNhMzgKU6vsqp97bRX+yuDFmh0XBAxkXV5Xjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fsa1aM1tV7pA2lg1jeDlB3LeBvKp4wnIN6W58vs+kDqcxG0R+GNzJhe/Wn3vTMdVs3OTQGsOKxtTnuZBNA3WdSziOR1xKx/nDVhL7GJuziegCwHyuNTA5Mg+zuFQX8A1rrA8BEDKhR+CZ9qVkg6v1XjGV3N42SWQSSIC2mD4nGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=earyzcES; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cPs8AC+pY9AbZ6VyY+Zilio8cae40dF7NZxvYJ4FZko=; b=earyzcESf/+qtQ9xJ2SBg2mAsx
	n20xqgRZbCP/k4TIU0eXcRJ4jwTcfA28WZcu8Exay9/gVq+FOGC2WfvuM/may4JH8RHTljMjIxo5B
	wZ/EYzXXglrtJwMVB/vHyS9WdrVFGGlUfvW9UHvVcWGmWmbVkiO430GjTLf82K60txG2LdslbBhJ+
	zNGM+5XZeVqefN527N7YRiBrLap768kfnL6rAQazE46OtGZs3SlG0jjh7pW9Rag3lm0ymDMNPWu+M
	YJ4AoSlk1Le/4wxQFa19JRfn8G7tGZxro9W0WrY51dX3f2c92SYIFSBpug6QwCuHqBVME/ZZehRVP
	UrwDkVMQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uyMTy-005l38-2n;
	Tue, 16 Sep 2025 11:51:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 16 Sep 2025 11:51:51 +0800
Date: Tue, 16 Sep 2025 11:51:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>,
	Ashish Kalra <Ashish.Kalra@amd.com>, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
	nikunj@amd.com, davem@davemloft.net, aik@amd.com, ardb@kernel.org,
	john.allen@amd.com, michael.roth@amd.com, Neeraj.Upadhyay@amd.com,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 1/3] x86/sev: Add new dump_rmp parameter to
 snp_leak_pages() API
Message-ID: <aMje1_nDBX-VWCXZ@gondor.apana.org.au>
References: <cover.1757543774.git.ashish.kalra@amd.com>
 <c6d2fbe31bd9e2638eaefaabe6d0ffc55f5886bd.1757543774.git.ashish.kalra@amd.com>
 <20250912155852.GBaMRDPEhr2hbAXavs@fat_crate.local>
 <aMRnxb68UTzId7zz@google.com>
 <20250913105528.GAaMVNoJ1_Qwq8cfos@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250913105528.GAaMVNoJ1_Qwq8cfos@fat_crate.local>

On Sat, Sep 13, 2025 at 12:55:28PM +0200, Borislav Petkov wrote:
>
> Right, I guess Tom's on that one...
> 
> As to the other two:
> 
> https://lore.kernel.org/r/e7807012187bdda8d76ab408b87f15631461993d.1757543774.git.ashish.kalra@amd.com
> https://lore.kernel.org/r/7be1accd4c0968fe04d6efe6ebb0185d77bed129.1757543774.git.ashish.kalra@amd.com
> 
> Herbert, how do you want to proceed here?
> 
> Do you want me to give you an immutable branch with the first patch and you
> can base the other two ontop or should I carry all three through tip?
> 
> Yeah, it is time for patch tetris again... :-P

Hi Boris:

You can take those two patches directly with my ack:

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

