Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E854A7D7B
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244336AbiBCBsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbiBCBsV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:48:21 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BD4C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:48:21 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id p29-20020a634f5d000000b003624b087f05so636719pgl.7
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=b4vksZLlMEiO4ywLr2M7a7HAeZ1tFLiyor0J5bzguzE=;
        b=rDKFbR/dATp71fCoYDolbl9KvHd4aErz69kPjV36mZDgZe7g2Q4Ljmu8Lh9DfAJW0d
         mmU4kx67/z2+OmxM+YY6Id+c6K7e5fIgw/PBKfyTXblPTMwD4UzIpktlqgKMtYboUIbK
         DRDMfkPqGYghd5SCnTGrzOwWYc2CbUjt6BuHBolejVgQ/O3p2AQrGSxDk+UGk9MKjjtW
         0z3ozc5KPuqyyKS+aFuznCsfxJnH/CfSccAPw7etAorA9N8cjr/Xp2rdtlDlqZmbJXAb
         F6w/BLwHkbzhUaSLqHckg6cFj1XZ7Vs9BoS/gKVeC/Rl9AZO8zl7fkQIuFUxHMcJzTah
         S0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=b4vksZLlMEiO4ywLr2M7a7HAeZ1tFLiyor0J5bzguzE=;
        b=z8FBFfU7VpnqFjEG8y8IIYhrUZIiScHiABFEMkFIQd9PKXId6zfPzzOEwO0nWXUy0x
         ZCr2PLHsUmuZwwzbEz86hMmV3tKU+zR/alGlH0DPMsSs3ygChvyU+MUsiY2vSMXtGxty
         dqbGeYH1Pyp1szngV6UlH6sG5Z70TYMTfpBzRZBKu+yOvfZSywrJlfx4hxsOln9nY1Mb
         3s7evDTZ5A8tF/m9pGyJW3KtKyT4gzUdNsTXVcEl+u422hw/L7nm2eVl5zLnSnoQABNJ
         IIBF66BNSOgmI+zXpjw4gSjcyH7/6/PA1bJtV7gwKYzd4CBPJpSXQz3nH6t09OwZ3rhz
         2C/g==
X-Gm-Message-State: AOAM53204slhT/GiHB7+VgWGeWU3KZvZKJqNGQgkLJtTDjNGr0GBPUx2
        NDk+Tx92THfjxeGs5IXAkFr45c32jZHrnfu8ZzYTxh/tZq/Kbzdh6JK6yCiKuTOM6tyVifLiO+/
        axp1OvDJVwtEDS18cRqQa9Z//u96QK5/HR65DYb3wFps/Y7xCCV/FGicrD1pLfig=
X-Google-Smtp-Source: ABdhPJyHYbhWQvdY17LPkTTGI8oo/UmBydWJOB+gdAypwQ9giD2PmoCy3xWT64uS+csU5jp+1rEzDdLXHipddg==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a05:6a00:134b:: with SMTP id
 k11mr30299044pfu.33.1643852900422; Wed, 02 Feb 2022 17:48:20 -0800 (PST)
Date:   Wed,  2 Feb 2022 17:48:12 -0800
Message-Id: <20220203014813.2130559-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH 1/2] KVM: x86/pmu: Don't truncate the PerfEvtSeln MSR when
 creating a perf event
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD's event select is 3 nybbles, with the high nybble in bits 35:32 of
a PerfEvtSeln MSR. Don't drop the high nybble when setting up the
config field of a perf_event_attr structure for a call to
perf_event_create_kernel_counter().

Fixes: ca724305a2b0 ("KVM: x86/vPMU: Implement AMD vPMU code for KVM")
Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/pmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 2c98f3ee8df4..80f7e5bb6867 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -95,7 +95,7 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
 }
 
 static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
-				  unsigned config, bool exclude_user,
+				  u64 config, bool exclude_user,
 				  bool exclude_kernel, bool intr,
 				  bool in_tx, bool in_tx_cp)
 {
@@ -181,7 +181,8 @@ static int cmp_u64(const void *a, const void *b)
 
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 {
-	unsigned config, type = PERF_TYPE_RAW;
+	u64 config;
+	u32 type = PERF_TYPE_RAW;
 	struct kvm *kvm = pmc->vcpu->kvm;
 	struct kvm_pmu_event_filter *filter;
 	bool allow_event = true;
-- 
2.35.0.263.gb82422642f-goog

