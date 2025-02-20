Return-Path: <kvm+bounces-38742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96526A3E21A
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:19:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECFC9705026
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:10:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE3292185BE;
	Thu, 20 Feb 2025 17:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KWIfDiYQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4489E217713
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740071198; cv=none; b=J/3ts76vVG3Sow4ipBEteW3RnDX4TfpBGRZ0zFzSIzglXLqAxNqEbF9fDQsLGhOfGdgV2kzsB5xXlxm/8suh+lfIWZM+s1uZI+KCwcMq4j2IF3l/5TyH+rMICA4CoLeTxMGKuGE27fDt9pgUyBowRJ6Rj3NulP2FAXLNT5xUOos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740071198; c=relaxed/simple;
	bh=eu50HJKfyrCTMD4ztoEkCZGNty0iOhs0JtUIdC5Ri1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tiD/TROtrzMvOLxe3NklEcUxRgQ2OKbaum1opxR8xTsYHP6ONzBeO98sqgzKRnu/r90pc4phF//lkuAaFBJwj5uwPKlwutK1EkuzE+7tm2j45WznhQG04jI/OSwhsRENDDkjrC2gqL2YhiiOP9r0b2iT34v+WFsgf/ujkpqKp/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KWIfDiYQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740071195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bVGdK/kkfSDfuv7grRfMiXUUF7ivbIYfwlJKDtAOPok=;
	b=KWIfDiYQNumotQeNhykQiK27No7quBgq2Er7N5c+clGnDsd1ZRW2SGzqmk5ZpvsTG3GJZA
	kIPXRJUcxrtMUS+qdJ7j9E9+y7hWAz0wEXxLyDsU6stfG6lBzdqUJWkfdIpxLv/HX0rUgi
	qMysveZkVEDHbwNt172nca7Xt1+P9vE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-481-y8DucBQzNgy_W9jIFAwHYA-1; Thu,
 20 Feb 2025 12:06:31 -0500
X-MC-Unique: y8DucBQzNgy_W9jIFAwHYA-1
X-Mimecast-MFC-AGG-ID: y8DucBQzNgy_W9jIFAwHYA_1740071189
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4FF121800878;
	Thu, 20 Feb 2025 17:06:29 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 052F2180035F;
	Thu, 20 Feb 2025 17:06:27 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Tony Lindgren <tony.lindgren@linux.intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 15/30] KVM: TDX: Define TDX architectural definitions
Date: Thu, 20 Feb 2025 12:05:49 -0500
Message-ID: <20250220170604.2279312-16-pbonzini@redhat.com>
In-Reply-To: <20250220170604.2279312-1-pbonzini@redhat.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Isaku Yamahata <isaku.yamahata@intel.com>

Define architectural definitions for KVM to issue the TDX SEAMCALLs.

Structures and values that are architecturally defined in the TDX module
specifications the chapter of ABI Reference.

Co-developed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 - Drop old duplicate defines, the x86 core exports what's needed (Kai)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx.h      |   2 +
 arch/x86/kvm/vmx/tdx_arch.h | 123 ++++++++++++++++++++++++++++++++++++
 2 files changed, 125 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/tdx_arch.h

diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index fc013c8816f1..4dea6e89fc69 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -2,6 +2,8 @@
 #ifndef __KVM_X86_VMX_TDX_H
 #define __KVM_X86_VMX_TDX_H
 
