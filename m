Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A3C72B7BD
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 07:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236331AbjFLFlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 01:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235946AbjFLFkP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 01:40:15 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C33510E9
        for <kvm@vger.kernel.org>; Sun, 11 Jun 2023 22:40:06 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-1a670ac3650so979003fac.1
        for <kvm@vger.kernel.org>; Sun, 11 Jun 2023 22:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1686548403; x=1689140403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qy2FvnQ7sT+hFfzfZbK6StB7FDfBUwIcnd7vowD7Hdo=;
        b=fKgyV64IuuDp42oIE6+vlEALvMZVYR6v+zRX2M6KBdp2U1Q4EEebp+gWJClqMF1XXk
         OLG79st9/QNYq31F77kDNAqW5yxqzjZ/ljYG9ZCiIhBYqfERkkZZQkMmWp1DKH5TNdMY
         vXwGTZP9VPOUhOKsd6hbPeiYhZlI/rvmafAKC/3+1ih6jsO+O29QAWjMS+laB5KoHEvV
         GwwTRhkKPI0XRfYBv7/a6FrBe9Y+HxKOlxG2qFED5Y+OpmdtPrKVe6cF16ZoSPqwH9kV
         zYhhgtK4v0R8WlZnF2eixvx1n0GVXz/t83u1plyp4pJ+FBjsPOuJFY+3CynImlF53wg4
         93xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686548403; x=1689140403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qy2FvnQ7sT+hFfzfZbK6StB7FDfBUwIcnd7vowD7Hdo=;
        b=WudJiBiwydre38z9ITYrQ31p45J2v8NFEo0m9XyS8TlM68G78qbEa+XepB7NankNhw
         ipK1CPjkhcev7MF0sbNY+aFT6zFiGAWUHSIAdN7CwuOk2enDgpxQxOTQsI8Ru7kuxE2n
         zXq7+Nput9vT0oRGKIf3J1nfYIcLe1zHBN2p85Yo9WfLSyMIv7VsP8G65U7i/R+wAuPU
         J0aqPxMivP4DPbONMsh7uea/gqAYcQhwjwKkcbu5RYmHJZ4fGqFDaXAYr1lNvDREJMug
         F+d8zdlXVEAxRK69jnmlORVsLavHvp9ThKE9vcrzhDnr7/6dUWEV9LHXDFrhS6Qfnhh5
         gDig==
X-Gm-Message-State: AC+VfDyhm4vjIJxfvL7IElvxngDUWlWyHdYDFUV6WyOcPBz/8/kJrSST
        MtTlfPyUT364UTPEWkQ6AtwQag==
X-Google-Smtp-Source: ACHHUZ5kPec2p3OADgxcfQzu4nQmjeX0kue8Qhu5qVqg39cFrxryxf6q488ZF3QT6feTgV7ykRUpYg==
X-Received: by 2002:a05:6870:2207:b0:19f:5701:8c47 with SMTP id i7-20020a056870220700b0019f57018c47mr5001745oaf.9.1686548402860;
        Sun, 11 Jun 2023 22:40:02 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id lv19-20020a056871439300b001a30d846520sm5534869oab.7.2023.06.11.22.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 22:40:02 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>,
        Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v2 04/10] RISC-V: KVM: Set kvm_riscv_aia_nr_hgei to zero
Date:   Mon, 12 Jun 2023 11:09:26 +0530
Message-Id: <20230612053932.58604-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230612053932.58604-1-apatel@ventanamicro.com>
References: <20230612053932.58604-1-apatel@ventanamicro.com>
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

