Return-Path: <kvm+bounces-31986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA0739CFEAB
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 12:48:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F321287C6D
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 11:48:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85BAD191F8F;
	Sat, 16 Nov 2024 11:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="VAmFM6s7"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8993C372;
	Sat, 16 Nov 2024 11:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731757709; cv=none; b=EnGTUKbFpYNokvIftjo46lBD7owv2nOQQ4OHers/mYDsiD/qqjms4KI0k0W7N9rgoxnl92LALaiOZNHreTgYM8QgiOe5KEl7k4BfiVPkpXk1dQLFqnbuSV0HzCnOq76B2bWm7JDzzSDjM65Lj8WxDtSivXnYfCDVgdHTVIBjRfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731757709; c=relaxed/simple;
	bh=vrmQk4tfiwY6BCyc5NGdMV68lsuudl9Qi1eHO5KPf1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hgt1Z8XyLBJp8pfXk2Y2zfnWycl37sq7OPcszEFew2aymdfMZYHt5DH5cbuRdRlLxSIj0lhpoS9dSxKMtVZ5vhTbpX9OD0WLuEZGLkwiwdjH8c8PexW+hOmoQjmZth47uwPOKx9zAJnjuQyNMKSo4vnO5jEyHYgMtCOrpwpTrpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=VAmFM6s7; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E0B2940E0220;
	Sat, 16 Nov 2024 11:48:21 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ANtg24uy7g3q; Sat, 16 Nov 2024 11:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1731757696; bh=rLWhxNFi5nY3pkA2knu5aaYnqE8vCoV2EH6Oqvm0Jug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VAmFM6s7oxPw2ZdKthnrASmZH2nSVq7LvMEYZSJvo2TFGaO6fNNX8ySYv6U2f4xl2
	 6HFtMErSjf3FKX8cGj1L1WXfHnp2eM8nzQEZzm6cJHEwnd86zKtrVyW80pnd2fJpGz
	 KTZ9LWaLgQPmyir/EHk691LMP1HfnKH/pPwqNjc8AZ1RCSMfObPdAAHKTB0Y74gSj+
	 /o9h9HbJXD/F3R7wMaGBl0TBkldETZRafXgRHnlWKoPaksTUVAQl/kXTnLaWUpNqNP
	 o1nL1TQW0c2T4epGXKwf0OPVnuaIFzUcwrQka2BTLx+bmZXP0QJKOqFAsC8JGgG86+
	 KWhbs/9qT2nbQJXnQ0C5FjDSjg0EdUM+5TDOvUt3tnACr4JFIAVMkL7JbsKJybTozN
	 85+PNkAytpvLmGt8ae1X9Rc+877LO6JCO+s9KXm8O4eTP13dgPflmaWbw6N1hosMy/
	 QqqNspNQaw33CVNApX/O4oKOyJs8APzyMAqWkH6pgO7JGus5HKY1rLKxMWCEnOqHgR
	 D5xG7OyFXLsrHsueDQtO2LiGCIuL76vD96LTptRJ2w+2H3o+bRkpfRra/qGjQ4JSw1
	 pktUp4m8zOuQ5S7S6ShBr/063jrgLTywragToTZ1g/NLubIQRHXi+OW5Vi0Cu1Cikj
	 hLqHDX41ouhbtKSmkg+ZhBIk=
Received: from zn.tnic (p200300ea9736a13e329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9736:a13e:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DDA8640E0208;
	Sat, 16 Nov 2024 11:48:03 +0000 (UTC)
Date: Sat, 16 Nov 2024 12:47:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: Maksim Davydov <davydov-max@yandex-team.ru>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
	x86@kernel.org, seanjc@google.com, sandipan.das@amd.com,
	mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	hpa@zytor.com, pbonzini@redhat.com
Subject: Re: [PATCH 0/2] x86: KVM: Add missing AMD features
Message-ID: <20241116114754.GAZziGausNsHqPnr3j@fat_crate.local>
References: <20241113133042.702340-1-davydov-max@yandex-team.ru>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241113133042.702340-1-davydov-max@yandex-team.ru>

On Wed, Nov 13, 2024 at 04:30:40PM +0300, Maksim Davydov wrote:
> This series adds definition of some missing AMD features in
> 0x80000008_EBX and 0x80000021_EAX functions. It also gives an opportunity
> to expose these features to userspace.

Any particular, concrete use for them in luserspace or this is a just-for-fun
exercise?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

