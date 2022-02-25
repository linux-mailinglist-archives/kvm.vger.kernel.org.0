Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC4B4C40A8
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 09:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238791AbiBYIyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 03:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238814AbiBYIy1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 03:54:27 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1870B22320E;
        Fri, 25 Feb 2022 00:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645779234; x=1677315234;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=uS226ko481dKVKU+nkMhxwjiC1Kg1uHtGTxSWuBb7xs=;
  b=TynXPmLmXwXxjbTcWECvLb4ztIu4U9AbsecKzIFHRROoEsUzU6OStHD1
   pXJozf8Kklb5XTrSsTDOOzCrWv1xou4CSjvD44jFq61EJJmPlXnf6J/Sq
   8LowEwCyjCBpFA+nphdIgK95XZSFzjtpoYqUEgI0VfOmHphi97BnwKe77
   ZwHVE1jimdCpaGfy5FsoxwIiMF62x+IblByWhVY1/zobcmCU7Af/EhL/v
   iY4XLlKyVMtOFnhYb4h+gwm+1Xh3sApKgB8CB3q0xSyV7Di1o799UqDbt
   /nXOzZtWdZRigkjBLF0uaEoqG1WuQp/dHe8erHTwrz36D0JB5otQicnIe
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="252186122"
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="252186122"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 00:53:54 -0800
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="549186594"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 00:53:48 -0800
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
Subject: [PATCH v6 8/9] KVM: x86: Allow userspace set maximum VCPU id for VM
Date:   Fri, 25 Feb 2022 16:22:22 +0800
Message-Id: <20220225082223.18288-9-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220225082223.18288-1-guang.zeng@intel.com>
References: <20220225082223.18288-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce new max_vcpu_id in KVM for x86 architecture. Userspace
can assign maximum possible vcpu id for current VM session using
KVM_CAP_MAX_VCPU_ID of KVM_ENABLE_CAP ioctl().

This is done for x86 only because the sole use case is to guide
memory allocation for PID-pointer table, a structure needed to
enable VMX IPI.

By default, max_vcpu_id set as KVM_MAX_VCPU_IDS.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
No new KVM capability is added to advertise the support of
configurable maximum vCPU ID to user space because max_vcpu_id is
just a hint/commitment to allow KVM to reduce the size of PID-pointer
table. But I am not 100% sure if it is proper to do so.

 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/x86.c              | 11 +++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6dcccb304775..db16aebd946c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1233,6 +1233,12 @@ struct kvm_arch {
 	hpa_t	hv_root_tdp;
 	spinlock_t hv_root_tdp_lock;
 #endif
+	/*
+	 * VM-scope maximum vCPU ID. Used to determine the size of structures
+	 * that increase along with the maximum vCPU ID, in which case, using
+	 * the global KVM_MAX_VCPU_IDS may lead to significant memory waste.
+	 */
+	u32 max_vcpu_id;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4f6fe9974cb5..ca17cc452bd3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5994,6 +5994,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exit_on_emulation_error = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_MAX_VCPU_ID:
+		if (cap->args[0] <= KVM_MAX_VCPU_IDS) {
+			kvm->arch.max_vcpu_id = cap->args[0];
+			r = 0;
+		} else
+			r = -E2BIG;
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -11067,6 +11074,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	struct page *page;
 	int r;
 
+	if (vcpu->vcpu_id >= vcpu->kvm->arch.max_vcpu_id)
+		return -E2BIG;
+
 	vcpu->arch.last_vmentry_cpu = -1;
 	vcpu->arch.regs_avail = ~0;
 	vcpu->arch.regs_dirty = ~0;
@@ -11589,6 +11599,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
 	kvm->arch.hv_root_tdp = INVALID_PAGE;
 #endif
+	kvm->arch.max_vcpu_id = KVM_MAX_VCPU_IDS;
 
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
-- 
2.27.0

