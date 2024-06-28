Return-Path: <kvm+bounces-20631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77F5B91B684
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 07:48:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C64F2834D0
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 05:48:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3765B4645B;
	Fri, 28 Jun 2024 05:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="d/Pz2trK"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CCE4CE04;
	Fri, 28 Jun 2024 05:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719553713; cv=none; b=YNYj0gttlZrFfVsVsQycklI/fFtc/Lkqc61tb2KgapI/VMbLofVB6kPx84Tx/5mo6V5QIbA7rJ9vv8iXqbr5+6I9YZ40zzveKT5MHV6QtUwcCwIAsB7Vz7ybo2JWVcwzMux60pXP2hewvfmgqEfOgyZ2DqBv1Rdorqc7GoFaeDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719553713; c=relaxed/simple;
	bh=Q7WKdA+hXAXxgy3HlHSu/1B6QEXdSV/MXBkZGhnG1mc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T5jlFfkjJeRrRk+To+BApqaKb7XWK0PHwZKPWvVBmb+MgZwq1SnZoAn9ViZ2sbf3hBKFUoKq9PQxh/xyZr8JVKCL1b0RiwWCLPrgMRqtUCSRCtCAHPYRj0Beyp51rmTbIg6fjIp4xxmrRCc7ocj415jRS6Of+t4elcZ0vIBXIjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=d/Pz2trK; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id CE13340E0027;
	Fri, 28 Jun 2024 05:48:25 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id wjRQb-ly-jwM; Fri, 28 Jun 2024 05:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1719553702; bh=1KU5WjFQ9OJnMvH5xK9i0KmW4ZpX/9vw0VqmKD1BVww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d/Pz2trKsApd/38kYUe3Xe8yY7jGH5jrB6FRDgJ0at3d5icC02X1q0QdnNUd1fzQ/
	 6QifQubLf5X7Vl4+HddBG7IEbEPMUdy26xm4YOxeAVzZHhTZj/Er0Cqy5DlMQnN4xd
	 ENo3dJhiA45BVtezOI1O6DVKz4sEIpqfyyxYjGwpIX6ACiNNKHcAfcihLX5C9gBoKy
	 VUayowiGzw/JoMtzXzwsSuWDH94fN/0+mZs4c5pXBsKR8FNHSPeCYiXMug6FHKbM7J
	 2Nr8knj31IEjNETCvb71aMHl8PXP5C0myYk9WOb2XTvV004gBOcS0JA9I9RJ+YwNPU
	 FLOvu1j+u2LyOj5cvvi1YB3GdG3l43mgQ0IOzQo8/p1HCml1Fa5S5y6cbNri69rKx9
	 IAzDPt4DdlbJvv6QF0Jpvt2Vz6hE6uiN/q+bM14unFUQrz3Xt4I8oNEZAT3SEMypNE
	 DADh1QKBVUgAwlRTyvOn3uhXUNlSN564mymnM6CGGu09EklqKix6Tlr84bGN7zdA1b
	 Hl/N8BaKGElBGh774HtuNszd8OnqNuGyiSYITHlK7KX3YWzevtfkSIf+yaeWoRqffj
	 gKkMGDfrHPlI2RP2KHBNkb639KruVP9noEcaDOS/DTfZstqZBuUr8zeh0pnfCFrE/d
	 Ht9/tFRpGOgXVHIkL36vx/LA=
Received: from nazgul.tnic (unknown [24.134.159.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A4D8040E0192;
	Fri, 28 Jun 2024 05:48:11 +0000 (UTC)
Date: Fri, 28 Jun 2024 07:48:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v10 06/24] virt: sev-guest: Simplify VMPCK and sequence
 number assignments
Message-ID: <20240628054831.GAZn5Or1GyxAzAdqt0@fat_crate.local>
References: <20240621123903.2411843-1-nikunj@amd.com>
 <20240621123903.2411843-7-nikunj@amd.com>
 <20240625170450.GMZnr4surYmBPd94lC@fat_crate.local>
 <97f596b5-5ced-867f-5246-03345d06bed6@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <97f596b5-5ced-867f-5246-03345d06bed6@amd.com>

On Fri, Jun 28, 2024 at 09:55:28AM +0530, Nikunj A. Dadhania wrote:
> Yes, changed in following patch 07/24. Do you want me to pull those
> changes to this patch ?

Nah, not needed.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

