Return-Path: <kvm+bounces-72922-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6K81I/bEqWknEgEAu9opvQ
	(envelope-from <kvm+bounces-72922-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 19:01:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 164D5216B9E
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 19:01:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0AC2131C0227
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 988AB3D3CE9;
	Thu,  5 Mar 2026 17:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kfXnihBd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1C847DF97;
	Thu,  5 Mar 2026 17:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732706; cv=none; b=kt4wOkwVUz2YNeol9++RRxQaUhQ8IkEbU9m8nhSPllwl1+k+vZd4cOmXrdqbfUJrZ9W0yzAU9lSmwl/CyP/LXx634YFFTosETOVNnVYUOG9W6hWEu+SGfaY8PUzX5il4FU0qvBRsf7Y4xHf/E+EJdxItBd8ywVr9+FFTVwSlthY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732706; c=relaxed/simple;
	bh=8YJ2FKnXboCtX8fNqYAUAygCHVrbqcpCQXjFPwTg67o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIgD8YC7g90I5VDaaW3Gn2XR/MH5NLDFyOzTf02dLwnVEwlRrYq3ea7TL8CajDin6x/CNSQj2F0dlRbKw5G0tA6AWmeCG9Zj1ZH6TM7Uh402FeC7mF7nt5y89CQ3Zem0d11HD5BriyawSNBgmuyJi0B89x6tSz2FbFqeumc2bVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kfXnihBd; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732705; x=1804268705;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8YJ2FKnXboCtX8fNqYAUAygCHVrbqcpCQXjFPwTg67o=;
  b=kfXnihBdfugpRXLpHtEOTTJMInUZp2LWIayc+zp5x8eqfu4fmq4S53Ee
   K1aPxzcH+XaCaUO5ZA6ZALQJoGgMkt/D+XQQhNWVRosrGrp72Vfo9UxxG
   QJiRfZDNh1ARbFOPCfjbw8wbDpAWK/1z6u71K8A26tyASrSM75tnyO8R8
   BFo387nIdS+DvFkG+VmMUg9dlcyWfnT/y9bJiPbrtScLRN58wl/oACtm4
   fWCM2Br/0uqQ1el09HTttyS8HCnyOs8LiGQPYjonXkxFAavhXJtnuqQot
   flUWVS2RYjRrrW4ZNmJXpsVT50aj7StzHhAG6uOQaYiN7qQJf2WCCbDAb
   A==;
X-CSE-ConnectionGUID: bahDTtt5QZas/G6LgXRInA==
X-CSE-MsgGUID: tfV6aF+uR3eUFGGQR4dRAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="85301980"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="85301980"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:52 -0800
X-CSE-ConnectionGUID: FMyYb2zeTcShiRckjReY1w==
X-CSE-MsgGUID: 5GET/YLnTUa9Qm5HOvNlVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="222896548"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:52 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 31/36] KVM: selftests: Add serialize() helper and X86_FEATURE_SERIALIZE
Date: Thu,  5 Mar 2026 09:44:11 -0800
Message-ID: <69230e737e4150f4e9e0cafca755d1149c620c0d.1772732517.git.isaku.yamahata@intel.com>
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
X-Rspamd-Queue-Id: 164D5216B9E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72922-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

As the following test cases use serialize instruction, add feature
definition and a helper function for it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
--
Changes v2:
- newly added
---
 tools/testing/selftests/kvm/include/x86/processor.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index da94ebf16821..88e5acc1c03e 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -172,6 +172,7 @@ struct kvm_x86_cpu_feature {
 #define	X86_FEATURE_RDPID		KVM_X86_CPU_FEATURE(0x7, 0, ECX, 22)
 #define	X86_FEATURE_SGX_LC		KVM_X86_CPU_FEATURE(0x7, 0, ECX, 30)
 #define	X86_FEATURE_SHSTK		KVM_X86_CPU_FEATURE(0x7, 0, ECX, 7)
+#define	X86_FEATURE_SERIALIZE		KVM_X86_CPU_FEATURE(0x7, 0, EDX, 14)
 #define	X86_FEATURE_IBT			KVM_X86_CPU_FEATURE(0x7, 0, EDX, 20)
 #define	X86_FEATURE_AMX_TILE		KVM_X86_CPU_FEATURE(0x7, 0, EDX, 24)
 #define	X86_FEATURE_SPEC_CTRL		KVM_X86_CPU_FEATURE(0x7, 0, EDX, 26)
@@ -1433,6 +1434,12 @@ static inline void cli(void)
 	asm volatile ("cli");
 }
 
+static inline void serialize(void)
+{
+	/* serialize instruction. binutils >= 2.35 */
+	kvm_asm_safe(".byte 0x0f, 0x01, 0xe8");
+}
+
 void __vm_xsave_require_permission(uint64_t xfeature, const char *name);
 
 #define vm_xsave_require_permission(xfeature)	\
-- 
2.45.2


