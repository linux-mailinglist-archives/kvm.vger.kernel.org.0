Return-Path: <kvm+bounces-31575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20C769C4FB1
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:42:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2A56282A06
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A2E120CCF6;
	Tue, 12 Nov 2024 07:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nHJnp+Cj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE6420B80E;
	Tue, 12 Nov 2024 07:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397171; cv=none; b=NBYRksxyc6Jb49PhS9NG61LGYPCI0dFveMTx0iaQ+HSKN2cRF6JpZ/Tj80+ZSjpNAl0r2iq/ou5d8DX+lex4rSJ1NdNxH2+/nL/HBkRu1XQ3l7ZntRUg84dB8SM+RzKCH5kdFbrRo26OAJNiZM2JUz1odRMqWpiZh5MItnA9yYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397171; c=relaxed/simple;
	bh=4fRyHylFpFmoOmS+0uQ9CGHFi3HY1T18UcGp/o4aH74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AB7+SN6+nqGhqCfhRbn1x6+luPFgkDffYwroDKaEA7nRypVAmROKidniFeE+pQ/uxHraB9OB+OOME5s0CPGSGkaonyEp1dbYlk6IonjTdp+TATCELDAE4Vuu/mCQ2xpf56OhSJV2d+K7E7nojGG/dgSRmEEI6bweC6349zUV4UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nHJnp+Cj; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397170; x=1762933170;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4fRyHylFpFmoOmS+0uQ9CGHFi3HY1T18UcGp/o4aH74=;
  b=nHJnp+CjzC4gjUjU2LQVX6wG0u3AissvB233vnylLu+xYOpwDKIFWeF3
   eQp55ZJmKWvsB1VN+eIAPVw9ypUys/Eq618WkoTBuH83uXM+2DHd8TNmF
   I1SO3xyDFWOfHyFEKl/3zfFeyrm+TXQf5OfAb2dkKqnjQc0pGRqk6Lya1
   y0EtuPGotgNnJlRoK6MiZ+IvzBUHt8Q9Po1zKfalCA8zce2UsAltTkOf0
   K/nmW6xjoU7jj6JdHP1Y5oTCjrVeaX8ewSdElBvjmEzBe/WAedo0LtFob
   ze9E2+KPAT8rhWu142bbcG+omN20rG44KKsEkX8jSzwhUksw9okooZSoB
   Q==;
X-CSE-ConnectionGUID: 7aUDtJPERfyDf4OCxUGuLw==
X-CSE-MsgGUID: 5psBrAwKQcS0AgWJbOKu/Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31389432"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31389432"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:39:29 -0800
X-CSE-ConnectionGUID: SNQaZgoJTxyyqUMHs2R58w==
X-CSE-MsgGUID: TFIITmeXS1qZjDQiZCdl0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="87082029"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:39:25 -0800
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
Subject: [PATCH v2 12/24] x86/virt/tdx: Add SEAMCALL wrappers to remove a TD private page
Date: Tue, 12 Nov 2024 15:36:58 +0800
Message-ID: <20241112073658.22157-1-yan.y.zhao@intel.com>
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

TDX architecture introduces the concept of private GPA vs shared GPA,
depending on the GPA.SHARED bit. The TDX module maintains a single Secure
EPT (S-EPT or SEPT) tree per TD to translate TD's private memory accessed
using a private GPA. Wrap the SEAMCALL TDH.MEM.PAGE.REMOVE with
tdh_mem_page_remove() and TDH_PHYMEM_PAGE_WBINVD with
tdh_phymem_page_wbinvd_hkid() to unmap a TD private page from the SEPT,
remove the TD private page from the TDX module and flush cache lines to
memory after removal of the private page.

Callers should specify "GPA" and "level" when calling tdh_mem_page_remove()
to indicate to the TDX module which TD private page to unmap and remove.

