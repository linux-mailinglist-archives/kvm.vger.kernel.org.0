Return-Path: <kvm+bounces-15508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D2618ACE1A
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 15:25:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD55328214E
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 13:25:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A01AF14F9CF;
	Mon, 22 Apr 2024 13:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="LpxCAOKJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1AE14F13B;
	Mon, 22 Apr 2024 13:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713792337; cv=none; b=cJuwjyXu1zgVf4ZD36JH+xLwd1eKQb0/s9JImYtfIvvst8Q5gPYyxLe20aWLFTc7CycoY6GTArbvODfJQ0WVLPdDed6seAQhofI3We69MKbh+R7Y1tGgEoXp47nL/obmgkxYDucatnAN1JoE/y4popFvnV/3qYsFtUsTMvwc4p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713792337; c=relaxed/simple;
	bh=5DvoennQmckQFIaYiAoIASFU7DEMjeJ/9hYgo86JV4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BDu9EOg4ufIum4zP28HRnlz8o/QqEMXl684TWkwF+AN6nZe5cUwqHXpZBLWG2byT+xJ8YI+ge+XDU/7DbxnUxlKkS6i92i4u5HWrNWVsNA4Pa8Cwt71v1HMkt1Yvgvmiwov6nn2QHEjjWJzieGoX2lwQFL7mABP1jM/VpqrY8bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=LpxCAOKJ; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3852D40E0249;
	Mon, 22 Apr 2024 13:25:34 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id BwRWVbxTdVd4; Mon, 22 Apr 2024 13:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1713792330; bh=qmP5qyvqIWfUfyAhEfkmOf7gu8DbOspWfu7561GReo0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LpxCAOKJ21rdSnLNOzU4D1RYdLRCcOX2VTRJl+WnZAAJER9BSoDoOoFUwSAfg0rXi
	 LQ+lejeMqvQcilsI/ysnlsXOJP4uGjrMIkMwBsJMCr2rxofLa0EltkVaG7Fnf8WWkg
	 w6KMQDlV+bD1NVWOBdw/azhFpCZsvLURHi9CjTuEvhk2J8p81+tcJYDN7kZK+5r+ax
	 xzLmPYU9OyD2uiQ+foh31Rlgb5BbacfVfrpU2Kg22MTMW39XfMawcUsMi21aihT4ow
	 zbc0SDszmzKIkjX2CNBx21Ju8LjXTA9BvyUyo6Io5IlBaI0V2ZdcfbAR9Hwzws0wsy
	 tPDP4efGU9staHn0IL70Dg1qSC5y7BAgxJAaPbzWXHnnmcMcNLkzVgH55b9kfdT5ME
	 OocJt1YeHp9iEgO3PZnZYGVL8/gZnpixfnUAjuj2AsWjzIdM/aid3/9csPHhn0jBAT
	 6tnNt90ARUBsFTsdBCYH0Wi7VXhXmOH6t8U1Tgpk2VeCUclKQ5ilNTeoeoCug+Ymi2
	 mUWMVb9ffqqFX7ObfNR4a/Xv8dd55f5dlDGI1RxaH00UPXmF6eqk05oTrpHQox9rVf
	 X46/BwuskG8km0gvd0nn19nqJLPdkSDM+plKwrWyHENf6UkmzjtO1D8CjkXAq61GDP
	 f0+C1kFv+sAnbpSE2WtU0gMI=
Received: from nazgul.tnic (unknown [IPv6:2a02:3038:209:d596:9e4e:36ff:fe9e:77ac])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 523A140E0240;
	Mon, 22 Apr 2024 13:25:19 +0000 (UTC)
Date: Mon, 22 Apr 2024 15:25:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v8 09/16] x86/cpufeatures: Add synthetic Secure TSC bit
Message-ID: <20240422132521.GCZiZlQfpu1nQliyYs@fat_crate.local>
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-10-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240215113128.275608-10-nikunj@amd.com>

On Thu, Feb 15, 2024 at 05:01:21PM +0530, Nikunj A Dadhania wrote:
> Add support for the synthetic CPUID flag which indicates that the SNP
> guest is running with secure tsc enabled (MSR_AMD64_SEV Bit 11 -

"TSC"

> SecureTsc_Enabled) . This flag is there so that this capability in the
> guests can be detected easily without reading MSRs every time accessors.

Why?

What's wrong with cc_platform_has(CC_ATTR_GUEST_SECURE_TSC) or so?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

