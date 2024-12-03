Return-Path: <kvm+bounces-32943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32D589E2D7A
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 21:46:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6188B64A88
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 18:34:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6F2B1FCFF5;
	Tue,  3 Dec 2024 18:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="REFI6MUo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C9A1FAC3B
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 18:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733250868; cv=none; b=HygoUTvROeoLonnD6orbBjIv86aSteW4QnR+C8qYbIJJ2EmcRVNIth3aR2i9wcHyQBdG50XFi38wk5boTaAMLq3L5H53Uc4fmr3o6fni3xZmI1oD69FcojwRyfm2hRZXKwd5k3NBIxPeMFLF8GFfILIkZNceu4lUSj2y37sJLB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733250868; c=relaxed/simple;
	bh=7MnQbP5PGAjBJGCuegS6t0EWfQ+3pQNWf9splNLet2c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NOa0oldZDONtxmoNHN/qhXovL3+3cvAZxTrKeGS307ApqNFXzQv8C3aAJ12t8kPzmnpcNYejHFhS8CEZ/dJGxPba0fKif/X3dXTKGO9y6+mSrs3hqBj+CNpielFa79FP3LgC43sLRoWY2mSkS4ITeTuvQJOXrJoxHuEiByi8YXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=REFI6MUo; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 322CC3F851
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 18:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1733250860;
	bh=MyL1AYuJN9Q5JnK9u9GoHzpaWNFL+dOgoyQl8jNRl5I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=REFI6MUoCDuprc8lfX8ip9Gx30R9ZhMQIf4FfLu8PMWHw8Vqwkuq+4nsTv5ahkQA4
	 uJUurQ2JsAIOXitSBGROmJNChor7JSUW35xm+G+bmp7iEgihQQWAepgDP9po8YjYFM
	 Uk6jawLvpXvqwj1J1At4sdCY6AQK5t5QWKqRwNOvqomRnsO+XvIvbSk9e17BGySqfL
	 kSgBsOnrwrxsUjCNUACk2l3qneQ83L33EKLvWfXReEboDhtnZI0xxD7A6EEUGX2bfD
	 DGTlpQ8VvBea+Uhv356UVR1s1K6aFACbGXjNuT50DnLrROq6dPN6u1VLnmA3qjY8Cz
	 tKmYN0A/LBajg==
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5d0e78fb68aso2721528a12.0
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 10:34:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733250859; x=1733855659;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MyL1AYuJN9Q5JnK9u9GoHzpaWNFL+dOgoyQl8jNRl5I=;
        b=MBgKR0P8Whb23uRSZqFzDZs1ZQSbvSgmEKnreaMbz6N55wKvwkA2Uu8swcjB1EMUij
         1TDIJQ0kdII5K5ug/CcRW4+qPjnHEjfm6uTJat+e1Wzip/mp3L1k3bGOdSR9RXwf+IH1
         dDbo8791DRxKIvTJZaWnauaYC50y7YtGNC3I/SgIOYwOHnca2boXHk5GaBvngS8KUgXE
         F4SxSb1+WExQlNnBJVogR/b4dSA7VEuxrHTOecQwR8XAYGaojPVcfV6by0WWIrvB+vhe
         aJsnIFSdq3qJEl9IPQkZylCZsQ07Tiu46UDXsSQQu6wcMc3E7Hxiv69bkM7RNATASZXF
         7oeA==
X-Forwarded-Encrypted: i=1; AJvYcCXSAc8Oo+53OmbChQq6By8ZqRGVJQUbcmcPdaOt202Ll/EtAJw9xbED6oTy/D5EA1jfoiA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0wtQzHLyAwk7SI1wpCWdWv4gZxr9WRam99jehT9x7JWpM/oq+
	6rVDTdFHOpS2FkZH8+TYAB1o7ZKmsmQiOBY7d4lmscgvI0cypKzMcNZf7hHgExYvwwX7VE9R4SX
	gP/C2zlI2Zi692pj9cyq0ZrKRSLXcwx+JGWiLeeSG4OKlFW6WGPbWoYz/ZcQx+KZsqiq/4QY/+Z
	rb7ChWcAdNgN/3TgM/s5q7SqgwaQjAky48Nob5qUSW
X-Gm-Gg: ASbGnctcDvEsqwj+HBd9yHHoC2UZkmElYi2RvUz1zlgOjD+t040holh/Lp4rqbaFUML
	LRexvT1rPgPUyiPQc1gZVQNYNbsYFaA==
X-Received: by 2002:a05:6402:1ed4:b0:5cf:f248:7715 with SMTP id 4fb4d7f45d1cf-5d10cb8022fmr2756978a12.23.1733250857608;
        Tue, 03 Dec 2024 10:34:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEG0G+RewPILJiDp6qaS8ruGUAMI+iT9HP2uUxMDvXlvWg4LZG7LfwE88w7bpQsnEjZwgGq5usafn1zNi80xXQ=
X-Received: by 2002:a05:6402:1ed4:b0:5cf:f248:7715 with SMTP id
 4fb4d7f45d1cf-5d10cb8022fmr2756938a12.23.1733250856312; Tue, 03 Dec 2024
 10:34:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHTA-uYp07FgM6T1OZQKqAdSA5JrZo0ReNEyZgQZub4mDRrV5w@mail.gmail.com>
 <20241126103427.42d21193.alex.williamson@redhat.com> <CAHTA-ubXiDePmfgTdPbg144tHmRZR8=2cNshcL5tMkoMXdyn_Q@mail.gmail.com>
 <20241126154145.638dba46.alex.williamson@redhat.com> <CAHTA-uZp-bk5HeE7uhsR1frtj9dU+HrXxFZTAVeAwFhPen87wA@mail.gmail.com>
 <20241126170214.5717003f.alex.williamson@redhat.com> <CAHTA-uY3pyDLH9-hy1RjOqrRR+OU=Ko6hJ4xWmMTyoLwHhgTOQ@mail.gmail.com>
 <20241127102243.57cddb78.alex.williamson@redhat.com> <CAHTA-uaGZkQ6rEMcRq6JiZn8v9nZPn80NyucuSTEXuPfy+0ccw@mail.gmail.com>
In-Reply-To: <CAHTA-uaGZkQ6rEMcRq6JiZn8v9nZPn80NyucuSTEXuPfy+0ccw@mail.gmail.com>
From: Mitchell Augustin <mitchell.augustin@canonical.com>
Date: Tue, 3 Dec 2024 12:34:05 -0600
Message-ID: <CAHTA-uY_S9Y1rdtH=fDmC3duz51v6c1Qc8PfFbjyT6czQmZByA@mail.gmail.com>
Subject: Re: drivers/pci: (and/or KVM): Slow PCI initialization during VM boot
 with passthrough of large BAR Nvidia GPUs on DGX H100
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org, 
	Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> If the slowness is confined to the guest kernel boot, can you share the l=
og of that boot with timestamps?

Here is the guest boot, with timestamps:

BdsDxe: loading Boot0003 "ubuntu" from
HD(15,GPT,6714CD0E-2211-4B5F-8DAA-341FCBAE2865,0x2800,0x35000)/\EFI\ubuntu\=
shimx64.efi
BdsDxe: starting Boot0003 "ubuntu" from
HD(15,GPT,6714CD0E-2211-4B5F-8DAA-341FCBAE2865,0x2800,0x35000)/\EFI\ubuntu\=
shimx64.efi
[    0.000000] Linux version 6.12.1+ (ubuntu@testbox01) (gcc (Ubuntu
11.4.0-1ubuntu1~22.04) 11.4.0, GNU ld (GNU Binutils for Ubuntu) 2.38)
#1 SMP PREEMPT_DYNAMIC Tue Dec  3 15:39:18 UTC 2024
[    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-6.12.1+
root=3DUUID=3Dfec1c9ae-0df3-419c-80dd-f3035049b845 ro console=3Dtty1
console=3DttyS0 pci=3Dbar_logging_enabled
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Hygon HygonGenuine
[    0.000000]   Centaur CentaurHauls
[    0.000000]   zhaoxin   Shanghai
[    0.000000] x86/split lock detection: #DB: warning on user-space bus_loc=
ks
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007ed3efff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x000000007ed3f000-0x000000007edfffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x000000007ee00000-0x000000007f8ecfff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x000000007f8ed000-0x000000007fb6cfff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x000000007fb6d000-0x000000007fb7efff] ACPI =
data
[    0.000000] BIOS-e820: [mem 0x000000007fb7f000-0x000000007fbfefff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x000000007fbff000-0x000000007ff7bfff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x000000007ff7c000-0x000000007fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000e6dfffffff] usabl=
e
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] APIC: Static calls initialized
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem
0x0000000000000000-0x000000000009ffff] usable
[    0.000000] reserve setup_data: [mem
0x0000000000100000-0x000000007e327017] usable
[    0.000000] reserve setup_data: [mem
0x000000007e327018-0x000000007e359057] usable
[    0.000000] reserve setup_data: [mem
0x000000007e359058-0x000000007ed3efff] usable
[    0.000000] reserve setup_data: [mem
0x000000007ed3f000-0x000000007edfffff] reserved
[    0.000000] reserve setup_data: [mem
0x000000007ee00000-0x000000007f8ecfff] usable
[    0.000000] reserve setup_data: [mem
0x000000007f8ed000-0x000000007fb6cfff] reserved
[    0.000000] reserve setup_data: [mem
0x000000007fb6d000-0x000000007fb7efff] ACPI data
[    0.000000] reserve setup_data: [mem
0x000000007fb7f000-0x000000007fbfefff] ACPI NVS
[    0.000000] reserve setup_data: [mem
0x000000007fbff000-0x000000007ff7bfff] usable
[    0.000000] reserve setup_data: [mem
0x000000007ff7c000-0x000000007fffffff] reserved
[    0.000000] reserve setup_data: [mem
0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] reserve setup_data: [mem
0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] reserve setup_data: [mem
0x00000000ffc00000-0x00000000ffffffff] reserved
[    0.000000] reserve setup_data: [mem
0x0000000100000000-0x000000e6dfffffff] usable
[    0.000000] efi: EFI v2.7 by Ubuntu distribution of EDK II
[    0.000000] efi: TPMFinalLog=3D0x7fbe7000 SMBIOS=3D0x7f988000 SMBIOS
3.0=3D0x7f986000 ACPI=3D0x7fb7e000 ACPI 2.0=3D0x7fb7e014 MEMATTR=3D0x7e35c0=
18
MOKvar=3D0x7f987000 RNG=3D0x7fb73018 TPMEventLog=3D0x7fb6f018
[    0.000000] random: crng init done
[    0.000000] efi: Remove mem149: MMIO range=3D[0xffc00000-0xffffffff]
(4MB) from e820 map
[    0.000000] SMBIOS 3.0.0 present.
[    0.000000] DMI: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
2024.02-2 03/11/2024
[    0.000000] DMI: Memory slots populated: 58/58
[    0.000000] Hypervisor detected: KVM
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: using sched offset of 28018231721 cycles
[    0.000002] clocksource: kvm-clock: mask: 0xffffffffffffffff
max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[    0.000004] tsc: Detected 2000.000 MHz processor
[    0.000096] last_pfn =3D 0xe6e0000 max_arch_pfn =3D 0x10000000000
[    0.000126] MTRR map: 4 entries (2 fixed + 2 variable; max 18),
built from 8 variable MTRRs
[    0.000128] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT
[    0.000165] last_pfn =3D 0x7ff7c max_arch_pfn =3D 0x10000000000
[    0.005618] Using GB pages for direct mapping
[    0.005903] Secure boot disabled
[    0.005903] RAMDISK: [mem 0x626a7000-0x6bcd5fff]
[    0.005905] ACPI: Early table checksum verification disabled
[    0.005907] ACPI: RSDP 0x000000007FB7E014 000024 (v02 BOCHS )
[    0.005910] ACPI: XSDT 0x000000007FB7D0E8 00004C (v01 BOCHS  BXPC
  00000001      01000013)
[    0.005913] ACPI: FACP 0x000000007FB78000 0000F4 (v03 BOCHS  BXPC
  00000001 BXPC 00000001)
[    0.005916] ACPI: DSDT 0x000000007FB79000 00316D (v01 BOCHS  BXPC
  00000001 BXPC 00000001)
[    0.005918] ACPI: FACS 0x000000007FBB5000 000040
[    0.005920] ACPI: APIC 0x000000007FB77000 0000F0 (v03 BOCHS  BXPC
  00000001 BXPC 00000001)
[    0.005922] ACPI: TPM2 0x000000007FB76000 00004C (v04 BOCHS  BXPC
  00000001 BXPC 00000001)
[    0.005928] ACPI: MCFG 0x000000007FB75000 00003C (v01 BOCHS  BXPC
  00000001 BXPC 00000001)
[    0.005930] ACPI: WAET 0x000000007FB74000 000028 (v01 BOCHS  BXPC
  00000001 BXPC 00000001)
