Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0E9278AEB
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 16:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgIYOfE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 10:35:04 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:12199 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728960AbgIYOfD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 10:35:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1601044503; x=1632580503;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=glN5TArU2loYWTVC+Uyhcgh2yNYL1XpJNimKI1PsQRc=;
  b=Dfsz7OdpVQv3UyBpRmgqfqBnFiWPO37j8bLRcWypPY40tK3SyDZMAxz0
   Jf7ibU4UC/ckwj0M3H2wpXifgk4jzCLi+k+FWINWm1XoSfkptP7PNP4HH
   I4ElIijnT8yCMdtKWGWFM+o6OkVc7zlJSe6ZeGUJc/sMThaXrGsKcL0Wv
   I=;
X-IronPort-AV: E=Sophos;i="5.77,302,1596499200"; 
   d="scan'208";a="79292761"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 25 Sep 2020 14:34:41 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 08BBAA1C9C;
        Fri, 25 Sep 2020 14:34:33 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 25 Sep 2020 14:34:33 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.162.221) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 25 Sep 2020 14:34:30 +0000
From:   Alexander Graf <graf@amazon.com>
To:     kvm list <kvm@vger.kernel.org>
CC:     Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 0/8] Allow user space to restrict and augment MSR emulation
Date:   Fri, 25 Sep 2020 16:34:14 +0200
Message-ID: <20200925143422.21718-1-graf@amazon.com>
X-Mailer: git-send-email 2.28.0.394.ge197136389
MIME-Version: 1.0
X-Originating-IP: [10.43.162.221]
X-ClientProxiedBy: EX13D08UWC002.ant.amazon.com (10.43.162.168) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While tying to add support for the MSR_CORE_THREAD_COUNT MSR in KVM,
I realized that we were still in a world where user space has no control
over what happens with MSR emulation in KVM.

That is bad for multiple reasons. In my case, I wanted to emulate the
MSR in user space, because it's a CPU specific register that does not
exist on older CPUs and that really only contains informational data that
is on the package level, so it's a natural fit for user space to provide
it.

However, it is also bad on a platform compatibility level. Currrently,
KVM has no way to expose different MSRs based on the selected target CPU
type.

This patch set introduces a way for user space to indicate to KVM which
MSRs should be handled in kernel space. With that, we can solve part of
the platform compatibility story. Or at least we can not handle AMD specific
MSRs on an Intel platform and vice versa.

In addition, it introduces a way for user space to get into the loop
when an MSR access would generate a #GP fault, such as when KVM finds an
MSR that is not handled by the in-kernel MSR emulation or when the guest
is trying to access reserved registers.

In combination with filtering, user space trapping allows us to emulate
arbitrary MSRs in user space, paving the way for target CPU specific MSR
implementations from user space.

v1 -> v2:

  - s/ETRAP_TO_USER_SPACE/ENOENT/g
  - deflect all #GP injection events to user space, not just unknown MSRs.
    That was we can also deflect allowlist errors later
  - fix emulator case
  - new patch: KVM: x86: Introduce allow list for MSR emulation
  - new patch: KVM: selftests: Add test for user space MSR handling

v2 -> v3:

  - return r if r == X86EMUL_IO_NEEDED
  - s/KVM_EXIT_RDMSR/KVM_EXIT_X86_RDMSR/g
  - s/KVM_EXIT_WRMSR/KVM_EXIT_X86_WRMSR/g
  - Use complete_userspace_io logic instead of reply field
  - Simplify trapping code
  - document flags for KVM_X86_ADD_MSR_ALLOWLIST
  - generalize exit path, always unlock when returning
  - s/KVM_CAP_ADD_MSR_ALLOWLIST/KVM_CAP_X86_MSR_ALLOWLIST/g
  - Add KVM_X86_CLEAR_MSR_ALLOWLIST
  - Add test to clear whitelist
  - Adjust to reply-less API
  - Fix asserts
  - Actually trap on MSR_IA32_POWER_CTL writes

