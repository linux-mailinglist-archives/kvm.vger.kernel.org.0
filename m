Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5C06190CA
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 07:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiKDGRI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 02:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKDGRG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 02:17:06 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C71727DE2
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 23:17:04 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id m7-20020a05600c090700b003cf8a105d9eso2548223wmp.5
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 23:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zhu8jnKVSyUET5dWBbeizhKy1SMpRgjknQ38ay3i9pY=;
        b=covwzkdstwrYZ2G7OGrFQYxKlY30OW2v5rlDRhhupowlVD65ej46/o9SO1UinrJ3/m
         0lzcsO8YTJZmr/8SS9w4G7XV3IkmHQcJPGZbAe/TLjJ5KTJK85/W6uuk7h6kTDoQj92W
         ApAWWRRkpDXzKGV9t9o3idyzMUpNFaWAZu9DuTUUy6nrTakQB0q5wzB+k2CelDXa6IB5
         2FO5BoKxhA2bpTh7AZA9bEYA3HeY+XOxsUwYP4XXKEpXY21QhzIYtSm/7JtZ8pYOY/Ta
         +TNovCnwrRY7TDHWx4Ppwn5BGKQJ1qdrs6RhX5fjH3YY+C3XZRqQmGpNg1DWvjpAr/EE
         Kv2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zhu8jnKVSyUET5dWBbeizhKy1SMpRgjknQ38ay3i9pY=;
        b=VKI+9tyuFUpHt/otB+o05Qk4dycjnwyuNin2igV+iuRGX1yHO6+MCxhvUudr57wcRO
         HMGGYAEfzjrOeu+4Oc6K7C6gUHf5uGPRgu2v0XDdbqJNCu8lugp6lAXu7w6o9oP5PWzg
         McnhW8zDsxsvAQoXdLgoggEsXYuOYGkF119pnuBiPdLoMcG55oqK6NNufsnEBzTSR8Go
         krR6Xdczdmobn1m9kJo3EhEvnW6SawD2sc1Hp8vmN5VtCb2jeb058t3JJE8c1h78z/wk
         xzfjDAzI083TjsZEgBCXZlc+incltqa+s120+7WzE4cvuQJELj3nwNy/sxaZfbnwi3nJ
         NO3Q==
X-Gm-Message-State: ACrzQf03OxRL4JhAd7VpxLM31CZqSn/wsupGrDiJeg1J/8JDIX+9k61p
        YPjnVetgO4/W/vMMKO61eW+GCw==
X-Google-Smtp-Source: AMsMyM7QV0dYQ4ol87Y3z5F86P2uJ/pz/WIvC3iw6qySzDfWN/XF8zwLlmhTATqf2Z5wsEx3NYMhJw==
X-Received: by 2002:a05:600c:1e8c:b0:3cf:55e7:c54f with SMTP id be12-20020a05600c1e8c00b003cf55e7c54fmr27323841wmb.61.1667542622808;
        Thu, 03 Nov 2022 23:17:02 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b4d7:0:c7c:f931:dd4c:1ea6])
        by smtp.gmail.com with ESMTPSA id m16-20020a5d6250000000b00236860e7e9esm2487658wrv.98.2022.11.03.23.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 23:17:02 -0700 (PDT)
From:   Usama Arif <usama.arif@bytedance.com>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com
Cc:     fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH] arm64: paravirt: remove conduit check in has_pv_steal_clock
Date:   Fri,  4 Nov 2022 06:16:59 +0000
Message-Id: <20221104061659.4116508-1-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

arm_smccc_1_1_invoke() which is called later on in the function
will return failure if there's no conduit (or pre-SMCCC 1.1),
hence the check is unnecessary.

Suggested-by: Steven Price <steven.price@arm.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 arch/arm64/kernel/paravirt.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
index 57c7c211f8c7..aa718d6a9274 100644
--- a/arch/arm64/kernel/paravirt.c
+++ b/arch/arm64/kernel/paravirt.c
@@ -141,10 +141,6 @@ static bool __init has_pv_steal_clock(void)
 {
 	struct arm_smccc_res res;
 
-	/* To detect the presence of PV time support we require SMCCC 1.1+ */
-	if (arm_smccc_1_1_get_conduit() == SMCCC_CONDUIT_NONE)
-		return false;
-
 	arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
 			     ARM_SMCCC_HV_PV_TIME_FEATURES, &res);
 
-- 
2.25.1

