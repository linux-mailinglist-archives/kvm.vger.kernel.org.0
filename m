Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC0169B329
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 20:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjBQTbc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 14:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjBQTbZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 14:31:25 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F9A5CF04
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 11:31:22 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id e4-20020a05600c4e4400b003dc4050c94aso1677944wmq.4
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 11:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8WSi6Yx8V8miujoCWlAIYCoROXEDMV4nQFAEHjGFqXc=;
        b=XaN+ZS6Q0gwXJELjlZ+dXx1Lg5XiD31tdHIYvcm2zbyWkJvBP6Ke7uBtdkGFnsTbh7
         uRcsX3lNYZlv1u4Emwj1XXhlPVVh/hs6HYrmhqgJUnLDsd0OyJ2gzXuErd8uu4c4T8I7
         XXuTyeEn7ps1KYwLMWmYjdQrX4nCDDqsHL1hduYTD7w7sZYe1Ynb/A6NxvmS1lPXxf8A
         SXGlJR9OJ0+cZJmvRLpAcn5lo4EQUV1hfQjWsmqRo9jQKIhYAyKsVjm1k8q4PJwYnrwX
         iAQxLB4LckyhDXZGQ2Koxo9W0W8g0A4xMLJdbYxqVbqU5xuJ0YpAG6eJ7q7AP3n+BBxN
         a/tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8WSi6Yx8V8miujoCWlAIYCoROXEDMV4nQFAEHjGFqXc=;
        b=uDYbr64+Na9J2IhHNqzIDMXPuTWJz2YZN0bvdxds+Vsecbwx1WL3AB8k3q/YozG9bv
         kfCjxFjXDFJbnLaC+BemsfcBeA2Tg5pyspLl/SQaGb6GhNzfOGXrv1my0BL0q2cgYMSA
         uAI7KH9CuhKTIltCh5CmzSYpe9bXW/4eu080A4wf2auRidGlWFP7A+HLTusQOkNTU7Pj
         Hm55hARZknszURGBPLy2WO2Tw53VfSzerUZEYL5/uJoUkZZK3q5XcApYQVF0AiZfqojS
         wSo67jorsNf2ENgIKhaoC2eWgIEu3/8/EiyzTRwXVdvas1NHpQdw2cZbZAzedjL1aoVN
         zshg==
X-Gm-Message-State: AO0yUKUelVa9ddxay1j1U16cEWCYes7D3jGuB0EHH75aIe+UpVdCkEWG
        bxkYaTo/Dd/fPbvXtDRoOdX9FnpqPSKsd8j4
X-Google-Smtp-Source: AK7set9mBhbjWBQbVXwnRMh3ycSCnEMS4xykCEJmmL33SAA6mM/Q6hcBqqlF1TY/TdH9naEH7RQ2/w==
X-Received: by 2002:a05:600c:3297:b0:3e2:1368:e395 with SMTP id t23-20020a05600c329700b003e21368e395mr5115275wmp.33.1676662280398;
        Fri, 17 Feb 2023 11:31:20 -0800 (PST)
Received: from nuc.fritz.box (p200300f6af465a00bfa0a0965e5e0d85.dip0.t-ipconnect.de. [2003:f6:af46:5a00:bfa0:a096:5e5e:d85])
        by smtp.gmail.com with ESMTPSA id u9-20020a05600c4d0900b003e1f2e43a1csm5393618wmp.48.2023.02.17.11.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 11:31:20 -0800 (PST)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v2 2/2] KVM: Shrink struct kvm_mmu_memory_cache
Date:   Fri, 17 Feb 2023 20:33:36 +0100
Message-Id: <20230217193336.15278-3-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230217193336.15278-1-minipli@grsecurity.net>
References: <20230217193336.15278-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the 'capacity' member around to make use of the padding hole on 64
bit systems instead of introducing yet another one.

This allows us to save 8 bytes per instance for 64 bit builds of which,
e.g., x86's struct kvm_vcpu_arch has a few.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
v2: use order as suggested by Sean

 include/linux/kvm_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 76de36e56cdf..0b2ddce47f11 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -91,11 +91,11 @@ struct gfn_to_pfn_cache {
  * is topped up (__kvm_mmu_topup_memory_cache()).
  */
 struct kvm_mmu_memory_cache {
-	int nobjs;
 	gfp_t gfp_zero;
 	gfp_t gfp_custom;
 	struct kmem_cache *kmem_cache;
 	int capacity;
+	int nobjs;
 	void **objects;
 };
 #endif
-- 
2.39.1

