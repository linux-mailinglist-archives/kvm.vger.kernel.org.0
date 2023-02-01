Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCFD56871AF
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 00:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbjBAXNV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 18:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbjBAXNI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 18:13:08 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7241EFC3
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 15:13:01 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so3891630pjq.0
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 15:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f/7530mh4DkGnv39VYISEk6sTro0TBVeeYDJYRU9cCE=;
        b=6rrYpuQ3AazlVjMMqGZZu5fqvWSx4m30nKrrli18Or8Z5zP+uxSAYGM9KwQ8QThJKh
         NhPSaWAkWIVugK1pWjFB0xZo0yGJKVVRYvCCZEaw8o6NQrg3KvGg2mVc2oS8Wm7J9Yxf
         ZEtGO1jXQXZ1foQbxQPD0bch3bOQWkFrj0yPM0ivgMu7otiD7CMlZTVc1c6Jh+MQq94w
         5PEY7auuWiTfnCI4NmhQYtox/77QemHrB2VSkzqCbAXFJUrXX1VmNqk40aKOMfUF3ajy
         UtEaqBPJXT7bVv5ugZ9uE+MiVAa4BlkFKiTo9pnBn56SUsZzgRMgctBcPWNwLHN4mH9H
         ruIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f/7530mh4DkGnv39VYISEk6sTro0TBVeeYDJYRU9cCE=;
        b=x7/+taohzWXAopRAPm+52YUBJKLqQjjM6xn90ZFtRS5IOXw4S+JO+SydUKMiTlsGsF
         2HmyQ4BJ7zBkjBq7h/dAFF1rzZvzcQVMbJWJHRrO7MJfG9qc2t4l5xeDuVTbZ006EmgN
         KAjsZkgFuACchjPFP5hlgL7m3sPinCybAEX6p0+I1w1WCSzswbDI0/sJM9agWZS0V811
         X1uS5pCDtP9lSBXS/5cjJhCC/x/0106Mzh4L5ABhY99kL4afsRsIX1n9dmLsme85xIPX
         G7iY+kGAlPPR9QUrIIgfQlnUkqdgrZP0YDub9/x0wmpfMP67f1sWwPP/eEOPFhVRgfr1
         K6Rw==
X-Gm-Message-State: AO0yUKXnLj9/5h7MSdnQxT0NpxRU/LADrTcgTVwwvpXZKevtoU0nR1AY
        QfI0hYx1Fa5G7UZOKZVoE+rg9Q==
X-Google-Smtp-Source: AK7set9Rt/QreaL1VPXUzodJiWysodEyNH87Hm5kvz/h1prd3AvfYbOWToHLHNakOdrUE2hCDsn95g==
X-Received: by 2002:a17:90a:31b:b0:22c:2da6:f3c0 with SMTP id 27-20020a17090a031b00b0022c2da6f3c0mr4126607pje.42.1675293181142;
        Wed, 01 Feb 2023 15:13:01 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id t3-20020a17090a510300b0022bf0b0e1b7sm1861774pjh.10.2023.02.01.15.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 15:13:00 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v4 09/14] RISC-V: KVM: Make PMU functionality depend on Sscofpmf
Date:   Wed,  1 Feb 2023 15:12:45 -0800
Message-Id: <20230201231250.3806412-10-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230201231250.3806412-1-atishp@rivosinc.com>
References: <20230201231250.3806412-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The privilege mode filtering feature must be available in the host so
that the host can inhibit the counters while the execution is in HS mode.
Otherwise, the guests may have access to critical guest information.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 2dad37f..9a531fe 100644
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

