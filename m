Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEABE4DD60C
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 09:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbiCRIZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 04:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbiCRIZI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 04:25:08 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D56D8564B
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 01:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647591830; x=1679127830;
  h=from:to:cc:subject:date:message-id;
  bh=i/JJFLyJDjFn1s9WmE8jwULfMKu8AvMeotO8o1pccgA=;
  b=TMxLw14sQ0LBcCftxBVhDI3k/fyn9VpxjGnvCBnVHNg8RcpWCRjeYXOn
   tRrUPLXpre56nEiaPO4/gO3vYlchJJBEJEf45q1XRQ0HW/rXaG9m0eJ2B
   mZAJ1hsjUabBnL+z9BvaVvZlP9d3AZUWXjHYCRC2CX91hvTYy+P4ykTq6
   JT1TAQiXV36rt6vgbzu/JF3snluI/do8PkciF1h6SN8YShtoCsN34oM4v
   PA2Y3jkZT8UJLGpIwzqeyD+60hdNafCRFyy0G/xpSNeMP21HaENhPW7iE
   XYaPLVkOxGn/kJsRMDg38q4MjefnMNapPNYdKbR53eyKNanQIA68C3l0i
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="343528098"
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="343528098"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 01:23:50 -0700
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="558320543"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 01:23:47 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v2 0/3] Enable notify VM exit
Date:   Fri, 18 Mar 2022 16:29:31 +0800
Message-Id: <20220318082934.25030-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Notify VM exit is introduced to mitigate the potential DOS attach from
malicious VM. This series is the userspace part to enable this feature
through a new KVM capability KVM_CAP_X86_NOTIFY_VMEXIT. The
corresponding KVM patch series is available at

https://lore.kernel.org/lkml/20220318074955.22428-1-chenyi.qiang@intel.com/

---
Change logs:
v1 -> v2
- Add some commit message to explain why we disable Notify VM exit by default.
- Rename KVM_VCPUEVENT_SHUTDOWN to KVM_VCPUEVENT_TRIPLE_FAULT.
- Do the corresponding change to use the KVM_VCPUEVENTS_TRIPLE_FAULT
  to save/restore the triple fault event to avoid lose some synthesized
  triple fault from KVM.
- v1: https://lore.kernel.org/qemu-devel/20220310090205.10645-1-chenyi.qiang@intel.com/

---

Chenyi Qiang (3):
  linux-headers: Sync the linux headers
  i386: kvm: Save&restore triple fault event
  i386: Add notify VM exit support

 hw/i386/x86.c               | 24 +++++++++++++
 include/hw/i386/x86.h       |  3 ++
 linux-headers/asm-x86/kvm.h |  4 +++
 linux-headers/linux/kvm.h   | 29 +++++++++++++---
 target/i386/cpu.c           |  1 +
 target/i386/cpu.h           |  1 +
 target/i386/kvm/kvm.c       | 68 ++++++++++++++++++++++++++-----------
 7 files changed, 105 insertions(+), 25 deletions(-)

-- 
2.17.1

