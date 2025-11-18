Return-Path: <kvm+bounces-63536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D008C68DB9
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 11:34:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E67204F197C
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 10:33:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D19D343D8A;
	Tue, 18 Nov 2025 10:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="jZF5NfMc"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB75B30103D;
	Tue, 18 Nov 2025 10:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763461984; cv=none; b=OoF+S7Hv9FjuAZZArfl9hH5x31OVvMJeD9idLQgN1Eq4xo6iGVUwVc++AAnjMDLBA0eoP/ZvWiSi03RJ3ULg5KXbyASf1ejAT769pJMhgy2NSwqdiDv2Kwue46LVnvYbnKKPQ0Ht4kqUIltqtbSBZ1sKhvkkZNoV+CeZWh4pze0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763461984; c=relaxed/simple;
	bh=dxvcxdy4vmKK8JBKDkw3kYdaEbdFMdW7xnAPLzstfiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CFuXXAgnCJLOXkD1UhksE/RB6//E5/ATUtLm9aQ1pdd16MZdnGFIbEGPHtk9KW4DMj7hQ+BFWBuF84izS3ICJNknkLTs+exfnbQOljsgDBVDd0IzHqosnLZdFDXO4z7VXUjtrAV1kf2+UkSt8sr+9+jgdrHNWDvbw5PMc37S3GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=jZF5NfMc; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A8BE140E0191;
	Tue, 18 Nov 2025 10:32:56 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id MqkUbmwc3r4j; Tue, 18 Nov 2025 10:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1763461972; bh=Zc6Dv9Gmjv5GMGCUrDvg2L38fB1zG/P+vzA9htzfsI0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jZF5NfMc3nFV2H1tw9QjVetRpSp0eXcc7u4ZUVUvBCKBKAjBHNgEuk37Jw4sw0dxo
	 GIkIoFHYIYg8jzmWKsDVWv4OooIKtQ3Sx39zooYWI7Vy3wc8kCFiPDoKNFIrx/wxse
	 g+Itt2CcblrBDLjnNrkAYUJ93hy/ICt7nytgxqlRHt6z+IJGSV6HLADOiqkP6jI1gd
	 dFSozWoiu8DhGxk25Y/iwGhujVt8pB/t6eyTSstsuLcQP7npOvx8OUjk9CliMm8KPZ
	 BRV5hZu0McaU08DUjca9ROIQtJEZ7WKDGEN3RgKLkOeGVAY5WFMd2UWOXxlu3PvlIx
	 m1GZHMqP4aeEj9QKoNHQ+6uc1Bo93qCeVQqjsQdhLeGykJE4tYMwHumH5o9wS4gOjW
	 REms6jB96eawthepFD/46dEL44QPspvn1gixVSmDSQW1CZDr2fkwwIaGmgyoPmP9fh
	 KJCMRI8l9xdDVEFsq4F2CKZ3VIVPcXEhJPYM7K7uZdGvXmy4w406bxJr8XrX67oLNW
	 YPZJZshh/IzgigXi/YEe+8IEx6icmqziPNBrM/Qv2+yOQEUUTSGEwX++gP67PaEfFO
	 2jXmfh6eTgzuvbyjW66o8og8cffneJmYiSTWts+GEmn+QPEBk8CNEfpPQaU6id6u6t
	 OoIzNT/VhqJth8L4A2RZ11yM=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 0038640E0216;
	Tue, 18 Nov 2025 10:32:42 +0000 (UTC)
Date: Tue, 18 Nov 2025 11:32:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v5 3/9] x86/bugs: Decouple ALTERNATIVE usage from VERW
 macro definition
Message-ID: <20251118103235.GAaRxLQ74QAzt32r6A@fat_crate.local>
References: <20251113233746.1703361-1-seanjc@google.com>
 <20251113233746.1703361-4-seanjc@google.com>
 <20251117101129.GGaRr00XgEln3XzR5N@fat_crate.local>
 <aRtAOM040vM9RGfK@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aRtAOM040vM9RGfK@google.com>

On Mon, Nov 17, 2025 at 07:33:12AM -0800, Sean Christopherson wrote:
> Brendan also brought this up in v4[*].  Unless there's a way to coerce ALTERNATIVE_2
> into working with multiple strings, the layer of indirection is needed so that KVM
> can emit __stringify() for the entire sequence.

Ah, yah, there was that.

Pls put a small comment above it so that we don't forget.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

