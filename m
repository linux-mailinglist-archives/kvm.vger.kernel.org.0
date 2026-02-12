Return-Path: <kvm+bounces-70985-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gIhLKSznjWkm8gAAu9opvQ
	(envelope-from <kvm+bounces-70985-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:43:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A939D12E633
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:43:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id EFC813066AF0
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 14:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D81C35E551;
	Thu, 12 Feb 2026 14:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YNuZvhIO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBBF364E85;
	Thu, 12 Feb 2026 14:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770906994; cv=none; b=g0UQkc7oajp6RsKb2FtWrWG7ZLl6DD2Jc34dFqnZvGEhdeTGeB95nvGtn/YMhbK8fogXyFaq/e83Le32xmIv7/LJHPHKdYQ/ukEDNRFidTDOF8eLplWeTncnJ/LMoA5HKoJqWMuXd5vWO1hgtB/4wkRNWw75cBUWpefk1eLXiJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770906994; c=relaxed/simple;
	bh=OdcMPe5LBKXvJM6VM5nGyaL81TXyUOMDL3aqYnWqntw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rv5FcKk5plAHG/J49Wbh44QSTjzFTLRrx1eNrk6eKTfd4F8v23NAUErr63tSOfBpgY2wVPjM9vkxKmG9sM1MVicAqF90U1Fw8JSs70AmCkjkTCo1q4Rtcxjyd6f1HLs0SeBk/QIgQ7FP9v9LVYwCWEO0lOY7vUF1n3Cp+srSVB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YNuZvhIO; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770906993; x=1802442993;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OdcMPe5LBKXvJM6VM5nGyaL81TXyUOMDL3aqYnWqntw=;
  b=YNuZvhIOCAKcoVvIAF/L/PQhXiZUI+3PSXezI3sAsVM6aOzoRv+PVRAt
   /L00vF5zqjrxXg2UmvURgFmkv2WY9cCJRiTmqao5ucYnKp7TWxrSUHpWI
   CemxrnpdMqVu3qjIOcoO5rUTi5avLhO5UOp726//yeNAXqKLOP4tFlzLO
   MqPIoygewBzC9FxQjH2qfN8xUNPY2eeOaQ52PXCe1MRumGfI4iXexIp5K
   +hbOylS+8JypdOaPKGyKF4E0sSEPuyCm5AEKgA5OeqQrkNOWOlc7kQYRw
   vfakLClp7E+lvxmDEDM1CBKWmF16O4/vdbvzVkQxZ73Yz9eFK1/ASKmnW
   Q==;
X-CSE-ConnectionGUID: 7zY7k80qQaCKTBbPVtcR0g==
X-CSE-MsgGUID: NnvF9AEXRYiyxr6iAbr6IA==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="89662929"
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="89662929"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:36:32 -0800
X-CSE-ConnectionGUID: YFDFfVwWSvmf2xioQY1d2A==
X-CSE-MsgGUID: Z8REfhSQRTKBsgdkhWUnJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="211428312"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:36:31 -0800
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-doc@vger.kernel.org
Cc: reinette.chatre@intel.com,
	ira.weiny@intel.com,
	kai.huang@intel.com,
	dan.j.williams@intel.com,
	yilun.xu@linux.intel.com,
	sagis@google.com,
	vannapurve@google.com,
	paulmck@kernel.org,
	nik.borisov@suse.com,
	zhenzhong.duan@intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com,
	kas@kernel.org,
	dave.hansen@linux.intel.com,
	vishal.l.verma@intel.com,
	binbin.wu@linux.intel.com,
	tony.lindgren@linux.intel.com,
	Chao Gao <chao.gao@intel.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v4 23/24] x86/virt/tdx: Document TDX Module updates
Date: Thu, 12 Feb 2026 06:35:26 -0800
Message-ID: <20260212143606.534586-24-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212143606.534586-1-chao.gao@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70985-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[28];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: A939D12E633
X-Rspamd-Action: no action

Document TDX Module updates as a subsection of "TDX Host Kernel Support" to
provide background information and cover key points that developers and
users may need to know, for example:

 - update is done in stop_machine() context
 - update instructions and results
 - update policy and tooling

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 Documentation/arch/x86/tdx.rst | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/Documentation/arch/x86/tdx.rst b/Documentation/arch/x86/tdx.rst
index 61670e7df2f7..01ae560c7f66 100644
--- a/Documentation/arch/x86/tdx.rst
+++ b/Documentation/arch/x86/tdx.rst
@@ -99,6 +99,40 @@ initialize::
 
   [..] virt/tdx: module initialization failed ...
 
+TDX Module Runtime Updates
+--------------------------
+
+The TDX architecture includes a persistent SEAM loader (P-SEAMLDR) that
+runs in SEAM mode separately from the TDX Module. The kernel can
+communicate with P-SEAMLDR to perform runtime updates of the TDX Module.
+
+During updates, the TDX Module becomes unresponsive to other TDX
+operations. To prevent components using TDX (such as KVM) from experiencing
+unexpected errors during updates, updates are performed in stop_machine()
+context.
+
+TDX Module updates have complex compatibility requirements; the new module
+must be compatible with the current CPU, P-SEAMLDR, and running TDX Module.
+Rather than implementing complex module selection and policy enforcement
+logic in the kernel, userspace is responsible for auditing and selecting
+appropriate updates.
+
+Updates use the standard firmware upload interface. See
+Documentation/driver-api/firmware/fw_upload.rst for detailed instructions
+
+Successful updates are logged in dmesg:
+  [..] virt/tdx: version 1.5.20 -> 1.5.24
+
+If updates failed, running TDs may be killed and further TDX operations may
+be not possible until reboot. For detailed error information, see
+Documentation/ABI/testing/sysfs-devices-faux-tdx-host.
+
+Given the risk of losing existing TDs, userspace should verify that the update
+is compatible with the current system and properly validated before applying it.
+A reference userspace tool that implements necessary checks is available at:
+
+  https://github.com/intel/confidential-computing.tdx.tdx-module.binaries
+
 TDX Interaction to Other Kernel Components
 ------------------------------------------
 
-- 
2.47.3


