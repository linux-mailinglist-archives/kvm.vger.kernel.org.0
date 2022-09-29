Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91CAE5EEE26
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 08:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbiI2G4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 02:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234434AbiI2G4q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 02:56:46 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4601712B4BB
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 23:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664434605; x=1695970605;
  h=from:to:cc:subject:date:message-id;
  bh=rJLbSPcnX3/oXcI+W/wXHWPYmRO1oX+WALuKjgicB3k=;
  b=VchVcQyyP5Sf88gwNhY32LM2fwqH4lDjQCfE+oqBV9vV7NKSBjvb8IeQ
   d4uc0R9VNHezPfAFKXZiRNEZfCbeWuwvN/D79Khv2v728K4It0cO/DiBC
   BzOCs3+tPpkjBWc8EqTLL16GrPfRgfAZl3bFPrrUZA0W7nL0B691+q/+6
   ZWp1IsstNpRs9TlDSZbjgJgu6HSdWyZ9XPnPLXUCAPJTpXnjjRusJKZQY
   jgeTOLI/TrQ0TmdWhT2XFsOIm+I0BD7SHzGmGuzEyrnMqYoy2cbBKVpQZ
   X0q5Z/zAXoLXSByskz5ZGGT3mm5vxCg/SKuKKwPok1v3nofit0mnil4jq
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="302724720"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="302724720"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 23:56:44 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="711268467"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="711268467"
Received: from chenyi-pc.sh.intel.com ([10.239.159.53])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 23:56:42 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Peter Xu <peterx@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v8 0/4] Enable notify VM exit
Date:   Thu, 29 Sep 2022 15:03:37 +0800
Message-Id: <20220929070341.4846-1-chenyi.qiang@intel.com>
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
 target/i386/kvm/kvm.c    | 121 +++++++++++++++++++++++++++++++++++++++
 target/i386/machine.c    |  20 +++++++
 target/mips/kvm.c        |   4 ++
 target/ppc/kvm.c         |   4 ++
 target/riscv/kvm.c       |   4 ++
 target/s390x/kvm/kvm.c   |   4 ++
 14 files changed, 272 insertions(+), 74 deletions(-)

-- 
2.17.1

