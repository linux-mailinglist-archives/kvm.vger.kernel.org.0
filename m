Return-Path: <kvm+bounces-59520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 587A0BBDE0D
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 13:36:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EC1F84EA27F
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 11:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DE7F26A1D9;
	Mon,  6 Oct 2025 11:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XG+a4Mvm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D3D2561AE
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 11:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759750592; cv=none; b=abcIQB6M3tFLIJ7xzlZf4Y+c21CgBgJUeImZKM751sRYHOdmIN3pGCcHzQnxxx7TGw366Zz43PGIDybUWIRwZhgw/MDP2fPO0O46HGk7RYwELKvqpnBi9twS7/MDTWVmmZyJMrhf7CUJ0C9kzxLDQJsmxFsUTVfFrc426ZLv+tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759750592; c=relaxed/simple;
	bh=M6G5A31ZEq/JRJ2gj8m8NBBaQ5MZnXbzZYAYpBE7Os4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qM9rGAlfZlV1cPbqv8Lo4hzk/0Z0Pn5WKmwAMRUYlH4aIBzKgwhbta7FPZQdY29eceuaiP5/mVo2Wo6zmfGata0qENxG8NSGxD13GaZa4dQI+PH1q8hZO/E3juBfH9FSMDkm6tkBd25ay0S1zCf4ZdWwsnCF63GgLonT65L9yZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XG+a4Mvm; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759750591; x=1791286591;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M6G5A31ZEq/JRJ2gj8m8NBBaQ5MZnXbzZYAYpBE7Os4=;
  b=XG+a4Mvm280OyGJw5at4DAK03weeN2mIV7n4M4VTqeacjVykzsTtVQGw
   g5cDTlJZDwV4VjLT8CHjLZVx4C+RRshDskm0JOLFxRERW/fH0lwgX7L8c
   /i1XvbmVE0/xktZ0hwAUDDEh36GvyHVkvOAw3v5Ym0ArzKYcAX89TVFAi
   ujDtR2tVEZ8i5aBZxosHLZriZMkLYlMfAs9/TjD0iPCCuLOiBfBDL6HYT
   eew1kSJ720o0wSKWbPPli+fnRbkn1id/I8Lf7UZMNewfkUvJ6knleO9Zu
   gQJwebEdZqn79bNr1F01abNvCbOfqPAY4Oj9w8oO9bF45Vl7IryayrT/h
   g==;
X-CSE-ConnectionGUID: /fO+VYJBSd66G1IEjIFxrA==
X-CSE-MsgGUID: pcZB85T2S2ikTt7Jhj/Btg==
X-IronPort-AV: E=McAfee;i="6800,10657,11573"; a="60958776"
X-IronPort-AV: E=Sophos;i="6.18,319,1751266800"; 
   d="scan'208";a="60958776"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 04:36:30 -0700
X-CSE-ConnectionGUID: qzKW3yIKSCS6rjJQNR88cw==
X-CSE-MsgGUID: MizBEneTQRSQCJ+LDXpaVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,319,1751266800"; 
   d="scan'208";a="210815083"
Received: from ettammin-mobl2.ger.corp.intel.com (HELO tlindgre-MOBL1..) ([10.245.246.151])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 04:36:21 -0700
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
Subject: [RFC PATCH 1/3] Documentation: kvm: Add KVM_MIGRATE_CMD
Date: Mon,  6 Oct 2025 14:35:22 +0300
Message-ID: <20251006113524.1573116-2-tony.lindgren@linux.intel.com>
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

Document KVM_MIGRATE_CMD. To support live migration of confidential
computing guests, the hardware may need to pass migration command related
data between the source and destination. For confidential computing, the
migration command related data is not accessible to KVM.

Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
---
 Documentation/virt/kvm/api.rst | 47 ++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6ae24c5ca559..31db949d3e44 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6504,6 +6504,53 @@ the capability to be present.
 `flags` must currently be zero.
 
 
+4.144 KVM_MIGRATE_CMD
+---------------------
+
+:Capability: KVM_CAP_MIGRATION
+:Architectures: arm64, x86
+:Type: vm ioctl
+:Parameters: struct kvm_migrate_cmd (in/out)
+:Returns: 0 on success, < 0 on error
+
+Allows userspace to send migration commands to the hardware.
+
+For confidential computing, the migration commands may use encrypted data
+that needs to be passed between the source and destination hardware. The
+hardware may also require specific coordination steps during migration that
+must be triggered at precise points in the migration process.
+
+The parameter related data structures are::
+
+  #define KVM_MIGRATE_PREPARE		0
+  #define KVM_MIGRATE_SETUP		1
+  #define KVM_MIGRATE_TOKEN		2
+  #define KVM_MIGRATE_SOURCE_BLACKOUT	3
+  #define KVM_MIGRATE_ABORT		4
+  #define KVM_MIGRATE_FINISH		5
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
+  struct kvm_migrate_cmd {
+	__u16 command;
+	__u16 flags;
+	__u32 reserved;
+	struct kvm_transfer_buffer buf;
+  };
+
+  @command  - One of the defined KVM_MIGRATE commands
+  @flags    - Hardware specific flags
+  @reserved - Reserved for future use
+  @buf      - Userspace buffer for hardware specific data
+
 .. _kvm_run:
 
 5. The kvm_run structure
-- 
2.43.0


