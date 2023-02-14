Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F5C695835
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 06:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbjBNFJP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 00:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbjBNFIx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 00:08:53 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20591BAF8;
        Mon, 13 Feb 2023 21:08:32 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id r17so9411293pff.9;
        Mon, 13 Feb 2023 21:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sItHlm/JGIFF8epd+Grv0m74NzCDKYjoyYZMtq9W6kA=;
        b=GvahJ06V0yYti90uTJzBHGIjSPFYr01oL9eEhVi0PRR7naZdFoWbWNmu4II8htFqNv
         rSEoGyayflh4DS9iqCUkrcEISqfSxi/ty3zbAL6gwk3aY5m6nzcfCnth8vByPmSDvEpH
         +DPfV3aZpa5pa3DPFAGAZAWlSxHCOqTjxGfkixBe4EaSs7uIGNJMkeMne7dI+krX1N5j
         OcYp7Zcish2W37mVSMI2VFuE4bCVq2YF3zb10WqdHmkYQH3CCOruzdgJL9sF/9ned0gM
         NNT1d30R85h2669dNuNHrhtdrw+Xavco1TP5uBDaLdDuaXxc8Z9NkBTEfqsU3Z9qWeEr
         RCJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sItHlm/JGIFF8epd+Grv0m74NzCDKYjoyYZMtq9W6kA=;
        b=S4ynCkw3eN+L97cXIAFdh2f4Vtdpb8LQ64Z8gMp7KUuPvVnTrFKXXww6dyI18G5kbS
         2F74XgqV/F5HfMDbpt+Rkcds355voCa+EWdB5GQpey9cwEyGMTOm3gaEtbwCNBU/onLL
         QXCjCzkBrSqZeSLoyUeCJILipbLxOCSgEPmgV1KsIRkJpkzrLHJKdkQr+0dAgH/zIb0N
         hw7eW/ThLmYJ6UaYgqJKOZsF7zhBJfS6M2aeIwwp2CfM7LvEsMw/qMx8Vyl1juGLmw+b
         Naw+9kb4cg4aF5GZD8claJIbFw+cuFS7Hvpfxssk2PAAAdJyYU7czL4AusmSZ/M8kg0q
         Zp3g==
X-Gm-Message-State: AO0yUKUwBK5QjQWcPL/EYvF0fuXSq46KMG5EUtq26VL50fKUPnAYl+zR
        umhXYQCPz1YrzqTPHNzfhbVauprEt21W1Jpnwgo=
X-Google-Smtp-Source: AK7set94o6naqXRz6vBV7zTaP7mabK7N65dWwJa9gs0EZ7qFy/OhvTCpF1vv5byAZa1MS3byYqgJkQ==
X-Received: by 2002:a62:7b04:0:b0:5a8:a8b5:d185 with SMTP id w4-20020a627b04000000b005a8a8b5d185mr879057pfc.1.1676351312038;
        Mon, 13 Feb 2023 21:08:32 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j22-20020aa79296000000b005a79f5d9f53sm8738919pfa.165.2023.02.13.21.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 21:08:31 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 09/12] KVM: x86/pmu: Forget PERFCTR_CORE if the min num of counters isn't met
Date:   Tue, 14 Feb 2023 13:07:54 +0800
Message-Id: <20230214050757.9623-10-likexu@tencent.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214050757.9623-1-likexu@tencent.com>
References: <20230214050757.9623-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

KVM should sanity check the number of counters enumerated by perf and
explicitly drop PERFCTR_CORE support if the min isn't met. E.g. if KVM
needs 6 counters and perf says there are 4, then something is wrong and
enumerating 6 to the guest is only going to cause more issues.

Opportunistically, the existing kvm_cpu_cap_check_and_set() makes it
easier to simplify the host check before setting the PERFCTR_CORE flag.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/svm/svm.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dd21e8b1a259..f4a4691b4f4e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4910,9 +4910,14 @@ static __init void svm_set_cpu_caps(void)
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
 
-	/* AMD PMU PERFCTR_CORE CPUID */
-	if (enable_pmu && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
-		kvm_cpu_cap_set(X86_FEATURE_PERFCTR_CORE);
+	if (enable_pmu) {
+		if (kvm_pmu_cap.num_counters_gp < AMD64_NUM_COUNTERS_CORE) {
+			kvm_pmu_cap.num_counters_gp = AMD64_NUM_COUNTERS;
+		} else {
+			/* AMD PMU PERFCTR_CORE CPUID */
+			kvm_cpu_cap_check_and_set(X86_FEATURE_PERFCTR_CORE);
+		}
+	}
 
 	/* CPUID 0x8000001F (SME/SEV features) */
 	sev_set_cpu_caps();
-- 
2.39.1

