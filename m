Return-Path: <kvm+bounces-33509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 229649ED758
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 21:39:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB37718835F1
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 20:38:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B34292210E9;
	Wed, 11 Dec 2024 20:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="EfPYCnJl"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA341FF1D7;
	Wed, 11 Dec 2024 20:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733949513; cv=none; b=A+Br8MWIXUZDCoSUz6aHC+h5pHEWQprfzehmLkLUizc60mwxAjWFwQSQKlpVfaskaEZ2IhbUnt5B6HKnKyzaalCVip/LLfHnnFzyuR4QfxK4IpNmGlB53+q7z9/DDGtKgNYhP36vUbvBmRYQRYq4KJCOoIyv11RckYAYK8+N334=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733949513; c=relaxed/simple;
	bh=9IpLqG+c+Yfk5ORgYVTRNn7JW9hDcHmFP7FiNyJGQwI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AcTPbtGX2r5/Smz/+P3CepqAUuNlsQCjYe9sYyJzyeYpiTHo5mJZ1wDJnckHfCbUBk845LYypD5AxdzDlL6w1BB8l+Gu8/aaK41CnsoCwbFsuKjqzDJqLn9w675P+Gwo+HTPblQ7HJWdLehKNgmnTxl/6A/dYyKc0CGT4d4Tr1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=EfPYCnJl; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A471140E0169;
	Wed, 11 Dec 2024 20:38:28 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id wQrmHTqsyfuQ; Wed, 11 Dec 2024 20:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733949505; bh=eDxoeuthO4PCXJB2+jnxxZFOWPaaY2daE2aZpStwsBo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EfPYCnJldMw8PCdb8IHuJw09vp63MNJUt89Lhjpv8SIlW16M+ecrj8i37lDhi3T0+
	 wvO1lSbLyyolh4KZnGjQIm2zM5xA562NC1UR/W4rWZmiUr0ZaoCTIK/lNusXXkvcQz
	 bjommxYo6MWIewlPSSieeSs8yt+s2TDtF87ga34uLF8d/x5hKjUVnQfycFsJ+apKw6
	 MhfCko5grgj7hdPoPDfMhDK7na4+osMtdBNM7Kssbj2NVQaWfPdu8QFjtz0YsYmjZU
	 WZLeRinlQNc5A9rHWy0gHE6kvRRwNkLVjxIComh8+qs6BxdbUTNXMQUEif8Fd/WOK2
	 1gmyUPAzy8MG78tjJBGxV2UzYw3RrGMRLf6KgZJL+o5FZSoAQH+gGcAB/S54UQUxLH
	 zeqxmgum3ORGImnvlmufTKyJc9O+PQWVYaamjAy2lnqhEnEt4q/9hhiDY6IbcLemE2
	 17X3YbO2U18eRnkOqs9tq/3PaNiw1ktCJzResZy36iQMp8/VPGszTfmQXs0B322nad
	 KwjTy2GXxR57E+NvlaN8dvxxoGXBLkkm9EcK+5HEs2gvG3GR7ei7JXcWSPU6MYDWsh
	 wWSl3IrbMiWvtkkicTDVf4pClQGw8m5W9W1dAk/C0MebqOfwlsYYbny1puRfWJmBel
	 P0YZY1re2UWPs5MzumvKRz2k=
Received: from zn.tnic (p200300ea971F93CE329c23ffFEA6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:93ce:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1162F40E02BA;
	Wed, 11 Dec 2024 20:38:17 +0000 (UTC)
Date: Wed, 11 Dec 2024 21:38:16 +0100
From: Borislav Petkov <bp@alien8.de>
To: Josh Poimboeuf <jpoimboe@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] x86/bugs: Add SRSO_USER_KERNEL_NO support
Message-ID: <20241211203816.GHZ1n4OFXK8KS4K6dC@fat_crate.local>
References: <20241202120416.6054-1-bp@kernel.org>
 <20241202120416.6054-2-bp@kernel.org>
 <20241210065331.ojnespi77no7kfqf@jpoimboe>
 <20241210153710.GJZ1hgJpVImYZq47Sv@fat_crate.local>
 <20241211075315.grttcgu2ht2vuq5d@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241211075315.grttcgu2ht2vuq5d@jpoimboe>

On Tue, Dec 10, 2024 at 11:53:15PM -0800, Josh Poimboeuf wrote:
> The printk makes sense when it's actually a fallback from
> "spec_rstack_overflow=safe-ret"

Well, it kinda is as safe-ret is the default and we're falling back from it...

> but if nothing was specified on the cmdline, it's the default rather than
> a fallback.  In which case I think the printk would be confusing.

... but as I said, I'm not hung on that printk - zapped it is.

Btw, Sean, how should we merge this?

Should I take it all through tip and give you an immutable branch?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

