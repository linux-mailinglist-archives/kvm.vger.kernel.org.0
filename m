Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A446599AA2
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 13:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348717AbiHSLKQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 07:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348714AbiHSLKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 07:10:14 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71218FBA6A
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:14 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d10so3856186plr.6
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=0YGFLPFovyB+DyTae27PXjktmX2sRvaYGC3mBGAT3Tc=;
        b=YLq5SKA6Z5IdKifhlt6auyqTc9VCJLJq7++qeGbUrDwi3KyKHmPbxcuApBHNUzC+PR
         RMiuifxbmKh3TQdzKlFtxpb5dSYx4e92wSmYSawl2czBNkWj8HcZoBvmn2crJwEF+JKB
         38YXfYEZ2tzWBpuWedNKqfhOgyMpY25CLyzvGJ+q1OD7i5AD7rkw2KkCwubSv3x0oMRe
         mtom6rjmMTVQT25P6ISz1Ue/CT30oKQrobBlgI2JQG/eRB/T5Rlj0HQRbuY/dvPlJh5p
         cro94k+SHqWZ4e+mFb+E9LSN48sGg67l3ASNXpvieYIthotNbL5dmh0JlDzlTMtT1tK9
         s4FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=0YGFLPFovyB+DyTae27PXjktmX2sRvaYGC3mBGAT3Tc=;
        b=FGwiGfqwYqlCPqzXWJjJH39QRUJOmWn8VGfs0iff818dCzHANFvQocFo692/+72Pju
         2xb5dEHeXmklnHFKH4aW7SZvuttHUxgF1DrYHWUsIuTeWZL4Z7NbsHoxvZofFqulR/yN
         MfFvgOpG6RqqMrEghW4oQjs1KE+z1dh2uUaweGY4np9V2sc5LE113PcVuffkwPJGJNIc
         jVISzF4EFYEJ31n0y2pbRsevLSjtuQCfQWtHbCx5rBPzVFsyNqx8gbe/y+WscWJQVVQQ
         uqpeALXcLk+pa4xMgp06QeAoQgutnywGtAxi+ZJRGzdeCMGViyRx/tJwvTq5VOpNAp+6
         h1Nw==
X-Gm-Message-State: ACgBeo0c+7kPjuKiN2Ey+jGagpl+vGZobvYYOLO4pCdq5uSisyTt9uFh
        vA5/pf2CsenNYNJ6suXi1xo=
X-Google-Smtp-Source: AA6agR7rBjM6wWBALIACLDH7k+lh8VTq8e61TARHo4KALoCdWQC5rcPnhLz2ZzuDVU3MIXVQi8IF2w==
X-Received: by 2002:a17:90a:e7d1:b0:1f5:665:4607 with SMTP id kb17-20020a17090ae7d100b001f506654607mr13635154pjb.77.1660907413969;
        Fri, 19 Aug 2022 04:10:13 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jd7-20020a170903260700b0016bfbd99f64sm2957778plb.118.2022.08.19.04.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 04:10:13 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 09/13] x86/pmu: Report SKIP when testing Intel LBR on AMD platforms
Date:   Fri, 19 Aug 2022 19:09:35 +0800
Message-Id: <20220819110939.78013-10-likexu@tencent.com>
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

The test conclusion of running Intel LBR on AMD platforms
should not be PASS, but SKIP, fix it.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 x86/pmu_lbr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
index 8dad1f1..4a9e24d 100644
--- a/x86/pmu_lbr.c
+++ b/x86/pmu_lbr.c
@@ -59,7 +59,7 @@ int main(int ac, char **av)
 
 	if (!is_intel()) {
 		report_skip("PMU_LBR test is for intel CPU's only");
-		return 0;
+		return report_summary();
 	}
 
 	if (!this_cpu_has_pmu()) {
-- 
2.37.2

