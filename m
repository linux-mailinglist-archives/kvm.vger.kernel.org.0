Return-Path: <kvm+bounces-37917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFB44A316E7
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 21:51:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4E8A3A3F4E
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 20:51:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7D062641CB;
	Tue, 11 Feb 2025 20:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="gk9Urs80"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99021EE7DC;
	Tue, 11 Feb 2025 20:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739307094; cv=none; b=HPv9hfHasIwwbmVaBLZphzAxLBIiNOgl++YEKOvcMXft3xZKWgnLdkmsL14YHCrfDDav40noHUSETbuu4pNGyyE1iyi8Iko38JzKz1RbuXCA06J6D1uE1UQeoK/4wctw84bAwUBP+0/RPBz+NeZvtwRF8IqW2mXRl3boavPjALY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739307094; c=relaxed/simple;
	bh=oF97RN+QYIbXaZVag4m8/l3cmZmzYmJ0Man1X/uZI4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tp9F/COTCKhBGSkynE/8R1Znp5M8PN8qCN10M3Eonxx80Ggw0EaHQUVNltB8Hdh3J/bX0g8DecH3hp2UnU5VXJqpObit25YtW0FLSjSd8mrsFZxagxaFSpDuIZQnzaCWj6U0l2VswiFN67blsmEwhiQvGxlmfR7qe1vQtr23ajw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=gk9Urs80; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E441540E01A3;
	Tue, 11 Feb 2025 20:51:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 0XL7F3RpwsX7; Tue, 11 Feb 2025 20:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1739307087; bh=MJdjOZab43bqqhooT97hKZ7nWPaECw9SFU7z5Mg1ViI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gk9Urs80qEa2oToYP2ui0U73ibG0d2QFdvOxuygaIcoYjZ8ML9nj0I2xysWFXxs3R
	 4yhfgQW6PIS/FQMKLLcdHe6UD0220lFHrBTa4scVOBeaGYCuLGAtGvtC9ocZxwViCd
	 kLtWKnKhfBU9I48zypW33DdeGb7N/AC1Jz30GfHobpR8JgNxAk35CdYSfAH1bR8IYc
	 k3AZ3WPsgVWtZprDpm0oofKLOn4OlWSs5qpNlgQ7mxr12j8LZ1FdI6208nbLW8WEgO
	 DDtW4PEIyjEoiUIj7MwXgy4zJH0RneWX4JLuFbkouWJ+8JMxKkYkwXz7B59xBB7QGK
	 Pc6bWBaV9Ktzzlz6/aNi6YEtL4EnJuhlIlMUbVCHahzzGKJ6ViEMUIN6MckHGcEX+W
	 GTV8rRPDLefgUw75YEgJJsyrcFqSsqTTytvqtREeJUmJVWQNl+Ob5I2Y/8m3tAf/9g
	 AHEcFbSOxDZu19Wm9q+oKN+oYgpUIOeNMvDT9PD7tzIpJh8eQLgQ2FSu+MIWvNO5zi
	 l5OmrCXGagiwwrZpDbZUjmxe6rDIVTxZThGCKvsD+BfNnp8YLUElBy2WNs307IuWKN
	 H41PGOwC7K9CIR+bMoGYUBKunmPp2/gEsL5MDMrCeukeva5bTGdIGoMrbL5HkapBB3
	 CXr2KOAG9VjyAOQ980vuoqKA=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DD39F40E01A0;
	Tue, 11 Feb 2025 20:51:15 +0000 (UTC)
Date: Tue, 11 Feb 2025 21:51:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	Yosry Ahmed <yosryahmed@google.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20250211205110.GIZ6u4PokpHTfKfz6r@fat_crate.local>
References: <Z36zWVBOiBF4g-mW@google.com>
 <20250108181434.GGZ37AiioQkcYbqugO@fat_crate.local>
 <20250111125215.GAZ4Jpf6tbcoS7jCzz@fat_crate.local>
 <Z4qnzwNYGubresFS@google.com>
 <20250118152655.GBZ4vIP44MivU2Bv0i@fat_crate.local>
 <Z5JtbZ-UIBJy2aYE@google.com>
 <20250123170149.GCZ5J1_WovzHQzo0cW@fat_crate.local>
 <Z5KEoepANyswViO_@google.com>
 <20250124125843.GBZ5OOg3rWBd9pY3Bx@fat_crate.local>
 <CALMp9eQarOhpNkw6WCWOvh_fcHg9846sEo7fAOEoAtKRDA7kSQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALMp9eQarOhpNkw6WCWOvh_fcHg9846sEo7fAOEoAtKRDA7kSQ@mail.gmail.com>

On Tue, Feb 11, 2025 at 11:19:25AM -0800, Jim Mattson wrote:
> What is the performance impact of BpSpecReduce on Turin?

See upthread:

https://lore.kernel.org/all/20241216173142.GDZ2Bj_uPBG3TTPYd_@fat_crate.local

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

