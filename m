Return-Path: <kvm+bounces-43197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 49BE7A86F33
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 21:48:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3DA20189EE60
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 19:48:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EAF0221725;
	Sat, 12 Apr 2025 19:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c1GpG0Zg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BC926AE4;
	Sat, 12 Apr 2025 19:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744487293; cv=none; b=TPKz7KiIqNj9xPjuf0YiFL74MBe9vskl4rf3lTmVic41K9MEHU7mtTjFKhiXf6q9nxoqxRj7cZ9xSPMEGKJ9qqQa7MMPRTWKgZq7izfBEt4UNomSyWGOXOBQOAtOV+ycdxA3QCoKaLczwkfLqqlDmCdc/NUSBtx4cXwaaqUJl/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744487293; c=relaxed/simple;
	bh=tidewq6Pm9Tm8u2xZt8A3sCPNevnitgMH0YXOfmz+Rc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NzfEHI0HXdm0PMEMuZ67xX38lXnRy79d5q8/WnXwZrEdywc0+EL203pBkwt3yTpe5rrcmN3TadTuUZfSJsOEMTEZDUS3AFpnzVfdVhtVmtVW3lnGX2WhgGe/GkztxZx2hao4oK5tsFcw11njo7Pt8D0ryoH8ib/b5kRAo9frKEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c1GpG0Zg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C12FC4CEE3;
	Sat, 12 Apr 2025 19:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744487293;
	bh=tidewq6Pm9Tm8u2xZt8A3sCPNevnitgMH0YXOfmz+Rc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c1GpG0Zg9V+Y4P+40FpJSt176TFdO7YjmltC/KE8CeoAUUgQE7ZJG+83m2bAfHSX3
	 hjxOYWh8TQ/vYlJkPEtW2iQfIm1Z+3TqQ2SZ4sLofGhVGCFyNYoLU5h4+8sNHc9GbU
	 cNT8GanKEgaOz1wb5Bhbu3KT+H0i8Q6JWXQ7URE6RLUoSddcoGL94TlA32uYpFsqYE
	 dBBSF6QlJ8dCk0b2c0OTCmsSKd+Pz+gLCcxl7G9ILiN6KgVcMMqSf9CVig+4OlkZ9u
	 0MYKTWPRCjXq7Sss5628hIqC3GoxbhguC2ApdLKi5TBd3CHdjtdRuYzUF5Zy0ZhdpH
	 IiPBU4Pl/zWUQ==
Date: Sat, 12 Apr 2025 21:48:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@kernel.org>,
	linux-kernel@vger.kernel.org, x86@kernel.org,
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
Subject: Re: [PATCH 05/11] x86: remove HIGHMEM64G support
Message-ID: <Z_rDdnlSs0rts3b9@gmail.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-6-arnd@kernel.org>
 <08b63835-121d-4adc-8f03-e68f0b0cabdf@intel.com>
 <Z_o7B_vDPRL03iSN@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_o7B_vDPRL03iSN@kernel.org>


* Mike Rapoport <rppt@kernel.org> wrote:

> On Fri, Apr 11, 2025 at 04:44:13PM -0700, Dave Hansen wrote:
> > Has anyone run into any problems on 6.15-rc1 with this stuff?
> > 
> > 0xf75fe000 is the mem_map[] entry for the first page >4GB. It obviously
> > wasn't allocated, thus the oops. Looks like the memblock for the >4GB
> > memory didn't get removed although the pgdats seem correct.
> 
> That's apparently because of 6faea3422e3b ("arch, mm: streamline HIGHMEM
> freeing"). 
> Freeing of high memory was clamped to the end of ZONE_HIGHMEM which is 4G
> and after 6faea3422e3b there's no more clamping, so memblock_free_all()
> tries to free memory >4G as well.
>  
> > I'll dig into it some more. Just wanted to make sure there wasn't a fix
> > out there already.
> 
> This should fix it.
> 
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index 57120f0749cc..4b24c0ccade4 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -1300,6 +1300,8 @@ void __init e820__memblock_setup(void)
>  		memblock_add(entry->addr, entry->size);
>  	}
>  
> +	memblock_remove(PFN_PHYS(max_pfn), -1);
> +
>  	/* Throw away partial pages: */
>  	memblock_trim_memory(PAGE_SIZE);

Mind sending a full patch with changelog, SOB, Ard's Tested-by, Dave's 
Reported-by, etc.?

Thanks,

	Ingo

