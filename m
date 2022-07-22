Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC2F57E4D3
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 18:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbiGVQvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 12:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235867AbiGVQvA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 12:51:00 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019332181E
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 09:50:59 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id t2-20020a17090a4e4200b001f21572f3a4so4721987pjl.0
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 09:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fhiEUpY832dBqpBZs6lVDJUJh/wPjhRPH5Wz0gZOdjs=;
        b=dlpFbmXItlUG9AvAKQ4H72BXu7Ec0gAYulbojqhVRlPlmOQtGwb0eiZ2TMO2TCDDrj
         DnL31uggr5tjrAfWw7V9MNiEU/aMiiaCv86V7QRe6dTtRLRyvr/Myez57yefVPu79b9a
         R3r744egp5g760mv20a1p2v3LqLYnEICd03OzMW1NmHz9mgyBnS6xXAycfkF/JmOa7V0
         pBu2teIE9lF7a0FyNp+c9fI/Em3+ZOb4oRMHK4OnKeF3P4aKM5aDtdfr56IcgqXK2kHP
         by52M9Tm29aOBwPMFiHW4YZ2DWiSLPoihmkCKzsL7cyyoHA4euIFOr/SEF/GcVFvmD2j
         O6sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fhiEUpY832dBqpBZs6lVDJUJh/wPjhRPH5Wz0gZOdjs=;
        b=AVPkwAVc+j1NzIM5rg+uFC2Bd1XmoA79yVnnRKlI2Ua7j0/5bO8inBn4lNsTsvYmyl
         8B3FDvG2Jyee7VHddwZ8UKQyxm4Tx1585kOmA7gim+quCprpOjnxcCC0QOb0WPz3pqz+
         2Irnw4frwQX5HmXtS67ObobPe4cx1tlRvJ8LZHuIMsGq0qfWUo+f5lOko1z6nsgxuwHT
         x7N8eOhEMbRN9Q69I8EmBnaSryespKK05YY1R+cAoKQHLK5eDWV8hrg7zVdJpNz19lg8
         VaSIxax6N/BHGCvIEZ4Xz3ze/WMO2IRz4vvUQMhwIdwbhHVBnmwuA8To/dTw3FLdOME2
         Wg2g==
X-Gm-Message-State: AJIora/sbHs/clcBCgDDKjrFv/57BsPZStPUbFzQO9GDsaOlUlvD4xcp
        zUQV2J2Aip69niBqqiEiBLL3qw==
X-Google-Smtp-Source: AGRyM1vRTM3hIrzt2q2YQt5RlR51I0fFh7y/0/pkqJWtGugoh6yMC2nGJ0JNrvJjfz1pnKXpBNa4Nw==
X-Received: by 2002:a17:902:70cc:b0:16c:60e0:50fb with SMTP id l12-20020a17090270cc00b0016c60e050fbmr443033plt.156.1658508658489;
        Fri, 22 Jul 2022 09:50:58 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902ea0700b0016a3f9e4865sm4028476plg.148.2022.07.22.09.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 09:50:58 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rob Herring <robh@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Wei Fu <wefu@redhat.com>
Subject: [PATCH v7 3/4] RISC-V: Prefer sstc extension if available
Date:   Fri, 22 Jul 2022 09:50:46 -0700
Message-Id: <20220722165047.519994-4-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220722165047.519994-1-atishp@rivosinc.com>
References: <20220722165047.519994-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RISC-V ISA has sstc extension which allows updating the next clock event
via a CSR (stimecmp) instead of an SBI call. This should happen dynamically
if sstc extension is available. Otherwise, it will fallback to SBI call
to maintain backward compatibility.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/clocksource/timer-riscv.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
index 593d5a957b69..05f6cf067289 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -7,6 +7,9 @@
  * either be read from the "time" and "timeh" CSRs, and can use the SBI to
  * setup events, or directly accessed using MMIO registers.
  */
+
+#define pr_fmt(fmt) "riscv-timer: " fmt
+
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
 #include <linux/cpu.h>
@@ -20,14 +23,28 @@
 #include <linux/of_irq.h>
 #include <clocksource/timer-riscv.h>
 #include <asm/smp.h>
+#include <asm/hwcap.h>
 #include <asm/sbi.h>
 #include <asm/timex.h>
 
+static DEFINE_STATIC_KEY_FALSE(riscv_sstc_available);
+
 static int riscv_clock_next_event(unsigned long delta,
 		struct clock_event_device *ce)
 {
+	u64 next_tval = get_cycles64() + delta;
+
 	csr_set(CSR_IE, IE_TIE);
-	sbi_set_timer(get_cycles64() + delta);
+	if (static_branch_likely(&riscv_sstc_available)) {
+#if defined(CONFIG_32BIT)
+		csr_write(CSR_STIMECMP, next_tval & 0xFFFFFFFF);
+		csr_write(CSR_STIMECMPH, next_tval >> 32);
+#else
+		csr_write(CSR_STIMECMP, next_tval);
+#endif
+	} else
+		sbi_set_timer(next_tval);
+
 	return 0;
 }
 
@@ -165,6 +182,12 @@ static int __init riscv_timer_init_dt(struct device_node *n)
 	if (error)
 		pr_err("cpu hp setup state failed for RISCV timer [%d]\n",
 		       error);
+
+	if (riscv_isa_extension_available(NULL, SSTC)) {
+		pr_info("Timer interrupt in S-mode is available via sstc extension\n");
+		static_branch_enable(&riscv_sstc_available);
+	}
+
 	return error;
 }
 
-- 
2.25.1

