Return-Path: <kvm+bounces-63144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B719BC5AC79
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:33:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4DFD6351F67
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:32:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5257221ADB7;
	Fri, 14 Nov 2025 00:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UcTYMdGH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64564A02
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763080356; cv=none; b=KlMKCfUbBYAx6G4vrH80O8oerw3iUyOYobkseEWdfd4QhSgU3floTX2VaP5hPqYYX4MYmBRvXW4ZG286l0WTIj3Gp1j2JUCCNxifaZPkFWVnSlIJk6bIoJek+Kb4FKn9DoYk5hY1E/xQdRSamMCq+6SjhDrhyo6fmFnUl810udo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763080356; c=relaxed/simple;
	bh=aZPWNgQi3FNPEeRabHkEo9eLl+efgRdZPiOS7w/z/mY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KydRHvLLCj+SR/zT3AgafdmdIc5kDd5/g25Tf3m6LcfuOmwmIIh4MpsM1T7mHcZbK4JpffOfhHsWasEn5Ul0PL+eCnNW2RI7NF9vrQBE/QiI/8T7X82WTNbxjJo88tlhbQzyoLNvJXZNzIdjIFLyg56VkaPmV5m49YX3IpiVX7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UcTYMdGH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763080354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cwScgguf1cuymzI2NQXDUxRJxBMZCYwifQYw0aZhyQA=;
	b=UcTYMdGHovqAxu/5JgWsrPt2KySx/KnMtNUdlAs98bWUdJ/DnSxvswjw0+P5J67nulZj5X
	Fw1Qy+6I8HNKInWhBXO+QQBitnl1s427vFO6jdLc3zSFlXx3RsGBG4uTmYD/wcNVQKPYky
	va60hu8fMyhRIraZUGR3LRkchaDndog=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-512-Rwz-UB-GPBG5dJo_gae-lA-1; Thu,
 13 Nov 2025 19:32:30 -0500
X-MC-Unique: Rwz-UB-GPBG5dJo_gae-lA-1
X-Mimecast-MFC-AGG-ID: Rwz-UB-GPBG5dJo_gae-lA_1763080349
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BDF6B1800447;
	Fri, 14 Nov 2025 00:32:29 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5965D180049F;
	Fri, 14 Nov 2025 00:32:29 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: kvm@vger.kernel.org
Cc: kbusch@kernel.org
Subject: [PATCH kvm-unit-tests] xsave: add testcase for emulation of AVX instructions
Date: Thu, 13 Nov 2025 19:32:28 -0500
Message-ID: <20251114003228.60592-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Companion patch to the emulator changes in KVM.  Funnily enough,
no valid combination involving AVX was tried.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/xsave.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/x86/xsave.c b/x86/xsave.c
index cc8e3a0a..e6d15938 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -15,6 +15,34 @@
 #define XSTATE_SSE      0x2
 #define XSTATE_YMM      0x4
 
+char __attribute__((aligned(32))) v32_1[32] = {
+    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
+    128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143,
+};
+char __attribute__((aligned(32))) v32_2[32] = { 0 };
+
+static __attribute__((target("avx"))) void
+test_avx_fep(void)
+{
+	asm volatile("vzeroall\n"
+	    KVM_FEP "vmovdqa v32_1, %%ymm0\n"
+	    KVM_FEP "vmovdqa %%ymm0, v32_2\n" : : :
+	    "memory",
+	    "%ymm0", "%ymm1", "%ymm2", "%ymm3", "%ymm4", "%ymm5", "%ymm6", "%ymm7",
+	    "%ymm8", "%ymm9", "%ymm10", "%ymm11", "%ymm12", "%ymm13", "%ymm14", "%ymm15");
+}
+
+static __attribute__((target("avx"))) void
+test_avx(void)
+{
+	asm volatile("vzeroall\n"
+	    "vmovdqa v32_1, %%ymm0\n"
+	    "vmovdqa %%ymm0, v32_2\n" : : :
+	    "memory",
+	    "%ymm0", "%ymm1", "%ymm2", "%ymm3", "%ymm4", "%ymm5", "%ymm6", "%ymm7",
+	    "%ymm8", "%ymm9", "%ymm10", "%ymm11", "%ymm12", "%ymm13", "%ymm14", "%ymm15");
+}
+
 static void test_xsave(void)
 {
     unsigned long cr4;
@@ -45,7 +73,22 @@ static void test_xsave(void)
     report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == 0,
            "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP | XSTATE_SSE)");
     report(xgetbv_safe(XCR_XFEATURE_ENABLED_MASK, &xcr0) == 0,
-           "        xgetbv(XCR_XFEATURE_ENABLED_MASK)");
+           "\t\txgetbv(XCR_XFEATURE_ENABLED_MASK)");
+
+    if (supported_xcr0 & XSTATE_YMM) {
+        test_bits = XSTATE_FP | XSTATE_SSE | XSTATE_YMM;
+        report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == 0,
+               "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FS | XSTATE_SSE | XSTATE_YMM)");
+        xgetbv_safe(XCR_XFEATURE_ENABLED_MASK, &xcr0);
+        if (xcr0 == test_bits) {
+            if (is_fep_available)
+                test_avx_fep();
+            else
+                test_avx();
+            report(memcmp(v32_1, v32_2, 32) == 0,
+                   "vmovdqa emulation");
+        }
+    }
 
     printf("\tIllegal tests\n");
     test_bits = 0;
-- 
2.43.5


