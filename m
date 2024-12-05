Return-Path: <kvm+bounces-33176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54AC29E6056
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 23:06:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B5CE28298B
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 22:06:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42D1B1CDA2E;
	Thu,  5 Dec 2024 22:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c+Z5jJ4s"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2681B87CF;
	Thu,  5 Dec 2024 22:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733436367; cv=none; b=E/z82yzUwmirtc/nTQEHWQyjDYOow470PEU/SDBm7lYwne0jhk0jl3akTxucy4cR+zoEeB53tE8XoWf32LTP9oYSiytZCIY9VYpjtHl2/TKBZOTyysfNPI8NzeIieVcj8RenChxcvobeOPiW2GEXUYViLcRxGJtpSpOwfCVFdWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733436367; c=relaxed/simple;
	bh=L3PuwvxgeCB6Zi60CiOUyxN2M783Zvc3EW19LwKwWQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hbmDRnNr3q8agecKnRvR3csRLdLOOqFa8jynuCFoYFS23NRzQH44QNnitB24pdJg8P1ON2GSygA+NaPW0zGnySvDEzliQNkffTgfY7IAjedCF9+r+Vzm8/ei/w3nSf65kheWVlUxUddRKf29ZAam0I/ZF0PRepwkdqPqaMr4Nm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c+Z5jJ4s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66320C4CED1;
	Thu,  5 Dec 2024 22:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733436366;
	bh=L3PuwvxgeCB6Zi60CiOUyxN2M783Zvc3EW19LwKwWQQ=;
	h=Date:From:To:Cc:Subject:From;
	b=c+Z5jJ4sxDwI6oPh94/aevrQXIeBAvgDtR+j2zviPCzTWxVy3w4cm90HakTFqdKV6
	 GcSEeKKcxKUIKvqTAVcthEdW7QLK20zD9ePPvbwpGLEZ5dGREBClrQQZUtXyIRSLfZ
	 nIg7G6nmFmgmQpiyvHkW9oznUX8iudWAYx3pyAJprWN4/PAKvi4riXKic4WHUOyJyk
	 L10iznPTk7FOepEAcXzQZD1wkhgF33VaKjkFKsUeiOj/1EymMIAqmMmYN74cLaCNUV
	 FMC9NVN92pQHvVKfRnY3w5Cx6h392yllpTlhv/Zhj9/eapyl45X3DbU4wx4MzT0Q/I
	 MztmMVw4QS4NA==
Date: Thu, 5 Dec 2024 15:06:04 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Borislav Petkov <bp@alien8.de>, x86@kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Kim Phillips <kim.phillips@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Hitting AUTOIBRS WARN_ON_ONCE() in init_amd() booting 32-bit kernel
 under KVM
Message-ID: <20241205220604.GA2054199@thelio-3990X>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Boris and x86 + KVM folks,

I got access to a new box that has an EPYC 9454P in it and I noticed
that I hit the warning from

        /*
         * Make sure EFER[AIBRSE - Automatic IBRS Enable] is set. The APs are brought up
         * using the trampoline code and as part of it, MSR_EFER gets prepared there in
         * order to be replicated onto them. Regardless, set it here again, if not set,
         * to protect against any future refactoring/code reorganization which might
         * miss setting this important bit.
         */
        if (spectre_v2_in_eibrs_mode(spectre_v2_enabled) &&
            cpu_has(c, X86_FEATURE_AUTOIBRS))
                WARN_ON_ONCE(msr_set_bit(MSR_EFER, _EFER_AUTOIBRS));

