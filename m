Return-Path: <kvm+bounces-43187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E338EA86BDB
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 10:40:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E54F8C0996
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 08:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D580619DF5B;
	Sat, 12 Apr 2025 08:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VoHQnj6K"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011201632C8;
	Sat, 12 Apr 2025 08:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744447192; cv=none; b=lB1HzILEcoom3D75wmzz9gsIGQQcnaMowftV473C8rOAGSkuUFhtWY/fArxnb5YsXTq3l63SLaAWh9h3MTXuI0Cgeg112kUAq8hlYT0HNBNhl5HAwv6KsokRZ+bj+X4I5uCHupeiOPR1a1u2LZYESirb9M4fPZZ/rV/v4hcZfGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744447192; c=relaxed/simple;
	bh=p+NZrCyufs8TawZDNBCmnM+bhj0M44SjnbBW1hof8qc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZU+2X/nL7zWGgkibv3A3r9ZJ9m38ZlEuF0UizG6OUe8+2zHhyDxRT4Rys0meJWwb8aSovJ4n2j1rXdFG4Ok3SgnFy5qbXqAxfeI7b6ua8I5t/ufeAku3ZZHbAjhkx5PP4oIrMIJY1BVJLDT4hX0+S1pJy2Op/fCK2Ztrv++Y/ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VoHQnj6K; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6781AC4CEE3;
	Sat, 12 Apr 2025 08:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744447191;
	bh=p+NZrCyufs8TawZDNBCmnM+bhj0M44SjnbBW1hof8qc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VoHQnj6Kz1+zTykA2Zo8USYmi4bibd9QxIcHCdiQtRC/HXjtWsoRhcMg56hAuq2YD
	 Mo4c8F7GMQ/YiDW68+k01BEJmmLTlXYryaJW2VSAw/MZyPsfpmrlNgcLK46RDOn1ec
	 4mYBFvyg2FD2f+s80Y7vgQ6R87oNpKYxIJNJkHJdDXj/ehLJgZSzZpOocMVKMG3vzZ
	 rTtxJ4Avq0HfRzrKtME3FMrL/n654xeTE824ZfRJM44uAOPcROZA4u/TDv82WGjJXL
	 3FfA0Fbct0CxOGxXkrj92Zplq1i2084r92weItalBK9eK2S4B0QFQc8C4EUj2XwpXy
	 9VLnQRfbYbHJA==
Date: Sat, 12 Apr 2025 10:39:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Arnd Bergmann <arnd@kernel.org>, linux-kernel@vger.kernel.org,
	x86@kernel.org, Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Shevchenko <andy@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Davide Ciminaghi <ciminaghi@gnudd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH 05/11] x86: remove HIGHMEM64G support
Message-ID: <Z_om0KMBqtbq7g0_@gmail.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-6-arnd@kernel.org>
 <08b63835-121d-4adc-8f03-e68f0b0cabdf@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08b63835-121d-4adc-8f03-e68f0b0cabdf@intel.com>


* Dave Hansen <dave.hansen@intel.com> wrote:

> Has anyone run into any problems on 6.15-rc1 with this stuff?
> 
> 0xf75fe000 is the mem_map[] entry for the first page >4GB. It 
> obviously wasn't allocated, thus the oops. Looks like the memblock 
> for the >4GB memory didn't get removed although the pgdats seem 
> correct.
> 
> I'll dig into it some more. Just wanted to make sure there wasn't a 
> fix out there already.

Not that I'm aware of.

> The way I'm triggering this is booting qemu with a 32-bit PAE kernel, 
> and "-m 4096" (or more).

That's a new regression indeed.

Thanks,

	Ingo

