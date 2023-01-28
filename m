Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6696E67F588
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 08:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbjA1H2B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Jan 2023 02:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbjA1H17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Jan 2023 02:27:59 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972801A94A
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 23:27:56 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id lp10so6684631pjb.4
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 23:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Uu0XcOi0YfgGBrdwbE6Fd5anHlLU0kgUQvAvy8N3SY=;
        b=iQufTxafHvT+YxmPupDGUBtEEbJkIH9hmfsJNRto9WJxjIRW8Pg5woDtIMI1wkg3DS
         R+I/hByys5ZOJx6yEf73FsszEm0uiQCIwXAuKdbxLqxQ5V5uY4v4TICEYqjHQVdLNSS6
         DPrLTtCrNK57h6NLhUbj72BYOABBqdEmznHPJ3tkx5aguszWitl8QF2OlngExBMCU3uJ
         pbJjUWVuk7DMVdbQzor/c/kcLTWQ4T94vs2l9R124muqq+zjICjnTzxlvuid0cBvqPrv
         ZVm7VaPqwJoD4OxQLRFUzdwJuHCixFVxvE0LCvLeKF8VcKaUPs36PUoIC3h8ATfJXPOf
         dA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Uu0XcOi0YfgGBrdwbE6Fd5anHlLU0kgUQvAvy8N3SY=;
        b=ov1ylJY+K2PpSOTIK/SNDGArIDJ4LHv1P9jyBXbNjIgQdbQ5nJWC8T+iCa708at076
         Kxqc2fefUWNqyyzz7zIU67C7o4zNWpRjqpyJaWuNDjdyITaEAL7HP9QVhUnZSRI0lxZu
         YkqfjHnq4SFQWus3D+05r81P+lusYHNjNHmBT8pp4nF0zBoS7NxlOJYM6vTXx9nok7oh
         +FF2OdMbvxzZkUCLUNTvprkx03Qn7qyoLVe2PdumMbFJTE1PKW+7Vhzzhb1I4FSvD+rI
         sqjz5kyNv310x3947mG0OmKSUEfp+5ZrAHlRsoN73ubo3U/pG8PC8QBufjoEXYoP2+sS
         lI7w==
X-Gm-Message-State: AO0yUKUUzpWnErU3GrJP0T0gwGNThnvEG8gmF58nui8PS5hRsVnvEBTg
        n3xVgd9pYmHTWOPeXDvXwPMSDA==
X-Google-Smtp-Source: AK7set8elKufdTa2dQJy/JujoNR9s6RimlLWJMQHkwmFUsxhc/iYyt2WN/V9fwrCUXZJF8pidXkQrQ==
X-Received: by 2002:a17:902:f202:b0:189:340c:20d2 with SMTP id m2-20020a170902f20200b00189340c20d2mr962841plc.23.1674890876510;
        Fri, 27 Jan 2023 23:27:56 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id jh19-20020a170903329300b00194ac38bc86sm753132plb.131.2023.01.27.23.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 23:27:55 -0800 (PST)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 2/7] RISC-V: Detect AIA CSRs from ISA string
Date:   Sat, 28 Jan 2023 12:57:32 +0530
Message-Id: <20230128072737.2995881-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230128072737.2995881-1-apatel@ventanamicro.com>
References: <20230128072737.2995881-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
---
 arch/riscv/include/asm/hwcap.h | 2 ++
 arch/riscv/kernel/cpu.c        | 2 ++
 arch/riscv/kernel/cpufeature.c | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 86328e3acb02..341ef30a3718 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -59,6 +59,8 @@ enum riscv_isa_ext_id {
 	RISCV_ISA_EXT_ZIHINTPAUSE,
 	RISCV_ISA_EXT_SSTC,
 	RISCV_ISA_EXT_SVINVAL,
+	RISCV_ISA_EXT_SMAIA,
+	RISCV_ISA_EXT_SSAIA,
 	RISCV_ISA_EXT_ID_MAX
 };
 static_assert(RISCV_ISA_EXT_ID_MAX <= RISCV_ISA_EXT_MAX);
diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
index 1b9a5a66e55a..a215ec929160 100644
--- a/arch/riscv/kernel/cpu.c
+++ b/arch/riscv/kernel/cpu.c
@@ -162,6 +162,8 @@ arch_initcall(riscv_cpuinfo_init);
  *    extensions by an underscore.
  */
 static struct riscv_isa_ext_data isa_ext_arr[] = {
+	__RISCV_ISA_EXT_DATA(smaia, RISCV_ISA_EXT_SMAIA),
+	__RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
 	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
 	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
 	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 93e45560af30..3c5b51f519d5 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -228,6 +228,8 @@ void __init riscv_fill_hwcap(void)
 				SET_ISA_EXT_MAP("zihintpause", RISCV_ISA_EXT_ZIHINTPAUSE);
 				SET_ISA_EXT_MAP("sstc", RISCV_ISA_EXT_SSTC);
 				SET_ISA_EXT_MAP("svinval", RISCV_ISA_EXT_SVINVAL);
+				SET_ISA_EXT_MAP("smaia", RISCV_ISA_EXT_SMAIA);
+				SET_ISA_EXT_MAP("ssaia", RISCV_ISA_EXT_SSAIA);
 			}
 #undef SET_ISA_EXT_MAP
 		}
-- 
2.34.1

