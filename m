Return-Path: <kvm+bounces-31573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 54E699C4FAC
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:41:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BCC14B22BA5
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:41:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4208120CCE8;
	Tue, 12 Nov 2024 07:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hGwPLdcG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA6120C481;
	Tue, 12 Nov 2024 07:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397149; cv=none; b=WIbcs/XBaDe0mIpYZkGZ/Y4SADC5R2/04akQQ4ewvhJYXahl1Qx+B+xrt9gldLJNRZ0rJk6sDeET+kPKJjerphg2K/tb5tzDyPGSd8H9eQnUaDRyqUzK8EFPQUu21a1g0tikQIiPJ2M3nrUnmdifIoefZZpu1F/NgVLwSd1VO2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397149; c=relaxed/simple;
	bh=bg1j8ds2WKtREt9N/qTvmMHLjdRPkMBb+kP+s34qI+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGxythZjHqbvI74Q+po1u5l+dv6ENRygNImXD//7CG8L+l8NpDYkKkvUamR1kC8twR30o1pIWV0N2ebFbGba3qOr8FgF3ZVZaKLV6wSZnWTjYa1CqHMWmrwG9EtH+iDOGXdJkzYD0bQHqpckeVcG7nquAnfsC1OBzd5B+WRAm/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hGwPLdcG; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397148; x=1762933148;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bg1j8ds2WKtREt9N/qTvmMHLjdRPkMBb+kP+s34qI+k=;
  b=hGwPLdcGHA366pSzC/5QnTlRK5pjK2B26m1XpqoBE2gG5MoebZ495Xc7
   c9R+peA/53ubjGQCPBW0S2LA4T+3eNm9bPs936Q7i8HnhJlusRWM6t5L6
   Zv5f+yMdrHHklr+FuNAxYkzd5s5FMCOGrP+VfIWABYai50BsYs62ZG4NW
   jQ1I5JwXrqY9ONE+FzTE3AxszAjaAMBvoyOSd8n2witk4Et0GtLUD2Ffs
   HGEHN3hbPnsog5oDE01z+1kcKwRj4pp4M8GBX687zlMFyglVY4wsJrcF+
   KMgAsy/ho0QlL7owcwuE8v8aCQER+Ewl0E/AwtT5BQUtbSQLKWbp+PBEX
   w==;
X-CSE-ConnectionGUID: LgG1uImeRNKxXfYBX86x7Q==
X-CSE-MsgGUID: FyOTixNSSIu4GrO7Uq+wNg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31389391"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31389391"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:39:07 -0800
X-CSE-ConnectionGUID: f4hl0gqqRr+UWe/+quIlgg==
X-CSE-MsgGUID: WCsYzx02RzWvmZBVl4Vtzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="87081953"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:39:03 -0800
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
Subject: [PATCH v2 10/24] x86/virt/tdx: Add SEAMCALL wrappers to add TD private pages
Date: Tue, 12 Nov 2024 15:36:36 +0800
Message-ID: <20241112073636.22129-1-yan.y.zhao@intel.com>
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
depending on the GPA.SHARED bit. The TDX module maintains a Secure EPT
(S-EPT or SEPT) tree per TD to translate TD's private memory accessed
using a private GPA. Wrap the SEAMCALL TDH.MEM.PAGE.ADD with
tdh_mem_page_add() and TDH.MEM.PAGE.AUG with tdh_mem_page_aug() to add TD
private pages and map them to the TD's private GPAs in the SEPT.

Callers of tdh_mem_page_add() and tdh_mem_page_aug() allocate and provide
normal pages to the wrappers, who further pass those pages to the TDX
module. Before passing the pages to the TDX module, tdh_mem_page_add() and
tdh_mem_page_aug() perform a CLFLUSH on the page mapped with keyID 0 to
ensure that any dirty cache lines don't write back later and clobber TD
memory or control structures. Don't worry about the other MK-TME keyIDs
because the kernel doesn't use them. The TDX docs specify that this flush
is not needed unless the TDX module exposes the CLFLUSH_BEFORE_ALLOC
feature bit. Do the CLFLUSH unconditionally for two reasons: make the
solution simpler by having a single path that can handle both
!CLFLUSH_BEFORE_ALLOC and CLFLUSH_BEFORE_ALLOC cases. Avoid wading into any
correctness uncertainty by going with a conservative solution to start.

Call tdh_mem_page_add() to add a private page to a TD during the TD's build
time (i.e., before TDH.MR.FINALIZE). Specify which GPA the 4K private page
will map to. No need to specify level info since TDH.MEM.PAGE.ADD only adds
pages at 4K level. To provide initial contents to TD, provide an additional
source page residing in memory managed by the host kernel itself (encrypted
with a shared keyID). The TDX module will copy the initial contents from
the source page in shared memory into the private page after mapping the
page in the SEPT to the specified private GPA. The TDX module allows the
source page to be the same page as the private page to be added. In that
case, the TDX module converts and encrypts the source page as a TD private
page.

