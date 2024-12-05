Return-Path: <kvm+bounces-33134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60D979E5599
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 13:35:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20425282F34
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 12:35:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97A2F1D9A7E;
	Thu,  5 Dec 2024 12:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="K1pz2Rxr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27D1203718;
	Thu,  5 Dec 2024 12:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733402129; cv=none; b=FxuxZo+lEZg9bQqxcTx7/zJAhKUgtZ56xaUnxilK8cQRWGYg/IOh1GqX/WMhaThi/ZYOWD+gWc1LC9/y0zkCUZILky9Y8+BvTQlOLLYqSG/KjfJXz2IB7OgnJM+77PEdT1jwo/dTyVhc749aZegej7fkHKEsKed2vxVC0yswGtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733402129; c=relaxed/simple;
	bh=sMA6Xych+cRnY38lt0wEi/0I/8ZE/i/cFqvtQMrF8SY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HDJ9ZWwZLd8OgzIT4G3DS0uWUzRBdNislw6u723zUhv0XuSaREVfvrWGQMdLdpVmZRldo93lY+tmZ1i7eRs02Rq+6ecfhSNG4C+iT0Vaa014+mUn/OWKGHRV++q6P4p0xD5+rXgnWoyS2/fPQgsFG46K9pOoBa54XSC+9Us0H1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=K1pz2Rxr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85499C4CED1;
	Thu,  5 Dec 2024 12:35:25 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="K1pz2Rxr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1733402124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sMA6Xych+cRnY38lt0wEi/0I/8ZE/i/cFqvtQMrF8SY=;
	b=K1pz2Rxrrd/WpoVMeBb0VES7uL/oAWJCl+9N6IeSiR6iUKq00AJgFB/A2KcCAWyDxIm+Vi
	TFY0/o7MuBBUE+z7Ied0NqLm4VdlUD4J01qjHlZIKp24PhraLE1i3SzDXC+9Fa0766Q0Wb
	VQ3bQ06316UsklfmTSQASI/pmK2SC14=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3037247a (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 5 Dec 2024 12:35:23 +0000 (UTC)
Date: Thu, 5 Dec 2024 13:35:19 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Shevchenko <andy@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arnd Bergmann <arnd@kernel.org>, linux-kernel@vger.kernel.org,
	x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Matthew Wilcox <willy@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Davide Ciminaghi <ciminaghi@gnudd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	sultan@kerneltoast.com
Subject: Re: [PATCH 09/11] x86: rework CONFIG_GENERIC_CPU compiler flags
Message-ID: <Z1GdxrjBpn2Nu1vu@zx2c4.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-10-arnd@kernel.org>
 <CAHk-=wh_b8b1qZF8_obMKpF+xfYnPZ6t38F1+5pK-eXNyCdJ7g@mail.gmail.com>
 <d189f1a1-40d4-4f19-b96e-8b5dd4b8cefe@app.fastmail.com>
 <CAHk-=wji1sV93yKbc==Z7OSSHBiDE=LAdG_d5Y-zPBrnSs0k2A@mail.gmail.com>
 <Z1FgxAWHKgyjOZIU@smile.fi.intel.com>
 <74e8e9c6-8205-413a-97a4-aae32042c019@app.fastmail.com>
 <Z1GLrISQEaXelzqu@smile.fi.intel.com>
 <1f2ad273-f3a5-4d16-95a4-b8d960410917@app.fastmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1f2ad273-f3a5-4d16-95a4-b8d960410917@app.fastmail.com>

On Thu, Dec 05, 2024 at 12:58:22PM +0100, Arnd Bergmann wrote:
> As I said earlier, I don't think we should offer the 'native'
> option for 32-bit targets at all. For 64-bit, we either decide
> it's a user error to enable -march=native, or change it to
> -mtune=native to avoid the problem.

I've been building my laptop's kernel with -march=native for years, and
I'd be happy if this capability were upstream.

Jason

