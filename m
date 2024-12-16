Return-Path: <kvm+bounces-33869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 38AAA9F3765
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 18:21:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E7FA11882C43
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 17:21:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9827D2066CB;
	Mon, 16 Dec 2024 17:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Ws7DxjwJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9344C2063D2;
	Mon, 16 Dec 2024 17:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734369689; cv=none; b=PjEtAiK17aRgAlegkToeeTn6Q/OJY2LYvQwOkEACp0Tnq9iNqWxEIdllqp9foiW+YRU36sLX6FRfcuC5jPgfLRe27HQResydvhrvCMNLn6l58yI9GSsMXtFlN8pBta3osaKEgNzly0cfUFaccXPwNLeZJC9Evtem0GGtyQ3UYRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734369689; c=relaxed/simple;
	bh=PJhBIGavO75oUIuythOpbZQWf9qeJaB0K5qVu5wRzkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ylb1LalVjLH3Dclb4C/aD1v1Bi6zFfsIoPRW5M89U0PYDjLn8q2b01gcaFoqR82oEgzR5/apP+ORZBKVXL/blPxQw1Qrw+CcZrhXPZbvZlaSJ87OlBAHPgEUkYsz1IMgZadZk6LNhQqk4cCQUXIE1tEO+wb7gSHpwNE6MBa6JS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Ws7DxjwJ; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7CCDA40E0288;
	Mon, 16 Dec 2024 17:21:25 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id QPd-heR1xPtD; Mon, 16 Dec 2024 17:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1734369682; bh=DTLKHvlsb1eT4f3pms2ceKzfQpmWFZnGKQx2hbANbbU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ws7DxjwJAaS5Qqpo5ej3UO95Rh4aPePSbYeFKFafIe/OvTlavkhytZiSOXupjPFiA
	 mf8jqV/hIuZOom3l5cbYsbf5/J1gcJoMZp/q0UuAzBbV+3wac0b6LRuqAY1EvV5NHr
	 fgny2vvR0FBNuVyX0RQ1IB1euAwX54BHkSmjIBbKpC59s8uyYVE/Zr5odCTsKsNjr0
	 kfl1uAqvrtSe1e3V/4lUHj2XrhBLx+pmKZ+Z5tQZnmgpqYQ5/9BFtGB+iLgPQwlJvW
	 tHmtMGIv5AVQgd9FCZjuS8ADmxmE1cWxi52bfbhNnLoLjB7KsYZCDEIZj2+UJVMvYQ
	 xsV/Kl/JpKlKFFOwKnDdtLuy3jSVURI2AuqSrnv/QzT1orawjlijVXfrTgJ7U9Abvb
	 Pog8o66wNoVtuFle2czYoYgWPSdYvYaGck1mktaI/Df8PhbZFzCJs2S/qggp7J8O8U
	 k89U3C9XN9G+PseMKd+QRVqdc8FuMck4qf8Y/odd4w8Hi4usBOk4VpXVRoVZttvIC5
	 CXNfXf7TvjqCXB5mcgHnWyMRUm/UI5tNAzbtTK5jajzvkT9KkqV8Tic4PODxJAGmGg
	 Xu/0F32LPT/6j8Uv63kkeCGMJ3biB/l3zwyRVVlKthaRntFUO10539A5X4Gj5Ji4sG
	 T8oRAKyvUtZ4F/SUwTREMpQs=
Received: from zn.tnic (p200300EA971F937D329C23Fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:937d:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E63C940E0286;
	Mon, 16 Dec 2024 17:21:13 +0000 (UTC)
Date: Mon, 16 Dec 2024 18:21:13 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@kernel.org>,
	X86 ML <x86@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] x86/bugs: Add SRSO_USER_KERNEL_NO support
Message-ID: <20241216172113.GCZ2BhiQlgqYtpQ5lC@fat_crate.local>
References: <20241202120416.6054-1-bp@kernel.org>
 <20241202120416.6054-2-bp@kernel.org>
 <20241210065331.ojnespi77no7kfqf@jpoimboe>
 <20241210153710.GJZ1hgJpVImYZq47Sv@fat_crate.local>
 <20241211075315.grttcgu2ht2vuq5d@jpoimboe>
 <20241211203816.GHZ1n4OFXK8KS4K6dC@fat_crate.local>
 <Z1oTu37PmOvK6OlN@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z1oTu37PmOvK6OlN@google.com>

On Wed, Dec 11, 2024 at 02:35:39PM -0800, Sean Christopherson wrote:
> On Wed, Dec 11, 2024, Borislav Petkov wrote:
> > Btw, Sean, how should we merge this?
> > 
> > Should I take it all through tip and give you an immutable branch?
> 
> Hmm, that should work.  I don't anticipate any conflicts other than patch 2
> (Advertise SRSO_USER_KERNEL_NO to userspace), which is amusingly the most trivial
> patch.
> 
> Patch 2 is going to conflict with the CPUID/cpu_caps rework[*], but the conflict
> won't be hard to resolve, and I'm pretty sure that if I merge in your branch after
> applying the rework, the merge commit will show an "obviously correct" resolution.
> Or if I screw it up, an obviously wrong resolution :-)
> 
> Alternatively, take 1, 3, and 4 through tip, and 2 through my tree, but that
> seems unnecessarily convoluted.

Ok, lemme queue them all through tip and we'll see what conflicts we encounter
along the way and then sync again.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

