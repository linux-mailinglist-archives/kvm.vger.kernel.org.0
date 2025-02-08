Return-Path: <kvm+bounces-37656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AE7B8A2D5B2
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2025 11:55:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 512867A3D88
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2025 10:54:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C8091BEF82;
	Sat,  8 Feb 2025 10:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e0dMd1kf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5B922FDF1;
	Sat,  8 Feb 2025 10:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012085; cv=none; b=upO3lAWd/YDV+Jj+yT5eUdP6yI/oaRJA2K+gxnVHekJjHcQNEWqtN96Is5Jxkm80V6OMAeTp0jKwQxRFH+btzKCtmF+La2ogWBDZJvjqwALQMX7cy7CyjNTQU8Ht8VRBiEmBDqDpnLaWZCGerOK4mEC3Lt0p+oMHYJbfcfcAjwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012085; c=relaxed/simple;
	bh=lI/51wLi2H8Tam0i5+pdnLfj876YBIBpf/fiqN/u6YM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GuJaJvUsYGM82pKy/b+tdQY8g8lzKG+Q5lVCH8IZL0GctmMCjhOa50ozgGZuab9h7IdHhIyyImOy/Yq3bPJJawKuLuMneV/99xMvhZ9/jJSXRUZ+oa4vvp17DgTX91iXmqCISE3+2E94/RUBjZoZ9pFZ80yi/yd3y5LBRHLWBQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e0dMd1kf; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739012075; x=1770548075;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lI/51wLi2H8Tam0i5+pdnLfj876YBIBpf/fiqN/u6YM=;
  b=e0dMd1kf1xiTMXjh+Y2pUClJcKfrT0BAAcmIeejJkwtxxXk1XOlHmaLT
   TZZcf1QEK+exipPPT9yb0CERy892c+MJgtzPKSFXuC9BsXFHTvQU5yhzM
   6S8Hi7bFMh42cadEx+sbQcVUjBqh68NSIJC7lRS18p7W59IBrOP2QgUf8
   PhpbQmuHhm8VRR3BW1qROlKOLPfR1Dfr+11yHTqeo5otc4W9o9TrLAYjt
   i7Viucp5d6QMLCtAlt/7HV/dQmUiZIhxppqo1rQxA3zqvPj+aVMng1hys
   qwCu9GtYRGzNjAvp+FdDELcnsTAhebeBdEudsFxYK0fz697YX/KYHvVjM
   Q==;
X-CSE-ConnectionGUID: d5DfgFCXTKSthEv9KWEO1A==
X-CSE-MsgGUID: iwknCTFHSrmAS6LzuwOW1w==
X-IronPort-AV: E=McAfee;i="6700,10204,11338"; a="43310486"
X-IronPort-AV: E=Sophos;i="6.13,269,1732608000"; 
   d="scan'208";a="43310486"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2025 02:54:25 -0800
X-CSE-ConnectionGUID: PbE6dLz4RI2m2AgTbUfwlg==
X-CSE-MsgGUID: KdnNn2DzTy25klR1Ypc8pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,269,1732608000"; 
   d="scan'208";a="116798959"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2025 02:54:23 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH] KVM: selftests: Wait mprotect_ro_done before write to RO in mmu_stress_test
Date: Sat,  8 Feb 2025 18:53:18 +0800
Message-ID: <20250208105318.16861-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the read-only mprotect() phase of mmu_stress_test, ensure that
mprotect(PROT_READ) has completed before the guest starts writing to the
read-only mprotect() memory.

Without waiting for mprotect_ro_done before the guest starts writing in
stage 3 (the stage for read-only mprotect()), the host's assertion of stage
3 could fail if mprotect_ro_done is set to true in the window between the
guest finishing writes to all GPAs and executing GUEST_SYNC(3).

This scenario is easy to occur especially when there are hundred of vCPUs.

CPU 0                  CPU 1 guest     CPU 1 host
                                       enter stage 3's 1st loop
                       //in stage 3
                       write all GPAs
                       @rip 0x4025f0

mprotect(PROT_READ)
mprotect_ro_done=true
                       GUEST_SYNC(3)
                                       r=0, continue stage 3's 1st loop

                       //in stage 4
                       write GPA
                       @rip 0x402635

                                       -EFAULT, jump out stage 3's 1st loop
                                       enter stage 3's 2nd loop
                       write GPA
                       @rip 0x402635
                                       -EFAULT, continue stage 3's 2nd loop
                                       guest rip += 3

The test then fails and reports "Unhandled exception '0xe' at guest RIP
'0x402638'", since the next valid guest rip address is 0x402639, i.e. the
"(mem) = val" in vcpu_arch_put_guest() is compiled into a mov instruction
of length 4.

Even if it could be compiled into a mov instruction of length 3, the
following execution of GUEST_SYNC(4) in guest could still cause the host
failure of the assertion of stage 3.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 25 +++++++++++--------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index d9c76b4c0d88..a2ccf705bb2a 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -35,11 +35,16 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 	GUEST_SYNC(2);
 
 	/*
-	 * Write to the region while mprotect(PROT_READ) is underway.  Keep
-	 * looping until the memory is guaranteed to be read-only, otherwise
-	 * vCPUs may complete their writes and advance to the next stage
-	 * prematurely.
-	 *
+	 * mprotect(PROT_READ) is underway.  Keep looping until the memory is
+	 * guaranteed to be read-only, otherwise vCPUs may complete their
+	 * writes and advance to the next stage prematurely.
+	 */
+	do {
+		;
+	} while (!READ_ONCE(mprotect_ro_done));
+
+	/*
+	 * Write to the region after mprotect(PROT_READ) is done.
 	 * For architectures that support skipping the faulting instruction,
 	 * generate the store via inline assembly to ensure the exact length
 	 * of the instruction is known and stable (vcpu_arch_put_guest() on
@@ -47,16 +52,14 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 	 * is low in this case).  For x86, hand-code the exact opcode so that
 	 * there is no room for variability in the generated instruction.
 	 */
-	do {
-		for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
+	for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
 #ifdef __x86_64__
-			asm volatile(".byte 0x48,0x89,0x00" :: "a"(gpa) : "memory"); /* mov %rax, (%rax) */
+		asm volatile(".byte 0x48,0x89,0x00" :: "a"(gpa) : "memory"); /* mov %rax, (%rax) */
 #elif defined(__aarch64__)
-			asm volatile("str %0, [%0]" :: "r" (gpa) : "memory");
+		asm volatile("str %0, [%0]" :: "r" (gpa) : "memory");
 #else
-			vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
+		vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
 #endif
-	} while (!READ_ONCE(mprotect_ro_done));
 
 	/*
 	 * Only architectures that write the entire range can explicitly sync,
-- 
2.43.2


