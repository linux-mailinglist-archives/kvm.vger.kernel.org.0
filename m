Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14BE532BC1
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 15:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbiEXN4u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 09:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiEXN4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 09:56:49 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB8E3465D
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 06:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653400608; x=1684936608;
  h=from:to:cc:subject:date:message-id;
  bh=gY5w/fc1CrCywA3P9SvJffDd0T+qKJWSCObbmR+/MR4=;
  b=MmTZBvnKIgq+sdZ7IAKpOfr96T0BvTaopCdqaI9UJ5JNuQys7sL/SeMU
   VbjLKSqPR3HlR5pL4fsSASk66ZpuXkzMeWJnaKkasnb7XgWU05nhIGTe6
   NKtjiMXYBgNN//kJ0fUdmoW/1+9h2ToU2PPoy/NrELH+jnnnnDSA5VG3b
   ZMtDIuzamEkH4REWHRRsbegCasr36b5ugBlNHx08AaIJ0ZIPlFfxBc8TG
   lG5jeGce8cLF7EoZtCusA+SFRYV9TqwChH7SLxN0BVSNa8Y3u7blLVMOk
   TcrqwOEyOeJe44mZc9kRmgVfCcn7qPxGMATEUDikgKB57vxWES0xnOqMO
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="273261430"
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="273261430"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 06:56:48 -0700
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="717179414"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 06:56:45 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v4 0/3] Enable notify VM exit
Date:   Tue, 24 May 2022 22:02:59 +0800
Message-Id: <20220524140302.23272-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Notify VM exit is introduced to mitigate the potential DOS attach from
malicious VM. This series is the userspace part to enable this feature
through a new KVM capability KVM_CAP_X86_NOTIFY_VMEXIT. The detailed
info can be seen in Patch 3.

The corresponding KVM patches are avaiable at:
https://lore.kernel.org/lkml/20220524135624.22988-1-chenyi.qiang@intel.com/

---
Change logs:
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
  linux-header: update linux header
  i386: kvm: extend kvm_{get, put}_vcpu_events to support pending triple
    fault
  i386: Add notify VM exit support

 hw/i386/x86.c               | 45 +++++++++++++++++++
 include/hw/i386/x86.h       |  5 +++
 linux-headers/asm-x86/kvm.h |  6 ++-
 linux-headers/linux/kvm.h   | 11 +++++
 target/i386/cpu.c           |  1 +
 target/i386/cpu.h           |  1 +
 target/i386/kvm/kvm.c       | 86 ++++++++++++++++++++++++++++---------
 7 files changed, 134 insertions(+), 21 deletions(-)

-- 
2.17.1

