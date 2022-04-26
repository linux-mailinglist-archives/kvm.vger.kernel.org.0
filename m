Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D56E25107AA
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 20:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353017AbiDZS41 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 14:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353151AbiDZS4W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 14:56:22 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E849F1569EB
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 11:53:10 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d15so31057613pll.10
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 11:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KslgnjbYCZy+RC57ZlL0pYo5UT2utIjDNcmnyodLbb4=;
        b=mlb9fCc5rb7zG7mTZaJ0VEWPjisdXFLSvYf5s+ONK4bMBESNNjkC9LspUvLeDIH7qg
         KJWqNCNtmrDhGwSK8WWziE2vvMlKPHdrhOkxTNKqVrH4bzYAGPS3JOAcgn9uJq2U7GIc
         rqsSRnlpOfMuOq6EQMF6XQB3zL1qkroK77mrAmkPgolCGxAEvrggowjCIMTKALEz7O5L
         T0apibn7Lov23G7OW7GMaHKpIMQhO9kHaeUhCdh6NwztivMdV78PW8DemC/NYlrXYNCa
         Tbvw8tsT61VlPxpax/4JEuuCl543oeV9N3N8bh+s/UR7NZ4AcjNRTV5pmDrO2xmEU0Yu
         0vVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KslgnjbYCZy+RC57ZlL0pYo5UT2utIjDNcmnyodLbb4=;
        b=IzkBhpQNdvYBoJP8nNMBWRy2fZhY5HOZeHfi8FCN9s1xBMgbL+V/UMT2lJi1fCvGDA
         OiWzSBSAqRAHJgL042gzbLQ4UBiZHp+iDLruDUS3DtIEPFeHdfl4eskuvftGOGNwy3Tl
         4CTNK3vXuMS1QeUsroA1p/SfFiCal+ueJp0XuDXtHpaQT2awZYmWcixGveJH1oEzIMtc
         MBEJbFFgqbv8CFuM//ZmqDUZYC1U/SWT5nfbW1F1hwafApZRAzGmoLh5WuVkhrR5avxb
         4YDjOcnl8/yiGZCkypmrzyknHAv6IP+ocTCQS0MePuo+yXp40kRXfaBQE5F+bxWJ7YAN
         Dhog==
X-Gm-Message-State: AOAM530URHF9Q8lj4zzkKC/eVXwfDPXmPUXbVUIBrergURqvMP0PE51a
        H7QtWlNibXpLkQ26JMf+On4YdA==
X-Google-Smtp-Source: ABdhPJydAWW3DEffEILPWDD4OW996Ze0tqBY9UvoB/z8q/qtxrBuRCzG4CK+M8gIY/YrqzWEtsn8HQ==
X-Received: by 2002:a17:902:d645:b0:158:f267:83b1 with SMTP id y5-20020a170902d64500b00158f26783b1mr25064870plh.11.1650999190315;
        Tue, 26 Apr 2022 11:53:10 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id cl18-20020a17090af69200b001cd4989ff5asm3839664pjb.33.2022.04.26.11.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 11:53:09 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Atish Patra <atishp@atishpatra.org>,
        Anup Patel <anup@brainfault.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        devicetree@vger.kernel.org, Jisheng Zhang <jszhang@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH v3 2/4] RISC-V: Enable sstc extension parsing from DT
Date:   Tue, 26 Apr 2022 11:52:43 -0700
Message-Id: <20220426185245.281182-3-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220426185245.281182-1-atishp@rivosinc.com>
References: <20220426185245.281182-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ISA extension framework now allows parsing any multi-letter
ISA extension.

Enable that for sstc extension.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/hwcap.h | 1 +
 arch/riscv/kernel/cpu.c        | 1 +
 arch/riscv/kernel/cpufeature.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 0734e42f74f2..25915eb60d61 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -52,6 +52,7 @@ extern unsigned long elf_hwcap;
  */
 enum riscv_isa_ext_id {
 	RISCV_ISA_EXT_SSCOFPMF = RISCV_ISA_EXT_BASE,
+	RISCV_ISA_EXT_SSTC,
 	RISCV_ISA_EXT_ID_MAX = RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
index ccb617791e56..ca0e4c0db17e 100644
--- a/arch/riscv/kernel/cpu.c
+++ b/arch/riscv/kernel/cpu.c
@@ -88,6 +88,7 @@ int riscv_of_parent_hartid(struct device_node *node)
  */
 static struct riscv_isa_ext_data isa_ext_arr[] = {
 	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
+	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
 	__RISCV_ISA_EXT_DATA("", RISCV_ISA_EXT_MAX),
 };
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 1b2d42d7f589..a214537c22f1 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -192,6 +192,7 @@ void __init riscv_fill_hwcap(void)
 				set_bit(*ext - 'a', this_isa);
 			} else {
 				SET_ISA_EXT_MAP("sscofpmf", RISCV_ISA_EXT_SSCOFPMF);
+				SET_ISA_EXT_MAP("sstc", RISCV_ISA_EXT_SSTC);
 			}
 #undef SET_ISA_EXT_MAP
 		}
-- 
2.25.1