Call tdh_mem_page_aug() to add a private page to a TD during the TD's
runtime (i.e., after TDH.MR.FINALIZE). TDH.MEM.PAGE.AUG supports adding
huge pages. Specify which GPA the private page will map to, along with
level info embedded in the lower bits of the GPA. The TDX module will
recognize the added page as the TD's private page after the TD's acceptance
with TDCALL TDG.MEM.PAGE.ACCEPT.

tdh_mem_page_add() and tdh_mem_page_aug() may fail. Callers can check
function return value and retrieve extended error info from the function
output parameters.

The TDX module has many internal locks. To avoid staying in SEAM mode for
too long, SEAMCALLs returns a BUSY error code to the kernel instead of
spinning on the locks. Depending on the specific SEAMCALL, the caller
may need to handle this error in specific ways (e.g., retry). Therefore,
return the SEAMCALL error code directly to the caller. Don't attempt to
handle it in the core kernel.

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
- split out TDH.MEM.PAGE.ADD/AUG and re-wrote the patch msg (Yan).
- removed the code comment in tdh_mem_page_add() about rcx/rdx since the
  callers still need to check for accurate interpretation from spec and
  need to put the comment in a central place (Yan, Reinette).
- split out from original patch "KVM: TDX: Add C wrapper functions for
  SEAMCALLs to the TDX module" and move to x86 core (Kai)
---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/virt/vmx/tdx/tdx.c | 39 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 3 files changed, 43 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index b6f3e5504d4d..d363aa201283 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -124,8 +124,10 @@ void tdx_guest_keyid_free(unsigned int keyid);
 
 /* SEAMCALL wrappers for creating/destroying/running TDX guests */
 u64 tdh_mng_addcx(u64 tdr, u64 tdcs);
+u64 tdh_mem_page_add(u64 tdr, u64 gpa, u64 hpa, u64 source, u64 *rcx, u64 *rdx);
 u64 tdh_mem_sept_add(u64 tdr, u64 gpa, u64 level, u64 hpa, u64 *rcx, u64 *rdx);
 u64 tdh_vp_addcx(u64 tdvpr, u64 tdcx);
+u64 tdh_mem_page_aug(u64 tdr, u64 gpa, u64 hpa, u64 *rcx, u64 *rdx);
 u64 tdh_mng_key_config(u64 tdr);
 u64 tdh_mng_create(u64 tdr, u64 hkid);
 u64 tdh_vp_create(u64 tdr, u64 tdvpr);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 1dc9be680475..e63e3cfd41fc 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1575,6 +1575,26 @@ u64 tdh_mng_addcx(u64 tdr, u64 tdcs)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_addcx);
 
+u64 tdh_mem_page_add(u64 tdr, u64 gpa, u64 hpa, u64 source, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa,
+		.rdx = tdr,
+		.r8 = hpa,
+		.r9 = source,
+	};
+	u64 ret;
+
+	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	ret = seamcall_ret(TDH_MEM_PAGE_ADD, &args);
+
+	*rcx = args.rcx;
+	*rdx = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_page_add);
+
 u64 tdh_mem_sept_add(u64 tdr, u64 gpa, u64 level, u64 hpa, u64 *rcx, u64 *rdx)
 {
 	struct tdx_module_args args = {
@@ -1606,6 +1626,25 @@ u64 tdh_vp_addcx(u64 tdvpr, u64 tdcx)
 }
 EXPORT_SYMBOL_GPL(tdh_vp_addcx);
 
+u64 tdh_mem_page_aug(u64 tdr, u64 gpa, u64 hpa, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa,
+		.rdx = tdr,
+		.r8 = hpa,
+	};
+	u64 ret;
+
+	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);
+
+	*rcx = args.rcx;
+	*rdx = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_page_aug);
+
 u64 tdh_mng_key_config(u64 tdr)
 {
 	struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 7624d098515f..d32ed527f67f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -18,8 +18,10 @@
  * TDX module SEAMCALL leaf functions
  */
 #define TDH_MNG_ADDCX			1
+#define TDH_MEM_PAGE_ADD		2
 #define TDH_MEM_SEPT_ADD		3
 #define TDH_VP_ADDCX			4
+#define TDH_MEM_PAGE_AUG		6
 #define TDH_MNG_KEY_CONFIG		8
 #define TDH_MNG_CREATE			9
 #define TDH_VP_CREATE			10
-- 
2.43.2


