Return-Path: <kvm+bounces-15505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D10B88ACDF9
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 15:15:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B30DB2382F
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 13:15:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A294D14F13E;
	Mon, 22 Apr 2024 13:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="NKdxfYzU"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45FE14F120;
	Mon, 22 Apr 2024 13:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713791726; cv=none; b=d2UnFOHGpeeb1r8mAwP/LaAaCsD6cCCrWcjqV5S0fcAK3xymNurmrxwyL4nFHmKc/Te5GBcnKyr00yQ0lrb5d+uPGGaZzDcFCsKKDT+yvb17ns3Mjrsb3Aj9MvRTKaMMhSLC59Eb1BlYl25Z8E/325PKG2b+ICoJKXQ2tjxMKIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713791726; c=relaxed/simple;
	bh=Bsi2yrP9GspUNdvxo00t0OABd9LalWnEPytFUjRckpI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZHqJhSGPg1sP9jY1FnEV91J6hT9fYa1RyvVaY0ogSWHWbuifE4k6W9ZcJHp3ef/utyvXLnEd8F5q9GaTLTSnIM9kcJbCo3OV+1cW4DPYu+cenwtrAPo1n1Jf6ClMzlslj9Bb5A9Q1CBksk6TqzpmHM7hRojIsbqN+nnG5LA8Jpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=NKdxfYzU; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5659840E00B2;
	Mon, 22 Apr 2024 13:15:22 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id tSmzaJxpVIeN; Mon, 22 Apr 2024 13:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1713791717; bh=6GcGWsNB6KQVPHBxhsurkToAwd7K4BfgUopftbZCrT4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NKdxfYzUGlllLZtmk5Dvimol6pTVI2TXeBwm/NuJOg8amoKGgPjr78IyU9JNKaGG8
	 KNBjIOxe7l2o5M+WNQivj6fygOzNcvEMDyTsvmYIbL54WK4RIZcYyAaszWrINh1IjI
	 kGtlnZFBrV+nx8CFeX7EGe3m1QeOJAoLWRk7icQWefFOJRuPKvvVmJdzd2HcxQSVTM
	 bnWpisSQ0LHcFNWTyM4g7zxipoTJH1O499dXrFAse3ifbgzXufai5f2in6PEiH5C0s
	 44p5eZDX9+DKFEHmcO+GOv4/o+2pDzJaB+8gByQpXetS0Hi4lbXEWVaR48BdDjmFlt
	 TLmbGxumfn2uJ0IgXxv1FlsOZ6byrxICz6a9lwv5QWs7zEYVKUvRzj0Q8gHh0i3ZzN
	 Q44+c0rmBeQFm2EAh5bhgCmL6OJOZblTEV9O01VAN2dGHcTJxb4ITqlqBwKxM15Xga
	 tSmlBkxjwxzm4CgS1E1W5FbvXSFdpAP9wu+JUqJiIWaJB7oCvvd34YHRD7T/5YetP/
	 UyVuIJmeZoWD6OkwSU0LW/THbdhCVV0frlrxj0TNbUmU1qUADCmfHuhkswigWq6iXI
	 SebUNfU6pM7QKoTALRcofguRwMFkTIcDPT81mHdfazBzeLTrCRnxngdBFYGUFJv6LF
	 VgNpZFYLYFZkuSwxbelKphCI=
Received: from nazgul.tnic (unknown [IPv6:2a02:3038:209:d596:9e4e:36ff:fe9e:77ac])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C464140E016C;
	Mon, 22 Apr 2024 13:15:05 +0000 (UTC)
Date: Mon, 22 Apr 2024 15:14:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v8 07/16] x86/sev: Move and reorganize sev guest request
 api
Message-ID: <20240422131459.GAZiZi0wUtpx2r0M6-@fat_crate.local>
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-8-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240215113128.275608-8-nikunj@amd.com>

On Thu, Feb 15, 2024 at 05:01:19PM +0530, Nikunj A Dadhania wrote:
> Subject: Re: [PATCH v8 07/16] x86/sev: Move and reorganize sev guest request api

s/api/API/g

Please check your whole patchset for proper naming/abbreviations
spelling, etc.

Another one: s/sev/SEV/g and so on. You should know the drill by now.

> For enabling Secure TSC, SEV-SNP guests need to communicate with the
> AMD Security Processor early during boot. Many of the required
> functions are implemented in the sev-guest driver and therefore not
> available at early boot. Move the required functions and provide
> API to the sev guest driver for sending guest message and vmpck
> routines.

Patches which move and reorganize must always be split: first patch(es):
you do *purely* *mechanical* move without any code changes. Then you do
the code changes ontop so that a reviewer can have a chance of seeing
what you're doing.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

