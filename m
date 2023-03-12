Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E483E6B644F
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjCLJyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjCLJyb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:31 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C251A4989A
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:54:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614859; x=1710150859;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XWMJJ/2hHmz/bkn9akg8jMbVYLZzPIETliUK5OIsnuY=;
  b=F/eUbNXEcF1T1uJAE0RWrxkeirg/Z5m8e799BoW8k/geBxeWv9cUCVur
   w8nVGN4mFMR8iUSDE28ACNItWM6Smkcqmhxd3FgT60cZgPuQvxwuHmtkI
   usVuB1WehWtkrzqbCpO71RLrf8AJqaG9g50vRakOu+esHT7Yfzo3N/vwb
   ARIx9Jdb2XQER6vzMyiID5PEXRZKMC79HmvcZI20DlnaluqK90XmxOjOu
   zSrKoJQ4xA8q+/BKTT+AYNv2ubuY80IYOzxSj6v76PKy8/rmlAJo1cJgd
   vvvSxbK78i5nDQi8LfmyAFYT0cDFMJaFp6GoQaUOE470v2CLECgeckSy9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622881"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622881"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852408943"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852408943"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:17 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-2 00/17] Introduce & support pKVM on Intel platform
Date:   Mon, 13 Mar 2023 02:00:55 +0800
Message-Id: <20230312180112.1778254-1-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DATE_IN_FUTURE_06_12,DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set is part-2 of this RFC patches. It introduces
CONFIG_PKVM_INTEL, and do a deprivilege for native run Linux,
to a host VM.

Host Linux must be trusted until pKVM got boot up, so pKVM shall be boot
as early as possible. In addition, pKVM can not support deinit (e.g.,
return host to root mode after it got deprivileged to a VM). These
disallow build KVM module (pKVM binary embedded) as a dynamic loaded
module. Thus after enable CONFIG_PKVM_INTEL, the KVM module is built-in,
and the Linux system running on bare-metal prepares environment to run
each pCPU into vmx non-root mode - this means all pCPUs in native Linux
are deprivileged to vCPUs, and the native Linux system is deprivileged
to a host VM. Meanwhile pKVM is kept running under vmx root mode with an
independent binary.

Host VM almost own all the hardware resources except modules owned by
pKVM, like VMX, EPT and IOMMU; pKVM shall fully own VMX, EPT and IOMMU
to ensure the isolation of protected VMs.

This patch set did some initial works for above:

- pKVM manages the VMX to do the host deprivilege. But there is no VMX
  emulation to host VM, so host VM can not run its guests base on pKVM
  yet.

- The EPT is disabled for host VM as no host EPT page table created in
  pKVM yet. And there is no MMU page table setup for pKVM either, so it
  reuses native Linux Kernel's CR3 page table now.

- The IOMMU is not touched by pKVM yet and directly pass-thru to host VM.

And this patch set also build pKVM as an independent binary, which make
pKVM compiled with separated sections, and add prefix __pkvm for all its
symbols to ensure pKVM & host Linux will not touch each other's symbols.
This help to do the address space isolation for pKVM and host VM in the
next patch series.

The future patch sets shall create pKVM its own CR3 page table, enable
memory isolation based on EPT page table, provide emulation of VMCS and
EPT for host VM, and enable DMA protection based on IOMMU & its
emulation for host VM (Not in this RFC).

Jason Chen CJ (16):
  pkvm: x86: Introduce CONFIG_PKVM_INTEL
  KVM: VMX: Refactor for setup_vmcs_config
  pkvm: x86: Add vmx capability check and vmx config setup
  pkvm: x86: Add pCPU env setup
  pkvm: x86: Add basic setup for host vcpu
  pkvm: x86: Introduce pkvm_host_deprivilege_cpus
  pkvm: x86: Allocate vmcs and msr bitmap pages for host vcpu
  pkvm: x86: Initailize vmcs guest state area for host vcpu
  pkvm: x86: Initialize vmcs host state area for host vcpu
  pkvm: x86: Initialize vmcs control fields for host vcpu
  pkvm: x86: Define empty debug functions for hypervisor
  pkvm: x86: Add vmexit handler for host vcpu
  pkvm: x86: Add private vmx_ops.h for pKVM
  pkvm: x86: Add pKVM retpoline.S
  pkvm: x86: Build pKVM runtime as an independent binary
  pkvm: x86: Deprivilege host OS

Zide Chen (1):
  pkvm: x86: Stub CONFIG_DEBUG_LIST in pKVM

 arch/x86/include/asm/kvm_host.h            |   1 +
 arch/x86/include/asm/pkvm_image.h          |  42 ++
 arch/x86/kernel/vmlinux.lds.S              |  32 +
 arch/x86/kvm/Kconfig                       |  13 +
 arch/x86/kvm/Makefile                      |   1 +
 arch/x86/kvm/vmx/pkvm/.gitignore           |   1 +
 arch/x86/kvm/vmx/pkvm/Makefile             |   9 +
 arch/x86/kvm/vmx/pkvm/hyp/Makefile         |  40 ++
 arch/x86/kvm/vmx/pkvm/hyp/debug.h          |  13 +
 arch/x86/kvm/vmx/pkvm/hyp/lib/list_debug.c |  17 +
 arch/x86/kvm/vmx/pkvm/hyp/lib/retpoline.S  | 113 ++++
 arch/x86/kvm/vmx/pkvm/hyp/pkvm.lds.S       |  10 +
 arch/x86/kvm/vmx/pkvm/hyp/vmexit.c         | 154 +++++
 arch/x86/kvm/vmx/pkvm/hyp/vmexit.h         |  11 +
 arch/x86/kvm/vmx/pkvm/hyp/vmx_asm.S        | 186 ++++++
 arch/x86/kvm/vmx/pkvm/hyp/vmx_ops.h        | 185 ++++++
 arch/x86/kvm/vmx/pkvm/include/pkvm.h       |  54 ++
 arch/x86/kvm/vmx/pkvm/pkvm_host.c          | 728 +++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c                     | 122 ++--
 arch/x86/kvm/vmx/vmx.h                     |  22 +
 arch/x86/kvm/vmx/vmx_ops.h                 |   7 +
 arch/x86/kvm/x86.c                         |   5 +
 include/asm-generic/vmlinux.lds.h          |  17 +
 23 files changed, 1736 insertions(+), 47 deletions(-)
 create mode 100644 arch/x86/include/asm/pkvm_image.h
 create mode 100644 arch/x86/kvm/vmx/pkvm/.gitignore
 create mode 100644 arch/x86/kvm/vmx/pkvm/Makefile
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/Makefile
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/debug.h
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/lib/list_debug.c
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/lib/retpoline.S
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/pkvm.lds.S
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/vmexit.h
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/vmx_asm.S
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/vmx_ops.h
 create mode 100644 arch/x86/kvm/vmx/pkvm/include/pkvm.h
 create mode 100644 arch/x86/kvm/vmx/pkvm/pkvm_host.c

-- 
2.25.1

