Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2F067ED6F
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 19:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbjA0S0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 13:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbjA0S0Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 13:26:24 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436D97B405
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 10:26:22 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id be8so5859267plb.7
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 10:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VYOVEt3jt/KSlQQ1kq4H/LNDYTWOBqHX+UHxFdJqK+A=;
        b=kmh1lQGUzNyTV+SJvoAKXkHkMGjivjZAJea6T5Hr7EIlrPYBaMWMvcEiaLpqyM/KtS
         ePUoVDqeA8FMW6jaejIY4R3VgjOlyByf9TehWXCybvPMj+3uRjKWKop61ca/PFAC6MT4
         u3APAiin9cC4fpcKBa+GtGHu3seYOHxtbVJgMIUBvfzxemER3gL+mJmlsb0jlsOtQ+oS
         uOR1c9hgmjpmrfdg2V/+etjez1klBx34/ATu64GSwu4Arvg8fJLRv0JOESyyZq5JJ4hV
         TMtYAzqqBm3p15eDA0DYzPXUxJxBvUsdN3ACp+QtTe86hJ8JnVWhd0xd34wW7zvkSCt7
         3xuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VYOVEt3jt/KSlQQ1kq4H/LNDYTWOBqHX+UHxFdJqK+A=;
        b=VuUN6WvKosqcS9CEg5WYBCZNW1Y+eDgBUofSLtlOt7+BEDYL9km1sVVfAMvx/f+VTi
         P3jhDUfd1RdAjRPSxXHkkPm3xu6vvvjuqJHpy5883v84nCHHRTSTGRN2BpYjQWDwjWMg
         4WEucE9bffNtZZfuGrI0tT2SWVWwPuRAOtdtalLk7QEqbeUxPXvZGVuoziCQbIwHjNf6
         Qd61yZtEK+x+DWH/8RJtYBz7oiPFFQPh34vncOAl+Z3GhjdWea6jycgfrWvZrCLZcTQX
         TjZb3w0T7ohiV3ifgG3AoMSYo2iQ1EdwQcX6S+vz2vrJLNpM5aCbkESOG6erN/3/cMOD
         xqkw==
X-Gm-Message-State: AFqh2kque+UblDCJdoK3M1jBZvCzhnMfPb3UGLCyK1o+k3zVXVJFcxww
        4ZncthnoN+SR/WYHAroZS22GFw==
X-Google-Smtp-Source: AMrXdXv28M1C5TJfJZfYHoZMjXL4lC3hCwkbE2KMfgzJPjpOMAP1NeiIdUKuchXc6Zc48jYRIYXapQ==
X-Received: by 2002:a17:902:e811:b0:194:5066:fc20 with SMTP id u17-20020a170902e81100b001945066fc20mr51140337plg.40.1674843981856;
        Fri, 27 Jan 2023 10:26:21 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jc5-20020a17090325c500b00189d4c666c8sm3195219plb.153.2023.01.27.10.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 10:26:21 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v3 09/14] RISC-V: KVM: Make PMU functionality depend on Sscofpmf
Date:   Fri, 27 Jan 2023 10:25:53 -0800
Message-Id: <20230127182558.2416400-10-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127182558.2416400-1-atishp@rivosinc.com>
References: <20230127182558.2416400-1-atishp@rivosinc.com>
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

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index d3fd551..7713927 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -79,6 +79,14 @@ int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
 
+	/*
+	 * PMU functionality should be only available to guests if privilege mode
+	 * filtering is available in the host. Otherwise, guest will always count
+	 * events while the execution is in hypervisor mode.
+	 */
+	if (!riscv_isa_extension_available(NULL, SSCOFPMF))
+		return 0;
+
 	ret = riscv_pmu_get_hpm_info(&hpm_width, &num_hw_ctrs);
 	if (ret < 0)
 		return ret;
-- 
2.25.1