that was added by commit 8cc68c9c9e92 ("x86/CPU/AMD: Make sure
EFER[AIBRSE] is set") when booting a 32-bit kernel in QEMU with KVM. I
do not see this without KVM, so maybe this has something to do with
commit 8c19b6f257fa ("KVM: x86: Propagate the AMD Automatic IBRS feature
to the guest") as well?

I've included as much information as I can below for reproduction. If
there is anything more I can provide or test, I am more than happy to do
so. If this is expected given it is a 32-bit guest or something else, I
can just ignore the warning in my report infrastructure. I have not
checked if this is a recent regression since I have only had this box
for a couple of days.

  $ uname -r
  6.13.0-rc1-debug

  $ lscpu
  ...
    Model name:             AMD EPYC 9454P 48-Core Processor
      CPU family:           25
      Model:                17
  ...
  Vulnerabilities:
    Gather data sampling:   Not affected
    Itlb multihit:          Not affected
    L1tf:                   Not affected
    Mds:                    Not affected
    Meltdown:               Not affected
    Mmio stale data:        Not affected
    Reg file data sampling: Not affected
    Retbleed:               Not affected
    Spec rstack overflow:   Mitigation; Safe RET
    Spec store bypass:      Mitigation; Speculative Store Bypass disabled via prctl
    Spectre v1:             Mitigation; usercopy/swapgs barriers and __user pointer sanitization
    Spectre v2:             Mitigation; Enhanced / Automatic IBRS; IBPB conditional; STIBP always-on; RSB filling; PBRSB-eIBRS Not affected; BHI Not affected
    Srbds:                  Not affected
    Tsx async abort:        Not affected

  $ qemu-system-i386 --version | head -1
  QEMU emulator version 9.1.2

  $ git show --format='%h ("%s")' -s
  896d8946da97 ("Merge tag 'net-6.13-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")

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
  [    0.000000] Linux version 6.13.0-rc1-00170-g896d8946da97 (nathan@ax162) (i386-linux-gcc (GCC) 14.2.0, GNU ld (GNU Binutils) 2.42) #1 SMP PREEMPT_DYNAMIC Thu Dec  5 13:54:30 MST 2024
  ...
  [    0.096072] smp: Bringing up secondary CPUs ...
  [    0.096731] smpboot: x86: Booting SMP configuration:
  [    0.097004] .... node  #0, CPUs:      #1
  [    0.009830] ------------[ cut here ]------------
  [    0.009830] WARNING: CPU: 1 PID: 0 at arch/x86/kernel/cpu/amd.c:1068 init_amd+0x50f/0xa20
  [    0.009830] Modules linked in:
  [    0.009830] CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Not tainted 6.13.0-rc1-00170-g896d8946da97 #1
  [    0.009830] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Arch Linux 1.16.3-1-1 04/01/2014
  [    0.009830] EIP: init_amd+0x50f/0xa20
  [    0.009830] Code: 4d 00 f0 80 4f 78 04 e9 b4 fd ff ff 8d b4 26 00 00 00 00 ba 15 00 00 00 b8 80 00 00 c0 e8 79 65 4d 00 85 c0 0f 84 01 fe ff ff <0f> 0b e9 fa fd ff ff 2e 8d b4 26 00 00 00 00 66 90 8b 47 38 85 c0
  [    0.009830] EAX: 00000001 EBX: 00000011 ECX: c0000080 EDX: 00000000
  [    0.009830] ESI: df5850a1 EDI: df585020 EBP: c1157f54 ESP: c1157f04
  [    0.009830] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210002
  [    0.009830] CR0: 80050033 CR2: 00000000 CR3: 0d6ce000 CR4: 00350e90
  [    0.009830] Call Trace:
  [    0.009830]  ? show_regs.cold+0x16/0x1e
  [    0.009830]  ? __warn.cold+0xbf/0x114
  [    0.009830]  ? init_amd+0x50f/0xa20
  [    0.009830]  ? init_amd+0x50f/0xa20
  [    0.009830]  ? report_bug+0x116/0x150
  [    0.009830]  ? init_amd+0x510/0xa20
  [    0.009830]  ? exc_overflow+0x50/0x50
  [    0.009830]  ? handle_bug+0x56/0x90
  [    0.009830]  ? exc_invalid_op+0x1b/0x70
  [    0.009830]  ? handle_exception+0x14b/0x14b
  [    0.009830]  ? exc_overflow+0x50/0x50
  [    0.009830]  ? init_amd+0x50f/0xa20
  [    0.009830]  ? exc_overflow+0x50/0x50
  [    0.009830]  ? init_amd+0x50f/0xa20
  [    0.009830]  identify_cpu+0x29e/0x700
  [    0.009830]  identify_secondary_cpu+0xf/0x70
  [    0.009830]  smp_store_cpu_info+0x5a/0x70
  [    0.009830]  start_secondary+0x6e/0x100
  [    0.009830]  startup_32_smp+0x151/0x154
  [    0.009830] ---[ end trace 0000000000000000 ]---
  ...

Cheers,
Nathan

