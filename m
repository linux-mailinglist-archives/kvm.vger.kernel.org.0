Return-Path: <kvm+bounces-43328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACD24A894BB
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 09:18:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 38C307A4583
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 07:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEA57279908;
	Tue, 15 Apr 2025 07:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cHotjH1M"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7ABB2750E4;
	Tue, 15 Apr 2025 07:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744701522; cv=none; b=irVXQotjqze9fopEws1pY1YEjr4hxynoNfyuB8xB20IIexOmHUt+u5+CowQ73PZ3JTjblngc7ACdHGEl4yOAFlvQAT8EhIgEZBSKNorM7YTxeee4wxeHaSjcKiFD/dYAErvxDD4RQwDk1+z2xL3mHQ9iD6zOWhtOkFV9P7+6rXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744701522; c=relaxed/simple;
	bh=GJLkjskX7cizH/QJtftzLj5Lofz1xtnYk99Eo9Q8FaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H87BrEXsC7wp+ZLkfov/Z023YWflSRl+cmcfDWzjy2cJcoxBStXhrMh7ITI+eO7Iy4qm6EbCuTdQL10VSlpDkjNIpPZLc73yH6FheqVAZf0iRdwBCGwew/LbU4C+Cc2HQalT60htID/TewQLfbl5dLn9jUBENPaGtCWC3EZ1NHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cHotjH1M; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E91C4CEDD;
	Tue, 15 Apr 2025 07:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744701522;
	bh=GJLkjskX7cizH/QJtftzLj5Lofz1xtnYk99Eo9Q8FaA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cHotjH1M9rXSxjx/XCV3LFBxK2vFPrs2wagedjdU+2yaquL+NG/bcny2MH4SWdu7b
	 Ws9TKHfGoXvCeEA/cTpZSqoQ0aKVKFQRACSutWQgd3Vonx4F9M3eLynRv/fqxK0tgM
	 H/21VBX6KjVBz/9K/fYOIdyxyWC1aoNEbci25/aknl3Yk5nkoW9yywK0rsa163kmZa
	 sCQi/LVx/FEUFiRn0Sn+ubrScarG4Y4josiZ3ksy+gmk4UEvKcAPvZaPAuntGEXV/r
	 hT2ZE+eoRhRL3enyVWrVlsUsslYsriiwZ+Jl6VQch2rJS0IRqvDclw1hRg7pH6F4iw
	 xDqqDulhw45FQ==
Date: Tue, 15 Apr 2025 10:18:33 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
	Arnd Bergmann <arnd@kernel.org>, Ingo Molnar <mingo@kernel.org>,
	Andy Shevchenko <andy@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Davide Ciminaghi <ciminaghi@gnudd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
	x86@kernel.org
Subject: Re: [tip: x86/urgent] x86/e820: Discard high memory that can't be
 addressed by 32-bit systems
Message-ID: <Z_4ISTuGo8VmZt9X@kernel.org>
References: <20250413080858.743221-1-rppt@kernel.org>
 <174453620439.31282.5525507256376485910.tip-bot2@tip-bot2>
 <a641e123-be70-41ab-b0ce-6710d7fd0c2d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a641e123-be70-41ab-b0ce-6710d7fd0c2d@intel.com>

On Mon, Apr 14, 2025 at 07:19:02AM -0700, Dave Hansen wrote:
> On 4/13/25 02:23, tip-bot2 for Mike Rapoport (Microsoft) wrote:
> > +	/*
> > +	 * 32-bit systems are limited to 4BG of memory even with HIGHMEM and
> > +	 * to even less without it.
> > +	 * Discard memory after max_pfn - the actual limit detected at runtime.
> > +	 */
> > +	if (IS_ENABLED(CONFIG_X86_32))
> > +		memblock_remove(PFN_PHYS(max_pfn), -1);
> 
> Mike, thanks for the quick fix! I did verify that this gets my silly
> test VM booting again.
> 
> The patch obviously _works_. But in the case I was hitting max_pfn was
> set MAX_NONPAE_PFN. The unfortunate part about this hunk is that it's
> far away from the related warning:

