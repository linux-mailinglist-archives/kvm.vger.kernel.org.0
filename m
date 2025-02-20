Return-Path: <kvm+bounces-38743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6AFFA3E1ED
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:13:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9322C189DAE2
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50F82218AD7;
	Thu, 20 Feb 2025 17:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="THcp4JvQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46A6217F54
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740071199; cv=none; b=qZQnBQfUxNK2c+NtSST0B+uNt2o0YUdd0Flc+HvUjeJa+VIf/DVmZv+jxDgLKqDL9YqdGBkyTN+f4nDno5VI/KIFDxLYqn6HKB48EJLn1SB6Al+1W8eY5y3qdXbDez+HGIfR686a3X9YI977KSBZ3ZtMpSt1kLUEHq4wkDJ1uPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740071199; c=relaxed/simple;
	bh=Cvk0fLAe+ttKnZPVjmBaJXVNqyzrbCujk7VB45yy+tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QAArIildjoYdXITvwFuL4NgMs0sNDdPrNNRqVZ5URs3W7BWq/f2ye+8hl4f5SqrNLWX4yH8u1C3vA0VQZ+x88/awQTp+Lg8/p1NgmVdRxrSZJmUOp2MJGhEaB1qKWRVn9glWl8/5lXG0NGeLlVG2L/CgZTEV6l3kN1iN87k2sqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=THcp4JvQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740071196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Mkpvq25cFtWQqE53LKozHj77nsCFaTRFqVovN6R0Ro=;
	b=THcp4JvQr9aCmWWlulTZMFtp3af/upDgq8eT5yc424WF7w9FKg1f4SFWCE7vLjgVKirgQl
	9oabY2zBmpOJA51zQhBUv56GVgAcrSygP5IuIY9b+SUL+ELu9XmI82OGQolxNf/S46nLd8
	xwunvL1BldQHvgNQ7fKJ27Ow+j683K0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-101-DlPU8oVjM86JldCoSThOTA-1; Thu,
 20 Feb 2025 12:06:33 -0500
X-MC-Unique: DlPU8oVjM86JldCoSThOTA-1
X-Mimecast-MFC-AGG-ID: DlPU8oVjM86JldCoSThOTA_1740071190
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF0DF1801A15;
	Thu, 20 Feb 2025 17:06:30 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 84E1E180035F;
	Thu, 20 Feb 2025 17:06:29 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Yuan Yao <yuan.yao@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 16/30] KVM: TDX: Add TDX "architectural" error codes
Date: Thu, 20 Feb 2025 12:05:50 -0500
Message-ID: <20250220170604.2279312-17-pbonzini@redhat.com>
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

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add error codes for the TDX SEAMCALLs both for TDX VMM side for TDH
SEAMCALL and TDX guest side for TDG.VP.VMCALL.  KVM issues the TDX
SEAMCALLs and checks its error code.  KVM handles hypercall from the TDX
guest and may return an error.  So error code for the TDX guest is also
needed.

TDX SEAMCALL uses bits 31:0 to return more information, so these error
codes will only exactly match RAX[63:32].  Error codes for TDG.VP.VMCALL is
defined by TDX Guest-Host-Communication interface spec.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <20241030190039.77971-14-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/shared/tdx.h |  7 +++++-
 arch/x86/kvm/vmx/tdx.h            |  1 +
 arch/x86/kvm/vmx/tdx_errno.h      | 36 +++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kvm/vmx/tdx_errno.h

diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index fcbbef484a78..4aedab1f2a1a 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -71,7 +71,12 @@
 #define TDVMCALL_GET_QUOTE		0x10002
 #define TDVMCALL_REPORT_FATAL_ERROR	0x10003
 
-#define TDVMCALL_STATUS_RETRY		1
+/*
+ * TDG.VP.VMCALL Status Codes (returned in R10)
+ */
+#define TDVMCALL_STATUS_SUCCESS		0x0000000000000000ULL
+#define TDVMCALL_STATUS_RETRY		0x0000000000000001ULL
+#define TDVMCALL_STATUS_INVALID_OPERAND	0x8000000000000000ULL
 
 /*
  * Bitmasks of exposed registers (with VMM).
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 4dea6e89fc69..abe77ceddb9f 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -3,6 +3,7 @@
 #define __KVM_X86_VMX_TDX_H
 
 #include "tdx_arch.h"
+#include "tdx_errno.h"
 
 #ifdef CONFIG_INTEL_TDX_HOST
 int tdx_bringup(void);
diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
new file mode 100644
index 000000000000..dc3fa2a58c2c
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* architectural status code for SEAMCALL */
+
+#ifndef __KVM_X86_TDX_ERRNO_H
+#define __KVM_X86_TDX_ERRNO_H
+
+#define TDX_SEAMCALL_STATUS_MASK		0xFFFFFFFF00000000ULL
+
+/*
+ * TDX SEAMCALL Status Codes (returned in RAX)
+ */
+#define TDX_NON_RECOVERABLE_VCPU		0x4000000100000000ULL
+#define TDX_INTERRUPTED_RESUMABLE		0x8000000300000000ULL
+#define TDX_OPERAND_INVALID			0xC000010000000000ULL
+#define TDX_OPERAND_BUSY			0x8000020000000000ULL
+#define TDX_PREVIOUS_TLB_EPOCH_BUSY		0x8000020100000000ULL
+#define TDX_PAGE_METADATA_INCORRECT		0xC000030000000000ULL
+#define TDX_VCPU_NOT_ASSOCIATED			0x8000070200000000ULL
+#define TDX_KEY_GENERATION_FAILED		0x8000080000000000ULL
+#define TDX_KEY_STATE_INCORRECT			0xC000081100000000ULL
+#define TDX_KEY_CONFIGURED			0x0000081500000000ULL
+#define TDX_NO_HKID_READY_TO_WBCACHE		0x0000082100000000ULL
+#define TDX_FLUSHVP_NOT_DONE			0x8000082400000000ULL
+#define TDX_EPT_WALK_FAILED			0xC0000B0000000000ULL
+#define TDX_EPT_ENTRY_STATE_INCORRECT		0xC0000B0D00000000ULL
+
+/*
+ * TDX module operand ID, appears in 31:0 part of error code as
+ * detail information
+ */
+#define TDX_OPERAND_ID_RCX			0x01
+#define TDX_OPERAND_ID_TDR			0x80
+#define TDX_OPERAND_ID_SEPT			0x92
+#define TDX_OPERAND_ID_TD_EPOCH			0xa9
+
+#endif /* __KVM_X86_TDX_ERRNO_H */
-- 
2.43.5



