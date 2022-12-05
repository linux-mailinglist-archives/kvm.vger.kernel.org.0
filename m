Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C836427A3
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 12:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbiLELhy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 06:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbiLELhk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 06:37:40 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545A2E2E;
        Mon,  5 Dec 2022 03:37:39 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id s7so10519726plk.5;
        Mon, 05 Dec 2022 03:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KFQHLYXEhvLwqH5TYvoapPT/lEw1a01Q5YmU44e+sHk=;
        b=M80cJZmAOTqLsmxJMavm8jqVic1TepS37Ipu6dZMWyx0nyOTubp1KMtTBtwZ9ApgYU
         KTalkwGpv2T+YQlQbsvg7HVPG061u42nZVmgtZdrv2OPw81go3nmhz6t7FABahlwuKmn
         4P0vVsXyj+ixPTUBSk5BYbQ0tlVu3tjrdBSi26B6FhRjD91vRgek+7t3tI5TCi/w2iQz
         wnigXB8csfmOccXBqrohXb5XOTgNcbqn736/2WEdJaaAt+oEarv1KKY6b+UCEF2nsKMH
         LTm73cboePXX/YpiKOa0dZ5RmJAg9iFZGDkxdMvyBW+xj2OaG3/VPVxuWbc+0eiYH3mN
         r1yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KFQHLYXEhvLwqH5TYvoapPT/lEw1a01Q5YmU44e+sHk=;
        b=K1+9eYz0E4a3Dn3FBew0FUlZLvstK6JY1TQYIcq4Gkg52zx1MWTBQMKyj2xRL9tDbL
         KF+KHka7CK9ctvM6j5IDz8EecZo9yHL5fmLBX1i9+mGmfV3BfxgV6Xmfqhxg/hUCsxiN
         Hm2Ab7jdVdLVcYtMM1xdN936Ky57J1Z2DXalJ/oVPm4L95Rvi8cuNvsGAOEQs1qqBa/k
         sWmo/u+esMo6YbNlhSgzi5rW/HZPFSojhRS1CDiBoHzjNPvykeK1haiTkT236EFLSVqR
         CILI+x6F4i/yB1fRf0Y2cX9+igt4Hb0JRNwCQVz8NuRy74AMgVlw+pJPB3csf3ccuurE
         35Yw==
X-Gm-Message-State: ANoB5pl055H39zhlxbigidrFUBIaualzWA3nqga3T/sMlQlUNu5heQXn
        +4678FMLiwtYNIIRhYRsaqc=
X-Google-Smtp-Source: AA0mqf73p05qfaoI01ifWj80/DGFPBfVqbGuKzxhFLakycVPgMGoV3H/JckECUZlvBSgYtOMbCC4VA==
X-Received: by 2002:a17:90b:264a:b0:213:7030:f69a with SMTP id pa10-20020a17090b264a00b002137030f69amr88900345pjb.231.1670240258868;
        Mon, 05 Dec 2022 03:37:38 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id a3-20020a170902710300b001895b2d48a1sm1106394pll.253.2022.12.05.03.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 03:37:38 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: Avoid ternary operator by directly referring to counters->type
Date:   Mon,  5 Dec 2022 19:37:18 +0800
Message-Id: <20221205113718.1487-1-likexu@tencent.com>
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

In either case, the counters will point to fixed or gp pmc array, and
taking advantage of the C pointer, it's reasonable to use an almost known
mem load operation directly without disturbing the branch predictor.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e5cec07ca8d9..28b0a784f6e9 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -142,7 +142,7 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 	}
 	if (idx >= num_counters)
 		return NULL;
-	*mask &= pmu->counter_bitmask[fixed ? KVM_PMC_FIXED : KVM_PMC_GP];
+	*mask &= pmu->counter_bitmask[counters->type];
 	return &counters[array_index_nospec(idx, num_counters)];
 }
 
-- 
2.38.1

