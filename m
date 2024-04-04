Return-Path: <kvm+bounces-13568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C14378988FE
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 15:42:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFAD11C25E66
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 13:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13AC912882F;
	Thu,  4 Apr 2024 13:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="YP8YeFFC"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5378127B6A;
	Thu,  4 Apr 2024 13:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712238141; cv=none; b=ZOgKsnyQYXX3SRpJ1PVgsaYl3g8bORE62fFJb6h08fqTrvc+B8Icd+51kQDwZzhKNIfFSn3Ym/xxmqVwx3/A3JuAwd2bxeKSgvpDAdUnSCuSsxL+M0H7lCA+mmOv9wQiwBBH+aIr7IzLqRFzkyJRakbsw6hIpXz+Pkw3jQ3o76E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712238141; c=relaxed/simple;
	bh=SiFNlvNoywBWrh9dJB2VKBaVx4+zJofi44aMlEqmAas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QON9ORVgQjI4KIf/ncjRUSew+EwGutvrJ7Z3+LLNe4FduRHsuOW/bap2n+e886IV5Xr0g4VRJyWWUz2e7G2EGVhns1nlOgCi3ovBKdDeraUTmhnDGnaO9iRWpeeZetqMKKvRaPobV1d72Gi+dWwexynWhIfXKqNlF66ABKOc5zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=YP8YeFFC; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4E3BD40E0177;
	Thu,  4 Apr 2024 13:42:16 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id AG3-nPPPc-qB; Thu,  4 Apr 2024 13:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1712238132; bh=SnwD9Z8zRiZ36IaQVN6USZlKwVv26RZDYLKXu7FYw0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YP8YeFFCnpEp8rna7b+P2a0QTsBwQx6jMX+N3KUJxALwLPHkfiaNO879S246LE+Qi
	 lSN1Z/CPvCElarNeyzuv7kIOfgcYnDt0yHuTbIGM8kUH/aQDaEYbCVWRj0bQ1V83a3
	 7Xoke6VfzlxS97dIZzsvv551Fh8zXMT4hh3q3MU5TsPkh5IZJlgZw0JKlIDJVRa5DP
	 QUKLGKdEFHQI6tvIMgvUql135tHFjbPn9Bw7Ti5W2fG0BJ79/GdWan+YSKTAkVsaiS
	 srT+AypeNQm4YPoQoXYbrKzJZXglxVtIoUUdWhNbqjmPobXR8znv6ZCQV+zy4xEOwF
	 t34Mn8k+fc7kJeAmSo0/0PC+UvQ420a+4M+4LVki+m0QnTIqu0SObBj2sbPn1CjncO
	 k/y2FKDUlW36ZfV2Uor/WT6GhCZrklebwwt12N4LW2d4ccd7p9zaDcjmT/dt5+7aUz
	 qPlggv7g5VWLFnmg1M+1csCwWEqaZjhOIeeapI01UB3Em+swlCIsP5emHfHz/FFD2n
	 mgVTsYNwb4cgEjiOU2Tuo0hIUYl7Z4mW1T1ZTgJN4lJ9B3sXP/pBgJW+LdnbEMpC3G
	 TYmgsVBYdr9IBWDkaiQDbgNWGPdW3gto+R2HlJG9Y9n88xWy3sEyDG7clgEre1wErc
	 /Kg4IE6VuUmwVVvIjkCkwpZ4=
Received: from zn.tnic (p5de8ecf7.dip0.t-ipconnect.de [93.232.236.247])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2FEC440E00F4;
	Thu,  4 Apr 2024 13:41:51 +0000 (UTC)
Date: Thu, 4 Apr 2024 15:41:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc: Michael Roth <michael.roth@amd.com>, bp@kernel.org, bgardon@google.com,
	dave.hansen@linux.intel.com, dmatlack@google.com, hpa@zytor.com,
	jpoimboe@kernel.org, kvm@vger.kernel.org, leitao@debian.org,
	linux-kernel@vger.kernel.org, maz@kernel.org, mingo@redhat.com,
	pawan.kumar.gupta@linux.intel.com, pbonzini@redhat.com,
	peterz@infradead.org, seanjc@google.com, shahuang@redhat.com,
	tabba@google.com, tglx@linutronix.de, x86@kernel.org
Subject: Re: [BUG net-next] arch/x86/kernel/cpu/bugs.c:2935: "Unpatched
 return thunk in use. This should not happen!" [STACKTRACE]
Message-ID: <20240404134142.GCZg6uFh_ZSzUFLChd@fat_crate.local>
References: <1d10cd73-2ae7-42d5-a318-2f9facc42bbe@alu.unizg.hr>
 <20240318202124.GCZfiiRGVV0angYI9j@fat_crate.local>
 <12619bd4-9e9e-4883-8706-55d050a4d11a@alu.unizg.hr>
 <20240326101642.GAZgKgisKXLvggu8Cz@fat_crate.local>
 <8fc784c2-2aad-4d1d-ba0f-e5ab69d28ec5@alu.unizg.hr>
 <20240328123830.dma3nnmmlb7r52ic@amd.com>
 <20240402101549.5166-1-bp@kernel.org>
 <20240402133856.dtzinbbudsu7rg7d@amd.com>
 <f497a833-f945-4907-b916-1739324de014@alu.unizg.hr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f497a833-f945-4907-b916-1739324de014@alu.unizg.hr>

On Wed, Apr 03, 2024 at 03:43:02PM +0200, Mirsad Todorovac wrote:
> I wonder if I could make any additional contribution to the project.

I'd suggest:

https://kernel.org/doc/html/latest/process/2.Process.html#getting-started-with-kernel-development

and

https://kernel.org/doc/html/latest/process/development-process.html

which will give you a broader picture.

You could test linux-next, build random configs:

"make randconfig"

and see if you trigger a compiler warning, try to analyze it, understand
it and fix it.

It is a steep climb but it is a lot of fun. :-)

HTH.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

