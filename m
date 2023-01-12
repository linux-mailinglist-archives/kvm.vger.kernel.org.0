Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA58666743C
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 15:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbjALOED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 09:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234056AbjALODk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 09:03:40 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71D152741
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 06:03:33 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id o7-20020a17090a0a0700b00226c9b82c3aso20961392pjo.3
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 06:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wjWQ9F0LaanvIi9SVaFlkrqw0WGzFdxUF931tj4YTWo=;
        b=T+9X/H4J/G3JlwF9psZ/cWzPV07niIG+bOZMhVU214/rAQWZSLhMuBw5PuaNrOyaiV
         oqNriOfX2cRc1DkYlgZq4HYRQbTaH5XagEPPtJ3krBvxRJEhA3JCjlUbuB7DUnDXQUuI
         7MyPPjJ/vUwaVOW+hGCKlfcUqEFjFT5g2Dly6RCyg51Sgpc+d2G/Xa4t6nP/Aqtd7J98
         Xt5v20IOdlplskt/PUCFRCi4wP2INn335nSmKdFV8gLZ5tJMMFu4xdEUnaVpHAzhcSo4
         ZThl76vGl/Um6/ilm2ElYvHQOegLNry4OHmaaLOO5h6UcJgxFxVS7+wyL8gGR+kuUSCl
         Y7Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wjWQ9F0LaanvIi9SVaFlkrqw0WGzFdxUF931tj4YTWo=;
        b=5H0wgwLkfqhUgACWM1i8fn023MCbadaa3Q+1+xclK0bN1V0ryMrUK3Z8ZVTe12aCgh
         ByRUrQcpeg5wtvoqLq0A+5BXDLJ9MTy7k7Isgjy/DVQWXTHE6TnARU5uYR6RtFE/YCIJ
         H2VoXoEuShLI57rXLCcn2tvmRax+am0adxNvdm5JRju4LYTVnXpxuxYy8vpVz+2NnpKQ
         gIzhfmA32ZyU19gye/yiywW+u1KTzgZ/+AsBqqFZdWxkajttQXewuYR0N0jRglqInxab
         w5qtoBLw9jGq161B4JmHiuzafj3XGjhVkiDr3Xg4XdwGepK/3XGrhL7Nn/UIY3gQDkn6
         xnLA==
X-Gm-Message-State: AFqh2krhal7uuM1xjo9Tu1CgW/RMTX88996FWcnRCHpbZAg9vaWhKCNe
        P32qctk37bgQlFQ2vA6pjE+9NA==
X-Google-Smtp-Source: AMrXdXscgqqsMnhBi0KMkEXRBk0fS7yh3irzNgU/w6MnzE3yQhSAfPlAdtp/WbKEGvyg5x1cv+sNYg==
X-Received: by 2002:a17:902:ba12:b0:194:4016:11ac with SMTP id j18-20020a170902ba1200b00194401611acmr10522106pls.30.1673532213046;
        Thu, 12 Jan 2023 06:03:33 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902cecb00b001925016e34bsm12351455plg.79.2023.01.12.06.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 06:03:32 -0800 (PST)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 2/7] RISC-V: Detect AIA CSRs from ISA string
Date:   Thu, 12 Jan 2023 19:32:59 +0530
Message-Id: <20230112140304.1830648-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112140304.1830648-1-apatel@ventanamicro.com>
References: <20230112140304.1830648-1-apatel@ventanamicro.com>
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
---
 arch/riscv/include/asm/hwcap.h | 8 ++++++++
 arch/riscv/kernel/cpu.c        | 2 ++
 arch/riscv/kernel/cpufeature.c | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 86328e3acb02..c649e85ed7bb 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -59,10 +59,18 @@ enum riscv_isa_ext_id {
 	RISCV_ISA_EXT_ZIHINTPAUSE,
 	RISCV_ISA_EXT_SSTC,
 	RISCV_ISA_EXT_SVINVAL,
+	RISCV_ISA_EXT_SSAIA,
+	RISCV_ISA_EXT_SMAIA,
 	RISCV_ISA_EXT_ID_MAX
 };
 static_assert(RISCV_ISA_EXT_ID_MAX <= RISCV_ISA_EXT_MAX);
 
+#ifdef CONFIG_RISCV_M_MODE
+#define RISCV_ISA_EXT_SxAIA		RISCV_ISA_EXT_SMAIA
+#else
+#define RISCV_ISA_EXT_SxAIA		RISCV_ISA_EXT_SSAIA
+#endif
+
 /*
  * This enum represents the logical ID for each RISC-V ISA extension static
  * keys. We can use static key to optimize code path if some ISA extensions
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

