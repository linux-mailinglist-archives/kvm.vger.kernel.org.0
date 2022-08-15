Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91CA592C17
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 12:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242545AbiHOKOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 06:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242490AbiHOKOV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 06:14:21 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796351929A
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 03:13:52 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id f30so6294928pfq.4
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 03:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=dFKzWK8a4yXz4IM3nrzPfNkwPwctqNlzhtFsMB1wqCk=;
        b=mQEAZpYQ0EVvDahiUTuG7qmuHXN7H9wD4VlttXtK7HD43Z25oqTz4sFNhcb1MBdQV+
         WqEAMvem+Z7ttYaPMozJ2GtZaYTPt79cUZgAmFDdJ03twbf1NPPB/5SWJDxovSpntkZ1
         l3RPrkuRWOhTX1ihLufr+OnUrf1+Rm6OxwJPXZdAZIRkm2+bS8of0+bDF1EHp0G2vgz9
         kGdL1x489bwuMXunyEUkS5yAftbeCRbiPCAe5Si50XS2eSNeFr+4ghZ2SrTzP7FCNboY
         bHlBG69v153LAexHsmQ5TZmzYQlT+nAj3u/w9c2dkkCQ6U6tvSOYa2X78Cob/bgAt0k9
         GicA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=dFKzWK8a4yXz4IM3nrzPfNkwPwctqNlzhtFsMB1wqCk=;
        b=mPNFzz7JGs7QY9O1BW1cPWB8pB/6+1IBUipPrUfnBrChVTgA86WpO757bt7y88SHLz
         cXOYPRwQsrsRLYD098DFqf0BRSs9bVZBnvfSXAMNPBnF1JT1Eemu+vUQBdlXuXBzeYRv
         6EVJD2VluhC9rQG1II0c5IPH3t9bh+Qt0nFLAMuM6pRjg5Rkr05cOPQiakZ/la9GWj8L
         +cCEyBIlYY5pFGth9CPySnXcPQXu29keGSyK34k24fEFS/EfFT1h0ZOewnpvuW7yq0mL
         FbQopmhG0kv0ORZagNF3PwybHHgGIgaCAQqQjwqA5nQ/hE9rQmRHVKBKLGqTy4Ma+MpI
         mLdA==
X-Gm-Message-State: ACgBeo0R/DOORUSXOR8FOFXCNyWDXd+cq+72vldQOA7tjJIUuJpXPQd6
        raXrHFlbOAAS5XkVc0ewEZiCVBIwFxuR+A==
X-Google-Smtp-Source: AA6agR4YrU02hkB6ryQizenDJpvTjG1tvszIQSB8Cn/CJIYXgttujnGGifI9OkjGT9OMCGuwML5KSw==
X-Received: by 2002:a62:e114:0:b0:52d:24b6:a89 with SMTP id q20-20020a62e114000000b0052d24b60a89mr15843272pfh.65.1660558431589;
        Mon, 15 Aug 2022 03:13:51 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([171.76.84.46])
        by smtp.gmail.com with ESMTPSA id i190-20020a6254c7000000b0052d4f2e2f6asm6267437pfb.119.2022.08.15.03.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 03:13:50 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Atish Patra <atishp@rivosinc.com>,
        Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH kvmtool 4/5] riscv: Add Sstc extension support
Date:   Mon, 15 Aug 2022 15:43:24 +0530
Message-Id: <20220815101325.477694-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220815101325.477694-1-apatel@ventanamicro.com>
References: <20220815101325.477694-1-apatel@ventanamicro.com>
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

From: Atish Patra <atishp@rivosinc.com>

Sstc extension allows the guest OS to program the timer directly without
relying on the SBI call. The kernel detects the presence of Sstc extnesion
from the riscv,isa DT property. Add the Sstc extension to the device tree
if it is supported by the host.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index eb7851e..aeba042 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -18,6 +18,7 @@ struct isa_ext_info {
 
 struct isa_ext_info isa_info_arr[] = {
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
+	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
 };
 
 static void dump_fdt(const char *dtb_file, void *fdt)
-- 
2.34.1

