Return-Path: <kvm+bounces-39367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 547FEA46B81
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:57:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3984188BD88
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E898425EF94;
	Wed, 26 Feb 2025 19:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FZMOkb7K"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E03925C6E2
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599748; cv=none; b=Zkh4DYv2UDDtlpqYcI5ze48/4xXxZhBNlEVLF4utmOCtMZjJ3Tugppgaz8Bu3bzacTKVHG/dplcbLYyd2Cq7FtJ3c3DL4pwOTTc8CDP4HXb0+Y09WgQFygfHEnAWJKRZRHF+fUeuoLXE+f22y0X6F+KOhoM3HvwX/Ci+Sb4RmDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599748; c=relaxed/simple;
	bh=tuCDezGkGZKes6SNps7SpkW0sxeyUG6wKmTBxPiKhQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PuFCA0lixPisLvRSazTg2ht+ZF9cV3CGD/2t3eWwdfsj2sSTAGDDxWzBEs41IHRSMPNFDmqk4g40q4ktrnlBeXXarPX/E6igft7skatXqYw8G28kxa3rMpECO/PGBMdRUTOvz/ZhrsXTjSjFQFHM89MdBCgyq4BXoQRXChnZ+is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FZMOkb7K; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rupr9p/wgo3RuMUrJOLANvVCzCd0tb9n2/MMkqBhlGA=;
	b=FZMOkb7Ktg8EQMyIbc5Z5EwbLpY0H1z5LRboxB/kNGoYtzzFqD9d5xeoUN+Avzxn3BSFKr
	icQ4j5ZApNTCJKyRqFB/8xjzz90R9a/onlHN4/zTMu/cxdIlQDOk5vd5x+wfZGy3vPz9tn
	Mwvv8JsQrXtl8bg/xoSMHqWRZ6KWNpg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-382-AzmdJ06uPZSlS6n2cqWU1A-1; Wed,
 26 Feb 2025 14:55:40 -0500
X-MC-Unique: AzmdJ06uPZSlS6n2cqWU1A-1
X-Mimecast-MFC-AGG-ID: AzmdJ06uPZSlS6n2cqWU1A_1740599739
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 12F2119560B5;
	Wed, 26 Feb 2025 19:55:39 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BD8D51944D02;
	Wed, 26 Feb 2025 19:55:37 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 05/29] x86/virt/tdx: Add SEAMCALL wrappers for TD measurement of initial contents
Date: Wed, 26 Feb 2025 14:55:05 -0500
Message-ID: <20250226195529.2314580-6-pbonzini@redhat.com>
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
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/virt/vmx/tdx/tdx.c | 27 +++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 3 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 28d25d1bfa96..c0841fc87fa8 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -174,6 +174,8 @@ u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
 u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data);
+u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *ext_err1, u64 *ext_err2);
+u64 tdh_mr_finalize(struct tdx_td *td);
 u64 tdh_vp_flush(struct tdx_vp *vp);
 u64 tdh_mng_vpflushdone(struct tdx_td *td);
 u64 tdh_mng_key_freeid(struct tdx_td *td);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index ffa0f6b8254d..8eaaf31a4187 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1667,6 +1667,33 @@ u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_rd);
 
+u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *ext_err1, u64 *ext_err2)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa,
+		.rdx = tdx_tdr_pa(td),
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_MR_EXTEND, &args);
+
+	*ext_err1 = args.rcx;
+	*ext_err2 = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mr_extend);
+
+u64 tdh_mr_finalize(struct tdx_td *td)
+{
+	struct tdx_module_args args = {
+		.rcx = tdx_tdr_pa(td),
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
index c9bea023f2b4..ed7152f81a6d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -23,6 +23,8 @@
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



