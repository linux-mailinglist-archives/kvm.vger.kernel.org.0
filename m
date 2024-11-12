Return-Path: <kvm+bounces-31569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC26A9C4F9F
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:40:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 320B31F27161
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:40:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1F2F20C00B;
	Tue, 12 Nov 2024 07:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DabZaDXy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C7F20A5FE;
	Tue, 12 Nov 2024 07:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397103; cv=none; b=Z3+UinAD5oq0Jqu/P01Spk/VVjf46GMkpilkArpA26VAIq8T4mTCMdjq8mJ3H4UE9vyC9oRlYHid8N37jC8l9bBI7Vd9GJH8XfUsxWPr6oXb3yPANybVp++u+lT1JjSZ6r/iUheTlBX8yNh7S4KfcN7yKvaxKcMoKPHsNIriOfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397103; c=relaxed/simple;
	bh=LJP5i6H0vrVARHyHyA5b39kA++Huw/2CwDa6XjsgVdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzVAx/7H5YO1iiOTJ+u40DRZp2Q6m/CawUH1Z5MZS/J+/XUGkgxAdYIgoX8OyF86xzl4IUAzL++OkcJXZ217lJ9bTYfgTGPYO/sx2+cjc+Z3Fc4yFIOpZl79r/f9/aruomFS2s+CovlcdKIkr2QkVCBytAfTh0tARqfzSb8PoDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DabZaDXy; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397102; x=1762933102;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LJP5i6H0vrVARHyHyA5b39kA++Huw/2CwDa6XjsgVdQ=;
  b=DabZaDXyFkV7CC1mvIWhfdDo/zVh2wBkDctNcZVww8SUzlRVFNZe8WsF
   UYoPtOQJibX+J+9iSXDqNHRFQh+d7AUZ7wbXgUmo1N7YkWZLa7gJUO0Ew
   pSJqP97ci/jhnvsDeihgx3m3EIy/8RLQRM/6ElpYB1UaNkDLQCMZRWnTx
   Dg0HvCbri63XOypgTtTwAd1nY8+zuV+dEj5SNiZm7+NvvcGZFskQ5V2xS
   3LmRt7f032E4q6GCXZjlep619GorypKO4x+9S9PEWPrInD131r13z3Qqh
   tkrz5Yf0zlpwFUJQNcXSyZ2dRTZNhjumyBIu+3fiOsy72GPV1je4FyVDG
   Q==;
X-CSE-ConnectionGUID: jF4UArfmS7S1geYmbjew1Q==
X-CSE-MsgGUID: dc/yFJ8rR5e2y/8owxcfKw==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="42598658"
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="42598658"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:38:22 -0800
X-CSE-ConnectionGUID: B4UqiyKrQc65YKcJV4DvLA==
X-CSE-MsgGUID: DZR3eZcrQ8Ofxujm9Aj9TQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="110595087"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:38:17 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 06/24] KVM: TDX: Add accessors VMX VMCS helpers
Date: Tue, 12 Nov 2024 15:35:50 +0800
Message-ID: <20241112073551.22070-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241112073327.21979-1-yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX defines SEAMCALL APIs to access TDX control structures corresponding to
the VMX VMCS.  Introduce helper accessors to hide its SEAMCALL ABI details.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
TDX MMU part 2 v2:
-Move inline warning msgs to tdh_vp_rd/wr_failed() (Paolo)

TDX MMU part 2 v1:
 - Update for the wrapper functions for SEAMCALLs. (Sean)
 - Eliminate kvm_mmu_free_private_spt() and open code it.
 - Fix bisectability issues in headers (Kai)
 - Updates from seamcall overhaul (Kai)

v19:
 - deleted unnecessary stub functions,
   tdvps_state_non_arch_check() and tdvps_management_check().
---
 arch/x86/kvm/vmx/tdx.c | 13 +++++++
 arch/x86/kvm/vmx/tdx.h | 88 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 101 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 7fb32d3b1aae..ed4473d0c2cd 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -32,6 +32,19 @@ static enum cpuhp_state tdx_cpuhp_state;
 
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
 
 static u64 tdx_get_supported_attrs(const struct tdx_sys_info_td_conf *td_conf)
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 1b78a7ea988e..727bcf25d731 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -49,6 +49,10 @@ struct vcpu_tdx {
 	enum vcpu_tdx_state state;
 };
 
+void tdh_vp_rd_failed(struct vcpu_tdx *tdx, char *uclass, u32 field, u64 err);
+void tdh_vp_wr_failed(struct vcpu_tdx *tdx, char *uclass, char *op, u32 field,
+		      u64 val, u64 err);
+
 static inline bool is_td(struct kvm *kvm)
 {
 	return kvm->arch.vm_type == KVM_X86_TDX_VM;
@@ -80,6 +84,90 @@ static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 fiel
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
+	err = tdh_vp_rd(tdx->tdvpr_pa, TDVPS_##uclass(field), &data);		\
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
+	err = tdh_vp_wr(tdx->tdvpr_pa, TDVPS_##uclass(field), val,		\
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
+	err = tdh_vp_wr(tdx->tdvpr_pa, TDVPS_##uclass(field), bit, bit);	\
+	if (unlikely(err))							\
+		tdh_vp_wr_failed(tdx, #uclass, " |= ", field, bit, err);	\
+}										\
+static __always_inline void td_##lclass##_clearbit##bits(struct vcpu_tdx *tdx,	\
+							 u32 field, u64 bit)	\
+{										\
+	u64 err;								\
+										\
+	tdvps_##lclass##_check(field, bits);					\
+	err = tdh_vp_wr(tdx->tdvpr_pa, TDVPS_##uclass(field), 0, bit);		\
+	if (unlikely(err))							\
+		tdh_vp_wr_failed(tdx, #uclass, " &= ~", field, bit, err);\
+}
+
+TDX_BUILD_TDVPS_ACCESSORS(16, VMCS, vmcs);
+TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
+TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
 #else
 static inline void tdx_bringup(void) {}
 static inline void tdx_cleanup(void) {}
-- 
2.43.2


