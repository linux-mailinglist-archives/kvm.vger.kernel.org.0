Return-Path: <kvm+bounces-10659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92D5D86E735
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 18:30:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 359CE2824CD
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 17:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74C541798F;
	Fri,  1 Mar 2024 17:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UlWLgrlm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F285C9C;
	Fri,  1 Mar 2024 17:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709314185; cv=none; b=ABfXioAJ79p1ccdInbbgiAazYP20spCBQvMZa4S55sO2ARqxC401UxdF9S6UnZE2kDpJosAKgI9mKCxxDKoAq0KqTICiBlv/C43N512CiPMtnDQgKs75HC0KIg8KJXZ7zdYwC24sgprrQSMiT5OIbCzGFAr376mLEkL2qdVYpn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709314185; c=relaxed/simple;
	bh=xhAmNSgq/jNSfhesY71o3ouQLTaGpDQEc7g/WrW05mQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IgtjmitrE/fBiKQaVHb92vNZZTTMxsJCAg9jqT0urcPAPYRhMBFdlTmZNfHcPF1SYYmz7g/8XlTWUacR9WV4AUb38E869trn+vV9uguI0t9fjkFWt3LzIlU4xj8mpZ0koLSmk7I5MSCgKU11IbMF2MB4s9lZW/C/2RRkAG9M2vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UlWLgrlm; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709314183; x=1740850183;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xhAmNSgq/jNSfhesY71o3ouQLTaGpDQEc7g/WrW05mQ=;
  b=UlWLgrlm8LifINGPWfu408Yq3EElAdzbVvETQFv4XX3N4I+WlCHkeEfx
   ccgukcz/LVy1uN7FZhbXC+8SHowPsRj3apogfMxIMmwPxbTEE9/6rMFcA
   K+P9yXHxFPzN1CvSppQJlvo0U/8pe2ID5hpt137eMM/7lqMOGPCR+20xX
   hp3wc3YM8wIr/oG6vR6+W8pbFndqd3G5TZdPyK7NeCn5kWwYE76TskidS
   EkQkRvdkuT3f9I66rkHLhgABAbrWeC+oDD7P302j7vchrga1+FMivhlPD
   ospIIOuCdpIPCbiulV7wDao9dArSuOeMDg3PsGtCYMDX8XVfPlXm18gj6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11000"; a="6812378"
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="6812378"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 09:29:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="12946517"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 09:29:23 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>
Subject: [RFC PATCH 1/8] KVM: Document KVM_MAP_MEMORY ioctl
Date: Fri,  1 Mar 2024 09:28:43 -0800
Message-Id: <c50dc98effcba3ff68a033661b2941b777c4fb5c.1709288671.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1709288671.git.isaku.yamahata@intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Adds documentation of KVM_MAP_MEMORY ioctl.

It pre-populates guest memory. And potentially do initialized memory
contents with encryption and measurement depending on underlying
technology.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/api.rst | 36 ++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0b5a33ee71ee..33d2b63f7dbf 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6352,6 +6352,42 @@ a single guest_memfd file, but the bound ranges must not overlap).
 
 See KVM_SET_USER_MEMORY_REGION2 for additional details.
 
+4.143 KVM_MAP_MEMORY
+------------------------
+
+:Capability: KVM_CAP_MAP_MEMORY
+:Architectures: none
+:Type: vcpu ioctl
+:Parameters: struct kvm_memory_mapping(in/out)
+:Returns: 0 on success, <0 on error
+
+KVM_MAP_MEMORY populates guest memory without running vcpu.
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
+  /* For kvm_memory_mapping:: flags */
+  #define KVM_MEMORY_MAPPING_FLAG_WRITE         _BITULL(0)
+  #define KVM_MEMORY_MAPPING_FLAG_EXEC          _BITULL(1)
+  #define KVM_MEMORY_MAPPING_FLAG_USER          _BITULL(2)
+  #define KVM_MEMORY_MAPPING_FLAG_PRIVATE       _BITULL(3)
+
+KVM_MAP_MEMORY populates guest memory in the underlying mapping. If source is
+not zero and it's supported (depending on underlying technology), the guest
+memory content is populated with the source.  The flags field supports three
+flags: KVM_MEMORY_MAPPING_FLAG_WRITE, KVM_MEMORY_MAPPING_FLAG_EXEC, and
+KVM_MEMORY_MAPPING_FLAG_USER.  Which corresponds to fault code for kvm page
+fault to populate guest memory. write fault, fetch fault and user fault.
+When it returned, the input is updated.  If nr_pages is large, it may
+return -EAGAIN and update the values (base_gfn and nr_pages. source if not zero)
+to point the remaining range.
+
 5. The kvm_run structure
 ========================
 
-- 
2.25.1


