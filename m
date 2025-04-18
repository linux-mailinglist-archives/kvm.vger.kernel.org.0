Return-Path: <kvm+bounces-43681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D579A93E67
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 21:49:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DFC3465EEB
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 19:49:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ECB322D4F0;
	Fri, 18 Apr 2025 19:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="altnYPOM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D2FE555;
	Fri, 18 Apr 2025 19:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745005750; cv=none; b=aqLP2O0NQvUraa7L0TjddOxbKn0HdrUg8c4nPncXKn7sFVXf8dyRAOLzry1QY22/XsT6t91rRDmsBnGKGro8OcHPwYJeaWzmHNE0rz8dYnuDz9m+wXADJgKsD15PnCv1ldiHYoV24GIGVz22kwNkPrMueIM+5HjXHLhpEDuHVaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745005750; c=relaxed/simple;
	bh=8UVH/lHjMsF+dI2JW/nIoKO8Mv9Z2RQkwd7fDO5Umvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OPUj/fdkoacYZAcTNMcElVjYU4gqq7s2CqqgfiZXHXTJZ+k+iWg1VN/dncxdaA4mfgc4oI15ODn80xVO1R6lj53GyA53SbNmHNVMSR7zJcfFCvmmtUD03FVGG+1GsP4IR4F12mHvazraT6HpDmJpBll7olscAv/IkLAmJ3QExiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=altnYPOM; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-af589091049so1593671a12.1;
        Fri, 18 Apr 2025 12:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745005748; x=1745610548; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H/DP2CmiwGVI+dol2y3cXMhgIWEKYb/rbMKps9cdVa4=;
        b=altnYPOM5iu8BTaCVWIjp9G0gbHTQp3EAFUAXS/CBfvz15yptO2HeL6ZxKo/F3sfUb
         JtG+7bjyC7uKwXyBkSSgWLgk6WYTTtQ4W/rIyvW0kRogBbyxDnWMdMTl8gXHYySJBfzQ
         A9grL7uwMaDXBRX7uM/ZXT5E6lnvQ9v9/c5u6R4YI+Dtk2rP5u0FCFcVDkkPM1livMz/
         vjLL4Y5k02XajCAoHTg6GTK7WMmddwVbaZPYSJp/uYSZDRsUmCu8Edj4ZYfwVzGCGdFh
         vLEGmSeMAGAKd5NHwCHb/ECe/KuQ2AEnimmfnKJqTIsQ2CCwRMtaRMmsp5DBwkfylorW
         FYWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745005748; x=1745610548;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H/DP2CmiwGVI+dol2y3cXMhgIWEKYb/rbMKps9cdVa4=;
        b=q9oOX9FQ8PZC+DkiukNC0Q6IXB578ADnJQ/r4oVadV/ii9MAlIHAvuL99YM9Bsk4c3
         H8M7ukz5MNDGa1k+Zhg+7GK9REYpsyQXUOJJZ+TwuyP0pFmMlhROBwidMtY2eDD5h6Yy
         L3vt/k5q7GpIgztBd8MGh0/zTrEQS2DFz7iq6K7610AaQjooP60HqgcfLp6GGcsXFuFR
         qEelucZ/3k6akK504YbkqI8WPv+TGWBITYR5fmpm9WtHir7s674P1QHcTQTLXMf+oLgm
         WqB3lzW1v+BWjEEyK/ia07nlKYscaEXL4X6Ujv4/+X7dcxCXqLC0RcHgtGIciKQLAGfe
         bOEA==
X-Forwarded-Encrypted: i=1; AJvYcCUdaxgj66NiJNN0kQcvoFJMDE0WDnOVyoBKvSpyNi3Fwlg2EL+CIMPiGF5SjW6zFyR//Ls=@vger.kernel.org, AJvYcCXBJ/j2Bjjb2/HWXAt12HAKxtCmDEVHCzEkDoIf/dlp8/uPsnmaHSojuO2M0k6ebAEzWypUHEvG2w41Jrim@vger.kernel.org
X-Gm-Message-State: AOJu0YzomRXV4AUE7b7bUyryXGV0V1cj5+wgz8a4ex4fIDcL789fYRji
	fSF5iLiimQzlQcIQexr5tPDiW2GzkArzLhe9ffSzeGlcVGG8Glcy