Yeah, my first instinct was to put memblock_remove() in the same 'if',
but there's no memblock there yet :)
 
> >         if (max_pfn > MAX_NONPAE_PFN) {
> >                 max_pfn = MAX_NONPAE_PFN;
> >                 printk(KERN_WARNING MSG_HIGHMEM_TRIMMED);
> >         }
> 
> and it's logically doing the same thing: truncating memory at
> MAX_NONPAE_PFN.
> 
> How about we reuse 'MAX_NONPAE_PFN' like this:
> 
> 	if (IS_ENABLED(CONFIG_X86_32))
> 		memblock_remove(PFN_PHYS(MAX_NONPAE_PFN), -1);
> 
> Would that make the connection more obvious?

Yes, that's better. Here's the updated patch:

From a235764221e4a849fa274a546ff2a3d9f15da2a9 Mon Sep 17 00:00:00 2001
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 13 Apr 2025 10:36:17 +0300
Subject: [PATCH v2] x86/e820: discard high memory that can't be addressed by
 32-bit systems

Dave Hansen reports the following crash on a 32-bit system with
CONFIG_HIGHMEM=y and CONFIG_X86_PAE=y:

  > 0xf75fe000 is the mem_map[] entry for the first page >4GB. It
  > obviously wasn't allocated, thus the oops.

  BUG: unable to handle page fault for address: f75fe000
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  *pdpt = 0000000002da2001 *pde = 000000000300c067 *pte = 0000000000000000
  Oops: Oops: 0002 [#1] SMP NOPTI
  CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.15.0-rc1-00288-ge618ee89561b-dirty #311 PREEMPT(undef)
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
  EIP: __free_pages_core+0x3c/0x74
  Code: c3 d3 e6 83 ec 10 89 44 24 08 89 74 24 04 c7 04 24 c6 32 3a c2 89 55 f4 e8 a9 11 45 fe 85 f6 8b 55 f4 74 19 89 d8 31 c9 66 90 <0f> ba 30 0d c7 40 1c 00 00 00 00 41 83 c0 28 39 ce 75 ed 8b

  EAX: f75fe000 EBX: f75fe000 ECX: 00000000 EDX: 0000000a
  ESI: 00000400 EDI: 00500000 EBP: c247becc ESP: c247beb4
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210046
  CR0: 80050033 CR2: f75fe000 CR3: 02da6000 CR4: 000000b0
  Call Trace:
   memblock_free_pages+0x11/0x2c
   memblock_free_all+0x2ce/0x3a0
   mm_core_init+0xf5/0x320
   start_kernel+0x296/0x79c
   ? set_init_arg+0x70/0x70
   ? load_ucode_bsp+0x13c/0x1a8
   i386_start_kernel+0xad/0xb0
   startup_32_smp+0x151/0x154
  Modules linked in:
  CR2: 00000000f75fe000

The mem_map[] is allocated up to the end of ZONE_HIGHMEM which is defined
by max_pfn.

Before 6faea3422e3b ("arch, mm: streamline HIGHMEM freeing") freeing of
high memory was also clamped to the end of ZONE_HIGHMEM but after
6faea3422e3b memblock_free_all() tries to free memory above the of
ZONE_HIGHMEM as well and that causes access to mem_map[] entries beyond
the end of the memory map.

Discard the memory after MAX_NONPAE_PFN from memblock on 32-bit systems
so that core MM would be aware only of actually usable memory.

Reported-by: Dave Hansen <dave.hansen@intel.com>
Tested-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/kernel/e820.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 57120f0749cc..5e6b1034e6f1 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1300,6 +1300,13 @@ void __init e820__memblock_setup(void)
 		memblock_add(entry->addr, entry->size);
 	}
 
+	/*
+	 * Discard memory above 4GB because 32-bit systems are limited to 4GB
+	 * of memory even with HIGHMEM.
+	 */
+	if (IS_ENABLED(CONFIG_X86_32))
+		memblock_remove(PFN_PHYS(MAX_NONPAE_PFN), -1);
+
 	/* Throw away partial pages: */
 	memblock_trim_memory(PAGE_SIZE);
 
-- 
2.47.2

-- 
Sincerely yours,
Mike.

