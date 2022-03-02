Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090954CA306
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 12:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241391AbiCBLP1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 06:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241384AbiCBLPN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 06:15:13 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A80D60A8B;
        Wed,  2 Mar 2022 03:14:15 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id z2so1264879plg.8;
        Wed, 02 Mar 2022 03:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LB2Rb6jDVG8ESI9lXPQQ7RDtAAcoqVgAAU8pFuQ40Os=;
        b=mL0ZvY02MjrP36BHSwyl3J021AubY9TqUCofuH/2SptWX5ARfBr9gOASAsUnoI4UxB
         l6VXN4dH5oVt8zdJdmtNvTP3fTJOJyOiGWfXZhAF8khtCWLMQ5RUq+EIeU1LyEPOZ6Lr
         QNwDo2NgTGHhwEuoZKAHTO3FBh/KVPZ2FlG+yp+Bldb11+IRb8fAr5coRAMDHKdgBLHj
         MHf2zvSl3qxvpthSnYxjul17y1yT2RMVV7wXlGx+cgB/9y27jHqtb/s3ob6CGs45ENxc
         s86Yi57QikZgOXkfpsvEblpdiD25oPVJ4efasKccvp7UWVyZwFXWCQf+wmfQxBps/biw
         LeDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LB2Rb6jDVG8ESI9lXPQQ7RDtAAcoqVgAAU8pFuQ40Os=;
        b=wjOWzQy7s724eKqp9QRehZwshPd8QUZLKPFIlYHm+KH5QbQRBLJYQW88exiVWDy8nc
         HHqboFp4qz+t/KPYXXl0yt0kcIsSq+TAyg+1Un0f/yl547LwQ5RKLH3QkjH/a3kGYgOQ
         J0+dvLzIPydXlJgMCCr3wRH2Ic5xbKAr30vVC349NtPVyEs1OnQOti/mdnpDw3g1S5Ih
         AB1Zg9/aphfd8+HRLH0LsFcqUvdg7ZN9qMpY+xPe3sjJX+7ZdRD/oz8f+sVnKsr0ns2s
         N58brGyQNcdHylhyiMOcIkZydYJFZzuoVc5qrewTQTCFlD2DYeAvQ5WmCXzCfATjeY3B
         n7xQ==
X-Gm-Message-State: AOAM530KdRTqjEiQX7OL7zab51/bM9MQp7O2tcBHJl0HHeYWkR1w2bbx
        cP4xaJtwOq2bmdZd1gwjc/I=
X-Google-Smtp-Source: ABdhPJzgFSeWc9NS1kv85YFdX7GTdFf0FkqSaD2vPuTuSTkry9Xu8BmSkbBg1IA8PfXMKxwH6aofww==
X-Received: by 2002:a17:902:b582:b0:14c:a63d:3df6 with SMTP id a2-20020a170902b58200b0014ca63d3df6mr30212293pls.51.1646219654889;
        Wed, 02 Mar 2022 03:14:14 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v22-20020a17090ad59600b001b7deb42251sm4681847pju.15.2022.03.02.03.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 03:14:14 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>
Subject: [PATCH v2 12/12] KVM: x86/pmu: Clear reserved bit PERF_CTL2[43] for AMD erratum 1292
Date:   Wed,  2 Mar 2022 19:13:34 +0800
Message-Id: <20220302111334.12689-13-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220302111334.12689-1-likexu@tencent.com>
References: <20220302111334.12689-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The AMD Family 19h Models 00h-0Fh Processors may experience sampling
inaccuracies that cause the following performance counters to overcount
retire-based events. To count the non-FP affected PMC events correctly,
a patched guest with a target vCPU model would:

    - Use Core::X86::Msr::PERF_CTL2 to count the events, and
    - Program Core::X86::Msr::PERF_CTL2[43] to 1b, and
    - Program Core::X86::Msr::PERF_CTL2[20] to 0b.

To support this use of AMD guests, KVM should not reserve bit 43
only for counter #2. Treatment of other cases remains unchanged.

AMD hardware team clarified that the conditions under which the
overcounting can happen, is quite rare. This change may make those
PMU driver developers who have read errata #1292 less disappointed.

Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/svm/pmu.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 41c9b9e2aec2..05b4e4f2bb66 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -18,6 +18,20 @@
 #include "pmu.h"
 #include "svm.h"
 
+/*
+ * As a workaround of "Retire Based Events May Overcount" for erratum 1292,
+ * some patched guests may set PERF_CTL2[43] to 1b and PERF_CTL2[20] to 0b
+ * to count the non-FP affected PMC events correctly.
+ *
+ * Note, tests show that the counter difference before and after using the
+ * workaround is not significant. Host will be scheduling CTR2 indiscriminately.
+ */
+static inline bool vcpu_overcount_retire_events(struct kvm_vcpu *vcpu)
+{
+	return guest_cpuid_family(vcpu) == 0x19 &&
+		guest_cpuid_model(vcpu) < 0x10;
+}
+
 enum pmu_type {
 	PMU_TYPE_COUNTER = 0,
 	PMU_TYPE_EVNTSEL,
@@ -224,6 +238,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	struct kvm_pmc *pmc;
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
+	u64 reserved_bits;
 
 	/* MSR_PERFCTRn */
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
@@ -236,7 +251,10 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	if (pmc) {
 		if (data == pmc->eventsel)
 			return 0;
-		if (!(data & pmu->reserved_bits)) {
+		reserved_bits = pmu->reserved_bits;
+		if (pmc->idx == 2 && vcpu_overcount_retire_events(vcpu))
+			reserved_bits &= ~BIT_ULL(43);
+		if (!(data & reserved_bits)) {
 			pmc->eventsel = data;
 			reprogram_counter(pmc);
 			return 0;
-- 
2.35.1

