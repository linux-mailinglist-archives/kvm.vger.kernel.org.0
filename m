Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E996753A0EF
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 11:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351070AbiFAJnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 05:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243015AbiFAJnA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 05:43:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 81060522C1
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 02:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654076578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ivDjIQXWN6AyT8LMwhNKski76n2fMPOrF0108bc7GWM=;
        b=a27yA2JDHPrgP2JJngfX8sjv+xuAa+/5PYINB4ELdnMfhq4w0YbXXuKvwr6/cUCRJu1Q3D
        4ZciJANg1o+9qCHC2dtKnHETzIhmWwALi6Z/54GBm2pEBoajboKWY3gwFG1BxyDPxo1PeZ
        TVRwFps50iUUiW1qS7ScxSxfNU6VI7g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-Z6BNiidANg-9gYJPRg-rEQ-1; Wed, 01 Jun 2022 05:42:57 -0400
X-MC-Unique: Z6BNiidANg-9gYJPRg-rEQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38233811E76;
        Wed,  1 Jun 2022 09:42:57 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F30A440EC002;
        Wed,  1 Jun 2022 09:42:56 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterz@infradead.org, x86@kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH] x86: events: Do not return bogus capabilities if PMU is broken
Date:   Wed,  1 Jun 2022 05:42:56 -0400
Message-Id: <20220601094256.362047-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

If the PMU is broken due to firmware issues, check_hw_exists() will return
false but perf_get_x86_pmu_capability() will still return data from x86_pmu.
Likewise if some of the hotplug callbacks cannot be installed the contents
of x86_pmu will not be reverted.

Handle the failure in both cases by clearing x86_pmu if init_hw_perf_events()
or reverts to software events only.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/events/core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 99cf67d63cf3..d23f3821daf5 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2095,14 +2095,15 @@ static int __init init_hw_perf_events(void)
 	}
 	if (err != 0) {
 		pr_cont("no PMU driver, software events only.\n");
-		return 0;
+		err = 0;
+		goto out_bad_pmu;
 	}
 
 	pmu_check_apic();
 
 	/* sanity check that the hardware exists or is emulated */
 	if (!check_hw_exists(&pmu, x86_pmu.num_counters, x86_pmu.num_counters_fixed))
-		return 0;
+		goto out_bad_pmu;
 
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
@@ -2211,6 +2212,8 @@ static int __init init_hw_perf_events(void)
 	cpuhp_remove_state(CPUHP_AP_PERF_X86_STARTING);
 out:
 	cpuhp_remove_state(CPUHP_PERF_X86_PREPARE);
+out_bad_pmu:
+	memset(&x86_pmu, 0, sizeof(x86_pmu));
 	return err;
 }
 early_initcall(init_hw_perf_events);
@@ -2982,6 +2985,11 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
 
 void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 {
+	if (!x86_pmu.name) {
+		memset(cap, 0, sizeof(*cap));
+		return;
+	}
+
 	cap->version		= x86_pmu.version;
 	/*
 	 * KVM doesn't support the hybrid PMU yet.
-- 
2.31.1

