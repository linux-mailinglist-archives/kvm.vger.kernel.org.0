Return-Path: <kvm+bounces-72912-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UNLsNtrDqWm2EQEAu9opvQ
	(envelope-from <kvm+bounces-72912-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:56:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E13C7216A15
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:56:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3907C3042455
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:48:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C0A04301D9;
	Thu,  5 Mar 2026 17:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RPbYZlkA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9423EB7E6;
	Thu,  5 Mar 2026 17:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732692; cv=none; b=lmgh4NYZZfUTnrR1ISA+XvZKALdrCSVSP6B32Zj8QrYhI/Nff0oMXams5Y7vLPeW8obsxwd9rxx+qHKeiOWcxC1+pcjvy0Y0IgXJ7VgfIiiAmUzwDxbQN5QyoZ1ISRXxKduTYPXO8aUwXvHn4xcuOz8m0zn/46NMA6Qzf4GCpZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732692; c=relaxed/simple;
	bh=yBvXSCWCFU+Hikr0EvHDTy04mJGDwR9u1MTzGHv1i38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOEWkaFSpBIsk4R/XbEjNNIV6PJnWOXvKR4VOpqcrv9hOzcPlQjZiw+Q8R5kXUS3xZMKYDMu0AnpCDKIxb5RK+WOQkvnowAPASJJYIFaARz6ycx+O6q9/ILprpcgbnnXdBpfOqYl18pkDB3XykYHKaErJkS72vXiOJmo0024IAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RPbYZlkA; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732691; x=1804268691;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yBvXSCWCFU+Hikr0EvHDTy04mJGDwR9u1MTzGHv1i38=;
  b=RPbYZlkAYYufAmWA33fCI77A4j1SZi5IQLtOYMgXfrbvFn7aED5bSU/3
   Qlmeodpdkg9thLkqqtRZ7rYYIWnGp0Ei1cXiIDFKgVWde0qmKEeC577nC
   5csDaZYEuLA1Shtav54uPVYiAmagi/Orfp8MGKwmgYp6QAvwthDyRhLI3
   IDF7y1iL7ar3G9YdMsfKIUKWsnGHS9eV2rojT/0bjTzC0l+Gkpn99JClV
   ksc80bfowcQXqK/m/sojJUPXHx1UzCJ5S2hVXz3GOwsOyQtZ0ZUo87lIr
   6dbPG+QUOaDg8gTlgiLmhS2s3+nkq4STTEOoSuf+8j3zuBaOCzJSttjSq
   A==;
X-CSE-ConnectionGUID: bZQCNbf/THS2IaB+h77cwQ==
X-CSE-MsgGUID: DuGRrEjHT/SDTMSK+kPXQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="85301952"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="85301952"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:47 -0800
X-CSE-ConnectionGUID: fYxSK8FxQNKPL88aIDF7EA==
X-CSE-MsgGUID: syGH3bWwQOCnRLiU4dfKmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="222896521"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:45 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 24/36] KVM: nVMX: Introduce module parameter for nested APIC timer virtualization
Date: Thu,  5 Mar 2026 09:44:04 -0800
Message-ID: <f892652a926d714fb6c2e35c1fb84ded519751be.1772732517.git.isaku.yamahata@intel.com>
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
X-Rspamd-Queue-Id: E13C7216A15
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72912-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org]
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
Changes:
v1 -> v2:
- use 0444 instead of S_IRUGO.
---
 arch/x86/kvm/vmx/capabilities.h |  1 +
 arch/x86/kvm/vmx/nested.c       | 13 ++++++++++++-
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 8d67be77f02c..861334e15c01 100644
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
index 3cd29b005afe..60c7256298ce 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -27,6 +27,10 @@ module_param_named(enable_shadow_vmcs, enable_shadow_vmcs, bool, S_IRUGO);
 static bool __ro_after_init warn_on_missed_cc;
 module_param(warn_on_missed_cc, bool, 0444);
 
+static bool __read_mostly enable_nested_apic_timer_virt = true;
+module_param_named(nested_apic_timer_virt, enable_nested_apic_timer_virt, bool,
+		   0444);
+
 #define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
 
 /*
@@ -7453,13 +7457,20 @@ static void nested_vmx_setup_secondary_ctls(u32 ept_caps,
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
index 0271514162df..4d5414af750b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -119,7 +119,7 @@ module_param(enable_ipiv, bool, 0444);
 
 module_param(enable_device_posted_irqs, bool, 0444);
 
-static bool __read_mostly enable_apic_timer_virt = true;
+bool __read_mostly enable_apic_timer_virt = true;
 module_param_named(apic_timer_virt, enable_apic_timer_virt, bool, 0444);
 
 /*
-- 
2.45.2


