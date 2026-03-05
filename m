Return-Path: <kvm+bounces-72920-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iOBnOSLDqWl3EQEAu9opvQ
	(envelope-from <kvm+bounces-72920-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:53:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id D2741216978
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:53:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9657E306C02C
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:49:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80FF647D957;
	Thu,  5 Mar 2026 17:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EWldZcfF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4263B4508F2;
	Thu,  5 Mar 2026 17:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732702; cv=none; b=S5PXclRS07i1tcrdiaW9mxF8lvc9GCN56V5v7xhkWl5slsuUwVKVb0kbX/o8jL8YmeSjzus/TEf6GHuY+ydcpDloHh9ZSKQMZEbcTuUB022ZMGf7sOficz7ca/CY8kj1Y8ESmKXB5tKA8ySnkeVqehrUQ9ZaSLGUjNyvZDQRZs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732702; c=relaxed/simple;
	bh=nVMEQc7hnfHWhWlWMR74SIkVL/5f832Ezi9L3urEKwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKwnJ5Iu07P2AmXMISBVHpzspEGuSXf/rcsdbiUC0JKP1CkK1fb52ZIzE4b2Eb+cNgGsnTVS27vCinrjl6CnTqSFTyHJ92G4iMwfVAyYVi21lRVsx0jC2Nu0WES4xtt1Bc7oBFFJXYuKXjhQ97/B/AoKNyDxOq5z1JEYr/LfBx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EWldZcfF; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732697; x=1804268697;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nVMEQc7hnfHWhWlWMR74SIkVL/5f832Ezi9L3urEKwQ=;
  b=EWldZcfFCwb5lwfIgt/nwJkTIObHkTvRGstfgYpeYb/KKcCbFhB5J5nM
   Idd3w5ceAIC8jko1c783je9i9TSnYYkY8FbfDAu8YJQxPrDwTAtQIOmk9
   TPrz5gnhak152xFs4rKVq5t8BkD6TydOQxHGCBak7riElYqTlejmOouDP
   E95GSzml/aipFdA5xgNvuAdkIIsdUjs62cWTZdpC5lAbA++Snd8LqcMeW
   8xGx767HsL8nLhw8rqLhMnnnVsPa3izGwaOo9ryRPqyzduOYQ46MdhfK9
   C/jH3e7h9qlzfW5kPtnhqfhq8YR7POBJHFNfz+YE6SepPQ/kKZQKzS1gv
   w==;
X-CSE-ConnectionGUID: TKn/zxSPRJunDoR9VUpbBw==
X-CSE-MsgGUID: iuIaOAMnR8C/Wa5StAwkPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="77701158"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="77701158"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:57 -0800
X-CSE-ConnectionGUID: 3s/l5F0/Q0GPKHoKEWfkzg==
X-CSE-MsgGUID: j36PFEJyQA6UkUyDpCRJWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="256647704"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:57 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 36/36] Documentation: KVM: x86: Update documentation of struct vmcs12
Date: Thu,  5 Mar 2026 09:44:16 -0800
Message-ID: <439849b2347a9352ab5767d0a78d9273fd20e407.1772732517.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1772732517.git.isaku.yamahata@intel.com>
References: <cover.1772732517.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D2741216978
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72920-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Update struct vmcs12 in the documentation to match the current
implementation.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/x86/nested-vmx.rst | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/nested-vmx.rst b/Documentation/virt/kvm/x86/nested-vmx.rst
index ac2095d41f02..0269a89a1beb 100644
--- a/Documentation/virt/kvm/x86/nested-vmx.rst
+++ b/Documentation/virt/kvm/x86/nested-vmx.rst
@@ -113,7 +113,15 @@ struct shadow_vmcs is ever changed.
 		u64 guest_pdptr3;
 		u64 host_ia32_pat;
 		u64 host_ia32_efer;
-		u64 padding64[8]; /* room for future expansion */
+		u64 host_ia32_perf_global_ctrl;
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
@@ -217,6 +225,10 @@ struct shadow_vmcs is ever changed.
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


