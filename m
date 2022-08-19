Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D68B599A85
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 13:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348709AbiHSLKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 07:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348704AbiHSLKK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 07:10:10 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A1CFBA6A
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:09 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id a8so4295471pjg.5
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=2rwDhftcDKKq4CQuzXLKUT9Zt9Zd73y4NeTayZ73PF4=;
        b=KV7LJq3BR+TBx8fVhLx0SrEQegdcWhcZcvr08Gv3fB8Nq5GcowE2HRZAAfwvS90H4U
         /qluVKnYhetGxbYpfzDaVmJp1VYXN64WfDxtZcWl89BYH8UF4ApC930PPn9eq+YMnnfr
         O1K4FjV+Hsj6EqsX1NLEaAzlUk4PTpITHyhjkD6F2uMc9u4EpOIvXT3R7xBtsWFAX0Ge
         53lmHDQRozFMn892xG3mJMmx7SI52ta2S+kMr2eCnjVwlB9UdZW1nV5o4xFIOhAxauJZ
         87vkiPTkpbtq8/xvqBVYLU2pdqJSjqne+BxBS0Dsm/O/pvtWwGKHEfCcvUi7ry+nPYQS
         rXYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=2rwDhftcDKKq4CQuzXLKUT9Zt9Zd73y4NeTayZ73PF4=;
        b=EEgWeowlzWL/zdV83OLaXiBUzKVmbLp8g+e/f/YNI8Oc54HRyKqO+7FR9akk9CiMcj
         RVc2aaIcJWcEQcu2xMN5JZwC7vOrX2OEaKObPsmTxP9ti/Simd2qkeR4fQOGpMBbREpU
         Jm5rrEQcEYafzHSCIAjBc+Z/qZcweymMubF9xF8Si9wHogH2mjnQD6KktN58O3Q+yDVj
         hBFB0NM7jl8u6IBxWKLkQbbizJdHByM+Ruz0hM34HP3BltpY/vZt7cLZG2OWqD4o6DeV
         3IzaVIGZUC3eMPw1dM8CGkp+5P6HKRNEgvS4f+ZBd0NBqjq5EY7bPDqaK2XSzB0guhim
         sx5w==
X-Gm-Message-State: ACgBeo1vSjVB1KBbKFIbWibc++epZguORYfOi7aKu7vBTHUV7RSsbcJL
        BYGJXxJteK1PwECVmYeRRo0=
X-Google-Smtp-Source: AA6agR74QeVAbSs2O61j1YbI80hZ0Xyp8BtBGGpjZgm0zVkvFEjnDmGPS3uEgT30thW4MQzNM65Rrg==
X-Received: by 2002:a17:902:ce84:b0:16f:81d2:60c with SMTP id f4-20020a170902ce8400b0016f81d2060cmr6877132plg.57.1660907409094;
        Fri, 19 Aug 2022 04:10:09 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jd7-20020a170903260700b0016bfbd99f64sm2957778plb.118.2022.08.19.04.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 04:10:08 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 06/13] x86/pmu: Test emulation instructions on full-width counters
Date:   Fri, 19 Aug 2022 19:09:32 +0800
Message-Id: <20220819110939.78013-7-likexu@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819110939.78013-1-likexu@tencent.com>
References: <20220819110939.78013-1-likexu@tencent.com>
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

Move check_emulated_instr() into check_counters() so that full-width
counters could be tested with ease by the same test case.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 x86/pmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 057fd4a..9262f3c 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -530,6 +530,9 @@ static void check_emulated_instr(void)
 
 static void check_counters(void)
 {
+	if (is_fep_available())
+		check_emulated_instr();
+
 	check_gp_counters();
 	check_fixed_counters();
 	check_rdpmc();
@@ -664,9 +667,6 @@ int main(int ac, char **av)
 
 	apic_write(APIC_LVTPC, PC_VECTOR);
 
-	if (is_fep_available())
-		check_emulated_instr();
-
 	check_counters();
 
 	if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES) {
-- 
2.37.2

