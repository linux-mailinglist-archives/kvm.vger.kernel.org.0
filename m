Return-Path: <kvm+bounces-39371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 70DD8A46B8C
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:58:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 044F116D624
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:58:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5279F2676FA;
	Wed, 26 Feb 2025 19:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZJuxB8g1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB83426658C
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599754; cv=none; b=eoFDY6sONL6T8aN3PekBFmPg6ghFyQOuNvbGeUSPpEkZnPo69cnif7M8lsNjvm2mzS7tRfdC+8T1XLmJXfOESrNHxJPJ1AZtE9hQudIyZgaeiNtycVkIzpCOlJBM6QMkwvQW27rd0UmiHCN3o96wlvzOzYxhOWKEWVEHD9CZUJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599754; c=relaxed/simple;
	bh=TEgDrXOaGNxLHp+ZMToVC5t81PcFu+i/BL72BOcHPtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=feMCCCcAyYH8PQwTWTAERCKH2idFyGkmQC9q3PMq8LxsH2kDcdfHCARVorFi1ZK2j79gj8kfZOn8BiCK4uhiqY/QeJyIZN6/MGvW1X6ebqCrIH6deh5W9WGt/nuajl4gm6PaVN9/j0kuOsxPMbFwPo4womz8geBehIZQYoTjtIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZJuxB8g1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kl/R+UIdUpUSBZ3NVQghzk/4WCvPdLJyhrreIwmEdRo=;
	b=ZJuxB8g1lOxdvcWosklAnao9aUbkjwPPY0KPQ48oQH8VHysnUZWx6hV0wkIB2RlxEQ/cpr
	x0TtyaVcCIHcmAvxknmkrMyGTUoONtG/RuAEb2JqD+EYyyzGNfmKAb5b16dLp4f9ZIRzBk
	OSnSw+l9I/GrbQiZAPic8HYH0dMt0sY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-633-mz7vUJgDPJ2go8CPe0oxZQ-1; Wed,
 26 Feb 2025 14:55:48 -0500
X-MC-Unique: mz7vUJgDPJ2go8CPe0oxZQ-1
X-Mimecast-MFC-AGG-ID: mz7vUJgDPJ2go8CPe0oxZQ_1740599747
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 206761800874;
	Wed, 26 Feb 2025 19:55:47 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2BDB4300019E;
	Wed, 26 Feb 2025 19:55:46 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH 11/29] KVM: TDX: Add accessors VMX VMCS helpers
Date: Wed, 26 Feb 2025 14:55:11 -0500
Message-ID: <20250226195529.2314580-12-pbonzini@redhat.com>
In-Reply-To: <20250226195529.2314580-1-pbonzini@redhat.com>
References: <20250226195529.2314580-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX defines SEAMCALL APIs to access TDX control structures corresponding to
the VMX VMCS.  Introduce helper accessors to hide its SEAMCALL ABI details.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Message-ID: <20241112073551.22070-1-yan.y.zhao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx.c | 13 +++++++
 arch/x86/kvm/vmx/tdx.h | 88 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 101 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d85f74c0a965..3fb5410cecb1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -36,6 +36,19 @@ static enum cpuhp_state tdx_cpuhp_state;
 
 static const struct tdx_sys_info *tdx_sysinfo;
 
+void tdh_vp_rd_failed(struct vcpu_tdx *tdx, char *uclass, u32 field, u64 err)
+{
+	KVM_BUG_ON(1, tdx->vcpu.kvm);
+	pr_err("TDH_VP_RD[%s.0x%x] failed 0x%llx\n", uclass, field, err);
+}
+
+void tdh_vp_wr_failed(struct vcpu_tdx *tdx, char *uclass, char *op, u32 field,
+		      u64 val, u64 err)
+{
+	KVM_BUG_ON(1, tdx->vcpu.kvm);
+	pr_err("TDH_VP_WR[%s.0x%x]%s0x%llx failed: 0x%llx\n", uclass, field, op, val, err);
+}
+
 #define KVM_SUPPORTED_TD_ATTRS (TDX_TD_ATTR_SEPT_VE_DISABLE)
 
 static __always_inline struct kvm_tdx *to_kvm_tdx(struct kvm *kvm)
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 5fea072b4f56..77d693dfcb08 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -47,6 +47,10 @@ struct vcpu_tdx {
 	enum vcpu_tdx_state state;
 };
 
+void tdh_vp_rd_failed(struct vcpu_tdx *tdx, char *uclass, u32 field, u64 err);
+void tdh_vp_wr_failed(struct vcpu_tdx *tdx, char *uclass, char *op, u32 field,
+		      u64 val, u64 err);
+
 static inline bool is_td(struct kvm *kvm)
 {
 	return kvm->arch.vm_type == KVM_X86_TDX_VM;
@@ -68,6 +72,90 @@ static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 fiel
 	}
 	return data;
 }
