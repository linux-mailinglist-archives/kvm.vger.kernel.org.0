Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA064FB7BC
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 11:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344552AbiDKJjl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 05:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344576AbiDKJjg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 05:39:36 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83594403E7;
        Mon, 11 Apr 2022 02:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649669836; x=1681205836;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Ac+Tj+oOHnMDyhI2NE6QYoSazPkEr2C+i7OWolZUv+E=;
  b=DBy/3LuSo6LwUrj+IYYXRksJa1LAi5N/ejBlIYgk+hlobRdPWxAFB4lF
   YM1WD4j/Yt1ZYli7SIAWEtXEhkhq8B1mi3F7iMJj4efUMPIn3eP0L53R1
   OwcndjDjGxEwPl9Cq9/eFwqCHOGP6pidxteXf4sFSGKjKx9Bvrvlhmf9i
   Otjw2yfKNBJGaeKEIGXgSM6EmJuv9bSe1mR87CyNjgylsOPUXx8ncTUVQ
   Vb8EepWUluiz56CnhfCY6Y+SaDvdy9aSyBDLRZ64GNUA3x/ZHC8SNSFPD
   hl3esKEuRQDFCpKI8kbH/8K5gIIGvgUxaAoiTBFkS/2fpcegJdHS765ob
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10313"; a="243960657"
X-IronPort-AV: E=Sophos;i="5.90,251,1643702400"; 
   d="scan'208";a="243960657"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 02:37:15 -0700
X-IronPort-AV: E=Sophos;i="5.90,251,1643702400"; 
   d="scan'208";a="572050604"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 02:37:09 -0700
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
Subject: [PATCH v8 8/9] KVM: x86: Allow userspace set maximum VCPU id for VM
Date:   Mon, 11 Apr 2022 17:04:46 +0800
Message-Id: <20220411090447.5928-9-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220411090447.5928-1-guang.zeng@intel.com>
References: <20220411090447.5928-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
 Documentation/virt/kvm/api.rst  | 17 +++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/x86.c              | 18 +++++++++++++++++-
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d13fa6600467..bb0b0f3edefe 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7136,6 +7136,23 @@ The valid bits in cap.args[0] are:
                                     IA32_MISC_ENABLE[bit 18] is cleared.
 =================================== ============================================
 
+7.32 KVM_CAP_MAX_VCPU_ID
+------------------------
+
+:Architectures: x86
+:Target: VM
+:Parameters: args[0] - maximum APIC ID value set for current VM
+:Returns: 0 on success, -EINVAL if args[0] is beyond KVM_MAX_VCPU_IDS
+          supported in KVM or if vCPU has been created.
+
+Userspace is able to calculate the limit to APIC ID values from designated CPU
+topology. This capability allows userspace to specify maximum possible APIC ID
+assigned for current VM session prior to the creation of vCPUs. KVM can manage
+memory allocation of VM-scope structures which depends on the value of APIC ID.
+
+Calling KVM_CHECK_EXTENSION for this capability returns the value of maximum APIC
+ID that KVM supports at runtime. It sets as KVM_MAX_VCPU_IDS in VM initialization.
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
index 0c0ca599a353..d1a39285deab 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4320,7 +4320,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_MAX_VCPUS;
 		break;
 	case KVM_CAP_MAX_VCPU_ID:
-		r = KVM_MAX_VCPU_IDS;
+		r = kvm->arch.max_vcpu_ids;
 		break;
 	case KVM_CAP_PV_MMU:	/* obsolete */
 		r = 0;
@@ -6064,6 +6064,18 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_MAX_VCPU_ID:
+		r = -EINVAL;
+		if (cap->args[0] > KVM_MAX_VCPU_IDS)
+			break;
+
+		mutex_lock(&kvm->lock);
+		if (!kvm->created_vcpus) {
+			kvm->arch.max_vcpu_ids = cap->args[0];
+			r = 0;
+		}
+		mutex_unlock(&kvm->lock);
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -11180,6 +11192,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	struct page *page;
 	int r;
 
+	if (vcpu->vcpu_id >= vcpu->kvm->arch.max_vcpu_ids)
+		return -EINVAL;
+
 	vcpu->arch.last_vmentry_cpu = -1;
 	vcpu->arch.regs_avail = ~0;
 	vcpu->arch.regs_dirty = ~0;
@@ -11704,6 +11719,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
 	kvm->arch.hv_root_tdp = INVALID_PAGE;
 #endif
+	kvm->arch.max_vcpu_ids = KVM_MAX_VCPU_IDS;
 
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
-- 
2.27.0

