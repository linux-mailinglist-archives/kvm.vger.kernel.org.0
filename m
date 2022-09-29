Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C675EEE94
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 09:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235159AbiI2HOM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 03:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbiI2HOG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 03:14:06 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E871E132FCC
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 00:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664435639; x=1695971639;
  h=from:to:cc:subject:date:message-id;
  bh=nwY5bmJV6FRcP6uUqHV21Hqn9xma6O1iWPE5VL+dj9s=;
  b=Ifeiv1PE4IGRHYhrw8n0Nee8zNkD1TVhUR9riK1jy5ogaKV4oarHVayi
   Dh5JmTxvlwOdgOq1CIv4NTeCET1BEWUCTA5tlmc2YQKvw2P5wmaUX0IOi
   FDiwBrzhhDsuC46MGdEzXef2IEqj6w7ExBqRWu8QkyhFCGdbi9USOpGeo
   ejYNjM7YmUhol4Ha0bOFwo5Wg+OCrCKoQCQJYYbYgtT12Cit/HXW/1eoJ
   +dTYew7cAcz+W6Wz0sRFPTc4OnnehXMf894Rw2RyHKk9XJgcNYOpA07gu
   N121jgO1L8aUwLtkYhWe7L2/D50IqJW2orfGXheX+ir3STfUnGNy/Lzf/
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="288978793"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="288978793"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 00:13:58 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="655440710"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="655440710"
Received: from chenyi-pc.sh.intel.com ([10.239.159.53])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 00:13:56 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Peter Xu <peterx@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [RESEND PATCH v8 0/4] Enable notify VM exit
Date:   Thu, 29 Sep 2022 15:20:10 +0800
Message-Id: <20220929072014.20705-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's a minor issue in previous version. Sorry for that and please
ignore that version. Resend the patch set.

---

Notify VM exit is introduced to mitigate the potential DOS attach from
malicious VM. This series is the userspace part to enable this feature
through a new KVM capability KVM_CAP_X86_NOTIFY_VMEXIT. The detailed
info can be seen in Patch 4.

The corresponding KVM support can be found in linux 6.0-rc:
(2f4073e08f4c KVM: VMX: Enable Notify VM exit)

---
Change logs:
v7 -> v8
- Add triple_fault_pending field transmission on migration (Paolo)
- Change the notify-vmexit and notify-window to the accelerator property. Add it as
  a x86-specific property. (Paolo)
- Add a preparation patch to expose struct KVMState in order to add target-specific property.
- Define three option for notify-vmexit. Make it on by default. (Paolo)
- Raise a KVM internal error instead of triple fault if invalid context of guest VMCS detected.
- v7: https://lore.kernel.org/qemu-devel/20220923073333.23381-1-chenyi.qiang@intel.com/

v6 -> v7
- Add a warning message when exiting to userspace (Peter Xu)
- v6: https://lore.kernel.org/all/20220915092839.5518-1-chenyi.qiang@intel.com/

v5 -> v6
- Add some info related to the valid range of notify_window in patch 2. (Peter Xu)
- Add the doc in qemu-options.hx. (Peter Xu)
- v5: https://lore.kernel.org/qemu-devel/20220817020845.21855-1-chenyi.qiang@intel.com/

---

Chenyi Qiang (3):
  i386: kvm: extend kvm_{get, put}_vcpu_events to support pending triple
    fault
  kvm: expose struct KVMState
  i386: add notify VM exit support

Paolo Bonzini (1):
  kvm: allow target-specific accelerator properties

 accel/kvm/kvm-all.c      |  78 ++-----------------------
 include/sysemu/kvm.h     |   2 +
 include/sysemu/kvm_int.h |  75 ++++++++++++++++++++++++
 qapi/run-state.json      |  17 ++++++
 qemu-options.hx          |  11 ++++
 target/arm/kvm.c         |   4 ++
 target/i386/cpu.c        |   1 +
 target/i386/cpu.h        |   1 +
 target/i386/kvm/kvm.c    | 122 +++++++++++++++++++++++++++++++++++++++
 target/i386/machine.c    |  20 +++++++
 target/mips/kvm.c        |   4 ++
 target/ppc/kvm.c         |   4 ++
 target/riscv/kvm.c       |   4 ++
 target/s390x/kvm/kvm.c   |   4 ++
 14 files changed, 273 insertions(+), 74 deletions(-)

-- 
2.17.1

