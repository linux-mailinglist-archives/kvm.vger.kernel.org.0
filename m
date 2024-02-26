Return-Path: <kvm+bounces-9656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 171A2866C80
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:38:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BFEDC1F217EB
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 734CC5A7A6;
	Mon, 26 Feb 2024 08:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fg19aK5I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B92358239;
	Mon, 26 Feb 2024 08:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936082; cv=none; b=tqG41N9tsw2jSUIWLHfRYZL2WmTDWgG/pAjd2O1+Drd/O9NuYly8YxFW4SI3eS/9HlWKReXFdnxMfH6tajjuEZSjQHOI2WZ/xjC9RIBIAkwO1anR94g1AoXYjrHTYv5cVCn1AU6tsquK65JO84gy59AYiWV2gWkRp51NO2NymC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936082; c=relaxed/simple;
	bh=bjQSqSS3f2d0HbCCIxYTXagxQRR+xdW29IEToT0E4RY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=feuEKfpSMyJwkf/F7oyK7iuOUu/sX3oYUut1U1UuFPZNiIsP4nIuT6GnZmFt6sw/8zlJOj0aLkTrCIbvcW22d2uxTqdeOvngSxEdCMTpgRf56EAMpOt8M4vcX+MXWV35infvsJ9g/an3rgLH00uugwr5XvmoGnpXeUebHkKhKz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fg19aK5I; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936080; x=1740472080;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bjQSqSS3f2d0HbCCIxYTXagxQRR+xdW29IEToT0E4RY=;
  b=Fg19aK5IOsXnC4P+SqqkVq/wb937vNbcCD3NzyuDLNcfmmVgtm7QU/73
   sza7BszFdYgwWUoGo069Ogr1NdlQZ3gpAQQyNHP9ysyVa9l5yzsSjVOvL
   8r//3hhV6GeSjyWiYKQAAT0HcVwpF19uRn4kxDKJgzjjz/CzriGy7HWIg
   aJQuSrwZ0hDasGKt7Q+9x3yMzeXigbFj4RRaTvKMGz4E6xAFDSNH2T5ZA
   Uz/YikiBSw/wh065o6w/qvEdZIBm1nDmKeWuacB2eLenihcjihW+g1+bz
   WyQNw9qnfp5NY1sM2Aajm/3fu6HMtWRV40WmygmsTqmQXsxpjTQiwNp5Y
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6155281"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6155281"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6615557"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:58 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 032/130] KVM: TDX: Add helper functions to allocate/free TDX private host key id
Date: Mon, 26 Feb 2024 00:25:34 -0800
Message-Id: <7348e22ba8d0eeab7ba093f3e83bfa7ee4da1928.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add helper functions to allocate/free TDX private host key id (HKID).

The memory controller encrypts TDX memory with the assigned TDX HKIDs.  The
global TDX HKID is to encrypt the TDX module, its memory, and some dynamic
data (TDR).  The private TDX HKID is assigned to guest TD to encrypt guest
memory and the related data.  When VMM releases an encrypted page for
reuse, the page needs a cache flush with the used HKID.  VMM needs the
global TDX HKID and the private TDX HKIDs to flush encrypted pages.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v19:
- Removed stale comment in tdx_guest_keyid_alloc() by Binbin
- Update sanity check in tdx_guest_keyid_free() by Binbin

v18:
- Moved the functions to kvm tdx from arch/x86/virt/vmx/tdx/
- Drop exporting symbols as the host tdx does.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a7e096fd8361..cde971122c1e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -11,6 +11,34 @@
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+/*
+ * Key id globally used by TDX module: TDX module maps TDR with this TDX global
+ * key id.  TDR includes key id assigned to the TD.  Then TDX module maps other
+ * TD-related pages with the assigned key id.  TDR requires this TDX global key
+ * id for cache flush unlike other TD-related pages.
+ */
+/* TDX KeyID pool */
+static DEFINE_IDA(tdx_guest_keyid_pool);
+
+static int __used tdx_guest_keyid_alloc(void)
+{
+	if (WARN_ON_ONCE(!tdx_guest_keyid_start || !tdx_nr_guest_keyids))
+		return -EINVAL;
+
+	return ida_alloc_range(&tdx_guest_keyid_pool, tdx_guest_keyid_start,
+			       tdx_guest_keyid_start + tdx_nr_guest_keyids - 1,
+			       GFP_KERNEL);
+}
+
+static void __used tdx_guest_keyid_free(int keyid)
+{
+	if (WARN_ON_ONCE(keyid < tdx_guest_keyid_start ||
+			 keyid > tdx_guest_keyid_start + tdx_nr_guest_keyids - 1))
+		return;
+
+	ida_free(&tdx_guest_keyid_pool, keyid);
+}
+
 static int __init tdx_module_setup(void)
 {
 	int ret;
-- 
2.25.1


