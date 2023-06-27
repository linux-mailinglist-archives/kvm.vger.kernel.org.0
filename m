Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4C373FB64
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 13:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbjF0Lvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 07:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbjF0Lvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 07:51:48 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC35E69
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 04:51:47 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-98df3dea907so422970666b.3
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 04:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687866705; x=1690458705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wwRqncGBMw48ZRHZQQygcwpEXInzVqgYCZMTOEm7gro=;
        b=mnixBROMk4W/E5oZOyhcDKzrHtFUiMXo/SHSOVZCdjVa4W+QHAk1YP6JN0WdriXCRg
         7kgoxdRSdpXiXm9/tuZtgVuUAVG4ULDZsoY7BNnEAtsId8Zrgl3kiwhYh8lszegl3BbK
         eboQUwrTSJ19pIAC5BvplUdAQ5sUlzxk+8+17nFe/f8c02iQ5HztThoAHTWuKxBxryTN
         vQz3qYE32MLVfAyKfOuC1Jf5fuf2ID3FOaFQZuzkK/hinGVcshX/IMsG6Y03ITu8CKRp
         tLJv9jBxZg9m/AMaSr9x1W1DFD3qMA1U+SUcDCepP90EDHA7/670RNlWEjyMxhvaXW6J
         bCDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687866705; x=1690458705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wwRqncGBMw48ZRHZQQygcwpEXInzVqgYCZMTOEm7gro=;
        b=jERymvpp7gr0zWzVOw532rIKS4O3JaOS2GJizjAcJTZwr3SK5NOsPuE36Z6t1/q62R
         ZDIoM3itzMkuN1IFZJjsQo3V+g0uF1JJcmjfRAYxIQzTYR/+GMGoK/c9ulHMUOKnamAJ
         SsfLeEmhVE1BQGtVapbRhrCzTDVWoZJ82CYAJrIQpVAiR+A1Fdr+pLgBAP1HOZGMBBQp
         i8QDqD1jfetAwwx2aAHQsZjuP7Zh86upH69DSLa6+7gWCCrXBApToYlSjcyx5vPHoVbB
         2FMh7eseJtTpMJUjvW2q3vfewzH+mN+IDppDTGiMA6aU1aDtYs/LSc3lh2HvK+SqhbPV
         //8w==
X-Gm-Message-State: AC+VfDzY4UFy/XOx1CWHHIOH4itKj3RjW4iDmUo4+TS7bt4LsIuyHa2+
        slwqeeL95C0EM1VEn2vPZJQc+A==
X-Google-Smtp-Source: ACHHUZ6xLnSQ/b3U5NJqWbrTuz86G0gbNTSsjgso5M/VhbPKvGVEY9yrkxTf9DH2qSNmGFKSSTxcGw==
X-Received: by 2002:a17:906:6a04:b0:988:a837:327a with SMTP id qw4-20020a1709066a0400b00988a837327amr22018537ejc.44.1687866705562;
        Tue, 27 Jun 2023 04:51:45 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.199.204])
        by smtp.gmail.com with ESMTPSA id h14-20020a17090634ce00b0098238141deasm4478624ejb.90.2023.06.27.04.51.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Jun 2023 04:51:45 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v3 3/6] target/ppc: Move CPU QOM definitions to cpu-qom.h
Date:   Tue, 27 Jun 2023 13:51:21 +0200
Message-Id: <20230627115124.19632-4-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230627115124.19632-1-philmd@linaro.org>
References: <20230627115124.19632-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/ppc/cpu-qom.h | 5 +++++
 target/ppc/cpu.h     | 6 ------
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/target/ppc/cpu-qom.h b/target/ppc/cpu-qom.h
index 9666f54f65..c2bff349cc 100644
--- a/target/ppc/cpu-qom.h
+++ b/target/ppc/cpu-qom.h
@@ -31,6 +31,11 @@
 
 OBJECT_DECLARE_CPU_TYPE(PowerPCCPU, PowerPCCPUClass, POWERPC_CPU)
 
+#define POWERPC_CPU_TYPE_SUFFIX "-" TYPE_POWERPC_CPU
+#define POWERPC_CPU_TYPE_NAME(model) model POWERPC_CPU_TYPE_SUFFIX
+#define CPU_RESOLVING_TYPE TYPE_POWERPC_CPU
+#define cpu_list ppc_cpu_list
+
 ObjectClass *ppc_cpu_class_by_name(const char *name);
 
 typedef struct CPUArchState CPUPPCState;
diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
index af12c93ebc..e91e1774e5 100644
--- a/target/ppc/cpu.h
+++ b/target/ppc/cpu.h
@@ -1468,12 +1468,6 @@ static inline uint64_t ppc_dump_gpr(CPUPPCState *env, int gprn)
 int ppc_dcr_read(ppc_dcr_t *dcr_env, int dcrn, uint32_t *valp);
 int ppc_dcr_write(ppc_dcr_t *dcr_env, int dcrn, uint32_t val);
 
-#define POWERPC_CPU_TYPE_SUFFIX "-" TYPE_POWERPC_CPU
-#define POWERPC_CPU_TYPE_NAME(model) model POWERPC_CPU_TYPE_SUFFIX
-#define CPU_RESOLVING_TYPE TYPE_POWERPC_CPU
-
-#define cpu_list ppc_cpu_list
-
 /* MMU modes definitions */
 #define MMU_USER_IDX 0
 static inline int cpu_mmu_index(CPUPPCState *env, bool ifetch)
-- 
2.38.1

