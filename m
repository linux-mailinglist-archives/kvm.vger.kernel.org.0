Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE474CD04A
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 09:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbiCDIkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 03:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235074AbiCDIj7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 03:39:59 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F50E19F450;
        Fri,  4 Mar 2022 00:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646383126; x=1677919126;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=9WPWKdMQOaT9T1cEg177XiXdX47Ve45od60PsvVFF4Y=;
  b=GREnMUR19GFYsIqpkm1OqGp7sCiQefCkSKHVoh1PV0quJlkOpFjP7xEo
   WgW08aq6tE+ai32zN29bs0ZXolaM1rEwwL5wWbBX0QeLYE72Elw4nd9Nv
   KUny9PqzdxGezSkLoMSsdVN6ae/WRrZOVndVeK27lJzRYJI9vM9jLG9wK
   YS9MIGxNOUXiQXZs1sT0fOfO0g6oOBzWGjdoB4mXp4dix2KIS5aqdmtNF
   kq/iZvDRzPX1+KZPrMV9PKrZnOZLqQ3dtaCSi8f1hJnkV9lQYf9/uvBqc
   rO6o3xHvVr6rRiK6jVlZxv7Z03cCfDc2AN2RbwB8kwkiywrPdKmiTQqpp
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="254122218"
X-IronPort-AV: E=Sophos;i="5.90,154,1643702400"; 
   d="scan'208";a="254122218"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 00:38:45 -0800
X-IronPort-AV: E=Sophos;i="5.90,154,1643702400"; 
   d="scan'208";a="552141513"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 00:38:39 -0800
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
Subject: [PATCH v7 7/8] KVM: x86: Allow userspace set maximum VCPU id for VM
Date:   Fri,  4 Mar 2022 16:07:24 +0800
Message-Id: <20220304080725.18135-8-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220304080725.18135-1-guang.zeng@intel.com>
References: <20220304080725.18135-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
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