TDH.MEM.PAGE.REMOVE may fail, and the caller of tdh_mem_page_remove() can
check the function return value and retrieve extended error information
from the function output parameters. Follow the TLB tracking protocol
before calling tdh_mem_page_remove() to remove a TD private page to avoid
SEAMCALL failure.

After removing a TD's private page, the TDX module does not write back and
invalidate cache lines associated with the page and the page's keyID (i.e.,
the TD's guest keyID). Therefore, provide tdh_phymem_page_wbinvd_hkid() to
allow the caller to pass in the TD's guest keyID and invoke
TDH_PHYMEM_PAGE_WBINVD to perform this action.

Before reusing the page, the host kernel needs to map the page with keyID 0
and invoke movdir64b() to convert the TD private page to a normal shared
page.

TDH.MEM.PAGE.REMOVE and TDH_PHYMEM_PAGE_WBINVD may meet contentions inside
the TDX module for TDX's internal resources. To avoid staying in SEAM mode
for too long, TDX module will return a BUSY error code to the kernel
instead of spinning on the locks. The caller may need to handle this error
in specific ways (e.g., retry). The wrappers return the SEAMCALL error code
directly to the caller. Don't attempt to handle it in the core kernel.

[Kai: Switched from generic seamcall export]
[Yan: Re-wrote the changelog]
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
TDX MMU part 2 v2:
- split out TDH.MEM.PAGE.REMOVE, TDH_PHYMEM_PAGE_WBINVD and re-wrote the
  patch msg (Yan).
- split out from original patch "KVM: TDX: Add C wrapper functions for
  SEAMCALLs to the TDX module" and move to x86 core (Kai)
---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/virt/vmx/tdx/tdx.c | 27 +++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 3 files changed, 30 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 227cb334176e..bad47415894b 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -143,8 +143,10 @@ u64 tdh_vp_wr(u64 tdvpr, u64 field, u64 data, u64 mask);
 u64 tdh_vp_init_apicid(u64 tdvpr, u64 initial_rcx, u32 x2apicid);
 u64 tdh_phymem_page_reclaim(u64 page, u64 *rcx, u64 *rdx, u64 *r8);
 u64 tdh_mem_track(u64 tdr);
+u64 tdh_mem_page_remove(u64 tdr, u64 gpa, u64 level, u64 *rcx, u64 *rdx);
 u64 tdh_phymem_cache_wb(bool resume);
 u64 tdh_phymem_page_wbinvd_tdr(u64 tdr);
+u64 tdh_phymem_page_wbinvd_hkid(u64 hpa, u64 hkid);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index f7f83d86ec18..1b57486f2f06 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1847,6 +1847,23 @@ u64 tdh_mem_track(u64 tdr)
 }
 EXPORT_SYMBOL_GPL(tdh_mem_track);
 
+u64 tdh_mem_page_remove(u64 tdr, u64 gpa, u64 level, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa | level,
+		.rdx = tdr,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_MEM_PAGE_REMOVE, &args);
+
+	*rcx = args.rcx;
+	*rdx = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_page_remove);
+
 u64 tdh_phymem_cache_wb(bool resume)
 {
 	struct tdx_module_args args = {
@@ -1866,3 +1883,13 @@ u64 tdh_phymem_page_wbinvd_tdr(u64 tdr)
 	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_tdr);
+
+u64 tdh_phymem_page_wbinvd_hkid(u64 hpa, u64 hkid)
+{
+	struct tdx_module_args args = {};
+
+	args.rcx = hpa | (hkid << boot_cpu_data.x86_phys_bits);
+
+	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index e659eee1080a..505203a89238 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -35,6 +35,7 @@
 #define TDH_PHYMEM_PAGE_RDMD		24
 #define TDH_VP_RD			26
 #define TDH_PHYMEM_PAGE_RECLAIM		28
+#define TDH_MEM_PAGE_REMOVE		29
 #define TDH_SYS_KEY_CONFIG		31
 #define TDH_SYS_INIT			33
 #define TDH_SYS_RD			34
-- 
2.43.2