X-Gm-Gg: ASbGnctAdcL2BRD2rjnD04IjvRndP0u262eJsZdIY/sknMi5elEslmY00ehjwHWO8Dx
	pHHsij4demo50jEdxdSStkzJw6x4Vgw0igsgL4Uj10fD9z3V6d80wh8sh+8X/ngxbB1ZF1WLqDW
	l7696CPoFRE0WWuxN/IXEGI4x4y0WZHo/+oNNxI9SYNHuk0ieshh+fqaU8wM3TXezgJiuZ8NDDn
	dI8c1DI0za/dGazjuiT3KP/3uiurfuO6pJi8UNipgV8P/L8TcuXaOV2Qiq7hDpgclzfIkB1mHTA
	6nq9zE19lpJhjhf3SkNqeIdgNGzL/bQ5iTsm1k42EqLsqJmwWEoNjmvd22OsWh41
X-Google-Smtp-Source: AGHT+IHA0GA+Al7VnclN+jkpAGrDhJ0RwYnWV0Z1lgR4ObuwxoGkI/svRRbYerRcNHMnNoXLeU4vEw==
X-Received: by 2002:a17:90b:35cc:b0:2fe:a8b1:7d8 with SMTP id 98e67ed59e1d1-3087bba1699mr5931241a91.25.1745005747988;
        Fri, 18 Apr 2025 12:49:07 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3087e0feac1sm1636629a91.33.2025.04.18.12.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Apr 2025 12:49:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 18 Apr 2025 12:49:06 -0700
From: Guenter Roeck <linux@roeck-us.net>
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
Message-ID: <ef60b9cf-1f0d-4fc1-91df-9f1c25dcd019@roeck-us.net>
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

Hi,

