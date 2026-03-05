Return-Path: <kvm+bounces-72925-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uPFnIDvFqWknEgEAu9opvQ
	(envelope-from <kvm+bounces-72925-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 19:02:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DE966216BBE
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 19:02:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0D62831D06AE
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:51:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CECA3E717D;
	Thu,  5 Mar 2026 17:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JQ703vh+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE4E371054
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732877; cv=none; b=FglT87lreBPmGSfLPFgJ2+IZtFvCugzwhAEqWyfdU6ZaaNEQvUnvAwbcdER2jTvaurwg9qSbhI53VwFvVtROrtAAJzrTRo/K1lEQow/EkFIuLWg3Lg5z/gSSKOcNRT/K4fxrfvRg2IWn3Wf6AA+g3DgZyohsn8uBpHOpDI2VpCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732877; c=relaxed/simple;
	bh=M7VFVa9lXnCPR10A6Ateq6QnbjtHmaH3DBU9/sbXUCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLnQp50+KMGQoguadikWcgsR1SMXtpnZn+MRCrcLAsSYQIBKYnamCzWrcTTwvbSacLSHKgdtf015pbVzRxyFMmbKowtWeWABNUtEFw8YmFViVbRzqg8y8mGhzCczIJ2Bv/yUo3OLIxF83Kyc+kHu68QRrrFxxS0pEIH7UsNaTxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JQ703vh+; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732876; x=1804268876;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:reply-to:mime-version:
   content-transfer-encoding;
  bh=M7VFVa9lXnCPR10A6Ateq6QnbjtHmaH3DBU9/sbXUCw=;
  b=JQ703vh+cZfPovjXhU1Hx16l8xKqlVaRWcOVk66OXc3NpRmJg2ukJJjJ
   ZyiAWbzIWXbtnLkw+qV8x9UabOwk+E0opvPErcUhpkspKNjpM+QKrvk9T
   DleWFpxsUp4jPqUVfbsrpqrOHYoDJjynsclZp9+tC13sqQn38zxZFW+v/
   kNAzWWjgFIQV69vT6TQSDf8rP/P8n2PTgrX6auZ1D9grOXFbO98dZJnpw
   ArGmQmZsXWvepENJBRyshoB20iQCqNPMLJFupKca8L5zh8K9k8SMv3e+/
   5G8I8Y8vFOXALY9vqeYOYxcSzSpd9nce6acyy8WkHkiVgX3NmWZQrUzF6
   g==;
X-CSE-ConnectionGUID: 1We8Q3I6RM6rzlnwFDBRpQ==
X-CSE-MsgGUID: sZ2xRDPOQ1ay/Rgf9Ra5EA==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="84465349"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="84465349"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:47:56 -0800
X-CSE-ConnectionGUID: bugvJlfkRi2gADHNsXz0RA==
X-CSE-MsgGUID: KDuIJuKuTxGtBm8y5TXacg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="223237337"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:47:55 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH v2 2/2] x86: tscdeadline_latency: Remove unnecessary nop
Date: Thu,  5 Mar 2026 09:47:53 -0800
Message-ID: <2ef8af4c0afc26feee8a993ef818f9ed40a7f329.1772678359.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <f7e98f7d5a21375ad584004db94e0d34806c4840.1772678359.git.isaku.yamahata@intel.com>
References: <f7e98f7d5a21375ad584004db94e0d34806c4840.1772678359.git.isaku.yamahata@intel.com>
Reply-To: 7acdd9974effabe5dc461aa755eacf9fb0697467.1770116601.git.isaku.yamahata@intel.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DE966216BBE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com];
	TAGGED_FROM(0.00)[bounces-72925-lists,kvm=lfdr.de];
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

Eliminate unncessary nop instruction right after wrmsr(TSC DEADLINE) for
code clarity.

The existing logic is sti(), wrmsr(TSC DEADLINE), NOP, and loop HLT to wait
for the interrupts.  Because we explicitly wait for the timer interrupts
with the interrupt unmasked, the test doesn't need the NOP instruction to
be a place where the interrupt is raised.  Other tests (apic and vmexit)
expect that the timer interrupt happens right after wrmsr(TSC DEADLINE),
which needs the interruptible window and serialization right after updating
the deadline value.  However, tscdeadline_latency doesn't need it.  Delete
the unnecessary NOP to clarify that serialization isn't needed.

The code doesn't have any comments on why NOP is there.  The commit message
of d482c49772fb ("kvm-unit-tests: add tscdeadline-latency test") has only
"To test latency between TSC deadline timer interrupt injection.", which
doesn't tell why.  The following commits that modify the file doesn't touch
NOP.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 x86/tscdeadline_latency.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/x86/tscdeadline_latency.c b/x86/tscdeadline_latency.c
index 6bf56225a9a6..4e6a045314a7 100644
--- a/x86/tscdeadline_latency.c
+++ b/x86/tscdeadline_latency.c
@@ -73,7 +73,6 @@ static void start_tsc_deadline_timer(void)
     sti();
 
     wrmsr(MSR_IA32_TSCDEADLINE, rdmsr(MSR_IA32_TSC)+delta);
-    asm volatile ("nop");
 }
 
 static int enable_tsc_deadline_timer(void)
-- 
2.45.2


