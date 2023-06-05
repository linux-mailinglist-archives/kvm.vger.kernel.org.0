Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF645722B63
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 17:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbjFEPkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 11:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234707AbjFEPj7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 11:39:59 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5238F7
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 08:39:58 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1b00ecabdf2so45869935ad.2
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 08:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1685979598; x=1688571598;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3y8ZxaitI4vDMB0+bZfjoHdHul+aXR4kvCb6HBDbSsk=;
        b=JaqNg7sN/e7gIeih2uZhtfREFG2IH1olkhz63U6B6sCbbDXJ+OSaBFdImVqpTtz7dQ
         k7dh1Kj3qgCbGUwraqgZGgGxaTIc6oX9sYPr1SVxsEbXdCwqE/9QQkgyIb6IcRTqvumO
         7n4xeE37coXrJ431vwE9t4gOlstc/yaKtSMg026KWweGp9qc6qDenmzprcxJdC4pgktU
         KFBdLVfhS9+755LCUU+/m+C+SW7Xn+C9lThCIaQ48tHJQ3jDNH2szJaoWf2GRnhArOvK
         0OaSEoMvpudVAuesI1tkV0oZqmvO79O6POYuNbVc1r4XHZlhfGaXBVw6OpLv3qdwf/pV
         jxpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685979598; x=1688571598;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3y8ZxaitI4vDMB0+bZfjoHdHul+aXR4kvCb6HBDbSsk=;
        b=RL0c1VIwqY4mABq+SQOBmCm6cQo2XnlV+1RkX9LT6hB+s0dsZGGztW1Hq6q+kxs30R
         200vhlESXlUdW9WsqtPJPExDl0mRMeQGzoG5lSgcNRP35G0HtIFeiquk4ab2oYSDk1QH
         J3qA6jztDLtbVb+8lUErd4zLDWFsHnTp8w0VUheMa3Px7hUhU9xSc2o/54UbaDRslPet
         6v62BwhiCA+fMFo7OSI3YOaDgbM0O4Mcy4zZOintocL/7YPVvOF/YPF4EoazaHvsnlrx
         eM6ZTIWu3zrhvW/+OOQaauu++2qvT6Gse7Pr5nCJrphf2ZVIs4tUazlbIFZRyJUkGZ34
         tJ5g==
X-Gm-Message-State: AC+VfDxs1clBpIpo/I4lS/6D3CTUfK4fq2zTPLgH2P5tgRI3wIZnqQwL
        rYezXe69lbBa/m7nRH6bYGKbwg==
X-Google-Smtp-Source: ACHHUZ6VLVHTULzJC3UwlOIGxh1xz1Hej5pdJKL54f/HWuLX+oy5kWMBPi/AnZJSJIE42NhnPdD6dQ==
X-Received: by 2002:a17:903:41c7:b0:1a1:b3bb:cd5b with SMTP id u7-20020a17090341c700b001a1b3bbcd5bmr9720134ple.62.1685979598362;
        Mon, 05 Jun 2023 08:39:58 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id jk19-20020a170903331300b001b0aec3ed59sm6725962plb.256.2023.06.05.08.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 08:39:57 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Evan Green <evan@rivosinc.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Celeste Liu <coelacanthus@outlook.com>,
        Andrew Bresticker <abrestic@rivosinc.com>
Subject: [PATCH -next v21 03/27] riscv: hwprobe: Add support for probing V in RISCV_HWPROBE_KEY_IMA_EXT_0
Date:   Mon,  5 Jun 2023 11:07:00 +0000
Message-Id: <20230605110724.21391-4-andy.chiu@sifive.com>
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

Probing kernel support for Vector extension is available now. This only
add detection for V only. Extenions like Zvfh, Zk are not in this scope.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Evan Green <evan@rivosinc.com>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
---
Changelog v20:
 - Fix a typo in document, and remove duplicated probes (Heiko)
 - probe V extension in RISCV_HWPROBE_KEY_IMA_EXT_0 key only (Palmer,
   Evan)
---
 Documentation/riscv/hwprobe.rst       | 3 +++
 arch/riscv/include/uapi/asm/hwprobe.h | 1 +
 arch/riscv/kernel/sys_riscv.c         | 4 ++++
 3 files changed, 8 insertions(+)

diff --git a/Documentation/riscv/hwprobe.rst b/Documentation/riscv/hwprobe.rst
index 9f0dd62dcb5d..7431d9d01c73 100644
--- a/Documentation/riscv/hwprobe.rst
+++ b/Documentation/riscv/hwprobe.rst
@@ -64,6 +64,9 @@ The following keys are defined:
   * :c:macro:`RISCV_HWPROBE_IMA_C`: The C extension is supported, as defined
     by version 2.2 of the RISC-V ISA manual.
 
+  * :c:macro:`RISCV_HWPROBE_IMA_V`: The V extension is supported, as defined by
+    version 1.0 of the RISC-V Vector extension manual.
+
 * :c:macro:`RISCV_HWPROBE_KEY_CPUPERF_0`: A bitmask that contains performance
   information about the selected set of processors.
 
diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/uapi/asm/hwprobe.h
index 8d745a4ad8a2..7c6fdcf7ced5 100644
--- a/arch/riscv/include/uapi/asm/hwprobe.h
+++ b/arch/riscv/include/uapi/asm/hwprobe.h
@@ -25,6 +25,7 @@ struct riscv_hwprobe {
 #define RISCV_HWPROBE_KEY_IMA_EXT_0	4
 #define		RISCV_HWPROBE_IMA_FD		(1 << 0)
 #define		RISCV_HWPROBE_IMA_C		(1 << 1)
+#define		RISCV_HWPROBE_IMA_V		(1 << 2)
 #define RISCV_HWPROBE_KEY_CPUPERF_0	5
 #define		RISCV_HWPROBE_MISALIGNED_UNKNOWN	(0 << 0)
 #define		RISCV_HWPROBE_MISALIGNED_EMULATED	(1 << 0)
diff --git a/arch/riscv/kernel/sys_riscv.c b/arch/riscv/kernel/sys_riscv.c
index 5db29683ebee..88357a848797 100644
--- a/arch/riscv/kernel/sys_riscv.c
+++ b/arch/riscv/kernel/sys_riscv.c
@@ -10,6 +10,7 @@
 #include <asm/cpufeature.h>
 #include <asm/hwprobe.h>
 #include <asm/sbi.h>
+#include <asm/vector.h>
 #include <asm/switch_to.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -171,6 +172,9 @@ static void hwprobe_one_pair(struct riscv_hwprobe *pair,
 		if (riscv_isa_extension_available(NULL, c))
 			pair->value |= RISCV_HWPROBE_IMA_C;
 
+		if (has_vector())
+			pair->value |= RISCV_HWPROBE_IMA_V;
+
 		break;
 
 	case RISCV_HWPROBE_KEY_CPUPERF_0:
-- 
2.17.1

