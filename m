Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E78367B427
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 15:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235370AbjAYOVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 09:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235426AbjAYOVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 09:21:21 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8D246D67
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:21:19 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso2142332pjf.1
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LEmGChUVnZQOmwfi7xG4k4V6O37t39G64IbOwnQqBms=;
        b=Mgb65GpuK9yJrPVkx4kQ2Ci8WktzW+IO7bEtBhRcPRo9HeerGgLhDi59MSIyKjx2va
         p8uCYA+B0qdtfqTUAnRoQ8RLNfzx+jQA57SakCY61y0EoPrxTbFCtM+clv4CNbkbHuIE
         dQ26JEziH2FAV8tL6For36tiiWbDz9eMJ0SBm/0cgCQ09tQZWJQvQDgKaUJj4CyzQOII
         upV2AoKzkCxnMHMGLoOvlyYaO9o+/ZJ6sO0tQC5qVmTaWbRyYSPjxzphkHj+7BV8Y00Q
         wOG9flapF4qwbIiarQrWQ46DdMcVbp79JiTMrwcaWE09mo50Og6q/o2lIL9b6QRPbckS
         vflA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LEmGChUVnZQOmwfi7xG4k4V6O37t39G64IbOwnQqBms=;
        b=Dz4w4SSO4+dXYuN9vtgyocMdw2l+JkCscjZjTA4O155AqSOUWIho1X/Pj5NlKucF6h
         kq78Y6eemuPqXUowUGBRfgYWDtk6YzumCjhTup8pBNmsw51Mz4PATAbYjwGNycBquD5g
         p/q/7xdy6uGEBFy1L03r0Q/OJaduOKPDgMx+P3vM6bKQPJp5gwTfY5KsuJw1N1w9pEPC
         HqlDG9ATZhv11A8455KO8Ygb2n4RrWBDMolvVu1yvDnk3Tz4/skxumyolayN+l50zsxz
         UhjdB6PcZdl/6HvIz2yEwrA/8vsMbiZCcOZeNDcfF25yD1QwLU/Gh60V31aP+OV1pw+q
         fNww==
X-Gm-Message-State: AFqh2kopWizueTl3IMFANkgXf+c5X46+iWhfqPiBTF1v5iEm+BaKLCYd
        CbU6MMd3aLBTsT8ppu/OuyLoXQ==
X-Google-Smtp-Source: AMrXdXsk2JUgDD+qVk9IAT4BHytMQ3y+Sghwgj5N2J+EbXRUuhk8YMB5VLjL8ceNGGJL630ZWx+hwg==
X-Received: by 2002:a05:6a20:1b21:b0:b8:ad30:717c with SMTP id ch33-20020a056a201b2100b000b8ad30717cmr31941568pzb.9.1674656479111;
        Wed, 25 Jan 2023 06:21:19 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id bu11-20020a63294b000000b004a3510effa5sm3203520pgb.65.2023.01.25.06.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:21:18 -0800 (PST)
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
        Guo Ren <guoren@kernel.org>,
        Qinglin Pan <panqinglin2020@iscas.ac.cn>
Subject: [PATCH -next v13 03/19] riscv: Add new csr defines related to vector extension
Date:   Wed, 25 Jan 2023 14:20:40 +0000
Message-Id: <20230125142056.18356-4-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230125142056.18356-1-andy.chiu@sifive.com>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
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

