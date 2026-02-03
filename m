Return-Path: <kvm+bounces-70056-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kNX+GMQ9gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70056-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:26:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DB13BDD8D0
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:26:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 625573164C1A
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:21:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 430D53ED13F;
	Tue,  3 Feb 2026 18:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nE4cmgeC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1073E9F65;
	Tue,  3 Feb 2026 18:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142672; cv=none; b=GnQGwU1xivm+2J5jCdlS8TtczoJKi47yvGdgZZ8pDhlp05hwRIeK+PDvUmX1LsTLBDVSrreQgt/YXUj8a3NOYiF8grNWxiIpjCLuynvvX0PNbaI7B1DhnkXOBZk79eBRU5PY9mKhALrfg2IN9zu+JtDVa7V15HIr2272OPsIK8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142672; c=relaxed/simple;
	bh=JRZl22MrKBXrmWeEoctb6XWd0blFgFAn0h4yl+0mCos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjAAUaaMUlFIQXnOXi/owefz4xkVY8oOChxKjYPVO5KLY3sBmGlkiYdPzXCKZLfQZcnebU62pXl7uIc2iKqZq50dCpVUjmw4Khl6skxZJWGG2dY/dQcjPFlmNzqfezqUfnA8PCGeMWaTr4Q3ZIdiO6tQrNfXU4NJTqxmqM0Pdg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nE4cmgeC; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142670; x=1801678670;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JRZl22MrKBXrmWeEoctb6XWd0blFgFAn0h4yl+0mCos=;
  b=nE4cmgeCMTHidTWemDVK3WsqmNSpXRUROprEsPU59DLvkKkCEX6W6RlG
   VAszC9mogLiHjBb1dOLqflvZG4j153DejjMXNcnxj06lVKsTaaENcmU2o
   fQkhGpJlTxldqSyQJsqS3WMwJt62Bv9E9+gaD8JsmhsYW+ED/z3NlIMrH
   +/Ftl0CJm2flkfHWoUEWhwrleITF1u5Ze4CdkU7m/T8spkDVdJnGIAr3j
   A5Cc6pfvXULxvsUxzZplc8ZDBvgC8Js4Ber2JcQJNu+I+7TEzl3ONAdZK
   xaIFS1Yzmye0zFGHjwjr1ODhBTb+nD5trHazlHxZpWRN8/5h9HRhyH1d5
   g==;
X-CSE-ConnectionGUID: nDN4rU6wToGysktyUG1Psg==
X-CSE-MsgGUID: joht6PABS1mmOhNCs5/SqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="88745850"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="88745850"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:46 -0800
X-CSE-ConnectionGUID: d8TgeHvSQMqYv8fs6+dphw==
X-CSE-MsgGUID: PH0EyS4yT++7ioUQZhPpEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209605523"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:45 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 23/32] KVM: nVMX: Introduce module parameter for nested APIC timer virtualization
Date: Tue,  3 Feb 2026 10:17:06 -0800
Message-ID: <c210c32b8e8345c9265535ae9347678f679e7d83.1770116051.git.isaku.yamahata@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70056-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DB13BDD8D0
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Introduce a new module parameter, nested_apic_timer_virt, to control the
nested virtualization of the APIC timer in KVM.

The nested_apic_timer_virt parameter is set to true by default on processor
platforms that support APIC timer virtualization.  On platforms that do not
support this feature, the parameter will indicate that APIC timer
virtualization is not available.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/capabilities.h |  1 +
 arch/x86/kvm/vmx/nested.c       | 13 ++++++++++++-
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index f73a50c887ac..8d8beae4839a 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -15,6 +15,7 @@ extern bool __read_mostly enable_ept;
 extern bool __read_mostly enable_unrestricted_guest;
 extern bool __read_mostly enable_ept_ad_bits;
 extern bool __read_mostly enable_pml;
+extern bool __read_mostly enable_apic_timer_virt;
 extern int __read_mostly pt_mode;
 
 #define PT_MODE_SYSTEM		0
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a940f1d9ee83..fd2c3b11aabe 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -27,6 +27,10 @@ module_param_named(enable_shadow_vmcs, enable_shadow_vmcs, bool, S_IRUGO);
 static bool __ro_after_init warn_on_missed_cc;
 module_param(warn_on_missed_cc, bool, 0444);
 
+static bool __read_mostly enable_nested_apic_timer_virt = true;
+module_param_named(nested_apic_timer_virt, enable_nested_apic_timer_virt, bool,
+		   S_IRUGO);
+
 #define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
 
 /*
@@ -7485,13 +7489,20 @@ static void nested_vmx_setup_secondary_ctls(u32 ept_caps,
 static void nested_vmx_setup_tertiary_ctls(struct vmcs_config *vmcs_conf,
 					   struct nested_vmx_msrs *msrs)
 {
-	msrs->tertiary_ctls = vmcs_conf->cpu_based_3rd_exec_ctrl;
+	enable_nested_apic_timer_virt &= enable_apic_timer_virt;
 
+	msrs->tertiary_ctls = vmcs_conf->cpu_based_3rd_exec_ctrl;
 	msrs->tertiary_ctls &= TERTIARY_EXEC_GUEST_APIC_TIMER;
 
+	if (!enable_nested_apic_timer_virt)
+		msrs->tertiary_ctls &= ~TERTIARY_EXEC_GUEST_APIC_TIMER;
+
 	if (msrs->tertiary_ctls)
 		msrs->procbased_ctls_high |=
 			CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
+
+	if (!(msrs->tertiary_ctls & TERTIARY_EXEC_GUEST_APIC_TIMER))
+		enable_nested_apic_timer_virt = false;
 }
 
 static void nested_vmx_setup_misc_data(struct vmcs_config *vmcs_conf,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 76725f8dd228..bc4611629879 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -118,7 +118,7 @@ module_param(enable_ipiv, bool, 0444);
 
 module_param(enable_device_posted_irqs, bool, 0444);
 
-static bool __read_mostly enable_apic_timer_virt = true;
+bool __read_mostly enable_apic_timer_virt = true;
 module_param_named(apic_timer_virt, enable_apic_timer_virt, bool, 0444);
 
 /*
-- 
2.45.2


