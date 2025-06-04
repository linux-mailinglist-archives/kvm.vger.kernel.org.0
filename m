Return-Path: <kvm+bounces-48435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21615ACE420
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 20:02:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 924F13A7231
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 18:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71E31F8BDD;
	Wed,  4 Jun 2025 18:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="dfluSOO+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE71199237
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 18:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749060160; cv=none; b=LGjIYB1JbN/W2JreJG8dXCgctljm8YvWlGco1FpaFDbdfOB0q+o4Qkhw2pdZSu5ciMLdEKPpgWjsdfXL/QMov7b81jvhiIf+VliRatIbthVTNeOZ2XKYbS/5n9X/lYQQtWtizVx8hBF72AQA1GJwqdrwayMT++MHLrb4goK80aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749060160; c=relaxed/simple;
	bh=F8HnxpY70p/Zp2iUyqkIkhQ+KlYjxgtmeLMWDz54ozM=;
	h=Date:Subject:In-Reply-To:CC:From:To:Message-ID:Mime-Version:
	 Content-Type; b=fA36qJCL75J5ccG2rn39QBt3+Wv33A9r3uYyw3GBhHMmGi0Z6/KgFmyzTwtwLCPrytWqXyeWOdohMRVhD9dydORRtGSxhlkiaYRAAhKcPwwG1K3vH1LYuFN+NH2JYZ3VZXoVknIx9iOimYmZ7p9RVKmolWF11wqOjBwSoFMch/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com; spf=pass smtp.mailfrom=dabbelt.com; dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b=dfluSOO+; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b2c3c689d20so65484a12.3
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 11:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1749060157; x=1749664957; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4sb9NtYIBm94y/rjJYszo90EtKu9XX4CPTVA/wAKQT8=;
        b=dfluSOO+1nTAtSN05kvky7z4h4bB20K7kUPb7wwI0JJU9PHQJ9y7/53dT1r15ErXzC
         pmk3z2hw7rnWfNevFrgf7UGNEE3G00YKK4IwbgEaJ48nyv9AcZpHGjwwMwlDGqCzMLIg
         RfkWPUHK0aktnbR9to4m6fvDfrb7gsC2laFDP61gFKEZVdW3mRso1DuhpOsOcTrH7qbK
         9CUri0DyY2eOB4jfs3MOvvbsm7zcNv3W0UiUMy8nafT5EPsb+5rN/6svhGhYyquGpVEq
         b+7lEi3cfE2lEv43XsIPZAYFR6ObbptgiOOv67Bx+iBn6AykCPzR7Ehwrw818xZ3lMmi
         byuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749060157; x=1749664957;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4sb9NtYIBm94y/rjJYszo90EtKu9XX4CPTVA/wAKQT8=;
        b=SRaqVNeg45TOWTO0EUoost4G/SaHcBPxaMvqqnFiFWp1UO9omOkH7SKZNpTBucRzOz
         4agdtlk4TxPUGEpByenplp3WGCS6+M6xFYicMna/iPrFukwEstb3X2IBjM8t3lfxQJam
         R0Xn/kjvjc843SMx4gvgCzJ6XS42/xOaPzcyWNP56Hm7hqvUmCw5oppKY2QOQ8GwwyOq
         eGz0yWW+TUnbzxffJRGJZK/hoUXNrxTeYRdzV6uZ8rGjca5igmawSZPIG+AJJT/NY8Ix
         c6ku0WU5lnZXxgPExWeNrc8UfbqYvv/hnOok+kZf1DX9g/z11NfyBhRjYQHidvrvNx2t
         r1EA==
X-Forwarded-Encrypted: i=1; AJvYcCXMkkGnCxRCMoKNhPSzrHYlHanF3uMwJacKermBSBGbVLzS5JJ/DOLUz33SrK/2pVW08aU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw88mUZFPjHF+dJBeyo/jM43hWxEZD2XMTQ458Znf2VgSGIpYqa
	iVHFsCUVFTb23CBOGInNfLVMx5ceDznvf+ffwFVUHAUT8L0/P5a4NOVQLgkwTywpMKg=
