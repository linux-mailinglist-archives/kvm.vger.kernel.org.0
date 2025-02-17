Return-Path: <kvm+bounces-38377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1096A388DE
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 17:11:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57A3E3A213D
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 16:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84BA82253B7;
	Mon, 17 Feb 2025 16:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="KeB+11la"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E4F15575C;
	Mon, 17 Feb 2025 16:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739808478; cv=none; b=lc/S+ItMoNrvE92k0e18b29nnzy/mnSilpozZ5R9ttKu+kc6QjZEGVefD73bd6mEHB5xhNrW704zA6ytuxifYlPJihw/0RY0dr6Lfgz9nN549uuTJ5ySlEh7F0/LKe9zFd9q94oiMTAghQEd1ReiqvLwkg5u9VLzPpC2bc5gPgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739808478; c=relaxed/simple;
	bh=ZrsUY4WxM2KXglcaITS5skiOuSbZys77BjzBQjmx1Xs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WJnXgkcf4ZGMNgWgirCwGF32DhPaxalWR3f5R5Sek/Os63b4sR/8M2OZqIAbE4zqliAASKDz5B1qtWaEQd0N0smH5EPGBjC0A/qIo5FljHC4OgWDisWakQkQfw0e8uWY2jqVMT8a7AEOdZ38t+GwNyUw4juMrwQZWOYmENwB2w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=KeB+11la; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7505040E01A3;
	Mon, 17 Feb 2025 16:07:53 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 66SWbZ7g5m6h; Mon, 17 Feb 2025 16:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1739808465; bh=IzM8iArkOMQyqjlaS803SpfwHnZrKVrnYMOCEqL2HNA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KeB+11lauTp3BePXJQFJg4kDy7Cr+L5baHAuO131HM4tlXZCTZXYe8fE6claf8Y4J
	 1dBMaY42I9QHEaT1a1xNubw+miXz2wh0xogr8loydSeCGzAwFezHppXC1m6KKhDeGH
	 dV9CdIUhypUx012/I/aoJvorHyGRAw+C6lc/dk+MLCuAXA3EWRNO9c7tcuW0LoW3U7
	 1FnV4KvBC0JFE6u/ugqWkSxmPdJgikSLYtpCV2Xar4yqIDfRhN2erST4g23vdWai66
	 utv/v9qEMvdOinJPmVn9Za3wG2cYJj2S+OyzAR5HDwX2XaYakz4lwBAFpjvc006tRo
	 PF24sXEaeilARnn0fTaY5E24i+lAICIuH4O0PJWMlmleqsaCuMJ1Ht2NCB9efUt6QM
	 duSU/QwKWKcCyNU0kff2OKexvSP2Z+yBDAwI5cvaXLmaozKIyrO2KUFOC9EshAQbv4
	 TMnnVdFeWa0IqCQFuv7kwAcSKo2dinV55Elx8voboL00LYWyS8FA9VXh22ut/iQGNi
	 vMZuAb5bZUDbDZWX9MaS0AWXE0FxDu6b7Yt0/R7tRWineMokHv5s5LGEaxe5z0Jkjm
	 S2f0aQSTXiOhwbJUMapiKepekl6jbrmctPfT7QZBNBk19DYp90L/QRS/vfagB1bXuT
	 fJ0KDumQQa4ZRPJ286w27YRY=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4C07740E0191;
	Mon, 17 Feb 2025 16:07:34 +0000 (UTC)
Date: Mon, 17 Feb 2025 17:07:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>,
	Patrick Bellasi <derkling@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: Re: Re: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20250217160728.GFZ7NewJHpMaWdiX2M@fat_crate.local>
References: <20250213142815.GBZ64Bf3zPIay9nGza@fat_crate.local>
 <20250213175057.3108031-1-derkling@google.com>
 <20250214201005.GBZ6-jHUff99tmkyBK@fat_crate.local>
 <20250215125307.GBZ7COM-AkyaF8bNiC@fat_crate.local>
 <Z7LQX3j5Gfi8aps8@Asmaa.>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z7LQX3j5Gfi8aps8@Asmaa.>

On Sun, Feb 16, 2025 at 09:59:59PM -0800, Yosry Ahmed wrote:
> If 1-2% is the cost for keeping the MSR enabled at all times, I wonder
> if we should just do that for simplicitly, and have it its own
> mitigation option (chosen by the cmdline).

Yes, that's what David and I think we should do initially.

Then we can chase some more involved scheme like setting the bit before the
first VM runs and then clearing it when the last one exits. I *think* I've
seen something like that in KVM but I need to stare in detail.

> - Upon return to userspace (similar to your previous proposal). In this
>   case we run userspace with the MSR cleared, and only perform an IBPB
>   in the exit to userspace pace.

You want to IBPB before clearing the MSR as otherwise host kernel will be
running with the mistrained gunk from the guest.

> Any thoughts? 

Yes, let's keep it simple and do anything more involved *only* if it is really
necessary.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

