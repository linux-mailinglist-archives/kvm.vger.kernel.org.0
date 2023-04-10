Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4046DC5F1
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 12:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjDJKvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 06:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjDJKvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 06:51:45 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BFC61BD;
        Mon, 10 Apr 2023 03:51:31 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id ke16so4281991plb.6;
        Mon, 10 Apr 2023 03:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681123888; x=1683715888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=siL/5td9QhsXXhtZYPTjo70/OQWDBNwZqVddnZ8Ql0o=;
        b=XfthjGDRGhw6nwtA8r2xAWSOgEgP9OSKtiBqgfLNukbgatKKWynjGqSvNx7vLSoj2J
         KoSR89pzlYfuvBHqw7tSj6DhOdzrUWiJE9Ql14Z6kT6HkY2KisbBJnUfjozl4rxQ6j37
         tG+RK0huU4zzK4yNCM1XGoE06l9S4aO9TGDoqGYE3U8EhtGRko+6tF6CAYWh7WlV0wcY
         2/qUH/imVQTk+hDka7LbUhgRATu44TrmToPJhXWCDZiobgxp4OlN4q4l4a4VRrhXVHwl
         Q7Wee3+wfFy/lqP/90uX9KKxvVEtIAFaqJITLo8Vs+PAUxLWJIi0kE9RD5Q3CYU4aFD7
         OGmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681123888; x=1683715888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=siL/5td9QhsXXhtZYPTjo70/OQWDBNwZqVddnZ8Ql0o=;
        b=phXgEv/2VFum3MYE9Ydz/CCHhypTzpLM8/udOXDcdx8GuI56Co/+jDcppS2mjkUDLu
         Hcc6wZqrEsVaotAiMFsAnfw2qdTNKD/gHtrVfVieMqScG8gR//NctnNgxKZLB16VDlfz
         32vwOIRMCrjchNJ9Nb9knm6tHnNrKVAslpFN/BIFKJh2SOOS0kNH9zFCcrCYJ5ezakim
         Jr4QqoUFdPsJeakM2h2x8Yb5/XeY/rzJfVvRy5Deh4AuXBnx29ZU7znpnLxXK7v6NtQD
         6ooxuLIcYNXo87OqIOwR1oPM5k5Y0u/TOkP81m0V32lfYtKDiKhCRy9IH1pZB2+laDEc
         k6TA==
X-Gm-Message-State: AAQBX9f1oFN1GsMz+ZD3N4k/Cbd65RYurZE3yLqwbdPAW0XR33Cc2Bb5
        Xf1wFG5f8q8MxrUXSoXPeh8=
X-Google-Smtp-Source: AKy350ZoRXrpnjQNpJQNzEffJxeh8gid6aBA2Kk3d5YCA/5SyNeZwDxMqP14qkAC/wCpL7S6Hyczgw==
X-Received: by 2002:a05:6a20:8e19:b0:d9:6660:8746 with SMTP id y25-20020a056a208e1900b000d966608746mr14705391pzj.18.1681123887993;
        Mon, 10 Apr 2023 03:51:27 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h4-20020a056a00170400b0062e032b61a6sm7783252pfc.91.2023.04.10.03.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 03:51:27 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V5 06/10] KVM: x86/pmu: Forget PERFCTR_CORE if the min num of counters isn't met
Date:   Mon, 10 Apr 2023 18:50:52 +0800
Message-Id: <20230410105056.60973-7-likexu@tencent.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230410105056.60973-1-likexu@tencent.com>
References: <20230410105056.60973-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
index 7584eb85410b..683f1b480fcb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4928,9 +4928,18 @@ static __init void svm_set_cpu_caps(void)
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
2.40.0

