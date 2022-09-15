Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9075B974F
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 11:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiIOJWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 05:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiIOJWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 05:22:11 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7419889926
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 02:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663233730; x=1694769730;
  h=from:to:cc:subject:date:message-id;
  bh=SkR324RLMMkIUWiv3hw1YvNe88zTRhG2iEk5umz+KYg=;
  b=JUOh4p6u8ddA/c03S2s7vUAV4ft9F7k3juxOvbhQ7Q785HtiMKQuxPwE
   icE41tgR7ffrEoF8riYiqzMbrRs/wP+Sqqa+RVckWeE3EWv/NcLuY0GyF
   TVFN/gSbmwuruoSndAH5SfDIlrURT71Cr8iMqsW4yuriY3C6rseVnoBWs
   B9cktgtQwiLtiJg4miCNVLKgDVNxsmighrl0mvlYd/2Nj1ml4DEIuxndz
   sLppY0sTML7Aji+1StxdGPkw6ageSCJ0WgmCGgCsD2FL2jnBDY8z3TeIN
   rntEGetAtXunTcniaSzkftU2s5RHTMiH7yWqmR8IxAnWyHBDRUZ3Tac+V
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="299475267"
X-IronPort-AV: E=Sophos;i="5.93,317,1654585200"; 
   d="scan'208";a="299475267"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 02:21:52 -0700
X-IronPort-AV: E=Sophos;i="5.93,317,1654585200"; 
   d="scan'208";a="759563761"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 02:21:50 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Peter Xu <peterx@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v6 0/2] Enable notify VM exit
Date:   Thu, 15 Sep 2022 17:28:37 +0800
Message-Id: <20220915092839.5518-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
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

This patch set depends on some definition which can be updated from
scripts/update-linux-headers.sh. A separate patch set is sent out at
https://lists.gnu.org/archive/html/qemu-devel/2022-09/msg02102.html

---
Change logs:
v5 -> v6
- Add some info related to the valid range of notify_window in patch 2. (Peter Xu)
- Add the doc in qemu-options.hx. (Peter Xu)
- v5: https://lore.kernel.org/qemu-devel/20220817020845.21855-1-chenyi.qiang@intel.com/

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

Chenyi Qiang (2):
  i386: kvm: extend kvm_{get, put}_vcpu_events to support pending triple
    fault
  i386: Add notify VM exit support

 hw/i386/x86.c         | 45 ++++++++++++++++++++++++++++++++++++++++
 include/hw/i386/x86.h |  5 +++++
 qemu-options.hx       | 10 ++++++++-
 target/i386/cpu.c     |  1 +
 target/i386/cpu.h     |  1 +
 target/i386/kvm/kvm.c | 48 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 109 insertions(+), 1 deletion(-)

-- 
2.17.1

