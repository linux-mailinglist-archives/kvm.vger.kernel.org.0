Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE694487C90
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 19:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbiAGS4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 13:56:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33250 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233121AbiAGSzj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 13:55:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641581739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ms8oamnV9ATtAzyj0HE2k4dLqAn6UNVYQIiTNYGjoYQ=;
        b=WTyUGHpujWosBySJQcr8nXbDRCx+pxbx5nUAvxUGouFOpA9kGMgU6LcmszSPf2X7WZy3sN
        cx6snsgyB1akplgq88Hcg++ZEemhUC5Q7BPgyBCVib73WkTeRXbiiS4QTab4dCPhPFNwj5
        lniA9e+GQnukfpg5Oo+Qd10nmaqe0Ks=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-9mXsQg6TOd6q09GtKhJZKQ-1; Fri, 07 Jan 2022 13:55:33 -0500
X-MC-Unique: 9mXsQg6TOd6q09GtKhJZKQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BFAB10168D1;
        Fri,  7 Jan 2022 18:55:32 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C26378CB2B;
        Fri,  7 Jan 2022 18:55:31 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     guang.zeng@intel.com, jing2.liu@intel.com, kevin.tian@intel.com,
        seanjc@google.com, tglx@linutronix.de, wei.w.wang@intel.com,
        yang.zhong@intel.com
Subject: [PATCH v6 21/21] kvm: x86: Disable interception for IA32_XFD on demand
Date:   Fri,  7 Jan 2022 13:55:12 -0500
Message-Id: <20220107185512.25321-22-pbonzini@redhat.com>
In-Reply-To: <20220107185512.25321-1-pbonzini@redhat.com>
References: <20220107185512.25321-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kevin Tian <kevin.tian@intel.com>

Always intercepting IA32_XFD causes non-negligible overhead when this
register is updated frequently in the guest.

Disable r/w emulation after intercepting the first WRMSR(IA32_XFD)
with a non-zero value.

Disable WRMSR emulation implies that IA32_XFD becomes out-of-sync
with the software states in fpstate and the per-cpu xfd cache. This
leads to two additional changes accordingly:

  - Call fpu_sync_guest_vmexit_xfd_state() after vm-exit to bring
    software states back in-sync with the MSR, before handle_exit_irqoff()
    is called.

  - Always trap #NM once write interception is disabled for IA32_XFD.
    The #NM exception is rare if the guest doesn't use dynamic
    features. Otherwise, there is at most one exception per guest
    task given a dynamic feature.

p.s. We have confirmed that SDM is being revised to say that
when setting IA32_XFD[18] the AMX register state is not guaranteed
to be preserved. This clarification avoids adding mess for a creative
guest which sets IA32_XFD[18]=1 before saving active AMX state to
its own storage.

Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Message-Id: <20220105123532.12586-22-yang.zhong@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/vmx.c          | 24 +++++++++++++++++++-----
 arch/x86/kvm/vmx/vmx.h          |  2 +-
 arch/x86/kvm/x86.c              |  8 ++++++++
 4 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6cbf97a2ebc4..89d1fdb39c46 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -647,6 +647,7 @@ struct kvm_vcpu_arch {
 	u64 smi_count;
 	bool tpr_access_reporting;
 	bool xsaves_enabled;
+	bool xfd_no_write_intercept;
 	u64 ia32_xss;
 	u64 microcode_version;
 	u64 arch_capabilities;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b8b7f5c7b3df..15e30602782b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -162,6 +162,7 @@ static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
 	MSR_FS_BASE,
 	MSR_GS_BASE,
 	MSR_KERNEL_GS_BASE,
+	MSR_IA32_XFD,
 	MSR_IA32_XFD_ERR,
 #endif
 	MSR_IA32_SYSENTER_CS,
@@ -764,10 +765,11 @@ void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
 	}
 
 	/*
-	 * Trap #NM if guest xfd contains a non-zero value so guest XFD_ERR
-	 * can be saved timely.
+	 * Disabling xfd interception indicates that dynamic xfeatures
+	 * might be used in the guest. Always trap #NM in this case
+	 * to save guest xfd_err timely.
 	 */
-	if (vcpu->arch.guest_fpu.fpstate->xfd)
+	if (vcpu->arch.xfd_no_write_intercept)
 		eb |= (1u << NM_VECTOR);
 
 	vmcs_write32(EXCEPTION_BITMAP, eb);
@@ -1978,9 +1980,21 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_XFD:
 		ret = kvm_set_msr_common(vcpu, msr_info);
-		/* Update #NM interception according to guest xfd */
-		if (!ret)
+		/*
+		 * Always intercepting WRMSR could incur non-negligible
+		 * overhead given xfd might be changed frequently in
+		 * guest context switch. Disable write interception
+		 * upon the first write with a non-zero value (indicating
+		 * potential usage on dynamic xfeatures). Also update
+		 * exception bitmap to trap #NM for proper virtualization
+		 * of guest xfd_err.
+		 */
+		if (!ret && data) {
+			vmx_disable_intercept_for_msr(vcpu, MSR_IA32_XFD,
+						      MSR_TYPE_RW);
+			vcpu->arch.xfd_no_write_intercept = true;
 			vmx_update_exception_bitmap(vcpu);
+		}
 		break;
 #endif
 	case MSR_IA32_SYSENTER_CS:
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 69dd2f85abdc..f8fc7441baea 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -349,7 +349,7 @@ struct vcpu_vmx {
 	struct lbr_desc lbr_desc;
 
 	/* Save desired MSR intercept (read: pass-through) state */
-#define MAX_POSSIBLE_PASSTHROUGH_MSRS	14
+#define MAX_POSSIBLE_PASSTHROUGH_MSRS	15
 	struct {
 		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bde18ca657db..60da2331ec32 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10083,6 +10083,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
 
+	/*
+	 * Sync xfd before calling handle_exit_irqoff() which may
+	 * rely on the fact that guest_fpu::xfd is up-to-date (e.g.
+	 * in #NM irqoff handler).
+	 */
+	if (vcpu->arch.xfd_no_write_intercept)
+		fpu_sync_guest_vmexit_xfd_state();
+
 	static_call(kvm_x86_handle_exit_irqoff)(vcpu);
 
 	if (vcpu->arch.guest_fpu.xfd_err)
-- 
2.31.1

