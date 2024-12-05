Return-Path: <kvm+bounces-33171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 610309E5DC2
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 18:57:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A6E318853ED
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 17:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60C05225770;
	Thu,  5 Dec 2024 17:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="cBxavDjG"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946D51922FB
	for <kvm@vger.kernel.org>; Thu,  5 Dec 2024 17:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733421427; cv=none; b=A6WHvl6SCv+sHcIBxG4QFpkpI6YlIQZeZWb75HWz0rYvFtEP7IjHL4x+z9sC6QdQN5H598TQmHxz/VEG6v+0vgvd/4evlBUiCLh7blcE2T0/iT7uCdAP3QcxzA7+cUDCUQWNs5Tkyhw14rh7WgDsO5azWAWRaWabiMdBy0huJik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733421427; c=relaxed/simple;
	bh=E9XpcUM9vA6Bi3yWNZuu5q7MoCCTVGmwfmQk975EnDM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y9nZNVrZjU5oFTAkwNCdWtL3U16LxtBg8TQf+WWrOSGlJxEUu+N0BEO6IDvmuz7MR2lb5fYMQ1MFzaIlSLfQ1OIsw0RHQFbgF6Q8VBeDpqk4mNtykUSJ/vWahj+GPhQHSFfHQfyVmCfLNq1LDVM197Fd2RDdGGRo2y6a4DgzVs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=cBxavDjG; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E002340E028B;
	Thu,  5 Dec 2024 17:57:01 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id p-iIkgcRdhUf; Thu,  5 Dec 2024 17:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733421418; bh=NjTl13Z0N1X6EkUtL9s1KelIFIMuogZDEO/xwtP1xR0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cBxavDjG3QoohFAZgacRqO2j4uA4wRRekCxVyZqUdMi5rQ+g2FptWIoMRZYROkuS4
	 SF/2c8psxFpY86R7LNz8pqeGdToEnNb4j7yAbCuyXM9Ii2BkwOBHpwPe1vUKC4p5Et
	 jzDAofLR/8LPa/esQtDQxnkDJomwrTCSELoS5duDKKT8sjtMmcEnyY26uqwKdTqEst
	 EXgxMgZUc68l/S1j7Jy+MIMtWXyA2FGRULgDXHJsVNBeJblAo7qIDABPb1g5RZyzdB
	 /IIDgqgUdkkPmzfZOB+xxAyBV5108srkBfQBtUXHV9y4Cq+IgWmpZqzck1a5WwUadk
	 OzhIL2u3Jh5O6WJg1LOoOEZBEiQnc7J2OyuEBK1mlAi7C8wsvtEUj2btdP8owWpR4d
	 hJeNQKszHfejvzH8sYZdHOME2WXFLQITJrYYf/FWN/lFFhI15BmwTQauxFeON1CIYJ
	 SXw8w/iSBjkYN5mW8LVBCCzL6j1y2aAPkyfmhvqGHXDEH114g/ke6qXEiL4bUAXXYU
	 Jyr6P+Xz+/SLUs3D3sC/XGbKoKZYzdvbif0B5/DCekwH8hCuKJRS2wbnhlJZq3UxeU
	 BGLoIhH+hrLXoiyb0JYvczYTC3G1uXNRCGGx0USDPGoFBr0kHNkCTbogmboXiVahiL
	 tCTM7L7t9NOcEQZS8WHQ/1xY=
Received: from zn.tnic (p200300Ea971F93C5329C23FFFeA6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:93c5:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5C4FB40E0269;
	Thu,  5 Dec 2024 17:56:51 +0000 (UTC)
Date: Thu, 5 Dec 2024 18:56:43 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
	pbonzini@redhat.com, jmattson@google.com, Xin Li <xin@zytor.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH 12/15] KVM: x86: Track possible passthrough MSRs in
 kvm_x86_ops
Message-ID: <20241205175643.GBZ1HpW4uCgQwRSSow@fat_crate.local>
References: <20241127201929.4005605-1-aaronlewis@google.com>
 <20241127201929.4005605-13-aaronlewis@google.com>
 <Z0eV4puJ39N8wOf9@google.com>
 <20241128164624.GDZ0ieYPnoB4u39rBT@fat_crate.local>
 <Z09gVXxfj5YedL7V@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z09gVXxfj5YedL7V@google.com>

On Tue, Dec 03, 2024 at 11:47:33AM -0800, Sean Christopherson wrote:
> For KVM x86, from Documentation/process/maintainer-kvm-x86.rst:

Thanks,  I've been looking for this text! :-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

