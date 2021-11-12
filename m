Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660E944E43C
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 10:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbhKLJzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 04:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234914AbhKLJy4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 04:54:56 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8CCC061767;
        Fri, 12 Nov 2021 01:52:06 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id t5-20020a17090a4e4500b001a0a284fcc2so6853998pjl.2;
        Fri, 12 Nov 2021 01:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/GEAKHOTJvbS3IgOKWf3Q6MVeHzRCDLEfVOLNTMcwPg=;
        b=FJFqrTnwPEuLtvQGIWc1XYBDmelqiGH2Mx60N5A6KyhcghAo9lOw+HSm04iREm4lwP
         Jv5+l5Nf6U/ifpewJ5N+XGkUNuegN0qKpNocKs4eNSFmJTXAfWMLaB+BupalCrH/e0Dg
         C7zHSJfwIsoICsc24dbakO1IE02D9VDI0SupaqRLBFphsIx7kQWSKEdAFrfrSz8MZPEu
         f6CHyPxwtlfs4X4tqsHVLOcEqGo8cSU/YIb3X9eqtjkn0hiC6wm/8mECRDM8hLm8RmcN
         /vtB552ru+41YMQhg3+ldMnE+XA2ydotW8xWWTWw5f5QUNjjZSIY1jD1Eji3rx26FHdb
         znkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/GEAKHOTJvbS3IgOKWf3Q6MVeHzRCDLEfVOLNTMcwPg=;
        b=VdBKSsgn9rByRind745dszysAg20yROvldYxeObPpdsPtPwbuLK29RkBZ/c0yoDCvU
         DA067iJdt7RNcGT6Vj8oHVCremxJFs0ZL6kvWdOGgFIOwlo17NErVo923tIdqt9tugil
         hqFwasa4SqEGcAePfMvQJfIU/9hBqVTeY1gtvZXbKpn4tijLBd0nJx+yUEgZ5J8GyCOy
         yy3oLae3nb7dS9pgz5MSbVs4SNrK8HAXKSiEwJ0S6OHveF9626c4wUJT4gWmTC98mQOU
         NCyHIB6exQrk98rCIsIieMxcU8cGEkNYh5U5NjdsYj0GP05+VZomSc8bbmx3x9hq8Ds8
         U4pg==
X-Gm-Message-State: AOAM5328vyL+ZyfYZ79fWNacnJFPoMgpVAV7QjJO8uL+4ItTX5MlM/21
        PKzVewzEzroDgUK5fNzc8ps=
X-Google-Smtp-Source: ABdhPJzE7V0Wq/g/ND3xAvRBQ3tIRjdvBkwQ43iKJ9Dwq2bQ/lzMKnzidVUmmfSLQwEMkOiEVQfwJQ==
X-Received: by 2002:a17:90a:9f93:: with SMTP id o19mr34183778pjp.136.1636710726076;
        Fri, 12 Nov 2021 01:52:06 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id f3sm5799403pfg.167.2021.11.12.01.52.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Nov 2021 01:52:05 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6/7] perf: x86/core: Add interface to query perfmon_event_map[] directly
Date:   Fri, 12 Nov 2021 17:51:38 +0800
Message-Id: <20211112095139.21775-7-likexu@tencent.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211112095139.21775-1-likexu@tencent.com>
References: <20211112095139.21775-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Currently, we have [intel|knc|p4|p6]_perfmon_event_map on the Intel
platforms and amd_[f17h]_perfmon_event_map on the AMD platforms.

Early clumsy KVM code or other potential perf_event users may have
hard-coded these perfmon_maps (e.g., arch/x86/kvm/svm/pmu.c), so
it would not make sense to program a common hardware event based
on the generic "enum perf_hw_id" once the two tables do not match.

Let's provide an interface for callers outside the perf subsystem to get
the counter config based on the perfmon_event_map currently in use,
and it also helps to save bytes.

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/events/core.c            | 9 +++++++++
 arch/x86/include/asm/perf_event.h | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 2a57dbed4894..dc88d39cec1b 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -691,6 +691,15 @@ void x86_pmu_disable_all(void)
 	}
 }
 
+u64 perf_get_hw_event_config(int perf_hw_id)
+{
+	if (perf_hw_id < x86_pmu.max_events)
+		return x86_pmu.event_map(perf_hw_id);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(perf_get_hw_event_config);
+
 struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
 {
 	return static_call(x86_pmu_guest_get_msrs)(nr);
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8fc1b5003713..11a93cb1198b 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -492,9 +492,14 @@ static inline void perf_check_microcode(void) { }
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
 extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
+extern u64 perf_get_hw_event_config(int perf_hw_id);
 extern int x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
 #else
 struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
+u64 perf_get_hw_event_config(int perf_hw_id);
+{
+	return 0;
+}
 static inline int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
 {
 	return -1;
-- 
2.33.0

