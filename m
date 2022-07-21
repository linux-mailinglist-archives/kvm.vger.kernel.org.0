Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C080657C914
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 12:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbiGUKgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 06:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbiGUKgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 06:36:01 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAB128E1C;
        Thu, 21 Jul 2022 03:36:00 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id t3-20020a17090a3b4300b001f21eb7e8b0so4227049pjf.1;
        Thu, 21 Jul 2022 03:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ojTdOvekZFxnrXtD4DiHIEP3F03nTJIQqCh8/9hHa4k=;
        b=Ri9b82ZtYT7TeTf8FyMtOLfy7LgXbRy8Pg5DodWL9WG+QG3isp+1cOfz3ZxbU1aA9/
         AVmqOO5TEGYah7SohIfcWJnAo1jiqIxJU96meKkoJnv4gJOanz28svdhhPEJzgaoJDw1
         G7KP8heB0Wjwa2ID3JPy8lOpIdkrBFMLzMd/COvVv6HG5gQOtXfFVn8ge11W07FRarRs
         ayk/gwFuXl7T8zR0zJzb3iA1SC0pTsZe99xu2vtW0X5jfgQxMmfZwLLrfz1dfdHhnzZo
         Gat5HKev0LK5Y4oA2ZLoIkJNv5CT44OMUYosNZQ61M1jwfmqJLdKmqXtWHpOQKQ/2q+m
         Fk1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ojTdOvekZFxnrXtD4DiHIEP3F03nTJIQqCh8/9hHa4k=;
        b=PWEf7UxG4s5p46uNX82Kve5c4R3Q10jDCr5A+y6o+0kk53PEG3QLQxT00EmQ5s8deX
         yU6bkEu3tmz1gyctZoEGVRTi+ITScygV0CH/eZ9Q2vr6UHnmO4Wj2gYK34MUHlmkbrot
         TwnyjmzjEjjodrybTAdvNk+J6sANfCO2Ro4pD+yQnfYOiW8hcWliRzH77s9r20pLz+lO
         1wKX6Kwc1UM1w0ZfKFwUT6UAXGwgoQPqxEieWu/gxkjYRkuKNNsjpcCxRM9eve+i6FKa
         O8WSsc1kcB+o2safn/ENf462/8kHrSBaWSyah+0JWprN5GDJVpolPbq5Ut78WsFHon5A
         SvTA==
X-Gm-Message-State: AJIora9eQtzRZ2E7Lc0HqAJP9XCnYYjWtI86N43vW8MzNn/fBOU4KTRY
        FBnNS42ff0DDdOsraJrotoA=
X-Google-Smtp-Source: AGRyM1vPplN6H7FMHen1Lt6GXz+XBq7RgCnVoZksODNCncTaXOXIGYsJFGEKg8EbIMwaIgmFGYl3Qw==
X-Received: by 2002:a17:902:a616:b0:16c:d74e:4654 with SMTP id u22-20020a170902a61600b0016cd74e4654mr24025363plq.4.1658399759960;
        Thu, 21 Jul 2022 03:35:59 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q12-20020a65494c000000b00419aa0d9a2esm1161887pgs.28.2022.07.21.03.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 03:35:59 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>
Subject: [PATCH v2 1/7] perf/x86/core: Update x86_pmu.pebs_capable for ICELAKE_{X,D}
Date:   Thu, 21 Jul 2022 18:35:42 +0800
Message-Id: <20220721103549.49543-2-likexu@tencent.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220721103549.49543-1-likexu@tencent.com>
References: <20220721103549.49543-1-likexu@tencent.com>
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

Ice Lake microarchitecture with EPT-Friendly PEBS capability also support
the Extended feature, which means that all counters (both fixed function
and general purpose counters) can be used for PEBS events.

Update x86_pmu.pebs_capable like SPR to apply PEBS_ALL semantics.

Cc: Kan Liang <kan.liang@linux.intel.com>
Fixes: fb358e0b811e ("perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/events/intel/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 4e9b7af9cc45..e46fd496187b 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6239,6 +6239,7 @@ __init int intel_pmu_init(void)
 	case INTEL_FAM6_ICELAKE_X:
 	case INTEL_FAM6_ICELAKE_D:
 		x86_pmu.pebs_ept = 1;
+		x86_pmu.pebs_capable = ~0ULL;
 		pmem = true;
 		fallthrough;
 	case INTEL_FAM6_ICELAKE_L:
-- 
2.37.1

