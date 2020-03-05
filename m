Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47E3817AE46
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 19:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgCEShn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 13:37:43 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39383 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727005AbgCEShi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Mar 2020 13:37:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583433456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xfb+Soh2A345soHe2wUP+VAGGLoLquQzD+xTt+DA2Nw=;
        b=LQDw2YpPEeeiOD4M0hd8goh6ZvrhzzZqObKwi8o6a4ObfjFY8B1JS3wsjgThyXW+xHAI1w
        3AYPTDb0/omBTBhNZiAhIgdGUdubtJ/uF4pB4g/jKFHZK5MBtscp+ZkEt8Zv2CV7KQmk57
        txbrP8uhQb23XeslKjj19RZb93fDXl8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-fJMa8QqRNFCFX5g89rMNZA-1; Thu, 05 Mar 2020 13:37:34 -0500
X-MC-Unique: fJMa8QqRNFCFX5g89rMNZA-1
Received: by mail-wm1-f70.google.com with SMTP id y7so2414723wmd.4
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 10:37:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xfb+Soh2A345soHe2wUP+VAGGLoLquQzD+xTt+DA2Nw=;
        b=l4BG0zJE7KorEdFoYsjYViCK81zyyXc/RcwikJeNRqgKMX6tMUBW8xkAbt+tjUVyWZ
         8nqkgrQLCuCQPmJshJpvKBHyun0og9VgCPIFyJHxqjfBSvioKvXTgF6Y1rsIlWMMd9MY
         wAHpO+QHZCDCcDZepE4WKTaLl9BQxWhBzSKOoue+dkoasYbaN4w4ZZZnjOHcHt3wZWS6
         IJHs8QrZJLJa9aWelT3CvUqdjK7voAl/xB46BxeJS9gUOc7DmJ68NHUeiV7x0BNzIJkf
         XaQvA05IeIhzWo0XkyFf2+jUeXEtDH/szThIafnz7dnKGUBpbGKfWfDsbaCIg0z5m/Q8
         DM8Q==
X-Gm-Message-State: ANhLgQ0HBu5m3bdpzy4ygJk8vi77J2lfUxPeiefY/0M83zUP36pBuzk0
        AHADv/kVnCMGNo8a7rnOF4K0p4BBhgttyfR//In0sJrnBJ/3J26vhE56EAd1bqThP9/AJwREJQN
        SGqNF3OESAXFW
X-Received: by 2002:a5d:49c5:: with SMTP id t5mr287915wrs.154.1583433453487;
        Thu, 05 Mar 2020 10:37:33 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuQ2QHCqVf+xa7VZrF0noYQ9aS405u86qPMgcOqSRhpc33vMZ/QkXSho/1PdQYGhzfZ8ToXUw==
X-Received: by 2002:a5d:49c5:: with SMTP id t5mr287895wrs.154.1583433453240;
        Thu, 05 Mar 2020 10:37:33 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u17sm9369121wmj.47.2020.03.05.10.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 10:37:32 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] KVM: VMX: untangle VMXON revision_id setting when using eVMCS
Date:   Thu,  5 Mar 2020 19:37:25 +0100
Message-Id: <20200305183725.28872-3-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305183725.28872-1-vkuznets@redhat.com>
References: <20200305183725.28872-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As stated in alloc_vmxon_regions(), VMXON region needs to be tagged with
revision id from MSR_IA32_VMX_BASIC even in case of eVMCS. The logic to
do so is not very straightforward: first, we set
hdr.revision_id = KVM_EVMCS_VERSION in alloc_vmcs_cpu() just to reset it
back to vmcs_config.revision_id in alloc_vmxon_regions(). Simplify this by
introducing 'enum vmcs_type' parameter to alloc_vmcs_cpu().

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 32 ++++++++++++++------------------
 arch/x86/kvm/vmx/vmx.h | 12 +++++++++---
 2 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dab19e4e5f2b..697be8823576 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2554,7 +2554,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	return 0;
 }
 
-struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
+struct vmcs *alloc_vmcs_cpu(enum vmcs_type type, int cpu, gfp_t flags)
 {
 	int node = cpu_to_node(cpu);
 	struct page *pages;
@@ -2566,13 +2566,21 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
 	vmcs = page_address(pages);
 	memset(vmcs, 0, vmcs_config.size);
 
-	/* KVM supports Enlightened VMCS v1 only */
-	if (static_branch_unlikely(&enable_evmcs))
+	/*
+	 * When eVMCS is enabled, vmcs->revision_id needs to be set to the
+	 * supported eVMCS version (KVM_EVMCS_VERSION) instead of revision_id
+	 * reported by MSR_IA32_VMX_BASIC.
+	 *
+	 * However, even though not explicitly documented by TLFS, VMXArea
+	 * passed as VMXON argument should still be marked with revision_id
+	 * reported by physical CPU.
+	 */
+	if (type != VMXON_REGION && static_branch_unlikely(&enable_evmcs))
 		vmcs->hdr.revision_id = KVM_EVMCS_VERSION;
 	else
 		vmcs->hdr.revision_id = vmcs_config.revision_id;
 
-	if (shadow)
+	if (type == SHADOW_VMCS_REGION)
 		vmcs->hdr.shadow_vmcs = 1;
 	return vmcs;
 }
@@ -2652,25 +2660,13 @@ static __init int alloc_vmxon_regions(void)
 	for_each_possible_cpu(cpu) {
 		struct vmcs *vmcs;
 
-		vmcs = alloc_vmcs_cpu(false, cpu, GFP_KERNEL);
+		/* The VMXON region is really just a special type of VMCS. */
+		vmcs = alloc_vmcs_cpu(VMXON_REGION, cpu, GFP_KERNEL);
 		if (!vmcs) {
 			free_vmxon_regions();
 			return -ENOMEM;
 		}
 
-		/*
-		 * When eVMCS is enabled, alloc_vmcs_cpu() sets
-		 * vmcs->revision_id to KVM_EVMCS_VERSION instead of
-		 * revision_id reported by MSR_IA32_VMX_BASIC.
-		 *
-		 * However, even though not explicitly documented by
-		 * TLFS, VMXArea passed as VMXON argument should
-		 * still be marked with revision_id reported by
-		 * physical CPU.
-		 */
-		if (static_branch_unlikely(&enable_evmcs))
-			vmcs->hdr.revision_id = vmcs_config.revision_id;
-
 		per_cpu(vmxarea, cpu) = vmcs;
 	}
 	return 0;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e64da06c7009..4c327030bb9c 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -489,7 +489,13 @@ static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 	return &(to_vmx(vcpu)->pi_desc);
 }
 
-struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags);
+enum vmcs_type {
+	VMXON_REGION,
+	VMCS_REGION,
+	SHADOW_VMCS_REGION,
+};
+
+struct vmcs *alloc_vmcs_cpu(enum vmcs_type type, int cpu, gfp_t flags);
 void free_vmcs(struct vmcs *vmcs);
 int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
 void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
@@ -498,8 +504,8 @@ void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs);
 
 static inline struct vmcs *alloc_vmcs(bool shadow)
 {
-	return alloc_vmcs_cpu(shadow, raw_smp_processor_id(),
-			      GFP_KERNEL_ACCOUNT);
+	return alloc_vmcs_cpu(shadow ? SHADOW_VMCS_REGION : VMCS_REGION,
+			      raw_smp_processor_id(), GFP_KERNEL_ACCOUNT);
 }
 
 u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa);
-- 
2.24.1

