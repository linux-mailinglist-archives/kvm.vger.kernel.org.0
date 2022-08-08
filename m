Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF0758CC5B
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 18:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243842AbiHHQr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 12:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243717AbiHHQr0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 12:47:26 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3373167FC
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 09:47:22 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3283109eae2so82194537b3.15
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 09:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=J0glRIDIbuGCbKdxnt8/cWy/xOoQHmQPA7WmgziCB2E=;
        b=AfvAFqrfEt120gb1a3RLQJIpu5udvhNQB1FDeBfGrDbnJx3R/+fgR863wwCCv5ZZlz
         tk5xpQCXg9c6SWVKbFzEqlqHggMZXdxzlRW0Itc5yw5HPNlrGFYYg+jhRv0F2H6BPH/f
         KyiA2iRw91J/cyrRNPbauAuMIRQTMm25qf/0BLrtonDRPrC30GAugQ0qbVhxyDV6Z4PJ
         EvC73dRhRwsE510xV20L8NKKO+zmVLnmu8irzKgfl+DzNP5QsbVX9w86mdL4xBTeq2Sn
         wu0VJ7UbEZBx8CwBUqO+o1jGgalwRMXwC+0pB7LLaEGFnhKMd1BXwEbOqm5fTVlnvT1f
         SfvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=J0glRIDIbuGCbKdxnt8/cWy/xOoQHmQPA7WmgziCB2E=;
        b=B289sNCzPjfTcN/+N5Vaof2lNOFrJZMLRp3bKN7zS1tuHFye9I3wncPG+xo/vDYNAF
         qgv5is+zGGJzJsiarBfCr//BpWvoEZUp3PiXv0pI4b5lMZ/wyom0awZ/m10g1RVeh4mp
         oK1FGZUlh5GGg0iEZQBeMBtppHfV6NRROFFaEzu+jw1PJS7WB5Viv4/2t9FQKr3mFVAv
         QDI6miqok5g354CXB5OUAB3lAUA5k4ENJrFNnowyf8UtBmd4p/6YdctFgjJGZT9GIO7U
         5pvstOXmxV4+faDDVTo1SpQW0s84b58sfVRCRh80jriHDI7g2X44hbEGaKtp2/NpCv0Z
         JtyQ==
X-Gm-Message-State: ACgBeo39LyYPOvwNbdhXrn1KrtdJi2Oyz4F71oT9LDybvK11/EietY6Y
        /jdoZo3CicudSKK+qyrdsxC5PTRoumw=
X-Google-Smtp-Source: AA6agR7SO2aAw4dSqZdUIl4cP6rXs9uDeRInWbJJqU5gQtpXV+mkObgpSQSuZhYa8w6WWCttP+jTZu8Ky8I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:250:0:b0:673:e6c5:27bf with SMTP id
 77-20020a250250000000b00673e6c527bfmr17243579ybc.258.1659977241593; Mon, 08
 Aug 2022 09:47:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon,  8 Aug 2022 16:47:07 +0000
In-Reply-To: <20220808164707.537067-1-seanjc@google.com>
Message-Id: <20220808164707.537067-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220808164707.537067-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v3 7/7] x86/pmu: Run the "emulation" test iff
 forced emulation is available
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
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

Run the PMU's emulation testcase if and only if forced emulation is
available, and do so without requiring the user to manually specify they
want to run the emulation testcase.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c         | 17 ++++++++---------
 x86/unittests.cfg |  7 -------
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 457c5b9..d59baf1 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -655,17 +655,16 @@ int main(int ac, char **av)
 
 	apic_write(APIC_LVTPC, PC_VECTOR);
 
-	if (ac > 1 && !strcmp(av[1], "emulation")) {
+	if (is_fep_available())
 		check_emulated_instr();
-	} else {
+
+	check_counters();
+
+	if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES) {
+		gp_counter_base = MSR_IA32_PMC0;
+		report_prefix_push("full-width writes");
 		check_counters();
-
-		if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES) {
-			gp_counter_base = MSR_IA32_PMC0;
-			report_prefix_push("full-width writes");
-			check_counters();
-			check_gp_counters_write_width();
-		}
+		check_gp_counters_write_width();
 	}
 
 	return report_summary();
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 01d775e..ed65185 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -198,13 +198,6 @@ check = /sys/module/kvm/parameters/ignore_msrs=N
 check = /proc/sys/kernel/nmi_watchdog=0
 accel = kvm
 
-[pmu_emulation]
-file = pmu.flat
-arch = x86_64
-extra_params = -cpu max -append emulation
-check = /sys/module/kvm/parameters/force_emulation_prefix=Y
-accel = kvm
-
 [vmware_backdoors]
 file = vmware_backdoors.flat
 extra_params = -machine vmport=on -cpu max
-- 
2.37.1.559.g78731f0fdb-goog

