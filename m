Return-Path: <kvm+bounces-32760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 86EE39DBB7A
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 17:46:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2015DB2253E
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 16:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DA711BD9FB;
	Thu, 28 Nov 2024 16:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="GJyF8A+o"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988D317993
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 16:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732812404; cv=none; b=rJyJ7vP/jhigTuw3MPQb0yK2BY/p5MXavQgIwuKpeuSZG+ASJwEkXWEruKV2AImTfYIEYYiJ/AaiKP2yh4Egh1sjLr0NV1V6c+puqVMc7SgGw+84AcR6YzEWA9/gpMrQ442++Q5zO2R65q84bjpzI2edpmqAI6h1Rgmtpao3uxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732812404; c=relaxed/simple;
	bh=aSOh3A0l7EtflvEdF8vU8Q0Lw+zvLKHtu9k1Fm3RM6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aXdzF0jgsWkZzm/1IbHc0woY+SrdtsywYpav0lPM2H3J5MvbArnujReN2e/ZVUL8vJKza8kRZb+lXhkMo6ETu3jsHP/yVVkVZ81ymcOHQLuxul6QmMytTewPpvnNUymJULFoXblVmtkiEXmkwMLFrlZUQeSpW5VVqvz7381D1SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=GJyF8A+o; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6C12140E015E;
	Thu, 28 Nov 2024 16:46:39 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id QrYJmTi9r4M2; Thu, 28 Nov 2024 16:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1732812392; bh=KHBMWyOOFqGmtZziLrDCtujxKI1bdHlIUELfefYP8NU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GJyF8A+o3nrqIlPq79GfLd0VZguHPf+9Jjjn/VcIr9TWtxrq84KG/ED83yC/CrNvY
	 IC/Qf/oMGD/NNBtFsFdo2XdTxaDxtAK9ffIADqhmR31w4d298wOsTd6xb8DsUMhajY
	 qLg41KLCnN0lyDN5c/waSKZAM/dpPVB4Ub/K4XCNbLcEqnUfaDAcqaJmPRWsnhT9Q2
	 uLeONSm5ILuJkf70mPDgtH6CA5BTWaGSXl8qTsRG6CFnBCzKwtwcUq/qcDcHmbeHGd
	 QRlaZgk+D/LeO5XOSDWDSeoKsTM+oki63TBuVSlz1JIIE666EtX8y7p21++9x7XJVc
	 Ky2m0EbYnFqItPLQc6CKdIelExgXaKZwp8z7kyRT+6rVLWZxVbd0RAUdifPH5pTPJS
	 P+90H2Q5ySlYBWjDd0JDRtwHycyb565EvAVr9y8FnZRj5FuH8Lp64n2203al3TARQ7
	 K1k3JB5mFg6LAGIfHmbigICEWx0U2Dwun+avaH7AyNExQbnyqLTM13EDwWvWsZWB8E
	 aiMXGZDFkNHXzNvn4HfTgrXifa9/VO+JFYD7KvL73lTg/9mb6fEY67g+DMMz285LeY
	 BpgOzKo45I+kh+u43arF0NQzTwJhDoyRGljnZqVwt8d5nSf9Rs7IS/D4ksfPx4D3R8
	 F9+u9RF1WqD5NGFiUF9yNetI=
Received: from zn.tnic (p200300ea9736a177329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9736:a177:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7A27D40E01D6;
	Thu, 28 Nov 2024 16:46:25 +0000 (UTC)
Date: Thu, 28 Nov 2024 17:46:24 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
	pbonzini@redhat.com, jmattson@google.com, Xin Li <xin@zytor.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH 12/15] KVM: x86: Track possible passthrough MSRs in
 kvm_x86_ops
Message-ID: <20241128164624.GDZ0ieYPnoB4u39rBT@fat_crate.local>
References: <20241127201929.4005605-1-aaronlewis@google.com>
 <20241127201929.4005605-13-aaronlewis@google.com>
 <Z0eV4puJ39N8wOf9@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z0eV4puJ39N8wOf9@google.com>

On Wed, Nov 27, 2024 at 01:57:54PM -0800, Sean Christopherson wrote:
> The attached patch is compile-tested only (the nested interactions in particular
> need a bit of scrutiny) and needs to be chunked into multiple patches, but I don't
> see any obvious blockers, and the diffstats speak volumes:

I'd like to apply this and take a closer look but I don't know what it goes
against. Btw, you could point me to some documentation explaining which
branches in the kvm tree people should use to base off work ontop.

In any case, the overall idea makes sense to me - SVM and VMX both know which
MSRs should be intercepted and so on.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

