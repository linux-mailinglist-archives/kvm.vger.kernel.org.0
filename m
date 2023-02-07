Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1FD68D34D
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 10:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbjBGJ4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 04:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbjBGJ4c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 04:56:32 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417E7EC67
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 01:56:31 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id k13so15147771plg.0
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 01:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U3Hr20eyCmr1XHvNCY+x9mO1pacGqN3TdQd+bzW/k8M=;
        b=4HEe0hzldZYwed5Z8Cp2++a5PJtmn28f8PTxEBZtcLZlF8EZm170x+BYoMl26u3x5T
         TRKm4iw2gy0MRLw6KZq/QzFP+V9r0l3hY4NGP5/PiII1Ol1HyHOOqjSWKLRHGo8ywXFb
         FvjnfuaC/OjtogkNOItzaP6cyDqZG/+6ugri5f74tfAJ/jfTwl4FEbfz4rCTwAv3uwDU
         lvTK/D9mtthTxn+aicm5Xw4+b3rtrifXhYBMCGHpEgMbxzSCTP7nM4Pq9N7GxMgiLOyC
         53mUzm4iUP5qMNNC8rqchdmoVr6Ligi6Fa3/nC6Cq6Igfk11s1aHMv32+2c9BBhyBNt/
         Kcow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U3Hr20eyCmr1XHvNCY+x9mO1pacGqN3TdQd+bzW/k8M=;
        b=gdtWoyirLlXsGHdY6rWxzvg+uDHwd59jSV6RJY6YiIZPIMJ4ZSlfPiCfMTSGn9sC9t
         T7tsC9VZYXUNj115pHSCtylS/4HEFEzd4TzKSFlROCqfSlH3D0Wa3VSclRwxEm51tvF+
         LJhzYjatpkbjSC5nu5PsKxjWMWNJQHFno8jsfI08iKsFBH9PjhX+A6WbCsnraxhMX4BZ
         /E4fqIl9QDx17ygbMphkduwE++lCbggoqRe6kSLl9jSieXMQensglrf23hawWwGpOl5v
         m1eI9E4ObC/TP4h05G6/NLv42VNY2VRAR6kgJJEaEhQpQ4pIVNYHjCMl2H9G93IUCWx9
         Y8eA==
X-Gm-Message-State: AO0yUKX5zETHgu3IGwlLgOMTQZuo+3toiMVyOZpnpeXdQd88en9edWD0
        08nWXmP0xMQQ/VXeWKrLzqZh6w==
X-Google-Smtp-Source: AK7set8QQLOwrqLTTA0LlDm/5ideQ9RT0pkFR/RF033vPbcn2NcFmH2jpV7biDMrXUHPtAQvFVZnzw==
X-Received: by 2002:a17:903:2444:b0:189:5ef4:6ae9 with SMTP id l4-20020a170903244400b001895ef46ae9mr2840251pls.45.1675763790800;
        Tue, 07 Feb 2023 01:56:30 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id w8-20020a1709027b8800b0019602b2c00csm4030598pll.175.2023.02.07.01.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 01:56:30 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>
Subject: [PATCH v6 3/8] RISC-V: KVM: Make PMU functionality depend on Sscofpmf
Date:   Tue,  7 Feb 2023 01:55:24 -0800
Message-Id: <20230207095529.1787260-4-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230207095529.1787260-1-atishp@rivosinc.com>
References: <20230207095529.1787260-1-atishp@rivosinc.com>
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
index e79721b..6c1f073 100644
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