[    0.005931] ACPI: Reserving FACP table memory at [mem 0x7fb78000-0x7fb78=
0f3]
[    0.005932] ACPI: Reserving DSDT table memory at [mem 0x7fb79000-0x7fb7c=
16c]
[    0.005933] ACPI: Reserving FACS table memory at [mem 0x7fbb5000-0x7fbb5=
03f]
[    0.005933] ACPI: Reserving APIC table memory at [mem 0x7fb77000-0x7fb77=
0ef]
[    0.005934] ACPI: Reserving TPM2 table memory at [mem 0x7fb76000-0x7fb76=
04b]
[    0.005934] ACPI: Reserving MCFG table memory at [mem 0x7fb75000-0x7fb75=
03b]
[    0.005935] ACPI: Reserving WAET table memory at [mem 0x7fb74000-0x7fb74=
027]
[    0.006168] No NUMA configuration found
[    0.006168] Faking a node at [mem 0x0000000000000000-0x000000e6dfffffff]
[    0.006174] NODE_DATA(0) allocated [mem 0xe6dffd5dc0-0xe6dfffffff]
[    0.006997] Zone ranges:
[    0.006998]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.006999]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.007000]   Normal   [mem 0x0000000100000000-0x000000e6dfffffff]
[    0.007001]   Device   empty
[    0.007002] Movable zone start for each node
[    0.007004] Early memory node ranges
[    0.007004]   node   0: [mem 0x0000000000001000-0x000000000009ffff]
[    0.007005]   node   0: [mem 0x0000000000100000-0x000000007ed3efff]
[    0.007006]   node   0: [mem 0x000000007ee00000-0x000000007f8ecfff]
[    0.007006]   node   0: [mem 0x000000007fbff000-0x000000007ff7bfff]
[    0.007007]   node   0: [mem 0x0000000100000000-0x000000e6dfffffff]
[    0.007050] Initmem setup node 0 [mem 0x0000000000001000-0x000000e6dffff=
fff]
[    0.007058] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.007090] On node 0, zone DMA: 96 pages in unavailable ranges
[    0.010984] On node 0, zone DMA32: 193 pages in unavailable ranges
[    0.011000] On node 0, zone DMA32: 786 pages in unavailable ranges
[    1.820432] On node 0, zone Normal: 132 pages in unavailable ranges
[    1.821388] ACPI: PM-Timer IO Port: 0x608
[    1.821399] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    1.821424] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    1.821426] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    1.821428] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    1.821429] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    1.821429] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level=
)
[    1.821430] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level=
)
[    1.821433] ACPI: Using ACPI (MADT) for SMP configuration information
[    1.821434] TSC deadline timer available
[    1.821436] CPU topo: Max. logical packages:  16
[    1.821437] CPU topo: Max. logical dies:      16
[    1.821437] CPU topo: Max. dies per package:   1
[    1.821440] CPU topo: Max. threads per core:   1
[    1.821440] CPU topo: Num. cores per package:     1
[    1.821440] CPU topo: Num. threads per package:   1
[    1.821441] CPU topo: Allowing 16 present CPUs plus 0 hotplug CPUs
[    1.821454] kvm-guest: APIC: eoi() replaced with kvm_guest_apic_eoi_writ=
e()
[    1.821464] kvm-guest: KVM setup pv remote TLB flush
[    1.821467] kvm-guest: setup PV sched yield
[    1.821474] PM: hibernation: Registered nosave memory: [mem
0x00000000-0x00000fff]
[    1.821475] PM: hibernation: Registered nosave memory: [mem
0x000a0000-0x000fffff]
[    1.821476] PM: hibernation: Registered nosave memory: [mem
0x7e327000-0x7e327fff]
[    1.821477] PM: hibernation: Registered nosave memory: [mem
0x7e359000-0x7e359fff]
[    1.821477] PM: hibernation: Registered nosave memory: [mem
0x7ed3f000-0x7edfffff]
[    1.821478] PM: hibernation: Registered nosave memory: [mem
0x7f8ed000-0x7fb6cfff]
[    1.821479] PM: hibernation: Registered nosave memory: [mem
0x7fb6d000-0x7fb7efff]
[    1.821479] PM: hibernation: Registered nosave memory: [mem
0x7fb7f000-0x7fbfefff]
[    1.821480] PM: hibernation: Registered nosave memory: [mem
0x7ff7c000-0x7fffffff]
[    1.821480] PM: hibernation: Registered nosave memory: [mem
0x80000000-0xdfffffff]
[    1.821481] PM: hibernation: Registered nosave memory: [mem
0xe0000000-0xefffffff]
[    1.821481] PM: hibernation: Registered nosave memory: [mem
0xf0000000-0xfeffbfff]
[    1.821481] PM: hibernation: Registered nosave memory: [mem
0xfeffc000-0xfeffffff]
[    1.821482] PM: hibernation: Registered nosave memory: [mem
0xff000000-0xffffffff]
[    1.821483] [mem 0x80000000-0xdfffffff] available for PCI devices
[    1.821484] Booting paravirtualized kernel on KVM
[    1.821486] clocksource: refined-jiffies: mask: 0xffffffff
max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    1.821492] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:16
nr_cpu_ids:16 nr_node_ids:1
[    1.822851] percpu: Embedded 67 pages/cpu s237568 r8192 d28672 u524288
[    1.822886] kvm-guest: PV spinlocks enabled
[    1.822888] PV qspinlock hash table entries: 256 (order: 0, 4096
bytes, linear)
[    1.822891] Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-6.12.1+
root=3DUUID=3Dfec1c9ae-0df3-419c-80dd-f3035049b845 ro console=3Dtty1
console=3DttyS0 pci=3Dbar_logging_enabled
[    1.822937] Unknown kernel command line parameters
"BOOT_IMAGE=3D/boot/vmlinuz-6.12.1+", will be passed to user space.
[    1.854018] Dentry cache hash table entries: 33554432 (order: 16,
268435456 bytes, linear)
[    1.869588] Inode-cache hash table entries: 16777216 (order: 15,
134217728 bytes, linear)
[    1.869786] Fallback order for Node 0: 0
[    1.869789] Built 1 zonelists, mobility grouping on.  Total pages: 24156=
4488
[    1.869790] Policy zone: Normal
[    1.869794] mem auto-init: stack:off, heap alloc:on, heap free:off
[    1.869797] software IO TLB: area num 16.
[    3.684392] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D16, =
Nodes=3D1
[    3.684440] ftrace: allocating 54200 entries in 212 pages
[    3.692927] ftrace: allocated 212 pages with 4 groups
[    3.693473] Dynamic Preempt: voluntary
[    3.693548] rcu: Preemptible hierarchical RCU implementation.
[    3.693548] rcu: RCU restricting CPUs from NR_CPUS=3D8192 to nr_cpu_ids=
=3D16.
[    3.693549] Trampoline variant of Tasks RCU enabled.
[    3.693550] Rude variant of Tasks RCU enabled.
[    3.693550] Tracing variant of Tasks RCU enabled.
[    3.693550] rcu: RCU calculated value of scheduler-enlistment delay
is 25 jiffies.
[    3.693551] rcu: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D16
[    3.693562] RCU Tasks: Setting shift to 4 and lim to 1
rcu_task_cb_adjust=3D1 rcu_task_cpu_ids=3D16.
[    3.693564] RCU Tasks Rude: Setting shift to 4 and lim to 1
rcu_task_cb_adjust=3D1 rcu_task_cpu_ids=3D16.
[    3.693567] RCU Tasks Trace: Setting shift to 4 and lim to 1
rcu_task_cb_adjust=3D1 rcu_task_cpu_ids=3D16.
[    3.695485] NR_IRQS: 524544, nr_irqs: 552, preallocated irqs: 16
[    3.695689] rcu: srcu_init: Setting srcu_struct sizes based on contentio=
n.
[    3.695755] Console: colour dummy device 80x25
[    3.695758] printk: legacy console [tty1] enabled
[    3.695968] printk: legacy console [ttyS0] enabled
[    3.792982] ACPI: Core revision 20240827
[    3.793373] APIC: Switch to symmetric I/O mode setup
[    3.793980] x2apic enabled
[    3.794440] APIC: Switched APIC routing to: physical x2apic
[    3.794936] kvm-guest: APIC: send_IPI_mask() replaced with
kvm_send_ipi_mask()
[    3.795580] kvm-guest: APIC: send_IPI_mask_allbutself() replaced
with kvm_send_ipi_mask_allbutself()
[    3.796387] kvm-guest: setup PV IPIs
[    3.798399] clocksource: tsc-early: mask: 0xffffffffffffffff
max_cycles: 0x39a85c9bff6, max_idle_ns: 881590591483 ns
[    3.799717] Calibrating delay loop (skipped) preset value.. 4000.00
BogoMIPS (lpj=3D8000000)
[    3.800877] x86/cpu: User Mode Instruction Prevention (UMIP) activated
[    3.801779] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    3.802443] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    3.803187] Spectre V1 : Mitigation: usercopy/swapgs barriers and
__user pointer sanitization
[    3.803714] Spectre V2 : Spectre BHI mitigation: SW BHB clearing on
syscall and VM exit
[    3.803714] Spectre V2 : Mitigation: Enhanced / Automatic IBRS
[    3.803714] Spectre V2 : Spectre v2 / SpectreRSB mitigation:
Filling RSB on context switch
[    3.803714] Spectre V2 : Spectre v2 / PBRSB-eIBRS: Retire a single
CALL on VMEXIT
[    3.803714] Spectre V2 : mitigation: Enabling conditional Indirect
Branch Prediction Barrier
[    3.803714] Speculative Store Bypass: Mitigation: Speculative Store
Bypass disabled via prctl
[    3.803714] TAA: Mitigation: TSX disabled
[    3.803714] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating
point registers'
[    3.803714] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    3.803714] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    3.803714] x86/fpu: Supporting XSAVE feature 0x020: 'AVX-512 opmask'
[    3.803714] x86/fpu: Supporting XSAVE feature 0x040: 'AVX-512 Hi256'
[    3.803714] x86/fpu: Supporting XSAVE feature 0x080: 'AVX-512 ZMM_Hi256'
[    3.803714] x86/fpu: Supporting XSAVE feature 0x200: 'Protection
Keys User registers'
[    3.803714] x86/fpu: Supporting XSAVE feature 0x20000: 'AMX Tile config'
[    3.803714] x86/fpu: Supporting XSAVE feature 0x40000: 'AMX Tile data'
[    3.803714] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    3.803714] x86/fpu: xstate_offset[5]:  832, xstate_sizes[5]:   64
[    3.803714] x86/fpu: xstate_offset[6]:  896, xstate_sizes[6]:  512
[    3.803714] x86/fpu: xstate_offset[7]: 1408, xstate_sizes[7]: 1024
[    3.803714] x86/fpu: xstate_offset[9]: 2432, xstate_sizes[9]:    8
[    3.803714] x86/fpu: xstate_offset[17]: 2496, xstate_sizes[17]:   64
[    3.803714] x86/fpu: xstate_offset[18]: 2560, xstate_sizes[18]: 8192
[    3.803714] x86/fpu: Enabled xstate features 0x602e7, context size
is 10752 bytes, using 'compacted' format.
[    3.803714] Freeing SMP alternatives memory: 44K
[    3.803714] pid_max: default: 32768 minimum: 301
[    3.803714] LSM: initializing
lsm=3Dlockdown,capability,landlock,yama,apparmor,ima,evm
[    3.803714] landlock: Up and running.
[    3.803714] Yama: becoming mindful.
[    3.803714] AppArmor: AppArmor initialized
[    3.803714] Mount-cache hash table entries: 524288 (order: 10,
4194304 bytes, linear)
[    3.803714] Mountpoint-cache hash table entries: 524288 (order: 10,
4194304 bytes, linear)
[    3.803714] smpboot: CPU0: Intel(R) Xeon(R) Platinum 8480C (family:
0x6, model: 0x8f, stepping: 0x8)
[    3.803714] Performance Events: PEBS fmt0-, Sapphire Rapids events,
full-width counters, Intel PMU driver.
[    3.803714] ... version:                2
[    3.803714] ... bit width:              48
[    3.803714] ... generic registers:      8
[    3.803714] ... value mask:             0000ffffffffffff
[    3.803714] ... max period:             00007fffffffffff
[    3.803719] ... fixed-purpose events:   3
[    3.804131] ... event mask:             00000007000000ff
[    3.804773] signal: max sigframe size: 11952
[    3.805241] rcu: Hierarchical SRCU implementation.
[    3.805729] rcu: Max phase no-delay instances is 1000.
[    3.806291] Timer migration: 2 hierarchy levels; 8 children per
group; 2 crossnode level
[    3.807705] smp: Bringing up secondary CPUs ...
[    3.807809] smpboot: x86: Booting SMP configuration:
[    3.808321] .... node  #0, CPUs:        #1  #2  #3  #4  #5  #6  #7
#8  #9 #10 #11 #12 #13 #14 #15
[    3.880011] smp: Brought up 1 node, 16 CPUs
[    3.881357] smpboot: Total of 16 processors activated (64000.00 BogoMIPS=
)
[    3.883830] Memory: 950467920K/966257952K available (20480K kernel
code, 4367K rwdata, 13728K rodata, 5092K init, 4692K bss, 15767412K
reserved, 0K cma-reserved)
[    3.909514] devtmpfs: initialized
[    3.909514] x86/mm: Memory block size: 512MB
[    3.921087] ACPI: PM: Registering ACPI NVS region [mem
0x7fb7f000-0x7fbfefff] (524288 bytes)
[    3.921087] clocksource: jiffies: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 7645041785100000 ns
[    3.921713] futex hash table entries: 4096 (order: 6, 262144 bytes, line=
ar)
[    3.923773] pinctrl core: initialized pinctrl subsystem
[    3.924385] PM: RTC time: 16:25:37, date: 2024-12-03
[    3.925492] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    3.926658] DMA: preallocated 4096 KiB GFP_KERNEL pool for atomic alloca=
tions
[    3.927971] DMA: preallocated 4096 KiB GFP_KERNEL|GFP_DMA pool for
atomic allocations
[    3.929311] DMA: preallocated 4096 KiB GFP_KERNEL|GFP_DMA32 pool
for atomic allocations
[    3.930154] audit: initializing netlink subsys (disabled)
[    3.930764] audit: type=3D2000 audit(1733243137.541:1):
state=3Dinitialized audit_enabled=3D0 res=3D1
[    3.930836] thermal_sys: Registered thermal governor 'fair_share'
[    3.931719] thermal_sys: Registered thermal governor 'bang_bang'
[    3.932348] thermal_sys: Registered thermal governor 'step_wise'
[    3.932967] thermal_sys: Registered thermal governor 'user_space'
[    3.933587] thermal_sys: Registered thermal governor 'power_allocator'
[    3.934213] EISA bus registered
[    3.935225] cpuidle: using governor ladder
[    3.935652] cpuidle: using governor menu
[    3.935940] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    3.936707] PCI: ECAM [mem 0xe0000000-0xefffffff] (base 0xe0000000)
for domain 0000 [bus 00-ff]
[    3.937597] PCI: Using configuration type 1 for base access
[    3.938428] kprobes: kprobe jump-optimization is enabled. All
kprobes are optimized if possible.
[    3.964139] HugeTLB: registered 1.00 GiB page size, pre-allocated 0 page=
s
[    3.966236] HugeTLB: 16380 KiB vmemmap can be freed for a 1.00 GiB page
[    3.967746] HugeTLB: registered 2.00 MiB page size, pre-allocated 0 page=
s
[    3.968946] HugeTLB: 28 KiB vmemmap can be freed for a 2.00 MiB page
[    3.970176] fbcon: Taking over console
[    3.971728] ACPI: Added _OSI(Module Device)
[    3.971729] ACPI: Added _OSI(Processor Device)
[    3.972572] ACPI: Added _OSI(3.0 _SCP Extensions)
[    3.973466] ACPI: Added _OSI(Processor Aggregator Device)
[    3.976318] ACPI: 1 ACPI AML tables successfully acquired and loaded
[    3.979963] ACPI: Interpreter enabled
[    3.980703] ACPI: PM: (supports S0 S5)
[    3.980703] ACPI: Using IOAPIC for interrupt routing
[    3.980703] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=3Dnocrs" and report a bug
[    3.982423] PCI: Ignoring E820 reservations for host bridge windows
[    3.983728] ACPI: Enabled 2 GPEs in block 00 to 3F
[    3.988066] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    3.989238] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM
ClockPM Segments MSI EDR HPX-Type3]
[    3.991051] acpi PNP0A08:00: _OSC: platform does not support
[PCIeHotplug LTR DPC]
[    3.991791] acpi PNP0A08:00: _OSC: OS now controls [SHPCHotplug PME
AER PCIeCapability]
[    3.993646] PCI host bridge to bus 0000:00
[    3.994422] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window=
]
[    3.995706] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window=
]
[    3.995720] pci_bus 0000:00: root bus resource [mem
0x000a0000-0x000bffff window]
[    3.997131] pci_bus 0000:00: root bus resource [mem
0x80000000-0xdfffffff window]
[    3.998522] pci_bus 0000:00: root bus resource [mem
0xf0000000-0xfebfffff window]
[    3.999720] pci_bus 0000:00: root bus resource [mem
0x380000000000-0x3937ffffffff window]
[    4.001254] pci_bus 0000:00: root bus resource [bus 00-ff]
[    4.002346] pci 0000:00:00.0: [8086:29c0] type 00 class 0x060000
conventional PCI endpoint
[    4.004284] pci 0000:00:01.0: [1b36:000c] type 01 class 0x060400
PCIe Root Port
[    4.011425] pci 0000:00:01.0: BAR 0 [mem 0x81c8e000-0x81c8efff]
[    4.022953] pci 0000:00:01.0: PCI bridge to [bus 01]
[    4.023770] pci 0000:00:01.0:   bridge window [mem 0x81a00000-0x81bfffff=
]
[    4.026049] pci 0000:00:01.0:   bridge window [mem
0x38e800000000-0x38efffffffff 64bit pref]
[    4.029118] pci 0000:00:01.1: [1b36:000c] type 01 class 0x060400
PCIe Root Port
[    4.033508] pci 0000:00:01.1: BAR 0 [mem 0x81c8d000-0x81c8dfff]
[    4.043729] pci 0000:00:01.1: PCI bridge to [bus 02]
[    4.047775] pci 0000:00:01.1:   bridge window [mem 0x81800000-0x819fffff=
]
[    4.050074] pci 0000:00:01.1:   bridge window [mem
0x38f000000000-0x38f7ffffffff 64bit pref]
[    4.053056] pci 0000:00:01.2: [1b36:000c] type 01 class 0x060400
PCIe Root Port
[    4.056631] pci 0000:00:01.2: BAR 0 [mem 0x81c8c000-0x81c8cfff]
[    4.060737] pci 0000:00:01.2: PCI bridge to [bus 03]
[    4.061723] pci 0000:00:01.2:   bridge window [mem 0x81600000-0x817fffff=
]
[    4.063754] pci 0000:00:01.2:   bridge window [mem
0x38f800000000-0x38ffffffffff 64bit pref]
[    4.069238] pci 0000:00:01.3: [1b36:000c] type 01 class 0x060400
PCIe Root Port
[    4.076527] pci 0000:00:01.3: BAR 0 [mem 0x81c8b000-0x81c8bfff]
[    4.080558] pci 0000:00:01.3: PCI bridge to [bus 04]
[    4.083776] pci 0000:00:01.3:   bridge window [mem 0x81400000-0x815fffff=
]
[    4.086008] pci 0000:00:01.3:   bridge window [mem
0x390000000000-0x3907ffffffff 64bit pref]
[    4.088997] pci 0000:00:01.4: [1b36:000c] type 01 class 0x060400
PCIe Root Port
[    4.092530] pci 0000:00:01.4: BAR 0 [mem 0x81c8a000-0x81c8afff]
[    4.096548] pci 0000:00:01.4: PCI bridge to [bus 05]
[    4.097513] pci 0000:00:01.4:   bridge window [mem 0x81200000-0x813fffff=
]
[    4.099677] pci 0000:00:01.4:   bridge window [mem
0x390800000000-0x390fffffffff 64bit pref]
[    4.103948] pci 0000:00:01.5: [1b36:000c] type 01 class 0x060400
PCIe Root Port
[    7.843731] pci 0000:00:01.5: BAR 0 [mem 0x81c89000-0x81c89fff]
[   14.671740] pci 0000:00:01.5: PCI bridge to [bus 06]
[   14.675724] pci 0000:00:01.5:   bridge window [mem 0x81000000-0x811fffff=
]
[   18.063755] pci 0000:00:01.5:   bridge window [mem
0x380000000000-0x382002ffffff 64bit pref]
[   18.067724] pci 0000:00:01.6: [1b36:000c] type 01 class 0x060400
PCIe Root Port
[   21.383734] pci 0000:00:01.6: BAR 0 [mem 0x81c88000-0x81c88fff]
[   27.983742] pci 0000:00:01.6: PCI bridge to [bus 07]
[   27.985078] pci 0000:00:01.6:   bridge window [mem 0x80e00000-0x80ffffff=
]
[   31.243754] pci 0000:00:01.6:   bridge window [mem
0x384000000000-0x386002ffffff 64bit pref]
[   31.246974] pci 0000:00:01.7: [1b36:000c] type 01 class 0x060400
PCIe Root Port
[   34.459736] pci 0000:00:01.7: BAR 0 [mem 0x81c87000-0x81c87fff]
[   40.887740] pci 0000:00:01.7: PCI bridge to [bus 08]
[   40.889069] pci 0000:00:01.7:   bridge window [mem 0x80c00000-0x80dfffff=
]
[   44.103758] pci 0000:00:01.7:   bridge window [mem
0x388000000000-0x38a002ffffff 64bit pref]
[   44.107724] pci 0000:00:02.0: [1b36:000c] type 01 class 0x060400
PCIe Root Port
[   47.299735] pci 0000:00:02.0: BAR 0 [mem 0x81c86000-0x81c86fff]
[   53.691742] pci 0000:00:02.0: PCI bridge to [bus 09]
[   53.693237] pci 0000:00:02.0:   bridge window [mem 0x80a00000-0x80bfffff=
]
[   56.887766] pci 0000:00:02.0:   bridge window [mem
0x38c000000000-0x38e002ffffff 64bit pref]
[   56.891222] pci 0000:00:02.1: [1b36:000c] type 01 class 0x060400
PCIe Root Port
[   56.893260] pci 0000:00:02.1: BAR 0 [mem 0x81c85000-0x81c85fff]
[   56.895727] pci 0000:00:02.1: PCI bridge to [bus 0a]
[   56.896313] pci 0000:00:02.1:   bridge window [mem 0x80800000-0x809fffff=
]
[   56.897587] pci 0000:00:02.1:   bridge window [mem
0x391000000000-0x3917ffffffff 64bit pref]
[   56.900203] pci 0000:00:02.2: [1b36:000c] type 01 class 0x060400
PCIe Root Port
[   56.902634] pci 0000:00:02.2: BAR 0 [mem 0x81c84000-0x81c84fff]
[   56.905143] pci 0000:00:02.2: PCI bridge to [bus 0b]
[   56.905721] pci 0000:00:02.2:   bridge window [mem 0x80600000-0x807fffff=
]
[   56.906969] pci 0000:00:02.2:   bridge window [mem
0x391800000000-0x391fffffffff 64bit pref]
[   56.908523] pci 0000:00:02.3: [1b36:000c] type 01 class 0x060400
PCIe Root Port
[   56.916817] pci 0000:00:02.3: BAR 0 [mem 0x81c83000-0x81c83fff]
[   56.919387] pci 0000:00:02.3: PCI bridge to [bus 0c]
[   56.919745] pci 0000:00:02.3:   bridge window [mem 0x80400000-0x805fffff=
]
[   56.920976] pci 0000:00:02.3:   bridge window [mem
0x392000000000-0x3927ffffffff 64bit pref]
[   56.922701] pci 0000:00:02.4: [1b36:000c] type 01 class 0x060400
PCIe Root Port
[   56.925875] pci 0000:00:02.4: BAR 0 [mem 0x81c82000-0x81c82fff]
[   56.929750] pci 0000:00:02.4: PCI bridge to [bus 0d]
[   56.930322] pci 0000:00:02.4:   bridge window [mem 0x80200000-0x803fffff=
]
[   56.931545] pci 0000:00:02.4:   bridge window [mem
0x392800000000-0x392fffffffff 64bit pref]
[   56.932596] pci 0000:00:02.5: [1b36:000c] type 01 class 0x060400
PCIe Root Port
[   56.934846] pci 0000:00:02.5: BAR 0 [mem 0x81c81000-0x81c81fff]
[   56.944343] pci 0000:00:02.5: PCI bridge to [bus 0e]
[   56.944910] pci 0000:00:02.5:   bridge window [mem 0x80000000-0x801fffff=
]
[   56.946136] pci 0000:00:02.5:   bridge window [mem
0x393000000000-0x3937ffffffff 64bit pref]
[   56.955595] pci 0000:00:1f.0: [8086:2918] type 00 class 0x060100
conventional PCI endpoint
[   56.956002] pci 0000:00:1f.0: quirk: [io  0x0600-0x067f] claimed by
ICH6 ACPI/GPIO/TCO
[   56.956983] pci 0000:00:1f.2: [8086:2922] type 00 class 0x010601
conventional PCI endpoint
[   56.963100] pci 0000:00:1f.2: BAR 4 [io  0x6040-0x605f]
[   56.969468] pci 0000:00:1f.2: BAR 5 [mem 0x81c80000-0x81c80fff]
[   56.971808] pci 0000:00:1f.3: [8086:2930] type 00 class 0x0c0500
conventional PCI endpoint
[   56.975034] pci 0000:00:1f.3: BAR 4 [io  0x6000-0x603f]
[   56.976976] acpiphp: Slot [0] registered
[   56.983840] pci 0000:01:00.0: [1af4:1041] type 00 class 0x020000
PCIe Endpoint
[   56.986557] pci 0000:01:00.0: BAR 1 [mem 0x81a00000-0x81a00fff]
[   56.989447] pci 0000:01:00.0: BAR 4 [mem
0x38e800000000-0x38e800003fff 64bit pref]
[   56.991209] pci 0000:01:00.0: ROM [mem 0xfff80000-0xffffffff pref]
[   56.992772] pci 0000:00:01.0: PCI bridge to [bus 01]
[   56.996513] acpiphp: Slot [0-2] registered
[   56.997021] pci 0000:02:00.0: [1b36:000d] type 00 class 0x0c0330
PCIe Endpoint
[   56.998311] pci 0000:02:00.0: BAR 0 [mem 0x81800000-0x81803fff 64bit]
[   57.001850] pci 0000:00:01.1: PCI bridge to [bus 02]
[   57.003054] acpiphp: Slot [0-3] registered
[   57.003605] pci 0000:03:00.0: [1af4:1043] type 00 class 0x078000
PCIe Endpoint
[   57.008316] pci 0000:03:00.0: BAR 1 [mem 0x81600000-0x81600fff]
[   57.011611] pci 0000:03:00.0: BAR 4 [mem
0x38f800000000-0x38f800003fff 64bit pref]
[   57.013639] pci 0000:00:01.2: PCI bridge to [bus 03]
[   57.014849] acpiphp: Slot [0-4] registered
[   57.015386] pci 0000:04:00.0: [1af4:1042] type 00 class 0x010000
PCIe Endpoint
[   57.024292] pci 0000:04:00.0: BAR 1 [mem 0x81400000-0x81400fff]
[   57.027598] pci 0000:04:00.0: BAR 4 [mem
0x390000000000-0x390000003fff 64bit pref]
[   57.029599] pci 0000:00:01.3: PCI bridge to [bus 04]
[   57.030818] acpiphp: Slot [0-5] registered
[   57.031348] pci 0000:05:00.0: [1af4:1042] type 00 class 0x010000
PCIe Endpoint
[   57.036715] pci 0000:05:00.0: BAR 1 [mem 0x81200000-0x81200fff]
[   57.039719] pci 0000:05:00.0: BAR 4 [mem
0x390800000000-0x390800003fff 64bit pref]
[   57.042400] pci 0000:00:01.4: PCI bridge to [bus 05]
[   57.043592] acpiphp: Slot [0-6] registered
[   57.043813] pci 0000:06:00.0: [10de:2330] type 00 class 0x030200
PCIe Endpoint
[   60.295739] pci 0000:06:00.0: BAR 0 [mem
0x382002000000-0x382002ffffff 64bit pref]
[   63.551734] pci 0000:06:00.0: BAR 2 [mem
0x380000000000-0x381fffffffff 64bit pref]
[   66.815736] pci 0000:06:00.0: BAR 4 [mem
0x382000000000-0x382001ffffff 64bit pref]
[   70.067776] pci 0000:06:00.0: Max Payload Size set to 128 (was 256, max =
256)
[   70.069996] pci 0000:06:00.0: Enabling HDA controller
[   70.071185] pci 0000:06:00.0: 252.048 Gb/s available PCIe
bandwidth, limited by 16.0 GT/s PCIe x16 link at 0000:00:01.5 (capable
of 504.112 Gb/s with 32.0 GT/s PCIe x16 link)
[   70.072298] pci 0000:00:01.5: PCI bridge to [bus 06]
[   70.073478] acpiphp: Slot [0-7] registered
[   70.073983] pci 0000:07:00.0: [10de:2330] type 00 class 0x030200
PCIe Endpoint
[   73.311738] pci 0000:07:00.0: BAR 0 [mem
0x386002000000-0x386002ffffff 64bit pref]
[   76.547737] pci 0000:07:00.0: BAR 2 [mem
0x384000000000-0x385fffffffff 64bit pref]
[   79.779735] pci 0000:07:00.0: BAR 4 [mem
0x386000000000-0x386001ffffff 64bit pref]
[   83.015780] pci 0000:07:00.0: Max Payload Size set to 128 (was 256, max =
256)
[   83.018052] pci 0000:07:00.0: Enabling HDA controller
[   83.019254] pci 0000:07:00.0: 252.048 Gb/s available PCIe
bandwidth, limited by 16.0 GT/s PCIe x16 link at 0000:00:01.6 (capable
of 504.112 Gb/s with 32.0 GT/s PCIe x16 link)
[   83.024351] pci 0000:00:01.6: PCI bridge to [bus 07]
[   83.025571] acpiphp: Slot [0-8] registered
[   83.026077] pci 0000:08:00.0: [10de:2330] type 00 class 0x030200
PCIe Endpoint
[   86.243738] pci 0000:08:00.0: BAR 0 [mem
0x38a002000000-0x38a002ffffff 64bit pref]
[   89.463737] pci 0000:08:00.0: BAR 2 [mem
0x388000000000-0x389fffffffff 64bit pref]
[   92.683736] pci 0000:08:00.0: BAR 4 [mem
0x38a000000000-0x38a001ffffff 64bit pref]
[   95.903779] pci 0000:08:00.0: Max Payload Size set to 128 (was 256, max =
256)
[   95.905971] pci 0000:08:00.0: Enabling HDA controller
[   95.907197] pci 0000:08:00.0: 252.048 Gb/s available PCIe
bandwidth, limited by 16.0 GT/s PCIe x16 link at 0000:00:01.7 (capable
of 504.112 Gb/s with 32.0 GT/s PCIe x16 link)
[   95.908320] pci 0000:00:01.7: PCI bridge to [bus 08]
[   95.909554] acpiphp: Slot [0-9] registered
[   95.910087] pci 0000:09:00.0: [10de:2330] type 00 class 0x030200
PCIe Endpoint
[   99.103739] pci 0000:09:00.0: BAR 0 [mem
0x38e002000000-0x38e002ffffff 64bit pref]
[  102.303734] pci 0000:09:00.0: BAR 2 [mem
0x38c000000000-0x38dfffffffff 64bit pref]
[  105.503737] pci 0000:09:00.0: BAR 4 [mem
0x38e000000000-0x38e001ffffff 64bit pref]
[  108.699782] pci 0000:09:00.0: Max Payload Size set to 128 (was 256, max =
256)
[  108.701823] pci 0000:09:00.0: Enabling HDA controller
[  108.703015] pci 0000:09:00.0: 252.048 Gb/s available PCIe
bandwidth, limited by 16.0 GT/s PCIe x16 link at 0000:00:02.0 (capable
of 504.112 Gb/s with 32.0 GT/s PCIe x16 link)
[  108.708308] pci 0000:00:02.0: PCI bridge to [bus 09]
[  108.709542] acpiphp: Slot [0-10] registered
[  108.710071] pci 0000:0a:00.0: [1af4:1045] type 00 class 0x00ff00
PCIe Endpoint
[  108.713058] pci 0000:0a:00.0: BAR 4 [mem
0x391000000000-0x391000003fff 64bit pref]
[  108.716785] pci 0000:00:02.1: PCI bridge to [bus 0a]
[  108.718033] acpiphp: Slot [0-11] registered
[  108.718576] pci 0000:0b:00.0: [1af4:1044] type 00 class 0x00ff00
PCIe Endpoint
[  108.721044] pci 0000:0b:00.0: BAR 1 [mem 0x80600000-0x80600fff]
[  108.724184] pci 0000:0b:00.0: BAR 4 [mem
0x391800000000-0x391800003fff 64bit pref]
[  108.728781] pci 0000:00:02.2: PCI bridge to [bus 0b]
[  108.730011] acpiphp: Slot [0-12] registered
[  108.730724] pci 0000:00:02.3: PCI bridge to [bus 0c]
[  108.731839] acpiphp: Slot [0-13] registered
[  108.732536] pci 0000:00:02.4: PCI bridge to [bus 0d]
[  108.733643] acpiphp: Slot [0-14] registered
[  108.734352] pci 0000:00:02.5: PCI bridge to [bus 0e]
[  108.747719] ACPI: PCI: Interrupt link LNKA configured for IRQ 10
[  108.748395] ACPI: PCI: Interrupt link LNKB configured for IRQ 10
[  108.749053] ACPI: PCI: Interrupt link LNKC configured for IRQ 11
[  108.749717] ACPI: PCI: Interrupt link LNKD configured for IRQ 11
[  108.750388] ACPI: PCI: Interrupt link LNKE configured for IRQ 10
[  108.751045] ACPI: PCI: Interrupt link LNKF configured for IRQ 10
[  108.752015] ACPI: PCI: Interrupt link LNKG configured for IRQ 11
[  108.752844] ACPI: PCI: Interrupt link LNKH configured for IRQ 11
[  108.755743] ACPI: PCI: Interrupt link GSIA configured for IRQ 16
[  108.756363] ACPI: PCI: Interrupt link GSIB configured for IRQ 17
[  108.756978] ACPI: PCI: Interrupt link GSIC configured for IRQ 18
[  108.757592] ACPI: PCI: Interrupt link GSID configured for IRQ 19
[  108.758206] ACPI: PCI: Interrupt link GSIE configured for IRQ 20
[  108.758817] ACPI: PCI: Interrupt link GSIF configured for IRQ 21
[  108.759422] ACPI: PCI: Interrupt link GSIG configured for IRQ 22
[  108.759721] ACPI: PCI: Interrupt link GSIH configured for IRQ 23
[  108.760826] iommu: Default domain type: Translated
[  108.760826] iommu: DMA domain TLB invalidation policy: lazy mode
[  108.760998] SCSI subsystem initialized
[  108.763745] ACPI: bus type USB registered
[  108.764158] usbcore: registered new interface driver usbfs
[  108.764158] usbcore: registered new interface driver hub
[  108.764262] usbcore: registered new device driver usb
[  108.764804] pps_core: LinuxPPS API ver. 1 registered
[  108.765327] pps_core: Software ver. 5.3.6 - Copyright 2005-2007
Rodolfo Giometti <giometti@linux.it>
[  108.766311] PTP clock support registered
[  108.767758] EDAC MC: Ver: 3.0.0
[  108.767801] efivars: Registered efivars operations
[  108.768309] NetLabel: Initializing
[  108.768422] NetLabel:  domain hash size =3D 128
[  108.768912] NetLabel:  protocols =3D UNLABELED CIPSOv4 CALIPSO
[  108.769574] NetLabel:  unlabeled traffic allowed by default
[  108.771809] PCI: Using ACPI for IRQ routing
[  108.876471] vgaarb: loaded
[  108.876471] clocksource: Switched to clocksource kvm-clock
[  108.876602] VFS: Disk quotas dquot_6.6.0
[  108.877055] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 byte=
s)
[  108.877939] AppArmor: AppArmor Filesystem Enabled
[  108.878426] pnp: PnP ACPI init
[  108.878723] system 00:04: [mem 0xe0000000-0xefffffff window] has
been reserved
[  108.879556] pnp: PnP ACPI: found 5 devices
[  108.886381] clocksource: acpi_pm: mask: 0xffffff max_cycles:
0xffffff, max_idle_ns: 2085701024 ns
[  108.887284] NET: Registered PF_INET protocol family
[  108.888041] IP idents hash table entries: 262144 (order: 9, 2097152
bytes, linear)
[  108.899134] tcp_listen_portaddr_hash hash table entries: 65536
(order: 8, 1048576 bytes, linear)
[  108.900096] Table-perturb hash table entries: 65536 (order: 6,
262144 bytes, linear)
[  108.901344] TCP established hash table entries: 524288 (order: 10,
4194304 bytes, linear)
[  108.902773] TCP bind hash table entries: 65536 (order: 9, 2097152
bytes, linear)
[  108.903656] TCP: Hash tables configured (established 524288 bind 65536)
[  108.904738] MPTCP token hash table entries: 65536 (order: 8,
1572864 bytes, linear)
[  108.905849] UDP hash table entries: 65536 (order: 9, 2097152 bytes, line=
ar)
[  108.906909] UDP-Lite hash table entries: 65536 (order: 9, 2097152
bytes, linear)
[  108.907828] NET: Registered PF_UNIX/PF_LOCAL protocol family
[  108.908402] NET: Registered PF_XDP protocol family
[  108.908996] pci 0000:01:00.0: ROM [mem 0xfff80000-0xffffffff pref]:
can't claim; no compatible bridge window
[  108.909983] pci 0000:00:01.0: bridge window [io  0x1000-0x0fff] to
[bus 01] add_size 1000
[  108.910794] pci 0000:00:01.1: bridge window [io  0x1000-0x0fff] to
[bus 02] add_size 1000
[  108.911600] pci 0000:00:01.2: bridge window [io  0x1000-0x0fff] to
[bus 03] add_size 1000
[  108.912418] pci 0000:00:01.3: bridge window [io  0x1000-0x0fff] to
[bus 04] add_size 1000
[  108.913229] pci 0000:00:01.4: bridge window [io  0x1000-0x0fff] to
[bus 05] add_size 1000
[  108.914033] pci 0000:00:01.5: bridge window [io  0x1000-0x0fff] to
[bus 06] add_size 1000
[  108.914849] pci 0000:00:01.6: bridge window [io  0x1000-0x0fff] to
[bus 07] add_size 1000
[  108.915657] pci 0000:00:01.7: bridge window [io  0x1000-0x0fff] to
[bus 08] add_size 1000
[  108.916463] pci 0000:00:02.0: bridge window [io  0x1000-0x0fff] to
[bus 09] add_size 1000
[  108.917279] pci 0000:00:02.1: bridge window [io  0x1000-0x0fff] to
[bus 0a] add_size 1000
[  108.918092] pci 0000:00:02.2: bridge window [io  0x1000-0x0fff] to
[bus 0b] add_size 1000
[  108.918909] pci 0000:00:02.3: bridge window [io  0x1000-0x0fff] to
[bus 0c] add_size 1000
[  108.919720] pci 0000:00:02.4: bridge window [io  0x1000-0x0fff] to
[bus 0d] add_size 1000
[  108.920529] pci 0000:00:02.5: bridge window [io  0x1000-0x0fff] to
[bus 0e] add_size 1000
[  108.921341] pci 0000:00:01.0: bridge window [io  0x1000-0x1fff]: assigne=
d
[  108.922011] pci 0000:00:01.1: bridge window [io  0x2000-0x2fff]: assigne=
d
[  108.922681] pci 0000:00:01.2: bridge window [io  0x3000-0x3fff]: assigne=
d
[  108.923350] pci 0000:00:01.3: bridge window [io  0x4000-0x4fff]: assigne=
d
[  108.924034] pci 0000:00:01.4: bridge window [io  0x5000-0x5fff]: assigne=
d
[  108.924709] pci 0000:00:01.5: bridge window [io  0x7000-0x7fff]: assigne=
d
[  108.925377] pci 0000:00:01.6: bridge window [io  0x8000-0x8fff]: assigne=
d
[  108.926050] pci 0000:00:01.7: bridge window [io  0x9000-0x9fff]: assigne=
d
[  108.926725] pci 0000:00:02.0: bridge window [io  0xa000-0xafff]: assigne=
d
[  108.927401] pci 0000:00:02.1: bridge window [io  0xb000-0xbfff]: assigne=
d
[  108.928080] pci 0000:00:02.2: bridge window [io  0xc000-0xcfff]: assigne=
d
[  108.928754] pci 0000:00:02.3: bridge window [io  0xd000-0xdfff]: assigne=
d
[  108.929423] pci 0000:00:02.4: bridge window [io  0xe000-0xefff]: assigne=
d
[  108.930100] pci 0000:00:02.5: bridge window [io  0xf000-0xffff]: assigne=
d
[  108.930774] pci 0000:01:00.0: ROM [mem 0x81a80000-0x81afffff pref]: assi=
gned
[  108.931466] pci 0000:00:01.0: PCI bridge to [bus 01]
[  108.931972] pci 0000:00:01.0:   bridge window [io  0x1000-0x1fff]
[  108.934008] pci 0000:00:01.0:   bridge window [mem 0x81a00000-0x81bfffff=
]
[  108.935485] pci 0000:00:01.0:   bridge window [mem
0x38e800000000-0x38efffffffff 64bit pref]
[  108.938223] pci 0000:00:01.1: PCI bridge to [bus 02]
[  108.938752] pci 0000:00:01.1:   bridge window [io  0x2000-0x2fff]
[  108.940721] pci 0000:00:01.1:   bridge window [mem 0x81800000-0x819fffff=
]
[  108.942267] pci 0000:00:01.1:   bridge window [mem
0x38f000000000-0x38f7ffffffff 64bit pref]
[  108.946861] pci 0000:00:01.2: PCI bridge to [bus 03]
[  108.947372] pci 0000:00:01.2:   bridge window [io  0x3000-0x3fff]
[  108.948801] pci 0000:00:01.2:   bridge window [mem 0x81600000-0x817fffff=
]
[  108.949965] pci 0000:00:01.2:   bridge window [mem
0x38f800000000-0x38ffffffffff 64bit pref]
[  108.951897] pci 0000:00:01.3: PCI bridge to [bus 04]
[  108.952414] pci 0000:00:01.3:   bridge window [io  0x4000-0x4fff]
[  108.953873] pci 0000:00:01.3:   bridge window [mem 0x81400000-0x815fffff=
]
[  108.955155] pci 0000:00:01.3:   bridge window [mem
0x390000000000-0x3907ffffffff 64bit pref]
[  108.957710] pci 0000:00:01.4: PCI bridge to [bus 05]
[  108.961665] pci 0000:00:01.4:   bridge window [io  0x5000-0x5fff]
[  108.963129] pci 0000:00:01.4:   bridge window [mem 0x81200000-0x813fffff=
]
[  108.964291] pci 0000:00:01.4:   bridge window [mem
0x390800000000-0x390fffffffff 64bit pref]
[  108.966059] pci 0000:00:01.5: PCI bridge to [bus 06]
[  108.966559] pci 0000:00:01.5:   bridge window [io  0x7000-0x7fff]
[  108.967888] pci 0000:00:01.5:   bridge window [mem 0x81000000-0x811fffff=
]
[  109.409354] pci 0000:00:01.5:   bridge window [mem
0x380000000000-0x382002ffffff 64bit pref]
[  112.221077] pci 0000:00:01.6: PCI bridge to [bus 07]
[  112.222460] pci 0000:00:01.6:   bridge window [io  0x8000-0x8fff]
[  112.224133] pci 0000:00:01.6:   bridge window [mem 0x80e00000-0x80ffffff=
]
[  112.664541] pci 0000:00:01.6:   bridge window [mem
0x384000000000-0x386002ffffff 64bit pref]
[  115.460093] pci 0000:00:01.7: PCI bridge to [bus 08]
[  115.461289] pci 0000:00:01.7:   bridge window [io  0x9000-0x9fff]
[  115.462944] pci 0000:00:01.7:   bridge window [mem 0x80c00000-0x80dfffff=
]
[  115.903652] pci 0000:00:01.7:   bridge window [mem
0x388000000000-0x38a002ffffff 64bit pref]
[  118.683234] pci 0000:00:02.0: PCI bridge to [bus 09]
[  118.684442] pci 0000:00:02.0:   bridge window [io  0xa000-0xafff]
[  118.686015] pci 0000:00:02.0:   bridge window [mem 0x80a00000-0x80bfffff=
]
[  119.120481] pci 0000:00:02.0:   bridge window [mem
0x38c000000000-0x38e002ffffff 64bit pref]
[  121.867344] pci 0000:00:02.1: PCI bridge to [bus 0a]
[  121.868590] pci 0000:00:02.1:   bridge window [io  0xb000-0xbfff]
[  121.870150] pci 0000:00:02.1:   bridge window [mem 0x80800000-0x809fffff=
]
[  121.871384] pci 0000:00:02.1:   bridge window [mem
0x391000000000-0x3917ffffffff 64bit pref]
[  121.873293] pci 0000:00:02.2: PCI bridge to [bus 0b]
[  121.873849] pci 0000:00:02.2:   bridge window [io  0xc000-0xcfff]
[  121.875333] pci 0000:00:02.2:   bridge window [mem 0x80600000-0x807fffff=
]
[  121.876596] pci 0000:00:02.2:   bridge window [mem
0x391800000000-0x391fffffffff 64bit pref]
[  121.878632] pci 0000:00:02.3: PCI bridge to [bus 0c]
[  121.882584] pci 0000:00:02.3:   bridge window [io  0xd000-0xdfff]
[  121.884186] pci 0000:00:02.3:   bridge window [mem 0x80400000-0x805fffff=
]
[  121.885428] pci 0000:00:02.3:   bridge window [mem
0x392000000000-0x3927ffffffff 64bit pref]
[  121.887330] pci 0000:00:02.4: PCI bridge to [bus 0d]
[  121.887890] pci 0000:00:02.4:   bridge window [io  0xe000-0xefff]
[  121.889335] pci 0000:00:02.4:   bridge window [mem 0x80200000-0x803fffff=
]
[  121.890578] pci 0000:00:02.4:   bridge window [mem
0x392800000000-0x392fffffffff 64bit pref]
[  121.895434] pci 0000:00:02.5: PCI bridge to [bus 0e]
[  121.896009] pci 0000:00:02.5:   bridge window [io  0xf000-0xffff]
[  121.897484] pci 0000:00:02.5:   bridge window [mem 0x80000000-0x801fffff=
]
[  121.898678] pci 0000:00:02.5:   bridge window [mem
0x393000000000-0x3937ffffffff 64bit pref]
[  121.900541] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[  121.901218] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[  121.901890] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff windo=
w]
[  121.902640] pci_bus 0000:00: resource 7 [mem 0x80000000-0xdfffffff windo=
w]
[  121.903382] pci_bus 0000:00: resource 8 [mem 0xf0000000-0xfebfffff windo=
w]
[  121.904258] pci_bus 0000:00: resource 9 [mem
0x380000000000-0x3937ffffffff window]
[  121.907543] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
[  121.908181] pci_bus 0000:01: resource 1 [mem 0x81a00000-0x81bfffff]
[  121.908869] pci_bus 0000:01: resource 2 [mem
0x38e800000000-0x38efffffffff 64bit pref]
[  121.909728] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[  121.910343] pci_bus 0000:02: resource 1 [mem 0x81800000-0x819fffff]
[  121.911028] pci_bus 0000:02: resource 2 [mem
0x38f000000000-0x38f7ffffffff 64bit pref]
[  121.911890] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[  121.912510] pci_bus 0000:03: resource 1 [mem 0x81600000-0x817fffff]
[  121.913200] pci_bus 0000:03: resource 2 [mem
0x38f800000000-0x38ffffffffff 64bit pref]
[  121.914053] pci_bus 0000:04: resource 0 [io  0x4000-0x4fff]
[  121.914667] pci_bus 0000:04: resource 1 [mem 0x81400000-0x815fffff]
[  121.915357] pci_bus 0000:04: resource 2 [mem
0x390000000000-0x3907ffffffff 64bit pref]
[  121.916226] pci_bus 0000:05: resource 0 [io  0x5000-0x5fff]
[  121.916837] pci_bus 0000:05: resource 1 [mem 0x81200000-0x813fffff]
[  121.917526] pci_bus 0000:05: resource 2 [mem
0x390800000000-0x390fffffffff 64bit pref]
[  121.918456] pci_bus 0000:06: resource 0 [io  0x7000-0x7fff]
[  121.919188] pci_bus 0000:06: resource 1 [mem 0x81000000-0x811fffff]
[  121.919987] pci_bus 0000:06: resource 2 [mem
0x380000000000-0x382002ffffff 64bit pref]
[  121.920975] pci_bus 0000:07: resource 0 [io  0x8000-0x8fff]
[  121.921682] pci_bus 0000:07: resource 1 [mem 0x80e00000-0x80ffffff]
[  121.922463] pci_bus 0000:07: resource 2 [mem
0x384000000000-0x386002ffffff 64bit pref]
[  121.923375] pci_bus 0000:08: resource 0 [io  0x9000-0x9fff]
[  121.923990] pci_bus 0000:08: resource 1 [mem 0x80c00000-0x80dfffff]
[  121.924669] pci_bus 0000:08: resource 2 [mem
0x388000000000-0x38a002ffffff 64bit pref]
[  121.925523] pci_bus 0000:09: resource 0 [io  0xa000-0xafff]
[  121.926135] pci_bus 0000:09: resource 1 [mem 0x80a00000-0x80bfffff]
[  121.926811] pci_bus 0000:09: resource 2 [mem
0x38c000000000-0x38e002ffffff 64bit pref]
[  121.927738] pci_bus 0000:0a: resource 0 [io  0xb000-0xbfff]
[  121.928346] pci_bus 0000:0a: resource 1 [mem 0x80800000-0x809fffff]
[  121.929033] pci_bus 0000:0a: resource 2 [mem
0x391000000000-0x3917ffffffff 64bit pref]
[  121.929904] pci_bus 0000:0b: resource 0 [io  0xc000-0xcfff]
[  121.930507] pci_bus 0000:0b: resource 1 [mem 0x80600000-0x807fffff]
[  121.931191] pci_bus 0000:0b: resource 2 [mem
0x391800000000-0x391fffffffff 64bit pref]
[  121.932056] pci_bus 0000:0c: resource 0 [io  0xd000-0xdfff]
[  121.932663] pci_bus 0000:0c: resource 1 [mem 0x80400000-0x805fffff]
[  121.933332] pci_bus 0000:0c: resource 2 [mem
0x392000000000-0x3927ffffffff 64bit pref]
[  121.934171] pci_bus 0000:0d: resource 0 [io  0xe000-0xefff]
[  121.934763] pci_bus 0000:0d: resource 1 [mem 0x80200000-0x803fffff]
[  121.935428] pci_bus 0000:0d: resource 2 [mem
0x392800000000-0x392fffffffff 64bit pref]
[  121.936283] pci_bus 0000:0e: resource 0 [io  0xf000-0xffff]
[  121.936881] pci_bus 0000:0e: resource 1 [mem 0x80000000-0x801fffff]
[  121.937544] pci_bus 0000:0e: resource 2 [mem
0x393000000000-0x3937ffffffff 64bit pref]
[  121.938715] ACPI: \_SB_.GSIF: Enabled at IRQ 21
[  121.940275] PCI: CLS 32 bytes, default 64
[  121.940738] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[  121.941416] software IO TLB: mapped [mem
0x0000000077f7f000-0x000000007bf7f000] (64MB)
[  121.942286] clocksource: tsc: mask: 0xffffffffffffffff max_cycles:
0x39a85c9bff6, max_idle_ns: 881590591483 ns
[  121.943398] Trying to unpack rootfs image as initramfs...
[  121.946797] Initialise system trusted keyrings
[  121.947796] Key type blacklist registered
[  121.948874] workingset: timestamp_bits=3D36 max_order=3D28 bucket_order=
=3D0
[  121.950136] zbud: loaded
[  121.950926] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[  121.952373] fuse: init (API version 7.41)
[  121.953545] integrity: Platform Keyring initialized
[  121.965005] Key type asymmetric registered
[  121.965752] Asymmetric key parser 'x509' registered
[  121.966671] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 243)
[  121.968374] io scheduler mq-deadline registered
[  121.973937] ledtrig-cpu: registered to indicate activity on CPUs
[  121.976718] pcieport 0000:00:01.0: PME: Signaling with IRQ 24
[  121.978095] pcieport 0000:00:01.0: AER: enabled with IRQ 24
[  121.980625] pcieport 0000:00:01.1: PME: Signaling with IRQ 25
[  121.981978] pcieport 0000:00:01.1: AER: enabled with IRQ 25
[  121.984752] pcieport 0000:00:01.2: PME: Signaling with IRQ 26
[  121.986088] pcieport 0000:00:01.2: AER: enabled with IRQ 26
[  121.988893] pcieport 0000:00:01.3: PME: Signaling with IRQ 27
[  121.990224] pcieport 0000:00:01.3: AER: enabled with IRQ 27
[  121.994074] pcieport 0000:00:01.4: PME: Signaling with IRQ 28
[  121.995425] pcieport 0000:00:01.4: AER: enabled with IRQ 28
[  121.997834] pcieport 0000:00:01.5: PME: Signaling with IRQ 29
[  121.999189] pcieport 0000:00:01.5: AER: enabled with IRQ 29
[  122.001640] pcieport 0000:00:01.6: PME: Signaling with IRQ 30
[  122.002967] pcieport 0000:00:01.6: AER: enabled with IRQ 30
[  122.005684] pcieport 0000:00:01.7: PME: Signaling with IRQ 31
[  122.007019] pcieport 0000:00:01.7: AER: enabled with IRQ 31
[  122.008631] ACPI: \_SB_.GSIG: Enabled at IRQ 22
[  122.010594] pcieport 0000:00:02.0: PME: Signaling with IRQ 32
[  122.011908] pcieport 0000:00:02.0: AER: enabled with IRQ 32
[  122.014599] pcieport 0000:00:02.1: PME: Signaling with IRQ 33
[  122.015938] pcieport 0000:00:02.1: AER: enabled with IRQ 33
[  122.018673] pcieport 0000:00:02.2: PME: Signaling with IRQ 34
[  122.020009] pcieport 0000:00:02.2: AER: enabled with IRQ 34
[  122.022705] pcieport 0000:00:02.3: PME: Signaling with IRQ 35
[  122.024038] pcieport 0000:00:02.3: AER: enabled with IRQ 35
[  122.026700] pcieport 0000:00:02.4: PME: Signaling with IRQ 36
[  122.028065] pcieport 0000:00:02.4: AER: enabled with IRQ 36
[  122.030767] pcieport 0000:00:02.5: PME: Signaling with IRQ 37
[  122.033879] pcieport 0000:00:02.5: AER: enabled with IRQ 37
[  122.035354] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[  122.036770] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[  122.038219] ACPI: button: Power Button [PWRF]
[  122.050902] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[  122.077373] 00:00: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200)
is a 16550A
[  122.091765] Linux agpgart interface v0.103
[  122.107045] loop: module loaded
[  122.107936] tun: Universal TUN/TAP device driver, 1.6
[  122.108894] PPP generic driver version 2.4.2
[  122.109836] VFIO - User Level meta-driver version: 0.3
[  122.111923] xhci_hcd 0000:02:00.0: xHCI Host Controller
[  122.112928] xhci_hcd 0000:02:00.0: new USB bus registered, assigned
bus number 1
[  122.114613] xhci_hcd 0000:02:00.0: hcc params 0x00087001 hci
version 0x100 quirks 0x0000000000000010
[  122.117456] xhci_hcd 0000:02:00.0: xHCI Host Controller
[  122.118420] xhci_hcd 0000:02:00.0: new USB bus registered, assigned
bus number 2
[  122.119784] xhci_hcd 0000:02:00.0: Host supports USB 3.0 SuperSpeed
[  122.121002] usb usb1: New USB device found, idVendor=3D1d6b,
idProduct=3D0002, bcdDevice=3D 6.12
[  122.122679] usb usb1: New USB device strings: Mfr=3D3, Product=3D2,
SerialNumber=3D1
[  122.123981] usb usb1: Product: xHCI Host Controller
[  122.124876] usb usb1: Manufacturer: Linux 6.12.1+ xhci-hcd
[  122.125878] usb usb1: SerialNumber: 0000:02:00.0
[  122.126870] hub 1-0:1.0: USB hub found
[  122.127652] hub 1-0:1.0: 15 ports detected
[  122.129055] usb usb2: We don't know the algorithms for LPM for this
host, disabling LPM.
[  122.130565] usb usb2: New USB device found, idVendor=3D1d6b,
idProduct=3D0003, bcdDevice=3D 6.12
[  122.132081] usb usb2: New USB device strings: Mfr=3D3, Product=3D2,
SerialNumber=3D1
[  122.133408] usb usb2: Product: xHCI Host Controller
[  122.134310] usb usb2: Manufacturer: Linux 6.12.1+ xhci-hcd
[  122.135325] usb usb2: SerialNumber: 0000:02:00.0
[  122.136291] hub 2-0:1.0: USB hub found
[  122.137078] hub 2-0:1.0: 15 ports detected
[  122.138532] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU]
at 0x60,0x64 irq 1,12
[  122.140846] serio: i8042 KBD port at 0x60,0x64 irq 1
[  122.141773] serio: i8042 AUX port at 0x60,0x64 irq 12
[  122.142858] mousedev: PS/2 mouse device common for all mice
[  122.144050] rtc_cmos 00:03: RTC can wake from S4
[  122.145799] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input1
[  122.147424] rtc_cmos 00:03: registered as rtc0
[  122.148361] rtc_cmos 00:03: setting system clock to
2024-12-03T16:27:36 UTC (1733243256)
[  122.149924] rtc_cmos 00:03: alarms up to one day, y3k, 242 bytes nvram
[  122.151125] i2c_dev: i2c /dev entries driver
[  122.151943] device-mapper: core: CONFIG_IMA_DISABLE_HTABLE is
disabled. Duplicate IMA measurements will not be recorded in the IMA
log.
[  122.154834] device-mapper: uevent: version 1.0.3
[  122.155773] device-mapper: ioctl: 4.48.0-ioctl (2023-03-01)
initialised: dm-devel@lists.linux.dev
[  122.157444] platform eisa.0: Probing EISA bus 0
[  122.158290] platform eisa.0: EISA: Cannot allocate resource for mainboar=
d
[  122.159554] platform eisa.0: Cannot allocate resource for EISA slot 1
[  122.160759] platform eisa.0: Cannot allocate resource for EISA slot 2
[  122.161946] platform eisa.0: Cannot allocate resource for EISA slot 3
[  122.163142] platform eisa.0: Cannot allocate resource for EISA slot 4
[  122.164343] platform eisa.0: Cannot allocate resource for EISA slot 5
[  122.165558] platform eisa.0: Cannot allocate resource for EISA slot 6
[  122.166759] platform eisa.0: Cannot allocate resource for EISA slot 7
[  122.167954] platform eisa.0: Cannot allocate resource for EISA slot 8
[  122.169151] platform eisa.0: EISA: Detected 0 cards
[  122.170063] intel_pstate: CPU model not supported
[  122.170989] drop_monitor: Initializing network drop monitor service
[  122.172282] NET: Registered PF_INET6 protocol family
[  122.360845] Freeing initrd memory: 153788K
[  122.374297] Segment Routing with IPv6
[  122.374986] In-situ OAM (IOAM) with IPv6
[  122.375726] NET: Registered PF_PACKET protocol family
[  122.376806] Key type dns_resolver registered
[  122.380068] IPI shorthand broadcast: enabled
[  122.382606] sched_clock: Marking stable (122276003177,
104016675)->(123280420697, -900400845)
[  122.385188] registered taskstats version 1
[  122.388284] Loading compiled-in X.509 certificates
[  122.389880] Loaded X.509 cert 'Build time autogenerated kernel key:
a334e9265a36cd441018dea4fd4f8ea3cf5a815a'
[  122.393629] Demotion targets for Node 0: null
[  122.397029] Key type .fscrypt registered
[  122.397812] Key type fscrypt-provisioning registered
[  122.398801] Key type trusted registered
[  122.406641] cryptd: max_cpu_qlen set to 1000
[  122.411728] AES CTR mode by8 optimization enabled
[  122.431382] Key type encrypted registered
[  122.433172] AppArmor: AppArmor sha256 policy hashing enabled
[  122.436139] Loading compiled-in module X.509 certificates
[  122.438446] Loaded X.509 cert 'Build time autogenerated kernel key:
a334e9265a36cd441018dea4fd4f8ea3cf5a815a'
[  122.440242] ima: Allocated hash algorithm: sha1
[  122.460066] ima: No architecture policies found
[  122.460931] evm: Initialising EVM extended attributes:
[  122.461920] evm: security.selinux
[  122.462593] evm: security.SMACK64
[  122.463233] evm: security.SMACK64EXEC
[  122.463927] evm: security.SMACK64TRANSMUTE
[  122.464772] evm: security.SMACK64MMAP
[  122.465456] evm: security.apparmor
[  122.466101] evm: security.ima
[  122.466660] evm: security.capability
[  122.467334] evm: HMAC attrs: 0x1
[  122.468278] PM:   Magic number: 4:334:438
[  122.469151] memory memory1493: hash matches
[  122.470741] RAS: Correctable Errors collector initialized.
[  122.486309] clk: Disabling unused clocks
[  122.487032] PM: genpd: Disabling unused power domains
[  122.499660] Freeing unused decrypted memory: 2028K
[  122.501317] Freeing unused kernel image (initmem) memory: 5092K
[  122.502216] Write protecting the kernel read-only data: 34816k
[  122.504631] Freeing unused kernel image (rodata/data gap) memory: 608K
[  122.517808] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[  122.518639] Run /init as init process
Loading, please wait...
Starting version 249.11-0ubuntu3.12
[  122.674492] virtio_blk virtio2: 16/0/0 default/read/poll queues
[  122.678745] virtio_blk virtio2: [vda] 125829120 512-byte logical
blocks (64.4 GB/60.0 GiB)
[  122.681387] lpc_ich 0000:00:1f.0: I/O space for GPIO uninitialized
[  122.684588] ACPI: \_SB_.GSIA: Enabled at IRQ 16
[  122.685631]  vda: vda1 vda14 vda15
[  122.687232] input: VirtualPS/2 VMware VMMouse as
/devices/platform/i8042/serio1/input/input4
[  122.687881] i801_smbus 0000:00:1f.3: Enabling SMBus device
[  122.687929] virtio_blk virtio3: 16/0/0 default/read/poll queues
[  122.690964] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[  122.691005] input: VirtualPS/2 VMware VMMouse as
/devices/platform/i8042/serio1/input/input3
[  122.691549] ahci 0000:00:1f.2: AHCI vers 0001.0000, 32 command
slots, 1.5 Gbps, SATA mode
[  122.691554] ahci 0000:00:1f.2: 6/6 ports implemented (port mask 0x3f)
[  122.691556] ahci 0000:00:1f.2: flags: 64bit ncq only
[  122.692421] i2c i2c-0: Memory type 0x07 not supported yet, not
instantiating SPD
[  122.698161] virtio_blk virtio3: [vdb] 732 512-byte logical blocks
(375 kB/366 KiB)
[  122.699563] scsi host0: ahci
[  122.701581] scsi host1: ahci
[  122.702638] scsi host2: ahci
[  122.703511] scsi host3: ahci
[  122.704471] scsi host4: ahci
[  122.705343] scsi host5: ahci
[  122.706090] ata1: SATA max UDMA/133 abar m4096@0x81c80000 port
0x81c80100 irq 78 lpm-pol 0
[  122.707777] ata2: SATA max UDMA/133 abar m4096@0x81c80000 port
0x81c80180 irq 78 lpm-pol 0
[  122.709481] ata3: SATA max UDMA/133 abar m4096@0x81c80000 port
0x81c80200 irq 78 lpm-pol 0
[  122.711199] ata4: SATA max UDMA/133 abar m4096@0x81c80000 port
0x81c80280 irq 78 lpm-pol 0
[  122.712924] ata5: SATA max UDMA/133 abar m4096@0x81c80000 port
0x81c80300 irq 78 lpm-pol 0
[  122.714629] ata6: SATA max UDMA/133 abar m4096@0x81c80000 port
0x81c80380 irq 78 lpm-pol 0
[  122.718413] ACPI: bus type drm_connector registered
[  122.740509] virtio_net virtio0 enp1s0: renamed from eth0
[  123.024930] ata6: SATA link down (SStatus 0 SControl 300)
[  123.026502] ata5: SATA link down (SStatus 0 SControl 300)
[  123.028921] ata1: SATA link down (SStatus 0 SControl 300)
[  123.030372] ata2: SATA link down (SStatus 0 SControl 300)
[  123.031312] ata4: SATA link down (SStatus 0 SControl 300)
[  123.032536] ata3: SATA link down (SStatus 0 SControl 300)
[  123.173176] nvidia: loading out-of-tree module taints kernel.
[  123.173681] nvidia: module license 'NVIDIA' taints kernel.
[  123.174142] Disabling lock debugging due to kernel taint
[  123.174581] nvidia: module verification failed: signature and/or
required key missing - tainting kernel
[  123.175340] nvidia: module license taints kernel.
[  123.235766] nvidia-nvlink: Nvlink Core is being initialized, major
device number 237
[  123.236368] NVRM: loading NVIDIA UNIX x86_64 Kernel Module
550.127.05  Tue Oct  8 03:22:07 UTC 2024
[  123.270498] nvidia-modeset: Loading NVIDIA Kernel Mode Setting
Driver for UNIX platforms  550.127.05  Tue Oct  8 02:56:05 UTC 2024
[  123.273186] [drm] [nvidia-drm] [GPU ID 0x00000600] Loading driver
[  123.273666] [drm] Initialized nvidia-drm 0.0.0 for 0000:06:00.0 on minor=
 0
