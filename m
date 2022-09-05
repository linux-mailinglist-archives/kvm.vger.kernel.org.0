Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5795AD321
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 14:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238324AbiIEMn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 08:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238291AbiIEMnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 08:43:17 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA2024BC4;
        Mon,  5 Sep 2022 05:40:14 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id q15so8496442pfn.11;
        Mon, 05 Sep 2022 05:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ZJDlOLNEpQinUeL6S1qQXyWawMV51E1l4RDKs95cZlY=;
        b=A6CNuAqfSnXCKuT9yMqADdppFaa4VPh8gdOoQYijd3hQxho33aGHW1aPYBbIAsxvub
         vxoyCmbk7O7uhWUQVl01MLXsT1NFRHboCmFF/tlJpAPf5SWJQYyPMeRSy3ygsyhSYlXQ
         KnF5LPd1/jEefwobszmz/n/GSw5HZpDNsqyGtW5tH0MTwOdb8BOmX/DzgwYdyw9I37JK
         tBp3Rzd1bIZRXptrp6qiO38C8K/l4963RUDzGgKPmsP369pdvaz8HnmxejkRk/z/oHSk
         x4LvbXBBtjkyxv4Endpd0/8A9g6y8CrSSCJ/9PStUlrBuBFaihjPQATtja7MXXPwxPnL
         7Y0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ZJDlOLNEpQinUeL6S1qQXyWawMV51E1l4RDKs95cZlY=;
        b=UiydInl6E+53/v3WMv0pQ5DL/liSczZfUYTdDJm6k16+meB+/JzbVzxu3vMNzd6kwZ
         KUVsafcM3brJA+Tp3CJo4rOOJLBdS+jWANbPuRz62HgWamujaIRoz059Gi2JjMe42bHu
         L45JpvqE/Eqqs1g9SRjJ/gEUgg2Eeu3Cb12ozX1x6HO4H1ZcuTpxkDOLdhJmG4pcJf9u
         C/stZmXr+Gydt+QZMZqWjcVKy26HmzEq8Kn//+PIjiC0fdzXGDll3iSY+cvD4SbgDmED
         mqeJtSvta0bc5SCmmSxTaXXmppReZ53umIJr2ZAKtlFcm+rna6f0eugnKz9OQ98mmRUt
         Uu6Q==
X-Gm-Message-State: ACgBeo2W0UbsD4s9acHgIvRft3euT6Kj3+O25ihvhFDEQsU0o0CzC8xM
        UdnwR2SY4Y+JMtm2zbcysSVNiqMI1xbTfA==
X-Google-Smtp-Source: AA6agR5+Sq28GBLhP3yoCm22e9i4Jf1XxK++1m3+SxgzCjiWXdiVYACsO0ohxHVfajoL436Ia06tnQ==
X-Received: by 2002:a63:d406:0:b0:434:7829:2e73 with SMTP id a6-20020a63d406000000b0043478292e73mr1563852pgh.573.1662381614437;
        Mon, 05 Sep 2022 05:40:14 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x8-20020a170902ec8800b00168dadc7354sm7428431plg.78.2022.09.05.05.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 05:40:14 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sandipan Das <sandipan.das@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [kvm-unit-tests PATCH 1/2] x86/pmu: Update rdpmc testcase to cover #GP and emulation path
Date:   Mon,  5 Sep 2022 20:39:45 +0800
Message-Id: <20220905123946.95223-6-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220905123946.95223-1-likexu@tencent.com>
References: <20220905123946.95223-1-likexu@tencent.com>
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

Specifying an unsupported PMC encoding will cause a #GP(0).
All testcases should be passed when the KVM_FEP prefix is added.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 lib/x86/processor.h |  5 ++++-
 x86/pmu.c           | 13 +++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 10bca27..9c490d9 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -441,7 +441,10 @@ static inline int wrmsr_safe(u32 index, u64 val)
 static inline uint64_t rdpmc(uint32_t index)
 {
 	uint32_t a, d;
-	asm volatile ("rdpmc" : "=a"(a), "=d"(d) : "c"(index));
+	if (is_fep_available())
+		asm volatile (KVM_FEP "rdpmc" : "=a"(a), "=d"(d) : "c"(index));
+	else
+		asm volatile ("rdpmc" : "=a"(a), "=d"(d) : "c"(index));
 	return a | ((uint64_t)d << 32);
 }
 
diff --git a/x86/pmu.c b/x86/pmu.c
index 203a9d4..11607c0 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -758,12 +758,25 @@ static bool pmu_is_detected(void)
 	return detect_intel_pmu();
 }
 
+static void rdpmc_unsupported_counter(void *data)
+{
+	rdpmc(64);
+}
+
+static void check_rdpmc_cause_gp(void)
+{
+	report(test_for_exception(GP_VECTOR, rdpmc_unsupported_counter, NULL),
+		"rdpmc with invalid PMC index raises #GP");
+}
+
 int main(int ac, char **av)
 {
 	setup_vm();
 	handle_irq(PC_VECTOR, cnt_overflow);
 	buf = malloc(N*64);
 
+	check_rdpmc_cause_gp();
+
 	if (!pmu_is_detected())
 		return report_summary();
 
-- 
2.37.3

