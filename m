Return-Path: <kvm+bounces-13570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 20ED5898908
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 15:45:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 510451C254EF
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 13:45:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5808A1292DD;
	Thu,  4 Apr 2024 13:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="VTBo4C/p"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691721292CC;
	Thu,  4 Apr 2024 13:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712238322; cv=none; b=Qt7UFPWJBSR4BNiPBi0t9de/bjXADKL2g69+c9uplOqWaVT12xoJ03qzQNh/XuE/R1Auh3QsVbirBQhsXnq4K2APiaw1dE1df6KhcafdkBPtTDPgLsJpYzp6lUTZyLtu2UabkFQ0Z5scKFsFB5vYdsk/yl8wAvLft7A1QKzqOIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712238322; c=relaxed/simple;
	bh=lt7E2zXyUbMPBjxf4XmiRbNFbrymY6WXmeqg2i9JxxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q7y74ar2ATME45FCfqmsfAyKiyFCZwigkTauOgVMNMbzfcczc2Km0/R2RAZsA5yR63XIkR8cQKyq5++KuqG+Nfr6RwMLLeJREtW9LQkL0VNtCp3LJCuH9+KFOKA7uIoS99WJ0r3sUD86QLFwo2YKIC6qoEmNl3apZT68+ufqvk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=VTBo4C/p; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 23A9F40E019C;
	Thu,  4 Apr 2024 13:45:18 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id KFtpLrkW2Zbg; Thu,  4 Apr 2024 13:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1712238314; bh=KYePjgKyrxaOLQX3sTefJA/mryMqM96mkB5p7azkNE8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VTBo4C/pxotQQ2bPyVDeqvaYiueLsOLbdQZDll5g3ZzIE7Kyup0p+vV96V6t70OpY
	 COWgGMJG2WSKR0/kEV5/RVSjQXe+6Y6mqF3+vATFjpEUZyV2E00jx0aYQ32siV++BA
	 XU2LEnoMqVGQZXD2BXxd+8AvfleG4o6as0eDMDOhoIEq7K/rGd7x//Ym0e5ezGqtv7
	 g7EPORt+4YoazEyJkvcs/fVrOwwclj4/Y2hFFyTnPyC9iFMBJ5eZ45k954WzWgA6H/
	 ZtxozH/dcXOIIxAJ1+Wz6Uxz5oJsSpQ2azqSyTEnKfMQxcrYadNInMAtG1cALG8YVH
	 BWxIWgJzEMZFIIEtnx8gnzaZ0sQdsobihRWrMwtIBzbP7b95L67uoiEgOfJzw4csJR
	 mXAF1ZGzZafZXhQskUx7Lw/yaXHgzTX5v9uhoSQyvHtRK6pNognGD22xVsfC6eM8LF
	 0a/Au2ZGcHJDSVsfQ1X0jTIa239Yslny6HbYqqYW4io6xEo6B6ZmcqWLY2Bs2MMvBb
	 rEnWrWJ5FcE/rZ8Tuizww6RiRapMDbyYn2m14uHo4ZDhXgy5Ue4RUS8ppJRefwum6Y
	 4ICIFViVvRSpTXd0VDFkrlJCcZ/giC2/B7VTp7nmVkDscKlcieJzXtcAdSid41bSnV
	 qbYTBG0nrhf9BzBPhOBS14hs=
Received: from zn.tnic (p5de8ecf7.dip0.t-ipconnect.de [93.232.236.247])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 467EA40E00F4;
	Thu,  4 Apr 2024 13:44:53 +0000 (UTC)
Date: Thu, 4 Apr 2024 15:44:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Michael Roth <michael.roth@amd.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>, bp@kernel.org,
	bgardon@google.com, dave.hansen@linux.intel.com,
	dmatlack@google.com, hpa@zytor.com, kvm@vger.kernel.org,
	leitao@debian.org, linux-kernel@vger.kernel.org, maz@kernel.org,
	mingo@redhat.com, mirsad.todorovac@alu.unizg.hr,
	pawan.kumar.gupta@linux.intel.com, pbonzini@redhat.com,
	peterz@infradead.org, shahuang@redhat.com, tabba@google.com,
	tglx@linutronix.de, x86@kernel.org
Subject: Re: [BUG net-next] arch/x86/kernel/cpu/bugs.c:2935: "Unpatched
 return thunk in use. This should not happen!" [STACKTRACE]
Message-ID: <20240404134452.GDZg6u1A-mPTTRqs6d@fat_crate.local>
References: <1d10cd73-2ae7-42d5-a318-2f9facc42bbe@alu.unizg.hr>
 <20240318202124.GCZfiiRGVV0angYI9j@fat_crate.local>
 <12619bd4-9e9e-4883-8706-55d050a4d11a@alu.unizg.hr>
 <20240326101642.GAZgKgisKXLvggu8Cz@fat_crate.local>
 <8fc784c2-2aad-4d1d-ba0f-e5ab69d28ec5@alu.unizg.hr>
 <20240328123830.dma3nnmmlb7r52ic@amd.com>
 <20240402101549.5166-1-bp@kernel.org>
 <20240402133856.dtzinbbudsu7rg7d@amd.com>
 <20240403121436.GDZg1ILCn0a4Ddif3g@fat_crate.local>
 <Zg1QFlDdRrLRZchi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zg1QFlDdRrLRZchi@google.com>

On Wed, Apr 03, 2024 at 05:48:22AM -0700, Sean Christopherson wrote:
> I'm guessing a general solution for OBJECT_FILES_NON_STANDARD is needed

Yeah.

> but I have a series to drop it for vmenter.S.
>
> https://lore.kernel.org/all/20240223204233.3337324-9-seanjc@google.com

Cool, ship it.

Holler if I should test it a bit on my pile of hw.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

