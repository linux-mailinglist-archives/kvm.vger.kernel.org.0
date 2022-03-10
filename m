Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3D74D429E
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 09:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240389AbiCJIfI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 03:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240359AbiCJIfH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 03:35:07 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0942C5BE58;
        Thu, 10 Mar 2022 00:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646901246; x=1678437246;
  h=from:to:cc:subject:date:message-id;
  bh=nz5FzexQmq7xmux0Vn9kIxPKVazZKup2wF1i2KERivk=;
  b=ihjvRKREeBn6xQYTMuahJyIqhLfwHMjYERNMrgfGYhxK8hDrmGBbe0AP
   u33nN2O15BN9LT60fHyIjlTY8MqLF5FW9EO5QoigdCPCD7XekmW0mVEJr
   69kOFd4M1V3OSsShTgatqrlnRfm3Rw9UWabRNT4ejY+PBKBEkfnTicF0f
   pUBnd1aSfIcAwtW9WGCtRQUJkx92nKqrsKhDZSyBqsiLzEreeed/tj/d+
   9vRifD5KSlS2kE06FZJgSPSdoDXqO68h5c7b76kTfrZal2UHFMmPN2L4G
   1PpbXan/a5fctush6l4oLj86VW4vqH3fydP2OWmP5A+Fb1S7ydzjytjGq
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="235800117"
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="235800117"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 00:34:06 -0800
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="513891422"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 00:34:04 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/3] Introduce Notify VM exit
Date:   Thu, 10 Mar 2022 16:39:58 +0800
Message-Id: <20220310084001.10235-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
attack.

Patch 1: An extension of KVM_SET_VCPU_EVENTS ioctl to inject a
synthesized shutdown event from user space.

Patch 2: The main patch to enable Notify VM exit.

Patch 3: Add document about the new KVM capability and KVM exit reason.

---
Change logs:
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
  KVM: X86: Extend KVM_SET_VCPU_EVENTS to inject a SHUTDOWN event
  KVM: Add document for KVM_CAP_X86_NOTIFY_VMEXIT and KVM_EXIT_NOTIFY

Tao Xu (1):
  KVM: VMX: Enable Notify VM exit

 Documentation/virt/kvm/api.rst     | 42 ++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h    |  5 ++++
 arch/x86/include/asm/vmx.h         |  7 +++++
 arch/x86/include/asm/vmxfeatures.h |  1 +
 arch/x86/include/uapi/asm/kvm.h    |  1 +
 arch/x86/include/uapi/asm/vmx.h    |  4 ++-
 arch/x86/kvm/vmx/capabilities.h    |  6 ++++
 arch/x86/kvm/vmx/nested.c          | 17 +++++++++++-
 arch/x86/kvm/vmx/vmx.c             | 44 ++++++++++++++++++++++++++++--
 arch/x86/kvm/x86.c                 | 25 +++++++++++++++--
 arch/x86/kvm/x86.h                 |  5 ++++
 include/uapi/linux/kvm.h           |  7 +++++
 12 files changed, 156 insertions(+), 8 deletions(-)

-- 
2.17.1

