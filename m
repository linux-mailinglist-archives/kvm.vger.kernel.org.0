Return-Path: <kvm+bounces-72924-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4PLfBlfEqWm2EQEAu9opvQ
	(envelope-from <kvm+bounces-72924-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:58:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F65B216AA6
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:58:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AE21A32AC863
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:51:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 113EA3E7169;
	Thu,  5 Mar 2026 17:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OkNL5QNo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEAD3E7161
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732876; cv=none; b=cBUGrw9Ac25RuIHbJ59Yyp19gnRK4Cc21ugqkv5pKctxyb33hX89fL3PUhxIhvOQKVwK43RmwJMLoKl6FG7e9zYYN8liVsZCW2TWgqz1B8f/p+B2K0+YaSn0PJSugaaWgeDrtASZjn+mQ7Xzck7uTHS4owybyvIZBrKzQmW3BLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732876; c=relaxed/simple;
	bh=jJBvYBi6+iqjWfkOB3CFyeZTZOFIIPxoF3NXT7Ialoc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mIUECR8nZBlKrDvoOgywPOOJIFbYPwkKDvbiKHqm+jDx8nIVgupnaqB3/bdIuHlzITubp7MwQHLITljwBCZWBQQvdpfV6jJyPx8c3Q3NZxP+NJ4h51TjxQXPB+VnooRGbGEVuk2AFK5IkwgcIG2R6IhMFRYp+Xx6wF1qFcDDxv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OkNL5QNo; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732875; x=1804268875;
  h=from:to:cc:subject:date:message-id:reply-to:mime-version:
   content-transfer-encoding;
  bh=jJBvYBi6+iqjWfkOB3CFyeZTZOFIIPxoF3NXT7Ialoc=;
  b=OkNL5QNoyHrizXjGruh09SwKOY9Pn9LhfWnGlr3sqKQpaNClHtTsshfD
   uqoutNOx9w4zaUEUDC94/B/6S6Im30V19oCtweKkhujTqQMTSipOJVabI
   nM0y9mqntfo3EA2lWL+DOnYjWJuLFzQJZq5Q3AcUvezsuJgYvQS4zN06o
   XUgTD0WbU9vvrnW0f57S0td1C+F6qN1j1Ks17uF1s6MF461RnbXDNK534
   b5ggaF4BJF+E9SJHH7/+KMG19jUvu8csTPbdknpOja8ofSfE9kQ3z3b9u
   d5Sw/P3bQhFivG561Ham3Pbd+ZtoNntFUE9C4hBm9qdwqjtemW/gULUg4
   w==;
X-CSE-ConnectionGUID: 5VCTgRQdSByed5tVBZDZ+Q==
X-CSE-MsgGUID: g5bpviPxR3SRglyyu3RwwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="77701392"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="77701392"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:47:55 -0800
X-CSE-ConnectionGUID: Z/T+IqvBS62KZywv2ER8mw==
X-CSE-MsgGUID: dQBExEHzQ5mxYnIQrkTQ1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="256648746"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:47:54 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH v2 1/2] x86: apic, vmexit: Replace NOP with CPUID to serialize deadline timer
Date: Thu,  5 Mar 2026 09:47:52 -0800
Message-ID: <f7e98f7d5a21375ad584004db94e0d34806c4840.1772678359.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
Reply-To: 7acdd9974effabe5dc461aa755eacf9fb0697467.1770116601.git.isaku.yamahata@intel.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6F65B216AA6
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com];
	TAGGED_FROM(0.00)[bounces-72924-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	REPLYTO_DOM_EQ_FROM_DOM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	HAS_REPLYTO(0.00)[7acdd9974effabe5dc461aa755eacf9fb0697467.1770116601.git.isaku.yamahata@intel.com];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_NO_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Fix apic and vmexit test cases to pass with APIC timer virtualization by
replacing the NOP instruction with the CPUID instruction, a serializing
instruction.  Use CPUID instead of the SERIALIZE instruction for simplicity
because SERIALIZE is not universally available, but CPUID is.

apic and vmexit test cases use "wrmsr(TSCDEADLINE, past value); nop"
sequence to cause the deadline timer to fire immediately at the NOP
instruction.  It's not guaranteed because wrmsr(TSCDEADLINE) isn't a
serializing instruction according to SDM [1].  With APIC timer
virtualization enabled, those tests can fail.  It worked before because KVM
intercepts wrmsr(TSCDEADLINE).  KVM doesn't intercept it with APIC timer
virtualization enabled.

[1] From SDM 3a Serializing intructions
  An execution of WRMSR to any non-serializing MSR is not
  serializing. Non-serializing MSRs include the following: IA32_SPEC_CTRL
  MSR (MSR index 48H), IA32_PRED_CMD MSR (MSR index 49H), IA32_TSX_CTRL MSR
  (MSR index 122H), IA32_TSC_DEADLINE MSR (MSR index 6E0H), IA32_PKRS MSR
  (MSR index 6E1H), IA32_HWP_REQUEST MSR (MSR index 774H), or any of the
  x2APIC MSRs (MSR indices 802H to 83FH).

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
--
Changes v1 -> v2:
- Introduce wrmsr_tscdeadline_serialize().
- use cpuid(0, 0) instread of serialize instruction.
---
 lib/x86/processor.h | 10 ++++++++++
 x86/apic.c          |  3 +--
 x86/vmexit.c        |  3 +--
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 42dd2d2a4787..7255e515f548 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -1085,6 +1085,16 @@ static inline void wrtsc(u64 tsc)
 	wrmsr(MSR_IA32_TSC, tsc);
 }
 
+static inline void wrmsr_tscdeadline_serialize(u64 deadline)
+{
+	wrmsr(MSR_IA32_TSCDEADLINE, deadline);
+
+	/*
+	 * Use the CPUID instruction to serialize because the SERIALZE
+	 * instruction is not universally available.
+	 */
+	raw_cpuid(0, 0);
+}
 
 static inline void invlpg(volatile void *va)
 {
diff --git a/x86/apic.c b/x86/apic.c
index 0a52e9a45f1c..4c9659626911 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -34,8 +34,7 @@ static void __test_tsc_deadline_timer(void)
 {
 	handle_irq(TSC_DEADLINE_TIMER_VECTOR, tsc_deadline_timer_isr);
 
-	wrmsr(MSR_IA32_TSCDEADLINE, rdmsr(MSR_IA32_TSC));
-	asm volatile ("nop");
+	wrmsr_tscdeadline_serialize(rdmsr(MSR_IA32_TSC));
 	report(tdt_count == 1, "tsc deadline timer");
 	report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer clearing");
 }
diff --git a/x86/vmexit.c b/x86/vmexit.c
index 5296ed38aa34..1b675c00f930 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -436,8 +436,7 @@ static int has_tscdeadline(void)
 
 static void tscdeadline_immed(void)
 {
-	wrmsr(MSR_IA32_TSCDEADLINE, rdtsc());
-	asm volatile("nop");
+	wrmsr_tscdeadline_serialize(rdtsc());
 }
 
 static void tscdeadline(void)

base-commit: 86e53277ac80dabb04f4fa5fa6a6cc7649392bdc
-- 
2.45.2


