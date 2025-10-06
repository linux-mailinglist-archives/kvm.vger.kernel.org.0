Return-Path: <kvm+bounces-59521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9056EBBDE10
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 13:36:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4D1D24EA297
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 11:36:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DB7A26A1D9;
	Mon,  6 Oct 2025 11:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jR9mlPVe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70282561AE
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 11:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759750600; cv=none; b=ce05n8ErYf8B4qW50mD0IBJUy4Ug+SEyqtG1mtMQMPfldKkmFH2SJhXgbSZf7MHLdGyzQvTFbhqRm3SQs+SbzIPgUq5ji46UUiyEPhfZeVYd3FeaAMDbJE22XBfKONju7x8un4UQiao5rP8hybkZJl9d6VM8DliAzG6Z7FVESEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759750600; c=relaxed/simple;
	bh=u7AbABXVJpoVa8AfrYjIbF/VUInx35JIGpjJhhZDflg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbTaRRh+9IehX10c5DZnAjoUz63MJVW9YrawJOPoAXDCzudfLJiQPCOEGpb9iOjR8NLiVW6sksOpVodhysK5uMKXRZkkYG4Ug9RKBofofESwWryh/qr5bDKxC7Vb29dTqi02cqAoq3zxGoJmJAP79dbz9pZo0cO9uFmROcboQfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jR9mlPVe; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759750599; x=1791286599;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u7AbABXVJpoVa8AfrYjIbF/VUInx35JIGpjJhhZDflg=;
  b=jR9mlPVe6cUw2oSSp6o5cavt4XrYPrVb9LhnXCmjg/2N9ipJmEPrMRFL
   aNz/9sULjdrrHXCYZrMFV7VHZFrracSlCiJWPwIOsDFEYW21dXSj827/0
   eL6leQcKGXhpfWXd1dOz2WnArwwik0qZ9MyMrmAek8iq/YicjscBlesUY
   QUcKnpcMp8Xf5JD42pWJgZHn2eiMl/815Jnxu5OFy6iTwU4l3G7Ebpb4R
   2kmIC1YEzH+YsZ8emTYIRWcuSs6/uw5uZi/vrYLqL1a9QXWlBYtTzVocO
   Cb8Q4eO3IA8c+GC9YeyJaeJm+n1uVN6dRQKANEMorro6EJ84gvZsFoOyQ
   g==;
X-CSE-ConnectionGUID: Ch853PG4RcmK2+P7BiVicA==
X-CSE-MsgGUID: iHGp11qXToe/g/efanm3kQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11573"; a="60958812"
X-IronPort-AV: E=Sophos;i="6.18,319,1751266800"; 
   d="scan'208";a="60958812"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 04:36:38 -0700
X-CSE-ConnectionGUID: sRuh1Oe9QNirJm5LaaIkog==
X-CSE-MsgGUID: NjOCJ/qYTzyVmAxjI/VFZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,319,1751266800"; 
   d="scan'208";a="210815134"
Received: from ettammin-mobl2.ger.corp.intel.com (HELO tlindgre-MOBL1..) ([10.245.246.151])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 04:36:30 -0700
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Dhaval Giani <dhaval.giani@amd.com>,
	Jon Grimm <Jon.Grimm@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Steven Price <steven.price@arm.com>,
	Anup Patel <anup@brainfault.org>,
	Samuel Ortiz <sameo@rivosinc.com>,
	=?UTF-8?q?Jakub=20R=C5=AF=C5=BEi=C4=8Dka?= <jakub.ruzicka@matfyz.cz>,
	=?UTF-8?q?J=C3=B6rg=20R=C3=B6del=20?= <joro@8bytes.org>,
	Vishal Annapurve <vannapurve@google.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Elena Reshetova <elena.reshetova@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Kishen Maloor <kishen.maloor@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Peter Fang <peter.fang@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	kvm@vger.kernel.org