[  123.274250] [drm] [nvidia-drm] [GPU ID 0x00000700] Loading driver
[  123.274721] [drm] Initialized nvidia-drm 0.0.0 for 0000:07:00.0 on minor=
 1
[  123.275281] [drm] [nvidia-drm] [GPU ID 0x00000800] Loading driver
[  123.275726] [drm] Initialized nvidia-drm 0.0.0 for 0000:08:00.0 on minor=
 2
[  123.276300] [drm] [nvidia-drm] [GPU ID 0x00000900] Loading driver
[  123.276747] [drm] Initialized nvidia-drm 0.0.0 for 0000:09:00.0 on minor=
 3
Begin: Loading essential drivers ... [  124.444121] raid6: avx512x4
gen() 14024 MB/s
[  124.512117] raid6: avx512x2 gen() 13329 MB/s
[  124.580114] raid6: avx512x1 gen() 11168 MB/s
[  124.648131] raid6: avx2x4   gen() 13885 MB/s
[  124.716116] raid6: avx2x2   gen() 13625 MB/s
[  124.784135] raid6: avx2x1   gen() 10338 MB/s
[  124.784746] raid6: using algorithm avx512x4 gen() 14024 MB/s
[  124.852129] raid6: .... xor() 2366 MB/s, rmw enabled
[  124.852812] raid6: using avx512x2 recovery algorithm
[  124.858683] xor: automatically using best checksumming function   avx
[  124.861463] async_tx: api initialized (async)
done.
Begin: Running /scripts/init-premount ... done.
Begin: Mounting root file system ... Begin: Running /scripts/local-top ... =
done.
Begin: Running /scripts/local-premount ... [  125.020923] Btrfs
loaded, zoned=3Dyes, fsverity=3Dyes
Scanning for Btrfs filesystems
done.
Begin: Will now check root file system ... fsck from util-linux 2.37.2
[/usr/sbin/fsck.ext4 (1) -- /dev/vda1] fsck.ext4 -a -C0 /dev/vda1
cloudimg-rootfs: clean, 319639/7741440 files, 9800501/15700219 blocks
done.
[  125.104557] EXT4-fs (vda1): mounted filesystem
fec1c9ae-0df3-419c-80dd-f3035049b845 ro with ordered data mode. Quota
mode: none.
done.
Begin: Running /scripts/local-bottom ... done.
Begin: Running /scripts/init-bottom ... done.
[  125.426670] systemd[1]: Inserted module 'autofs4'
[  125.461519] systemd[1]: systemd 249.11-0ubuntu3.12 running in
system mode (+PAM +AUDIT +SELINUX +APPARMOR +IMA +SMACK +SECCOMP
+GCRYPT +GNUTLS +OPENSSL +ACL +BLKID +CURL +ELFUTILS +FIDO2 +IDN2 -IDN
+IPTC +KMOD +LIBCRYPTSETUP +LIBFDISK +PCRE2 -PWQUALITY -P11KIT
-QRENCODE +BZIP2 +LZ4 +XZ +ZLIB +ZSTD -XKBCOMMON +UTMP +SYSVINIT
default-hierarchy=3Dunified)
[  125.466514] systemd[1]: Detected virtualization kvm.
[  125.467306] systemd[1]: Detected architecture x86-64.

