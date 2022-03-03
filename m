Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453014CB7A2
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 08:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiCCH2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 02:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiCCH2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 02:28:03 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43C716DAE4
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 23:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646292436; x=1677828436;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gavUP5woFNMy2UOPabLAQZ8b8cVnPO8XZxPEkJOlPIY=;
  b=idRSr+1L+A/uw5D45w6equmKdprONs1uUW/IJqAgcsKnUfjTRowtfq+O
   qI87pXuKWlJu1UzOLU3ttmvRrkizgEqTWUFQ6xTQGk7s0SNt8BBi9+LDO
   nr30zqOITR+V0JsrkrLdHzFUX+TA65e34KIl3yR+7jOQGRQM621RGzzwl
   9gcdm7VPmLARyicWnimcCnYXOcww5kLtcmEtUrtrdmdKKdNBLdgbRb0cK
   6P1m8vsXw64CpQppVwDdCGcM/Tpi3aVF31VfAUFWs2pLprRq2PfQbGDjx
   TS7efiBu/8axElvpFAfND+JdEYlRiol+M6uw1RgSRRdVWqg+ZZKkleDKV
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="251176922"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="251176922"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:16 -0800
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="551631461"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:13 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yu.c.zhang@intel.com,
        zixuanwang@google.com, marcorr@google.com, jun.nakajima@intel.com,
        erdemaktas@google.com
Subject: [kvm-unit-tests RFC PATCH 00/17] X86: TDX framework support
Date:   Thu,  3 Mar 2022 15:18:50 +0800
Message-Id: <20220303071907.650203-1-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* What's TDX?
TDX stands for Trust Domain Extensions which isolates VMs from
the virtual-machine manager (VMM)/hypervisor and any other software on
the platform.

To support TDX, multiple software components, not only KVM but also QEMU,
guest kernel and virtual bios, need to be updated. For more details, please
check link[1], there are TDX spec and public repository link at github for
each software component.

* What we add?
This patchset adds a basic framework to support running exist and future
test cases in TDX protected environment, so as to verify the function
of the TDX software stack. Appreciate any comment and suggestion.

This framework depends on UEFI support from Zixuan and Marc.

The supported test cases are marked in a test group named "tdx". Most of
the unsupported test cases are due to testing features not supported by
TDX, a few are due to their special design not suitable for running in UEFI.

To run a test case in TDX:
    EFI_TDX=y [EFI_UEFI=/path/to/TDVF.fd] [QEMU=/path/to/qemu-tdx] ./x86/efi/run x86/msr.efi
To run all the tdx supported test cases:
    EFI_TDX=y [EFI_UEFI=/path/to/TDVF.fd] [QEMU=/path/to/qemu-tdx] ./run_tests.sh -g tdx

[EFI_UEFI=/path/to/TDVF.fd] [QEMU=/path/to/qemu-tdx] customization can be
removed after upstream OVMF and qemu have TDX support.

* Patch organization
patch  1-7: add initial support for TDX, some simple test cases could run with them.
patch    8: TDVF support accepting part of the whole memory and this patch add
            support for accepting remain memory.
patch 9-11: add multiprocessor support
patch12-13: enable lvl5 page table as TDVF use lvl5 page table
patch   14: TDX specific test case, may add more sub-test in the future
patch   15: bypass unsupported sub-test
patch16-17: enable all the TDX supported test cases to run in a batch with run_tests.sh

TODO:
1. merge TDX multiprocessor code in UEFI MP code framework when it's ready
2. add more TDX specific sub-test
3. add mmio simuation in #VE handler

[1] https://lwn.net/Articles/876997

Zhenzhong Duan (17):
  x86 TDX: Add support functions for TDX framework
  x86 TDX: Add #VE handler
  x86 TDX: Bypass APIC and enable x2APIC directly
  x86 TDX: Add exception table support
  x86 TDX: bypass wrmsr simulation on some specific MSRs
  x86 TDX: Simulate single step on #VE handled instruction
  x86 TDX: Extend EFI run script to support TDX
  x86 TDX: Add support for memory accept
  acpi: Add MADT table parse code
  x86 TDX: Add multi processor support
  x86 TDX: Add a formal IPI handler
  x86 TDX: Enable lvl5 boot page table
  x86 TDX: Add lvl5 page table support to virtual memory
  x86 TDX: Add TDX specific test case
  x86 TDX: bypass unsupported sub-test for TDX
  x86 UEFI: Add support for parameter passing
  x86 TDX: Make run_tests.sh work with TDX

 README.md                 |   6 +
 lib/argv.c                |   2 +-
 lib/argv.h                |   1 +
 lib/asm-generic/page.h    |   7 +-
 lib/efi.c                 |  73 +++++
 lib/linux/efi.h           |  41 ++-
 lib/x86/acpi.c            | 171 +++++++++++
 lib/x86/acpi.h            |  85 ++++++
 lib/x86/apic.c            |   4 +
 lib/x86/asm/setup.h       |   2 +
 lib/x86/desc.c            |  15 +-
 lib/x86/desc.h            |  10 +
 lib/x86/processor.h       |   2 +
 lib/x86/setup.c           |  82 +++++-
 lib/x86/smp.c             |  18 +-
 lib/x86/tdcall.S          | 303 ++++++++++++++++++++
 lib/x86/tdx.c             | 576 ++++++++++++++++++++++++++++++++++++++
 lib/x86/tdx.h             | 113 ++++++++
 lib/x86/vm.c              |  14 +-
 x86/Makefile.common       |   2 +
 x86/Makefile.x86_64       |   1 +
 x86/efi/README.md         |   6 +
 x86/efi/crt0-efi-x86_64.S |  12 +-
 x86/efi/efistart64.S      |  10 +
 x86/efi/run               |  19 ++
 x86/intel_tdx.c           |  94 +++++++
 x86/msr.c                 |   6 +
 x86/syscall.c             |   3 +-
 x86/unittests.cfg         |  22 +-
 29 files changed, 1668 insertions(+), 32 deletions(-)
 create mode 100644 lib/x86/tdcall.S
 create mode 100644 lib/x86/tdx.c
 create mode 100644 lib/x86/tdx.h
 create mode 100644 x86/intel_tdx.c

-- 
2.25.1

