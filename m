Return-Path: <kvm+bounces-33918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 275A29F49A0
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 12:11:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F34331888021
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 11:11:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E15411EC01C;
	Tue, 17 Dec 2024 11:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="b3QdsmPn"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DE31E282D;
	Tue, 17 Dec 2024 11:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734433857; cv=none; b=HfMN7x9QZ0cR5PYKxQVK427dt1eycQmJ7nJkh2+tJRIGF6gIbJTc9jE2a+g2i0Rdt85RLzsbc+ii9KxrH45x3GSNz3RjE3sU2zrCLEt+jagvB0JMhl/GMleQ5jgV6rEZFmyWRxYuZ6J51R8RKvzZzXQzpelkjPiBYoLAeA1CHNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734433857; c=relaxed/simple;
	bh=UFU9TrebHQPXzbRwZnK2H/+Y72d5JAdA+lEDvRrucXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iOD17trcdeApcPgeFA3x45ZL1h6h2YaqF5pKCwLz/NdqNff1qltCLS1FFiLGJHzQ7WVhbp/iP/DCb9i0BuJpiY9n8gs8KYmw4PYiLZ+5u3TAFEK7GUZZeErvj0HNsbcQrdCUdIUVZ22dsq6ITiV+WYmQg7dBhxMMp9cGniJqc60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=b3QdsmPn; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4DFE640E0289;
	Tue, 17 Dec 2024 11:10:52 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Nmu7S-YvuCz4; Tue, 17 Dec 2024 11:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1734433849; bh=rqxXmKaUJy6MlD2NUlFN1IfjWVJblNFVMMt3ayJPekU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b3QdsmPnzJBLzgHrqvmK/hJb+8rdYTxYGzu6l0nwHq7KJhhm/quXI3tQG9ExA+ZNp
	 g+Uq6REIrC2/rDVwBTev9Sub+iovYd+A4i3tu2dW0G0cSgMof0sUq0AHaXgD6GAGCu
	 LUFYWwAUI9NTtYgg1al0x2G0gK77s5D1A91zSxjob6zyP1u/1mjccjZJEjg7Wt2yaX
	 vTdkkowPKlwqzSrdoJ2eMo4M/4cbx8vHCK0ErT7lf8/z5f/nMze0EG+VR18VTh8GQY
	 3zJcp8lAudYBbVp9Ly/Rtn2AktdyoyUpC+QkHA3XZrQSqjrABsE8OqyXgLam00vHvg
	 0VVEJHBwTBmentawV7o2/bywWTft2D5m6hJW4y+8ZSZLossBwEORCgFO/0wkVll3ck
	 JVMjyewDvkZQokgoJ7zmzWnBRSLSINP3Vvm7u4Ok45sL5h6HQ3FUEZ77Kj9J2jz1fI
	 OdlX03jiSPlPNPrclXi8o39ELWWpC5V9GiJTqtueZGH3yy7cbzTqoFXgB+E2QvJ9kl
	 jLbR46owJ4No14L2ui7rFCdDJX5m4aKMdNCYfgTxp9OrAJy4yJf7ujPLo2CLnymlNU
	 um9c6h1VTs57V6tr2iQkPOAYeWHA3+II5o/CT7S0YjfMboO7+PhL4aeiND4orVzDA2
	 G3M3N7QcbnIetD+ZE6QyfvK0=
Received: from zn.tnic (p200300ea971f937D329C23FfFEa6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:937d:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2DEE840E0277;
	Tue, 17 Dec 2024 11:10:38 +0000 (UTC)
Date: Tue, 17 Dec 2024 12:10:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 08/13] x86/cpu/amd: Do not print FW_BUG for Secure TSC
Message-ID: <20241217111032.GCZ2FcKI9ANjz3Xb4h@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-9-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241203090045.942078-9-nikunj@amd.com>

On Tue, Dec 03, 2024 at 02:30:40PM +0530, Nikunj A Dadhania wrote:
> When Secure TSC is enabled and TscInvariant (bit 8) in CPUID_8000_0007_edx
> is set, the kernel complains with the below firmware bug:
> 
> [Firmware Bug]: TSC doesn't count with P0 frequency!

This happens in a normal guest too:

[    0.000000] [Firmware Bug]: TSC doesn't count with P0 frequency!
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
...
[    0.000000] DMI: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 2023.11-8 02/21/2024
...

If anything, this should check X86_FEATURE_HYPERVISOR but this is just a silly
warning so you don't really need to do anything about it.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

