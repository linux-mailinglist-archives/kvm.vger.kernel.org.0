Return-Path: <kvm+bounces-34437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 176DD9FF34A
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 08:33:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9F011603EF
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 07:33:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6847718C01E;
	Wed,  1 Jan 2025 07:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IIHHNCBA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867F917B4EC
	for <kvm@vger.kernel.org>; Wed,  1 Jan 2025 07:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735716669; cv=none; b=gArMGlYCnfUUntI2WIWXQUkN8uD394Mg+8XStSAuEfXkLBolcDNFhftUaNa4ytxFvRItl1xFPNztPFOI4YQgRBWXF4XfuJ0IvcgW1Q+JBTcFGaWK3cqXy8zosWHIE/XkVuUwdCxVkYDC/ol3X8Sww7o0HX4cuA4cgSkwtDwceBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735716669; c=relaxed/simple;
	bh=VOoQC1CV/1HAj3ZCGIc2zgSUUndm3i3MMRs10u5uomM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DqujfKBVfLKib37Qw7orwl7uBwxvqiYFG7Y2OYvTKK0e9Cx+iTYKgcwQl43cc1lgP0imx9WNDKiDYWLan1RleDCGck3MLmzOE9JVwuLIaGA2OSaAG3Ojp1ZXrznqNx+3WgnWT/tvCI0RK8y57kKHDoilxZNTqe1n2/Nt+YyAR8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IIHHNCBA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735716666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5pG+d1ebt0a7NEcPxIg3+/Fe11sM74wg5c/1Xh26kBw=;
	b=IIHHNCBADiwww+6f2phFjCGxun93YmzdNUbrDlRKA/M1C87vRmj6WfYHIswwFaNMauuJOx
	vrrBf9zpSjXC/mxaxcdizkMljio7O9ZxY3B5CVLh7tcH+zDhqHa0oVQqry3v1u3Kv39b6j
	9whctHhjhMYrGxAd2VnYeyWnSx5bI54=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-436-HPLLiIBiNAaHc2m40_TWYg-1; Wed,
 01 Jan 2025 02:31:05 -0500
X-MC-Unique: HPLLiIBiNAaHc2m40_TWYg-1
X-Mimecast-MFC-AGG-ID: HPLLiIBiNAaHc2m40_TWYg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C723019560B4;
	Wed,  1 Jan 2025 07:31:03 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9426419560AA;
	Wed,  1 Jan 2025 07:31:02 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	yan.y.zhao@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 09/11] x86/virt/tdx: Add SEAMCALL wrappers to manage TDX TLB tracking
Date: Wed,  1 Jan 2025 02:30:45 -0500
Message-ID: <20250101073047.402099-10-pbonzini@redhat.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX module defines a TLB tracking protocol to make sure that no logical
processor holds any stale Secure EPT (S-EPT or SEPT) TLB translations for a
given TD private GPA range. After a successful TDH.MEM.RANGE.BLOCK,
TDH.MEM.TRACK, and kicking off all vCPUs, TDX module ensures that the
subsequent TDH.VP.ENTER on each vCPU will flush all stale TLB entries for
the specified GPA ranges in TDH.MEM.RANGE.BLOCK. Wrap the
TDH.MEM.RANGE.BLOCK with tdh_mem_range_block() and TDH.MEM.TRACK with
tdh_mem_track() to enable the kernel to assist the TDX module in TLB
tracking management.

The caller of tdh_mem_range_block() needs to specify "GPA" and "level" to
request the TDX module to block the subsequent creation of TLB translation
for a GPA range. This GPA range can correspond to a SEPT page or a TD
private page at any level.

Contentions and errors are possible with the SEAMCALL TDH.MEM.RANGE.BLOCK.
Therefore, the caller of tdh_mem_range_block() needs to check the function
return value and retrieve extended error info from the function output
params.

Upon TDH.MEM.RANGE.BLOCK success, no new TLB entries will be created for
the specified private GPA range, though the existing TLB translations may
still persist.

