Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9C7437DD
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733103AbfFMPBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:01:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57032 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732536AbfFMOfT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 10:35:19 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D915730BC58B;
        Thu, 13 Jun 2019 14:35:00 +0000 (UTC)
Received: from x1w.redhat.com (unknown [10.40.205.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 393DD1001B2B;
        Thu, 13 Jun 2019 14:34:48 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Rob Bradford <robert.bradford@intel.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v2 00/20] hw/i386/pc: Do not restrict the fw_cfg functions to the PC machine
Date:   Thu, 13 Jun 2019 16:34:26 +0200
Message-Id: <20190613143446.23937-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 13 Jun 2019 14:35:19 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This is my take at salvaging some NEMU good work.
Samuel worked in adding the fw_cfg device to the x86-virt NEMU machine.
This series is inspired by NEMU's commit 3cb92d080835 [*] and adapted
to upstream style. The result makes the upstream codebase more
modularizable.
There are very little logical changes, this is mostly a cleanup
refactor.

Since v1:
- Addressed Li and MST comments

$ git backport-diff -u v1
Key:
[----] : patches are identical
[####] : number of functional differences between upstream/downstream patch
[down] : patch is downstream-only
The flags [FC] indicate (F)unctional and (C)ontextual differences, respectively

001/20:[----] [-C] 'hw/i386/pc: Use unsigned type to index arrays'
002/20:[----] [-C] 'hw/i386/pc: Use size_t type to hold/return a size of array'
003/20:[----] [--] 'hw/i386/pc: Let e820_add_entry() return a ssize_t type'
004/20:[0008] [FC] 'hw/i386/pc: Add the E820Type enum type'
005/20:[----] [-C] 'hw/i386/pc: Add documentation to the e820_*() functions'
006/20:[----] [--] 'hw/i386/pc: Use e820_get_num_entries() to access e820_entries'
007/20:[0016] [FC] 'hw/i386/pc: Extract e820 memory layout code'
008/20:[----] [--] 'hw/i386/pc: Use address_space_memory in place'
009/20:[down] 'hw/i386/pc: Rename bochs_bios_init as more generic fw_cfg_arch_create'
010/20:[0009] [FC] 'hw/i386/pc: Pass the boot_cpus value by argument'
011/20:[0010] [FC] 'hw/i386/pc: Pass the apic_id_limit value by argument'
012/20:[0009] [FC] 'hw/i386/pc: Pass the CPUArchIdList array by argument'
013/20:[0008] [FC] 'hw/i386/pc: Let fw_cfg_init() use the generic MachineState'
014/20:[----] [--] 'hw/i386/pc: Let pc_build_smbios() take a FWCfgState argument'
015/20:[----] [--] 'hw/i386/pc: Let pc_build_smbios() take a generic MachineState argument'
016/20:[----] [--] 'hw/i386/pc: Rename pc_build_smbios() as generic fw_cfg_build_smbios()'
017/20:[----] [--] 'hw/i386/pc: Let pc_build_feature_control() take a FWCfgState argument'
018/20:[----] [--] 'hw/i386/pc: Let pc_build_feature_control() take a MachineState argument'
019/20:[----] [--] 'hw/i386/pc: Rename pc_build_feature_control() as generic fw_cfg_build_*'
020/20:[0132] [FC] 'hw/i386/pc: Extract the x86 generic fw_cfg code'
Do you want to view the diffs using meld? y/[n]:

Regards,

Phil.

[*] https://github.com/intel/nemu/commit/3cb92d080835ac8d47c8b713156338afa33cff5c

Philippe Mathieu-Daudé (20):
  hw/i386/pc: Use unsigned type to index arrays
  hw/i386/pc: Use size_t type to hold/return a size of array
  hw/i386/pc: Let e820_add_entry() return a ssize_t type
  hw/i386/pc: Add the E820Type enum type
  hw/i386/pc: Add documentation to the e820_*() functions
  hw/i386/pc: Use e820_get_num_entries() to access e820_entries
  hw/i386/pc: Extract e820 memory layout code
  hw/i386/pc: Use address_space_memory in place
  hw/i386/pc: Rename bochs_bios_init as more generic fw_cfg_arch_create
  hw/i386/pc: Pass the boot_cpus value by argument
  hw/i386/pc: Pass the apic_id_limit value by argument
  hw/i386/pc: Pass the CPUArchIdList array by argument
  hw/i386/pc: Let fw_cfg_init() use the generic MachineState
  hw/i386/pc: Let pc_build_smbios() take a FWCfgState argument
  hw/i386/pc: Let pc_build_smbios() take a generic MachineState argument
  hw/i386/pc: Rename pc_build_smbios() as generic fw_cfg_build_smbios()
  hw/i386/pc: Let pc_build_feature_control() take a FWCfgState argument
  hw/i386/pc: Let pc_build_feature_control() take a MachineState
    argument
  hw/i386/pc: Rename pc_build_feature_control() as generic
    fw_cfg_build_*
  hw/i386/pc: Extract the x86 generic fw_cfg code

 hw/i386/Makefile.objs        |   2 +-
 hw/i386/e820_memory_layout.c |  60 +++++++++++
 hw/i386/e820_memory_layout.h |  76 +++++++++++++
 hw/i386/fw_cfg.c             | 137 ++++++++++++++++++++++++
 hw/i386/fw_cfg.h             |   8 ++
 hw/i386/pc.c                 | 201 ++---------------------------------
 include/hw/i386/pc.h         |  11 --
 target/i386/kvm.c            |   1 +
 8 files changed, 291 insertions(+), 205 deletions(-)
 create mode 100644 hw/i386/e820_memory_layout.c
 create mode 100644 hw/i386/e820_memory_layout.h

-- 
2.20.1

