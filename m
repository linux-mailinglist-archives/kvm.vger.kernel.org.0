Return-Path: <kvm+bounces-20404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A55914EEA
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 15:40:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 480201C222E1
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 13:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1646013DBAD;
	Mon, 24 Jun 2024 13:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="YyJ6y8P4"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AB21304B1;
	Mon, 24 Jun 2024 13:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719236423; cv=none; b=Swi5masMuGT+Jn63Y2qb/G6KFToPNfOyDNwOCXQWxfsqwMeObpepPCAZkQ6/7dvT1cZ2maCFOYzYyTw8P6hNXCR0KxEi63qjGzXz3FBm3LbJAK1HYg5s8IOz+WcuErWx0Es6aZpOo1uwFdoWhcIC607gTuZHJIV3cOHzzqDSm74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719236423; c=relaxed/simple;
	bh=QlUS0flNbGykCRDMaqIl/gMmF2gpEyepyq30ZlxzbOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f9E4/hHl9l8E1rYjJg4tbbBBxLOSdHDOgocfKBhKdbzR7pln3C041HQNWMP2B3xcFi8cdIyXruUlZiamXWL6jP9l8w3A4ZAEdYuLqaYqMpnGLxgJrSfQLrCNOmp8V62IFjdFzDtSFNgkXNtJuuekS69G6ytzOeZ/3o+LLGPOCW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=YyJ6y8P4; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 033FD40E021B;
	Mon, 24 Jun 2024 13:40:12 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id m41nE2rJuYAB; Mon, 24 Jun 2024 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1719236408; bh=bzkNWbiqZkc7oSP5W7yoRLsijH5YBc/k3XimXqLbYc4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YyJ6y8P4t0U9F26jE8Wqr4LhEGHMxF6Rm7ouXhDy/WmJ2CyRcB9dUEV9ynqAJhgOu
	 EBToZTXeu2evncJu6aMmcOzTI+enfAfA+L8jKOM8s/eGu4sEn3RZjet208tEcuU7EU
	 PkYMGBwVH4nJmDolQ3m4przZvkpZcJZtCBLVIHFkXelS6Ior/Jdparmd91zga0jRiY
	 /K7VSyeNuvt44I8OE/xtH4n4yRdLSCOPR7WDlTXXZfX6Wf3R9Wp0QbuDbJZVv6r1Cz
	 hAtFucv65ZEAODyQjJ7+w7buPPMN9/YRPavDanEAcC5XRealCXIQSTJN9SVTygLDWo
	 OgOabsWslQlbanMTusID7Jh+LUxzGidFZj2BSS6BBW7e1nql/8FrKF2TpO4dZQNkGA
	 oDafCwtn3mj8YB0evU238QdA3ukp6AA/uRmRi76gkpaQLoa0wfwvMEECGghZS0P5IQ
	 5vmGrs+Js83Ksz3En7/EyZrBzTpMqIGYqVWStiel5ufTmed7naNjbZ5+hC0W/55H3o
	 UHzo0Vfpd0wyfhvTh/qK/nmP3iSaNtR+eRNdI/8lG7DjRCf5gp/UL0LsB0gS0HAoIf
	 K1xaVvwee0L3omszoXqbu4q6/B8q4dRB6IKLx7m8XXhT9pTupdYrMKHFMxnXnzHZr0
	 Kqf7/K71GZQQTunnwQt6WPrg=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6589740E0177;
	Mon, 24 Jun 2024 13:39:57 +0000 (UTC)
Date: Mon, 24 Jun 2024 15:39:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com,
	tglx@linutronix.de, dave.hansen@linux.intel.com, pgonda@google.com,
	seanjc@google.com, pbonzini@redhat.com
Subject: Re: [PATCH v9 03/24] virt: sev-guest: Make payload a variable length
 array
Message-ID: <20240624133951.GDZnl3JxlKXaIvrrJ3@fat_crate.local>
References: <20240531043038.3370793-1-nikunj@amd.com>
 <20240531043038.3370793-4-nikunj@amd.com>
 <20240621165410.GIZnWwMo80ZsPkFENV@fat_crate.local>
 <7586ae76-71ba-2d6b-aa00-24f5ff428905@amd.com>
 <fe74fd23-5a5f-9539-ba1e-fb22f4fa5fc1@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fe74fd23-5a5f-9539-ba1e-fb22f4fa5fc1@amd.com>

On Mon, Jun 24, 2024 at 08:00:38AM -0500, Tom Lendacky wrote:
> An alternative to the #defines would be something like:
> 
> struct snp_guest_msg {
> 	struct snp_guest_msg_hdr hdr;
> 	u8 payload[PAGE_SIZE - sizeof(struct snp_guest_msg_hdr)];
>  } __packed;
> 
> Not sure it matters, but does reduce the changes while ensuring the
> payload plus header doesn't exceed a page.

Yeah, because that would've been my next question - the requirement to keep it
<= PAGE_SIZE.

So yeah, Nikunj, please do that also and add a 

	BUILD_BUG_ON(sizeof(struct snp_guest_msg) > PAGE_SIZE);

somewhere in the driver to catch all kinds of funky stuff.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

