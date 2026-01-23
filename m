Return-Path: <kvm+bounces-68996-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wPfUCZeOc2l0xAAAu9opvQ
	(envelope-from <kvm+bounces-68996-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:07:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id DD5A57778E
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:07:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 333A6301C068
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BBB9371051;
	Fri, 23 Jan 2026 15:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E4EcoqV4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCA1362129;
	Fri, 23 Jan 2026 15:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769180438; cv=none; b=OYj455xCK6UeBVjjMKUN0agt5b838rMscY84gkSnKXkQnplhBfKWxRTmAlwke7w9AzxaL4PyUYNH6GaUwo67Ttq8Y3HWiLel7fhI2Wji3SNI/jPzCKQMi6NvUDlShiyzajHOjJvKU4gWgkCe6GKUf5hkD/pauSyQJVdFE9+3F6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769180438; c=relaxed/simple;
	bh=W/SuQAxt7ClBHx9qecLubHrb5FhNgT3NcUOt5cFlxEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lqg5uwXDWDgSo2o26aHysplLoHoxNDSZPo8DAqtjvmEAFKeRAT0Qp04pNdnuuRqZOWAQR3r34CEuW/Krc0WPrRlnr3hTngX/VERcVNI/3QMMi4H308S3I/FuKvSW9bMdQTjIO8toe1vtcIyTAQghFZlaC/FUu2Ye+otUocIGWeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E4EcoqV4; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769180436; x=1800716436;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W/SuQAxt7ClBHx9qecLubHrb5FhNgT3NcUOt5cFlxEc=;
  b=E4EcoqV4RQTQ3+xRB01hMkGGSkfwo8jJALjYvMAxSa1/1QgFQHT+2KCf
   +Zs3kVpatA/WbnQ0V/PuSP5YZOCAaeX4y/Eq53H7payXqfkPzacCLVSUL
   orH5/pMq+iTX9ANHGorgUMIjbY8pxaZofKNKHXt8nG4h62X2keRc5UxHr
   OQtAeY69yxFHyRn57LNWKxCtgyrZBWu9HOen0An2XyfIR5kIGTp57AKuT
   ToU7zBGOAdoBzW6qN4T/r0yATb8Mf7ZD32K5O1nMAhSi2llSPcfmI9J79
   UrtktWazz6Dn3hmIX43MyOviHQnlNhPlI7JIw3EZJVF9mXwMeD6K1dkDL
   Q==;
X-CSE-ConnectionGUID: zO6HZXIEQNOOIO+6uz+aTw==
X-CSE-MsgGUID: o92uHkHzRN2fArADy1Hk5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="70334496"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70334496"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:18 -0800
X-CSE-ConnectionGUID: 2XrvhoCXT7SVFEQgT9a3sA==
X-CSE-MsgGUID: AmhIpe1pTmaa59UY/q4DCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="237697190"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:18 -0800
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org
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
	Chao Gao <chao.gao@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3 20/26] x86/virt/seamldr: Do TDX per-CPU initialization after updates
Date: Fri, 23 Jan 2026 06:55:28 -0800
Message-ID: <20260123145645.90444-21-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260123145645.90444-1-chao.gao@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68996-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: DD5A57778E
X-Rspamd-Action: no action

After installing the new TDX module, each CPU should be initialized
again to make the CPU ready to run any other SEAMCALLs. So, call
tdx_cpu_enable() on all CPUs.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
 arch/x86/virt/vmx/tdx/seamldr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index 13c34e6378e0..ee672f381dd5 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -239,6 +239,7 @@ enum tdp_state {
 	TDP_START,
 	TDP_SHUTDOWN,
 	TDP_CPU_INSTALL,
+	TDP_CPU_INIT,
 	TDP_DONE,
 };
 
@@ -303,6 +304,9 @@ static int do_seamldr_install_module(void *seamldr_params)
 				scoped_guard(raw_spinlock, &seamldr_lock)
 					ret = seamldr_call(P_SEAMLDR_INSTALL, &args);
 				break;
+			case TDP_CPU_INIT:
+				ret = tdx_cpu_enable();
+				break;
 			default:
 				break;
 			}
-- 
2.47.3