+#include "tdx_arch.h"
+
 #ifdef CONFIG_INTEL_TDX_HOST
 int tdx_bringup(void);
 void tdx_cleanup(void);
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
new file mode 100644
index 000000000000..fb7abe9fef8e
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -0,0 +1,123 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* architectural constants/data definitions for TDX SEAMCALLs */
+
+#ifndef __KVM_X86_TDX_ARCH_H
+#define __KVM_X86_TDX_ARCH_H
+
+#include <linux/types.h>
+
+/* TDX control structure (TDR/TDCS/TDVPS) field access codes */
+#define TDX_NON_ARCH			BIT_ULL(63)
+#define TDX_CLASS_SHIFT			56
+#define TDX_FIELD_MASK			GENMASK_ULL(31, 0)
+
+#define __BUILD_TDX_FIELD(non_arch, class, field)	\
+	(((non_arch) ? TDX_NON_ARCH : 0) |		\
+	 ((u64)(class) << TDX_CLASS_SHIFT) |		\
+	 ((u64)(field) & TDX_FIELD_MASK))
+
+#define BUILD_TDX_FIELD(class, field)			\
+	__BUILD_TDX_FIELD(false, (class), (field))
+
+#define BUILD_TDX_FIELD_NON_ARCH(class, field)		\
+	__BUILD_TDX_FIELD(true, (class), (field))
+
+
+/* Class code for TD */
+#define TD_CLASS_EXECUTION_CONTROLS	17ULL
+
+/* Class code for TDVPS */
+#define TDVPS_CLASS_VMCS		0ULL
+#define TDVPS_CLASS_GUEST_GPR		16ULL
+#define TDVPS_CLASS_OTHER_GUEST		17ULL
+#define TDVPS_CLASS_MANAGEMENT		32ULL
+
+enum tdx_tdcs_execution_control {
+	TD_TDCS_EXEC_TSC_OFFSET = 10,
+};
+
+/* @field is any of enum tdx_tdcs_execution_control */
+#define TDCS_EXEC(field)		BUILD_TDX_FIELD(TD_CLASS_EXECUTION_CONTROLS, (field))
+
+/* @field is the VMCS field encoding */
+#define TDVPS_VMCS(field)		BUILD_TDX_FIELD(TDVPS_CLASS_VMCS, (field))
+
+/* @field is any of enum tdx_guest_other_state */
+#define TDVPS_STATE(field)		BUILD_TDX_FIELD(TDVPS_CLASS_OTHER_GUEST, (field))
+#define TDVPS_STATE_NON_ARCH(field)	BUILD_TDX_FIELD_NON_ARCH(TDVPS_CLASS_OTHER_GUEST, (field))
+
+/* Management class fields */
+enum tdx_vcpu_guest_management {
+	TD_VCPU_PEND_NMI = 11,
+};
+
+/* @field is any of enum tdx_vcpu_guest_management */
+#define TDVPS_MANAGEMENT(field)		BUILD_TDX_FIELD(TDVPS_CLASS_MANAGEMENT, (field))
+
+#define TDX_EXTENDMR_CHUNKSIZE		256
+
+struct tdx_cpuid_value {
+	u32 eax;
+	u32 ebx;
+	u32 ecx;
+	u32 edx;
+} __packed;
+
+#define TDX_TD_ATTR_DEBUG		BIT_ULL(0)
+#define TDX_TD_ATTR_SEPT_VE_DISABLE	BIT_ULL(28)
+#define TDX_TD_ATTR_PKS			BIT_ULL(30)
+#define TDX_TD_ATTR_KL			BIT_ULL(31)
+#define TDX_TD_ATTR_PERFMON		BIT_ULL(63)
+
+/*
+ * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
+ */
+struct td_params {
+	u64 attributes;
+	u64 xfam;
+	u16 max_vcpus;
+	u8 reserved0[6];
+
+	u64 eptp_controls;
+	u64 config_flags;
+	u16 tsc_frequency;
+	u8  reserved1[38];
+
+	u64 mrconfigid[6];
+	u64 mrowner[6];
+	u64 mrownerconfig[6];
+	u64 reserved2[4];
+
+	union {
+		DECLARE_FLEX_ARRAY(struct tdx_cpuid_value, cpuid_values);
+		u8 reserved3[768];
+	};
+} __packed __aligned(1024);
+
+/*
+ * Guest uses MAX_PA for GPAW when set.
+ * 0: GPA.SHARED bit is GPA[47]
+ * 1: GPA.SHARED bit is GPA[51]
+ */
+#define TDX_CONFIG_FLAGS_MAX_GPAW      BIT_ULL(0)
+
+/*
+ * TDH.VP.ENTER, TDG.VP.VMCALL preserves RBP
+ * 0: RBP can be used for TDG.VP.VMCALL input. RBP is clobbered.
+ * 1: RBP can't be used for TDG.VP.VMCALL input. RBP is preserved.
+ */
+#define TDX_CONFIG_FLAGS_NO_RBP_MOD	BIT_ULL(2)
+
+
+/*
+ * TDX requires the frequency to be defined in units of 25MHz, which is the
+ * frequency of the core crystal clock on TDX-capable platforms, i.e. the TDX
+ * module can only program frequencies that are multiples of 25MHz.  The
+ * frequency must be between 100mhz and 10ghz (inclusive).
+ */
+#define TDX_TSC_KHZ_TO_25MHZ(tsc_in_khz)	((tsc_in_khz) / (25 * 1000))
+#define TDX_TSC_25MHZ_TO_KHZ(tsc_in_25mhz)	((tsc_in_25mhz) * (25 * 1000))
+#define TDX_MIN_TSC_FREQUENCY_KHZ		(100 * 1000)
+#define TDX_MAX_TSC_FREQUENCY_KHZ		(10 * 1000 * 1000)
+
+#endif /* __KVM_X86_TDX_ARCH_H */
-- 
2.43.5



