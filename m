Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCBB13D97
	for <lists+kvm@lfdr.de>; Sun,  5 May 2019 07:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfEEFxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 May 2019 01:53:36 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36768 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbfEEFxg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 May 2019 01:53:36 -0400
Received: by mail-pf1-f193.google.com with SMTP id v80so5018592pfa.3
        for <kvm@vger.kernel.org>; Sat, 04 May 2019 22:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mAdaTJv5fPZECrKFpm6hzzjTG0hmqfBl+ouJw3ibO3I=;
        b=WjtBlvWnhtdHGjqVIwqfElXrJ4rdfz3JD0bMgJfFUNazQjwBn60/8VQTWMbGvSLHkf
         N8DqYNkathjQRSBLkj5SWcngVGA9NgYoItDHgJIXd3XJn7EKyRuDyZCaC2x/2C1Ebwf2
         U7WOfEjcGhytMIKkOLhHZ0SQPMB6ordiTBD5F3d7xjNja+MzNxetBfrp2Rkihev9ufse
         y16hOu+DoV5WmFogviOMQ2cmKY668TcaZ+lMHBujh9gWsCqukDSJcurWjbX8nve4GDrG
         Dc9okPj5LLPoNli/JEmeCyCyJKWym6k40bvS0zg+Mdlv3tv9inUJF42izpuScz1KBQVK
         iwzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mAdaTJv5fPZECrKFpm6hzzjTG0hmqfBl+ouJw3ibO3I=;
        b=QiuLnbhzW7AAxFKAA1vPDWUvG/+9n3GRyMFGvGkABh+ViAGZ3Z7B0TJaajGUnVWSnB
         4rpqwsySrL5ZxjQd62qPttg5zb4AvHom3IQDQ+Prfs/aDByEfBnUqdJh/+RH9tnxN6UW
         JJ4IFeJIsgenJf+0+gsH0DvTmNSqi4Oozs4K1kubij7wh5CT8/G/LTwJk1s1oKsdmN2M
         tVw2DGPXgxbY0n3m2KX22byxcdO3rGap2ermuJ3K8VqlN17pT6NlNwNu2tFwilJSMGHq
         /y4Gx1Fyt+eMXpVBhG5WNc6Gjki8QMDKq2Z+8bDbwnR8FLY1uXuQsszHYcV3T8mPyRV3
         Vw3w==
X-Gm-Message-State: APjAAAVSGr4H5dEPmvMBmCadD7TUzJ6P/RIAkgQ5mChTEZwFZ9y+Rxge
        McEodoOojaUyZyvlmtgDPkOFNxgAbNM=
X-Google-Smtp-Source: APXvYqzsdhot/+6DT+7/5WL1D13+QiC8VcgUsPZYceagOwIvuM75lbAkelPUhk4u1rsT6pE2QE2FlQ==
X-Received: by 2002:a63:fc08:: with SMTP id j8mr1698731pgi.432.1557035615913;
        Sat, 04 May 2019 22:53:35 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id g72sm20634160pfg.63.2019.05.04.22.53.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 22:53:35 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH 1/2] x86: PMU: Fix PMU counters masking
Date:   Sat,  4 May 2019 15:31:41 -0700
Message-Id: <20190504223142.26668-2-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190504223142.26668-1-nadav.amit@gmail.com>
References: <20190504223142.26668-1-nadav.amit@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel SDM says that for MSR_IA32_PERFCTR0/1 "the lower-order 32 bits of
each MSR may be written with any value, and the high-order 8 bits are
sign-extended according to the value of bit 31." The current PMU tests
ignored the fact that the high bit is sign-extended.

At the same time, the fixed counters are not limited to 32-bit, but
appear to be limited to the width of the fixed counters (I could not
find clear documentation).

Fix the tests accordingly.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>

---

As a result of this fix, the fixed counters test currently fails on KVM.
I am unable to provide a bug-fix although the fix is simple.
---
 x86/pmu.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 6658fe9..afb387b 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -316,14 +316,19 @@ static void check_counter_overflow(void)
 	for (i = 0; i < num_counters + 1; i++, cnt.ctr++) {
 		uint64_t status;
 		int idx;
-		if (i == num_counters)
+
+		cnt.count = 1 - count;
+
+		if (i == num_counters) {
 			cnt.ctr = fixed_events[0].unit_sel;
+			cnt.count &= (1ul << edx.split.bit_width_fixed) - 1;
+		}
+
 		if (i % 2)
 			cnt.config |= EVNTSEL_INT;
 		else
 			cnt.config &= ~EVNTSEL_INT;
 		idx = event_to_global_idx(&cnt);
-		cnt.count = 1 - count;
 		measure(&cnt, 1);
 		report("cntr-%d", cnt.count == 1, i);
 		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
@@ -357,16 +362,25 @@ static void check_rdpmc(void)
 	report_prefix_push("rdpmc");
 
 	for (i = 0; i < num_counters; i++) {
-		uint64_t x = (val & 0xffffffff) |
-			((1ull << (eax.split.bit_width - 32)) - 1) << 32;
+		uint64_t x;
+
+		/*
+		 * Only the low 32 bits are writable, and the value is
+		 * sign-extended.
+		 */
+		x = (uint64_t)(int64_t)(int32_t)val;
+
+		/* Mask according to the number of supported bits */
+		x &= (1ull << eax.split.bit_width) - 1;
+
 		wrmsr(MSR_IA32_PERFCTR0 + i, val);
 		report("cntr-%d", rdpmc(i) == x, i);
 		report("fast-%d", rdpmc(i | (1<<31)) == (u32)val, i);
 	}
 	for (i = 0; i < edx.split.num_counters_fixed; i++) {
-		uint64_t x = (val & 0xffffffff) |
-			((1ull << (edx.split.bit_width_fixed - 32)) - 1) << 32;
-		wrmsr(MSR_CORE_PERF_FIXED_CTR0 + i, val);
+		uint64_t x = val & ((1ull << edx.split.bit_width_fixed) - 1);
+
+		wrmsr(MSR_CORE_PERF_FIXED_CTR0 + i, x);
 		report("fixed cntr-%d", rdpmc(i | (1 << 30)) == x, i);
 		report("fixed fast-%d", rdpmc(i | (3<<30)) == (u32)val, i);
 	}
-- 
2.17.1

