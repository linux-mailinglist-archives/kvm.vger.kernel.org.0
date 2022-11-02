Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2B36170F5
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbiKBWw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbiKBWwG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:52:06 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162BC11824
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:58 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id g6-20020a17090a300600b00212f609f6aeso32871pjb.9
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9nNN+PHGzHbaYgQC/ZKeqL/CYE4IeJIcWyQnEGuKDW4=;
        b=gJEoETgcpi2u+53kjhMUFmXNLgfpF6ZWKxz4umXIGbk3isqrWyFlnW/Bcp97G9TfDI
         Xx92FdS0K0BCvSUgraXg7G0/fWk9/RkJd6Tx/MduWMhl86p/yvQSkkqVipEKeNoRMpDL
         qpN5YtBOk7hgc2aIcwmfTK+YSBANHzXbulXKuGUEkcyciG/8btFAeH/tPqtXB8l3q7Ml
         zC7mCfMyATKOYeFfpCUVWy8DJ68b4UZg5f+4hI0xvC6hmJGNIDdQ0dLjiX2mY4USUOfv
         AnvlMyWA+yrPdPOYVz3UjKq8c/VL6J8fgPXYpUN7Azcmp0JohVWw2i6nNhFyGlxiP/Uj
         4Z6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9nNN+PHGzHbaYgQC/ZKeqL/CYE4IeJIcWyQnEGuKDW4=;
        b=balysRzPBWrr5S4aOoPzqCyBNHYY/WoKv7sAs9vBgH6XScyyNeAPC+rwLdyFec6dkf
         eoUEj87iNBxm+0qc48ydYdQwtwE6Cpu7KP/uFABrqBiX+/L4oHqTUwt8bGMrS92OqYFD
         TCGutqQx0668cYvXyistLE1sRt8FY+qNLxlpap1eCKOYcdbEq4E9UtmadomrRj9ZRfBz
         6boDL/B33knmn3qu8Kf4y1Nua5mU/lWLTSJV1JGOy9WGyHt4bX+4MT6+YsaHflVxM361
         yxanF932NqFZBC9pQhyBhTzluJai6TVIFckltasyL0zzLvzB8ReVtfxSxl709y9OkrhC
         5Xcg==
X-Gm-Message-State: ACrzQf2ULeHdV6FHK2zlakpIpvmtNZymEjVXKJqgd9L5+AyACynGYI56
        WI2AnZq6wyPqbCrLg9GJKB2E+LaFY2Q=
X-Google-Smtp-Source: AMsMyM64uFp2366ZZwWpxI6ZJe08AWAtaCX6W2Gs/ylt/R06SXiz9M42rSIEot1LErOPJ30xRKfWkNDNwzM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:9565:0:b0:56c:8860:bce1 with SMTP id
 x5-20020aa79565000000b0056c8860bce1mr27058465pfq.31.1667429516183; Wed, 02
 Nov 2022 15:51:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:51:08 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-26-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 25/27] x86/pmu: Add pmu_caps flag to track
 if CPU is Intel (versus AMD)
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Like Xu <likexu@tencent.com>,
        Sandipan Das <sandipan.das@amd.com>
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

Add a flag to track whether the PMU is backed by an Intel CPU.  Future
support for AMD will sadly need to constantly check whether the PMU is
Intel or AMD, and invoking is_intel() every time is rather expensive due
to it requiring CPUID (VM-Exit) and a string comparison.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/pmu.c  | 5 +++++
 lib/x86/pmu.h  | 1 +
 x86/pmu_lbr.c  | 2 +-
 x86/pmu_pebs.c | 2 +-
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index ea4859df..837d2a6c 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -6,6 +6,11 @@ void pmu_init(void)
 {
 	struct cpuid cpuid_10 = cpuid(10);
 
+	pmu.is_intel = is_intel();
+
+	if (!pmu.is_intel)
+		return;
+
 	pmu.version = cpuid_10.a & 0xff;
 
 	if (pmu.version > 1) {
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index e2c0bdf4..460e2a19 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -48,6 +48,7 @@
 #define MAX_NUM_LBR_ENTRY	32
 
 struct pmu_caps {
+	bool is_intel;
 	u8 version;
 	u8 nr_fixed_counters;
 	u8 fixed_counter_width;
diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
index 36c9a8fa..40b63fa3 100644
--- a/x86/pmu_lbr.c
+++ b/x86/pmu_lbr.c
@@ -47,7 +47,7 @@ int main(int ac, char **av)
 
 	setup_vm();
 
-	if (!is_intel()) {
+	if (!pmu.is_intel) {
 		report_skip("PMU_LBR test is for intel CPU's only");
 		return report_summary();
 	}
diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
index 3b6bcb2c..894ae6c7 100644
--- a/x86/pmu_pebs.c
+++ b/x86/pmu_pebs.c
@@ -392,7 +392,7 @@ int main(int ac, char **av)
 	if (pmu_has_full_writes())
 		pmu_activate_full_writes();
 
-	if (!is_intel()) {
+	if (!pmu.is_intel) {
 		report_skip("PEBS requires Intel ICX or later, non-Intel detected");
 		return report_summary();
 	} else if (!pmu_has_pebs()) {
-- 
2.38.1.431.g37b22c650d-goog

