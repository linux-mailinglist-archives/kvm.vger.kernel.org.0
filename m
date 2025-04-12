Return-Path: <kvm+bounces-43188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A3F45A86C59
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 12:06:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 937A7173D29
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 10:06:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9954A1B87E1;
	Sat, 12 Apr 2025 10:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T3KzdjyF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD971DDAB;
	Sat, 12 Apr 2025 10:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744452368; cv=none; b=L+h4AVKhDco0XrRZxCQEk6gfV+VOq5CRy0m6j3Xkopn1lfS7vBbz3iFZ3BOahLafAm3PzXaFZaATXplUoZi+cHuki+G90JxNVMJgU+N2CiCVt8Fhh63qafDbAiIJBLk6qQP/ugDvUi388ma0NpJj7DbceTqGoRO4gygTx0KbjVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744452368; c=relaxed/simple;
	bh=byn6WhbuFoDaP2oLGt/+qjLTmY6pSiADFCTzFQL0COw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qOPISUgFWcHEtMDstVqdw4KMOSjO5MQp7LZbTo1FEfsFsyS0IV4n+9/w/LbYOqQ0UD+O+ciRCD6LI7nJN2PewoHTCihbODaBd1ifx16gpS0Pu1mP+boW9f+6/wo+QwGjksnb27infJRa9soFSPXPZg12qHA4Wvzaal0xwsCOPEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T3KzdjyF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008B8C4CEE3;
	Sat, 12 Apr 2025 10:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744452368;
	bh=byn6WhbuFoDaP2oLGt/+qjLTmY6pSiADFCTzFQL0COw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T3KzdjyFVGv0bCND99+HcoMmhojVQqELvkByMlM2nnsjpoOO5N7hrC8thOO15ihpS
	 GDrPHglrxRPd4LGG+43nd4rxnwp7YzQWUqAVaFv/MaQkMqyRFJtAsmIxlp+Sb7YKT6
	 1NRfYFrHyDWJ231iF4z8THYLSHKJjiBLySHoqZbtRPG6mCuUEUoErCHF86VoieSLho
	 pzNFuC7qzYloq2bLIM+q9ZoUfSf9TJwoNkPVcXxNdpU91+8KOnCT+dQSbsm3QJXiyX
	 d0KZSXz20Qi2TfjOBam8gNtee8uGpwasn92US5H/WE3JvSxylSvwxN/WkbcrzeYGUE
	 y5QnSoB81TAiA==
Date: Sat, 12 Apr 2025 13:05:59 +0300
From: Mike Rapoport <rppt@kernel.org>
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
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 05/11] x86: remove HIGHMEM64G support
Message-ID: <Z_o7B_vDPRL03iSN@kernel.org>
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

On Fri, Apr 11, 2025 at 04:44:13PM -0700, Dave Hansen wrote:
> Has anyone run into any problems on 6.15-rc1 with this stuff?
> 
> 0xf75fe000 is the mem_map[] entry for the first page >4GB. It obviously
> wasn't allocated, thus the oops. Looks like the memblock for the >4GB
> memory didn't get removed although the pgdats seem correct.

That's apparently because of 6faea3422e3b ("arch, mm: streamline HIGHMEM
freeing"). 
Freeing of high memory was clamped to the end of ZONE_HIGHMEM which is 4G
and after 6faea3422e3b there's no more clamping, so memblock_free_all()
tries to free memory >4G as well.
 
> I'll dig into it some more. Just wanted to make sure there wasn't a fix
> out there already.

This should fix it.

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 57120f0749cc..4b24c0ccade4 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1300,6 +1300,8 @@ void __init e820__memblock_setup(void)
 		memblock_add(entry->addr, entry->size);
 	}
 
+	memblock_remove(PFN_PHYS(max_pfn), -1);
+
 	/* Throw away partial pages: */
 	memblock_trim_memory(PAGE_SIZE);
 
