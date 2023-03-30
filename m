Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A546D0A55
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 17:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbjC3PuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 11:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbjC3Pt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 11:49:58 -0400
Received: from out-33.mta1.migadu.com (out-33.mta1.migadu.com [IPv6:2001:41d0:203:375::21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2026C93F9
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 08:49:29 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680191367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=S43Pe8iMSCovNQhtr5HCK0Bk1fVcHN0kK8YtF9JG7fY=;
        b=xU2FVl4GG6WCimXhdnbpDW7aHHhd8JB5mMunB9VmwfryzVLBdBsZLGd756rwcj/pu2UMHw
        rCNQUVb8NHPBRLEpWus9pB8nbWvWrtQg2zKv8i5i6z5AgCcgjdy67S+xdFjBhXjmdJiId4
        GcNZmS8quDPEZLLadi49Lp3Vzv7GpLc=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 00/13] KVM: arm64: Userspace SMCCC call filtering
Date:   Thu, 30 Mar 2023 15:49:05 +0000
Message-Id: <20230330154918.4014761-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Arm SMCCC is rather prescriptive in regards to the allocation of
SMCCC function ID ranges. Many of the hypercall ranges have an
associated specification from Arm (FF-A, PSCI, SDEI, etc.) with some
room for vendor-specific implementations.

The ever-expanding SMCCC surface leaves a lot of work within KVM for
providing new features. Furthermore, KVM implements its own
vendor-specific ABI, with little room for other implementations (like
Hyper-V, for example). Rather than cramming it all into the kernel we
should provide a way for userspace to handle hypercalls.

It would appear that vCPU hotplug [*] has a legitimate use case for
something like this, sending PSCI calls to userspace (where they
should have gone in the first place).

[*] https://lore.kernel.org/kvmarm/20230203135043.409192-1-james.morse@arm.com/

=> We have these new hypercall bitmap registers, why not use that?

The hypercall bitmap registers aren't necessarily aimed at the same
problem. The bitmap registers allow a VMM to preserve the ABI the guest
gets from KVM by default when migrating between hosts. By default KVM
exposes the entire feature set to the guest, whereas user SMCCC calls
need explicit opt-in from userspace.

Applies to 6.3-rc3. Note that the kvm->lock is used in this series to
guard the SMCCC filter and should be converted to use
kvm->arch.config_lock when that is available. Marc, you can find my
conflict resolution below between these two series, and I've also pushed
the result to:

  git://git.kernel.org/pub/scm/linux/kernel/git/oupton/linux.git kvm-arm64/for-6.4

  Presumptive, I know! :)

v1: https://lore.kernel.org/kvmarm/20230320221002.4191007-1-oliver.upton@linux.dev/

v1 -> v2:
 - Only set bit 0 for longmode, requiring the remaining lower 31 bits be
   0 (Sean)
 - Let errors from kvm_smccc_call_handler() reach userspace (Suzuki)
 - Use the kvm_vm_has_ran_once() helper in the hypercall bitmap register
   handlers
 - Collect Suzuki's R-bs (thanks!)

Oliver Upton (13):
  KVM: x86: Redefine 'longmode' as a flag for KVM_EXIT_HYPERCALL
  KVM: arm64: Add a helper to check if a VM has ran once
  KVM: arm64: Add vm fd device attribute accessors
  KVM: arm64: Rename SMC/HVC call handler to reflect reality
  KVM: arm64: Start handling SMCs from EL1
  KVM: arm64: Refactor hvc filtering to support different actions
  KVM: arm64: Use a maple tree to represent the SMCCC filter
  KVM: arm64: Add support for KVM_EXIT_HYPERCALL
  KVM: arm64: Indroduce support for userspace SMCCC filtering
  KVM: arm64: Return NOT_SUPPORTED to guest for unknown PSCI version
  KVM: arm64: Let errors from SMCCC emulation to reach userspace
  KVM: selftests: Add a helper for SMCCC calls with SMC instruction
  KVM: selftests: Add test for SMCCC filter

 Documentation/virt/kvm/api.rst                |  25 ++-
 Documentation/virt/kvm/devices/vm.rst         |  76 +++++++
 arch/arm64/include/asm/kvm_host.h             |   8 +-
 arch/arm64/include/uapi/asm/kvm.h             |  24 +++
 arch/arm64/kvm/arm.c                          |  35 ++++
 arch/arm64/kvm/handle_exit.c                  |  36 ++--
 arch/arm64/kvm/hypercalls.c                   | 156 +++++++++++++-
 arch/arm64/kvm/pmu-emul.c                     |   4 +-
 arch/arm64/kvm/psci.c                         |   7 +-
 arch/x86/include/asm/kvm_host.h               |   7 +
 arch/x86/include/uapi/asm/kvm.h               |   3 +
 arch/x86/kvm/x86.c                            |   6 +-
 include/kvm/arm_hypercalls.h                  |   6 +-
 include/uapi/linux/kvm.h                      |   9 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/smccc_filter.c      | 196 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |  13 ++
 .../selftests/kvm/lib/aarch64/processor.c     |  52 +++--
 18 files changed, 601 insertions(+), 63 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/smccc_filter.c


base-commit: e8d018dd0257f744ca50a729e3d042cf2ec9da65

diff --cc arch/arm64/kvm/pmu-emul.c
index 82991d89c2ea,a0fc569fdbca..000000000000
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@@ -959,8 -961,12 +959,8 @@@ int kvm_arm_pmu_v3_set_attr(struct kvm_
  		     filter.action != KVM_PMU_EVENT_DENY))
  			return -EINVAL;
  
- 		if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags))
 -		mutex_lock(&kvm->lock);
 -
 -		if (kvm_vm_has_ran_once(kvm)) {
 -			mutex_unlock(&kvm->lock);
++		if (kvm_vm_has_ran_once(kvm))
  			return -EBUSY;
 -		}
  
  		if (!kvm->arch.pmu_filter) {
  			kvm->arch.pmu_filter = bitmap_alloc(nr_events, GFP_KERNEL_ACCOUNT);
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 28842b9d6c27..9ebfe8457299 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -154,7 +154,7 @@ static int kvm_smccc_set_filter(struct kvm *kvm, struct kvm_smccc_filter __user
 	if (copy_from_user(&filter, uaddr, sizeof(filter)))
 		return -EFAULT;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.config_lock);
 
 	if (kvm_vm_has_ran_once(kvm)) {
 		r = -EBUSY;
@@ -177,7 +177,7 @@ static int kvm_smccc_set_filter(struct kvm *kvm, struct kvm_smccc_filter __user
 	set_bit(KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED, &kvm->arch.flags);
 
 out_unlock:
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.config_lock);
 	return r;
 }
 

-- 
2.40.0.348.gf938b09366-goog
