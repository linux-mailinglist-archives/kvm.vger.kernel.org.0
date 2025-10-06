Return-Path: <kvm+bounces-59522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 32F16BBDE1C
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 13:37:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D093A4ECDB7
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 11:36:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6BD4271441;
	Mon,  6 Oct 2025 11:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PEKKradh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FA52652AF
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 11:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759750609; cv=none; b=O0aqn4wHeHfAMsvf3crssehnKDYfU+2MgCLvkZ50zTipx+wlWiDCFrSDCzpIltFKr0csFMiYxPomIhyLOx+BckuphImMOQOTnJcL6hOwDkZO0LzbRXqMyZf3oJbG1l0K2vuLENpxf25R9Z3VROVvv/4k0tnnNM4Wug0P75jRry4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759750609; c=relaxed/simple;
	bh=5LDmOHMBjzdcpnwpkWo8D7EbuujFeN/ylo71ZsTW00Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGET1HOHWZe8GvSlNAI3e3XF/dKTZ+Mq4eSGtsuzKoEHleH/obDlUZ4H8BSNqpoURrmBQue2b8JZNLY6ZDteICV3HbRxm+IKqL4N4jMTx+5GWpphqwnMGghPZAD48aJ8kAR4NLANsCb6IoljnwEjHBITxW2Nw8pJgpUXn6Gly3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PEKKradh; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759750608; x=1791286608;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5LDmOHMBjzdcpnwpkWo8D7EbuujFeN/ylo71ZsTW00Y=;
  b=PEKKradhnareuUOJVYEq3D6NMzSkaey1TB+4furp8q+sbht+O1SGBTJS
   ndXblheepNdri/p2n2BxCPhUK618p6DqJOEvaxmYBNifyJTTBlveh2sip
   UfXCzthkNcWMhbeopwP4KVtV6k4HXZLJeEL5LglkoYDb61EPLpkg8h1h1
   aCAsQZxE6u0ap28v6i+3hUDlWwpYh1h1aHhO9SagEdDMTtNdn3vSOhUUc
   P9xQTTdsxw6LCGJzk+ckU3PdL+ob3LSPmk8HemeuxsUTFG+2889GM9pEV
   iw2gdHsB6d0cCgcUYZeCyh5dYwjJnWrDchutgJWA0ZpdH4ZZeYatsYric
   Q==;
X-CSE-ConnectionGUID: Xo94T5fMTIeuTn0q/6Xoeg==
X-CSE-MsgGUID: fp792lL/RPeXCb81JlxWVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11573"; a="73275985"
X-IronPort-AV: E=Sophos;i="6.18,319,1751266800"; 
   d="scan'208";a="73275985"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 04:36:47 -0700
X-CSE-ConnectionGUID: nZt/8dBKRiuljGgDzrIC2A==
X-CSE-MsgGUID: /KaBrzlcRqGpYru5mVq3Qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,319,1751266800"; 
   d="scan'208";a="210815175"
Received: from ettammin-mobl2.ger.corp.intel.com (HELO tlindgre-MOBL1..) ([10.245.246.151])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 04:36:39 -0700
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
Subject: [RFC PATCH 3/3] Documentation: kvm: Add KVM_IMPORT/EXPORT_VCPU
Date: Mon,  6 Oct 2025 14:35:24 +0300
Message-ID: <20251006113524.1573116-4-tony.lindgren@linux.intel.com>
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

Document KVM_IMPORT_VCPU and KVM_EXPORT_VCPU. To support live migration of
confidential computing guests, the hardware needs to export the encrypted
VCPU state on the source and to import the encrypted VCPU state on the
destination.

Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
---
 Documentation/virt/kvm/api.rst | 69 ++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index dec73fd2c5bf..d9499e3b461a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6638,6 +6638,75 @@ index.
 
 See also :ref:`KVM_IMPORT_MEMORY <KVM_IMPORT_MEMORY>`.
 
+.. _KVM_IMPORT_VCPU:
+
+4.147 KVM_IMPORT_VCPU
+---------------------
+
+:Capability: KVM_CAP_MIGRATION
+:Architectures: arm64, x86
+:Type: vcpu ioctl
+:Parameters: struct kvm_vcpu_transfer (in/out)
+:Returns: 0 on success, < 0 on error
+
+Allows userspace to request the hardware to import a VCPU state from a userspace
+buffer.
+
+The VCPU state may not be directly accessible to KVM because of encryption. For
+confidential computing, the VCPU state is encrypted and only accessible to the
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
+  struct kvm_vcpu_transfer {
+        __u32 flags;
+        __u32 reserved;
+	struct kvm_transfer_buffer buf;
+  };
+
+  @flags    - Hardware specific flags
+  @reserved - Reserved for future use
+  @buf      - Userspace buffer to import VCPU state from
+
+4.148 KVM_EXPORT_VCPU
+---------------------
+:Capability: KVM_CAP_MIGRATION
+:Architectures: arm64, x86
+:Type: vcpu ioctl
+:Parameters: struct kvm_vcpu_transfer (in/out)
+:Returns: 0 on success, < 0 on error
+
+Allows userspace to request the hardware to export a VCPU state to a userspace
+buffer.
+
+The VCPU state may not be directly accessible to KVM because of encryption. For
+confidential computing, the VCPU state is encrypted and only accessible to the
+guest.
+
+The parameters are::
+
+  struct kvm_vcpu_transfer {
+        __u32 flags;
+        __u32 reserved;
+	struct kvm_transfer_buffer buf;
+  };
+
+  @flags    - Hardware specific flags
+  @reserved - Reserved for future use
+  @buf      - Userspace buffer to export VCPU state to
+
+See also :ref:`KVM_IMPORT_VCPU <KVM_IMPORT_VCPU>`.
+
 .. _kvm_run:
 
 5. The kvm_run structure
-- 
2.43.0