Call tdh_mem_track() after tdh_mem_range_block(). No extra info is required
except the TDR HPA to denote the TD. TDH.MEM.TRACK will advance the TD's
epoch counter to ensure TDX module will flush TLBs in all vCPUs once the
vCPUs re-enter the TD. TDH.MEM.TRACK will fail to advance TD's epoch
counter if there are vCPUs still running in non-root mode at the previous
TD epoch counter. Therefore, send IPIs to kick off vCPUs after
tdh_mem_track() to avoid the failure by forcing all vCPUs to re-enter the
TD.

Contentions are also possible in TDH.MEM.TRACK. For example, TDH.MEM.TRACK
may contend with TDH.VP.ENTER when advancing the TD epoch counter.
tdh_mem_track() does not provide the retries for the caller. Callers can
choose to avoid contentions or retry on their own.

[Kai: Switched from generic seamcall export]
[Yan: Re-wrote the changelog]
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Message-ID: <20241112073648.22143-1-yan.y.zhao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/virt/vmx/tdx/tdx.c | 27 +++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 3 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 51784ad1ff31..381a0f4aeefc 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -133,6 +133,7 @@ u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, u64 hpa, u64 source, u64 *rcx,
 u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, u64 level, u64 hpa, u64 *rcx, u64 *rdx);
 u64 tdh_vp_addcx(struct tdx_vp *vp, hpa_t tdcx);
 u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, u64 hpa, u64 *rcx, u64 *rdx);
+u64 tdh_mem_range_block(struct tdx_td *td, u64 gpa, u64 level, u64 *rcx, u64 *rdx);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, hpa_t hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
@@ -146,6 +147,7 @@ u64 tdh_vp_rd(struct tdx_vp *vp, u64 field, u64 *data);
 u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask);
 u64 tdh_vp_init_apicid(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid);
 u64 tdh_phymem_page_reclaim(hpa_t page, u64 *page_type, u64 *page_owner, u64 *page_size);
+u64 tdh_mem_track(struct tdx_td *tdr);
 u64 tdh_phymem_cache_wb(bool resume);
 u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
 #else
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 6db40f1d7a4f..58b2e24179ba 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1550,6 +1550,23 @@ u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, u64 hpa, u64 *rcx, u64 *rdx)
 }
 EXPORT_SYMBOL_GPL(tdh_mem_page_aug);
 
+u64 tdh_mem_range_block(struct tdx_td *td, u64 gpa, u64 level, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa | level,
+		.rdx = td->tdr,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_MEM_RANGE_BLOCK, &args);
+
+	*rcx = args.rcx;
+	*rdx = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_range_block);
+
 u64 tdh_mng_key_config(struct tdx_td *td)
 {
 	struct tdx_module_args args = {
@@ -1718,6 +1735,16 @@ u64 tdh_phymem_page_reclaim(hpa_t page, u64 *page_type, u64 *page_owner, u64 *pa
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_reclaim);
 
+u64 tdh_mem_track(struct tdx_td *td)
+{
+	struct tdx_module_args args = {
+		.rcx = td->tdr,
+	};
+
+	return seamcall(TDH_MEM_TRACK, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mem_track);
+
 u64 tdh_phymem_cache_wb(bool resume)
 {
 	struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 80e6ef006085..4b0ad536afd9 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -20,6 +20,7 @@
 #define TDH_MEM_SEPT_ADD		3
 #define TDH_VP_ADDCX			4
 #define TDH_MEM_PAGE_AUG		6
+#define TDH_MEM_RANGE_BLOCK		7
 #define TDH_MNG_KEY_CONFIG		8
 #define TDH_MNG_CREATE			9
 #define TDH_MNG_RD			11
@@ -35,6 +36,7 @@
 #define TDH_SYS_KEY_CONFIG		31
 #define TDH_SYS_INIT			33
 #define TDH_SYS_RD			34
+#define TDH_MEM_TRACK			38
 #define TDH_SYS_LP_INIT			35
 #define TDH_SYS_TDMR_INIT		36
 #define TDH_PHYMEM_CACHE_WB		40
-- 
2.43.5