Welcome to Ubuntu 22.04.5 LTS!

[  125.473943] systemd[1]: Hostname set to <testbox01>.
[  125.570639] block vda: the capability attribute has been deprecated.
[  125.753768] systemd[1]: Configuration file
/run/systemd/system/netplan-ovs-cleanup.service is marked
world-inaccessible. This has no effect as configuration data is
accessible via APIs without restrictions. Proceeding anyway.
[  125.900517] systemd[1]: Queued start job for default target
Graphical Interface.
[  125.949481] systemd[1]: Created slice Slice /system/modprobe.
[  OK  ] Created slice Slice /system/modprobe.
[  125.952530] systemd[1]: Created slice Slice /system/serial-getty.
[  OK  ] Created slice Slice /system/serial-getty.
[  125.955756] systemd[1]: Created slice Slice /system/systemd-fsck.
[  OK  ] Created slice Slice /system/systemd-fsck.
[  125.958807] systemd[1]: Created slice User and Session Slice.
[  OK  ] Created slice User and Session Slice.
[  125.961733] systemd[1]: Started Forward Password Requests to Wall
Directory Watch.
[  OK  ] Started Forward Password R=E2=80=A6uests to Wall Directory Watch.
[  125.965141] systemd[1]: Set up automount Arbitrary Executable File
Formats File System Automount Point.
[  OK  ] Set up automount Arbitrary=E2=80=A6s File System Automount Point.
[  125.968947] systemd[1]: Reached target Slice Units.
[  OK  ] Reached target Slice Units.
[  125.971127] systemd[1]: Reached target Mounting snaps.
[  OK  ] Reached target Mounting snaps.
[  125.973462] systemd[1]: Reached target Swaps.
[  OK  ] Reached target Swaps.
[  125.975501] systemd[1]: Reached target Local Verity Protected Volumes.
[  OK  ] Reached target Local Verity Protected Volumes.
[  125.978315] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[  OK  ] Listening on Device-mapper event daemon FIFOs.
[  125.981118] systemd[1]: Listening on LVM2 poll daemon socket.
[  OK  ] Listening on LVM2 poll daemon socket.
[  125.983685] systemd[1]: Listening on multipathd control socket.
[  OK  ] Listening on multipathd control socket.
[  125.986288] systemd[1]: Listening on Syslog Socket.
[  OK  ] Listening on Syslog Socket.
[  125.988464] systemd[1]: Listening on fsck to fsckd communication Socket.
[  OK  ] Listening on fsck to fsckd communication Socket.
[  125.991243] systemd[1]: Listening on initctl Compatibility Named Pipe.
[  OK  ] Listening on initctl Compatibility Named Pipe.
[  125.994119] systemd[1]: Listening on Journal Audit Socket.
[  OK  ] Listening on Journal Audit Socket.
[  125.996440] systemd[1]: Listening on Journal Socket (/dev/log).
[  OK  ] Listening on Journal Socket (/dev/log).
[  125.999168] systemd[1]: Listening on Journal Socket.
[  OK  ] Listening on Journal Socket.
[  126.001774] systemd[1]: Listening on Network Service Netlink Socket.
[  OK  ] Listening on Network Service Netlink Socket.
[  126.004578] systemd[1]: Listening on udev Control Socket.
[  OK  ] Listening on udev Control Socket.
[  126.006914] systemd[1]: Listening on udev Kernel Socket.
[  OK  ] Listening on udev Kernel Socket.
[  126.048544] systemd[1]: Mounting Huge Pages File System...
         Mounting Huge Pages File System...
