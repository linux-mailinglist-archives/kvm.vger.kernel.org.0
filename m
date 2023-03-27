Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7426CAAF9
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 18:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbjC0QuI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 12:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbjC0QuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 12:50:06 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1481E35B5
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:50:05 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id q206so5530139pgq.9
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679935804;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wxwN7g3H6Sw6hU6xeUFUVA8oVaitJPaamaFICOanx0U=;
        b=ddV9yf+Ej5SvPfEWDg02RLMqwomecI3qMrEVGh/489ozL+FbtvNWeB5Egzdce6DPzT
         SNdk/nyNvnaXpb/Wr/OZNUG3szjDDmTnI98Ey1KYmgCCqsSWPh+OzDfN3VhSpXtcB/Fy
         h+91EiWRFvP+I34noH8YmkXJBAl66SDJAC99ayt38GL8kf8VhbFsCarp5yaPA6pYHiK+
         zPGDHZGabPFF6S54c+Yo+ivQKK5r+wpDlkwRlslTJvHKdQThE7LLzG9L362VuYb1XvfD
         n8fk9LUdA8nSL51/snuo4AsyGxfxHKiWomOZOsdAsjK7ZSNQeXgVn9TIAxPRRkXGs2Xz
         cIOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679935804;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wxwN7g3H6Sw6hU6xeUFUVA8oVaitJPaamaFICOanx0U=;
        b=NzE2ROhJmu8SQOftvcp6DBNbln6gCOP4EVgBoeMLuzC5pwrLBkgBJCSGrhisVPgchN
         LHbfgcHcZnXZ/u9ZQVziQmQp52zT+3fUkTpXeXjkHDSsh/0kzvdG3dbcbx8ODFb3ht79
         mO6Vr1x9orDToctvecDV1tlfYcCrc0ac8/EfZQikZzu0fIp9Emc/8DqptjesmcxuFcOB
         CqWqQp9dCUgJCa0HR3+RnvJPX0pY+9gM8eFdGaNUN2OFexaPLov90aycvDty0iqxTbRf
         Ec7T7ATrRtc53SS/cLuQB7YRJScdbMs4uGWoYpwFo/PDRB4yJtlfyYvNbpEuryESwwjw
         CBgg==
X-Gm-Message-State: AAQBX9dvuHo1ov83rgx5XkcGKw9C8pKdheOxa4AhSPdwMgKJz5MRsUsx
        zaNfucApSDJbaB3DoBBZm3U44g==
X-Google-Smtp-Source: AKy350bqYgUcs1CGvpZN85+lCPsdrnwLPwHuQVxFCsuTKyLVm9ww+/c9Hgu75VmL6DLbOYPm1hCZyQ==
X-Received: by 2002:a62:5543:0:b0:625:a012:a59c with SMTP id j64-20020a625543000000b00625a012a59cmr13619565pfb.9.1679935804570;
        Mon, 27 Mar 2023 09:50:04 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id q20-20020a62e114000000b0061949fe3beasm19310550pfh.22.2023.03.27.09.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 09:50:04 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Anup Patel <apatel@ventanamicro.com>,
        Atish Patra <atishp@rivosinc.com>
Subject: [PATCH -next v17 03/20] riscv: Add new csr defines related to vector extension
Date:   Mon, 27 Mar 2023 16:49:23 +0000
Message-Id: <20230327164941.20491-4-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230327164941.20491-1-andy.chiu@sifive.com>
References: <20230327164941.20491-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

Follow the riscv vector spec to add new csr numbers.

Acked-by: Guo Ren <guoren@kernel.org>
Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Suggested-by: Vineet Gupta <vineetg@rivosinc.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
---
 arch/riscv/include/asm/csr.h | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 7c2b8cdb7b77..39f3fde69ee5 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -24,16 +24,24 @@
 #define SR_FS_CLEAN	_AC(0x00004000, UL)
 #define SR_FS_DIRTY	_AC(0x00006000, UL)
 
+#define SR_VS		_AC(0x00000600, UL) /* Vector Status */
+#define SR_VS_OFF	_AC(0x00000000, UL)
+#define SR_VS_INITIAL	_AC(0x00000200, UL)
+#define SR_VS_CLEAN	_AC(0x00000400, UL)
+#define SR_VS_DIRTY	_AC(0x00000600, UL)
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
@@ -296,6 +304,12 @@
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