Subject: [RFC PATCH 2/3] Documentation: kvm: Add KVM_IMPORT/EXPORT_MEMORY
Date: Mon,  6 Oct 2025 14:35:23 +0300
Message-ID: <20251006113524.1573116-3-tony.lindgren@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251006113524.1573116-1-tony.lindgren@linux.intel.com>
References: <20251006113524.1573116-1-tony.lindgren@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document KVM_IMPORT_MEMORY and KVM_EXPORT_MEMORY. To support live
migration of confidential computing guests, the hardware needs to export
the encrypted pages on the source and to import the encrypted pages on
the destination.

Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
---
 Documentation/virt/kvm/api.rst | 89 +++++++++++++++++++++++++++++++++-
 1 file changed, 88 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 31db949d3e44..dec73fd2c5bf 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6503,7 +6503,6 @@ the capability to be present.
 
 `flags` must currently be zero.
 
-
 4.144 KVM_MIGRATE_CMD
 ---------------------
 
@@ -6551,6 +6550,94 @@ The parameter related data structures are::
   @reserved - Reserved for future use
   @buf      - Userspace buffer for hardware specific data
 
+.. _KVM_IMPORT_MEMORY:
+
+4.145 KVM_IMPORT_MEMORY
+-----------------------
+
+:Capability: KVM_CAP_MIGRATION
+:Architectures: arm64, x86
+:Type: vm ioctl
+:Parameters: struct kvm_memory_transfer (in/out)
+:Returns: 0 on success, < 0 on error
+
+Allows userspace to request the hardware to import an array of memory pages from
+a userspace buffer.
+
+The memory may not be directly accessible to KVM because of encryption. For
+confidential computing, the guest memory is encrypted and only accessible to the
+guest.
+
+The parameter related data structures are::
+
+  struct kvm_transfer_buffer {
+	__u64 address;
+	__u32 size;
+	__u32 reserved;
+  };
+
+  @address  - Userspace buffer address
+  @size     - Size of the userspace buffer
+  @reserved - Reserved for future use
+
+  struct kvm_memory_transfer {
+	__u64 gfns;
+	__u32 nr_gfns;
+	__u16 id;
+	__u16 flags;
+	__u64 reserved;
+	struct kvm_transfer_buffer buf;
+  };
+
+  @gfns     - Userspace array of GFNs to import
+  @nr_gfns  - Number of GFNs
+  @id       - Optional hardware specific transfer ID
+  @flags    - Hardware specific flags
+  @reserved - Reserved for future use
+  @buf      - Userspace buffer to import memory from
+
+The hardware specific ID is used at least for TDX for the migration thread
+index.
+
+4.146 KVM_EXPORT_MEMORY
+-----------------------
+
+:Capability: KVM_CAP_MIGRATION
+:Architectures: arm64, x86
+:Type: vm ioctl
+:Parameters: struct kvm_memory_transfer (in/out)
+:Returns: 0 on success, < 0 on error
+
+Allows userspace to request the hardware to export an array of memory pages
+to a userspace buffer.
+
+The memory may not be directly accessible to KVM because of encryption. For
+confidential computing, the guest memory is encrypted and only accessible to the
+guest.
+
+The parameters are::
+
+  struct kvm_memory_transfer {
+	__u64 gfns;
+	__u32 nr_gfns;
+	__u16 id;
+	__u16 flags;
+	__u64 reserved;
+	struct kvm_transfer_buffer buf;
+  };
+
+  @gfns     - Userspace array of GFNs to export
+  @nr_gfns  - Number of GFNs
+  @id       - Optional hardware specific transfer ID
+  @flags    - Hardware specific flags
+  @reserved - Reserved for future use
+  @buf      - Userspace buffer to export memory to
+
+The hardware specific ID is used at least for TDX for the migration thread
+index.
+
+See also :ref:`KVM_IMPORT_MEMORY <KVM_IMPORT_MEMORY>`.
+
 .. _kvm_run:
 
 5. The kvm_run structure
-- 
2.43.0


