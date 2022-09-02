Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2262B5AB711
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 19:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236854AbiIBRBw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 13:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236676AbiIBRBu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 13:01:50 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0113DDA3CA
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 10:01:48 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 199so2497076pfz.2
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 10:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Vm/PQtsMRdh7Pbw/4p9noQ+tg28yZ0+v0kEq1eCWKD4=;
        b=CkXXcHNS74QYdJ9e1NnZgnh3uVejOIINykzPJi6+1fXrDGrv0jJSyOFb5qRUcW5/iL
         EY2dLxMXAVSd9HWxKc1w6YMzC31Bvkow3RstUPN8fDd1eqBgYHg1lL0WnsUbBLufx0/2
         8I8XoHAsYff0k2alAeR9BpU5rmLJwJUWEKcHq7pxnDJxxDOL9FgRojBBa9CuIgr21tNU
         W3b0LLhfi6kiQxAa3zn/Wqyjs3qJhiZSokdva/fpwv+riege1Q8b0rnjdC4qaZdX+afX
         o8QEjn68saj7tA5h+i7UryiRBvSHJMQ7Qhnt/OEnZUQLoy6WtEzQKo/ycSV5C9ZcG3uO
         7sTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Vm/PQtsMRdh7Pbw/4p9noQ+tg28yZ0+v0kEq1eCWKD4=;
        b=L+btm/Ub8rcv4qmqtXRWtOQcT/7BcVIZTOsdEuamp0oTp/4S0tsRGOfuIm3hAnVU/6
         h5ekEbZfWcMg91Gnnp/0Bnr5sanFyuwLW6n1ag6UaEbfqR/KKLUSBdx4AsOLn2tO30TF
         SduplexAgrX00NjLjRfz5JCHy+LSWj6yHvwSu54hgSFX/0zvFpcbq9X4BKQWlbVimVxP
         j38iiFxDCRUxFV6gCPZFkMWI9yV4XwZseRQkOQ6JulDAIYLTvw/DfmXHUYCCZ1S7lBHc
         czLHJ80pJuULBNqN2yu3//beksvS849TL4m1BYCwUYbBH7hAEbmhhtYf0Y78l+sT4XJs
         rkCQ==
X-Gm-Message-State: ACgBeo398rjRGzg3/1jcCQBcPPwaMUDXAeg6v0ripH1fSkutzXv6PwU6
        hLHi487myImBLHorHLQzJ/D3IZgV73dzwQ==
X-Google-Smtp-Source: AA6agR4XTOArH8T6f1P6llgRGm5gyZO4n41IcmSaVSLCUa7S2QZEh/HuEaSl6Wg82L2tiR2gYRy8wA==
X-Received: by 2002:a05:6a00:b43:b0:52f:59dc:93 with SMTP id p3-20020a056a000b4300b0052f59dc0093mr37082459pfo.26.1662138108131;
        Fri, 02 Sep 2022 10:01:48 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([171.76.83.155])
        by smtp.gmail.com with ESMTPSA id w10-20020a65534a000000b0043014f9a4c9sm1638800pgr.93.2022.09.02.10.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 10:01:47 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 1/3] RISC-V: Probe Svinval extension form ISA string
Date:   Fri,  2 Sep 2022 22:31:29 +0530
Message-Id: <20220902170131.32334-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220902170131.32334-1-apatel@ventanamicro.com>
References: <20220902170131.32334-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mayuresh Chitale <mchitale@ventanamicro.com>

Just like other ISA extensions, we allow callers/users to detect the
presence of Svinval extension from ISA string.

Signed-off-by: Mayuresh Chitale <mchitale@ventanamicro.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/hwcap.h | 4 ++++
 arch/riscv/kernel/cpu.c        | 1 +
 arch/riscv/kernel/cpufeature.c | 1 +
 3 files changed, 6 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 6f59ec64175e..b22525290073 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -58,6 +58,7 @@ enum riscv_isa_ext_id {
 	RISCV_ISA_EXT_ZICBOM,
 	RISCV_ISA_EXT_ZIHINTPAUSE,
 	RISCV_ISA_EXT_SSTC,
+	RISCV_ISA_EXT_SVINVAL,
 	RISCV_ISA_EXT_ID_MAX = RISCV_ISA_EXT_MAX,
 };
 
@@ -69,6 +70,7 @@ enum riscv_isa_ext_id {
 enum riscv_isa_ext_key {
 	RISCV_ISA_EXT_KEY_FPU,		/* For 'F' and 'D' */
 	RISCV_ISA_EXT_KEY_ZIHINTPAUSE,
+	RISCV_ISA_EXT_KEY_SVINVAL,
 	RISCV_ISA_EXT_KEY_MAX,
 };
 
@@ -90,6 +92,8 @@ static __always_inline int riscv_isa_ext2key(int num)
 		return RISCV_ISA_EXT_KEY_FPU;
 	case RISCV_ISA_EXT_ZIHINTPAUSE:
 		return RISCV_ISA_EXT_KEY_ZIHINTPAUSE;
+	case RISCV_ISA_EXT_SVINVAL:
+		return RISCV_ISA_EXT_KEY_SVINVAL;
 	default:
 		return -EINVAL;
 	}
diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
index 0be8a2403212..7d1cd653ca02 100644
--- a/arch/riscv/kernel/cpu.c
+++ b/arch/riscv/kernel/cpu.c
@@ -96,6 +96,7 @@ static struct riscv_isa_ext_data isa_ext_arr[] = {
 	__RISCV_ISA_EXT_DATA(zicbom, RISCV_ISA_EXT_ZICBOM),
 	__RISCV_ISA_EXT_DATA(zihintpause, RISCV_ISA_EXT_ZIHINTPAUSE),
 	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
+	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
 	__RISCV_ISA_EXT_DATA("", RISCV_ISA_EXT_MAX),
 };
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 3b5583db9d80..9774f1271f93 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -204,6 +204,7 @@ void __init riscv_fill_hwcap(void)
 				SET_ISA_EXT_MAP("zicbom", RISCV_ISA_EXT_ZICBOM);
 				SET_ISA_EXT_MAP("zihintpause", RISCV_ISA_EXT_ZIHINTPAUSE);
 				SET_ISA_EXT_MAP("sstc", RISCV_ISA_EXT_SSTC);
+				SET_ISA_EXT_MAP("svinval", RISCV_ISA_EXT_SVINVAL);
 			}
 #undef SET_ISA_EXT_MAP
 		}
-- 
2.34.1

