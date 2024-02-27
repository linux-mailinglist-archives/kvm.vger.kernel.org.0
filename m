Return-Path: <kvm+bounces-10111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 91376869F08
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 19:26:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46A281F23E0A
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 18:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2BB714830D;
	Tue, 27 Feb 2024 18:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="LYxPeK5W"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176B33D541;
	Tue, 27 Feb 2024 18:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709058373; cv=none; b=UUqfA0ha5+9N1QsPfOK2kc38cDr+joJNX4NRlrW/mLSWRkX4o0+pTOtF8chA+Xv38/VKJKot0lCNblWN/Y54rTB/wGmsgxNm7TUDuWk4l2V35AucTZlO75zJSMXRmzzouWIz5zl+s/64HzkWiFlqQQVxCWYkqcVVOVmf4cfpNAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709058373; c=relaxed/simple;
	bh=q54Zb8zuIF+rT8dKLPGT5h8/ppybmYT9EgPGBzXLu7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GtblPZVqeObHGBMBXUApyD2MtHctZlOgz5JLEZNmczTKOdoEJtW7LKJsYeb0LpmC2MUeju/L4j8Wlpz5k+b5q5yESNvHE5PzHXaIBuT7CiJjZzS3sEKfm4x4ySKc83iWSQh/Q8FPHPdZg7wDzThHjh3QakVUpdkx9wOB72k4qlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=LYxPeK5W; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6865840E0196;
	Tue, 27 Feb 2024 18:26:07 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Cp6QDiXg8qpd; Tue, 27 Feb 2024 18:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1709058361; bh=q5+4QNmqIGJdtL57QmnH1XXYBYtR2lIOJJG5PsvH/5o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LYxPeK5W22m5gA3wH4jg/WUsRabTiz0FMsXAKdT8IS1k/VpQyO8OtPFuqiDJLdm+l
	 UQ5fIzE+fsLYNJaMx4BJYI9Bn1AebGgCzfy+BxfzPaZ5BdLwrCQ89dMkODleadbNt+
	 bFauUNkFoIeKA4p965xcM+TpRgpuNcmT7+zd7TDa4Oo3VzgstHd0yTgZOO9bcDwgoi
	 dQjdZ1rts70abUQu5sZBXCmnz2mAlobzSlPDYOM1TKCnR7LkQhsuz+IvOQQ2q/iuEE
	 /2nYuaYM3E5m1rkoFL3AvQblCjCHe8EugCJ/Z3yClgxcd3B7I2ADyT8sBQjGU/Q/W7
	 ygB1RV2DpdSM9UWcYlN3FhZFMIc7BXHT206LrGXtyaLhfVDtS252MWs8yy86k3fFz6
	 3sciYo3+w0mkRI9Vt80YquOWlpiy1ECLt78tYHdTz6z+sKD4c2dyyjjetaWkSIB19A
	 BJm62F+LmpEEAfa5ns1OtfpRZZ1Kk7rtemg+oYN1xQoGOprQSwk9LBI+gJC6nxDA0H
	 qFutaZFgmrn+jfhYzE2DuZ6sD8q4q8bOyOu/lVpoeFkKQVCZGgYpFiQdonkY5iyBeA
	 cZ/05n45y41DgYjBvFlCZ8rAkE3cJ9mRxG6HqUZswAUJBqXp9Dlfj7e9UUUnDnatN5
	 9rYv+MZCxJzv7+g3VdE7VaeI=
Received: from zn.tnic (pd953021b.dip0.t-ipconnect.de [217.83.2.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 28B7140E016C;
	Tue, 27 Feb 2024 18:25:50 +0000 (UTC)
Date: Tue, 27 Feb 2024 19:25:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v8 01/16] virt: sev-guest: Use AES GCM crypto library
Message-ID: <20240227182544.GEZd4pKN5ASvSx4_dO@fat_crate.local>
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-2-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240215113128.275608-2-nikunj@amd.com>

On Thu, Feb 15, 2024 at 05:01:13PM +0530, Nikunj A Dadhania wrote:
> The sev-guest driver encryption code uses Crypto API for SNP guest
> messaging to interact with AMD Security processor. For enabling SecureTSC,
> SEV-SNP guests need to send a TSC_INFO request guest message before the
> smpboot phase starts. Details from the TSC_INFO response will be used to
> program the VMSA before the secondary CPUs are brought up. The Crypto API
> is not available this early in the boot phase.
> 
> In preparation of moving the encryption code out of sev-guest driver to
> support SecureTSC and make reviewing the diff easier, start using AES GCM
> library implementation instead of Crypto API.
> 
> Drop __enc_payload() and dec_payload() helpers as both are pretty small and
> can be moved to the respective callers.
> 
> CC: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Tested-by: Peter Gonda <pgonda@google.com>
> ---
>  drivers/virt/coco/sev-guest/Kconfig     |   4 +-
>  drivers/virt/coco/sev-guest/sev-guest.c | 175 ++++++------------------
>  drivers/virt/coco/sev-guest/sev-guest.h |   3 +
>  3 files changed, 43 insertions(+), 139 deletions(-)

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

