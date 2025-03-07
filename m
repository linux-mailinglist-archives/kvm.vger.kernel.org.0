Return-Path: <kvm+bounces-40438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A09B9A5737A
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:22:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E34EF1899032
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:22:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA2C9259CB4;
	Fri,  7 Mar 2025 21:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fi9CPsiD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490932586CE
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 21:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741382469; cv=none; b=a4uMPpXnQvfqaKxPm7GIts3RAWPFnAxI9+TfC3sBE27FWwFOzgVqXBQ2Fkl3+vmaf1b4oNVuXM39kCN/uaiLTsV6W1td2fC0LktU2qmVy+gCmZ+1+LbznX2Q1LXdcT6g7hq+AiDNGdZtRX6jFH1tSI8RBVDawKs14PYdKfrZTdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741382469; c=relaxed/simple;
	bh=qpkacy2Jzwwy0gJXtu8/qM/Tqfg9A3oH3LarWUk4h4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VAaV00SyDr5hcBbEzW9EAydAfg+f1jML4l4OXE/gKtNE1E/RF/Tc/5IW4kRAvMDG1wgU2rJhvmapLm5wZrD0NiehK5O7kxrVJSd3TaqbTAgPNsbKL7XND7NYtS3bDOyau9IAAu6ytjGvQElkWYzPlEUIR2jYoYufMhqiHacpRS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fi9CPsiD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741382466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qMRvNmsJozgcBHdIoIX4JxtznEgCRMVe2eMdkTftQ0E=;
	b=fi9CPsiDCBRnrC1JxL1XhIAtDjFDXlxjkNXDDt+emclrpzhslkvbp6yN/pqGK/OW02VcRP
	Zxxa6G5AWl+vRFDkbRHPHXsp6Fl5/eEbPDSsRtyZ62m0exw5Vn1tIvKrAIVAvt5IXOPR+l
	ciT3WHmRkr7CLEyoBLKZHaMjxZ8zvZo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-643-AcKpgo1vPHm3r1HK7dXD7Q-1; Fri,
 07 Mar 2025 16:21:03 -0500
X-MC-Unique: AcKpgo1vPHm3r1HK7dXD7Q-1
X-Mimecast-MFC-AGG-ID: AcKpgo1vPHm3r1HK7dXD7Q_1741382461
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A7E8319560B2;
	Fri,  7 Mar 2025 21:21:01 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 86AD61956095;
	Fri,  7 Mar 2025 21:21:00 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: xiaoyao.li@intel.com,
	adrian.hunter@intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v3 04/10] KVM: TDX: vcpu_run: save/restore host state(host kernel gs)
Date: Fri,  7 Mar 2025 16:20:46 -0500
Message-ID: <20250307212053.2948340-5-pbonzini@redhat.com>
In-Reply-To: <20250307212053.2948340-1-pbonzini@redhat.com>
References: <20250307212053.2948340-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

From: Isaku Yamahata <isaku.yamahata@intel.com>

On entering/exiting TDX vcpu, preserved or clobbered CPU state is different
from the VMX case. Add TDX hooks to save/restore host/guest CPU state.
Save/restore kernel GS base MSR.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20250129095902.16391-7-adrian.hunter@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/main.c    | 24 +++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.c     | 40 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  4 ++++
 3 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 037590fc05e9..c0497ed0c9be 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -145,6 +145,26 @@ static void vt_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 	vmx_update_cpu_dirty_logging(vcpu);
 }
 
+static void vt_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_prepare_switch_to_guest(vcpu);
+		return;
+	}
+
+	vmx_prepare_switch_to_guest(vcpu);
+}
+
+static void vt_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_vcpu_put(vcpu);
+		return;
+	}
+
+	vmx_vcpu_put(vcpu);
+}
+
 static int vt_vcpu_pre_run(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu))
@@ -265,9 +285,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vcpu_free = vt_vcpu_free,
 	.vcpu_reset = vt_vcpu_reset,
 
-	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
+	.prepare_switch_to_guest = vt_prepare_switch_to_guest,
 	.vcpu_load = vt_vcpu_load,
-	.vcpu_put = vmx_vcpu_put,
+	.vcpu_put = vt_vcpu_put,
 
 	.update_exception_bitmap = vmx_update_exception_bitmap,
 	.get_feature_msr = vmx_get_feature_msr,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f50565f45b6a..94e08fdcb775 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3,6 +3,7 @@
 #include <linux/cpu.h>
 #include <asm/cpufeature.h>
 #include <linux/misc_cgroup.h>
+#include <linux/mmu_context.h>
 #include <asm/tdx.h>
 #include "capabilities.h"
 #include "mmu.h"
@@ -12,6 +13,7 @@
 #include "vmx.h"
 #include "mmu/spte.h"
 #include "common.h"
+#include "posted_intr.h"
 #include <trace/events/kvm.h>
 #include "trace.h"
 
@@ -624,6 +626,44 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	local_irq_enable();
 }
 
+/*
+ * Compared to vmx_prepare_switch_to_guest(), there is not much to do
+ * as SEAMCALL/SEAMRET calls take care of most of save and restore.
+ */
+void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vt *vt = to_vt(vcpu);
+
+	if (vt->guest_state_loaded)
+		return;
+
+	if (likely(is_64bit_mm(current->mm)))
+		vt->msr_host_kernel_gs_base = current->thread.gsbase;
+	else
+		vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
+
+	vt->guest_state_loaded = true;
+}
+
+static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vt *vt = to_vt(vcpu);
+
+	if (!vt->guest_state_loaded)
+		return;
+
+	++vcpu->stat.host_state_reload;
+	wrmsrl(MSR_KERNEL_GS_BASE, vt->msr_host_kernel_gs_base);
+
+	vt->guest_state_loaded = false;
+}
+
+void tdx_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	vmx_vcpu_pi_put(vcpu);
+	tdx_prepare_switch_to_host(vcpu);
+}
+
 void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 578c26d3aec4..cd18e9b1e124 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -133,6 +133,8 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu);
 fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit);
+void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
+void tdx_vcpu_put(struct kvm_vcpu *vcpu);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
@@ -164,6 +166,8 @@ static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediat
 {
 	return EXIT_FASTPATH_NONE;
 }
+static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
+static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
-- 
2.43.5



