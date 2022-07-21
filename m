Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C5157D303
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 20:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiGUSMb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 14:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiGUSM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 14:12:27 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348653DF3A
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 11:12:26 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id f65so2335477pgc.12
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 11:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JO4EgaFLA+7AeATY37WXQlGJ9vdJOA0mjTrTo1yHUWU=;
        b=riG2PtdLx0LlINs136KP5QyxDhqO+kVaZVCGH/J20pnAzCaWI0cNrw4ZKDVwIuQKzI
         s3DpyvOseHncIaaYhLOH8rx0kDgBjdmQ+VaSyFC5Te26GWSMTn/iDiwdMBSLbbySx1iz
         A/QtjMMVexwd7x+C6X+5Ka4WgCzL9oKKHK5fhduu7Y23VDfSJydWvcxzBlHNX0Y+JYow
         NlMMiIdZ8WTGaMGAdW+qWVbhP8ut+rKWjmzGrXNcbphrgxn9ziKf6TOmHxQcna3Xki3q
         g8zUDW456eefJqNCiXx4tF9aQ2VC3p4v6vcz4bF3Eb40szoNeVQvHZVgjCQsvw1DqLsg
         It4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JO4EgaFLA+7AeATY37WXQlGJ9vdJOA0mjTrTo1yHUWU=;
        b=jHaKdPldmJ/oUSqZgDm8YjiIDTs1q8jkPRqGxmoWGpZD57O6/FLqo9epSrNYdfyT/8
         K0gl72f5CoxGjPHV29ORC4B+4yeA38qBlBnCx52Jvddd+zKJZXzvwSklgQx7Kdqb9U3y
         NW+NmNxK6A4+GKFeK6WjNCs4UiQXUBcWWfRXUruXN4Fh0pYik4Mm7XZUycXSmPeSgi66
         odXMr7+B+dwSxBW8TSmzhxbzxtQFA1490CDbeildoMpD0iG7jo+f+Or4ZOpZyoLWpxA2
         aBlVHvacccxyoOHUO7zdeUnArVLPgVT2Y2pQ6U7DZKln/XogqkpD97zldai9NxZKYQpD
         usIQ==
X-Gm-Message-State: AJIora/P6+7o+pwoFq/irM3KuB7MMlqazGqncQmxLjgk+pjWwauln1Al
        hoBeWtKl8BWOA9SIPaPhA6X5NA==
X-Google-Smtp-Source: AGRyM1vCz2MPQ+o0CTmBQcVDehcx5aKC828ghajOSEd6ubFHv0tSkQh5zBLbLycgTGSqipKoq1bssQ==
X-Received: by 2002:a63:ff4c:0:b0:412:b100:786b with SMTP id s12-20020a63ff4c000000b00412b100786bmr39952104pgk.537.1658427145703;
        Thu, 21 Jul 2022 11:12:25 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b0016d3a354cffsm617358plm.89.2022.07.21.11.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 11:12:25 -0700 (PDT)
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
Subject: [PATCH v6 2/4] RISC-V: Enable sstc extension parsing from DT
Date:   Thu, 21 Jul 2022 11:12:10 -0700
Message-Id: <20220721181212.3705138-3-atishp@rivosinc.com>
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

The ISA extension framework now allows parsing any multi-letter
ISA extension.

Enable that for sstc extension.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/hwcap.h | 1 +
 arch/riscv/kernel/cpu.c        | 1 +
 arch/riscv/kernel/cpufeature.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 4e2486881840..b186fff75198 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -53,6 +53,7 @@ extern unsigned long elf_hwcap;
 enum riscv_isa_ext_id {
 	RISCV_ISA_EXT_SSCOFPMF = RISCV_ISA_EXT_BASE,
 	RISCV_ISA_EXT_SVPBMT,
+	RISCV_ISA_EXT_SSTC,
 	RISCV_ISA_EXT_ID_MAX = RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
index fba9e9f46a8c..0016d9337fe0 100644
--- a/arch/riscv/kernel/cpu.c
+++ b/arch/riscv/kernel/cpu.c
@@ -89,6 +89,7 @@ int riscv_of_parent_hartid(struct device_node *node)
 static struct riscv_isa_ext_data isa_ext_arr[] = {
 	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
 	__RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
+	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
 	__RISCV_ISA_EXT_DATA("", RISCV_ISA_EXT_MAX),
 };
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 12b05ce164bb..034bdbd189d0 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -199,6 +199,7 @@ void __init riscv_fill_hwcap(void)
 			} else {
 				SET_ISA_EXT_MAP("sscofpmf", RISCV_ISA_EXT_SSCOFPMF);
 				SET_ISA_EXT_MAP("svpbmt", RISCV_ISA_EXT_SVPBMT);
+				SET_ISA_EXT_MAP("sstc", RISCV_ISA_EXT_SSTC);
 			}
 #undef SET_ISA_EXT_MAP
 		}
-- 
2.25.1

