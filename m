Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97D9697325
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbjBOBH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbjBOBHc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:07:32 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4761305C1
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:07:29 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-52ec8c88d75so153433697b3.12
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I+uK5I847Ub+3lN0aBU7Gcssw6jbSaFlZxnmEwJsF78=;
        b=kEGDGgMAIhF4WS+uWDkyobWv0l+l/abqGQR5J9Ib3vG7/2CW2w00Im9EQC8yt+LmU5
         aBpYEjxKJO5KwUDKL6A+OgHwEdEfdGVlunFgEJ0ktKo0TEkEicL42N/2+6h4LBlqiFlV
         EVPXRfisozsa8/Ak2bQrEuHlDM4KrVy0LUz8NkvwjSwTjDdpxh7Qo5hPw6EFMdFhqqbd
         XNV3Cb7Fm9kGvxLo7Oz0cCu0/JHFejb9zWSDrDz/f0SykUMsKeTkHWF2G77h+yxGfMlP
         1WnpYGTKTmzFCIS7p1IDYnFsG7BN9QAT6YbQ6AfRVEWAaYUAJu4jESt67UodFPKa0cyy
         /ItQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I+uK5I847Ub+3lN0aBU7Gcssw6jbSaFlZxnmEwJsF78=;
        b=vCnCKQ8xKTsaY56oKA4xQsMD8tlIUsmxIOpfJo+3peoUifOmIo5Kdrddj7hkE4tPnN
         zTj/GSgajp8ou/Lacg9hn8bQneUfZMbLU6ZEXRFAgcJYp7yHwwqfqAEXYYg/sWjz4My4
         faGP4YEm1iElswgiEMDTbMGSTX7mRFKGtR7V1pi+/Rh3NcwXGNxswUnQtuo+HCfnQc9l
         OKPa6uaxnrQmY9nYmbf/ACE6D9fPuo95KG/oJPCnQKzj86qeC2+dN+RTCZi04cjCMtyK
         TiO/UX4GDxlTzlo+MgDiW3TWinzaIDdyWu10d0uIsma0ppuap0gf7+r0KFFhxUey+Y5u
         Ni4g==
X-Gm-Message-State: AO0yUKXVT2mOwJCniww7Sx5t9TjrzOvu4UhGOQ5egdIz+mzxNj17nk0E
        J8GO5vDHk6k4d30nLVm7lOnW+rwJrAsA
X-Google-Smtp-Source: AK7set91iu1Pp41RZ1Xv7Dro5d0bpbq1rHsaKAxqEIG8x/vMkAhgvV2qniDnuybFL/IYT9ABfXBZ9sg+uh1R
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a5b:c2:0:b0:855:fdcb:446d with SMTP id
 d2-20020a5b00c2000000b00855fdcb446dmr3ybp.6.1676423248137; Tue, 14 Feb 2023
 17:07:28 -0800 (PST)
Date:   Wed, 15 Feb 2023 01:07:07 +0000
In-Reply-To: <20230215010717.3612794-1-rananta@google.com>
Mime-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215010717.3612794-7-rananta@google.com>
Subject: [REPOST PATCH 06/16] tools: arm64: perf_event: Define Cycle counter
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

