Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED4D532B9A
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 15:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237951AbiEXNuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 09:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237945AbiEXNuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 09:50:13 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2356C95DD5;
        Tue, 24 May 2022 06:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653400213; x=1684936213;
  h=from:to:cc:subject:date:message-id;
  bh=zDknRWoz/4PyOLzohzgxcN97VkyYE+Alkf3vq8P2JJE=;
  b=SEVJonxntjcpDvaEXKNYvqWVH6L3Wpi/SHkP98lWIGyKcZFviW+Pb+G2
   6oxCmJq32bq86nWHpvS5psRUiddkwyH8a7VoVBxCBEq9KvbiMP2XuvEYc
   NYWXmKwYeB3dycNBUVEidXvhBjs6rhKFuer7N6ZqBd/yT+nLt8byG/XOk
   NfApDYxj95SiEDR8FbWuFBdCn1N9N6gR0ifr/n0rLrsxvZwPqKfrUUmwJ
   WODyBj7lHKCuy7fdkm5tU65i1mqWI4SrjsKvWVc3TcpCJSrl2rOfcKG5s
   JzQRnO0CJC5WbB/6gXQLa0i1BbNsPZvgAVTo74Y3Mjgqib9jLUbUn9K6d
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="272351824"
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="272351824"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 06:50:12 -0700
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="601311965"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 06:50:10 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 0/4] Introduce Notify VM exit
Date:   Tue, 24 May 2022 21:56:20 +0800
Message-Id: <20220524135624.22988-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Virtual machines can exploit Intel ISA characterstics to cause
functional denial of service to the VMM. This series introduces a new
feature named Notify VM exit, which can help mitigate such kind of
attacks.

Patch 1: An extension of KVM_SET_VCPU_EVENTS ioctl to inject a
synthesized shutdown event from user space. This is also a fix for other
synthesized triple fault, e.g. the RSM patch or nested_vmx_abort(),
which could get lost when exit to userspace to do migrate.

Patch 2: A selftest about get/set triple fault event.

Patch 3: Introduce struct kvm_caps to track misc global KVM cap/setting.

Patch 4: The main patch to enable Notify VM exit.

---
Change logs:
v6 -> v7
- Introduce a new cap KVM_CAP_TRIPLE_FAULT_EVENT to guard the extension
  of get/set triple fault event. (Sean)
- Add patch 3 from Sean to integrate misc kvm cap/settings. (Sean)
- Add the kvm lock around the notify_window and flag setting. (Sean)
- v6: https://lore.kernel.org/lkml/20220421072958.16375-1-chenyi.qiang@intel.com/

v5 -> v6
- Do some changes in document.
- Add a selftest about get/set triple fault event. (Sean)
- extend the argument to include both the notify window and some flags
  when enabling KVM_CAP_X86_BUS_LOCK_EXIT CAP. (Sean)
- Change to use KVM_VCPUEVENT_VALID_TRIPE_FAULT in flags field and add
  pending_triple_fault field in struct kvm_vcpu_events, which allows
  userspace to make/clear triple fault request. (Sean)
- Add a flag in kvm_x86_ops to avoid the kvm_has_notify_vmexit global
  varialbe and its export.(Sean)
- v5: https://lore.kernel.org/lkml/20220318074955.22428-1-chenyi.qiang@intel.com/

v4 -> v5
- rename KVM_VCPUEVENTS_SHUTDOWN to KVM_VCPUEVENTS_TRIPLE_FAULT. Make it
  bidirection and add it to get_vcpu_events. (Sean)
- v4: https://lore.kernel.org/all/20220310084001.10235-1-chenyi.qiang@intel.com/

v3 -> v4
- Change this feature to per-VM scope. (Jim)
- Once VM_CONTEXT_INVALID set in exit_qualification, exit to user space
  notify this fatal case, especially the notify VM exit happens in L2.
  (Jim)
- extend KVM_SET_VCPU_EVENTS to allow user space to inject a shutdown
  event. (Jim)
- A minor code changes.
- Add document for the new KVM capability.
- v3: https://lore.kernel.org/lkml/20220223062412.22334-1-chenyi.qiang@intel.com/

v2 -> v3
- add a vcpu state notify_window_exits to record the number of
  occurence as well as a pr_warn output. (Sean)
- Add the handling in nested VM to prevent L1 bypassing the restriction
  through launching a L2. (Sean)
- Only kill L2 when L2 VM is context invalid, synthesize a
  EXIT_REASON_TRIPLE_FAULT to L1 (Sean)
- To ease the current implementation, make module parameter
  notify_window read-only. (Sean)
- Disable notify window exit by default.
- v2: https://lore.kernel.org/lkml/20210525051204.1480610-1-tao3.xu@intel.com/

v1 -> v2
- Default set notify window to 0, less than 0 to disable.
- Add more description in commit message.
---

Chenyi Qiang (2):
  KVM: x86: Extend KVM_{G,S}ET_VCPU_EVENTS to support pending triple
    fault
  KVM: selftests: Add a test to get/set triple fault event

Sean Christopherson (1):
  KVM: x86: Introduce "struct kvm_caps" to track misc caps/settings

Tao Xu (1):
  KVM: VMX: Enable Notify VM exit

 Documentation/virt/kvm/api.rst                |  57 +++++++
 arch/x86/include/asm/kvm_host.h               |  24 ++-
 arch/x86/include/asm/vmx.h                    |   7 +
 arch/x86/include/asm/vmxfeatures.h            |   1 +
 arch/x86/include/uapi/asm/kvm.h               |   6 +-
 arch/x86/include/uapi/asm/vmx.h               |   4 +-
 arch/x86/kvm/cpuid.c                          |   8 +-
 arch/x86/kvm/debugfs.c                        |   4 +-
 arch/x86/kvm/lapic.c                          |   2 +-
 arch/x86/kvm/svm/nested.c                     |   4 +-
 arch/x86/kvm/svm/svm.c                        |  13 +-
 arch/x86/kvm/vmx/capabilities.h               |   6 +
 arch/x86/kvm/vmx/nested.c                     |  12 +-
 arch/x86/kvm/vmx/vmx.c                        |  62 ++++++--
 arch/x86/kvm/x86.c                            | 140 +++++++++++-------
 arch/x86/kvm/x86.h                            |  33 ++++-
 include/uapi/linux/kvm.h                      |  11 ++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/x86_64/triple_fault_event_test.c      | 101 +++++++++++++
 20 files changed, 390 insertions(+), 107 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c

-- 
2.17.1