[  126.056776] systemd[1]: Mounting POSIX Message Queue File System...
         Mounting POSIX Message Queue File System...
[  126.060599] systemd[1]: Mounting Kernel Debug File System...
         Mounting Kernel Debug File System...
[  126.063872] systemd[1]: Mounting Kernel Trace File System...
         Mounting Kernel Trace File System...
[  126.070076] systemd[1]: Starting Journal Service...
         Starting Journal Service...
[  126.073342] systemd[1]: Starting Set the console keyboard layout...
         Starting Set the console keyboard layout...
[  126.078999] systemd[1]: Starting Create List of Static Device Nodes...
         Starting Create List of Static Device Nodes...
[  126.082762] systemd[1]: Starting Monitoring of LVM2 mirrors,
snapshots etc. using dmeventd or progress polling...
         Starting Monitoring of LVM=E2=80=A6meventd or progress polling...
[  126.086481] systemd[1]: Condition check resulted in LXD - agent
being skipped.
[  126.088782] systemd[1]: Starting Load Kernel Module configfs...
         Starting Load Kernel Module configfs...
[  126.092533] systemd[1]: Starting Load Kernel Module drm...
         Starting Load Kernel Module drm...
[  126.095921] systemd[1]: Starting Load Kernel Module efi_pstore...
         Starting Load Kernel Module efi_pstore...
