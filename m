Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7A1722B8A
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 17:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbjFEPmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 11:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235008AbjFEPmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 11:42:19 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19778E63
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 08:41:53 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1b026657a6fso43036915ad.0
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 08:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1685979702; x=1688571702;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vWfWpcMCj1+Fb0BnBKmql7KJ370X51psXYGnDJmV9XE=;
        b=aa2XcqtZLW5iqnaCW4Qqr1H+Tzlig3YdL5foi2KV8ac0ghkespqXccDGXXKNl67dzp
         ntoXqcpEbUNXvG5jwzxqIS5KwFz8xhHNWI/SGHmvcSQ2teKRNuv/u+rgbNtYZ36omA6S
         0gqzwlRCz9zWjL1DPbymwwynFbAGzjHY5NEUVVXmd8WETn/AzMuXGLvdBcqDSf9KZ1j6
         v+X+RAJpugMnSnGeorxLAmIlpnxsjubdP5Udp40y6rMZhN9bi60e6YQ2sdLGuMjdvoXz
         TMfX2v3MjkZ4zJh15+lPq3UDK3JH4uglzBSdGlRDu9xCy0w27inNr0rnqfpXqvQamCjY
         JT9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685979702; x=1688571702;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vWfWpcMCj1+Fb0BnBKmql7KJ370X51psXYGnDJmV9XE=;
        b=EbqfIQ7yz/0swH5oNy0VwAsDjsYtpP4g5xTnTNsCbwNLbyOuexyHtCnEXqwrjvmW4P
         OLrN09WKPJ1ZThvV6ENBjUg3YFeULu/BnyhNpX8O+bROELdD8oX1Rmveo1QaerNv+86v
         bMTi9IqcgY0MpBWh/bc5OhwME1rwvF8Q58MnApkT9Mg5jMpWGn7TJ+69+6/ELRV5emBq
         urEBg+fRMfcLmffMUIQHCG0WOFaN+ihe9A5R9ONPBdRVrQo5035cT+RerUuZUwv9OBWQ
         lxShnzvINNO9ZL22uiqTrvHaA54V7tpDtowmACNlY71bafi/Ogm35UNitu/ire2kia8M
         Wl/A==
X-Gm-Message-State: AC+VfDz4FIrm6/pBtiePFrn31u7uEYrSXuZjNIPlMU32UXGZXxKHbkjE
        Bp72bTKM7xIJlS0f82TuS70DxQ==
X-Google-Smtp-Source: ACHHUZ5ALSUm1i1u3l9MlL1FkN2klEz94jSTED1PaH9Zd5Uees8rVfXo4MbbiVQ0JqYoJeYPnONJ1g==
X-Received: by 2002:a17:903:24c:b0:1ad:f138:b2f6 with SMTP id j12-20020a170903024c00b001adf138b2f6mr8809583plh.16.1685979702314;
        Mon, 05 Jun 2023 08:41:42 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id jk19-20020a170903331300b001b0aec3ed59sm6725962plb.256.2023.06.05.08.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 08:41:41 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Vincent Chen <vincent.chen@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <apatel@ventanamicro.com>,
        Jisheng Zhang <jszhang@kernel.org>, Guo Ren <guoren@kernel.org>
Subject: [PATCH -next v21 20/27] riscv: hwcap: change ELF_HWCAP to a function
Date:   Mon,  5 Jun 2023 11:07:17 +0000
Message-Id: <20230605110724.21391-21-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230605110724.21391-1-andy.chiu@sifive.com>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using a function is flexible to represent ELF_HWCAP. So the kernel may
encode hwcap reflecting supported hardware features just at the moment of
the start of each program.

This will be helpful when we introduce prctl/sysctl interface to control
per-process availability of Vector extension in following patches.
Programs started with V disabled should see V masked off in theirs
ELF_HWCAP.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
 arch/riscv/include/asm/elf.h   | 2 +-
 arch/riscv/include/asm/hwcap.h | 2 ++
 arch/riscv/kernel/cpufeature.c | 5 +++++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/elf.h b/arch/riscv/include/asm/elf.h
index ca23c4f6c440..c24280774caf 100644
--- a/arch/riscv/include/asm/elf.h
+++ b/arch/riscv/include/asm/elf.h
@@ -66,7 +66,7 @@ extern bool compat_elf_check_arch(Elf32_Ehdr *hdr);
  * via a bitmap that coorespends to each single-letter ISA extension.  This is
  * essentially defunct, but will remain for compatibility with userspace.
  */
-#define ELF_HWCAP	(elf_hwcap & ((1UL << RISCV_ISA_EXT_BASE) - 1))
+#define ELF_HWCAP	riscv_get_elf_hwcap()
 extern unsigned long elf_hwcap;
 
 /*
diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 574385930ba7..e6c288ac4581 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -61,6 +61,8 @@
 
 #include <linux/jump_label.h>
 
+unsigned long riscv_get_elf_hwcap(void);
+
 struct riscv_isa_ext_data {
 	/* Name of the extension displayed to userspace via /proc/cpuinfo */
 	char uprop[RISCV_ISA_EXT_NAME_LEN_MAX];
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 28032b083463..29c0680652a0 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -293,6 +293,11 @@ void __init riscv_fill_hwcap(void)
 	pr_info("riscv: ELF capabilities %s\n", print_str);
 }
 
+unsigned long riscv_get_elf_hwcap(void)
+{
+	return (elf_hwcap & ((1UL << RISCV_ISA_EXT_BASE) - 1));
+}
+
 #ifdef CONFIG_RISCV_ALTERNATIVE
 /*
  * Alternative patch sites consider 48 bits when determining when to patch
-- 
2.17.1

