Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48268509906
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 09:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385777AbiDUH1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 03:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385755AbiDUH1m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 03:27:42 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E80B49;
        Thu, 21 Apr 2022 00:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650525891; x=1682061891;
  h=from:to:cc:subject:date:message-id;
  bh=5i2QjPQG+ow+ZD5MP6LoJVVxJRKvV2NNUYuaxiC+6pM=;
  b=mKPSNgzP53i/pYgNiH+fPMgF1k21LU+RknuSO8ux8RbZPAuKNEONBtlL
   Sn7vMAc/VIwy5OH7JhJDAO+rRtntgIM1s3yY6DczvbY6VfwWFtTUg+A17
   mwOvEM0T/Xi02lWyeE/CNAtS6VXr5XmdxHM6kBxxL4N785u5+0s3SalED
   CknnxFj74HM6U1qozI5CTVQKdmhiIKLz8iu+ZvbjUcI3mXHpOVqnIJxxN
   9J1hMSbhDk93q31WleGIf89n777+DnWugIwao2L/mrlLebBUi+3gtUAH9
   ydzGZ01HgMVRzD/BVRbKndwNgnLko0YNZXZNRGAXlVA1GFaLTyyEIRaFC
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="324709279"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="324709279"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 00:24:49 -0700
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="727860203"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 00:24:47 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 0/3] Introduce Notify VM exit
Date:   Thu, 21 Apr 2022 15:29:55 +0800
Message-Id: <20220421072958.16375-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

Patch 3: The main patch to enable Notify VM exit.

---
Change logs:
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
  KVM: X86: Save&restore the triple fault request
  KVM: selftests: Add a test to get/set triple fault event

Tao Xu (1):
  KVM: VMX: Enable Notify VM exit

 Documentation/virt/kvm/api.rst                | 55 +++++++++++
 arch/x86/include/asm/kvm_host.h               |  9 ++
 arch/x86/include/asm/vmx.h                    |  7 ++
 arch/x86/include/asm/vmxfeatures.h            |  1 +
 arch/x86/include/uapi/asm/kvm.h               |  4 +-
 arch/x86/include/uapi/asm/vmx.h               |  4 +-
 arch/x86/kvm/vmx/capabilities.h               |  6 ++
 arch/x86/kvm/vmx/nested.c                     |  8 ++
 arch/x86/kvm/vmx/vmx.c                        | 48 +++++++++-
 arch/x86/kvm/x86.c                            | 33 ++++++-
 arch/x86/kvm/x86.h                            |  5 +
 include/uapi/linux/kvm.h                      | 10 ++
 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../kvm/x86_64/triple_fault_event_test.c      | 96 +++++++++++++++++++
 15 files changed, 280 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c

-- 
2.17.1

