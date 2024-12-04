Return-Path: <kvm+bounces-33054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 51AC39E41D1
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 18:37:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26AE9168294
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 17:37:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F1711C3C0E;
	Wed,  4 Dec 2024 17:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YyUJnVDs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656EF1C3BE2;
	Wed,  4 Dec 2024 17:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733332178; cv=none; b=DUQ9G+Sg5xmc3U/BHqliZ/GayblRN2/E3fIjjTxOsvfv9IxXBY5xAa0G8zh3vPx5teNePDuHgsS0nJk6K+d2konSUKGNW0Z0vcmz2r8kXJsduQGCqmILkY3azahIXqJd1kt0obt5SAltmlKkcljy17Fs+ApbPz1YE6TeYURApXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733332178; c=relaxed/simple;
	bh=R+x7WFjxT8S5OTA+WR7ZclGvWXKZowty7QKeX08QvPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ltUFhg4OMyCYZ3piKw/o86/H7BxzfgPsqwFJ3CpzRZ4p7aKxq78KhUcmiWsMlZc3ESahC6qp7fzh2kfoKFqeGavQEtvZqVtyefErxAv3lMBjUgsfUEaVc5gyliPZ/RhYlMTft6LzaJiMFBUV50bt1AHWiUFu0MmYGNdHBtwCCN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YyUJnVDs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1EBC4CECD;
	Wed,  4 Dec 2024 17:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733332177;
	bh=R+x7WFjxT8S5OTA+WR7ZclGvWXKZowty7QKeX08QvPM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YyUJnVDs1VRmBbkmQIUz90/t8Rv6+2Saknahn46UALUy+945ZA4TXebkEvjmgTHXd
	 mC1GR0D291GTL6kMDpaXL+sf4gUyrV21WyxTpcshpU38+lJuESQeKslzBMgYggD1uD
	 BPJ8OcUVwdjpySE4F8ebLyAysmeRKivF0Lj2NTmIMRiDiJTBO6oD2s5IBRzt2+/+I5
	 pztXK7TyO034l4oQHM8WPox43YFffvqfFXaR7xjUAVE5xMVa8hWdLpXok31ZvBBeke
	 aR0UJNRLR3M9v0G17nL75PDo8j79Jzn+vS0Ut4uxSe8e+IpvNWCJ94qzyE6bun/eB3
	 6eXdD7yZMTQ1g==
Date: Wed, 4 Dec 2024 10:09:35 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
	Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Shevchenko <andy@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Davide Ciminaghi <ciminaghi@gnudd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 09/11] x86: rework CONFIG_GENERIC_CPU compiler flags
Message-ID: <20241204170935.GB3356373@thelio-3990X>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-10-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241204103042.1904639-10-arnd@kernel.org>

Hi Arnd,

On Wed, Dec 04, 2024 at 11:30:40AM +0100, Arnd Bergmann wrote:
...
> +++ b/arch/x86/Kconfig.cpu
> +config X86_64_V1
> +config X86_64_V2
> +config X86_64_V3
...
> +++ b/arch/x86/Makefile
> +        cflags-$(CONFIG_MX86_64_V1)	+= -march=x86-64
> +        cflags-$(CONFIG_MX86_64_V2)	+= $(call cc-option,-march=x86-64-v2,-march=x86-64)
> +        cflags-$(CONFIG_MX86_64_V3)	+= $(call cc-option,-march=x86-64-v3,-march=x86-64)
...
> +        rustflags-$(CONFIG_MX86_64_V1)	+= -Ctarget-cpu=x86-64
> +        rustflags-$(CONFIG_MX86_64_V2)	+= -Ctarget-cpu=x86-64-v2
> +        rustflags-$(CONFIG_MX86_64_V3)	+= -Ctarget-cpu=x86-64-v3

There appears to be an extra 'M' when using these CONFIGs in Makefile,
so I don't think this works as is?

Cheers,
Nathan

