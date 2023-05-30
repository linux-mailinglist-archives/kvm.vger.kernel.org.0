Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DE471554B
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 08:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjE3GFT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 02:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjE3GFD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 02:05:03 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D485107;
        Mon, 29 May 2023 23:05:00 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-25687f44385so1462216a91.3;
        Mon, 29 May 2023 23:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685426699; x=1688018699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=okCUbwauqIa1DTJDmeQLbGd8OQ9Kua7tSb7xsqMZiUI=;
        b=U7+mSxeC/Yj44sP39TyH8ocQrCaAPwVNDwvLUuYbNK6d7KciKfwoJ1SpC8KGic4l/y
         vn6+9o1vZHR6CEDCfNNXiu50KM5eL24b8lES0h02HYexL6Nill3Wl1ol9vHpBC3xR0t3
         dGtE6wwi/NREVgHfny7XpYPp90EADRle9MApzyZWLjz22OIqOK7yk+xJPBx2etphVrBy
         ECCsvniGapeneRFlTO6gBvj9nToSkkfQDDmdaUpz1DLkG50FCrPrLelZ3fPfJD7zF9/i
         JF6A+lsUcV0z1LmL7aRD+zbW43UOfkbwHbPujoen92z0PZBdI9cvA5dEHtqf/5GPbsua
         hopw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685426699; x=1688018699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=okCUbwauqIa1DTJDmeQLbGd8OQ9Kua7tSb7xsqMZiUI=;
        b=V6d58yukfw0gVxTGUEvV8fQSBNfRGAsKc0rIv4HhmUn4hem4N7HzwiHzdneQSwtUbd
         FehRpAHFqPqC295fl4UwItMzB2DkpKn7oB0GdSVGvA9zNBafzjKe72zedd2RNV0Rdw2S
         C1SDs4K5Lolx8eqlc3124MQCdx1LAsnVHE4Z+qF106G1/qNSUtMDE8soDXE0RWWApH3l
         50yuNNU0GVomqu2pgBDe2wsvq+XwNz74YtPx50pQPLAKaEh6+nz5fP+PPIu0Bc7H7Gxs
         5Ylb+MpqDiTlhoDuXERA0AgYpoBadKJ5pVcIzsRHsKzysJTJa+mEIDpnpA6u2dSxZpdS
         9yUQ==
X-Gm-Message-State: AC+VfDwiVTUH1sEXzlerouxyKy90tMGodobThsAVY2H2oZ6Y44f8N39S
        cepZhWwxbsIYn7r4RuW7eVQ=
X-Google-Smtp-Source: ACHHUZ4T23R9zHhaB3Rx0O9ChMUitZIESI3yIzI1GOlKZtDq4ImOAitO5Kd1YJOaGQrUlmug+m8UCw==
X-Received: by 2002:a17:90b:4f88:b0:253:8e59:a867 with SMTP id qe8-20020a17090b4f8800b002538e59a867mr1212256pjb.42.1685426697009;
        Mon, 29 May 2023 23:04:57 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id gw8-20020a17090b0a4800b00256b67208b1sm638072pjb.56.2023.05.29.23.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 23:04:56 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 06/10] KVM: x86/pmu: Forget PERFCTR_CORE if the min num of counters isn't met
Date:   Tue, 30 May 2023 14:04:19 +0800
Message-Id: <20230530060423.32361-7-likexu@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230530060423.32361-1-likexu@tencent.com>
References: <20230530060423.32361-1-likexu@tencent.com>
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

A sanity check on the number of counters enumerated by perf is added.
PERFCTR_CORE support is explicitly dropped if the min number isn't met.
E.g. if KVM needs 6 counters and perf says there are 4, then something
is wrong and enumerating 6 to a guest is only going to cause more issues.

Opportunistically, the kvm_cpu_cap_check_and_set() is applied to simplify
the host check before setting the PERFCTR_CORE flag.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/svm/svm.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ca32389f3c36..d9669e3cc00a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5025,9 +5025,18 @@ static __init void svm_set_cpu_caps(void)
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
 
-	/* AMD PMU PERFCTR_CORE CPUID */
-	if (enable_pmu && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
-		kvm_cpu_cap_set(X86_FEATURE_PERFCTR_CORE);
+	if (enable_pmu) {
+		/*
+		 * Enumerate support for PERFCTR_CORE if and only if KVM has
+		 * access to enough counters to virtualize "core" support,
+		 * otherwise limit vPMU support to the legacy number of counters.
+		 */
+		if (kvm_pmu_cap.num_counters_gp < AMD64_NUM_COUNTERS_CORE)
+			kvm_pmu_cap.num_counters_gp = min(AMD64_NUM_COUNTERS,
+							  kvm_pmu_cap.num_counters_gp);
+		else
+			kvm_cpu_cap_check_and_set(X86_FEATURE_PERFCTR_CORE);
+	}
 
 	/* CPUID 0x8000001F (SME/SEV features) */
 	sev_set_cpu_caps();
-- 
2.40.1

