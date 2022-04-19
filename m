Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CC45072CE
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 18:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354533AbiDSQT1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 12:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354537AbiDSQTR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 12:19:17 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797A6396A3;
        Tue, 19 Apr 2022 09:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650384991; x=1681920991;
  h=from:to:cc:subject:date:message-id;
  bh=YlRsC+/41T+2N/ctZZSqpu7aySiqxH12farWrJv1ANM=;
  b=FvGdaR0F7fX3TQygAep10ZKf/pycoddt+ydjl/f6YP6jlO5i4NFaDQjm
   7JKHZbGUS2/OoRSF5sepmbRS/7Jz2pml8xAYqA87aXpEMZwujQUiZXFV+
   KCfXkF2uf35BxyDs+mmY9Sscrw00+iPCB34GsaBDWI7Fz+9XUsYdYzGCR
   6tNBk1JnofLtDeVCKOETqxkW+x6BprMSLsLKN9l4m3QU/Ywyec2gt278i
   pg6EVgqIt19PR8PeT1hBRNGnvKAf/xClLsPQUNmBfFoOV7tCpCSukiOw8
   znxyhCLsiFppB6Ty55kIW6biQOyfZQipkCqj7p8M/Dpzunrx0WrFk+11a
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="243738115"
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="243738115"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 09:16:31 -0700
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="529374957"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 09:16:25 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH v9 8/9] KVM: x86: Allow userspace set maximum VCPU id for VM
Date:   Tue, 19 Apr 2022 23:44:44 +0800
Message-Id: <20220419154444.11888-1-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce new max_vcpu_ids in KVM for x86 architecture. Userspace
can assign maximum possible vcpu id for current VM session using
KVM_CAP_MAX_VCPU_ID of KVM_ENABLE_CAP ioctl().

This is done for x86 only because the sole use case is to guide
memory allocation for PID-pointer table, a structure needed to
enable VMX IPI.

By default, max_vcpu_ids set as KVM_MAX_VCPU_IDS.

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 Documentation/virt/kvm/api.rst  | 18 ++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/x86.c              | 25 ++++++++++++++++++++++++-
 3 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d13fa6600467..0c6ad2d8bea0 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7136,6 +7136,24 @@ The valid bits in cap.args[0] are:
                                     IA32_MISC_ENABLE[bit 18] is cleared.
 =================================== ============================================
 
+7.32 KVM_CAP_MAX_VCPU_ID
+------------------------
+
+:Architectures: x86
+:Target: VM
+:Parameters: args[0] - maximum APIC ID value set for current VM
+:Returns: 0 on success, -EINVAL if args[0] is beyond KVM_MAX_VCPU_IDS
+          supported in KVM or if it has been settled.
+
+Userspace is able to calculate the limit to APIC ID values from designated CPU
+topology. This capability allows userspace to specify maximum possible APIC ID
+assigned for current VM session prior to the creation of vCPUs. By design, it
+can set only once and doesn't accept change any more. KVM will manage memory
+allocation of VM-scope structures which depends on the value of APIC ID.
+
+Calling KVM_CHECK_EXTENSION for this capability returns the value of maximum APIC
+ID that KVM supports at runtime. It sets as KVM_MAX_VCPU_IDS by default.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d23e80a56eb8..cdd14033988d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1238,6 +1238,12 @@ struct kvm_arch {
 	hpa_t	hv_root_tdp;
 	spinlock_t hv_root_tdp_lock;
 #endif
+	/*
+	 * VM-scope maximum vCPU ID. Used to determine the size of structures
+	 * that increase along with the maximum vCPU ID, in which case, using
+	 * the global KVM_MAX_VCPU_IDS may lead to significant memory waste.
+	 */
+	u32 max_vcpu_ids;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 277a0da8c290..744e88a71b63 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4320,7 +4320,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_MAX_VCPUS;
 		break;
 	case KVM_CAP_MAX_VCPU_ID:
-		r = KVM_MAX_VCPU_IDS;
+		if (!kvm->arch.max_vcpu_ids)
+			r = KVM_MAX_VCPU_IDS;
+		else
+			r = kvm->arch.max_vcpu_ids;
 		break;
 	case KVM_CAP_PV_MMU:	/* obsolete */
 		r = 0;
@@ -6064,6 +6067,20 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_MAX_VCPU_ID:
+		r = -EINVAL;
+		if (cap->args[0] > KVM_MAX_VCPU_IDS)
+			break;
+
+		mutex_lock(&kvm->lock);
+		if (kvm->arch.max_vcpu_ids == cap->args[0]) {
+			r = 0;
+		} else if (!kvm->arch.max_vcpu_ids) {
+			kvm->arch.max_vcpu_ids = cap->args[0];
+			r = 0;
+		}
+		mutex_unlock(&kvm->lock);
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -11172,6 +11189,12 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 		pr_warn_once("kvm: SMP vm created on host with unstable TSC; "
 			     "guest TSC will not be reliable\n");
 
+	if (!kvm->arch.max_vcpu_ids)
+		kvm->arch.max_vcpu_ids = KVM_MAX_VCPU_IDS;
+
+	if (id >= kvm->arch.max_vcpu_ids)
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.27.0