[  126.100140] systemd[1]: Starting Load Kernel Module fuse...
         Starting Load Kernel Module fuse...
[  126.102609] systemd[1]: Condition check resulted in OpenVSwitch
configuration for cleanup being skipped.
[  126.102740] pstore: Using crash dump compression: deflate
[  126.104171] systemd[1]: Condition check resulted in File System
Check on Root Device being skipped.
[  126.105766] pstore: Registered efi_pstore as persistent store backend
[  126.108314] systemd[1]: Starting Load Kernel Modules...
         Starting Load Kernel Modules...
[  126.111966] systemd[1]: Starting Remount Root and Kernel File Systems...
         Starting Remount Root and Kernel File Systems...
[  126.116526] systemd[1]: Starting Coldplug All udev Devices...
         Starting Coldplug All udev Devices...
[  126.121124] systemd[1]: Started Journal Service.
[  OK  ] Started Journal Service.
[  OK  ] Mounted Huge Pages File System.
[  OK  ] Mounted POSIX Message Queue File System.
[  OK  ] Mounted Kernel Debug File System.
[  OK  ] Mounted Kernel Trace File System.
[  OK  ] Finished Create List of Static Device Nodes.
[  OK  ] Finished Load Kernel Module configfs.
[  OK  ] Finished Load Kernel Module drm.
[  OK  ] Finished Load Kernel Module efi_pstore.
[  OK  ] Finished Load Kernel Module fuse.
[  OK  ] Finished Set the console keyboard layout.
[  OK  ] Finished Load Kernel Modules.
         Mounting FUSE Control File System...
         Mounting Kernel Configuration File System...
         Starting Apply Kernel Variables...
