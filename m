Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 824E569582B
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 06:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjBNFIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 00:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbjBNFIc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 00:08:32 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E371613534;
        Mon, 13 Feb 2023 21:08:25 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id h4so8036993pll.9;
        Mon, 13 Feb 2023 21:08:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W8nmMz7oCfEUvj7t/4z9Ywq4QcB70oo3SFxj8XWRGOY=;
        b=kw0OVoUxjjf8coMYsV721xacjRljMn2Aah2K8+ZnzE4JMDMTy8xzJFmbYUubTGoagR
         GvKqbvcCHCHwpynWNoCBBQazNeNrHzTioZuAWoAdW7jzGWWhJEZ7k6/WQ02EQyRVTaJO
         vtnQM0m26fNZmuqYIC7i7MlrBsxQymC4hZJ08QyD5NueIOVkSQBEF2bFxQurK7rDc/FH
         uMW8JS6dWH4ZRIDV3L5GfSzldBIe68IkUbzsc8WnSEMF84p/1WxkZ5H4f4uppwH/F4Be
         LfgrJFslq/Hj9naWkw5h7N++4YEhgFEuCoLvoJ+leeAHsKS+G1yJKt091bIf9YZ7xKyG
         5ovQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W8nmMz7oCfEUvj7t/4z9Ywq4QcB70oo3SFxj8XWRGOY=;
        b=uOtLfptgxV54usV9CLE1U78FbDqmsjdEoNpMyQHq7UY2zSH9wlKdYO5sSOTnuDYKTh
         lcFSWYeFLiSYF6fn2RQNtG1pyjE2sLdB/79qBzfS62VwbfAythhIMXUwJ1hOW6CD20MA
         KGdsewsrCwijP9+kYvJNRcoFDBDBOV3btt8On2qWSkF/Aesat0/GfNMvVy2U0U92vDAs
         okAQfzr3Yiug+bmnQ0ylVPLmB6/WJKo2luCcEaAQQ5yRSoAt5CMWZUwDOofg4FpEVORq
         T7ObM5Po9ilC5ZTKImuLvkbZEdeit2+XyFVCR1QylLiqXgGPOlFmmjmxQMaPooDyTrb5
         SWkA==
X-Gm-Message-State: AO0yUKVKB2LUD1vPT9v9PrNv4H+hxP42+TkI0qgsrz8Awxud9vEZICtL
        uuVqB5jKcKYdLfyeCr2LK5xgDbjyTWUkPqzHkSA=
X-Google-Smtp-Source: AK7set8Rlr1P355LUYmEV6WXCfOjzqTTVgbc4gS2tbC0Y3emDCAefLrMKM+5JAU7l5lNZ9Z5ldlaPQ==
X-Received: by 2002:a05:6a21:33aa:b0:bc:4d0c:ce45 with SMTP id yy42-20020a056a2133aa00b000bc4d0cce45mr1322845pzb.53.1676351305357;
        Mon, 13 Feb 2023 21:08:25 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j22-20020aa79296000000b005a79f5d9f53sm8738919pfa.165.2023.02.13.21.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 21:08:25 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 05/12] KVM: x86/pmu: Error when user sets the GLOBAL_STATUS reserved bits
Date:   Tue, 14 Feb 2023 13:07:50 +0800
Message-Id: <20230214050757.9623-6-likexu@tencent.com>
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

If the user space sets reserved bits when restoring the MSR_CORE_
PERF_GLOBAL_STATUS register, these bits will be accidentally returned
when the guest runs a read access to this register, and cannot be cleared
up inside the guest, which makes the guest's PMI handler very confused.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 904f832fc55d..aaea25d2cae8 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -397,7 +397,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			reprogram_fixed_counters(pmu, data);
 		break;
 	case MSR_CORE_PERF_GLOBAL_STATUS:
-		if (!msr_info->host_initiated)
+		if (!msr_info->host_initiated || (data & pmu->global_ovf_ctrl_mask))
 			return 1; /* RO MSR */
 
 		pmu->global_status = data;
-- 
2.39.1

