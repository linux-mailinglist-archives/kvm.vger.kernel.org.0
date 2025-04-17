Return-Path: <kvm+bounces-43585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E56F8A9229C
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 18:22:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B15B3ADEF6
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 16:22:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59A6F2550A9;
	Thu, 17 Apr 2025 16:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oNd4GsPZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F17D253944;
	Thu, 17 Apr 2025 16:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744906933; cv=none; b=b0b03E6n+kaSZjfLyL8sWrcPT0AjW1DX0lsKF9zzW3TBtMVTshypWS2Je/0iCrXGFrOfHYQ+Hc7MI7qPqGwtlinkxe+wdvaRQdPr3LS1cb9RVJ5osnfjeexFP6nDKRNsyLSkKgoKKt5T+m7aLnUkQh/aWcb5yrj5Idcw7R8K8ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744906933; c=relaxed/simple;
	bh=IEgK1tW/LHVNdFPh7WZchJgxvhcvbGcpPiR4a+OZMI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bZg0kHMw/bNsCLx8wyfoLi+V6OvWdioqPyR3+Va7Mc03DYyjKB7c8RigBVsdY4rSjqSzUAuPXpRrIv+zBLv3LLvyDPX9SiHlOKxr/ZKkk+/r5U+ZNEaoYrobFMvxgtilQmoCw/mT/ZZASv8hsJQFXse66xcf6xXq/Vd0a3IYNOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oNd4GsPZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D06C4CEEA;
	Thu, 17 Apr 2025 16:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744906932;
	bh=IEgK1tW/LHVNdFPh7WZchJgxvhcvbGcpPiR4a+OZMI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oNd4GsPZUeIRccS0guF6X8k3xQ+Dz7BP1np/J1HfbMLybAs+aFxAdb49IATl+gDxG
	 DSLr/DR4ChIoo2Xzx45NxoUjdvJp6gq1E3rEjK2IM5OZo4GuWic+S8D9jJVJYJtq+Q
	 vn9tmesCE4GU8Hrs58pr5kkn+PLTYz/wyNA5wK7hcxmpe2dA4FvJUJWxIu1iX3K4ZO
	 6PPW/cX+NZy+Agxt+H8s42xM8Af0KkszSknhksc33AddxXGry2En2U3BxDpiiLpT9A
	 GDg/3HCtMeMtlsNCq3A9moL78Fyz6OChXRy2db5+9pdsR7MpzDkRnEBYNYEW0LmNRU
	 eam/vyZ31yEpg==
Date: Thu, 17 Apr 2025 09:22:06 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andy Shevchenko <andy@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Davide Ciminaghi <ciminaghi@gnudd.com>,
	Ingo Molnar <mingo@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86/e820: discard high memory that can't be addressed by
 32-bit systems
Message-ID: <20250417162206.GA104424@ax162>
References: <Z_rDdnlSs0rts3b9@gmail.com>
 <20250413080858.743221-1-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250413080858.743221-1-rppt@kernel.org>

Hi Mike,

On Sun, Apr 13, 2025 at 11:08:58AM +0300, Mike Rapoport wrote:
...
>  arch/x86/kernel/e820.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index 57120f0749cc..5f673bd6c7d7 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -1300,6 +1300,14 @@ void __init e820__memblock_setup(void)
>  		memblock_add(entry->addr, entry->size);
>  	}
>  
> +	/*
> +	 * 32-bit systems are limited to 4BG of memory even with HIGHMEM and
> +	 * to even less without it.
> +	 * Discard memory after max_pfn - the actual limit detected at runtime.
> +	 */
> +	if (IS_ENABLED(CONFIG_X86_32))
> +		memblock_remove(PFN_PHYS(max_pfn), -1);
> +
>  	/* Throw away partial pages: */
>  	memblock_trim_memory(PAGE_SIZE);