> The way I'm triggering this is booting qemu with a 32-bit PAE kernel,
> and "-m 4096" (or more).
> 
> > [    0.003806] Warning: only 4GB will be used. Support for for CONFIG_HIGHMEM64G was removed!
> ...
> > [    0.561310] BUG: unable to handle page fault for address: f75fe000
> > [    0.562226] #PF: supervisor write access in kernel mode
> > [    0.562947] #PF: error_code(0x0002) - not-present page
> > [    0.563653] *pdpt = 0000000002da2001 *pde = 000000000300c067 *pte = 0000000000000000 
> > [    0.564728] Oops: Oops: 0002 [#1] SMP NOPTI
> > [    0.565315] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.15.0-rc1-00288-ge618ee89561b-dirty #311 PREEMPT(undef) 
> > [    0.567428] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> > [    0.568777] EIP: __free_pages_core+0x3c/0x74
> > [    0.569378] Code: c3 d3 e6 83 ec 10 89 44 24 08 89 74 24 04 c7 04 24 c6 32 3a c2 89 55 f4 e8 a9 11 45 fe 85 f6 8b 55 f4 74 19 89 d8 31 c9 66 90 <0f> ba 30 0d c7 40 1c 00 00 00 00 41 83 c0 28 39 ce 75 ed 8b 03 c1
> > [    0.571943] EAX: f75fe000 EBX: f75fe000 ECX: 00000000 EDX: 0000000a
> > [    0.572806] ESI: 00000400 EDI: 00500000 EBP: c247becc ESP: c247beb4
> > [    0.573776] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210046
> > [    0.574606] CR0: 80050033 CR2: f75fe000 CR3: 02da6000 CR4: 000000b0
> > [    0.575464] Call Trace:
> > [    0.575816]  memblock_free_pages+0x11/0x2c
> > [    0.576392]  memblock_free_all+0x2ce/0x3a0
> > [    0.576955]  mm_core_init+0xf5/0x320
> > [    0.577423]  start_kernel+0x296/0x79c
> > [    0.577950]  ? set_init_arg+0x70/0x70
> > [    0.578478]  ? load_ucode_bsp+0x13c/0x1a8
> > [    0.579059]  i386_start_kernel+0xad/0xb0
> > [    0.579614]  startup_32_smp+0x151/0x154
> > [    0.580100] Modules linked in:
> > [    0.580358] CR2: 00000000f75fe000
> > [    0.580630] ---[ end trace 0000000000000000 ]---
> > [    0.581111] EIP: __free_pages_core+0x3c/0x74
> > [    0.581455] Code: c3 d3 e6 83 ec 10 89 44 24 08 89 74 24 04 c7 04 24 c6 32 3a c2 89 55 f4 e8 a9 11 45 fe 85 f6 8b 55 f4 74 19 89 d8 31 c9 66 90 <0f> ba 30 0d c7 40 1c 00 00 00 00 41 83 c0 28 39 ce 75 ed 8b 03 c1
> > [    0.584767] EAX: f75fe000 EBX: f75fe000 ECX: 00000000 EDX: 0000000a
> > [    0.585651] ESI: 00000400 EDI: 00500000 EBP: c247becc ESP: c247beb4
> > [    0.586530] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210046
> > [    0.587480] CR0: 80050033 CR2: f75fe000 CR3: 02da6000 CR4: 000000b0
> > [    0.588344] Kernel panic - not syncing: Attempted to kill the idle task!
> > [    0.589435] ---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---
> 
> > [    0.561310] BUG: unable to handle page fault for address: f75fe000
> > [    0.562226] #PF: supervisor write access in kernel mode
> > [    0.562947] #PF: error_code(0x0002) - not-present page
> > [    0.563653] *pdpt = 0000000002da2001 *pde = 000000000300c067 *pte = 0000000000000000 
> > [    0.564728] Oops: Oops: 0002 [#1] SMP NOPTI
> > [    0.565315] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.15.0-rc1-00288-ge618ee89561b-dirty #311 PREEMPT(undef) 
> > [    0.567428] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> > [    0.568777] EIP: __free_pages_core+0x3c/0x74
> > [    0.569378] Code: c3 d3 e6 83 ec 10 89 44 24 08 89 74 24 04 c7 04 24 c6 32 3a c2 89 55 f4 e8 a9 11 45 fe 85 f6 8b 55 f4 74 19 89 d8 31 c9 66 90 <0f> ba 30 0d c7 40 1c 00 00 00 00 41 83 c0 28 39 ce 75 ed 8b 03 c1
> > [    0.571943] EAX: f75fe000 EBX: f75fe000 ECX: 00000000 EDX: 0000000a
> > [    0.572806] ESI: 00000400 EDI: 00500000 EBP: c247becc ESP: c247beb4
> > [    0.573776] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210046
> > [    0.574606] CR0: 80050033 CR2: f75fe000 CR3: 02da6000 CR4: 000000b0
> > [    0.575464] Call Trace:
> > [    0.575816]  memblock_free_pages+0x11/0x2c
> > [    0.576392]  memblock_free_all+0x2ce/0x3a0
> > [    0.576955]  mm_core_init+0xf5/0x320
> > [    0.577423]  start_kernel+0x296/0x79c
> > [    0.577950]  ? set_init_arg+0x70/0x70
> > [    0.578478]  ? load_ucode_bsp+0x13c/0x1a8
> > [    0.579059]  i386_start_kernel+0xad/0xb0
> > [    0.579614]  startup_32_smp+0x151/0x154
> > [    0.580100] Modules linked in:
> > [    0.580358] CR2: 00000000f75fe000
> > [    0.580630] ---[ end trace 0000000000000000 ]---
> > [    0.581111] EIP: __free_pages_core+0x3c/0x74
> > [    0.581455] Code: c3 d3 e6 83 ec 10 89 44 24 08 89 74 24 04 c7 04 24 c6 32 3a c2 89 55 f4 e8 a9 11 45 fe 85 f6 8b 55 f4 74 19 89 d8 31 c9 66 90 <0f> ba 30 0d c7 40 1c 00 00 00 00 41 83 c0 28 39 ce 75 ed 8b 03 c1
> > [    0.584767] EAX: f75fe000 EBX: f75fe000 ECX: 00000000 EDX: 0000000a
> > [    0.585651] ESI: 00000400 EDI: 00500000 EBP: c247becc ESP: c247beb4
> > [    0.586530] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210046
> > [    0.587480] CR0: 80050033 CR2: f75fe000 CR3: 02da6000 CR4: 000000b0
> > [    0.588344] Kernel panic - not syncing: Attempted to kill the idle task!
> > [    0.589435] ---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---

-- 
Sincerely yours,
Mike.

