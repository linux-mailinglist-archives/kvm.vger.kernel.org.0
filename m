Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF916D67B0
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 17:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235918AbjDDPlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 11:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235925AbjDDPld (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 11:41:33 -0400
Received: from out-37.mta0.migadu.com (out-37.mta0.migadu.com [IPv6:2001:41d0:1004:224b::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191915BA9
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 08:41:09 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680622866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MSEtqrGwi5Kv11LtxCbSZb41cR3IYNHEwzVl0YQk5Ik=;
        b=CAOQXI0dkdw7UE9LHMrg57LGGBP2aqltZFaN/pWm66GGqrA+GkY0X3Dl1m0nurZrSKRfVI
        JRZ45pVMYuKttU5F7WVHgniXonCppE125yA2iJctUatSsqUIGsA+sD7wGZQbTXlHSevumw
        tZwjlbV8Ps91OeLPLQs62uojMAeBsZc=
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
Subject: [PATCH v3 00/13] KVM: arm64: Userspace SMCCC call filtering
Date:   Tue,  4 Apr 2023 15:40:37 +0000
Message-Id: <20230404154050.2270077-1-oliver.upton@linux.dev>
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
v2: https://lore.kernel.org/kvmarm/20230330154918.4014761-1-oliver.upton@linux.dev/

v2 -> v3:
 - Collect Sean's Ack (thanks!)
 - s/ALLOW/HANDLE/g (Marc)
 - Test that the padding is zero (Marc)
 - Doc fixes, typos, etc. (Marc)
 - Test that the filter range has not overflowed

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
  KVM: arm64: Introduce support for userspace SMCCC filtering
  KVM: arm64: Return NOT_SUPPORTED to guest for unknown PSCI version
  KVM: arm64: Let errors from SMCCC emulation to reach userspace
  KVM: selftests: Add a helper for SMCCC calls with SMC instruction
  KVM: selftests: Add test for SMCCC filter

 Documentation/virt/kvm/api.rst                |  25 +-
 Documentation/virt/kvm/devices/vm.rst         |  79 ++++++
 arch/arm64/include/asm/kvm_host.h             |   8 +-
 arch/arm64/include/uapi/asm/kvm.h             |  24 ++
 arch/arm64/kvm/arm.c                          |  35 +++
 arch/arm64/kvm/handle_exit.c                  |  36 +--
 arch/arm64/kvm/hypercalls.c                   | 164 ++++++++++-
 arch/arm64/kvm/pmu-emul.c                     |   4 +-
 arch/arm64/kvm/psci.c                         |   7 +-
 arch/x86/include/asm/kvm_host.h               |   7 +
 arch/x86/include/uapi/asm/kvm.h               |   3 +
 arch/x86/kvm/x86.c                            |   6 +-
 include/kvm/arm_hypercalls.h                  |   6 +-
 include/uapi/linux/kvm.h                      |   9 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/smccc_filter.c      | 260 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |  13 +
 .../selftests/kvm/lib/aarch64/processor.c     |  52 ++--
 18 files changed, 676 insertions(+), 63 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/smccc_filter.c


base-commit: e8d018dd0257f744ca50a729e3d042cf2ec9da65

diff --cc arch/arm64/include/asm/kvm_host.h
index a8e2c52b44aa,2682b3fd0881..000000000000
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@@ -224,11 -222,8 +225,12 @@@ struct kvm_arch 
  #define KVM_ARCH_FLAG_EL1_32BIT				4
  	/* PSCI SYSTEM_SUSPEND enabled for the guest */
  #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED		5
 +	/* VM counter offset */
 +#define KVM_ARCH_FLAG_VM_COUNTER_OFFSET			6
 +	/* Timer PPIs made immutable */
 +#define KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE		7
- 
+ 	/* SMCCC filter initialized for the VM */
 -#define KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED		6
++#define KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED		8
  	unsigned long flags;
  
  	/*
diff --cc arch/arm64/kvm/arm.c
index 0e5a3ff8cc5a,efee032c9560..000000000000
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@@ -1513,13 -1502,18 +1536,25 @@@ long kvm_arch_vm_ioctl(struct file *fil
  			return -EFAULT;
  		return kvm_vm_ioctl_mte_copy_tags(kvm, &copy_tags);
  	}
 +	case KVM_ARM_SET_COUNTER_OFFSET: {
 +		struct kvm_arm_counter_offset offset;
 +
 +		if (copy_from_user(&offset, argp, sizeof(offset)))
 +			return -EFAULT;
 +		return kvm_vm_ioctl_set_counter_offset(kvm, &offset);
 +	}
+ 	case KVM_HAS_DEVICE_ATTR: {
+ 		if (copy_from_user(&attr, argp, sizeof(attr)))
+ 			return -EFAULT;
+ 
+ 		return kvm_vm_has_attr(kvm, &attr);
+ 	}
+ 	case KVM_SET_DEVICE_ATTR: {
+ 		if (copy_from_user(&attr, argp, sizeof(attr)))
+ 			return -EFAULT;
+ 
+ 		return kvm_vm_set_attr(kvm, &attr);
+ 	}
  	default:
  		return -EINVAL;
  	}
diff --cc arch/arm64/kvm/pmu-emul.c
index 240168416838,a0fc569fdbca..000000000000
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@@ -958,8 -961,12 +958,8 @@@ int kvm_arm_pmu_v3_set_attr(struct kvm_
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
index ba1adc68d695..22938e4d947c 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -164,7 +164,7 @@ static int kvm_smccc_set_filter(struct kvm *kvm, struct kvm_smccc_filter __user
 	if (end < start || filter.action >= NR_SMCCC_FILTER_ACTIONS)
 		return -EINVAL;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.config_lock);
 
 	if (kvm_vm_has_ran_once(kvm)) {
 		r = -EBUSY;
@@ -179,7 +179,7 @@ static int kvm_smccc_set_filter(struct kvm *kvm, struct kvm_smccc_filter __user
 	set_bit(KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED, &kvm->arch.flags);
 
 out_unlock:
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.config_lock);
 	return r;
 }
 

-- 
2.40.0.348.gf938b09366-goog