v3 -> v4:

  - Mention exit reasons in re-enter mandatory section of API documentation
  - Clear padding bytes
  - Generalize get/set deflect functions
  - Remove redundant pending_user_msr field
  - lock allow check and clearing
  - free bitmaps on clear

v4 -> v5:

  - use srcu 

v5 -> v6:

  - Switch from allow list to filtering API with explicit fallback option
  - Support and test passthrough MSR filtering
  - Check for filter exit reason
  - Add .gitignore
  - send filter change notification
  - change to atomic set_msr_filter ioctl with fallback flag
  - use EPERM for filter blocks
  - add bit for MSR user space deflection
  - check for overflow of BITS_TO_LONGS (thanks Dan Carpenter!)
  - s/int i;/u32 i;/
  - remove overlap check
  - Introduce exit reason mask to allow for future expansion and filtering
  - s/emul_to_vcpu(ctxt)/vcpu/
  - imported patch: KVM: x86: Prepare MSR bitmaps for userspace tracked MSRs
  - new patch: KVM: x86: Add infrastructure for MSR filtering
  - new patch: KVM: x86: SVM: Prevent MSR passthrough when MSR access is denied
  - new patch: KVM: x86: VMX: Prevent MSR passthrough when MSR access is denied

v6 -> v7:

  - s/MAX_POSSIBLE_PASSGHROUGH_MSRS/MAX_POSSIBLE_PASSTHROUGH_MSRS/g
  - Fire #GP without skipping the MSR instruction
  - uapi: Fix padding
  - selftest: trap on KVM_MSR_EXIT_REASON_FILTER as well
  - selftest: fix asserts
  - selftest: add test for invalid msr handling

v7 -> v8:

  - new patch: KVM: x86: Return -ENOENT on unimplemented MSRs
  - Add KVM_MSR_EXIT_REASON_UNKNOWN
  - s/KVM_MSR_ALLOW/KVM_MSR_FILTER/g
  - fix language in documentation
  - introduce KVM_MSR_FILTER_MAX_RANGES
  - adapt KVM_MSR_EXIT_REASON_FILTER value
  - selftest: add KVM_MSR_EXIT_REASON_UNKNOWN handling

Aaron Lewis (1):
  KVM: x86: Prepare MSR bitmaps for userspace tracked MSRs

Alexander Graf (7):
  KVM: x86: Return -ENOENT on unimplemented MSRs
  KVM: x86: Deflect unknown MSR accesses to user space
  KVM: x86: Add infrastructure for MSR filtering
  KVM: x86: SVM: Prevent MSR passthrough when MSR access is denied
  KVM: x86: VMX: Prevent MSR passthrough when MSR access is denied
  KVM: x86: Introduce MSR filtering
  KVM: selftests: Add test for user space MSR handling

 Documentation/virt/kvm/api.rst                | 182 ++++++++++-
 arch/x86/include/asm/kvm_host.h               |  18 ++
 arch/x86/include/uapi/asm/kvm.h               |  20 ++
 arch/x86/kvm/emulate.c                        |  18 +-
 arch/x86/kvm/svm/svm.c                        | 135 ++++++--
 arch/x86/kvm/svm/svm.h                        |   7 +
 arch/x86/kvm/vmx/nested.c                     |   2 +-
 arch/x86/kvm/vmx/vmx.c                        | 303 ++++++++++++------
 arch/x86/kvm/vmx/vmx.h                        |   9 +-
 arch/x86/kvm/x86.c                            | 271 +++++++++++++++-
 arch/x86/kvm/x86.h                            |   1 +
 include/trace/events/kvm.h                    |   2 +-
 include/uapi/linux/kvm.h                      |  18 ++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/user_msr_test.c      | 248 ++++++++++++++
 16 files changed, 1100 insertions(+), 136 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/user_msr_test.c

-- 
2.28.0.394.ge197136389




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



