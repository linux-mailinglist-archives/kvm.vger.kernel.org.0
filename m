Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B64691A0B
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 00:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfHRWy2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Aug 2019 18:54:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32964 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbfHRWy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Aug 2019 18:54:28 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AE516C049E10;
        Sun, 18 Aug 2019 22:54:27 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-33.brq.redhat.com [10.40.204.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A4E51D1;
        Sun, 18 Aug 2019 22:54:16 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Samuel Ortiz <sameo@linux.intel.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Rob Bradford <robert.bradford@intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v4 00/15] hw/i386/pc: Do not restrict the fw_cfg functions to the PC machine
Date:   Mon, 19 Aug 2019 00:53:59 +0200
Message-Id: <20190818225414.22590-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Sun, 18 Aug 2019 22:54:27 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This is my take at salvaging some NEMU good work.
Samuel worked in adding the fw_cfg device to the x86-virt NEMU machine.
This series is inspired by NEMU's commit 3cb92d080835 [0] and adapted
to upstream style. The result makes the upstream codebase more
modularizable.
There are very little logical changes, this is mostly a cleanup
refactor.

Since v3 [3]:
- Addressed Christophe suggestion (patch #8)
- Rebased patch #15 since Eduardo merged Like Xu's work between.

Since v2 [2]:
- Addressed MST comments from v2 (only patch #2 modified)
  - do not use unsigned for enum
  - do not add unuseful documentation

Since v1 [1]:
- Addressed Li and MST comments

$ git backport-diff -u v3
Key:
[----] : patches are identical
[####] : number of functional differences between upstream/downstream patch
[down] : patch is downstream-only
The flags [FC] indicate (F)unctional and (C)ontextual differences, respectively

001/15:[----] [--] 'hw/i386/pc: Use e820_get_num_entries() to access e820_entries'
002/15:[----] [-C] 'hw/i386/pc: Extract e820 memory layout code'
003/15:[----] [--] 'hw/i386/pc: Use address_space_memory in place'
004/15:[----] [-C] 'hw/i386/pc: Rename bochs_bios_init as more generic fw_cfg_arch_create'
005/15:[----] [--] 'hw/i386/pc: Pass the boot_cpus value by argument'
006/15:[----] [--] 'hw/i386/pc: Pass the apic_id_limit value by argument'
007/15:[0002] [FC] 'hw/i386/pc: Pass the CPUArchIdList array by argument'
008/15:[down] 'hw/i386/pc: Remove unused PCMachineState argument in fw_cfg_arch_create'
009/15:[----] [-C] 'hw/i386/pc: Let pc_build_smbios() take a FWCfgState argument'
010/15:[----] [-C] 'hw/i386/pc: Let pc_build_smbios() take a generic MachineState argument'
011/15:[----] [-C] 'hw/i386/pc: Rename pc_build_smbios() as generic fw_cfg_build_smbios()'
012/15:[----] [--] 'hw/i386/pc: Let pc_build_feature_control() take a FWCfgState argument'
013/15:[----] [--] 'hw/i386/pc: Let pc_build_feature_control() take a MachineState argument'
014/15:[----] [--] 'hw/i386/pc: Rename pc_build_feature_control() as generic fw_cfg_build_*'
015/15:[0017] [FC] 'hw/i386/pc: Extract the x86 generic fw_cfg code'

Regards,

Phil.

[0] https://github.com/intel/nemu/commit/3cb92d080835ac8d47c8b713156338afa33cff5c
[1] https://lists.gnu.org/archive/html/qemu-devel/2019-05/msg05759.html
[2] https://lists.gnu.org/archive/html/qemu-devel/2019-06/msg02786.html
[3] https://lists.gnu.org/archive/html/qemu-devel/2019-07/msg00193.html

Philippe Mathieu-Daudé (15):
  hw/i386/pc: Use e820_get_num_entries() to access e820_entries
  hw/i386/pc: Extract e820 memory layout code
  hw/i386/pc: Use address_space_memory in place
  hw/i386/pc: Rename bochs_bios_init as more generic fw_cfg_arch_create
  hw/i386/pc: Pass the boot_cpus value by argument
  hw/i386/pc: Pass the apic_id_limit value by argument
  hw/i386/pc: Pass the CPUArchIdList array by argument
  hw/i386/pc: Remove unused PCMachineState argument in
    fw_cfg_arch_create
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
 hw/i386/e820_memory_layout.c |  59 ++++++++++
 hw/i386/e820_memory_layout.h |  42 ++++++++
 hw/i386/fw_cfg.c             | 136 +++++++++++++++++++++++
 hw/i386/fw_cfg.h             |   7 ++
 hw/i386/pc.c                 | 202 ++---------------------------------
 include/hw/i386/pc.h         |  11 --
 target/i386/kvm.c            |   1 +
 8 files changed, 254 insertions(+), 206 deletions(-)
 create mode 100644 hw/i386/e820_memory_layout.c
 create mode 100644 hw/i386/e820_memory_layout.h

-- 
2.20.1

