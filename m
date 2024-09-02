Return-Path: <kvm+bounces-25690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E99F3969084
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 01:45:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7709B1F22C88
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 23:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B325188587;
	Mon,  2 Sep 2024 23:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="SVJPlBNP"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F25F13C684;
	Mon,  2 Sep 2024 23:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725320716; cv=none; b=meqJWsiRTTY2aILDHte2oZkZ8UCEFcouU4Sez8igCf2i089SqDsc0JjiILmGPGttrymoS7HjK/6N0tsW0ezxaWAQpD8RfbMmTWgnVLhW6lgUDz+sZeBPG1uaMVytVtbEcTxIIHe9igDeGw4nev1R4a09u0r/M15TrK3I2Au+zSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725320716; c=relaxed/simple;
	bh=Q+f+B1Jwe/vmxiVTW7NQhx5vIjICvDdunj5m6k0q6ok=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ucMyzrqDaE6GMsYbMyvmuE7CxeTTIQ5sOWHdyayiTdO6VarCTHyGIGwS5t6fzD/15vOj0UdOMcbkAk6h/AdYLMESW4peZdTnimMlk40TaemzdXRgGhu+7Jo24BjqSbJYdKXXa1twGQzez2fnen8qU0+6zek1jE1bOfbQvN4l/9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=SVJPlBNP; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1725320712;
	bh=UaJezUaY19zxJWqob2w1cOAk5qiAPl5VHmtR3xKChPw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=SVJPlBNP8APfuR/jBD4BjKXOasjSRZ3dbEv80YacUUHbcdDw+XM6x2QOEMOi1xx0G
	 2YI84S67i5/r6XZ2EhcaDv98rdhCTGlEoi1jECCm64pD3ZPLG9/H5Q/8B0fDuEFnn0
	 ODaujSs7E9rewRWin3OvP+Wi7kVFPTMXmkAtlOVngxeC9c92hxF0K9sD5LWYyiAqz9
	 XX/5QjfzVMkzcIC5jr62Zzp+L4JnzRecg6m4Zt5sMtEE1k/SNxRAfgO7Uhbr4eH27d
	 TDyAw6f/mrTclwB3jDJ3y1IQnfoXHfFk61zd0A7zo2gIuket9WZa/x4aJ3zVCrY44b
	 JAHuQDXFAf6gQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4WyQNR6tgxz4x1V;
	Tue,  3 Sep 2024 09:45:11 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Vegard Nossum <vegard.nossum@oracle.com>, Masahiro Yamada
 <masahiroy@kernel.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-um@lists.infradead.org,
 bpf@vger.kernel.org, llvm@lists.linux.dev, Vegard Nossum
 <vegard.nossum@oracle.com>
Subject: Re: [PATCH] kbuild: use objcopy to generate asm-offsets
In-Reply-To: <20240828083605.3093701-1-vegard.nossum@oracle.com>
References: <20240828083605.3093701-1-vegard.nossum@oracle.com>
Date: Tue, 03 Sep 2024 09:45:11 +1000
Message-ID: <875xrd7h88.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Vegard Nossum <vegard.nossum@oracle.com> writes:
> In order to give assembly code access to C structs without having to
> hardcore member offsets, the kernel compiles a C source file listing all
> the structs and offsets that are needed in assembly code. Using some
> C preprocessor trickery and a sed script, the compiled assembly code is
> turned back into C preprocessor code that in turn can be used by the
> asssembly code.
>
> This sed script is very hard to read and understand.
>
> Remove the sed script and compile the C source listing structs and
> offsets to an object file (instead of assembly code) that embeds C source
> directly. Then extract the C source using objcopy.
>

I threw some builders at this and hit a few errors:

parisc:
  # make -s -j 160 ARCH=parisc64 O=/kisskb/build/mpe_generic-64bit_defconfig_parisc64-gcc13 CROSS_COMPILE=/opt/cross/kisskb/korg/gcc-13.1.0-nolibc/hppa-linux/bin/hppa64-linux-  
  {standard input}: Assembler messages:
  {standard input}: Error: .size expression for main does not evaluate to a constant
  make[3]: *** [/kisskb/src/scripts/Makefile.build:244: scripts/mod/devicetable-offsets.o] Error 1

