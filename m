Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D246D677B
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 17:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235781AbjDDPfc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 11:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235720AbjDDPf0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 11:35:26 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B0546B2
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 08:35:23 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id q27so23761968oiw.0
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 08:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680622522; x=1683214522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ynrEkFOVoh2ilNhT6Py6G4YVVk8kEghcO9UKxKZ0ojM=;
        b=BRgoclKSIeTbKLh/Q1MXriT5oiW3WR6WixObJxARdL/bFvcR/4j48hWnV/ObX747qN
         +gDv8vGlIQdGAYuKxF/rfrWflgx6ZUeU+ecDwngrtAkErOwkorEjTDFspXygS/xrLUgg
         lXtFR9pjKu753nV+/op/WmH73gMQXZjJhWmsU0EkMyl0fDrIg5nFRQSVGDHHjBcAeQa5
         0UQY1QQMQz1Fw6X02DYX/zdMFFnKklg/83Kn24Ei9ceNP4+J0K+VSF0tMNvD9xbYByz8
         RdHqBaD+WXGDDfRje8ttZ22B2OR8r+jnKpTRpHKaNtoX/d10K/HXA0GxKNkEBMRzwe+8
         Ee0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680622522; x=1683214522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ynrEkFOVoh2ilNhT6Py6G4YVVk8kEghcO9UKxKZ0ojM=;
        b=awMygFrVZNdMDhbUBZXQyLCICW235BhPOTOm/67eDkISnhqNZCqV+cnh9MLVdGeJLC
         0gO7Ja9P0hZLsw3eHv5T/hc3km+ixOlbG63EXspiVFjgalXxN6EA1flffdrywpKY77Tf
         L67lbbwgpBegflUKEt3qMBTZArbnGbpwb0Y3pjCd6P3Da1obX2BK8Xk8+6vL8OXEXVtd
         GLmellkHMdhOSOuYevBsRvNIgVc+UeRMAwaTwRF0Opag1DvVy3TaAB4DiB0IOgXtEPOb
         2Rgd8KjpwVnun7PXMqnNUH7nX14aRibiwyMm0Wljeai8mHis1pUJNNjGs4yNDVDwJM2K
         bHnw==
X-Gm-Message-State: AAQBX9eiDgdMFthR+VDHWKpk9JNpqfb4ut/NlMwsLJq7JOq6ooai9ua8
        +r3q16yRnz4fYcetGT92/FOm6g==
X-Google-Smtp-Source: AKy350Y9uI08y403VTorUA/J6uTgRO5eDoz1AIXPnEeKljD+beDcikH9qMkjQIGfUTgowT7Ekfvjsg==
X-Received: by 2002:a05:6808:1787:b0:387:4d4:7a45 with SMTP id bg7-20020a056808178700b0038704d47a45mr1780227oib.18.1680622522363;
        Tue, 04 Apr 2023 08:35:22 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id w124-20020acadf82000000b00387384dc768sm5325803oig.9.2023.04.04.08.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 08:35:21 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>,
        Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v4 2/9] RISC-V: Detect AIA CSRs from ISA string
Date:   Tue,  4 Apr 2023 21:04:45 +0530
Message-Id: <20230404153452.2405681-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230404153452.2405681-1-apatel@ventanamicro.com>
References: <20230404153452.2405681-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have two extension names for AIA ISA support: Smaia (M-mode AIA CSRs)
and Ssaia (S-mode AIA CSRs).

We extend the ISA string parsing to detect Smaia and Ssaia extensions.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/hwcap.h | 2 ++
 arch/riscv/kernel/cpu.c        | 2 ++
 arch/riscv/kernel/cpufeature.c | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 6263a0de1c6a..74f5dab2148f 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -42,6 +42,8 @@
 #define RISCV_ISA_EXT_ZBB		30
 #define RISCV_ISA_EXT_ZICBOM		31
 #define RISCV_ISA_EXT_ZIHINTPAUSE	32
+#define RISCV_ISA_EXT_SMAIA		33
+#define RISCV_ISA_EXT_SSAIA		34
 
 #define RISCV_ISA_EXT_MAX		64
 #define RISCV_ISA_EXT_NAME_LEN_MAX	32
diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
index 8400f0cc9704..ae1e7bbf9344 100644
--- a/arch/riscv/kernel/cpu.c
+++ b/arch/riscv/kernel/cpu.c
@@ -188,6 +188,8 @@ static struct riscv_isa_ext_data isa_ext_arr[] = {
 	__RISCV_ISA_EXT_DATA(zicbom, RISCV_ISA_EXT_ZICBOM),
 	__RISCV_ISA_EXT_DATA(zihintpause, RISCV_ISA_EXT_ZIHINTPAUSE),
 	__RISCV_ISA_EXT_DATA(zbb, RISCV_ISA_EXT_ZBB),
+	__RISCV_ISA_EXT_DATA(smaia, RISCV_ISA_EXT_SMAIA),
+	__RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
 	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
 	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
 	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 59d58ee0f68d..9e92e23f6f82 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -221,6 +221,8 @@ void __init riscv_fill_hwcap(void)
 				}
 			} else {
 				/* sorted alphabetically */
+				SET_ISA_EXT_MAP("smaia", RISCV_ISA_EXT_SMAIA);
+				SET_ISA_EXT_MAP("ssaia", RISCV_ISA_EXT_SSAIA);
 				SET_ISA_EXT_MAP("sscofpmf", RISCV_ISA_EXT_SSCOFPMF);
 				SET_ISA_EXT_MAP("sstc", RISCV_ISA_EXT_SSTC);
 				SET_ISA_EXT_MAP("svinval", RISCV_ISA_EXT_SVINVAL);
-- 
2.34.1

