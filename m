Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3740E69B328
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 20:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjBQTbb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 14:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjBQTbZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 14:31:25 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABE85D3EB
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 11:31:21 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id t6-20020a7bc3c6000000b003dc57ea0dfeso1694679wmj.0
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 11:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3qVJ0bF2LOwR9FYE4JKJYonbraLFt3EzjvQr+HEt5I=;
        b=dDJnTYwngnWaEMzbUx4jZ16owZ0sQuT5enltrUeDwvsRnZTa0ZqUFeznb/4baviObx
         t+mRuQUNzNKeXtRe6pvoANi8rM4kQ1odHY5y1ACKAT+zWtZg1GxPJ9SsvSdrd2Bs3cVo
         kDmttHlvLfsqIbJnP3hg9dd7/QuOc/Kuz/qnGqK0bFNL7941EHNQvJmPy7y1fs9wHlTX
         5QvSWkqXB3S5gJWtQpNUDA0cb2n4FIAKZhGtB9j0JrS/VVVCORkenW0VV/qAPT08cQKC
         BVPZn/LC+cnMNSfeAJCYI1xsgmJz3h24QGAileaI9c17I7NU66LYjfXA3IYX49EWP0LI
         Jzmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h3qVJ0bF2LOwR9FYE4JKJYonbraLFt3EzjvQr+HEt5I=;
        b=Uv646cOD7a22S0pjbvbHgDemOpNmZdDhGuD+eYeliIGytM/jhar2RASuyPlav3JwEl
         ebPGqE2NA+StxBhiFOolevxnrkClLd8+ahj6xb+KGOPOPo8A+c85P7vWDqM9kAAzJ4NG
         u5EhgjtxdZTANcoiYCIENuFW3lY2j1eMX9MfRC3tPbEXTz9O0w9Uam9XSg9VDXpwTeaQ
         5dStjWy75SLW5/9qFFZg7es73sqUL3vt6dFmGDyAnPozCWg9U6SAnuT7qX4TZFiDbv9M
         Hi8D6uQwn4jC6rxsSXXeWN+6VdEngcXgTEswpzouXi4/HnUtH4td99ScIFRdZQmyFmlb
         KFiA==
X-Gm-Message-State: AO0yUKW4mm8BrFSO9lqC86fU+I0KY0c5rMDvfgLLyTvoTtFbP36DUKqF
        2qM1tb7z9pPfCMscDY+UKasM1NtO7dTSKRXC
X-Google-Smtp-Source: AK7set9FnlK5idA3iZnITZZN8lHm8p4XAS8BntZScEnhgNS2QLM37gJ5WgbduUThKUAlYlTQOqBLSg==
X-Received: by 2002:a05:600c:180a:b0:3db:1434:c51a with SMTP id n10-20020a05600c180a00b003db1434c51amr1329698wmp.40.1676662279691;
        Fri, 17 Feb 2023 11:31:19 -0800 (PST)
Received: from nuc.fritz.box (p200300f6af465a00bfa0a0965e5e0d85.dip0.t-ipconnect.de. [2003:f6:af46:5a00:bfa0:a096:5e5e:d85])
        by smtp.gmail.com with ESMTPSA id u9-20020a05600c4d0900b003e1f2e43a1csm5393618wmp.48.2023.02.17.11.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 11:31:19 -0800 (PST)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v2 1/2] KVM: x86: Shrink struct kvm_pmu
Date:   Fri, 17 Feb 2023 20:33:35 +0100
Message-Id: <20230217193336.15278-2-minipli@grsecurity.net>
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

Move the 'version' member to the beginning of the structure to reuse an
existing hole instead of introducing another one.

This allows us to save 8 bytes for 64 bit builds.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6aaae18f1854..43329c60a6b5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -516,6 +516,7 @@ struct kvm_pmc {
 #define KVM_PMC_MAX_FIXED	3
 #define KVM_AMD_PMC_MAX_GENERIC	6
 struct kvm_pmu {
+	u8 version;
 	unsigned nr_arch_gp_counters;
 	unsigned nr_arch_fixed_counters;
 	unsigned available_event_types;
@@ -528,7 +529,6 @@ struct kvm_pmu {
 	u64 global_ovf_ctrl_mask;
 	u64 reserved_bits;
 	u64 raw_event_mask;
-	u8 version;
 	struct kvm_pmc gp_counters[KVM_INTEL_PMC_MAX_GENERIC];
 	struct kvm_pmc fixed_counters[KVM_PMC_MAX_FIXED];
 	struct irq_work irq_work;
-- 
2.39.1