s390:
  # make -s -j 32 ARCH=s390 O=/kisskb/build/mpe_defconfig_s390x-gcc13 CROSS_COMPILE=/opt/cross/kisskb/korg/gcc-13.1.0-nolibc/s390-linux/bin/s390-linux-  
  In file included from /kisskb/src/arch/s390/include/asm/ptrace.h:11,
                   from /kisskb/src/arch/s390/kernel/vdso64/vdso_user_wrapper.S:7:
  /kisskb/src/arch/s390/include/uapi/asm/ptrace.h:167: warning: "STACK_FRAME_OVERHEAD" redefined
    167 | #define STACK_FRAME_OVERHEAD    160      /* size of minimum stack frame */
        | 
  In file included from /kisskb/src/include/asm-generic/asm-offsets.h:1,
                   from ./arch/s390/include/generated/asm/asm-offsets.h:1,
                   from /kisskb/src/arch/s390/kernel/vdso64/vdso_user_wrapper.S:5:
  ./include/generated/asm-offsets.h:51: note: this is the location of the previous definition
     51 | #define STACK_FRAME_OVERHEAD -96 /* sizeof(struct stack_frame) */

mips:
  # make -s -j 32 ARCH=mips O=/kisskb/build/mpe_defconfig_mips-gcc13 CROSS_COMPILE=/opt/cross/kisskb/korg/gcc-13.1.0-nolibc/mips-linux/bin/mips-linux-  
  {standard input}: Assembler messages:
  {standard input}:27: Error: junk at end of line, first unrecognized character is `M'
  {standard input}:212: Error: junk at end of line, first unrecognized character is `M'
  {standard input}:265: Error: junk at end of line, first unrecognized character is `M'
  {standard input}:338: Error: junk at end of line, first unrecognized character is `M'
  {standard input}:596: Error: junk at end of line, first unrecognized character is `S'
  {standard input}:608: Error: junk at end of line, first unrecognized character is `L'
  {standard input}:721: Error: junk at end of line, first unrecognized character is `L'
  {standard input}:806: Error: junk at end of line, first unrecognized character is `L'
  {standard input}:963: Error: junk at end of line, first unrecognized character is `P'
  {standard input}:996: Error: junk at end of line, first unrecognized character is `K'
  {standard input}:1161: Error: junk at end of line, first unrecognized character is `M'
  make[3]: *** [/kisskb/src/scripts/Makefile.build:244: arch/mips/kernel/asm-offsets.o] Error 1

riscv:
  # make -s -j 160 ARCH=riscv O=/kisskb/build/mpe_defconfig_riscv-gcc13 CROSS_COMPILE=/opt/cross/kisskb/korg/gcc-13.1.0-nolibc/riscv64-linux/bin/riscv64-linux-  
  In file included from /kisskb/src/arch/riscv/kernel/asm-offsets.c:9:
  /kisskb/src/arch/riscv/kernel/asm-offsets.c: In function 'asm_offsets':
  /kisskb/src/include/linux/kbuild.h:6:9: error: invalid 'asm': invalid use of '%c'
      6 |         asm volatile( \
        |         ^~~
  /kisskb/src/include/linux/kbuild.h:12:9: note: in expansion of macro '_LINE'
     12 |         _LINE("#define " #sym " %c0 /* " #val " */", "i" (val))
        |         ^~~~~
  /kisskb/src/include/linux/kbuild.h:15:9: note: in expansion of macro 'DEFINE'
     15 |         DEFINE(sym, offsetof(struct str, mem))
        |         ^~~~~~
  /kisskb/src/arch/riscv/kernel/asm-offsets.c:25:9: note: in expansion of macro 'OFFSET'
     25 |         OFFSET(TASK_THREAD_RA, task_struct, thread.ra);
        |         ^~~~~~
  /kisskb/src/include/linux/kbuild.h:6:9: error: invalid 'asm': invalid use of '%c'
      6 |         asm volatile( \
        |         ^~~


Full list here, but note there are some unrelated pre-existing failures:
  http://kisskb.ellerman.id.au/kisskb/head/259bba3447faaf5e5b12ae41a26a62978d4c1965/


cheers

