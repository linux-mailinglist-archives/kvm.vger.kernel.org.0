Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF44F7310D1
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 09:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243940AbjFOHfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 03:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245079AbjFOHeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 03:34:50 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B184A2D41
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 00:34:16 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1b3d0b33dc2so26805635ad.0
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 00:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1686814456; x=1689406456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qy2FvnQ7sT+hFfzfZbK6StB7FDfBUwIcnd7vowD7Hdo=;
        b=Nt5IJ9A8Go305vi9k3xNch93gz4wG7hVjY7emu+ejrqDCvtVPNFSMj/ewo8/JK8jKC
         5mTCTUhtatBK9HMGYBEbL1PQ08wnaCe7WXC+hWTgRDBES+tNYHWe/UI821L/gPKf8//x
         0ggc2QMn2Bd4RHfoQL5qR+bIELmGTRAjHA1f5VFO+cJfPiov87zTo4q4rQDv5BaUL2ro
         jgYmzC2oRLN4GydsRhhA5SOMkVWeZxc7z1uIl+FgKR0B0/XjHWmimv0ZNw86j/5Ge3Am
         ir0opF7aLz9gqQJ1q21Vhp/uz/wejAlOt2q/vOSIwYoNQUB29t/JHEHK8W+lT6yaY+fQ
         QJWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686814456; x=1689406456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qy2FvnQ7sT+hFfzfZbK6StB7FDfBUwIcnd7vowD7Hdo=;
        b=NcdGuT8TeOp3l2faKQAQqSgDVM9DXLdDf8SfWOGGAySLNbAWO0x7QGTKAcxCUM6lb9
         IoMMWB4b+ZkSjWrnI6Bk/uvXn7FtALn1NHq2QXCV7c3zrQOLiVsrjHATFjjVjobIyvWR
         jpx6Tsmc+BHedXRokTTPf2WYQCrf5Pj2C0qZyTWyayIR6ZXXEOIDgSiny3TBWPW1ppYY
         1uxs6gH0PQOXoBkp7rcaI9WEPOD7F6G4Qip/hseBLXeSRYdBVWE+LDWz1tnpF9+REnUI
         jpLNdXtlHJWQkUadSFBEniw91hdz/7mP7VdiznCxoAiActkWzfO/Czdz+eaZ5duRadj2
         snKA==
X-Gm-Message-State: AC+VfDzVNCOBDRKKVabQq9bUnqhWT0JbtieeE/HHI7QwEiyxrUsl1gyX
        EtyOnz1xLBrIUGaB0mOAOgG5aw==
X-Google-Smtp-Source: ACHHUZ6mHR+PnahYyMyHEriKGo1bZrAuECg7TeZ+DuP6p9ElRRQTkxt63TCxjTz3+MbZztPJbCNo0w==
X-Received: by 2002:a17:903:22c6:b0:1b3:d25a:5ece with SMTP id y6-20020a17090322c600b001b3d25a5ecemr10637846plg.31.1686814455799;
        Thu, 15 Jun 2023 00:34:15 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([106.51.83.242])
        by smtp.gmail.com with ESMTPSA id ji1-20020a170903324100b001b016313b1dsm8049855plb.86.2023.06.15.00.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 00:34:15 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>,
        Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v3 04/10] RISC-V: KVM: Set kvm_riscv_aia_nr_hgei to zero
Date:   Thu, 15 Jun 2023 13:03:47 +0530
Message-Id: <20230615073353.85435-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230615073353.85435-1-apatel@ventanamicro.com>
References: <20230615073353.85435-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We hard-code the kvm_riscv_aia_nr_hgei to zero until IMSIC HW
guest file support is added in KVM RISC-V.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/aia.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
index c78c06d99e39..3f97575707eb 100644
--- a/arch/riscv/kvm/aia.c
+++ b/arch/riscv/kvm/aia.c
@@ -408,7 +408,7 @@ int kvm_riscv_aia_alloc_hgei(int cpu, struct kvm_vcpu *owner,
 
 	raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
 
-	/* TODO: To be updated later by AIA in-kernel irqchip support */
+	/* TODO: To be updated later by AIA IMSIC HW guest file support */
 	if (hgei_va)
 		*hgei_va = NULL;
 	if (hgei_pa)
@@ -610,6 +610,14 @@ int kvm_riscv_aia_init(void)
 	if (kvm_riscv_aia_nr_hgei)
 		kvm_riscv_aia_nr_hgei--;
 
+	/*
+	 * Number of usable HGEI lines should be minimum of per-HART
+	 * IMSIC guest files and number of bits in HGEIE
+	 *
+	 * TODO: To be updated later by AIA IMSIC HW guest file support
+	 */
+	kvm_riscv_aia_nr_hgei = 0;
+
 	/* Initialize guest external interrupt line management */
 	rc = aia_hgei_init();
 	if (rc)
-- 
2.34.1

