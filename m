Return-Path: <kvm+bounces-23901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A480F94F9E0
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:50:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D72FE1C21D03
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8152319D88C;
	Mon, 12 Aug 2024 22:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tohj3idk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C5319B3C4;
	Mon, 12 Aug 2024 22:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502916; cv=none; b=QDdGYdvMv5nfR7t97TbnDwWHkVeChvvClFnrGXh0UkzbZookAnyR2zcO6Ex+dKCYScp68srCivVi7RaFF0I0rmSZEtzyJp9KDH4pG2VUpakSCDvnSYg/gGr8rw3xUvSQ8xqpOs5C177HDmPsPezytVGy0hu07+xGGWzbP4gsskI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502916; c=relaxed/simple;
	bh=t1hPqRdy3HbA5wWiotcscwrx1WvzkmojXvu4BmnMQ9o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C1+GY0bOTBkQmpuc66xHI5axyIGvRsnx8BH8+Tn5uGnp0PNK7HM//2ZBxF8CCFCoy+mZAScds0XSOsXm0pX3/GcdRFLNcBWrc7TGTCPvX8Po+lGQOpwf75usDtTFtwbP1eQUriuRtm33vPN1UPOzNRXlYCchA+70xMMA7SWF5Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tohj3idk; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723502914; x=1755038914;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t1hPqRdy3HbA5wWiotcscwrx1WvzkmojXvu4BmnMQ9o=;
  b=Tohj3idkKlKCCVu8mR7zc/XOwcbzaZ1v1tvvhv9vIhphizRbyhmuBZJQ
   WWjETSzCke+IRy9jVWQ1UmqD6vAsP30zjX7OASN8GVtkT26QgD3lnYAsn
   Qgy9ZYjV2oEnNmrttqae5S2f90cKQIZuwvpmpQSZ9QZNfmNMORRWt45cy
   aM2c0XuTw35hz7AbU8pzuM+XLbS4oztxHATtmS8rsIPiyNiHzrRX6vcXy
   8BKVsdDe0DpOaA4HOfPQXf/oVxNqzVxoUgsUD9vS0dZgvnR4LvwpfUkd3
   sFvlihUykOb3g0FyCu/hVEkrIRWKESN/FacrkEa8SZtkpPbcoYuYq3G+c
   w==;
X-CSE-ConnectionGUID: tCaosbcRRnSBFe7euyWJ6g==
X-CSE-MsgGUID: L2cieGPyQPKN5kpxX7fmbg==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="33041369"
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="33041369"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:30 -0700
X-CSE-ConnectionGUID: mU5j0ngTSNikdasniSbsHg==
X-CSE-MsgGUID: U0Hxk3AwQOSh/3v3YTcnxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="59008375"
Received: from jdoman-desk1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.222.53])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:30 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH 07/25] KVM: TDX: Add helper functions to allocate/free TDX private host key id
Date: Mon, 12 Aug 2024 15:48:02 -0700
Message-Id: <20240812224820.34826-8-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add helper functions to allocate/free TDX private host key id (HKID).

The memory controller encrypts TDX memory with the assigned HKIDs. Each TDX
guest must be protected by its own unique TDX HKID.

The HW has a fixed set of these HKID keys. Out of those, some are set aside
for use by for other TDX components, but most are saved for guest use. The
code that does this partitioning, records the range chosen to be available
for guest use in the tdx_guest_keyid_start and tdx_nr_guest_keyids
variables.

Use this range of HKIDs reserved for guest use with the kernel's IDA
allocator library helper to create a mini TDX HKID allocator that can be
called when setting up a TD. This way it can have an exclusive HKID, as is
required. This allocator will be used in future changes.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v1:
 - Update the commit message
 - Delete stale comment on global hkdi
 - Deleted WARN_ON_ONCE() as it doesn't seemed very usefull

v19:
 - Removed stale comment in tdx_guest_keyid_alloc() by Binbin
 - Update sanity check in tdx_guest_keyid_free() by Binbin

v18:
 - Moved the functions to kvm tdx from arch/x86/virt/vmx/tdx/
 - Drop exporting symbols as the host tdx does.
---
 arch/x86/kvm/vmx/tdx.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index dbcc1ed80efa..b1c885ce8c9c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -14,6 +14,21 @@ static enum cpuhp_state tdx_cpuhp_state;
 
 static const struct tdx_sysinfo *tdx_sysinfo;
 
+/* TDX KeyID pool */
+static DEFINE_IDA(tdx_guest_keyid_pool);
+
+static int __used tdx_guest_keyid_alloc(void)
+{
+	return ida_alloc_range(&tdx_guest_keyid_pool, tdx_guest_keyid_start,
+			       tdx_guest_keyid_start + tdx_nr_guest_keyids - 1,
+			       GFP_KERNEL);
+}
+
+static void __used tdx_guest_keyid_free(int keyid)
+{
+	ida_free(&tdx_guest_keyid_pool, keyid);
+}
+
 static int tdx_online_cpu(unsigned int cpu)
 {
 	unsigned long flags;
-- 
2.34.1


