Return-Path: <kvm+bounces-70065-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oDHsMiM+gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70065-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:27:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 294FEDD920
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:27:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 00C9F30D563D
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEC1D3F0771;
	Tue,  3 Feb 2026 18:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ejK3WZQp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D243EFD03;
	Tue,  3 Feb 2026 18:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142678; cv=none; b=gtnSxPS+snTlCnvecMJjrbrZ0W1f6ZzqeKfxO6dMPANQY5A/+DOUJ3DWAa7a7ox2VdPMvHK1FrTcCeqsbCcIme4EZdqcIIRJIxaEe4rsIIfBXxxoNj0XkS1sh2f9usqJO9GT+Flk9XY7i1NHQDo46vs52H95N7gDdwjj/DKp9po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142678; c=relaxed/simple;
	bh=kPME7/YSCiLjgGM8a4soCxooFyr40ldcGoCCSis39ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDcofEIuGtwICjSLFjWcMqdRwfyN/ItW3p2CDD8XrX0sh3E2VJtcXs0uO2cg9VIw/5tjemiTSgQvTdRTzUNV0Ks5q2Io9Z520QS9VOE1uILXHdUh9CFwayksxKmHycenqtCzfqgf/Og5h/dRXaQYy9Gkg+q5FGcycfZAYxWbng0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ejK3WZQp; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142677; x=1801678677;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kPME7/YSCiLjgGM8a4soCxooFyr40ldcGoCCSis39ac=;
  b=ejK3WZQpY3n/PR4h3AK8gXIJNLnIiUjRY9Aa8EaGiPqwLBJgJZPUlyGR
   3XWekEXP0wuo0AGt73oG/qm/aLtcASgruxz51SwFRrkhXpAeckL+BAEsd
   2P50ghffOcUT7K71kaKm6G2AnU/K8DyUYzZBvBwX5YjeO2AEd5z/O2b6q
   S8DxnIiWK7iMvoMiL1sPzkYLBn6UTuB2Z3eDDEzEXOyQf1343VbdZn2ls
   Vp07brJc7WXyhJLlsO3SZxKDR4V41ZmNv/VKlmS7IGA21dzFAoos39orW
   ER9efoweN6XvFY2H47z9pizRFyXg01tYpc+R/YV3BSE1g+gC+dixtHOuH
   A==;
X-CSE-ConnectionGUID: 2fJ7IJ8qQ4yySXW9BtBDkw==
X-CSE-MsgGUID: Zhmc2xpzRHyAN3BWzncqfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="88745893"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="88745893"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:50 -0800
X-CSE-ConnectionGUID: azEcP9f/TQyeeTnrI1MIBQ==
X-CSE-MsgGUID: q/oKJxdrTDe16q/KXRNXIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209605567"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:49 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 32/32] Documentation: KVM: x86: Update documentation of struct vmcs12
Date: Tue,  3 Feb 2026 10:17:15 -0800
Message-ID: <f9a34bba7835360998169cd479ef7559de77ddad.1770116051.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1770116050.git.isaku.yamahata@intel.com>
References: <cover.1770116050.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70065-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: 294FEDD920
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Update struct vmcs12 in the documentation to match the current
implementation.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/x86/nested-vmx.rst | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/nested-vmx.rst b/Documentation/virt/kvm/x86/nested-vmx.rst
index ac2095d41f02..561fd0970f54 100644
--- a/Documentation/virt/kvm/x86/nested-vmx.rst
+++ b/Documentation/virt/kvm/x86/nested-vmx.rst
@@ -113,7 +113,14 @@ struct shadow_vmcs is ever changed.
 		u64 guest_pdptr3;
 		u64 host_ia32_pat;
 		u64 host_ia32_efer;
-		u64 padding64[8]; /* room for future expansion */
+		u64 vmread_bitmap;
+		u64 vmwrite_bitmap;
+		u64 vm_function_control;
+		u64 eptp_list_address;
+		u64 pml_address;
+		u64 encls_exiting_bitmap;
+		u64 tsc_multiplier;
+		u64 tertiary_vm_exec_control;
 		natural_width cr0_guest_host_mask;
 		natural_width cr4_guest_host_mask;
 		natural_width cr0_read_shadow;
@@ -217,6 +224,10 @@ struct shadow_vmcs is ever changed.
 		u16 host_fs_selector;
 		u16 host_gs_selector;
 		u16 host_tr_selector;
+		u16 guest_pml_index;
+		u16 virtual_timer_vector;
+		u64 guest_deadline;
+		u64 guest_deadline_shadow;
 	};
 
 
-- 
2.45.2


