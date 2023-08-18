Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE8C7815D9
	for <lists+kvm@lfdr.de>; Sat, 19 Aug 2023 01:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242467AbjHRXfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 19:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241952AbjHRXfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 19:35:18 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5549C26AA
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 16:35:17 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-268099fd4f5so1704934a91.1
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 16:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692401717; x=1693006517;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ym9SwmeM0EPR5aYHYUdgC/P1fnr32QdCKm3f+6XcXjc=;
        b=Fv0Xz376xgfbogeLVo/xFfuLTRzprBEz5ZaGPXB4Ur1hfEMZIxb1yuw4VUcU7eJc94
         dzehw7VYLMIm9IkWTD0asKDJDmvBiYp9oXxAVB4B1JfWh+ywV6o31j0Yd4wLak36umaa
         +d5AyiEIcenOU5yVmxpLlgY3QPvYZhkM9rATPtRN7O/jU9tj86CrtrjrKkQgbpOm8Pj4
         3k5MJqvXJcSFnt7TwMa0k2dLebjdKSkm0guwxab6EkC6UjLSDYSWvGiSn/L8wt/QGYLA
         OA3VZB01v5tyvYxhBndx1DKpDsujYyisDDzwyXS/3OiuppqSUoaXISYPLIw5WNs485lU
         ROAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692401717; x=1693006517;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ym9SwmeM0EPR5aYHYUdgC/P1fnr32QdCKm3f+6XcXjc=;
        b=VJM+/kjtdjOi2dfSXEXz99gwZgzHCI2lWkzlduOhVfcd8lwe8zXUxHXTy31hLI3hSC
         ytVpwSLOqw254wvcZZATesK518Bd75ZymaudoDSk2PLpcycntV36aFHisRsm72ZQymul
         bJjS1jiYvlVWkq4DcV40TqOXpAy4Be+B2xPffvtJbgLJYoKGhGB+qcqnGdM0UaSyCAT7
         TcVwgK0mIlptZjpgal6lqpUXZLUAxUfjp9EUuotCiY1a7rNKNYA4yJWiw09InK40tHoW
         ANvUyLJgX+/J5KrKhGKlxhMgBw7d9QA9x0bH/Aupe88blBcb2laJZPuZQjbS/PosSV0W
         J2Bg==
X-Gm-Message-State: AOJu0Yzy1/uNiqcd2uyC+YIjZ7aiUmGJKTP1UFWUkQOpoBqq2J8Gy3YO
        1Y3jmZDBX7LDtoMxpRavSm7BkCwv4z8rcQLltA==
X-Google-Smtp-Source: AGHT+IGPoBEVZBfu7UdhnVUWQ69Uoqx9M/TxjOmX9oQgTBDD0sje061EEqzwCebhqYC+9MOR0gBKrC6ClC3SPuJMvg==
X-Received: from riemann.sea.corp.google.com ([2620:15c:100:201:63a2:7ca2:9ea:acb8])
 (user=srutherford job=sendgmr) by 2002:a17:90b:e8b:b0:26d:a6b:9a47 with SMTP
 id fv11-20020a17090b0e8b00b0026d0a6b9a47mr168989pjb.2.1692401716766; Fri, 18
 Aug 2023 16:35:16 -0700 (PDT)
Date:   Fri, 18 Aug 2023 16:34:51 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230818233451.3615464-1-srutherford@google.com>
Subject: [PATCH] x86/sev: Make early_set_memory_decrypted() calls page aligned
From:   Steve Rutherford <srutherford@google.com>
To:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David.Kaplan@amd.com,
        jacobhxu@google.com, patelsvishal@google.com, bhillier@google.com,
        Steve Rutherford <srutherford@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

early_set_memory_decrypted() assumes its parameters are page aligned.
Non-page aligned calls result in additional pages being marked as
decrypted via the encryption status hypercall, which results in
consistent corruption of pages during live migration. Live
migration requires accurate encryption status information to avoid
migrating pages from the wrong perspective.

Fixes: 4716276184ec ("X86/KVM: Decrypt shared per-cpu variables when SEV is active")
Signed-off-by: Steve Rutherford <srutherford@google.com>
---
 arch/x86/kernel/kvm.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 6a36db4f79fd..a0c072d3103c 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -419,7 +419,14 @@ static u64 kvm_steal_clock(int cpu)
 
 static inline void __set_percpu_decrypted(void *ptr, unsigned long size)
 {
-	early_set_memory_decrypted((unsigned long) ptr, size);
+	/*
+	 * early_set_memory_decrypted() requires page aligned parameters, but
+	 * this function needs to handle ptrs offset into a page.
+	 */
+	unsigned long start = PAGE_ALIGN_DOWN((unsigned long) ptr);
+	unsigned long end = (unsigned long) ptr + size;
+
+	early_set_memory_decrypted(start, end - start);
 }
 
 /*
@@ -438,6 +445,11 @@ static void __init sev_map_percpu_data(void)
 		return;
 
 	for_each_possible_cpu(cpu) {
+		/*
+		 * Calling __set_percpu_decrypted() for each per-cpu variable is
+		 * inefficent, since it may decrypt the same page multiple times.
+		 * That said, it avoids the need for more complicated logic.
+		 */
 		__set_percpu_decrypted(&per_cpu(apf_reason, cpu), sizeof(apf_reason));
 		__set_percpu_decrypted(&per_cpu(steal_time, cpu), sizeof(steal_time));
 		__set_percpu_decrypted(&per_cpu(kvm_apic_eoi, cpu), sizeof(kvm_apic_eoi));
-- 
2.42.0.rc1.204.g551eb34607-goog