On Sun, Apr 13, 2025 at 11:08:58AM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Dave Hansen reports the following crash on a 32-bit system with
> CONFIG_HIGHMEM=y and CONFIG_X86_PAE=y:
> 
>   > 0xf75fe000 is the mem_map[] entry for the first page >4GB. It
>   > obviously wasn't allocated, thus the oops.
> 
>   BUG: unable to handle page fault for address: f75fe000
>   #PF: supervisor write access in kernel mode
>   #PF: error_code(0x0002) - not-present page
>   *pdpt = 0000000002da2001 *pde = 000000000300c067 *pte = 0000000000000000
>   Oops: Oops: 0002 [#1] SMP NOPTI
>   CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.15.0-rc1-00288-ge618ee89561b-dirty #311 PREEMPT(undef)
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
>   EIP: __free_pages_core+0x3c/0x74
>   Code: c3 d3 e6 83 ec 10 89 44 24 08 89 74 24 04 c7 04 24 c6 32 3a c2 89 55 f4 e8 a9 11 45 fe 85 f6 8b 55 f4 74 19 89 d8 31 c9 66 90 <0f> ba 30 0d c7 40 1c 00 00 00 00 41 83 c0 28 39 ce 75 ed 8b
> 
>   EAX: f75fe000 EBX: f75fe000 ECX: 00000000 EDX: 0000000a
>   ESI: 00000400 EDI: 00500000 EBP: c247becc ESP: c247beb4
>   DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210046
>   CR0: 80050033 CR2: f75fe000 CR3: 02da6000 CR4: 000000b0
>   Call Trace:
>    memblock_free_pages+0x11/0x2c
>    memblock_free_all+0x2ce/0x3a0
>    mm_core_init+0xf5/0x320
>    start_kernel+0x296/0x79c
>    ? set_init_arg+0x70/0x70
>    ? load_ucode_bsp+0x13c/0x1a8
>    i386_start_kernel+0xad/0xb0
>    startup_32_smp+0x151/0x154
>   Modules linked in:
>   CR2: 00000000f75fe000
> 
> The mem_map[] is allocated up to the end of ZONE_HIGHMEM which is defined
> by max_pfn.
> 
> Before 6faea3422e3b ("arch, mm: streamline HIGHMEM freeing") freeing of
> high memory was also clamped to the end of ZONE_HIGHMEM but after
> 6faea3422e3b memblock_free_all() tries to free memory above the of
> ZONE_HIGHMEM as well and that causes access to mem_map[] entries beyond
> the end of the memory map.
> 
> Discard the memory after max_pfn from memblock on 32-bit systems so that
> core MM would be aware only of actually usable memory.
> 
> Reported-by: Dave Hansen <dave.hansen@intel.com>
> Tested-by: Arnd Bergmann <arnd@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

With this patch in pending-fixes ( v6.15-rc2-434-g93ced5296772),
all my i386 test runs crash.

[    0.020893] Kernel panic - not syncing: ioapic_setup_resources: Failed to allocate 0x0000002b bytes
[    0.021248] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.15.0-rc2-00434-g93ced5296772 #1 PREEMPT(undef)
[    0.021373] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[    0.021549] Call Trace:
[    0.021711]  dump_stack_lvl+0x20/0x104
[    0.022023]  dump_stack+0x12/0x18
[    0.022064]  panic+0x2c1/0x2d8
[    0.022116]  ? vprintk_default+0x29/0x30
[    0.022163]  __memblock_alloc_or_panic+0x57/0x58
[    0.022221]  io_apic_init_mappings+0x2e/0x1a8
[    0.022284]  setup_arch+0x909/0xdac
[    0.022338]  ? vprintk_default+0x29/0x30
[    0.022410]  start_kernel+0x63/0x760
[    0.022457]  ? load_ucode_bsp+0x12c/0x198
[    0.022507]  i386_start_kernel+0x74/0x74
[    0.022548]  startup_32_smp+0x151/0x154
[    0.023089] ---[ end Kernel panic - not syncing: ioapic_setup_resources: Failed to allocate 0x0000002b bytes ]---

Reverting this patch fixes the problem. Bisect log is attached for reference.

Guenter

---
# bad: [93ced5296772b7b704f48e4bad9fcfdf0633c780] Merge branch 'for-linux-next-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git
# good: [8ffd015db85fea3e15a77027fda6c02ced4d2444] Linux 6.15-rc2
git bisect start 'HEAD' 'v6.15-rc2'
# good: [5d6f363fc974e32dd9930fecaae63958b68a1df4] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git
git bisect good 5d6f363fc974e32dd9930fecaae63958b68a1df4
# good: [1790b4a242fe119fead08fccc5bf923423c7449a] Merge branch 'dma-mapping-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/mszyprowski/linux.git
git bisect good 1790b4a242fe119fead08fccc5bf923423c7449a
# good: [5d37ee8a1d6455968ea3134d78223090d487c7f4] Merge branch 'fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git
git bisect good 5d37ee8a1d6455968ea3134d78223090d487c7f4
# good: [9d4de5ae5208548eb9c6a490ac454601f4fbf00b] Merge branch 'i2c/i2c-host-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/andi.shyti/linux.git
git bisect good 9d4de5ae5208548eb9c6a490ac454601f4fbf00b
# bad: [f737ab93945fb8f0213e1cccc39d028eb5d880e0] Merge branch into tip/master: 'x86/urgent'
git bisect bad f737ab93945fb8f0213e1cccc39d028eb5d880e0
# good: [2e7a2843d0de7677b7bb908ca006dc435e52c416] Merge branch into tip/master: 'irq/urgent'
git bisect good 2e7a2843d0de7677b7bb908ca006dc435e52c416
# good: [d466304c4322ad391797437cd84cca7ce1660de0] x86/cpu: Add CPU model number for Bartlett Lake CPUs with Raptor Cove cores
git bisect good d466304c4322ad391797437cd84cca7ce1660de0
# good: [39893b1e4ad7c4380abe4cfddaa58b34c4363bf4] Merge branch into tip/master: 'timers/urgent'
git bisect good 39893b1e4ad7c4380abe4cfddaa58b34c4363bf4
# bad: [1e07b9fad022e0e02215150ca1e20912e78e8ec1] x86/e820: Discard high memory that can't be addressed by 32-bit systems
git bisect bad 1e07b9fad022e0e02215150ca1e20912e78e8ec1
# first bad commit: [1e07b9fad022e0e02215150ca1e20912e78e8ec1] x86/e820: Discard high memory that can't be addressed by 32-bit systems

