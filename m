Return-Path: <kvm+bounces-25777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B5B296A4E0
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 18:54:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 014031F22316
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 16:54:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B04C18C321;
	Tue,  3 Sep 2024 16:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="iEh+Qdhe"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DB017A90F;
	Tue,  3 Sep 2024 16:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725382475; cv=none; b=aeYoChrpvU8KzIsmjIcxnwTGPfYHOX3EazPd3ICY7QunITlsOWgUorsq6S+1O/ewPR0yoNd1E2y0wXmW6enkA9vrFwX6g3L0J+A0r+nh8zlQfN+FTi1fZYP5jaDjZlurWfj3tcm70Ou11ROqJVBoUa3H3i9t9K6l05QfGiLWy3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725382475; c=relaxed/simple;
	bh=8W2FKf1mX6wOlnKqq3kseLdpAUtcbmJpAgWyIYzTOco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UDMRlVB/FFycEWruOzy6tr0LytmZpeLqumA9d3MrCJCaeTc6HIEiSp3SfWb9lxSXe3I4mycS2JunM2K1CVWkM1Wv3/6csTci34rOwZM9BtUdLwpR0ELtvRFJk2UZo49UBTzDHMeN85fHfbtYtEYMD3hRW+d9OuLkZRxWiChEHd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=iEh+Qdhe; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 61C9D40E0275;
	Tue,  3 Sep 2024 16:54:31 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 6uHhZfpwbo0n; Tue,  3 Sep 2024 16:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1725382467; bh=pYKhtjki6SeFDno2F6TDAHe/MTQ7DiBiBkBNTh+qMDY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iEh+QdheQQujp8eWR6xyHMIMIqI26xwx4REdP0K1dOLVoq5ZVZjIZDM8LPgqXKjIt
	 +51UjdOFu8cQRG9q/E8AW8HYjUS+lvHqif8zZS33UrCBdVIp1Taf4pHEeCjt4DyvZC
	 G8XXZ4GQ8unC5uTn1+t+f023dbcmwwrXAqrLEKG5LOrMbfW6b8aLjNbPAenMVmOHmb
	 UYULQ+wES+tNYhB1CrwueQdUIVxy6JM0JiHxlHuuCtJJZcb3tOsnCKmMh8K1B0Ub+u
	 p02zVIineHl5B8eTW8i+5V1xRgiQou7neqZ4J7uSs10GAW4WsCabtOpif7iP7MMclt
	 o8iWEwyjjTFUrSag7eNwY8nneI9zgxh/tQm8Bfps3ITdWOOVj97o3yyeTsrJTD6WO6
	 rmM3cMPwZ8iVdZn8vm+PeU97RLksk4gPOXit8EAX18Jp6AnzHPkDAEEuaMfHvcjsyI
	 6IFvRZHF/z3rtCYPKhcS8DHAvv+Y/3RkiRXHIsq200Ijo9wA1Og0GZooZWFYa7yR0l
	 FPWQK1pBRcFySzJx/pefP9T18dSzt4cBmS3vZNRqpPKaFsRy73JheqcA/yUGxDb0/G
	 YEFBMaL+Jbq3P5oZvKZ6Cb5UMwWfqvVGQLzK0bjhjOr5wwQ8ZbCkHK/BBpB3pay1DK
	 LFMw4yDYRpeK/Cy2PQklEtfI=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 14E8540E0198;
	Tue,  3 Sep 2024 16:54:12 +0000 (UTC)
Date: Tue, 3 Sep 2024 18:54:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
	dave.hansen@linux.intel.com, tglx@linutronix.de, mingo@redhat.com,
	x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	thomas.lendacky@amd.com, michael.roth@amd.com,
	kexec@lists.infradead.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH] x86/sev: Fix host kdump support for SNP
Message-ID: <20240903165406.GBZtc_LmcBbsGql9Dj@fat_crate.local>
References: <20240827203804.4989-1-Ashish.Kalra@amd.com>
 <87475131-856C-44DC-A27A-84648294F094@alien8.de>
 <ZtCKqD_gc6wnqu-P@google.com>
 <155cb321-a169-4a56-b0ac-940676c1e9ee@amd.com>
 <26da9c1f-3cb6-45a5-b4df-1e4838057ea4@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <26da9c1f-3cb6-45a5-b4df-1e4838057ea4@amd.com>

On Fri, Aug 30, 2024 at 04:08:35PM -0500, Kalra, Ashish wrote:
> Are you convinced with Sean's feedback here that this is a required feature to fix ?

Yes.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

