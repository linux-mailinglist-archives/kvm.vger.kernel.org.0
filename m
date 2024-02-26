Return-Path: <kvm+bounces-9639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35638866C54
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:33:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66C891C21A8B
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5839053398;
	Mon, 26 Feb 2024 08:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IDx2P+CM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C93A4F8A0;
	Mon, 26 Feb 2024 08:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936069; cv=none; b=dSqOeekH0NEBwzgZOKN4coGrYUFSB1k2fRXKU+88KopL6y2ykgVPV8GJUVAoq9ZswQ+0wxcsUuNe4+yFmtIl1IEh39OVvDB+cK9y/D6j+naWCboMBzijx1HTJxIeK2ICjWb9FbVs0SajJj9mEcJkxiXbE1HN7FD2+4Sq3Pv9kpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936069; c=relaxed/simple;
	bh=yEg4v544YC7e+UFPcUmTBeIBNiztK9idn0tOEopCeIQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RO8fhbNt8HbNSiAxWg8n3kylaNFvAuTD2V1rnRG7HWpzYdoOwtQf+6glab7e1vxfs1YHLjL+Kp3FIICltAYwZO5MPBfn86IJomtRMirm5cZyziBcFwYV0eFU4dXcYHyh0/XNVA7HhmBHWngpaYhHny1eOrNP8OU3BSJkt3tkFgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IDx2P+CM; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936067; x=1740472067;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yEg4v544YC7e+UFPcUmTBeIBNiztK9idn0tOEopCeIQ=;
  b=IDx2P+CMzhL++faYjGDve/xKCONFD+CCHyUyPO+Jh+lhNV/Z0Ey5CmwU
   QhZDfTe7TgjTin7CWgOjc0k7Gn9gWqsRZV2eBQcqV/6ZuzRBmHuzWv+yl
   oePP2kAzD6idPWo2OX0LhduJARg5SoDS5CwsdYgw2C7GntHxlLA1oWYvZ
   g2GUwaOX9nfPje50nI86tMs5FPxJ82ae/K5GX2YsyeYRop9tXMhukE6+G
   z1wDQhq84wOZa/OrzSgIQh1CGmdCDolbO8UKO9EZPcRBezHgDdj9G76aq
   QFGGa0ltqNQRf285gFeUSfhNX86fSPdAgAejIC5nHqBz+jkqMsHq8b71f
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="28631491"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="28631491"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6474342"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:42 -0800
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
Subject: [PATCH v19 015/130] KVM: Document KVM_MEMORY_MAPPING ioctl
Date: Mon, 26 Feb 2024 00:25:17 -0800
Message-Id: <b695d166f95992339cc1836e656387042454b1e9.1708933498.git.isaku.yamahata@intel.com>
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

Adds documentation of KVM_MEMORY_MAPPING ioctl.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v19:
- newly added
---
 Documentation/virt/kvm/api.rst | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 3ec0b7a455a0..667dc58f7d2f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6323,6 +6323,34 @@ a single guest_memfd file, but the bound ranges must not overlap).
 
 See KVM_SET_USER_MEMORY_REGION2 for additional details.
 
+4.143 KVM_MEMORY_MAPPING
+------------------------
+
+:Capability: KVM_CAP_MEMORY_MAPPING
+:Architectures: none
+:Type: vcpu ioctl
+:Parameters: struct kvm_memory_mapping(in/out)
+:Returns: 0 on success, <0 on error
+
+KVM_MEMORY_MAPPING populates guest memory without running vcpu.
+
+::
+
+  struct kvm_memory_mapping {
+	__u64 base_gfn;
+	__u64 nr_pages;
+	__u64 flags;
+	__u64 source;
+  };
+
+KVM_MEMORY_MAPPING populates guest memory in the underlying mapping. If source
+is not zero and it's supported (it depends on underlying technology), the guest
+memory content is populated with the source.  If nr_pages is large, it may
+return -EAGAIN and the values (base_gfn and nr_pages. source if not zero) are
+updated to point the remaining range.
+
+The "flags" field is reserved for future extensions and must be '0'.
+
 5. The kvm_run structure
 ========================
 
-- 
2.25.1