Our CI noticed a boot failure after this change as commit 1e07b9fad022
("x86/e820: Discard high memory that can't be addressed by 32-bit
systems") in -tip when booting i386_defconfig with a simple buildroot
initrd.

  $ make -skj"$(nproc)" ARCH=i386 CROSS_COMPILE=i386-linux- mrproper defconfig bzImage

  $ curl -LSs https://github.com/ClangBuiltLinux/boot-utils/releases/download/20241120-044434/x86-rootfs.cpio.zst | zstd -d >rootfs.cpio

  $ qemu-system-i386 \
      -display none \
      -nodefaults \
      -M q35 \
      -d unimp,guest_errors \
      -append 'console=ttyS0 earlycon=uart8250,io,0x3f8' \
      -kernel arch/x86/boot/bzImage \
      -initrd rootfs.cpio \
      -cpu host \
      -enable-kvm \
      -m 512m \
      -smp 8 \
      -serial mon:stdio
  [    0.000000] Linux version 6.15.0-rc1-00177-g1e07b9fad022 (nathan@ax162) (i386-linux-gcc (GCC) 14.2.0, GNU ld (GNU Binutils) 2.42) #1 SMP PREEMPT_DYNAMIC Thu Apr 17 09:02:19 MST 2025
  [    0.000000] BIOS-provided physical RAM map:
  [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
  [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
  [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
  [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001ffdffff] usable
  [    0.000000] BIOS-e820: [mem 0x000000001ffe0000-0x000000001fffffff] reserved
  [    0.000000] BIOS-e820: [mem 0x00000000b0000000-0x00000000bfffffff] reserved
  [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
  [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
  [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
  [    0.000000] earlycon: uart8250 at I/O port 0x3f8 (options '')
  [    0.000000] printk: legacy bootconsole [uart8250] enabled
  [    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
  [    0.000000] APIC: Static calls initialized
  [    0.000000] SMBIOS 2.8 present.
  [    0.000000] DMI: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
  [    0.000000] DMI: Memory slots populated: 1/1
  [    0.000000] Hypervisor detected: KVM
  [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
  [    0.000000] kvm-clock: using sched offset of 196444860 cycles
  [    0.000589] clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
  [    0.002401] tsc: Detected 2750.000 MHz processor
  [    0.003126] last_pfn = 0x1ffe0 max_arch_pfn = 0x100000
  [    0.003728] MTRR map: 4 entries (3 fixed + 1 variable; max 19), built from 8 variable MTRRs
  [    0.004664] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT
  [    0.007149] found SMP MP-table at [mem 0x000f5480-0x000f548f]
  [    0.007802] No sub-1M memory is available for the trampoline
  [    0.008435] Failed to release memory for alloc_low_pages()
  [    0.008438] RAMDISK: [mem 0x1fa5f000-0x1ffdffff]
  [    0.009571] Kernel panic - not syncing: Cannot find place for new RAMDISK of size 5771264
  [    0.010486] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.15.0-rc1-00177-g1e07b9fad022 #1 PREEMPT(undef)
  [    0.011601] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
  [    0.012857] Call Trace:
  [    0.013135]  dump_stack_lvl+0x43/0x58
  [    0.013555]  dump_stack+0xd/0x10
  [    0.013919]  panic+0xa5/0x221
  [    0.014252]  setup_arch+0x86f/0x9f0
  [    0.014650]  ? vprintk_default+0x29/0x30
  [    0.015089]  start_kernel+0x4b/0x570
  [    0.015487]  i386_start_kernel+0x65/0x68
  [    0.015919]  startup_32_smp+0x151/0x154
  [    0.016344] ---[ end Kernel panic - not syncing: Cannot find place for new RAMDISK of size 5771264 ]---

At the parent change with the same command, the boot completes fine.

  [    0.000000] Linux version 6.15.0-rc1-00176-gd466304c4322 (nathan@ax162) (i386-linux-gcc (GCC) 14.2.0, GNU ld (GNU Binutils) 2.42) #1 SMP PREEMPT_DYNAMIC Thu Apr 17 09:00:12 MST 2025
  [    0.000000] BIOS-provided physical RAM map:
  ...
  [    0.000000] earlycon: uart8250 at I/O port 0x3f8 (options '')
  [    0.000000] printk: legacy bootconsole [uart8250] enabled
  [    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
  [    0.000000] APIC: Static calls initialized
  [    0.000000] SMBIOS 2.8 present.
  [    0.000000] DMI: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
  [    0.000000] DMI: Memory slots populated: 1/1
  [    0.000000] Hypervisor detected: KVM
  [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
  [    0.000001] kvm-clock: using sched offset of 429786443 cycles
  [    0.000806] clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
  [    0.003278] tsc: Detected 2750.000 MHz processor
  [    0.004730] last_pfn = 0x1ffe0 max_arch_pfn = 0x100000
  [    0.006220] MTRR map: 4 entries (3 fixed + 1 variable; max 19), built from 8 variable MTRRs
  [    0.009169] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT
  [    0.012840] found SMP MP-table at [mem 0x000f5480-0x000f548f]
  [    0.014310] RAMDISK: [mem 0x1fa5f000-0x1ffdffff]
  [    0.015141] ACPI: Early table checksum verification disabled
  ...
  [    0.046564] 511MB LOWMEM available.
  [    0.047421]   mapped low ram: 0 - 1ffe0000
  [    0.048431]   low ram: 0 - 1ffe0000
  [    0.049289] Zone ranges:
  [    0.049934]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
  [    0.051184]   Normal   [mem 0x0000000001000000-0x000000001ffdffff]
  [    0.053087] Movable zone start for each node
  [    0.054409] Early memory node ranges
  [    0.055513]   node   0: [mem 0x0000000000001000-0x000000000009efff]
  [    0.057411]   node   0: [mem 0x0000000000100000-0x000000001ffdffff]
  [    0.059176] Initmem setup node 0 [mem 0x0000000000001000-0x000000001ffdffff]
  ...

Is this an invalid configuration or virtual setup that is being tested
here or is there something else problematic with this change?

Cheers,
Nathan

