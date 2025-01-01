Return-Path: <kvm+bounces-34440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 040889FF34E
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 08:34:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 119163A14CA
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 07:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2980219258A;
	Wed,  1 Jan 2025 07:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tk2tpL71"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB1C190049
	for <kvm@vger.kernel.org>; Wed,  1 Jan 2025 07:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735716675; cv=none; b=p3YfDvrq6mtDALyZI+E+6z8I57J4HkBUZSxQ/+wCUyEllmL6BRun8FFnrRawnJgNRXfTN57v2ZPk/N+y5xMXIeEzowHZ0lmQUT7mT1aKvz5NcCHSldaLlYDCTxjwQohi5msGaEfgLidvKGsz49zO2GPaw0dox6cYvQTiFZ18dyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735716675; c=relaxed/simple;
	bh=du0QNeQ7E/PuNdbtbhZa1hL4jaD35sRJAZMZsQMuqNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q1T2jsrwexdFX+WCc+xC389hOPQuA1jDIIu+34A9YcO/Td3Nrs8wGkWlICZStSv/wAk/BVt6Pr+aIYf2ED7mybmYr4nH/xp8j0tCRqveqObwZ3TFisYxJ/Qu5dzEBcSUrJQEthtWy3OLBdLnKbsba48vF5DXAFw1po0+5CVxAWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tk2tpL71; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735716672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ffnt+9olmQvvF82DGWqsFbJ9s1bu/zdt90IVfcQ2uns=;
	b=Tk2tpL71FWphn6x+AAIescRDyLZ36daAiFyzWO7NUz2Q0oals20gcLfRqNrpFhN4KSDT5e
	W9rHM6ld4Z+pxRWZug/Kn9gjww/Wu/+jYaF5xIdmDccle+5YQT4Y66Kvf7heA6fnnHnIF2
	8hmZhdm5FxFFobDVqDsaEO3X06AUfIE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-693-TG6bIsHqPcCrO9Jp3ndw0Q-1; Wed,
 01 Jan 2025 02:31:08 -0500
X-MC-Unique: TG6bIsHqPcCrO9Jp3ndw0Q-1
X-Mimecast-MFC-AGG-ID: TG6bIsHqPcCrO9Jp3ndw0Q
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F6E619560A3;
	Wed,  1 Jan 2025 07:31:07 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 037381956052;
	Wed,  1 Jan 2025 07:31:05 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	yan.y.zhao@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 11/11] x86/virt/tdx: Add SEAMCALL wrappers for TD measurement of initial contents
Date: Wed,  1 Jan 2025 02:30:47 -0500
Message-ID: <20250101073047.402099-12-pbonzini@redhat.com>
In-Reply-To: <20250101073047.402099-1-pbonzini@redhat.com>
References: <20250101073047.402099-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

From: Isaku Yamahata <isaku.yamahata@intel.com>

The TDX module measures the TD during the build process and saves the
measurement in TDCS.MRTD to facilitate TD attestation of the initial
contents of the TD. Wrap the SEAMCALL TDH.MR.EXTEND with tdh_mr_extend()
and TDH.MR.FINALIZE with tdh_mr_finalize() to enable the host kernel to
assist the TDX module in performing the measurement.

The measurement in TDCS.MRTD is a SHA-384 digest of the build process.
SEAMCALLs TDH.MNG.INIT and TDH.MEM.PAGE.ADD initialize and contribute to
the MRTD digest calculation.

The caller of tdh_mr_extend() should break the TD private page into chunks
of size TDX_EXTENDMR_CHUNKSIZE and invoke tdh_mr_extend() to add the page
content into the digest calculation. Failures are possible with
TDH.MR.EXTEND (e.g., due to SEPT walking). The caller of tdh_mr_extend()
can check the function return value and retrieve extended error information
from the function output parameters.

Calling tdh_mr_finalize() completes the measurement. The TDX module then
turns the TD into the runnable state. Further TDH.MEM.PAGE.ADD and
TDH.MR.EXTEND calls will fail.

TDH.MR.FINALIZE may fail due to errors such as the TD having no vCPUs or
contentions. Check function return value when calling tdh_mr_finalize() to
determine the exact reason for failure. Take proper locks on the caller's
side to avoid contention failures, or handle the BUSY error in specific
ways (e.g., retry). Return the SEAMCALL error code directly to the caller.
Do not attempt to handle it in the core kernel.

[Kai: Switched from generic seamcall export]
[Yan: Re-wrote the changelog]
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Message-ID: <20241112073709.22171-1-yan.y.zhao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/virt/vmx/tdx/tdx.c | 27 +++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 3 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 5a38d28a0f7b..337432a61e40 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -138,6 +138,8 @@ u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, hpa_t hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
 u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data);
+u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *rcx, u64 *rdx);
+u64 tdh_mr_finalize(struct tdx_td *td);
 u64 tdh_vp_flush(struct tdx_vp *vp);
 u64 tdh_mng_vpflushdone(struct tdx_td *td);
 u64 tdh_mng_key_freeid(struct tdx_td *td);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 0f202faa0530..1c3347f2f33c 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1618,6 +1618,33 @@ u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_rd);
 
+u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa,
+		.rdx = td->tdr,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_MR_EXTEND, &args);
+
+	*rcx = args.rcx;
+	*rdx = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mr_extend);
+
+u64 tdh_mr_finalize(struct tdx_td *td)
+{
+	struct tdx_module_args args = {
+		.rcx = td->tdr,
+	};
+
+	return seamcall(TDH_MR_FINALIZE, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mr_finalize);
+
 u64 tdh_vp_flush(struct tdx_vp *vp)
 {
 	struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index d49cdd9b0577..a1e34773bab7 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -24,6 +24,8 @@
 #define TDH_MNG_KEY_CONFIG		8
 #define TDH_MNG_CREATE			9
 #define TDH_MNG_RD			11
+#define TDH_MR_EXTEND			16
+#define TDH_MR_FINALIZE			17
 #define TDH_VP_FLUSH			18
 #define TDH_MNG_VPFLUSHDONE		19
 #define TDH_VP_CREATE			10
-- 
2.43.5


