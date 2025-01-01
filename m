Return-Path: <kvm+bounces-34450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8706F9FF364
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 08:52:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DFAC18826DC
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 07:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CBD818FDA6;
	Wed,  1 Jan 2025 07:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XKFSgGxl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933131898ED
	for <kvm@vger.kernel.org>; Wed,  1 Jan 2025 07:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735717824; cv=none; b=ADkccrJKmw91LpeFxmQRzMvYuiRy4zErvoTTWOO1EiH2gMOhaFU7asEhAz07b6yAb3fQpAyjl84oLpzxOZJ8FuCkjH4Wc7mZZvvqFwsd6ANp/rdbsCXZoKO8eDSzkS9zN/v4bHj36D4btlUkxLJZmNMt8JHtJwpxTZ94XXSLC+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735717824; c=relaxed/simple;
	bh=KPP8RgU5kg5iR5YIHMu/u2Y/mhrpIuVLzWHK2ZPBo5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=foPX/H1rKwlOj9p3Jzeqfwjsts3DuXzBEON7VBCDbeOsp4jQMDM0iZ9NLYRUNKsuIF2VKxiJQg40dLjON1oKfmAZuRX/I3FmSfoZxVAiWh3XiF0C+WfrlIMrH0NmMgboG3qKhwB4UwxhU0UfZIO1Qo3ByNfs9b0DKU+Q/l0RwUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XKFSgGxl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735717821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=trMBeEf3l29xzm9/sLFqNMe9gjPadoxlYFhn4FjoWSk=;
	b=XKFSgGxlGZl+JN9j7eHsiXOIDvmmWKIci4pYnUzByoi71AmdnXIR3iIEK1J+QfF4261MGK
	+P9/2woBUBc8cVHuJ+n/6ZHpApjdCaXvfRA8r1vYnoFR0IlWwlaIUIYNTJFOuGSX8rlrIi
	7ST0FDqSoRp05AgBUEIlqJxj+FzikiQ=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-53-7TEfj6q_Oxm549NdtkGOFA-1; Wed,
 01 Jan 2025 02:50:18 -0500
X-MC-Unique: 7TEfj6q_Oxm549NdtkGOFA-1
X-Mimecast-MFC-AGG-ID: 7TEfj6q_Oxm549NdtkGOFA
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E8A5E1956096;
	Wed,  1 Jan 2025 07:50:16 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B58571956052;
	Wed,  1 Jan 2025 07:50:15 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	yan.y.zhao@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 09/13] x86/virt/tdx: Add SEAMCALL wrappers to manage TDX TLB tracking
Date: Wed,  1 Jan 2025 02:49:55 -0500
Message-ID: <20250101074959.412696-10-pbonzini@redhat.com>
In-Reply-To: <20250101074959.412696-1-pbonzini@redhat.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
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
index 32f3981d56c5..f0b7b7b7d506 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -142,6 +142,7 @@ u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, u64 hpa, u64 source, u64 *rcx,
 u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, u64 level, u64 hpa, u64 *rcx, u64 *rdx);
 u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page);
 u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, u64 hpa, u64 *rcx, u64 *rdx);
+u64 tdh_mem_range_block(struct tdx_td *td, u64 gpa, u64 level, u64 *rcx, u64 *rdx);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u64 hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
@@ -155,6 +156,7 @@ u64 tdh_vp_rd(struct tdx_vp *vp, u64 field, u64 *data);
 u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask);
 u64 tdh_vp_init_apicid(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid);
 u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size);
+u64 tdh_mem_track(struct tdx_td *tdr);
 u64 tdh_phymem_cache_wb(bool resume);
 u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
 #else
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index f39197d4eafc..c7e6f30d0a14 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1561,6 +1561,23 @@ u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, u64 hpa, u64 *rcx, u64 *rdx)
 }
 EXPORT_SYMBOL_GPL(tdh_mem_page_aug);
 
+u64 tdh_mem_range_block(struct tdx_td *td, u64 gpa, u64 level, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa | level,
+		.rdx = tdx_tdr_pa(td),
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
@@ -1734,6 +1751,16 @@ u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_reclaim);
 
+u64 tdh_mem_track(struct tdx_td *td)
+{
+	struct tdx_module_args args = {
+		.rcx = tdx_tdr_pa(td),
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



