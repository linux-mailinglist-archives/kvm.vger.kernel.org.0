Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB665649F41
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 14:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbiLLNAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 08:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbiLLM7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 07:59:43 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2059F645D;
        Mon, 12 Dec 2022 04:59:29 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id p24so11999097plw.1;
        Mon, 12 Dec 2022 04:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SFgEeA5A7ARtU0YSkuHa+HRfQvgLKouYsg8RDNfDz84=;
        b=hYvw5QeX9zFE2tyoogipEA2SeBdLA6a/ID7vo7vUKHSbeiCDmKaygXXPX9Lo/3dQjL
         wDiPRNvYbLUhLxEz1lBKzyJmt13paqxtVTuhVHIblyclvXcrDilOupWQWydmpEVdpFpy
         lDgIiyKeSvJsJNuCp0Tu268yoqxmRnpHathFzO8QzT4e5PrMZG0D4DbnCrhwJELQMy79
         Ujk9s+ZmR0bDRaS36P2+h9a6hTisgO00ebt07mRmYVtX0KUHLztp2EvzowM+WBLx6uKU
         xFmaUoAvOb2K4a10+AlucSIyFqwuudy4fzPp21Q3xusMsOQjYiBwjvAGLMJwxb/LEkwz
         wgjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SFgEeA5A7ARtU0YSkuHa+HRfQvgLKouYsg8RDNfDz84=;
        b=6XWQ1H7KaaZUWgp6unYZimEQE2BDMR/X92Yf4qyY74kzHkn6FrwRJSQlPVeX4NFvEZ
         0RWHfTLGAFhO21eLR0jyVq19JDZTD3SJDFl8wbRuZdaAtxNvTBU0yTgs5grxcwxY1Nf9
         BU0x+CmWlPwCC1JKjcILfJ4bTsV1Qfl19qRc1pE1Z8eSHRHEjP1s3khEkNu1GMKQ08Q/
         U5UeMOXZo/5iRGnbjFPSQEDF9uSxVzdTUlXG6ZgaBaxXxdUUgALlmi73MdkK6o351p7p
         6+lzWktduHvW862377smeEh0dWicKDVG3tl+s0RcO82RG+VgqAefZgmOQbqSThMC7ucD
         v39w==
X-Gm-Message-State: ANoB5pngMMcKZhSL3/QYoLlS6M5pSEnkRxaoP0uvUDPClW+CT35v+O9X
        yV5XYb9xn6C1XpFpH9adOggTmZ+C69Wiz7eu
X-Google-Smtp-Source: AA0mqf5emy7VKp+UqKxtG/HsKTOuE75TU96mzsGRf9BNvRLY4E9/UMCoAuUikhRmrXE9VFgbHRWJ5A==
X-Received: by 2002:a17:903:18c:b0:186:b069:98d5 with SMTP id z12-20020a170903018c00b00186b06998d5mr20626737plg.69.1670849968562;
        Mon, 12 Dec 2022 04:59:28 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jc3-20020a17090325c300b00186f608c543sm6273927plb.304.2022.12.12.04.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 04:59:28 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RFC 6/8] KVM: x86/pmu: properly use INTEL_PMC_FIXED_RDPMC_BASE macro
Date:   Mon, 12 Dec 2022 20:58:42 +0800
Message-Id: <20221212125844.41157-7-likexu@tencent.com>
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

Use macro INTEL_PMC_FIXED_RDPMC_BASE in the rdpmc context to
improve readability. No functional change intended.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 637fd709f5f4..b69d337d51d9 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -136,7 +136,7 @@ static bool intel_pmc_is_enabled(struct kvm_pmc *pmc)
 static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	bool fixed = idx & (1u << 30);
+	bool fixed = idx & INTEL_PMC_FIXED_RDPMC_BASE;
 
 	idx &= ~(3u << 30);
 
@@ -148,7 +148,7 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 					    unsigned int idx, u64 *mask)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	bool fixed = idx & (1u << 30);
+	bool fixed = idx & INTEL_PMC_FIXED_RDPMC_BASE;
 	struct kvm_pmc *counters;
 	unsigned int num_counters;
 
-- 
2.38.2