X-Gm-Gg: ASbGncslN2eN4WTpevfP9lANQQkJeWacOITESRwSDb54Qx2XIuKxZ8iDQ79i21I7I2M
	keHOF/sFZPjkHe8M5pc70LESvgAhrB1ma/EFHzWWQ6jWr9uRjxGHCwjIko2ezOztxr7JGbZDmt+
	r4b/BCX/KisknoquxRspcBR6LLA/ZLI8z1fW96YK/tacYzoc+yejar0cf1lMNG5Ewb1MUhf16jp
	cjGC8dCCfprWDYut4hMj7HNU0F8EUbyP0LnU8mq0ypgPFiDAvthI5yw2WNwJ4CsxyFdGSscWuOX
	9XCbm0WPLsj/yioRUvy0uu8pu5PKk+A78ZcSD2wrxSZDDBah0+HkBjA=
X-Google-Smtp-Source: AGHT+IGzoLjlPGLsxX/VcQAibjCHSuGjPNjwdnzeCXTcDSgTlXsCpPwGWWh1fCsXTwlbhq/KM2w0wQ==
X-Received: by 2002:a05:6a21:48f:b0:1fd:f4df:96ed with SMTP id adf61e73a8af0-21d22ce22c7mr5169223637.26.1749060156608;
        Wed, 04 Jun 2025 11:02:36 -0700 (PDT)
Received: from localhost ([2620:10d:c090:500::4:3cec])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-747afff72bcsm11485461b3a.166.2025.06.04.11.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 11:02:35 -0700 (PDT)
Date: Wed, 04 Jun 2025 11:02:35 -0700 (PDT)
X-Google-Original-Date: Wed, 04 Jun 2025 11:02:33 PDT (-0700)
Subject:     Re: [PATCH v8 00/14] riscv: add SBI FWFT misaligned exception delegation support
In-Reply-To: <20250523101932.1594077-1-cleger@rivosinc.com>
CC: Paul Walmsley <paul.walmsley@sifive.com>, anup@brainfault.org,
  atishp@atishpatra.org, shuah@kernel.org, corbet@lwn.net, linux-riscv@lists.infradead.org,
  linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
  linux-kselftest@vger.kernel.org, cleger@rivosinc.com, samuel.holland@sifive.com, ajones@ventanamicro.com,
  debug@rivosinc.com, Charlie Jenkins <charlie@rivosinc.com>
