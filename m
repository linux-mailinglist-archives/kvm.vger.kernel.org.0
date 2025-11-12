Return-Path: <kvm+bounces-62871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F04BC51AC0
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 11:33:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 320483AA009
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 10:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 599CB302CA2;
	Wed, 12 Nov 2025 10:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="QCLCeGU4"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35192FD1D5;
	Wed, 12 Nov 2025 10:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762943042; cv=none; b=tDS+LsKIl01/58+taCi87VU4atHZg2FLJzEjLF893jUKwyHdsEX4NDnzQbV/CNGc/U4SBoO2Sz7AGA3ecL9xIAHpcV/riZ8TxNEXpreFuvXRkRiuHfF19TFmcpmTn3RWogwaziPJyu6d650545EhPLWDAm/f0eGLJCYmHaUEs3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762943042; c=relaxed/simple;
	bh=hMphcSWzvjciJLgu8O9mNBZ6tS/PYXaz6WZrCbUlq6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EH0lh76CE2cOviV+sh1i0ZS7HruUF84311pIZaRSkIFHLrj1hgf/WFlhE9LyEh8aMD3kfTRl6uk9lWrdbLqlHxFiAsc8RFGaantYNlW1k8CyuU4bueXRTKmQ1Qzw4hTDK8awKO7RFqeeadYvXa7FkLN4K1jL8vvE43cGWkwVM0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=QCLCeGU4; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 107B840E0191;
	Wed, 12 Nov 2025 10:23:56 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id cEK6losoTe2o; Wed, 12 Nov 2025 10:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1762943032; bh=DcWrLzxh17tqGrEc3eGZpJOg3tUTZgcl6XBpECD3q3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QCLCeGU4V+yvIzX5bcSbdkHOamA01FY2W275TAbREMQo0bCVVP6kaf7H0LVUN0R/a
	 6WLPS2YEeC2IKT22s37kdUwhgIEQbZzkc+kSt+CFdGltJhuVdVSNd5pilnz/pJzOQ8
	 bg/Jy6t//rvWs6wafimEELgl/y+N6aHRznna0a0IZoUSOFRrlOI6dLRtj6521yxv8g
	 jQe2OA7RDPOUZVQp5vETlKjmFlOr4WQrRHfLLiGCFLJ9glf37K3HVKj/t6PNAiIjvV
	 LNsLBkhXh9B3EJuecxXFKnw/1pj82Ef2Ivl/tWFX5d8qLb+yo3JAixv5zXmU9zF3Zq
	 evZ5MQqhDYnWnEwNyKwKNt41dnHIydEl5d0MR40gPt/LcIZmpc06UzVZHtnIa0rhgY
	 fR3uTShVgMjmzANFYidcgPO5mOuCaDR58l+hwEoa9SiBn7Pa9t/4hlNrnIBNaAoc8U
	 mgnVZBZUNyQv6UisC75CNhCBxS9cJlvN0TsCirkCJ58HAfF3yAQR3Bb9dzqTNYPZYA
	 qRNe6FydRNa1610zpJprke3I3CrEh1Isi91a5p5SNVVXhLMnsuEXnHnwGZOCEpsH82
	 hxFmUTkM4K3Lgbz3FBKU+MudGNp9hPd8Ov/4sUqH+zWN7NDzo/HUwkNxaIpNrzPDyi
	 RiUvpJtg8HJvniTT1lTy4Szc=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 6F29740E01CD;
	Wed, 12 Nov 2025 10:23:43 +0000 (UTC)
Date: Wed, 12 Nov 2025 11:23:36 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 1/8] x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well
Message-ID: <20251112102336.GAaRRgKJ6lHCKQgxdd@fat_crate.local>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-2-seanjc@google.com>
 <20251103181840.kx3egw5fwgzpksu4@desk>
 <20251107190534.GTaQ5C_l_UsZmQR1ph@fat_crate.local>
 <aROyvB0kZSQYmCh0@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aROyvB0kZSQYmCh0@google.com>

On Tue, Nov 11, 2025 at 02:03:40PM -0800, Sean Christopherson wrote:
> How about:
> 
> /* If necessary, emit VERW on exit-to-userspace to clear CPU buffers. */
> #define CLEAR_CPU_BUFFERS \
> 	ALTERNATIVE "", __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF

By the "If necessary" you mean whether X86_FEATURE_CLEAR_CPU_BUF is set or
not, I presume...

I was just wondering whether this macro is going to be used somewhere else
*except* on the kernel->user vector.

> Ya, and this goes away (moved into SVM) by the end of the series.

Aha, lemme look at the rest too then.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

