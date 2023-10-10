Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214297BF601
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442911AbjJJIfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442896AbjJJIfe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:35:34 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC79697;
        Tue, 10 Oct 2023 01:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696926932; x=1728462932;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kaVTzwh2dN/eWiJYBlWq1T5Rd+0YPuN2zRyUm0iABbM=;
  b=NrasSUmEuqcp2n7/JASvDaK4ADhKwc0vXpPbLp/H+yegadr72tknTkPV
   F6SqXADGSLNMJJ/26kaUOIkPvpNk7XerrSlsBWWwkaqk0pnH0JMS8fTL1
   DF0gbacJRoPmBno9IGUD3u6e40fnwTcxB7AkFSe88IHFHcT/+WHvojQHQ
   gj0ewJ7/VXHcNMsSNc5dugqkC36qSTzwfVGdxW2P9My0LGqhwxhg6HiF3
   UJULUvufnn8w9kfrCJKlV+qT14wK8s/F00UVwEzWI0tJbT4M0HeztMFTh
   wdWKwjNduYTpnrv9lJyjfme4xaMbQ3xsvdHaAkto6AOZsgkrqn/03HuHD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="387176581"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="387176581"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="730001321"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="730001321"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:31 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Chao Peng <chao.p.peng@linux.intel.com>
Subject: [PATCH 00/12] x86/mce, KVM: X86: KVM memory poison and MCE injector support
Date:   Tue, 10 Oct 2023 01:35:08 -0700
Message-Id: <cover.1696926843.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Background
==========
The TDX is a VM-based confidential computing technology.  It encrypts guest
memory to protect it from software (host OS, VMM, firmware, etc. ...) outside of
the TCB.  Software in the host can write to the protected guest memory to corrupt,
and the protected guest can consume corrupted memory.  TDX uses machine checks
to notify the TDX vcpu consumption of corrupted memory.

For VM-based confidential computing (AMD SEV-SNP and Intel TDX), the KVM guest
memfd effort [1] is ongoing.  It allows guests to use file descriptors as the
protected guest memory without user-space virtual address mapping.  KVM handles
machine checks for guest vcpu specially.  It sets up the guest so that vcpu
exits from running guests on machine check, checks the exit reason, and manually
raises the machine check by calling do_machine_check().

Although Linux supports hwpoison and MCE injection framework, there are gaps in
testing hwpoison or MCE for TDX KVM [2] with KVM guest memfd [1].  a) hwpoison
framework (debugfs /sys/kernel/debug/hwpoison/{corrupt-pfn, unpison-pfn}) uses
physical address.  MADV_{HWPISON, UNPOISON} uses the virtual address of the user
process.  However, KVM guest memfd requires file descriptor and offset.  b) The
x86 MCE injection framework, /dev/mce-log (legacy deprecated device driver
interface) or debug fs /sys/kernel/debug/mce-inject/addr, also uses a physical
address.  c) The x86 MCE injection framework injects machine checks in the
context of the injector process.  KVM wants to inject machine check on behalf of
running vcpu.


Proposed solution
=================
This patch series fills those gaps and to test KVM with injecting machine
checks.  The proposed solution is

a) Introduce new flags FADVISE_{HWPOISON, UNPOISON} to hwpoison memory to
posix_fadvise():
Possible options are a1) add new flags for posix_fadvise() because hwpoison with
file descriptor and offset is a generic operation, not specific to KVM.  (This
patch series) a2) Add KVM guest memfd specific ioctl to inject hwpoison/trigger
MCE.  We can use same value to MADV_{HWPOISON, UNPOISON}.  a3) Add KVM-specific
debugfs entry for guest memfd.  Say,
/sys/kernel/debug/kvm/<pid>-<vm-fd>/guest-memfd<fd>/hwpoison/{corrupt-offset,
unoison-offset}.

  - fadvise(FADVISE_{HWPOISON, UNPOISON}): This patch series.
    Generic interface. Not specific to KVM.
  - KVM ioctl
    KVM specific.  The KVM debugfs is better.
  - KVM debugfs
    Debugfs is natural fit because this feature is for debug/test.
    Specific to KVM guest_memfd.

b) Enhancement to x86 MCE injector:
Add debug fs entries to x86 MCE injector under /sys/kernel/debug/mce-inject/ to
allow necessary parameters.  mcgstatus and notrigger.  mcgstatus is for LMCE_S.
notrigger is to suppress triggering machine check handler so that KVM can
trigger it.

c) Add a debugfs entry for KVM vcpu to trigger MCE injection:
Because setting parameters for MCE is not specific to KVM, reuse the existing
debugfs mce-inject.  The debugfs entry is only to cause KVM to trigger
MCE.  An alternative is to add an interface to set parameters without b)
similar to /dev/mce-log.

  - KVM debugfs: this patch series.
    Debugfs is natural fit because this feature is for debug/test.
  - New KVM ioctl
    KVM debugfs seems better.
  - Enhance /dev/mce-log
    Because this is legacy, debugfs mce injector is better.
  - Enhance /sys/kernel/debug/mce-inject/
    Because the feature is KVM specific, adding the feature to KVM
    interface is better than to the x86 MCE injector.

[1] https://lore.kernel.org/all/20230914015531.1419405-1-seanjc@google.com/
    KVM guest_memfd() and per-page attributes
    https://lore.kernel.org/all/20230921203331.3746712-1-seanjc@google.com/
    [PATCH 00/13] KVM: guest_memfd fixes
[2] https://lore.kernel.org/all/cover.1690322424.git.isaku.yamahata@intel.com/
    v15 KVM TDX basic feature support

Isaku Yamahata (12):
  x86/mce: Fix hw MCE injection feature detection
  X86/mce/inject: Add mcgstatus for mce-inject debugfs
  x86/mce/inject: Add notrigger entry to suppress MCE injection
  x86/mce: Move and export inject_mce() from inject.c to core.c
  mm/fadvise: Add flags to inject hwpoison for posix_fadvise()
  mm/fadvise: Add FADV_MCE_INJECT flag for posix_fadvise()
  x86/mce/inject: Wire up the x86 MCE injector to FADV_MCE_INJECT
  x86/mce: Define a notifier chain for mce injector
  KVM: X86: Add debugfs to inject machine check on VM exit
  KVM: selftests: Allow mapping guest memory without host alias
  KVM: selftests: lib: Add src memory type for hwpoison test
  KVM: selftests: hwpoison/mce failure injection

 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/include/asm/mce.h                    |  16 +
 arch/x86/kernel/cpu/mce/core.c                |  56 ++
 arch/x86/kernel/cpu/mce/inject.c              |  91 ++-
 arch/x86/kvm/debugfs.c                        |  22 +
 arch/x86/kvm/x86.c                            |  14 +
 include/linux/fs.h                            |   8 +
 include/uapi/linux/fadvise.h                  |   5 +
 mm/fadvise.c                                  | 120 ++-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/kvm_util_base.h     |   4 +
 .../testing/selftests/kvm/include/test_util.h |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  30 +-
 tools/testing/selftests/kvm/lib/test_util.c   |   8 +
 .../testing/selftests/kvm/mem_hwpoison_test.c | 721 ++++++++++++++++++
 15 files changed, 1066 insertions(+), 33 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/mem_hwpoison_test.c


base-commit: 6465e260f48790807eef06b583b38ca9789b6072
-- 
2.25.1