From: Palmer Dabbelt <palmer@dabbelt.com>
To: cleger@rivosinc.com
Message-ID: <mhng-C1CE13EE-C4E6-490D-ABF4-CE7BD84737C3@palmerdabbelt-mac>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Fri, 23 May 2025 03:19:17 PDT (-0700), cleger@rivosinc.com wrote:
> The SBI Firmware Feature extension allows the S-mode to request some
> specific features (either hardware or software) to be enabled. This
> series uses this extension to request misaligned access exception
> delegation to S-mode in order to let the kernel handle it. It also adds
> support for the KVM FWFT SBI extension based on the misaligned access
> handling infrastructure.
>
> FWFT SBI extension is part of the SBI V3.0 specifications [1]. It can be
> tested using the qemu provided at [2] which contains the series from
> [3]. Upstream kvm-unit-tests can be used inside kvm to tests the correct
> delegation of misaligned exceptions. Upstream OpenSBI can be used.
>
> Note: Since SBI V3.0 is not yet ratified, FWFT extension API is split
> between interface only and implementation, allowing to pick only the
> interface which do not have hard dependencies on SBI.
>
> The tests can be run using the kselftest from series [4].
>
> $ qemu-system-riscv64 \
> 	-cpu rv64,trap-misaligned-access=true,v=true \
> 	-M virt \
> 	-m 1024M \
> 	-bios fw_dynamic.bin \
> 	-kernel Image
>  ...
>
>  # ./misaligned
>  TAP version 13
>  1..23
>  # Starting 23 tests from 1 test cases.
>  #  RUN           global.gp_load_lh ...
>  #            OK  global.gp_load_lh
>  ok 1 global.gp_load_lh
>  #  RUN           global.gp_load_lhu ...
>  #            OK  global.gp_load_lhu
>  ok 2 global.gp_load_lhu
>  #  RUN           global.gp_load_lw ...
>  #            OK  global.gp_load_lw
>  ok 3 global.gp_load_lw
>  #  RUN           global.gp_load_lwu ...
>  #            OK  global.gp_load_lwu
>  ok 4 global.gp_load_lwu
>  #  RUN           global.gp_load_ld ...
>  #            OK  global.gp_load_ld
>  ok 5 global.gp_load_ld
>  #  RUN           global.gp_load_c_lw ...
>  #            OK  global.gp_load_c_lw
>  ok 6 global.gp_load_c_lw
>  #  RUN           global.gp_load_c_ld ...
>  #            OK  global.gp_load_c_ld
>  ok 7 global.gp_load_c_ld
>  #  RUN           global.gp_load_c_ldsp ...
>  #            OK  global.gp_load_c_ldsp
>  ok 8 global.gp_load_c_ldsp
>  #  RUN           global.gp_load_sh ...
>  #            OK  global.gp_load_sh
>  ok 9 global.gp_load_sh
>  #  RUN           global.gp_load_sw ...
>  #            OK  global.gp_load_sw
>  ok 10 global.gp_load_sw
>  #  RUN           global.gp_load_sd ...
>  #            OK  global.gp_load_sd
>  ok 11 global.gp_load_sd
>  #  RUN           global.gp_load_c_sw ...
>  #            OK  global.gp_load_c_sw
>  ok 12 global.gp_load_c_sw
>  #  RUN           global.gp_load_c_sd ...
>  #            OK  global.gp_load_c_sd
>  ok 13 global.gp_load_c_sd
>  #  RUN           global.gp_load_c_sdsp ...
>  #            OK  global.gp_load_c_sdsp
>  ok 14 global.gp_load_c_sdsp
>  #  RUN           global.fpu_load_flw ...
>  #            OK  global.fpu_load_flw
>  ok 15 global.fpu_load_flw
>  #  RUN           global.fpu_load_fld ...
>  #            OK  global.fpu_load_fld
>  ok 16 global.fpu_load_fld
>  #  RUN           global.fpu_load_c_fld ...
>  #            OK  global.fpu_load_c_fld
>  ok 17 global.fpu_load_c_fld
>  #  RUN           global.fpu_load_c_fldsp ...
>  #            OK  global.fpu_load_c_fldsp
>  ok 18 global.fpu_load_c_fldsp
>  #  RUN           global.fpu_store_fsw ...
>  #            OK  global.fpu_store_fsw
>  ok 19 global.fpu_store_fsw
>  #  RUN           global.fpu_store_fsd ...
>  #            OK  global.fpu_store_fsd
>  ok 20 global.fpu_store_fsd
>  #  RUN           global.fpu_store_c_fsd ...
>  #            OK  global.fpu_store_c_fsd
>  ok 21 global.fpu_store_c_fsd
>  #  RUN           global.fpu_store_c_fsdsp ...
>  #            OK  global.fpu_store_c_fsdsp
>  ok 22 global.fpu_store_c_fsdsp
>  #  RUN           global.gen_sigbus ...
>  [12797.988647] misaligned[618]: unhandled signal 7 code 0x1 at 0x0000000000014dc0 in misaligned[4dc0,10000+76000]
>  [12797.988990] CPU: 0 UID: 0 PID: 618 Comm: misaligned Not tainted 6.13.0-rc6-00008-g4ec4468967c9-dirty #51
>  [12797.989169] Hardware name: riscv-virtio,qemu (DT)
>  [12797.989264] epc : 0000000000014dc0 ra : 0000000000014d00 sp : 00007fffe165d100
>  [12797.989407]  gp : 000000000008f6e8 tp : 0000000000095760 t0 : 0000000000000008
>  [12797.989544]  t1 : 00000000000965d8 t2 : 000000000008e830 s0 : 00007fffe165d160
>  [12797.989692]  s1 : 000000000000001a a0 : 0000000000000000 a1 : 0000000000000002
>  [12797.989831]  a2 : 0000000000000000 a3 : 0000000000000000 a4 : ffffffffdeadbeef
>  [12797.989964]  a5 : 000000000008ef61 a6 : 626769735f6e0000 a7 : fffffffffffff000
>  [12797.990094]  s2 : 0000000000000001 s3 : 00007fffe165d838 s4 : 00007fffe165d848
>  [12797.990238]  s5 : 000000000000001a s6 : 0000000000010442 s7 : 0000000000010200
>  [12797.990391]  s8 : 000000000000003a s9 : 0000000000094508 s10: 0000000000000000
>  [12797.990526]  s11: 0000555567460668 t3 : 00007fffe165d070 t4 : 00000000000965d0
>  [12797.990656]  t5 : fefefefefefefeff t6 : 0000000000000073
>  [12797.990756] status: 0000000200004020 badaddr: 000000000008ef61 cause: 0000000000000006
>  [12797.990911] Code: 8793 8791 3423 fcf4 3783 fc84 c737 dead 0713 eef7 (c398) 0001
>  #            OK  global.gen_sigbus
>  ok 23 global.gen_sigbus
>  # PASSED: 23 / 23 tests passed.
>  # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0
>
> With kvm-tools:
>
>  # lkvm run -k sbi.flat -m 128
>   Info: # lkvm run -k sbi.flat -m 128 -c 1 --name guest-97
>   Info: Removed ghost socket file "/root/.lkvm//guest-97.sock".
>
>  ##########################################################################
>  #    kvm-unit-tests
>  ##########################################################################
>
>  ... [test messages elided]
>  PASS: sbi: fwft: FWFT extension probing no error
>  PASS: sbi: fwft: get/set reserved feature 0x6 error == SBI_ERR_DENIED
>  PASS: sbi: fwft: get/set reserved feature 0x3fffffff error == SBI_ERR_DENIED
>  PASS: sbi: fwft: get/set reserved feature 0x80000000 error == SBI_ERR_DENIED
>  PASS: sbi: fwft: get/set reserved feature 0xbfffffff error == SBI_ERR_DENIED
>  PASS: sbi: fwft: misaligned_deleg: Get misaligned deleg feature no error
>  PASS: sbi: fwft: misaligned_deleg: Set misaligned deleg feature invalid value error
>  PASS: sbi: fwft: misaligned_deleg: Set misaligned deleg feature invalid value error
>  PASS: sbi: fwft: misaligned_deleg: Set misaligned deleg feature value no error
>  PASS: sbi: fwft: misaligned_deleg: Set misaligned deleg feature value 0
>  PASS: sbi: fwft: misaligned_deleg: Set misaligned deleg feature value no error
>  PASS: sbi: fwft: misaligned_deleg: Set misaligned deleg feature value 1
>  PASS: sbi: fwft: misaligned_deleg: Verify misaligned load exception trap in supervisor
>  SUMMARY: 50 tests, 2 unexpected failures, 12 skipped
>
> This series is available at [5].
>
> Link: https://github.com/riscv-non-isa/riscv-sbi-doc/releases/download/vv3.0-rc2/riscv-sbi.pdf [1]
> Link: https://github.com/rivosinc/qemu/tree/dev/cleger/misaligned [2]
> Link: https://lore.kernel.org/all/20241211211933.198792-3-fkonrad@amd.com/T/ [3]
> Link: https://lore.kernel.org/linux-riscv/20250414123543.1615478-1-cleger@rivosinc.com [4]
> Link: https://github.com/rivosinc/linux/tree/dev/cleger/fwft [5]
> ---
>
> V8:
>  - Move misaligned_access_speed under CONFIG_RISCV_MISALIGNED and add a
>    separate commit for that.
>
> V7:
>  - Fix ifdefery build problems
>  - Move sbi_fwft_is_supported with fwft_set_req struct
>  - Added Atish Reviewed-by
>  - Updated KVM vcpu cfg hedeleg value in set_delegation
>  - Changed SBI ETIME error mapping to ETIMEDOUT
>  - Fixed a few typo reported by Alok
>
> V6:
>  - Rename FWFT interface to remove "_local"
>  - Fix test for MEDELEG values in KVM FWFT support
>  - Add __init for unaligned_access_init()
>  - Rebased on master
>
> V5:
>  - Return ERANGE as mapping for SBI_ERR_BAD_RANGE
>  - Removed unused sbi_fwft_get()
>  - Fix kernel for sbi_fwft_local_set_cpumask()
>  - Fix indentation for sbi_fwft_local_set()
>  - Remove spurious space in kvm_sbi_fwft_ops.
>  - Rebased on origin/master
>  - Remove fixes commits and sent them as a separate series [4]
>
> V4:
>  - Check SBI version 3.0 instead of 2.0 for FWFT presence
>  - Use long for kvm_sbi_fwft operation return value
>  - Init KVM sbi extension even if default_disabled
>  - Remove revert_on_fail parameter for sbi_fwft_feature_set().
>  - Fix comments for sbi_fwft_set/get()
>  - Only handle local features (there are no globals yet in the spec)
>  - Add new SBI errors to sbi_err_map_linux_errno()
>
> V3:
>  - Added comment about kvm sbi fwft supported/set/get callback
>    requirements
>  - Move struct kvm_sbi_fwft_feature in kvm_sbi_fwft.c
>  - Add a FWFT interface
>
> V2:
>  - Added Kselftest for misaligned testing
>  - Added get_user() usage instead of __get_user()
>  - Reenable interrupt when possible in misaligned access handling
>  - Document that riscv supports unaligned-traps
>  - Fix KVM extension state when an init function is present
>  - Rework SBI misaligned accesses trap delegation code
>  - Added support for CPU hotplugging
>  - Added KVM SBI reset callback
>  - Added reset for KVM SBI FWFT lock
>  - Return SBI_ERR_DENIED_LOCKED when LOCK flag is set
>
> Clément Léger (14):
>   riscv: sbi: add Firmware Feature (FWFT) SBI extensions definitions
>   riscv: sbi: remove useless parenthesis
>   riscv: sbi: add new SBI error mappings
>   riscv: sbi: add FWFT extension interface
>   riscv: sbi: add SBI FWFT extension calls
>   riscv: misaligned: request misaligned exception from SBI
>   riscv: misaligned: use on_each_cpu() for scalar misaligned access
>     probing
>   riscv: misaligned: declare misaligned_access_speed under
>     CONFIG_RISCV_MISALIGNED
>   riscv: misaligned: move emulated access uniformity check in a function
>   riscv: misaligned: add a function to check misalign trap delegability
>   RISC-V: KVM: add SBI extension init()/deinit() functions
>   RISC-V: KVM: add SBI extension reset callback
>   RISC-V: KVM: add support for FWFT SBI extension
>   RISC-V: KVM: add support for SBI_FWFT_MISALIGNED_DELEG
>
>  arch/riscv/include/asm/cpufeature.h        |  14 +-
>  arch/riscv/include/asm/kvm_host.h          |   5 +-
>  arch/riscv/include/asm/kvm_vcpu_sbi.h      |  12 +
>  arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h |  29 +++
>  arch/riscv/include/asm/sbi.h               |  60 +++++
>  arch/riscv/include/uapi/asm/kvm.h          |   1 +
>  arch/riscv/kernel/sbi.c                    |  81 ++++++-
>  arch/riscv/kernel/traps_misaligned.c       | 112 ++++++++-
>  arch/riscv/kernel/unaligned_access_speed.c |   8 +-
>  arch/riscv/kvm/Makefile                    |   1 +
>  arch/riscv/kvm/vcpu.c                      |   4 +-
>  arch/riscv/kvm/vcpu_sbi.c                  |  54 +++++
>  arch/riscv/kvm/vcpu_sbi_fwft.c             | 257 +++++++++++++++++++++
>  arch/riscv/kvm/vcpu_sbi_sta.c              |   3 +-
>  14 files changed, 620 insertions(+), 21 deletions(-)
>  create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
>  create mode 100644 arch/riscv/kvm/vcpu_sbi_fwft.c

Sorry I'm still kind of out of it here, but I think Alex was saying this 
has dependencies in the patchwork call this morning?

