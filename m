Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6876A7065A3
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 12:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbjEQKw2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 06:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjEQKwS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 06:52:18 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DFD5580
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 03:52:08 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id 5614622812f47-38ede2e0e69so389837b6e.2
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 03:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1684320727; x=1686912727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SQ28JLrG1g8D7dyJImcOfHjIQvhPaHtlfmKpeESLpGY=;
        b=Jnid0LSmDD5xq4sLyxjSQ8L5tr7Woa1SosoehMDgR69PzZ3l+2D6q4SoLHkgdDaiD+
         YG50yzfZYHRNEQI7qGu4l+X+dEpuW6aDqYF4R3Iwjz5VF0OVhGtNdi4dD4LNwy53DGsA
         nF8j+Y0t26IO0ZbRmQ7GTqbUqrHl2r/260iNHA57NH05fp9lVf9ZZ21wJ1rp6HbIfCo9
         wT4AxUNJG7Eb9+AQE/unR91SwtxbFEPVD0QZe2MgDn9nW0K0QleUZvLHYl5S7eKAJGx0
         J/wG2UaQs70iffUQGdghITh2ZWgwLSlg04OssoGZsqyRhtH9CtACUVR5+Bmm/O8jPaCo
         Nh0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684320727; x=1686912727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SQ28JLrG1g8D7dyJImcOfHjIQvhPaHtlfmKpeESLpGY=;
        b=KakOO6ScKZ1o+M2knNfmqPX6K9TivvuJxY4KIqYk0jnhhiGaQYpDcL7uNIFInrnyhZ
         rPdcm6lkpScgOT46DfxoSvo754mhKmjoDNgXs73gyxOSSHyTT6Fh6BaSxlFE0wIZqsjM
         mwyYudbcHxPYWLAIX+Jhti+HTrBqCxkKJRSXIhC+SIto2dUYpmJ8ezXYocbjXXhQtEXu
         6rmrHG4tJAfRJgvqc4S5jWtoTTGJ+5ybZlIKvIJUBD78qM8ycTcjcZHAKw8umPK7l11x
         NW+4Ie+T0n8yrfhr9FXTspI/awuvWPWJMLIZMqdwJW/VTxgORNpjT1mWuZWLYrwzVX9c
         MOrQ==
X-Gm-Message-State: AC+VfDyVJAu+1aK/1vRCYCXwUGFd92dAzffKvbnr2rDwznXJvadPOvU3
        Xpns0zixzUt3ZissPmTr+WalNw==
X-Google-Smtp-Source: ACHHUZ6UYNpzXHK7JEk/oI9BzRIucS9Y02RIxttWYFtZ944PMuU22M2sIdJpAvkSA1Dm1VhSrk0S1w==
X-Received: by 2002:a05:6808:17a8:b0:394:670f:9ecb with SMTP id bg40-20020a05680817a800b00394670f9ecbmr12925825oib.1.1684320727214;
        Wed, 17 May 2023 03:52:07 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id w1-20020a9d77c1000000b006ade3815527sm2279896otl.22.2023.05.17.03.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 03:52:07 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 04/10] RISC-V: KVM: Set kvm_riscv_aia_nr_hgei to zero
Date:   Wed, 17 May 2023 16:21:29 +0530
Message-Id: <20230517105135.1871868-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230517105135.1871868-1-apatel@ventanamicro.com>
References: <20230517105135.1871868-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We hard-code the kvm_riscv_aia_nr_hgei to zero until IMSIC HW
guest file support is added in KVM RISC-V.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
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

