Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340255E74D3
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 09:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiIWH0j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 03:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiIWH0i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 03:26:38 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C6412B4B5
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 00:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663917997; x=1695453997;
  h=from:to:cc:subject:date:message-id;
  bh=eJE+V/zd8eDJl9FgeFYELSaFkFMlAz8LS3Mil0zjLFo=;
  b=hCJ+yRFX7xFaZvhjhdqDvMt2tIsqb5xa+heGqeZp0lRCibKCJnFcjCjp
   NlyupL9caZVUD30iGbiDFvaaS0oRvuvaMb/Rko6zHjibp2U3F1RFthIoA
   YBfLfhaDqBwKVAXb5XyXxHy0S6SQXPUKBmSZH/8amp6nM/OHqn26XeMHW
   kVjSjS/pH4eAyez8HbSUZaPSG7+V+OePD2sL7nHw2hFTR/R9DSqLUxeqj
   sVib4w3GH5/6DIEogsbcUZ0d3CzPEdyYflsVlRBZl5Bmb60XnOINELNo0
   NYrGzAHy5ksaeKe0CaV96De99+jodGyEPLS8vDOxOtFvB4Sy/iPUECuxs
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="287646911"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="287646911"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 00:26:37 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="620121665"
Received: from chenyi-pc.sh.intel.com ([10.239.159.53])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 00:26:35 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Peter Xu <peterx@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v7 0/2] Enable notify VM exit
Date:   Fri, 23 Sep 2022 15:33:31 +0800
Message-Id: <20220923073333.23381-1-chenyi.qiang@intel.com>
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
info can be seen in Patch 2.

The corresponding KVM support can be found in linux 6.0-rc:
(2f4073e08f4c KVM: VMX: Enable Notify VM exit)

This patch set depends on some definition which can be updated from
scripts/update-linux-headers.sh. The corresponding separate patch set is
available at:
https://lists.gnu.org/archive/html/qemu-devel/2022-09/msg02102.html

---
Change logs:
v6 -> v7
- Add a warning message when exiting to userspace (Peter Xu)
- v6: https://lore.kernel.org/all/20220915092839.5518-1-chenyi.qiang@intel.com/

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

---

Chenyi Qiang (2):
  i386: kvm: extend kvm_{get, put}_vcpu_events to support pending triple
    fault
  i386: Add notify VM exit support

 hw/i386/x86.c         | 45 ++++++++++++++++++++++++++++++++++++
 include/hw/i386/x86.h |  5 ++++
 qemu-options.hx       | 10 +++++++-
 target/i386/cpu.c     |  1 +
 target/i386/cpu.h     |  1 +
 target/i386/kvm/kvm.c | 54 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 115 insertions(+), 1 deletion(-)

-- 
2.17.1

