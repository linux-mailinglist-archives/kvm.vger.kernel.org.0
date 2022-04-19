Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01150506534
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349166AbiDSHBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349142AbiDSHAu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:00:50 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5742A2F03D
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:59 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id k2-20020a170902ba8200b0015613b12004so9242012pls.22
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xBTLHLT7VrzBgTmY/Z5pWtMxjNk9GRjM0Wsv/9rlNHc=;
        b=VXqtSraq8cu7MS05g2E9z+XuvMzeSXl2fFGX5Y01D5E/dIxxlzx8ieTe37RrjIk3U8
         Qh9dlqkHr26rlE7cUeUJ722X9fORrcSyls/mjjfEdxkk7qv/i5exSe67vJL6znd7Jmxj
         XQleVnWUgNa/U6XHeLU4cVi7jJbuACQra/1UYgGqj4K+tkf/7sFnacr1qvJFFrXMhwrq
         LjiCU6LR5oMDmzv/AEuJDND+2wNX7EIcualNNJMKjPM+NXlYzs2C04kgPXIuXt8MTbBE
         VzdBDFwig9oH+F/vqkUZNWb/QeEljHfxo03ihPpY/Au8WjocLvzfT43Yox/2khE42Mcv
         XECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xBTLHLT7VrzBgTmY/Z5pWtMxjNk9GRjM0Wsv/9rlNHc=;
        b=t0ivm/wMtgWveqBCVsSwYeEu3sRF81RWkvKu8shDZ3VM9rh25d5JFQR5fHw6PkkrHC
         l2+e3Bv+A8fjvG7BXY0XAyvdczcg/NzYTU+dyWWKA1BX++NJayPcMTtb3Md9gWDwEF+f
         R/6tEIvD0Gr41iMm01XLrQckiGBaOZqrjRql+CApTyF5jRWlYTOb6tqMVL7ma7/0qAnU
         gr5326a0loDaDN5Gk6gd8ZsvJNPQweP4cwobgX2rDriHOB9pdAK8LX/nYc9tLXBTkekJ
         vcN6+JjyKw7BuojmbLSk3uj7wvSaroCOXxpuIF+CqC0vCn4r66ClfqiNlh3V2VxyXfZG
         uz7Q==
X-Gm-Message-State: AOAM531DQmORO2MSZNLOJp8pFPo6gfNXqoL03n+d6z9BUDFU/F9WcHFc
        7EVK3gDLnanwLIHFfoOrIuAPqlJ5TeA=
X-Google-Smtp-Source: ABdhPJwdi9SagPghJ2ANdJN9l35v2yt6f3eckRDsDVajt8Roakd+ylnifLm17O2VDNHE6Bdtl1/igHdjhO4=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:390d:b0:1d2:7a7d:170e with SMTP id
 ob13-20020a17090b390d00b001d27a7d170emr13243483pjb.230.1650351478693; Mon, 18
 Apr 2022 23:57:58 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:39 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-34-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 33/38] KVM: arm64: selftests: Add helpers to extract a
 field of ID registers
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a couple of helpers to extract a field of ID registers.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h |  5 ++++
 .../selftests/kvm/lib/aarch64/processor.c     | 27 +++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 8f9f46979a00..e12411fec822 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -185,4 +185,9 @@ static inline void local_irq_disable(void)
 	asm volatile("msr daifset, #3" : : : "memory");
 }
 
+int extract_signed_field(uint64_t val, int field, int width);
+unsigned int extract_unsigned_field(uint64_t val, int field, int width);
+int cpuid_extract_ftr(uint64_t val, int field, bool sign);
+int cpuid_extract_sftr(uint64_t val, int field);
+unsigned int cpuid_extract_uftr(uint64_t val, int field);
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 9343d82519b4..c55f7dfc8567 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -500,3 +500,30 @@ void __attribute__((constructor)) init_guest_modes(void)
 {
        guest_modes_append_default();
 }
+
+/* Helpers to get a feature field from ID register value */
+int extract_signed_field(uint64_t val, int field, int width)
+{
+	return (int64_t)(val << (64 - width - field)) >> (64 - width);
+}
+
+unsigned int extract_unsigned_field(uint64_t val, int field, int width)
+{
+	return (uint64_t)(val << (64 - width - field)) >> (64 - width);
+}
+
+int cpuid_extract_ftr(uint64_t val, int field, bool sign)
+{
+	return (sign) ? extract_signed_field(val, field, 4) :
+			extract_unsigned_field(val, field, 4);
+}
+
+int cpuid_extract_sftr(uint64_t val, int field)
+{
+	return cpuid_extract_ftr(val, field, true);
+}
+
+unsigned int cpuid_extract_uftr(uint64_t val, int field)
+{
+	return cpuid_extract_ftr(val, field, false);
+}
-- 
2.36.0.rc0.470.gd361397f0d-goog

