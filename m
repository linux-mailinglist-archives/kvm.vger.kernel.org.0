Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1C5509955
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 09:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385878AbiDUHis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 03:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385841AbiDUHi2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 03:38:28 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F918DFE7
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 00:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650526539; x=1682062539;
  h=from:to:cc:subject:date:message-id;
  bh=RYpKhYSMq8eLjdVzyNHf0E3ErJBgLIYFUFJXCz7oYy0=;
  b=Xc9sj8IqSnXAWAXeVJxEHNWzvX6C4DIFRYv/CZXDiSXVwXVsImA9zxlk
   y/zV0MPCGAq0u25TtTWIUU/EI6blSvLov0bKAHUY4J3EbVjicEko0P99z
   MoPjc575tN6txdGxjV2Xu/UIvgboKx+8XodeVBNzGxz4qaSSvu0ZVarDA
   rJmhdfB4Krc23kWfP/kEg7eKxj1eklhhEoQjKDzkk9wivgZmTiAYDz+up
   h0hVjlpINtByNMpgTEgdjIWSNLnm54WI7ucbnmckWT/K3wadxwSdmAzEa
   bqpRvJSLMFONGqSW07yLod+K7+YJn/Pqx71no65CFEYSm/T6MSRFgDj2J
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="264440487"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="264440487"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 00:35:15 -0700
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="530155117"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 00:35:12 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH v3 0/3] Enable notify VM exit
Date:   Thu, 21 Apr 2022 15:40:25 +0800
Message-Id: <20220421074028.18196-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
https://lore.kernel.org/lkml/20220421072958.16375-1-chenyi.qiang@intel.com/

---
Change logs:
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
  i386: kvm: Save&restore triple fault event
  i386: Add notify VM exit support

 hw/i386/x86.c               | 45 ++++++++++++++++++++++++
 include/hw/i386/x86.h       |  5 +++
 linux-headers/asm-x86/kvm.h |  4 ++-
 linux-headers/linux/kvm.h   | 10 ++++++
 target/i386/cpu.c           |  1 +
 target/i386/cpu.h           |  1 +
 target/i386/kvm/kvm.c       | 70 ++++++++++++++++++++++++++-----------
 7 files changed, 114 insertions(+), 22 deletions(-)

-- 
2.17.1

