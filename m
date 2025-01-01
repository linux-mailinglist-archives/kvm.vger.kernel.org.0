Return-Path: <kvm+bounces-34434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C66D9FF346
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 08:32:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 694CA3A2F2B
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 07:32:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EAA133CFC;
	Wed,  1 Jan 2025 07:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mdl5H91r"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59D629CF0
	for <kvm@vger.kernel.org>; Wed,  1 Jan 2025 07:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735716666; cv=none; b=AEveZy7rL8T8w62rGQN3LPXUgSOJzxo5zOKqcpAKnBN691f3tF6USuzgyFt6g26HGJ4qjJNLtu52p/qbWqAN8NCRAAr2eTLeajbEcjo5WYS0OOBslFhCadD/AMLgvfg8FBy5Zl/PVkS6rt10B3Xvf+wh1hYtnmLhTMAeLk24N8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735716666; c=relaxed/simple;
	bh=cNKQR/cdJ9JaIeHTnOtORrL/cq33mFO9nx8dy4Ntjc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UDpRklhE6h3SBFG46ULtsjOnvFWS9a0kXRVxNogAAqSCkO93k8jG5/Mg7VrDMvDGLrJ9Cu13fK3CO+YkC+TDMSf49Y0VCO6cBLqP9E0Ruhi7g/RFW5VnZ81Iat9Ej0OXQX/p5XKgIT/a0+eA5f9wfMkDS5qp+iXUp+NnrnqI1h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mdl5H91r; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735716663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BaWDBbL9DeXwmQT+X2xATU2780DEmEmSCYzLIaSXHo8=;
	b=Mdl5H91rivD6xWvb2Dffohb3+prZmWxGDuLw9MqYzHU04qcq4Xou0d2WCX4gF/TRlhX8IR
	dIOjHUPvBwSth37fhedfpHRxA+XDOHxvI3qwIsnOIKYMdrDfU//kPl+8qHmJ60NYbGoalC
	fxw5dHdrnHqJcvKQyzTrntk25W7EZmY=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-172-FmM4v5kuOgWnuGkjSeZwpw-1; Wed,
 01 Jan 2025 02:30:59 -0500
X-MC-Unique: FmM4v5kuOgWnuGkjSeZwpw-1
X-Mimecast-MFC-AGG-ID: FmM4v5kuOgWnuGkjSeZwpw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AAFDA1956087;
	Wed,  1 Jan 2025 07:30:57 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4119119560AA;
	Wed,  1 Jan 2025 07:30:56 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	yan.y.zhao@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH 05/11] x86/virt/tdx: Add SEAMCALL wrappers for TDX VM/vCPU field access
Date: Wed,  1 Jan 2025 02:30:41 -0500
Message-ID: <20250101073047.402099-6-pbonzini@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Intel TDX protects guest VMs from malicious host and certain physical
attacks. The TDX module has TD scoped and vCPU scoped "metadata fields".
These fields are a bit like VMCS fields, and stored in data structures
maintained by the TDX module. Export 3 SEAMCALLs for use in reading and
writing these fields:

Make tdh_mng_rd() use MNG.VP.RD to read the TD scoped metadata.

Make tdh_vp_rd()/tdh_vp_wr() use TDH.VP.RD/WR to read/write the vCPU
scoped metadata.

KVM will use these by creating inline helpers that target various metadata
sizes. Export the raw SEAMCALL leaf, to avoid exporting the large number
of various sized helpers.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
Message-ID: <20241115202028.1585487-6-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  |  3 +++
 arch/x86/virt/vmx/tdx/tdx.c | 47 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  3 +++
 3 files changed, 53 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 063b6e0b1899..baeb777b6ff4 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -133,9 +133,12 @@ u64 tdh_vp_addcx(struct tdx_vp *vp, hpa_t tdcx);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, hpa_t hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
+u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data);
 u64 tdh_mng_key_freeid(struct tdx_td *td);
 u64 tdh_mng_init(struct tdx_td *td, u64 td_params, hpa_t *tdr);
 u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx);
+u64 tdh_vp_rd(struct tdx_vp *vp, u64 field, u64 *data);
+u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask);
 u64 tdh_vp_init_apicid(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid);
 u64 tdh_phymem_page_reclaim(hpa_t page, u64 *page_type, u64 *page_owner, u64 *page_size);
 u64 tdh_phymem_cache_wb(bool resume);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index dd2cf3c87db1..392fe062c31b 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1526,6 +1526,23 @@ u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp)
 }
 EXPORT_SYMBOL_GPL(tdh_vp_create);
 
+u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
+{
+	struct tdx_module_args args = {
+		.rcx = td->tdr,
+		.rdx = field,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_MNG_RD, &args);
+
+	/* R8: Content of the field, or 0 in case of error. */
+	*data = args.r8;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mng_rd);
+
 u64 tdh_mng_key_freeid(struct tdx_td *td)
 {
 	struct tdx_module_args args = {
@@ -1563,6 +1580,36 @@ u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx)
 }
 EXPORT_SYMBOL_GPL(tdh_vp_init);
 
+u64 tdh_vp_rd(struct tdx_vp *vp, u64 field, u64 *data)
+{
+	struct tdx_module_args args = {
+		.rcx = vp->tdvpr,
+		.rdx = field,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_VP_RD, &args);
+
+	/* R8: Content of the field, or 0 in case of error. */
+	*data = args.r8;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_vp_rd);
+
+u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask)
+{
+	struct tdx_module_args args = {
+		.rcx = vp->tdvpr,
+		.rdx = field,
+		.r8 = data,
+		.r9 = mask,
+	};
+
+	return seamcall(TDH_VP_WR, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_wr);
+
 u64 tdh_vp_init_apicid(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid)
 {
 	struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 7a15c9afcdfa..aacd38b12989 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -19,11 +19,13 @@
 #define TDH_VP_ADDCX			4
 #define TDH_MNG_KEY_CONFIG		8
 #define TDH_MNG_CREATE			9
+#define TDH_MNG_RD			11
 #define TDH_VP_CREATE			10
 #define TDH_MNG_KEY_FREEID		20
 #define TDH_MNG_INIT			21
 #define TDH_VP_INIT			22
 #define TDH_PHYMEM_PAGE_RDMD		24
+#define TDH_VP_RD			26
 #define TDH_PHYMEM_PAGE_RECLAIM		28
 #define TDH_SYS_KEY_CONFIG		31
 #define TDH_SYS_INIT			33
@@ -32,6 +34,7 @@
 #define TDH_SYS_TDMR_INIT		36
 #define TDH_PHYMEM_CACHE_WB		40
 #define TDH_PHYMEM_PAGE_WBINVD		41
+#define TDH_VP_WR			43
 #define TDH_SYS_CONFIG			45
 
 /*
-- 
2.43.5



