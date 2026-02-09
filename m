Return-Path: <kvm+bounces-70573-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wLY7DHFjiWla8AQAu9opvQ
	(envelope-from <kvm+bounces-70573-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 05:32:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CC07F10B93E
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 05:32:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 234D7300E3AB
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 04:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F11F527877F;
	Mon,  9 Feb 2026 04:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="beWiTdqm"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B99A219EB;
	Mon,  9 Feb 2026 04:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770611437; cv=none; b=fQoF0B58WIV1v88CC79IcwthTiRmQUWVJDt1y1Nvd7JBpkLZi0uzLdYg3Z64Bq20oW7HzEKbV22TfSLa8E3YwfZPhDrCLNXUL88I7+OWhHW8v95rYL7o/K+BpMEhJhDrK58mml8mC6ckj44SRvu4movtc9Ed7iJG7yrU9zTEBaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770611437; c=relaxed/simple;
	bh=mg6Np9dLlQ9jkpUBZKs9K2GVpmriauqZmwB9RUasGXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNAUt0RwyL7kUsK7T2dpHDqUynRwoQNluFnWuhf7AI3QoDdgvUSoVldissgSMqDhJUOtMWieDNFVN/zaX4GnXL2DnM+eePfOovseGPtjb4Ylleyf9/FQ5stfsWof+O8DfOt/r2AySea9hG6kX2tFaml8q331EUUSdSdMKezXIj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=beWiTdqm; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=p0
	WWBaXeK1hJhUNXLmueWvDpkraa8hWuQq+v3jxbXV0=; b=beWiTdqmpGNBHpUDIE
	hfiA5ZOwTcRLTlSoO1aOBmol0IIEBAQQOS28bt8iE3ihSZpFSHQBR3en5Y7sPRjK
	xxwl3mG54LnoXMRa4XrlEp3L77KS87T3CYvu8xlHL4t7o1lLzSvVMPz/Q9nijkT+
	fFLbjZ+eUQZ0yBs4lJsCQswI4=
Received: from 163.com (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgD3F+yvYolpOQZEQw--.25673S7;
	Mon, 09 Feb 2026 12:29:37 +0800 (CST)
From: Zhiquan Li <zhiquan_li@163.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	shuah@kernel.org
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiquan_li@163.com
Subject: [PATCH RESEND 5/5] KVM: x86: selftests: Fix write MSR_TSC_AUX reserved bits test failure on Hygon
Date: Mon,  9 Feb 2026 12:13:05 +0800
Message-ID: <20260209041305.64906-6-zhiquan_li@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260209041305.64906-1-zhiquan_li@163.com>
References: <20260209041305.64906-1-zhiquan_li@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgD3F+yvYolpOQZEQw--.25673S7
X-Coremail-Antispam: 1Uf129KBjvJXoWxWw1xXFyrtrW3CF4rWryrCrg_yoW5ZrWfpa
	n2gw4YgrZrKa42qa9rXF1kGF4rArn7Gry0grnaq3y7Zwn5Ary2qr4xKayfXa4xZrWSvr98
	ZF47tr42kw4DAaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziD5rsUUUUU=
X-CM-SenderInfo: 52kl13xdqbzxi6rwjhhfrp/xtbCwhGBammJYrGJVQAA3X
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[163.com,none];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70573-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,163.com];
	FREEMAIL_FROM(0.00)[163.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zhiquan_li@163.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[163.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CC07F10B93E
X-Rspamd-Action: no action

On Hygon processors either RDTSCP or RDPID is supported in the host,
MSR_TSC_AUX is able to be accessed.

The write reserved bits test for MSR_TSC_AUX while RDPID as "feature"
and RDTSCP as "feature2" is failed on Hygon CPUs which only support
RDTSCP but not support RDPID.  In current design, if RDPID is not
supported, vCPU0 and vCPU1 write reserved bits expects #GP, however, it
is not applicable for Hygon CPUs.  Since on Hygon architecture whether
or not RDPID is supported in the host, once RDTSCP is supported,
MSR_TSC_AUX is able to be accessed, vCPU0 and vCPU1 drop bits 63:32 and
write successfully.

Therefore, the expectation of writing MSR_TSC_AUX reserved bits on Hygon
CPUs should be:
1) either RDTSCP or RDPID is supported case, and both are supported
   case, expect success and a truncated value, not #GP.
2) neither RDTSCP nor RDPID is supported, expect #GP.

Signed-off-by: Zhiquan Li <zhiquan_li@163.com>
---
 tools/testing/selftests/kvm/x86/msrs_test.c | 26 +++++++++++++++++----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testing/selftests/kvm/x86/msrs_test.c
index 40d918aedce6..2f1e800fe691 100644
--- a/tools/testing/selftests/kvm/x86/msrs_test.c
+++ b/tools/testing/selftests/kvm/x86/msrs_test.c
@@ -77,11 +77,11 @@ static bool ignore_unsupported_msrs;
 static u64 fixup_rdmsr_val(u32 msr, u64 want)
 {
 	/*
-	 * AMD CPUs drop bits 63:32 on some MSRs that Intel CPUs support.  KVM
-	 * is supposed to emulate that behavior based on guest vendor model
+	 * AMD and Hygon CPUs drop bits 63:32 on some MSRs that Intel CPUs support.
+	 * KVM is supposed to emulate that behavior based on guest vendor model
 	 * (which is the same as the host vendor model for this test).
 	 */
-	if (!host_cpu_is_amd)
+	if (!host_cpu_is_amd && !host_cpu_is_hygon)
 		return want;
 
 	switch (msr) {
@@ -94,6 +94,17 @@ static u64 fixup_rdmsr_val(u32 msr, u64 want)
 	}
 }
 
+/*
+ * On Hygon processors either RDTSCP or RDPID is supported in the host,
+ * MSR_TSC_AUX is able to be accessed.
+ */
+static bool is_hygon_msr_tsc_aux_supported(const struct kvm_msr *msr)
+{
+	return host_cpu_is_hygon &&
+			msr->index == MSR_TSC_AUX &&
+			(this_cpu_has(msr->feature) || this_cpu_has(msr->feature2));
+}
+
 static void __rdmsr(u32 msr, u64 want)
 {
 	u64 val;
@@ -174,9 +185,14 @@ void guest_test_reserved_val(const struct kvm_msr *msr)
 	/*
 	 * If the CPU will truncate the written value (e.g. SYSENTER on AMD),
 	 * expect success and a truncated value, not #GP.
+	 *
+	 * On Hygon CPUs whether or not RDPID is supported in the host, once RDTSCP
+	 * is supported, MSR_TSC_AUX is able to be accessed.  So, for either RDTSCP
+	 * or RDPID is supported case and both are supported case, expect
+	 * success and a truncated value, not #GP.
 	 */
-	if (!this_cpu_has(msr->feature) ||
-	    msr->rsvd_val == fixup_rdmsr_val(msr->index, msr->rsvd_val)) {
+	if (!is_hygon_msr_tsc_aux_supported(msr) && (!this_cpu_has(msr->feature) ||
+	    msr->rsvd_val == fixup_rdmsr_val(msr->index, msr->rsvd_val))) {
 		u8 vec = wrmsr_safe(msr->index, msr->rsvd_val);
 
 		__GUEST_ASSERT(vec == GP_VECTOR,
-- 
2.43.0


