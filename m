Return-Path: <kvm+bounces-63062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B9D6C5A63F
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:50:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08DE93B9C9C
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 22:47:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44046326940;
	Thu, 13 Nov 2025 22:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mI6iUfV5"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D3A328241
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 22:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074030; cv=none; b=DViH32UKWwZ5EMD3oYcxXA5YGCJXgTIS7b0k6aHywVBJzgXjBau8yjmIJiua/mWCoH218x3KCWBMVUnPM/tA5hGISPhygnJvkrbC8HVA1lO4fGPk3HDyNvV3YbYgIGcOa7OdNthpS5E9MpHORW1oj4vAOBXW5Tv2dS6aN5ArJzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074030; c=relaxed/simple;
	bh=+iT7JycQHs1qelWQ+cYRAM2zmmkANkKlFVv/6V9Sv3s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nj198rQAjzsQHZ/J7GYzqu/2ma3kVBKj42k+NTHunN1Y2/EzJYG624r0pL885lRfGqZEo1znZSa+4CcQHKy8Tmyh3LiXjUp5RkpUyVj5tdWMcgcss7kSrfkZ94aP9KYIaowv0RfMUF7QIHigOFueDMxM3LswogoqUUVx5rXHSt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mI6iUfV5; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763074016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Eo3bhZWVthkDLHeQ9yGuEDfsyaebGduIb78w2/PdeXM=;
	b=mI6iUfV5XEE0aZcOsVk5lCBj3JiW3yTv2AMMmJJuKbSlfvGA4TUFaocwLZrCCp5Af6lBqe
	jqCe6tLx6V2RORXRCjk+GKSt/hwsLODVJnjNMxJoKctee8U73y1nlnwKiaJvF0/pMLHpxE
	kP4b1hiLW5t5gWALpXsOECQRZEYcvmw=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [kvm-unit-tests] x86/svm: Correctly extract the IP from LBR MSRs
Date: Thu, 13 Nov 2025 22:46:39 +0000
Message-ID: <20251113224639.2916783-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Currently, only bit 63 is ignored when reading LBR MSRs. However,
different AMD CPUs use upper bits of the MSR differently. For example,
some Zen 4 processors document bit 63 in LASTBRACNHFROMIP and bits 63:61
in LASTBRANCHTOIP to be reserved. On the other hand, some Zen 5
processors bits 63:57 to be reserved in both MSRs.

Use the common denominator and always bits 63:57 when reading the LBR
MSRs, which should be sufficient testing. This fixes the test flaking on
some AMD processors that set bit 62 in LASTBRANCHTOIP.

Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 lib/x86/msr.h   | 8 ++++++--
 x86/svm_tests.c | 2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index cc4cb8551ea1b..e586a8e931900 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -85,8 +85,12 @@
 #define MSR_IA32_LASTINTFROMIP		0x000001dd
 #define MSR_IA32_LASTINTTOIP		0x000001de
 
-/* Yes, AMD does indeed record mispredict info in the LBR records themselves. */
-#define AMD_LBR_RECORD_MISPREDICT	BIT_ULL(63)
+/*
+ * Different AMD CPUs use the upper bits of the IP LBRs differently. For the
+ * purposes of tests, use the common denominator of the IP bits.
+ */
+#define AMD_LBR_RECORD_IP_BITS		57
+#define AMD_LBR_RECORD_IP_MASK		((1UL << AMD_LBR_RECORD_IP_BITS)-1)
 
 #define LBR_INFO_MISPRED		BIT_ULL(63)
 #define LBR_INFO_IN_TX			BIT_ULL(62)
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 80d5aeb108650..43e76badf1638 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2953,7 +2953,7 @@ static void svm_no_nm_test(void)
 
 static u64 amd_get_lbr_rip(u32 msr)
 {
-	return rdmsr(msr) & ~AMD_LBR_RECORD_MISPREDICT;
+	return rdmsr(msr) & AMD_LBR_RECORD_IP_MASK;
 }
 
 #define HOST_CHECK_LBR(from_expected, to_expected)					\
-- 
2.52.0.rc1.455.g30608eb744-goog


