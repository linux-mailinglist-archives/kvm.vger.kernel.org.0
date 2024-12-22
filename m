Return-Path: <kvm+bounces-34286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 53C059FA353
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 03:20:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9900D188671E
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 02:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB7F91A296;
	Sun, 22 Dec 2024 02:20:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.wilcox-tech.com (mail.wilcox-tech.com [45.32.83.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF0A2F2F
	for <kvm@vger.kernel.org>; Sun, 22 Dec 2024 02:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.32.83.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734834013; cv=none; b=jBIuTldYFrbyQDlRiqfJSYTsb1Ej/S4ZUJujS+VbjEGY5up9az3gaNZUwwPelB5Jp6oNnSDOEpd5YJRnXJXmnFz1dNcRx0+cxRZc428hpapduArGT38sVslq9VFZfhwapfx0J9HFg0g9KNcaImKBRXx2T6dppkaEdFh4vKPYAT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734834013; c=relaxed/simple;
	bh=CHm0gesNWMouwsCI/WF+QvWprriebXjmzic8ldz5YX4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=mLiCeJxqn+CCOlOGwF6dBw8ovnblhoQOvmwiyWUCkxQ31l8thA5SM5nxxbOb4ZxZbvJpSGAzK4M8TzEG4j22qqTQ+9H3Yniplx/gSawZlwQM0B5V2/MSY4pQIdtED6BGJAD1xsY7cWKaH0dlkCA/UMINHiat8WoQu5CqhJnurEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=Wilcox-Tech.com; spf=pass smtp.mailfrom=Wilcox-Tech.com; arc=none smtp.client-ip=45.32.83.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=Wilcox-Tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Wilcox-Tech.com
Received: (qmail 18201 invoked from network); 22 Dec 2024 02:13:27 -0000
Received: from ip98-184-130-195.tu.ok.cox.net (HELO smtpclient.apple) (AWilcox@Wilcox-Tech.com@98.184.130.195)
  by mail.wilcox-tech.com with ESMTPA; 22 Dec 2024 02:13:27 -0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.600.62\))
Subject: Re: [PATCH v2 4/5] powerpc: kvm: drop 32-bit book3s
From: "A. Wilcox" <AWilcox@Wilcox-Tech.com>
In-Reply-To: <20241221214223.3046298-5-arnd@kernel.org>
Date: Sat, 21 Dec 2024 20:13:12 -0600
Cc: kvm@vger.kernel.org,
 Arnd Bergmann <arnd@arndb.de>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Huacai Chen <chenhuacai@kernel.org>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Naveen N Rao <naveen@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Alexander Graf <graf@amazon.com>,
 Crystal Wood <crwood@redhat.com>,
 Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Paul Durrant <paul@xen.org>,
 Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org,
 kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9B9E07F0-3373-4F59-BE4C-E6C425B3C36D@Wilcox-Tech.com>
References: <20241221214223.3046298-1-arnd@kernel.org>
 <20241221214223.3046298-5-arnd@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
X-Mailer: Apple Mail (2.3774.600.62)

On Dec 21, 2024, at 3:42=E2=80=AFPM, Arnd Bergmann <arnd@kernel.org> =
wrote:
>=20
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> Support for KVM on 32-bit Book III-s implementations was added in 2010
> and supports PowerMac, CHRP, and embedded platforms using the =
Freescale G4
> (mpc74xx), e300 (mpc83xx) and e600 (mpc86xx) CPUs from 2003 to 2009.
>=20
> Earlier 603/604/750 machines might work but would be even more limited
> by their available memory.
>=20
> The only likely users of KVM on any of these were the final Apple
> PowerMac/PowerBook/iBook G4 models with 2GB of RAM that were at the =
high
> end 20 years ago but are just as obsolete as their x86-32 =
counterparts.
> The code has been orphaned since 2023.
>=20
> There is still a need to support 32-bit guests in order to better
> debug problems on ppc32 kernels. This should work in theory on both
> 64-bit booke and on 64-bit book3s hosts, but it would be good to
> confirm that this is still the case before the known working option
> gets removed.


I can confirm that running 6.12.5 on a P9 host, trying to boot a 6.6
32-bit kernel gave me:

Detected RAM kernel at 400000 (1330c8c bytes)=20
       Welcome to Open Firmware

  Copyright (c) 2004, 2017 IBM Corporation All rights reserved.
  This program and the accompanying materials are made available
  under the terms of the BSD License available at
  http://www.opensource.org/licenses/bsd-license.php

Booting from memory...
=20
( 380 ) Data Segment Exception [ -bfc00000 ]


    R0 .. R7           R8 .. R15         R16 .. R23         R24 .. R31
00000000014a1124   0000000000000000   000000000135b4ac   =
0000000000000000  =20
000000000dc70f30   ffffffffc0000000   000000000dc70fa4   =
000000000173600c  =20
0000000000000000   000000000e477010   0000000000000000   =
0000000000400000  =20
ffffffff0141be4c   000000000149ab74   00000000ffffffff   =
0000000000000008  =20
00000000c0014b6c   0000000020000402   0000000040400000   =
00000000016f2000  =20
ffffffff40400000   0000000000000000   0000000000000000   =
000000000dc70f60  =20
0000000000000000   0000000000000000   000000000e73d490   =
000000000149f000  =20
0000000000000000   000000000e756118   000000000dc70fa0   =
ffffffff40400000  =20

    CR / XER           LR / CTR          SRR0 / SRR1        DAR / DSISR
        80000402   00000000014a1124   00000000014a1128   =
ffffffff0141be4c  =20
0000000020040000   0000000000000000   8000000000003000           =
00000000  =20


2 >=20

Which is the same thing that happens if you boot a 32-bit Linux kernel
on a physical 64-bit Power machine.  This is probably because KVM is
so much more accurate than TCG for Power emulation :)

That said, I would like to keep the support alive for more than just
ppc32 kernel testing.  There are plenty of Power Macs with enough
memory to run some environments within KVM.  Ad=C3=A9lie=E2=80=99s new =
release
boots a full XFCE desktop in under 300 MB RAM, so even a 1 GB machine
has enough memory to run AmigaOS, Mac OS 9, or another XFCE in KVM.

I have found a few bugs in testing newer kernels, and one of them
affects all targets lower than Power7, which means 32-bit and 64-bit BE.
I am preparing to send those patches in.  I will continue shaking out
any remaining bugs on my 32-bit host.  I hope that these patches can
be useful, and possibly stimulate more interest so 32-bit support can
be maintained again.

In fairness, I do agree that there is very little value in keeping =
32-bit
MIPS or RISC-V support since the chips that support it are so limited.
32-bit Power however serves actual purposes.  32-bit x86 could be useful
to make sure =E2=80=9CKVM on 32-bit in general=E2=80=9D is easier to =
keep going,
but if it is causing maintenance issues then I suppose it can go.

Sincerely,
-Anna=