[  OK  ] Mounted FUSE Control File System.
[  OK  ] Mounted Kernel Configuration File System.
[  126.161694] EXT4-fs (vda1): re-mounted
fec1c9ae-0df3-419c-80dd-f3035049b845 r/w. Quota mode: none.
[  OK  ] Finished Remount Root and Kernel File Systems.
         Starting Device-Mapper Multipath Device Controller...
         Starting Flush Journal to Persistent Storage...
         Starting Load/Save Random Seed...
         Starting Create System Users...
[  OK  ] Finished Apply Kernel Variables.
[  OK  ] Finished Load/Save Random Seed.
[  OK  ] Finished Create System Users.
[  OK  ] Finished Monitoring of LVM=E2=80=A6 dmeventd or progress polling.
         Starting Create Static Device Nodes in /dev...
[  OK  ] Finished Flush Journal to Persistent Storage.
[  OK  ] Finished Create Static Device Nodes in /dev.
         Starting Rule-based Manage=E2=80=A6for Device Events and Files...
[  OK  ] Started Device-Mapper Multipath Device Controller.
[  OK  ] Reached target Preparation for Local File Systems.
         Mounting Mount unit for core20, revision 2379...
         Mounting Mount unit for lxd, revision 29351...
         Mounting Mount unit for snapd, revision 21759...
[  OK  ] Mounted Mount unit for core20, revision 2379.
[  OK  ] Mounted Mount unit for lxd, revision 29351.
[  OK  ] Mounted Mount unit for snapd, revision 21759.
[  OK  ] Reached target Mounted snaps.
[  OK  ] Finished Coldplug All udev Devices.
[  OK  ] Started Rule-based Manager for Device Events and Files.
[  OK  ] Started Dispatch Password =E2=80=A6ts to Console Directory Watch.
[  OK  ] Reached target Local Encrypted Volumes.
[  OK  ] Found device /dev/ttyS0.
[  OK  ] Found device /dev/disk/by-label/UEFI.
         Starting File System Check on /dev/disk/by-label/UEFI...
[  OK  ] Started File System Check Daemon to report status.
[  OK  ] Finished File System Check on /dev/disk/by-label/UEFI.
         Mounting /boot/efi...
         Starting Load Kernel Module efi_pstore...
[  OK  ] Finished Load Kernel Module efi_pstore.
[  OK  ] Mounted /boot/efi.
[  OK  ] Reached target Local File Systems.
         Starting Load AppArmor profiles...
         Starting Set console font and keymap...
         Starting Create final runt=E2=80=A6dir for shutdown pivot root...
         Starting Tell Plymouth To Write Out Runtime Data...
         Starting Set Up Additional Binary Formats...
         Starting Create Volatile Files and Directories...
         Starting Uncomplicated firewall...
