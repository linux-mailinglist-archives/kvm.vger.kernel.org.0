Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75A53982A4
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 20:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbfHUSUQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 14:20:16 -0400
Received: from mail-vs1-f74.google.com ([209.85.217.74]:40743 "EHLO
        mail-vs1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbfHUSUQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 14:20:16 -0400
Received: by mail-vs1-f74.google.com with SMTP id y7so1060220vsq.7
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 11:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=XOWLAgp0P8npFc8OAOfS4Qa4ZgriqhnGg7/Zma2VF2Y=;
        b=PL4GW/z+KdvWg8PgiliXgFESGa1f8UQXyd+7ri//f/7ac44KtIJPu57pb7RcP4x5CE
         YsVSa2XFokfd36Rh9twwQxbLrS3Ean1MUAjsfUqJRtTQhoN3RPycoBF8PZgs00WnpeJq
         HMqlX5qxJEavzolTIgMKI2L7kfV0sQCfJUngnemvBtwrMDcIgKFkHOt+hgglaLop/d04
         HOGhzWi6d9qVF+OGKQ4YrGSlX4M79EdWNs3OFWB140ZR6AXTlqvb+tUv9K/YCtB9Q59E
         HG0qmpwWMcVa4av4G8PBrMgwLS/JzGvZtAXgQD2+soMohQ/y2xXx1jMo4+2s8TmpHGP0
         piyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=XOWLAgp0P8npFc8OAOfS4Qa4ZgriqhnGg7/Zma2VF2Y=;
        b=sS8HJPrEeBzUN3YmV9jI22HVEiRS80a65/J/EcK7uRmwM+wDG/BQhenDEm3MhZtQ8a
         pkUiqejMrPhEkwm16WuH/x9hZuzxqxiskTSF+0VvF9gMl5kyB1fNVKjcdxkvuES83WJl
         qc571oi4aZvMRBOtofWtt2pRaAweWyiDoOQnHml/cG0/dUrsPYZlp6iGGIWG2jPnZ1TI
         BD2POrLVUHhX3uKY5y2V8yvoavoXwYVC6HoARHjyvU5g6EtENq9q/h4bPJokE7oDAwpE
         tKQJNhUuReVC3IQfCBXTbUbJdOjz5M6ceG6BCCgFUor0MGc/IgIC8WXNfh0kaEWyRO3b
         F4zg==
X-Gm-Message-State: APjAAAVx4qVHwHvNLFS8ZBTtT+bVob0yETlcCp/Z359UM1AKF99h1dZ5
        x1ws3q63OLPGrUGJ/waLn6zejJJlXmmWNIX1KV3x41Iu1kM+aP6uvV+zNGCbkkQVseDE39kK/+w
        jIYUB6Kz2YIViHSRUV+BBXGBtpIwbpGhLPXvXeeZwYWtIR2oMw3aqO3eRy0kgxnI=
X-Google-Smtp-Source: APXvYqyOtN6QsibogCg7LnU0B3aINk4w+2zic8k4fpKIkx0+JNYB93greEYNIPRkpmXkkZ7gyDjNpsDP9SKReg==
X-Received: by 2002:ab0:240e:: with SMTP id f14mr3249017uan.26.1566411614472;
 Wed, 21 Aug 2019 11:20:14 -0700 (PDT)
Date:   Wed, 21 Aug 2019 11:20:04 -0700
Message-Id: <20190821182004.102768-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These MSRs should be enumerated by KVM_GET_MSR_INDEX_LIST, so that
userspace knows that these MSRs may be part of the vCPU state.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Eric Hankland <ehankland@google.com>
Reviewed-by: Peter Shier <pshier@google.com>

---
 arch/x86/kvm/x86.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 93b0bd45ac73..ecaaa411538f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1140,6 +1140,42 @@ static u32 msrs_to_save[] = {
 	MSR_IA32_RTIT_ADDR1_A, MSR_IA32_RTIT_ADDR1_B,
 	MSR_IA32_RTIT_ADDR2_A, MSR_IA32_RTIT_ADDR2_B,
 	MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
+	MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
+	MSR_ARCH_PERFMON_FIXED_CTR0 + 2, MSR_ARCH_PERFMON_FIXED_CTR0 + 3,
+	MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
+	MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
+	MSR_ARCH_PERFMON_PERFCTR0, MSR_ARCH_PERFMON_PERFCTR1,
+	MSR_ARCH_PERFMON_PERFCTR0 + 2, MSR_ARCH_PERFMON_PERFCTR0 + 3,
+	MSR_ARCH_PERFMON_PERFCTR0 + 4, MSR_ARCH_PERFMON_PERFCTR0 + 5,
+	MSR_ARCH_PERFMON_PERFCTR0 + 6, MSR_ARCH_PERFMON_PERFCTR0 + 7,
+	MSR_ARCH_PERFMON_PERFCTR0 + 8, MSR_ARCH_PERFMON_PERFCTR0 + 9,
+	MSR_ARCH_PERFMON_PERFCTR0 + 10, MSR_ARCH_PERFMON_PERFCTR0 + 11,
+	MSR_ARCH_PERFMON_PERFCTR0 + 12, MSR_ARCH_PERFMON_PERFCTR0 + 13,
+	MSR_ARCH_PERFMON_PERFCTR0 + 14, MSR_ARCH_PERFMON_PERFCTR0 + 15,
+	MSR_ARCH_PERFMON_PERFCTR0 + 16, MSR_ARCH_PERFMON_PERFCTR0 + 17,
+	MSR_ARCH_PERFMON_PERFCTR0 + 18, MSR_ARCH_PERFMON_PERFCTR0 + 19,
+	MSR_ARCH_PERFMON_PERFCTR0 + 20, MSR_ARCH_PERFMON_PERFCTR0 + 21,
+	MSR_ARCH_PERFMON_PERFCTR0 + 22, MSR_ARCH_PERFMON_PERFCTR0 + 23,
+	MSR_ARCH_PERFMON_PERFCTR0 + 24, MSR_ARCH_PERFMON_PERFCTR0 + 25,
+	MSR_ARCH_PERFMON_PERFCTR0 + 26, MSR_ARCH_PERFMON_PERFCTR0 + 27,
+	MSR_ARCH_PERFMON_PERFCTR0 + 28, MSR_ARCH_PERFMON_PERFCTR0 + 29,
+	MSR_ARCH_PERFMON_PERFCTR0 + 30, MSR_ARCH_PERFMON_PERFCTR0 + 31,
+	MSR_ARCH_PERFMON_EVENTSEL0, MSR_ARCH_PERFMON_EVENTSEL1,
+	MSR_ARCH_PERFMON_EVENTSEL0 + 2, MSR_ARCH_PERFMON_EVENTSEL0 + 3,
+	MSR_ARCH_PERFMON_EVENTSEL0 + 4, MSR_ARCH_PERFMON_EVENTSEL0 + 5,
+	MSR_ARCH_PERFMON_EVENTSEL0 + 6, MSR_ARCH_PERFMON_EVENTSEL0 + 7,
+	MSR_ARCH_PERFMON_EVENTSEL0 + 8, MSR_ARCH_PERFMON_EVENTSEL0 + 9,
+	MSR_ARCH_PERFMON_EVENTSEL0 + 10, MSR_ARCH_PERFMON_EVENTSEL0 + 11,
+	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
+	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
+	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
+	MSR_ARCH_PERFMON_EVENTSEL0 + 18, MSR_ARCH_PERFMON_EVENTSEL0 + 19,
+	MSR_ARCH_PERFMON_EVENTSEL0 + 20, MSR_ARCH_PERFMON_EVENTSEL0 + 21,
+	MSR_ARCH_PERFMON_EVENTSEL0 + 22, MSR_ARCH_PERFMON_EVENTSEL0 + 23,
+	MSR_ARCH_PERFMON_EVENTSEL0 + 24, MSR_ARCH_PERFMON_EVENTSEL0 + 25,
+	MSR_ARCH_PERFMON_EVENTSEL0 + 26, MSR_ARCH_PERFMON_EVENTSEL0 + 27,
+	MSR_ARCH_PERFMON_EVENTSEL0 + 28, MSR_ARCH_PERFMON_EVENTSEL0 + 29,
+	MSR_ARCH_PERFMON_EVENTSEL0 + 30, MSR_ARCH_PERFMON_EVENTSEL0 + 31,
 };
 
 static unsigned num_msrs_to_save;
@@ -4989,6 +5025,11 @@ static void kvm_init_msr_list(void)
 	u32 dummy[2];
 	unsigned i, j;
 
+	BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED != 4,
+			 "Please update the fixed PMCs in msrs_to_save[]");
+	BUILD_BUG_ON_MSG(INTEL_PMC_MAX_GENERIC != 32,
+			 "Please update the generic perfctr/eventsel MSRs in msrs_to_save[]");
+
 	for (i = j = 0; i < ARRAY_SIZE(msrs_to_save); i++) {
 		if (rdmsr_safe(msrs_to_save[i], &dummy[0], &dummy[1]) < 0)
 			continue;
-- 
2.23.0.187.g17f5b7556c-goog

