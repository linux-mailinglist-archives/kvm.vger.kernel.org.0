Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E313E6A202D
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 18:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjBXRB4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 12:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjBXRBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 12:01:55 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67726B14C
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:01:50 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id c23so12209484pjo.4
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6oiv3GoujeROo2FqQ+/nZWilhp/M74Q6K5tii11K258=;
        b=LzukB1Ftb+M5MWrggVI5waWvR8vdX9YlggE3kHxi8SvIjlY0WBOiK4Qk3G3OqOlO+f
         o5iaGOv+Jk2u8xArSYJs6lcf60wopis1zkgscxl32hQGXXj6NznYuElTTliv6eE6WFtX
         vYCEzbORkh7x72EFmJlHoWNak1fiIhIExMW6ok0bp6YEHwqHZmOAc+JXJKkT1oU+sgvP
         mqQocNe0SaEEwYe3sAIKO0aobzHcm653wN7DvJhk29olHwR0DG+X5KL0mgzPHbUHsFcy
         9Spe6QGK7lxIRlAN2q77nG4M3PRMa3rM4YlNmqNXuW+fZ1ewL6TxFYBhefbMENXnJm2M
         vCeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6oiv3GoujeROo2FqQ+/nZWilhp/M74Q6K5tii11K258=;
        b=xOBjW2Ks2n4bOAALh8kp3G3E9qF4zsMkeniyhmnZudmnVOIgXHSNdC/9gOj3N3UU9d
         KH2KmIZ+WNbd7v3unRgRSFG31W2BeMulkq31uIbyl7L5nifS5zgtMr014x/G0IZTjpG/
         tkFJTaTK+z51KscEmoLRKpDVaZap7Q2O3oWVpZrySqhM4Z5UvIWrvwKmcEl2+R433Fp4
         OnrAPGNk2/JJQrXhfQ1/Xl1+bEySvy35U8QQKB374bdPFN5Z/0UZ/efLt/RagVDIG5YN
         cW/KxJmFxrzrCy2jjRNkbBDn9f9Kk/3DW/oOHJ2U6qGW5T/EwUMwFfApxGCASaz8xHJb
         b0tQ==
X-Gm-Message-State: AO0yUKXSqeHNIljz6Co2epcBWadXXOzG9BusGaJK29znk+0sYlF884mL
        nQ6AKZfK43d3KgqSg/HODgrgVQ==
X-Google-Smtp-Source: AK7set9y+i1eXYSbsemD/Nfvo8qLXh5WeFiF1PxWHM/91G0NMz9WVkIIPYNpAJsYETY0ho8DaVVAOg==
X-Received: by 2002:a17:902:c40d:b0:198:e13e:e73e with SMTP id k13-20020a170902c40d00b00198e13ee73emr20251145plk.53.1677258110286;
        Fri, 24 Feb 2023 09:01:50 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902b60c00b0019472226769sm9234731pls.251.2023.02.24.09.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 09:01:48 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@rivosinc.com>,
        Anup Patel <apatel@ventanamicro.com>,
        Guo Ren <guoren@kernel.org>
Subject: [PATCH -next v14 03/19] riscv: Add new csr defines related to vector extension
Date:   Fri, 24 Feb 2023 17:01:02 +0000
Message-Id: <20230224170118.16766-4-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230224170118.16766-1-andy.chiu@sifive.com>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

Follow the riscv vector spec to add new csr numbers.

[guoren@linux.alibaba.com: first porting for new vector related csr]
Acked-by: Guo Ren <guoren@kernel.org>
Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Suggested-by: Vineet Gupta <vineetg@rivosinc.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
[andyc: added SR_FS_VS]
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
---
 arch/riscv/include/asm/csr.h | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 0e571f6483d9..add51662b7c3 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -24,16 +24,24 @@
 #define SR_FS_CLEAN	_AC(0x00004000, UL)
 #define SR_FS_DIRTY	_AC(0x00006000, UL)
 
+#define SR_VS           _AC(0x00000600, UL) /* Vector Status */
+#define SR_VS_OFF       _AC(0x00000000, UL)
+#define SR_VS_INITIAL   _AC(0x00000200, UL)
+#define SR_VS_CLEAN     _AC(0x00000400, UL)
+#define SR_VS_DIRTY     _AC(0x00000600, UL)
+
 #define SR_XS		_AC(0x00018000, UL) /* Extension Status */
 #define SR_XS_OFF	_AC(0x00000000, UL)
 #define SR_XS_INITIAL	_AC(0x00008000, UL)
 #define SR_XS_CLEAN	_AC(0x00010000, UL)
 #define SR_XS_DIRTY	_AC(0x00018000, UL)
 
+#define SR_FS_VS	(SR_FS | SR_VS) /* Vector and Floating-Point Unit */
+
 #ifndef CONFIG_64BIT
-#define SR_SD		_AC(0x80000000, UL) /* FS/XS dirty */
+#define SR_SD		_AC(0x80000000, UL) /* FS/VS/XS dirty */
 #else
-#define SR_SD		_AC(0x8000000000000000, UL) /* FS/XS dirty */
+#define SR_SD		_AC(0x8000000000000000, UL) /* FS/VS/XS dirty */
 #endif
 
 #ifdef CONFIG_64BIT
@@ -297,6 +305,12 @@
 #define CSR_MIMPID		0xf13
 #define CSR_MHARTID		0xf14
 
+#define CSR_VSTART		0x8
+#define CSR_VCSR		0xf
+#define CSR_VL			0xc20
+#define CSR_VTYPE		0xc21
+#define CSR_VLENB		0xc22
+
 #ifdef CONFIG_RISCV_M_MODE
 # define CSR_STATUS	CSR_MSTATUS
 # define CSR_IE		CSR_MIE
-- 
2.17.1

