Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88432649F31
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 13:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbiLLM73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 07:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbiLLM7X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 07:59:23 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393F56160;
        Mon, 12 Dec 2022 04:59:21 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id m4so11995131pls.4;
        Mon, 12 Dec 2022 04:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OiLHXHKbQd18qU/wJIAEe1ddmbdvgaYtPXkeXnPK4Mc=;
        b=lLBbEI1nTIJOGEDFisYJob1XhIARuSKC0/jtyDs0opcR99IRYFPtY91txhFtVGZmSW
         XBNleig4SV8X0ilug2GL4IS+NMfBUG9qYgHnRnig69KYgubkmifnBg9Lm3cLMBl//rG/
         f0FBjyamlMtBahVDdXJWVOVA0yu0xhme5Ei1yq4rk7cSRumxje8jou4VAGIDooOqNDRU
         0s+dgky3tUWgRpmuwjv+DeH9bYI6W8GPOv2FUICsFSI6AhrJXc272vMO9FUCOOdpzHRt
         xP5FGwuaFhp/KPVqWaaesBGek/EI2MtaZmOjBwgCagpLLBZb+8JSu1dhYUV8MBK5gxd5
         adxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OiLHXHKbQd18qU/wJIAEe1ddmbdvgaYtPXkeXnPK4Mc=;
        b=PS6BTp4RV7ZmPz8MtZvE0TWenG9SW8F2pivTNWWYUE/PECa91BaaidqtK563cR1glk
         +XjqgeGlW4IlNAAsyU14yLixHrOZRVMiVohVi6/yEfOsiSF7UzzGZM5Vf8JrKTtQQsps
         871xMVql9thM6KjrIZbpuziFZ1YCpTQ0QWay/Uwp0/Oez+mu9IKzHz7eGJA4XnArt+c9
         UWMdSUgFfcpkFW6hvMMb6sLvExRxSRWOOmL6BPIbPcu7t29T1INkkpc5YcmflTGl45wy
         1E+H8UQFWD2TAxtpJDihDPbDnDdR6wdBQWYc1kUAEUmoaXQLRoguAKeKw5oX6vja4l0R
         rxKg==
X-Gm-Message-State: ANoB5pmUIeMxZawfnpvOfYqZGgYo+jWCBwEQeeHatQvN9sYP/joMFYHg
        Fe/KS2fmQFOpu7nE4kV7uOATgfcwAlSK3Q8G
X-Google-Smtp-Source: AA0mqf7Yz24FUgeNHPPXXOccqL227PFPrS8ouzv5RWtsGZv0wgyG8IldDLZyL3QB8JkOnU2GRBKh9w==
X-Received: by 2002:a17:902:7598:b0:188:92d6:49c8 with SMTP id j24-20020a170902759800b0018892d649c8mr16581800pll.48.1670849960678;
        Mon, 12 Dec 2022 04:59:20 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jc3-20020a17090325c300b00186f608c543sm6273927plb.304.2022.12.12.04.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 04:59:20 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: [PATCH RFC 3/8] perf: x86/core: Snyc PERF_METRICS bit together with fixed counter3
Date:   Mon, 12 Dec 2022 20:58:39 +0800
Message-Id: <20221212125844.41157-4-likexu@tencent.com>
X-Mailer: git-send-email 2.38.2
In-Reply-To: <20221212125844.41157-1-likexu@tencent.com>
References: <20221212125844.41157-1-likexu@tencent.com>
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

When the guest uses topdown (the fixed counter 3 and perf_metrics msr),
the sharing rule on the PERF_METRICS bit on the GLOBAL_CTRL msr does
not change, that is, it should be updated synchronously with the fixed
counter 3. Considering that guest topdown feature has just been enabled,
this is not a strictly bug fix.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-perf-users@vger.kernel.org
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/events/intel/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 1b92bf05fd65..e7897fd9f7ab 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2436,6 +2436,8 @@ static void intel_pmu_disable_fixed(struct perf_event *event)
 		 */
 		if (*(u64 *)cpuc->active_mask & INTEL_PMC_OTHER_TOPDOWN_BITS(idx))
 			return;
+
+		intel_clear_masks(event, GLOBAL_CTRL_EN_PERF_METRICS);
 		idx = INTEL_PMC_IDX_FIXED_SLOTS;
 	}
 
@@ -2729,6 +2731,7 @@ static void intel_pmu_enable_fixed(struct perf_event *event)
 		if (*(u64 *)cpuc->active_mask & INTEL_PMC_OTHER_TOPDOWN_BITS(idx))
 			return;
 
+		intel_set_masks(event, GLOBAL_CTRL_EN_PERF_METRICS);
 		idx = INTEL_PMC_IDX_FIXED_SLOTS;
 	}
 
-- 
2.38.2

