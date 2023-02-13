Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E22B694EA7
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 19:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjBMSC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 13:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjBMSCv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 13:02:51 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE2C1F91B
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 10:02:43 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id r11-20020a6b8f0b000000b0071853768168so8925202iod.23
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 10:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I+uK5I847Ub+3lN0aBU7Gcssw6jbSaFlZxnmEwJsF78=;
        b=QbdYvBJWHHUW2D1muNpyWaqx7zQissf8ygmzU3xHnetuuSzhAGPmBNebmkvWnEv3Xz
         0jTCK1eWSC3eS7VG05SG9/FEi8vrnebVB2jiUNG9uyANwJOnQEbKNRaRfVC8qN3KlsXd
         Rb7FZJQCo48VHQ5nbIMEllm2vsR2a8e8QO0sBnWaEwoXOJcijWRfplFKi31C6/eZC2hl
         CDRxtjZxnwD6IpsDftFHB8SBdayD9oQvAHBbKF9YvKcJEuRACq+a/5OsQTF53rsLP01P
         9TtEQC0bRtuTmKo8G83KZK+lIFZkGfzIN2Lo/u/KWJLSOnf/yAbo8wQZT1gT4X3o0f7A
         /H3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I+uK5I847Ub+3lN0aBU7Gcssw6jbSaFlZxnmEwJsF78=;
        b=pfW5DyujuBHv1JzXIFle3E3phPPUFHaRj096gAL7yZTv/VoSaMWaj3W4pSNevDL9ri
         8Y1jdylR91pAPI5cRqyTNKcRYtmWTFBgNwOOUdghlwPIW0f1gtL167XaWlA0OssZusJb
         j1N5VcRvbRPzFvt6tJGtj4S+3VsZEpCehHpDL8/gAKLEru3YEWPJE0Dr2zRHnvu8AAjO
         bJoYZ4lE/E/jdu+M081mexPBIMQ/a0ck78jx0w87l3ljSIC5LPTCDIVL3DVHpmTL6J77
         bCv32+wp1oXZIc1rJFIXPvIQVT7tbhShq35Av1v51/GF5I2QIJQVLijcA3TKRfCLWx/F
         BV3Q==
X-Gm-Message-State: AO0yUKUC3cMLlMAhShj1UODNXuid2h4YRlPY5gzivrUuoJTHP+heWCNp
        iAmAjMQuZcnIn8vNlJdaH7dK4tk0Pacl
X-Google-Smtp-Source: AK7set9juY00LvKn0j/zEJmqdLAxmL1I6OU4HnYIt4dcFolsJ+3w6e8YxMwoo+OzXJYGRW6YP6suEVqRXC4+
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a5d:9c49:0:b0:718:b11d:a972 with SMTP id
 9-20020a5d9c49000000b00718b11da972mr11228352iof.36.1676311362812; Mon, 13 Feb
 2023 10:02:42 -0800 (PST)
Date:   Mon, 13 Feb 2023 18:02:24 +0000
In-Reply-To: <20230213180234.2885032-1-rananta@google.com>
Mime-Version: 1.0
References: <20230213180234.2885032-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230213180234.2885032-4-rananta@google.com>
Subject: [PATCH 03/13] tools: arm64: perf_event: Define Cycle counter
 enable/overflow bits
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the definitions of ARMV8_PMU_CNTOVS_C (Cycle counter overflow
bit) for overflow status registers and ARMV8_PMU_CNTENSET_C (Cycle
counter enable bit) for PMCNTENSET_EL0 register.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/arch/arm64/include/asm/perf_event.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/arch/arm64/include/asm/perf_event.h b/tools/arch/arm64/include/asm/perf_event.h
index 97e49a4d4969f..8ce23aabf6fe6 100644
--- a/tools/arch/arm64/include/asm/perf_event.h
+++ b/tools/arch/arm64/include/asm/perf_event.h
@@ -222,9 +222,11 @@
 /*
  * PMOVSR: counters overflow flag status reg
  */
+#define ARMV8_PMU_CNTOVS_C      (1 << 31) /* Cycle counter overflow bit */
 #define	ARMV8_PMU_OVSR_MASK		0xffffffff	/* Mask for writable bits */
 #define	ARMV8_PMU_OVERFLOWED_MASK	ARMV8_PMU_OVSR_MASK
 
+
 /*
  * PMXEVTYPER: Event selection reg
  */
@@ -247,6 +249,11 @@
 #define ARMV8_PMU_USERENR_CR	(1 << 2) /* Cycle counter can be read at EL0 */
 #define ARMV8_PMU_USERENR_ER	(1 << 3) /* Event counter can be read at EL0 */
 
+/*
+ * PMCNTENSET: Count Enable set reg
+ */
+#define ARMV8_PMU_CNTENSET_C    (1 << 31) /* Cycle counter enable bit */
+
 /* PMMIR_EL1.SLOTS mask */
 #define ARMV8_PMU_SLOTS_MASK	0xff
 
-- 
2.39.1.581.gbfd45094c4-goog

