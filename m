Return-Path: <kvm+bounces-54827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D7D1B28BF2
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 10:40:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A4365C33F6
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 08:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A62923A99E;
	Sat, 16 Aug 2025 08:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Rv6Xhagd"
X-Original-To: kvm@vger.kernel.org
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2454C6E;
	Sat, 16 Aug 2025 08:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755333604; cv=none; b=PIuVEZk3L+bxkkdf2ahXtuVGmAiNwDKSk+6n4pddEMoGRjS3dVOVMEcCbp0fJGsZHclLiEl8MMYOujcMXNLYoE/UEzj9OktH5ZcYeHQfeOMH0R/4PYuNUy2m+ljoCXB6+pWeZcNEmY76ROifLWKSRpKcyPCAo7KvdkcRf6jGgE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755333604; c=relaxed/simple;
	bh=grjeKO0WyHDKzkcbqSLN6TkUzzXcw1wTK8LSPD95smU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H7zNAEkj0wRO36XOrwla1ODPvGTCyADkwMPCNKFr0f7s3/YzCGTWc7yKUVlXch8f6hIkzUmErOUsK0h2inYMAeOT7/xcn2zrPJJcWTjL5/A2ToDj3/wa2mqi/ZuBJpCuulNhkfMfjSuyrT0bjTszjsxg8upROGT23RwuspBzG7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Rv6Xhagd; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Xr1k0ZlltAi3NLyMOyFWqMyiT219XiIYBFFiDHrp6Rw=; b=Rv6Xhagd6gOxPw6plc+VMLFfOt
	5/1Ke4w/ftvYS9S4q9d+1eWBbzsduqe72We9YbJVYLyvoTqIxbi7bVWUBjT4sYORHsoZk6mLczi2u
	GifuuZP0w+yxI8CgtgfFz1+VJymkWWblNdKcb7qpeE4IQdQKsUxiVIQ5+cNNpz2zpZ23GiG91sD5I
	BVIjZilKZpMgeUuiQvhBx74EbyfK9sEkCItMS6PlYSLGSNc1nkjhpL6syBrPzcRlccF/iO0n9E6xP
	UGIjW5Zl89LMWZZ9Nbb+tKi5ZB4tsPVHlKYwn0LoNaG6HBj/fAb5VufsUqQQuwsV+0KnYQpVpG0Af
	ILFlxIFg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1unCCR-00ElsD-2Q;
	Sat, 16 Aug 2025 16:39:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 16 Aug 2025 16:39:36 +0800
Date: Sat, 16 Aug 2025 16:39:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: Neeraj.Upadhyay@amd.com, aik@amd.com, akpm@linux-foundation.org,
	ardb@kernel.org, arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
	dave.hansen@linux.intel.com, davem@davemloft.net, hpa@zytor.com,
	john.allen@amd.com, kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, michael.roth@amd.com,
	mingo@redhat.com, nikunj@amd.com, paulmck@kernel.org,
	pbonzini@redhat.com, rostedt@goodmis.org, seanjc@google.com,
	tglx@linutronix.de, thomas.lendacky@amd.com, x86@kernel.org
Subject: Re: [PATCH v7 0/7] Add SEV-SNP CipherTextHiding feature support
Message-ID: <aKBDyHxaaUYnzwBz@gondor.apana.org.au>
References: <cover.1752869333.git.ashish.kalra@amd.com>
 <20250811203025.25121-1-Ashish.Kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811203025.25121-1-Ashish.Kalra@amd.com>

On Mon, Aug 11, 2025 at 08:30:25PM +0000, Ashish Kalra wrote:
> Hi Herbert, can you please merge patches 1-5.
> 
> Paolo/Sean/Herbert, i don't know how do you want handle cross-tree merging
> for patches 6 & 7.

These patches will be at the base of the cryptodev tree for 6.17
so it could be pulled into another tree without any risks.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

