Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD644C40AD
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 09:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238772AbiBYIye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 03:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238758AbiBYIyb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 03:54:31 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F539222193;
        Fri, 25 Feb 2022 00:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645779240; x=1677315240;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=oeVLXWVPJ86PvAjYfho9TLMR4DXscOSnF7oYXF2Q+Ic=;
  b=cMv+RCYj/gEzQQMbUEhUbJpi4wE3OS0EJW/+2SphfT6te2PJrmB77DI0
   fLvn4jK9nPX4D5JMmBmlIEnIlKE3xU4eJLvUROYGXS8nL5Tqcleq9xEYY
   qzAJ8qLHxYUugVkXhMQ2dq7kf+BK0H0zx+JvYp2lyrvCQLxD7F8wEkt+V
   zAfPMpjvsN//wz8IvcTm9p/LyJnyBvw8yC4SONekWJQmQkxgxJhObfzF+
   cqOm5Z0UxbN/H5wyDjq6zUsQ2foK05PV29dxzn4xdYZHJtF1un7V9QxB1
   hO+8ZZwcViBKXmTOF3Nv9C2tP2JzngiqOqw0qxpVt8BRuaHvpDmbAhAud
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="250037416"
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="250037416"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 00:53:59 -0800
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="549186616"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 00:53:54 -0800
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
Subject: [PATCH v6 9/9] KVM: VMX: Optimize memory allocation for PID-pointer table
Date:   Fri, 25 Feb 2022 16:22:23 +0800
Message-Id: <20220225082223.18288-10-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220225082223.18288-1-guang.zeng@intel.com>
References: <20220225082223.18288-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current kvm allocates 8 pages in advance for Posted Interrupt Descriptor
pointer (PID-pointer) table to accommodate vCPUs with APIC ID up to
KVM_MAX_VCPU_IDS - 1. This policy wastes some memory because most of
VMs have less than 512 vCPUs and then just need one page.

If user hypervisor specify max practical vcpu id prior to vCPU creation,
IPIv can allocate only essential memory for PID-pointer table and reduce
the memory footprint of VMs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 45 ++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0cb141c277ef..22bfb4953289 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -230,9 +230,6 @@ static const struct {
 };
 
 #define L1D_CACHE_ORDER 4
-
-/* PID(Posted-Interrupt Descriptor)-pointer table entry is 64-bit long */
-#define MAX_PID_TABLE_ORDER get_order(KVM_MAX_VCPU_IDS * sizeof(u64))
 #define PID_TABLE_ENTRY_VALID 1
 
 static void *vmx_l1d_flush_pages;
@@ -4434,6 +4431,24 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 	return exec_control;
 }
 
+static int vmx_alloc_pid_table(struct kvm_vmx *kvm_vmx)
+{
+	struct page *pages;
+
+	if(kvm_vmx->pid_table)
+		return 0;
+
+	pages = alloc_pages(GFP_KERNEL | __GFP_ZERO,
+			get_order(kvm_vmx->kvm.arch.max_vcpu_id * sizeof(u64)));
+
+	if (!pages)
+		return -ENOMEM;
+
+	kvm_vmx->pid_table = (void *)page_address(pages);
+	kvm_vmx->pid_last_index = kvm_vmx->kvm.arch.max_vcpu_id - 1;
+	return 0;
+}
+
 #define VMX_XSS_EXIT_BITMAP 0
 
 static void init_vmcs(struct vcpu_vmx *vmx)
@@ -7159,6 +7174,16 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 			goto free_vmcs;
 	}
 
+	if (enable_ipiv && kvm_vcpu_apicv_active(vcpu)) {
+		struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
+
+		mutex_lock(&vcpu->kvm->lock);
+		err = vmx_alloc_pid_table(kvm_vmx);
+		mutex_unlock(&vcpu->kvm->lock);
+		if (err)
+			goto free_vmcs;
+	}
+
 	return 0;
 
 free_vmcs:
@@ -7202,17 +7227,6 @@ static int vmx_vm_init(struct kvm *kvm)
 		}
 	}
 
-	if (enable_ipiv) {
-		struct page *pages;
-
-		pages = alloc_pages(GFP_KERNEL | __GFP_ZERO, MAX_PID_TABLE_ORDER);
-		if (!pages)
-			return -ENOMEM;
-
-		to_kvm_vmx(kvm)->pid_table = (void *)page_address(pages);
-		to_kvm_vmx(kvm)->pid_last_index = KVM_MAX_VCPU_IDS - 1;
-	}
-
 	return 0;
 }
 
@@ -7809,7 +7823,8 @@ static void vmx_vm_destroy(struct kvm *kvm)
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
 
 	if (kvm_vmx->pid_table)
-		free_pages((unsigned long)kvm_vmx->pid_table, MAX_PID_TABLE_ORDER);
+		free_pages((unsigned long)kvm_vmx->pid_table,
+			get_order((kvm_vmx->pid_last_index + 1) * sizeof(u64)));
 }
 
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
-- 
2.27.0

