Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF37599A9D
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 13:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348723AbiHSLKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 07:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348720AbiHSLKS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 07:10:18 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F31FBA6A
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:17 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id y4so3868687plb.2
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=SFchpJ/MrC0RrbbSYDRFOHMYqa5I2Slu1pvtjw0DGY4=;
        b=O9D5eAOhM5vBEORGzKVH4FPfHKsUd3QWp+8qxYT3svu4l3ma6cmLR8Y0zgsulumBw/
         NJqvtn/W9/Tl7TzGyuR46LnXTqiMSZXm8aKTZoS6J++YEI0kXf2uTZi04g0qaoJdoXkk
         4NIBvFMvtyCsIhL2U1IONZpKO64PBGe0auC7If/O11q5gVfYprxvo0lXMTprREFLMLyx
         C34lnbqogvvxPqY/vxOWCahHmyaYPYw5pfeCmGGjgZnhSN0S9EWwyJQ2441urJIDj77f
         SHoAxfNgw83OzMQc1h+ix+Vin+b05zAxxCOuiB6u41PkVNWrufZ25jTD8H22n7wGil0B
         MqXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=SFchpJ/MrC0RrbbSYDRFOHMYqa5I2Slu1pvtjw0DGY4=;
        b=nxE9aLPXqosZ2/e3xx8ErnKdDyCOoBqwckx0dbA0ChAo2Yq1WZiK3/287BeMP+66NH
         3G5NuVjA27NKzoduVnof5yUVGtfL0K2j2jPO9Tf74d4Uh2zTArbOWwjVdrA0magFHukJ
         eA1ZwnCDgYB8hvUa59QGQ1NfIdRcoDFkjr0MmtvcFyHZlOYXM7Oy3DiUn+J7XUhjD9+d
         wicQM26X30YxeY7tziDuBqiqYoMivZm2wf4S9T226tEtu4VOTHrig9Zjyk/wV/WjTJjv
         t8ojuYq1+n/ZrnfPkh9tX8f895ASZ9c5JqubfaA+PTA6IAqkXDBTkTEZ2hW/CjqqGoe4
         JiRw==
X-Gm-Message-State: ACgBeo0uvQvFl6eWFIVadVP6MHUbLeFAy7OmPauxSPuJuCTh0E3EI85Y
        WIu0UCl0Rr+UqRzb1A1L+tjIIBelxfMWYg==
X-Google-Smtp-Source: AA6agR6e9qmYmlRIhl8UAUA3utDTRm7PpjdNTEBr5Yip+XsWhp2Y9R8aY/DvhLKdIk0iBFc4w/NbOg==
X-Received: by 2002:a17:903:28f:b0:16e:e00e:31ba with SMTP id j15-20020a170903028f00b0016ee00e31bamr7116559plr.154.1660907417162;
        Fri, 19 Aug 2022 04:10:17 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jd7-20020a170903260700b0016bfbd99f64sm2957778plb.118.2022.08.19.04.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 04:10:16 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 11/13] x86/pmu: Refine message when testing PMU on AMD platforms
Date:   Fri, 19 Aug 2022 19:09:37 +0800
Message-Id: <20220819110939.78013-12-likexu@tencent.com>
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

Add an Intel PMU detection step with a vendor prefix,
and report SKIP naturally on unsupported AMD platforms.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 x86/pmu.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 826472c..b22f255 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -667,16 +667,35 @@ static void set_ref_cycle_expectations(void)
 	gp_events[2].max = (gp_events[2].max * cnt.count) / tsc_delta;
 }
 
+static bool detect_intel_pmu(void)
+{
+	if (!pmu_version()) {
+		report_skip("No Intel Arch PMU is detected!");
+		return false;
+	}
+
+	report_prefix_push("Intel");
+	return true;
+}
+
+static bool pmu_is_detected(void)
+{
+	if (!is_intel()) {
+		report_skip("AMD PMU is not supported.");
+		return false;
+	}
+
+	return detect_intel_pmu();
+}
+
 int main(int ac, char **av)
 {
 	setup_vm();
 	handle_irq(PC_VECTOR, cnt_overflow);
 	buf = malloc(N*64);
 
-	if (!pmu_version()) {
-		report_skip("No Intel Arch PMU is detected!");
+	if (!pmu_is_detected())
 		return report_summary();
-	}
 
 	set_ref_cycle_expectations();
 
-- 
2.37.2

