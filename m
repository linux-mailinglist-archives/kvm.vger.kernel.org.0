Return-Path: <kvm+bounces-14157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 894D68A02D9
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 00:08:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17EF01F234E8
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 22:08:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDBA2190666;
	Wed, 10 Apr 2024 22:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iP4j2Wcn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49100184102;
	Wed, 10 Apr 2024 22:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712786877; cv=none; b=suoUHNlysQhBNqBXuMteQYB0m3zHXudfVSSRWDJUsVf5Th05t5iXlzd4VAiAFQDWEfRSFwRnRmsZAyTDn4HECbNmN8G938/yIbHtlTfDgY7wpKM8gKHkkmis/cqIgAl1ynjySpmleHD+UA/GGhD8f6z9dinhKixtsZVx+NKsCxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712786877; c=relaxed/simple;
	bh=6zo9q44VDWHNQpisy/DUoH9d+K7FwbxtL1YxaN+nx9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWY47GoJ19gs22kHGdtDvhwdaHIJg/MI1rrtydRzIi9960j3hcbNG0GCrGnj0elVa5+LkaoHM/jtQ2c2kHhwb64i8PKhed7yeN7T0a5T3aseOFroKs1X2Q/UKUQ3alR/g5+Se2P466BXaXg5tXTNGE/jJaK9p7bpX4+BId4cMrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iP4j2Wcn; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712786876; x=1744322876;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6zo9q44VDWHNQpisy/DUoH9d+K7FwbxtL1YxaN+nx9Y=;
  b=iP4j2Wcn67AtWEJvGDb3oOfn+e+JgJ4QhecUL7uSkWQHISD2jT+g+LD2
   QBa+kIY6iu4Fx0cgoEHp7HFq3n9CybIYWMtJzCqPxXK4das98aXUreO0g
   wdQYEpfn+BGm5mpPmvq8reuT53owovBEl9cV7PigzShCqL4HyK1yUS55l
   Q5KFC4InPhN0sIZAqRVb0qAR6ckQWusU8pr4Jm9rihKifzLqD+f2IdWox
   pc6nahqxyNaUPXaam9L0z8QLb52JIZhATkdaWMMOGpJTTYWQk0Vp53pdk
   13IVMDwQxXaXcTt3VMqp69FrNXUPNEezMLFX8NpjoqLrUr2KMHyuX9kQO
   w==;
X-CSE-ConnectionGUID: Mpj7y31QRie0GYv8TWQpsA==
X-CSE-MsgGUID: e4lawNIbTI2hY7lLkLcPPw==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="8041105"
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="8041105"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 15:07:53 -0700
X-CSE-ConnectionGUID: uYlNVSKcQSyPKHp3AC56Zg==
X-CSE-MsgGUID: av2ztQZTQJC3DhZn+piJiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="25476294"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 15:07:52 -0700
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 01/10] KVM: Document KVM_MAP_MEMORY ioctl
Date: Wed, 10 Apr 2024 15:07:27 -0700
Message-ID: <9a060293c9ad9a78f1d8994cfe1311e818e99257.1712785629.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <cover.1712785629.git.isaku.yamahata@intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Adds documentation of KVM_MAP_MEMORY ioctl. [1]

It populates guest memory.  It doesn't do extra operations on the
underlying technology-specific initialization [2].  For example,
CoCo-related operations won't be performed.  Concretely for TDX, this API
won't invoke TDH.MEM.PAGE.ADD() or TDH.MR.EXTEND().  Vendor-specific APIs
are required for such operations.

The key point is to adapt of vcpu ioctl instead of VM ioctl.  First,
populating guest memory requires vcpu.  If it is VM ioctl, we need to pick
one vcpu somehow.  Secondly, vcpu ioctl allows each vcpu to invoke this
ioctl in parallel.  It helps to scale regarding guest memory size, e.g.,
hundreds of GB.

[1] https://lore.kernel.org/kvm/Zbrj5WKVgMsUFDtb@google.com/
[2] https://lore.kernel.org/kvm/Ze-TJh0BBOWm9spT@google.com/

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v2:
- Make flags reserved for future use. (Sean, Michael)
- Clarified the supposed use case. (Kai)
- Dropped source member of struct kvm_memory_mapping. (Michael)
- Change the unit from pages to bytes. (Michael)
---
 Documentation/virt/kvm/api.rst | 52 ++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index f0b76ff5030d..6ee3d2b51a2b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6352,6 +6352,58 @@ a single guest_memfd file, but the bound ranges must not overlap).
 
 See KVM_SET_USER_MEMORY_REGION2 for additional details.
 
+4.143 KVM_MAP_MEMORY
+------------------------
+
+:Capability: KVM_CAP_MAP_MEMORY
+:Architectures: none
+:Type: vcpu ioctl
+:Parameters: struct kvm_memory_mapping (in/out)
+:Returns: 0 on success, < 0 on error
+
+Errors:
+
+  ========== =============================================================
+  EINVAL     invalid parameters
+  EAGAIN     The region is only processed partially.  The caller should
+             issue the ioctl with the updated parameters when `size` > 0.
+  EINTR      An unmasked signal is pending.  The region may be processed
+             partially.
+  EFAULT     The parameter address was invalid.  The specified region
+             `base_address` and `size` was invalid.  The region isn't
+             covered by KVM memory slot.
+  EOPNOTSUPP The architecture doesn't support this operation. The x86 two
+             dimensional paging supports this API.  the x86 kvm shadow mmu
+             doesn't support it.  The other arch KVM doesn't support it.
+  ========== =============================================================
+
+::
+
+  struct kvm_memory_mapping {
+	__u64 base_address;
+	__u64 size;
+	__u64 flags;
+  };
+
+KVM_MAP_MEMORY populates guest memory with the range, `base_address` in (L1)
+guest physical address(GPA) and `size` in bytes.  `flags` must be zero.  It's
+reserved for future use.  When the ioctl returns, the input values are updated
+to point to the remaining range.  If `size` > 0 on return, the caller should
+issue the ioctl with the updated parameters.
+
+Multiple vcpus are allowed to call this ioctl simultaneously.  It's not
+mandatory for all vcpus to issue this ioctl.  A single vcpu can suffice.
+Multiple vcpus invocations are utilized for scalability to process the
+population in parallel.  If multiple vcpus call this ioctl in parallel, it may
+result in the error of EAGAIN due to race conditions.
+
+This population is restricted to the "pure" population without triggering
+underlying technology-specific initialization.  For example, CoCo-related
+operations won't perform.  In the case of TDX, this API won't invoke
+TDH.MEM.PAGE.ADD() or TDH.MR.EXTEND().  Vendor-specific uAPIs are required for
+such operations.
+
+
 5. The kvm_run structure
 ========================
 
-- 
2.43.2


