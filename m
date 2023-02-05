Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE0F68ADD8
	for <lists+kvm@lfdr.de>; Sun,  5 Feb 2023 02:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbjBEBPq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Feb 2023 20:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbjBEBPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Feb 2023 20:15:33 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231B726CC9
        for <kvm@vger.kernel.org>; Sat,  4 Feb 2023 17:15:31 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id v23so8901671plo.1
        for <kvm@vger.kernel.org>; Sat, 04 Feb 2023 17:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0AVlyEHbyyemXbCCJ04JjX0BL6y1QGd5zwSvkdXtPJQ=;
        b=FgqKEoOoZgRolw5POmyvUXh/mijLkxb5w8TApP3igblrnHfvRSgyoplkkkftOHr4Rq
         l7Zg++CBz0jZhffhS0C6w+LPoH3o54NahnXJHB2o0PXKKtnYf9RY6umvZHARXD3dszmo
         5ThlZqjAJpvWGBusFG/ESsmLdhTmMu377wyF8Z1rS2wc8LTEpR7Ut935sHHvInN9SVRP
         OA6JnM9xlFdZjpmfmc6MuqvTqlkZYEdioFKf6asTNfBsIEqUQv0pG4C7TsLPiQfL9lsg
         DaQCYRik/B40basr6055LhqqFRJWEPksw9vSIsQUvjhWfqlcWh7f1ia3s8VOT+ujs6ek
         RKBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0AVlyEHbyyemXbCCJ04JjX0BL6y1QGd5zwSvkdXtPJQ=;
        b=nr9a7QjdUCw4pLLdDbV9gpOq5XYopzrDgDxckOAUrJ/lQbvJUWdxHimaGPUcOGS5Hv
         dzg5Be9X29ugWqvSIvP+xH4jhYukC/9sm59CMEtpabF3nF8qGKAg5UrGanqQPEBDjWgJ
         BEiaf8zgeD47+AZnuYw1GJ3ikCkSmIEXv9T0tq1hxNsYkuJpRUOODvsPM4gtwz0bXgcp
         elmULG38xdFGePMY1jWZ1rWOgcbdNvHrjHs8QxR2C356eBpUuXXIDJ2IExBf+L3dE4/W
         NFJKQ037ro/R7w1z2tokV++Pk5iDXHfaLqLyw5L1JXxu/XSPhb4s+DpwCk91R9W6wB+z
         0Ftw==
X-Gm-Message-State: AO0yUKUrZtzxKUjAGXJ4E81azMbbZBK5uG8pA0ACoaTkt3tAv/7hqkd+
        hA263EB2B16gx0Cxn0Z1Qk6Jkg==
X-Google-Smtp-Source: AK7set/oi9xtk3D0Eq1rYz/SuC2Pba9Hx3SWd9xHCM5mD1XcAcOr4gEozd/X8WGb0NofSI+eOtU1NA==
X-Received: by 2002:a17:90b:1bc6:b0:22b:e75f:8502 with SMTP id oa6-20020a17090b1bc600b0022be75f8502mr8558170pjb.9.1675559730788;
        Sat, 04 Feb 2023 17:15:30 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id c7-20020a17090a020700b0023080c4c3bcsm2721917pjc.31.2023.02.04.17.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 17:15:30 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v5 09/14] RISC-V: KVM: Make PMU functionality depend on Sscofpmf
Date:   Sat,  4 Feb 2023 17:15:10 -0800
Message-Id: <20230205011515.1284674-10-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230205011515.1284674-1-atishp@rivosinc.com>
References: <20230205011515.1284674-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The privilege mode filtering feature must be available in the host so
that the host can inhibit the counters while the execution is in HS mode.
Otherwise, the guests may have access to critical guest information.

Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 4919255..6d09a6f 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -79,6 +79,14 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
 
+	/*
+	 * PMU functionality should be only available to guests if privilege mode
+	 * filtering is available in the host. Otherwise, guest will always count
+	 * events while the execution is in hypervisor mode.
+	 */
+	if (!riscv_isa_extension_available(NULL, SSCOFPMF))
+		return;
+
 	ret = riscv_pmu_get_hpm_info(&hpm_width, &num_hw_ctrs);
 	if (ret < 0 || !hpm_width || !num_hw_ctrs)
 		return;
-- 
2.25.1

