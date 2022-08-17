Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58CA596734
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 04:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238118AbiHQCCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 22:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235324AbiHQCCm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 22:02:42 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943A87FE77
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 19:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660701760; x=1692237760;
  h=from:to:cc:subject:date:message-id;
  bh=Sl693IxK0Tv2IMegSNQ5h3hCL9MM2a2gImQ/QH6/NK0=;
  b=iU0h9LlUJZM/nTcxFFnPaogF+1JYehdhKta15YIk5K63HdJWH1JAwkeM
   mNc5i7R5KlQNoJxeRK33oeJbMoi16dbOuGmaypOQGAsH1Zaz06XXNM6mK
   2cn4xVyA0S+RUR2nCUUHH5gyNkDDM5aTdckmaW1OsD5UKLohcwJ5IBlU3
   0gD4phbJg9JhH3/uvQaACu40WqtWK0fpblI0FFrWW/jyg2yw5ZXNnjBbM
   ULM/WZgatzO3trB3UGs0p5JHRLOYHyDa6eFvHnmKMAHfDq9EOb0Eg7E7w
   Mm5F8LeZBrqGAJPYxM3ixPaFABwZimlmJX5W5iAarCiIzJ5V5IMTNTyuN
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="291131189"
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="291131189"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 19:02:40 -0700
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="675456968"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 19:02:38 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v5 0/3] Enable notify VM exit
Date:   Wed, 17 Aug 2022 10:08:42 +0800
Message-Id: <20220817020845.21855-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Notify VM exit is introduced to mitigate the potential DOS attach from
malicious VM. This series is the userspace part to enable this feature
through a new KVM capability KVM_CAP_X86_NOTIFY_VMEXIT. The detailed
info can be seen in Patch 3.

The corresponding KVM support can be found in linux 6.0-rc1:
(2f4073e08f4c KVM: VMX: Enable Notify VM exit)

---
Change logs:
v4 -> v5
- Remove the assert check to avoid the nop in NDEBUG case. (Yuan)
- v4: https://lore.kernel.org/qemu-devel/20220524140302.23272-1-chenyi.qiang@intel.com/

v3 -> v4
- Add a new KVM cap KVM_CAP_TRIPLE_FAULT_EVENT to guard the extension of triple fault
  event save&restore.
- v3: https://lore.kernel.org/qemu-devel/20220421074028.18196-1-chenyi.qiang@intel.com/

v2 -> v3
- Extend the argument to include both the notify window and some flags
  when enabling KVM_CAP_X86_BUS_LOCK_EXIT CAP.
- Change to use KVM_VCPUEVENTS_VALID_TRIPLE_FAULT in flags field and add
  pending_triple_fault field in struct kvm_vcpu_events.
- v2: https://lore.kernel.org/qemu-devel/20220318082934.25030-1-chenyi.qiang@intel.com/

v1 -> v2
- Add some commit message to explain why we disable Notify VM exit by default.
- Rename KVM_VCPUEVENT_SHUTDOWN to KVM_VCPUEVENT_TRIPLE_FAULT.
- Do the corresponding change to use the KVM_VCPUEVENTS_TRIPLE_FAULT
  to save/restore the triple fault event to avoid lose some synthesized
  triple fault from KVM.
- v1: https://lore.kernel.org/qemu-devel/20220310090205.10645-1-chenyi.qiang@intel.com/

---

Chenyi Qiang (3):
  Update linux headers to 6.0-rc1
  i386: kvm: extend kvm_{get, put}_vcpu_events to support pending triple
    fault
  i386: Add notify VM exit support

 hw/i386/x86.c                                 |  45 +++++
 include/hw/i386/x86.h                         |   5 +
 include/standard-headers/asm-x86/bootparam.h  |   7 +-
 include/standard-headers/drm/drm_fourcc.h     |  73 +++++++-
 include/standard-headers/linux/ethtool.h      |  29 +--
 include/standard-headers/linux/input.h        |  12 +-
 include/standard-headers/linux/pci_regs.h     |  30 ++-
 include/standard-headers/linux/vhost_types.h  |  17 +-
 include/standard-headers/linux/virtio_9p.h    |   2 +-
 .../standard-headers/linux/virtio_config.h    |   7 +-
 include/standard-headers/linux/virtio_ids.h   |  14 +-
 include/standard-headers/linux/virtio_net.h   |  34 +++-
 include/standard-headers/linux/virtio_pci.h   |   2 +
 linux-headers/asm-arm64/kvm.h                 |  27 +++
 linux-headers/asm-generic/unistd.h            |   4 +-
 linux-headers/asm-riscv/kvm.h                 |  22 +++
 linux-headers/asm-riscv/unistd.h              |   3 +-
 linux-headers/asm-s390/kvm.h                  |   1 +
 linux-headers/asm-x86/kvm.h                   |  33 ++--
 linux-headers/asm-x86/mman.h                  |  14 --
 linux-headers/linux/kvm.h                     | 172 +++++++++++++++++-
 linux-headers/linux/userfaultfd.h             |  10 +-
 linux-headers/linux/vduse.h                   |  47 +++++
 linux-headers/linux/vfio.h                    |   4 +-
 linux-headers/linux/vfio_zdev.h               |   7 +
 linux-headers/linux/vhost.h                   |  35 +++-
 target/i386/cpu.c                             |   1 +
 target/i386/cpu.h                             |   1 +
 target/i386/kvm/kvm.c                         |  48 +++++
 29 files changed, 623 insertions(+), 83 deletions(-)

-- 
2.17.1

