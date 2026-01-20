Return-Path: <kvm+bounces-68597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DFDFD3C352
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 10:22:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1F6945023C7
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 09:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E93683D2FF6;
	Tue, 20 Jan 2026 09:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="dVcKek7i"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3365A3C1979;
	Tue, 20 Jan 2026 09:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768900570; cv=none; b=dbGooo4C2TKzvmC8NrZwuncFySKn4IeLcVu1sdPvKPrIvuo2YbPuxhYST21qKHERgZZpbh3VMXLXhrQBCMu0/oJG/BmblMitPerdn47GAOdbEcfu9z/QLxAjUPIUNYCqnJDHJ2CQd8Whc1TkxlZI0XfBUsMrUcVa1oCj1IvbQoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768900570; c=relaxed/simple;
	bh=+LSKJXTL0Oi0zIuWeuP0lkYB6M5EUphYk6I5LcY7gDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qs3TaDM7aZ6mcd+LrXVse8+bpFQDuNTQJyUfZtXrSGzIlyNyUayxb+HAx7WXsTLWfe4lAz30unD47O4muZz21A2Ylhw4ViUwoeLqQ58kd0i0C4BF/1nVN0Suj5WcTtgIK24X5EevsuXvvJVPFlznogEqix4Yqt2TTFHQgmwByMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=dVcKek7i; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=al
	8hUm54zf4NpyVr8Q4r3YPQ1wLQggAbykFHpaZ9yp0=; b=dVcKek7i1vEzAFhtTg
	32JH0rGMfPqs4Sry8AFtuiFdq1j7NfhTetww7DuNXMxvfbG7v92RxXnz+cQXmno3
	UVvDGamzBVRjO7SZ6OTGuUA/+uhB7Ea11GrrE4ITUOkrjAGo6dGuwYCnIaveQ7tC
	z8wMlo7AwQ3O51+2WytvVtELc=
Received: from 163.com (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wCn5zu4R29pIOfPGw--.26432S7;
	Tue, 20 Jan 2026 17:15:44 +0800 (CST)
From: Zhiquan Li <zhiquan_li@163.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	shuah@kernel.org
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiquan_li@163.com
Subject: [PATCH 5/5] KVM: x86: selftests: Fix write MSR_TSC_AUX reserved bits test failure on Hygon
Date: Tue, 20 Jan 2026 17:14:48 +0800
Message-ID: <20260120091449.526798-6-zhiquan_li@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260120091449.526798-1-zhiquan_li@163.com>
References: <20260120091449.526798-1-zhiquan_li@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCn5zu4R29pIOfPGw--.26432S7
X-Coremail-Antispam: 1Uf129KBjvJXoWxWw1xXFyrtrW3Ar18AFy3twb_yoW5Zrykpa
	92kw4YgrZrKa42qa9rXF1kGF4rArn7Gry0grnaq3y7Zwn5Ary7Xr4xKayrXay7ZrWSvr98
	ZF47tw42kw4DAaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pMsjj9UUUUU=
X-CM-SenderInfo: 52kl13xdqbzxi6rwjhhfrp/xtbCwgA4IWlvR8C+mgAA3+

On Hygon processors either RDTSCP or RDPID is supported in the host,
MSR_TSC_AUX is able to be accessed.

The write reserved bits test for MSR_TSC_AUX with RDPID as "feature"
and RDTSCP as "feature2" is failed on Hygon CPUs which only support
RDTSCP but not support RDPID.  In current design, if RDPID is not
supported, vCPU0 and vCPU1 write reserved bits expects #GP, however, it
is not applicable for Hygon CPUs.  Since on Hygon architecture whether
or not RDPID is supported in the host, once RDTSCP is supported,
MSR_TSC_AUX is able to be accessed, vCPU0 and vCPU1 drop bits 63:32 and
write successfully.

Therefore, the results of write MSR_TSC_AUX reserved bits on Hygon CPUs
should be:
1) either RDTSCP or RDPID is supported case and both are supported case,
   expect success and a truncated value, not #GP.
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


