Return-Path: <kvm+bounces-32412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 826A89D8323
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 11:13:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24F8D16116B
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 10:12:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A0C2192B8A;
	Mon, 25 Nov 2024 10:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="jFCaEao7"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54BA19258A;
	Mon, 25 Nov 2024 10:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732529345; cv=none; b=C7BlhhOXq3+lmNsNrr7CYWnWkCbKsPtH6Yw0A4abhcjWsMyDiDiEZnMGCtcTwrwpclzA4CyV/UreZ6LS7vrWhjaa22Fi/Bg3NbE6euAOAp1OEgw4478ufz/7ZGWI9wIts3LPbxjlpaRheAK+7VDhdjj7GooQ02lWtjCGZq8p8vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732529345; c=relaxed/simple;
	bh=ZIS73Mx6UjIAG31Psalpe/cWH3qYnjiGVyJl/s0EtTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KBS63TkKRa1BOYZM1CTYMQNqC4jhvjXVZX6hz7RRDeuz8eME/ZAiHQxBO3d5/GwFoiracfPjxpcx1P2bSRJiKZXn3WMCE253BYNyzYMnhuu8wXwMRaO+nVIyQLdYCfYzeKDvjESCpkRXAI57etT5X7UBrHOGY8+tK/uRbqBbFlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=jFCaEao7; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E8B5840E0277;
	Mon, 25 Nov 2024 10:08:52 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Vv16YESf4Nj5; Mon, 25 Nov 2024 10:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1732529324; bh=swx+sN4yyK6qRuPJqti+5uQ+Reh1AMYW/1q6NKOIa28=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jFCaEao7YySG/Bj1PgD2a2s8ozmteM5WSJOPFXkyALTDYAW4N+WWyKVnGvuRp/r7S
	 IM2DHOu+knnLOVufGsKMHFO0lmIcSEPiHFvLka3KniQeuHGtY1NOPCXC1k8y/t9FIE
	 6RfpiDKNbD/x8sIKAcfsOz3X4I0nTP2dHZA2+K5ZrXGbF4bp5oCRbh87GjF4mS1zQZ
	 k8xhzTx5/oAvRBZp101H8//OyxZaJ0w9mZeCjsiEtpSeVJfYL6WP4mnSkLSIYBSth8
	 aUiqcxRdBWN+7ys6pciKe4rJ5voAWK7Oi7GKY07o6fLqN/u7lGRQSQ2ZgL6nMCPGJV
	 tnGoHUMHg/swgTi8Sgavx/+zKZ85bbUw8mk7JsmOSJ5t18mM90OHR3Xm0vhbum/onR
	 YbI0uzskv+Hq/MJ4cLW5YzMJ9JP9e+KCWIIU4NUyqzrzuJkZxp7UpwtvIUJhfVWKRx
	 dbKH25NiAWjbBVgcOj+Mbwi/8nlYY5l8AyAo+rs/A2LLYRklEroiWzprtsX3n9waXn
	 B+vbXmLuzDnSGB/egC7o6BbeETvBtDt5FWcDh79eD1G/cdf1lWqlt+3sg8RBQ1Ze/Y
	 eI6+wK+twj3eaophhrHTSTm1uytMd3/vD9qmSVKG9QdzGO4nXsJURvJ7Vwlwk5Mg2e
	 gUjleA79aDxeGdBlS8T03sOI=
Received: from zn.tnic (p200300ea9736a192329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9736:a192:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6341140E0269;
	Mon, 25 Nov 2024 10:08:26 +0000 (UTC)
Date: Mon, 25 Nov 2024 11:08:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: "Melody (Huibo) Wang" <huibo.wang@amd.com>,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
Message-ID: <20241125100805.GAZ0RMhbjUAKad3p8A@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
 <6f6c1a11-40bd-48dc-8e11-4a1f67eaa43b@amd.com>
 <4f0769a6-ef77-46f8-ba78-38d82995aa26@amd.com>
 <20241121054116.GAZz7H_Cub_ziNiBQN@fat_crate.local>
 <6b2d9a59-cfca-4d6c-915b-ca36826ce96b@amd.com>
 <20241121105344.GBZz8ROFlE8Qx2JuLB@fat_crate.local>
 <0042e7cf-764b-4ab9-9c66-0d020fe173e2@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0042e7cf-764b-4ab9-9c66-0d020fe173e2@amd.com>

On Mon, Nov 25, 2024 at 12:51:36PM +0530, Neeraj Upadhyay wrote:
> I see most of that flow required. By removing dependency on CONFIG_X86_X2APIC 
> and enabling SAVIC, I see below boot issues:

Ok, then please extend the Kconfig help text so that it explicitly calls out
the fact that the CONFIG_X86_X2APIC dependency is not only build but
functional one too and that SAVIC relies on X2APIC machinery being present in
the guest.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

