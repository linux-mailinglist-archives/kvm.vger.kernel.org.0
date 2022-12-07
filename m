Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3ED164546A
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 08:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiLGHPb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 02:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiLGHP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 02:15:28 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FE73FBAF;
        Tue,  6 Dec 2022 23:15:27 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id t11-20020a17090a024b00b0021932afece4so630260pje.5;
        Tue, 06 Dec 2022 23:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=irwELKgku9XO+PkVp3PJk2lHXEjpEyjkc1Dg0ROQzm4=;
        b=DFsxjvDT2uGfcXxcxPqVR0tKPPTxPVyRhht1b453vOlmzRPNrvE8e76aYflsONKUEl
         DnkK3ZE4Thy5xxRxASZydKiHcyH+ChwFXZKuBVkQgOgxg7RAfOoA5dDbKdBHwRRz926I
         l3EFfHM+WhEYE6xZKbFZ6hFY6GbHDzi5FQMTgAL9RenMHShSiPyEfK+MGIZaAq8Kp3Qa
         12BkPXqXfuXeXTNXEYBpejN7myai/oJLnP/qpxlBB01LMADkt46h3uDqRnnBW7uRMcrv
         PjK8C9rPZcA3l0evYCPPS0lldaFwrT4LxG7F0O8ntd/MnM4BzPBhy9RWBA2qMvMErhss
         dXyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=irwELKgku9XO+PkVp3PJk2lHXEjpEyjkc1Dg0ROQzm4=;
        b=vTiDg7ZWKcxjI4UxbW8Sl6zN/LPnHy+PdzaZdOicB0vUTDixek2Ed7Xf20MD8O4sD7
         wBfGmCbQeCV4vCti1JREjIC+dCDLTheDbCZT7gSo3M+XN74Z/pJZWXweDr8rrT99+hWE
         /lSP4FuN4Hy6yljIsG497jmCu26KTI/4rvjtNVKBD4S6GqTqFTLdNlsIZDqZOcZGLKyL
         Ch+9n/HrNUvTrAml+5dEbuFKvUW+1X//kR3TQpIqj0WO5Dt/cnbSCZG8d4bVb7f/stBD
         6TYGJuvQ20/QaUmkeHeqsqQ4x4aLv/JKRIrPIEIGA7viHLqP6HuU6dGOw/2lNL9+QSJ0
         8DHg==
X-Gm-Message-State: ANoB5pmD8M3//mLwvYf4a198AvJxPlhf75/nVYk1n7nSNI5yDkDrTZ+f
        5Pfl87F9drn8T9l1YI3aBq4=
X-Google-Smtp-Source: AA0mqf6QXrGNB9Fck1EG29BMan7sV5UVMU6CmMYL8qP9Duvuy/5rYJo4VYk70QzxmUrZY6fVupKcxw==
X-Received: by 2002:a17:90a:440b:b0:219:886b:9155 with SMTP id s11-20020a17090a440b00b00219886b9155mr26879356pjg.167.1670397327077;
        Tue, 06 Dec 2022 23:15:27 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id c126-20020a621c84000000b005629b6a8b53sm13198561pfc.15.2022.12.06.23.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 23:15:26 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH kvm-unit-tests] x86/pmu: Add Intel Guest Transactional (commited) cycles testcase
Date:   Wed,  7 Dec 2022 15:15:05 +0800
Message-Id: <20221207071506.15733-1-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
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

On Intel platforms with TSX feature, pmu users in guest can collect
the commited or total transactional cycles for a tsx-enabled workload,
adding new test cases to cover them, as they are not strictly the same
as normal hardware events from the KVM implementation point of view.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 x86/pmu.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 72 insertions(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 72c2c9c..d4c6813 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -20,7 +20,7 @@
 
 typedef struct {
 	uint32_t ctr;
-	uint32_t config;
+	uint64_t config;
 	uint64_t count;
 	int idx;
 } pmu_counter_t;
@@ -547,6 +547,76 @@ static void check_emulated_instr(void)
 	report_prefix_pop();
 }
 
+#define _XBEGIN_STARTED		(~0u)
+
+static inline int _xbegin(void)
+{
+	int ret = _XBEGIN_STARTED;
+	asm volatile(".byte 0xc7,0xf8 ; .long 0" : "+a" (ret) :: "memory");
+	return ret;
+}
+
+static inline void _xend(void)
+{
+	asm volatile(".byte 0x0f,0x01,0xd5" ::: "memory");
+}
+
+int *ptr;
+
+static void tsx_fault(void)
+{
+	int value = 0;
+
+	ptr = NULL;
+	if(_xbegin() == _XBEGIN_STARTED) {
+		value++;
+		// causes abort
+		*ptr = value;
+		_xend();
+	}
+}
+
+static void tsx_normal(void)
+{
+	int value = 0;
+
+	if(_xbegin() == _XBEGIN_STARTED) {
+		value++;
+		_xend();
+	}
+}
+
+static void check_tsx_cycles(void)
+{
+	pmu_counter_t cnt;
+	int i;
+
+	if (!this_cpu_has(X86_FEATURE_RTM) || !this_cpu_has(X86_FEATURE_HLE))
+		return;
+
+	report_prefix_push("TSX cycles");
+
+	for (i = 0; i < pmu.nr_gp_counters; i++) {
+		cnt.ctr = MSR_GP_COUNTERx(i);
+
+		if (i == 2)
+			/* Transactional cycles commited only on gp counter 2 */
+			cnt.config = EVNTSEL_OS | EVNTSEL_USR | 0x30000003c;
+		else
+			/* Transactional cycles */
+			cnt.config = EVNTSEL_OS | EVNTSEL_USR | 0x10000003c;
+
+		start_event(&cnt);
+		tsx_fault();
+		tsx_normal();
+		stop_event(&cnt);
+
+		report(cnt.count > 0, "gp cntr-%d", i);
+	}
+
+	report_prefix_pop();
+}
+
 static void check_counters(void)
 {
 	if (is_fep_available())
@@ -559,6 +629,7 @@ static void check_counters(void)
 	check_counter_overflow();
 	check_gp_counter_cmask();
 	check_running_counter_wrmsr();
+	check_tsx_cycles();
 }
 
 static void do_unsupported_width_counter_write(void *index)
-- 
2.38.1

