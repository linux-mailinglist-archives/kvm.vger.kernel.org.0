Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D191626809
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 09:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbiKLIR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Nov 2022 03:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234747AbiKLIR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Nov 2022 03:17:27 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12085BD47
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 00:17:26 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id g13-20020a056a000b8d00b0056e28b15757so3798510pfj.1
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 00:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=erREdX/KDsXecKj6gAJQc8HQGGxLcgScAAv0CqZULEU=;
        b=YpZw7R2gC5bvKwjGM8NpdnFt1KqwMZgN0FK+q3Tcnq4RSpkrJ5mlI8gWdBgR1P3PNY
         wtWzQsCJAqHyfWbM4T6Blssr1vYpjmXg8r3avJ3Ag1eRynebA0swGQiLy+T/1xOLVqmx
         uKzeeAOCidZWlofpDaepHSuA37EGmUdkY+nB9QsBoniCzied3NX2L3xwX+W+QenR+ZG1
         qe7sBJhQop7ZDaWqme1bLG2j1DUYNgOzuWcEQ4r62GNmnVKY3n/YokKrJD6DndIW86EL
         O5F8B+cOkhxiU1R0kRa5Etvr8wVBsf/tf0E3jTUURwKOs26mJNks+CHuJUcJpad+jjix
         9UEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=erREdX/KDsXecKj6gAJQc8HQGGxLcgScAAv0CqZULEU=;
        b=LUIYUcxMIKoG4r0C39YQ5g52ZS06s9W67aOGQUZ48AuhAsQC1dDTyU45W0CuKkASzJ
         AovWmxpeoUl9XCR3t146GB02oXPOXyL3VLNgolexri0/HjIK/3OORIJTjZIzkY20CRF2
         hzjby6d6fdvLcpvImoenmUFKgsJrhsGBjC1g2KRmNmm9aO4tHfyXtH9a9ALdoJkJLX4Z
         B8DOQY8kPXJnD4n8bGMEGpvZiNPnVRamlgcnxIqnTJMj5ZZ/S96JzgLQHmKL6rDJLg2q
         CrknTAAFEj5zjaAe/MC41qCPG60K2jMCCiAkxEwULNweJ+csO/56ZYvwRzHqxuOmAK4+
         sTRw==
X-Gm-Message-State: ANoB5pkkGtsaBXlYHbmQidF+As+EO7gFxlvOXVlptJGLewNE6lcOq7wf
        ZFZJX+sK1k07IJuLgJAzzJTdIyVWMN7ipg==
X-Google-Smtp-Source: AA0mqf6QQp6GfMYPE6XZxs/+skS8K7KjLSTBecvWkfOO3UbLxYSWSVwUiwHGGOFgupv2VbGHKjubxmxwv9+J9A==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:aa7:92ca:0:b0:56c:6bcc:cf0e with SMTP id
 k10-20020aa792ca000000b0056c6bcccf0emr6073185pfa.64.1668241046330; Sat, 12
 Nov 2022 00:17:26 -0800 (PST)
Date:   Sat, 12 Nov 2022 08:17:07 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221112081714.2169495-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-6-ricarkol@google.com>
Subject: [RFC PATCH 05/12] arm64: Add a capability for FEAT_BBM level 2
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        dmatlack@google.com, qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new capability to detect "Stage-2 Translation table
break-before-make" (FEAT_BBM) level 2.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kernel/cpufeature.c | 11 +++++++++++
 arch/arm64/tools/cpucaps       |  1 +
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6062454a9067..ff97fb05d430 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2339,6 +2339,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.min_field_value = 1,
 		.matches = has_cpuid_feature,
 	},
+	{
+		.desc = "Stage-2 Translation table break-before-make level 2",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HAS_STAGE2_BBM2,
+		.sys_reg = SYS_ID_AA64MMFR2_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR2_EL1_BBM_SHIFT,
+		.field_width = 4,
+		.min_field_value = 2,
+		.matches = has_cpuid_feature,
+	},
 	{
 		.desc = "TLB range maintenance instructions",
 		.capability = ARM64_HAS_TLB_RANGE,
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index f1c0347ec31a..f421adbdb08b 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -36,6 +36,7 @@ HAS_PAN
 HAS_RAS_EXTN
 HAS_RNG
 HAS_SB
+HAS_STAGE2_BBM2
 HAS_STAGE2_FWB
 HAS_SYSREG_GIC_CPUIF
 HAS_TIDCP1
-- 
2.38.1.431.g37b22c650d-goog

