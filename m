Return-Path: <kvm+bounces-50986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5728AEB70D
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 14:02:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6909565CB8
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 12:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11A2429E0E0;
	Fri, 27 Jun 2025 12:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="MnyuJS3i"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389DA1DB551;
	Fri, 27 Jun 2025 12:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751025712; cv=none; b=QLEsUJ12EhIsvU0ay1NCZNIc3oOFpj51N26emgkNazsZ0Gx9mCR+RLF+ykip7HgjN53KOJDqvqRjSPMKUC9azFg0JFZFuLrNCS3ZK5ArAtxgT0X/FuGHvBYZ6SBnt1jax+SLazIV56MilO3dcOGj8L7yVn7hlkTd6rGFMcqskbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751025712; c=relaxed/simple;
	bh=UHMGY9lxYmtZHXs+Es7Nhp2fGyKHJf0mmDaSA3nAdQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bhQuuD9nPzuZ7MDx7ObxwxsTF0k9gUeL9fzy6Z91CX6PupHeqoIhFQJTN1lzxkOf1ZDWXuRjsKx5XOw9mrZh1QeRnP0FvKhd+xokvD0hV9dMWseJoiQ65BmphkgJWOoe1VR7MTj/4veugCqVLNb1H3OUkjpJGBZfKQe/9Gs9MCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=MnyuJS3i; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2D04640E0169;
	Fri, 27 Jun 2025 12:01:48 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id WrsdBXC2E2Xe; Fri, 27 Jun 2025 12:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1751025697; bh=FkZ5lpYwYTYuA2kPbG6UdUCZVUGwHwYkxO5MZLARu2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MnyuJS3ifx2X1UipUt7O520VGuBc4r7fgG9DBqh+LRNksXo83qdUuuQgii3UTVsJd
	 PvuDyZTIVxGW9vMRUf7EqWKPbyk17n5w0b/ZQ34Cu8t5+TNPSUp02AQJfUtLuMUq8b
	 mBrtXi7GqszMZQP0quIeWNBgMx77wMB2j+ca064eWd/o6ntyjGuU6YgLuI9x1j8R8a
	 nPJ6ZP0fg8kzcyTy/ypocO6o3hFQjGZW+3zsTjdaFyTjg0nhCbTGRWbdX3tgMzG8Rm
	 wTsgewTl2Js0KwRwke+MLRsMg70YJ+7c303gHup9QJvDe20bWv5exEJ/p9gY1P+pSY
	 eacxAjruA0aOSvggI4MsSvk6HDLYB/Jvm4fVkaUh3pmr8qJm1p1EkbaAqvr5tEx3wP
	 A6Q3MdC9pZWb+gmSs8pCEcZoggA/pJkNexRIE+0lG4cm3CVbpSD+9qD1CmLGIMJn9f
	 szRUauC6pef6M1G42phJfePVNO5PuQ5QvRY1l52obpyuicXBgtEeTJRtZzCN+hZIiU
	 ZNxRAL2kyTKEgxeKB+Uzq+RwsR2qv3hbet60Ro7aSuNQjkcEka7a28gnqwzeLK5FBb
	 shYT4hwXP2JNheeLCuAhkDHfGswZUT6CWnJWC4/Q5hGMqelhRUvxub1wbjJFieeUo1
	 kPhtlHwH2duvJYtFde097Tos=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7CDCF40E019C;
	Fri, 27 Jun 2025 12:01:28 +0000 (UTC)
Date: Fri, 27 Jun 2025 14:01:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-coco@lists.linux.dev, kvm@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] x86/sev: fix error handling in
 sev_es_efi_map_ghcbs_caas()
Message-ID: <20250627120122.GBaF6IEgLEmfntS7qA@fat_crate.local>
References: <20250626114014.373748-1-kraxel@redhat.com>
 <20250626114014.373748-3-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250626114014.373748-3-kraxel@redhat.com>

On Thu, Jun 26, 2025 at 01:40:12PM +0200, Gerd Hoffmann wrote:
> -		if (kernel_map_pages_in_pgd(pgd, pfn, address, 1, pflags))
> -			return 1;
> +		retval = kernel_map_pages_in_pgd(pgd, pfn, address, 1, pflags);
> +		if (retval != 0)
> +			return retval;

Yeah, I'd understand if it made any sense to propagate the error upwards but
this function is called exactly once by efi_setup_page_tables() and all it
needs to return is success/failure which the caller uses on the spot.

So no point in doing any of that nonsense. I'll zap it from the set.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

