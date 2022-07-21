Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52D257D307
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 20:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbiGUSMc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 14:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiGUSM3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 14:12:29 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4DD3DBD2
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 11:12:27 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id r186so2380955pgr.2
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 11:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k7oAEso24XUyiMu0RhEG3Nlz67s2VkRn8qN/IYX5xGk=;
        b=e4v5kYM9VG4DZw0IIxSlfEM9WcRpuHzW+aUXV6hSu/yuTBN2zvgBptWTPIqr+OOL7U
         M4p1sac+9UivJeffTW/Ct3miDf1y/PJKINANXsgviIQD8x4vSDwB7iZY9AmXGxYTsU+7
         PiYJhVOIkGlfMUm/SJWbgAj8qdHQz0JF8WWC3+1f5cX5AXhUAcoK0UrRXNjCSoLnytGl
         /TFysN8Zgm2nGPj7DwNU1xZamTCq2hQ4ShaIS1en4EsSn1KBqsuin2lvgPecVOPcUzaf
         tlBj+TNJofOJs9cx3SwLdVEmD37KwfTpI/HdSOI5j08fFkQGsPS3hLEIrJXM1oXtfipw
         kGjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k7oAEso24XUyiMu0RhEG3Nlz67s2VkRn8qN/IYX5xGk=;
        b=EUJnFuBFvDxFDjq6Zrfb+dLxT+VtyRPymHSy4NpyVYw4tNEPWLZ/Hp0zh8LwsaDLZm
         9TZrgyUYJOgJvuQz3sSDrRGsBUWxmRN22LmC4ExheOIBygeEoCs4sz8SgRwQAiMCImlq
         BsN2lJs6BygH9YU4nLQBToXX8GtT8RPsaa7fnWubbuOHJ1GjIxprhwZuhwq9fqNMgI84
         X7AfvKGuIqg47VSiP8DF3p8d532kP8Pa0aHz7PRaSXod2q3fk9ZTC12DS5c99pTrF4XR
         8ijk/iAB8Sx/KLkenDN7NVlmBOvAqZfDs8aiJbvA19AeMFMsq1ygamj7Itj/07nRbhPG
         ll2w==
X-Gm-Message-State: AJIora+dScxjtsoefLKQv8K92VypfmaB1Rwo+TOID5L0DY7Eb4O7mgP+
        fs+d8DuscPzvJAMPqHeGPkIRXw==
X-Google-Smtp-Source: AGRyM1t6vxRkdk5QsbyWbVO79Sk4ZCIpAMQ4DLkJlBMooxcrWoVenWvw9yGMAn+ygbbtEoAGioMJbg==
X-Received: by 2002:a63:c53:0:b0:412:6f28:7a87 with SMTP id 19-20020a630c53000000b004126f287a87mr40570740pgm.136.1658427147128;
        Thu, 21 Jul 2022 11:12:27 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b0016d3a354cffsm617358plm.89.2022.07.21.11.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 11:12:26 -0700 (PDT)
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
        Thomas Gleixner <tglx@linutronix.de>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Wei Fu <wefu@redhat.com>
Subject: [PATCH v6 3/4] RISC-V: Prefer sstc extension if available
Date:   Thu, 21 Jul 2022 11:12:11 -0700
Message-Id: <20220721181212.3705138-4-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220721181212.3705138-1-atishp@rivosinc.com>
References: <20220721181212.3705138-1-atishp@rivosinc.com>
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
 drivers/clocksource/timer-riscv.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
index 593d5a957b69..3f100fb53d82 100644
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
@@ -23,11 +26,24 @@
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
 
@@ -165,6 +181,12 @@ static int __init riscv_timer_init_dt(struct device_node *n)
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