+
+static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
+{
+#define VMCS_ENC_ACCESS_TYPE_MASK	0x1UL
+#define VMCS_ENC_ACCESS_TYPE_FULL	0x0UL
+#define VMCS_ENC_ACCESS_TYPE_HIGH	0x1UL
+#define VMCS_ENC_ACCESS_TYPE(field)	((field) & VMCS_ENC_ACCESS_TYPE_MASK)
+
+	/* TDX is 64bit only.  HIGH field isn't supported. */
+	BUILD_BUG_ON_MSG(__builtin_constant_p(field) &&
+			 VMCS_ENC_ACCESS_TYPE(field) == VMCS_ENC_ACCESS_TYPE_HIGH,
+			 "Read/Write to TD VMCS *_HIGH fields not supported");
+
+	BUILD_BUG_ON(bits != 16 && bits != 32 && bits != 64);
+
+#define VMCS_ENC_WIDTH_MASK	GENMASK(14, 13)
+#define VMCS_ENC_WIDTH_16BIT	(0UL << 13)
+#define VMCS_ENC_WIDTH_64BIT	(1UL << 13)
+#define VMCS_ENC_WIDTH_32BIT	(2UL << 13)
+#define VMCS_ENC_WIDTH_NATURAL	(3UL << 13)
+#define VMCS_ENC_WIDTH(field)	((field) & VMCS_ENC_WIDTH_MASK)
+
+	/* TDX is 64bit only.  i.e. natural width = 64bit. */
+	BUILD_BUG_ON_MSG(bits != 64 && __builtin_constant_p(field) &&
+			 (VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_64BIT ||
+			  VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_NATURAL),
+			 "Invalid TD VMCS access for 64-bit field");
+	BUILD_BUG_ON_MSG(bits != 32 && __builtin_constant_p(field) &&
+			 VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_32BIT,
+			 "Invalid TD VMCS access for 32-bit field");
+	BUILD_BUG_ON_MSG(bits != 16 && __builtin_constant_p(field) &&
+			 VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_16BIT,
+			 "Invalid TD VMCS access for 16-bit field");
+}
+
+#define TDX_BUILD_TDVPS_ACCESSORS(bits, uclass, lclass)				\
+static __always_inline u##bits td_##lclass##_read##bits(struct vcpu_tdx *tdx,	\
+							u32 field)		\
+{										\
+	u64 err, data;								\
+										\
+	tdvps_##lclass##_check(field, bits);					\
+	err = tdh_vp_rd(&tdx->vp, TDVPS_##uclass(field), &data);		\
+	if (unlikely(err)) {							\
+		tdh_vp_rd_failed(tdx, #uclass, field, err);			\
+		return 0;							\
+	}									\
+	return (u##bits)data;							\
+}										\
+static __always_inline void td_##lclass##_write##bits(struct vcpu_tdx *tdx,	\
+						      u32 field, u##bits val)	\
+{										\
+	u64 err;								\
+										\
+	tdvps_##lclass##_check(field, bits);					\
+	err = tdh_vp_wr(&tdx->vp, TDVPS_##uclass(field), val,			\
+		      GENMASK_ULL(bits - 1, 0));				\
+	if (unlikely(err))							\
+		tdh_vp_wr_failed(tdx, #uclass, " = ", field, (u64)val, err);	\
+}										\
+static __always_inline void td_##lclass##_setbit##bits(struct vcpu_tdx *tdx,	\
+						       u32 field, u64 bit)	\
+{										\
+	u64 err;								\
+										\
+	tdvps_##lclass##_check(field, bits);					\
+	err = tdh_vp_wr(&tdx->vp, TDVPS_##uclass(field), bit, bit);		\
+	if (unlikely(err))							\
+		tdh_vp_wr_failed(tdx, #uclass, " |= ", field, bit, err);	\
+}										\
+static __always_inline void td_##lclass##_clearbit##bits(struct vcpu_tdx *tdx,	\
+							 u32 field, u64 bit)	\
+{										\
+	u64 err;								\
+										\
+	tdvps_##lclass##_check(field, bits);					\
+	err = tdh_vp_wr(&tdx->vp, TDVPS_##uclass(field), 0, bit);		\
+	if (unlikely(err))							\
+		tdh_vp_wr_failed(tdx, #uclass, " &= ~", field, bit, err);\
+}
+
+TDX_BUILD_TDVPS_ACCESSORS(16, VMCS, vmcs);
+TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
+TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
 #else
 static inline int tdx_bringup(void) { return 0; }
 static inline void tdx_cleanup(void) {}
-- 
2.43.5



