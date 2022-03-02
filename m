Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 864CC4CA2F8
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 12:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241283AbiCBLPB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 06:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241344AbiCBLOv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 06:14:51 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EF660AAF;
        Wed,  2 Mar 2022 03:14:07 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id p8so1643110pfh.8;
        Wed, 02 Mar 2022 03:14:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nirOxkhTtOqrukVcFgpCOAp8FbBAO2shJfP6XS8Zkbg=;
        b=crvxCU50UaIUgXmLL+2szMSRYsN12nUPfLrAxqiDX4Qq9npWOzUyriwRwPtRg3ay1A
         r+OuHNTf58OnrXGDn5aZLm9vaRegL/ArbOmm0juVbIDSvLMvGHiEwvyrIX2qHjuyEz2X
         b51MrjNjgBJl79KWvSu01tcznqb6eBLVlX6Ce53wsNQvU0IAuZgjLetmCvZNk+g4EIVq
         xbcK/KWzDcAJVfgPjzqEUui92w9hXrdIhEnytmEjR0xNX8Im7i4EySI4j+HXsPfQf9sE
         yew87eZnOcw2qbg1HjD2DyXgqLMByE2ecaQMaSJT2YpSF/H5sCb+I+OvlnWdbo2qByqn
         Jigg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nirOxkhTtOqrukVcFgpCOAp8FbBAO2shJfP6XS8Zkbg=;
        b=V4d5nqFSENrxVq96oF8ZdR7iVCZfdZs/HXD3bUU0jObRa/F4FYah5wqb6Z9eZlP4l8
         Wa/CHZHxMkU8Qqw8HFDw2e1Sn0znZZs4Hg3pzs8CQYe5dTxUvPboNVBAJrygVlOik7YU
         OAAeTDDU3h1pEpZE7BYaGbnlnwxQST6nK15fk5jvbmAoBLIuXjY1rnIdPP8hIOV9d6RZ
         guqdLvoJal5SdOnCOOu+J72R4jZpfRvGNIQffG1SIG8fupN9rIZKvG3X5OYCvXdwdFQj
         O8EJKy1WGkKBNyZx1TzOjHQNgL0Fx3aWWBOeRrbpb17v2OUm3z5mRMZTAu3DlRx2TNAz
         YLvg==
X-Gm-Message-State: AOAM533GmKGQPUqO5qgnEU9Q7lx+23d8/HUmnl0WSgeYY5RDkIqmUdjX
        iRTkNSEc0GJlaCVCNuWZZ8k=
X-Google-Smtp-Source: ABdhPJzwy+v7a/GQS42AVYm3JF3eKqXGxQNqD/eGV8caSeX2uMW6wrCiwI2eoDLLjKp5oOyF66WALw==
X-Received: by 2002:a63:5f14:0:b0:373:9e86:44d3 with SMTP id t20-20020a635f14000000b003739e8644d3mr25358045pgb.416.1646219647322;
        Wed, 02 Mar 2022 03:14:07 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v22-20020a17090ad59600b001b7deb42251sm4681847pju.15.2022.03.02.03.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 03:14:07 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>
Subject: [PATCH v2 09/12] KVM: x86/pmu: Replace pmc_perf_hw_id() with perf_get_hw_event_config()
Date:   Wed,  2 Mar 2022 19:13:31 +0800
Message-Id: <20220302111334.12689-10-likexu@tencent.com>
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

With the help of perf_get_hw_event_config(), KVM could query the correct
EVENTSEL_{EVENT, UMASK} pair of a kernel-generic hw event directly from
the different *_perfmon_event_map[] by the kernel's pre-defined perf_hw_id.

Also extend the bit range of the comparison field to
AMD64_RAW_EVENT_MASK_NB to prevent AMD from
defining EventSelect[11:8] into perfmon_event_map[] one day.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 00e1660c10ca..9fb7d29e5fdd 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -472,13 +472,8 @@ static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
 static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
 	unsigned int perf_hw_id)
 {
-	u64 old_eventsel = pmc->eventsel;
-	unsigned int config;
-
-	pmc->eventsel &= (ARCH_PERFMON_EVENTSEL_EVENT | ARCH_PERFMON_EVENTSEL_UMASK);
-	config = kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc);
-	pmc->eventsel = old_eventsel;
-	return config == perf_hw_id;
+	return !((pmc->eventsel ^ perf_get_hw_event_config(perf_hw_id)) &
+		AMD64_RAW_EVENT_MASK_NB);
 }
 
 static inline bool cpl_is_matched(struct kvm_pmc *pmc)
-- 
2.35.1