[  OK  ] Finished Set console font and keymap.
[  OK  ] Finished Create final runt=E2=80=A6e dir for shutdown pivot root.
[  OK  ] Finished Tell Plymouth To Write Out Runtime Data.
[  OK  ] Finished Create Volatile Files and Directories.
[  OK  ] Finished Uncomplicated firewall.
[  OK  ] Listening on Load/Save RF =E2=80=A6itch Status /dev/rfkill Watch.
         Mounting Arbitrary Executable File Formats File System...
         Starting Network Time Synchronization...
         Starting Record System Boot/Shutdown in UTMP...
[  OK  ] Finished Load AppArmor profiles.
         Starting Load AppArmor pro=E2=80=A6managed internally by snapd...
         Starting Cloud-init: Local Stage (pre-network)...
[  OK  ] Finished Record System Boot/Shutdown in UTMP.
[  OK  ] Mounted Arbitrary Executable File Formats File System.
[  OK  ] Finished Set Up Additional Binary Formats.
[  OK  ] Finished Load AppArmor pro=E2=80=A6s managed internally by snapd.
[  OK  ] Started Network Time Synchronization.
[  OK  ] Reached target System Time Set.
[  127.373806] cloud-init[747]: Cloud-init v. 24.3.1-0ubuntu0~22.04.1
running 'init-local' at Tue, 03 Dec 2024 16:27:41 +0000. Up 127.34
seconds.
[  OK  ] Finished Cloud-init: Local Stage (pre-network).
[  OK  ] Reached target Preparation for Network.
         Starting Network Configuration...
[  OK  ] Started Network Configuration.
         Starting Wait for Network to be Configured...
         Starting Network Name Resolution...
[  OK  ] Started Network Name Resolution.
[  OK  ] Reached target Network.
[  OK  ] Reached target Host and Network Name Lookups.
[  OK  ] Finished Wait for Network to be Configured.
         Starting Cloud-init: Network Stage...
[  129.244256] cloud-init[767]: Cloud-init v. 24.3.1-0ubuntu0~22.04.1
running 'init' at Tue, 03 Dec 2024 16:27:43 +0000. Up 129.21 seconds.
[  129.259656] cloud-init[767]: ci-info:
++++++++++++++++++++++++++++++++++++++Net device
info++++++++++++++++++++++++++++++++++++++
[  129.262318] cloud-init[767]: ci-info:
+--------+------+----------------------------+---------------+--------+----=
---------------+
[  129.264994] cloud-init[767]: ci-info: | Device |  Up  |
Address           |      Mask     | Scope  |     Hw-Address    |
[  129.267699] cloud-init[767]: ci-info:
+--------+------+----------------------------+---------------+--------+----=
---------------+
[  129.270229] cloud-init[767]: ci-info: | enp1s0 | True |
192.168.122.9        | 255.255.255.0 | global | 52:54:00:04:bc:be |
[  129.272567] cloud-init[767]: ci-info: | enp1s0 | True |
fe80::5054:ff:fe04:bcbe/64 |       .       |  link  |
52:54:00:04:bc:be |
[  129.275181] cloud-init[767]: ci-info: |   lo   | True |
127.0.0.1          |   255.0.0.0   |  host  |         .         |
[  129.277491] cloud-init[767]: ci-info: |   lo   | True |
::1/128           |       .       |  host  |         .         |
[  129.279803] cloud-init[767]: ci-info:
+--------+------+----------------------------+---------------+--------+----=
---------------+
[  129.283716] cloud-init[767]: ci-info:
++++++++++++++++++++++++++++++++Route IPv4
info++++++++++++++++++++++++++++++++
[  129.285855] cloud-init[767]: ci-info:
+-------+---------------+---------------+-----------------+-----------+----=
---+
[  129.288128] cloud-init[767]: ci-info: | Route |  Destination  |
Gateway    |     Genmask     | Interface | Flags |
[  129.290603] cloud-init[767]: ci-info:
+-------+---------------+---------------+-----------------+-----------+----=
---+
[  129.292894] cloud-init[767]: ci-info: |   0   |    0.0.0.0    |
192.168.122.1 |     0.0.0.0     |   enp1s0  |   UG  |
[  129.295710] cloud-init[767]: ci-info: |   1   | 192.168.122.0 |
0.0.0.0    |  255.255.255.0  |   enp1s0  |   U   |
[  129.299083] cloud-init[767]: ci-info: |   2   | 192.168.122.1 |
0.0.0.0    | 255.255.255.255 |   enp1s0  |   UH  |
[  129.302622] cloud-init[767]: ci-info:
+-------+---------------+---------------+-----------------+-----------+----=
---+
[  129.304920] cloud-init[767]: ci-info: +++++++++++++++++++Route IPv6
info+++++++++++++++++++
[  129.306748] cloud-init[767]: ci-info:
+-------+-------------+---------+-----------+-------+
[  129.308992] cloud-init[767]: ci-info: | Route | Destination |
Gateway | Interface | Flags |
[  129.310966] cloud-init[767]: ci-info:
+-------+-------------+---------+-----------+-------+
[  129.312899] cloud-init[767]: ci-info: |   1   |  fe80::/64  |    ::
  |   enp1s0  |   U   |
[  129.314814] cloud-init[767]: ci-info: |   3   |    local    |    ::
  |   enp1s0  |   U   |
[  129.317104] cloud-init[767]: ci-info: |   4   |  multicast  |    ::
  |   enp1s0  |   U   |
[  129.319107] cloud-init[767]: ci-info:
+-------+-------------+---------+-----------+-------+
[  OK  ] Finished Cloud-init: Network Stage.
[  OK  ] Reached target Cloud-config availability.
[  OK  ] Reached target Network is Online.
[  OK  ] Reached target System Initialization.
[  OK  ] Started Daily apt download activities.
[  OK  ] Started Daily apt upgrade and clean activities.
[  OK  ] Started Daily dpkg database backup timer.
[  OK  ] Started Periodic ext4 Onli=E2=80=A6ata Check for All Filesystems.
[  OK  ] Started Discard unused blocks once a week.
[  OK  ] Started Daily rotation of log files.
[  OK  ] Started Daily man-db regeneration.
[  OK  ] Started Message of the Day.
[  OK  ] Started Daily Cleanup of Temporary Directories.
[  OK  ] Started Download data for =E2=80=A6ailed at package install time.
[  OK  ] Started Check to see wheth=E2=80=A6w version of Ubuntu available.
[  OK  ] Reached target Path Units.
[  OK  ] Reached target Timer Units.
[  OK  ] Listening on cloud-init hotplug hook socket.
[  OK  ] Listening on D-Bus System Message Bus Socket.
[  OK  ] Listening on Open-iSCSI iscsid Socket.
[  OK  ] Listening on Socket unix for snap application lxd.daemon.
[  OK  ] Listening on Socket unix f=E2=80=A6p application lxd.user-daemon.
         Starting Socket activation for snappy daemon...
[  OK  ] Listening on UUID daemon activation socket.
[  OK  ] Reached target Preparation for Remote File Systems.
[  OK  ] Reached target Remote File Systems.
[  OK  ] Finished Availability of block devices.
[  OK  ] Listening on Socket activation for snappy daemon.
[  OK  ] Reached target Socket Units.
[  OK  ] Reached target Basic System.
         Starting LSB: automatic crash report generation...
[  OK  ] Started Regular background program processing daemon.
[  OK  ] Started D-Bus System Message Bus.
[  OK  ] Started Save initial kernel messages after boot.
         Starting Remove Stale Onli=E2=80=A6t4 Metadata Check Snapshots...
         Starting Record successful boot for GRUB...
[  OK  ] Started irqbalance daemon.
         Starting Dispatcher daemon for systemd-networkd...
         Starting NVIDIA Persistence Daemon...
         Starting System Logging Service...
         Starting Service for snap application lxd.activate...
[  OK  ] Reached target Preparation for Logins.
         Starting Wait until snapd is fully seeded...
         Starting Snap Daemon...
         Starting OpenBSD Secure Shell server...
         Starting User Login Management...
         Starting Permit User Sessions...
[  OK  ] Finished Remove Stale Onli=E2=80=A6ext4 Metadata Check Snapshots.
[  OK  ] Started NVIDIA Persistence Daemon.
[  OK  ] Finished Permit User Sessions.
         Starting Hold until boot process finishes up...
         Starting Terminate Plymouth Boot Screen...
[  OK  ] Started System Logging Service.
[  OK  ] Finished Hold until boot process finishes up.
[  OK  ] Finished Terminate Plymouth Boot Screen.
[  OK  ] Started User Login Management.
[  OK  ] Finished Record successful boot for GRUB.
         Starting GRUB failed boot detection...
[  OK  ] Started Serial Getty on ttyS0.
         Starting Set console scheme...
         Starting Hostname Service...
[  OK  ] Started Unattended Upgrades Shutdown.
[  OK  ] Started LSB: automatic crash report generation.
[  OK  ] Finished Set console scheme.
[  OK  ] Created slice Slice /system/getty.
[  OK  ] Started Getty on tty1.
[  OK  ] Reached target Login Prompts.
[  OK  ] Started OpenBSD Secure Shell server.
[  OK  ] Finished GRUB failed boot detection.
[  OK  ] Started Dispatcher daemon for systemd-networkd.
[  OK  ] Started Hostname Service.
         Starting Authorization Manager...
[  OK  ] Started Authorization Manager.
[  OK  ] Started Snap Daemon.
         Starting Time & Date Service...
[  OK  ] Started Time & Date Service.
[  OK  ] Finished Wait until snapd is fully seeded.
         Starting Cloud-init: Config Stage...
[  OK  ] Finished Service for snap application lxd.activate.
[  OK  ] Reached target Multi-User System.
[  OK  ] Reached target Graphical Interface.
         Starting Record Runlevel Change in UTMP...
[  OK  ] Finished Record Runlevel Change in UTMP.
[  130.761554] cloud-init[988]: Cloud-init v. 24.3.1-0ubuntu0~22.04.1
running 'modules:config' at Tue, 03 Dec 2024 16:27:45 +0000. Up 130.73
seconds.
[  OK  ] Finished Cloud-init: Config Stage.
         Starting Cloud-init: Final Stage...
[  131.205614] cloud-init[994]: Cloud-init v. 24.3.1-0ubuntu0~22.04.1
running 'modules:final' at Tue, 03 Dec 2024 16:27:45 +0000. Up 131.15
seconds.
[  131.264413] cloud-init[994]: Cloud-init v. 24.3.1-0ubuntu0~22.04.1
finished at Tue, 03 Dec 2024 16:27:45 +0000. Datasource
DataSourceNoCloud [seed=3D/dev/vdb].  Up 131.25 seconds
[  OK  ] Finished Cloud-init: Final Stage.
[  OK  ] Reached target Cloud-init target.

Ubuntu 22.04.5 LTS testbox01 ttyS0

testbox01 login:


Also, I am preparing a patch with the decode disable/enable moved up a
level, and it seems good in my tests so far and does reduce this slow
boot time by about a minute and a half, with no obvious regressions so
far.

Thanks,


On Mon, Dec 2, 2024 at 1:36=E2=80=AFPM Mitchell Augustin
<mitchell.augustin@canonical.com> wrote:
>
> Thanks!
>
> This approach makes sense to me - the only concern I have is that I
> see this restriction in a comment in __pci_read_base():
>
> `/* No printks while decoding is disabled! */`
>
> At the end of __pci_read_base(), we do have several pci_info() and
> pci_err() calls - so I think we would need to also print that info one
> level up after the new decode enable if we do decide to move decode
> disable/enable one level up. Let me know if you agree, or if there is
> a more straightforward alternative that I am missing.
>
> - Mitchell Augustin
>
>
> On Wed, Nov 27, 2024 at 11:22=E2=80=AFAM Alex Williamson
> <alex.williamson@redhat.com> wrote:
> >
> > On Tue, 26 Nov 2024 19:12:35 -0600
> > Mitchell Augustin <mitchell.augustin@canonical.com> wrote:
> >
> > > Thanks for the breakdown!
> > >
> > > > That alone calls __pci_read_base() three separate times, each time
> > > > disabling and re-enabling decode on the bridge. [...] So we're
> > > > really being bitten that we toggle decode-enable/memory enable
> > > > around reading each BAR size
> > >
> > > That makes sense to me. Is this something that could theoretically be
> > > done in a less redundant way, or is there some functional limitation
> > > that would prevent that or make it inadvisable? (I'm still new to pci
> > > subsystem debugging, so apologies if that's a bit vague.)
> >
> > The only requirement is that decode should be disabled while sizing
> > BARs, the fact that we repeat it around each BAR is, I think, just the
> > way the code is structured.  It doesn't take into account that toggling
> > the command register bit is not a trivial operation in a virtualized
> > environment.  IMO we should push the command register manipulation up a
> > layer so that we only toggle it once per device rather than once per
> > BAR.  Thanks,
> >
> > Alex
> >
>
>
> --
> Mitchell Augustin
> Software Engineer - Ubuntu Partner Engineering



--=20
Mitchell Augustin
Software Engineer - Ubuntu Partner Engineering

