Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4A27B0F23
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 00:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjI0Wyr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 18:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjI0Wyr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 18:54:47 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DAAFB
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 15:54:45 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d814634fe4bso19039266276.1
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 15:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695855285; x=1696460085; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=otCLYnpGBntJ1XIGUKo0lfka8i4/1CQ7JQxRCB1gZcg=;
        b=1artL3CWvQClogVxRJKLhE0OxMGpHsNxfqckaO0FiRY/pI5OlGE84I+cBhKUCsXZqZ
         +kcXMS5KbkKTRr42OLONI8ktHz1OkylPKVw7jnHhR2LK6rVmkEgpwqrrHl9k9ZicGlai
         TRapO+Ba+kVUTd86v1NlgLJJ75yv6MfaqdDRHUworcouu74qjpGK2xXp8DFaYq0LPn2P
         VOUbzZy19IS5ObLgTc29bWinF6zxkFkKYGGIgbF2DMqB/x77rmnfFOHjNLjvTrqn60Ko
         1Lg/32w/UhnDGSz9+d0r/RPG0mfz+R3cXyHpowd7ur3ToHPWDcuTySAK9hGFk4GPscxh
         OCrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695855285; x=1696460085;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=otCLYnpGBntJ1XIGUKo0lfka8i4/1CQ7JQxRCB1gZcg=;
        b=sUbiGX/BGztF4KwcUMR29NqA1wSMlJ39vUFpU7zFr6PVPVhDV+AAVFZGxLQKSu9ER6
         ju8VgxOXPqPU7+9NHXS3KibeC5djtL+PJf7BwERCH4gdmWL7SvG8G+e2ZSgb0MMnb8AJ
         vKezsLQ2AkdQagCfT1B0LC2ekduKIhyGHAapj36wUBLM8oGbGnU7Ua6IzuzmizOVECrz
         Wqr8Yq5+oBFI7MUVlHiK2fcE7ZJWmNYfdHepwmmKbptGq4Fu2VuHw/C2DUZMB8IdqgoW
         cwUWYMRLm4J1xw/HnW179+9ciGyX/x2Ks0wJeBN0o7amGwQY0zXpFk+TAVbX0hXo3+V+
         xKWQ==
X-Gm-Message-State: AOJu0Yw+Zl2MuqyvgA2FopHvkKYFgc3bU6OxHQa1Vlqj0YabrDgNEeZI
        Rqgmch0fT27nwOvbo/0DR1maAQHlBEoa
X-Google-Smtp-Source: AGHT+IE1MJbZ9ftHobZXIfXAdd+pbHqmqUoKkhxD3/LH6/6gdZFfRZWaTUZqOBhehOaaLXkiSkMCmi2HQQjn
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a25:dad0:0:b0:d78:2c3:e633 with SMTP id
 n199-20020a25dad0000000b00d7802c3e633mr45783ybf.2.1695855284841; Wed, 27 Sep
 2023 15:54:44 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Wed, 27 Sep 2023 22:54:41 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230927225441.871050-1-mizhang@google.com>
Subject: [kvm-unit-tests PATCH] x86/pmu: Clear mask in PMI handler to allow
 delivering subsequent PMIs
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>
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

Clear mask in PMI handler to allow subsequent PMI delivered. SDM 11.5.1
Local Vector Table mentions: "When the local APIC handles a
performance-monitoring counters interrupt, it automatically sets the mask
flag in the LVT performance counter register. This flag is set to 1 on
reset.  It can be cleared only by software."

Previously KVM vPMU does not set the mask when injecting the PMI, so there
is no issue for this test to work correctly. To ensure the test still works
after the KVM fix merges, add the mask clearing behavior to PMI handler.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 x86/pmu.c      | 1 +
 x86/pmu_pebs.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index 0def2869..667e6233 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -68,6 +68,7 @@ volatile uint64_t irq_received;
 static void cnt_overflow(isr_regs_t *regs)
 {
 	irq_received++;
+	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
 	apic_write(APIC_EOI, 0);
 }
 
diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
index d1a68ca3..ff943f0e 100644
--- a/x86/pmu_pebs.c
+++ b/x86/pmu_pebs.c
@@ -117,6 +117,7 @@ static unsigned int get_adaptive_pebs_record_size(u64 pebs_data_cfg)
 
 static void cnt_overflow(isr_regs_t *regs)
 {
+	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
 	apic_write(APIC_EOI, 0);
 }
 

base-commit: 1ceee557f19a24455f162874586a0df5eaf53221
-- 
2.42.0.582.g8ccd20d70d-goog

