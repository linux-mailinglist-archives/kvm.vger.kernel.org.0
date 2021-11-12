Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D411444E433
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 10:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234880AbhKLJyr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 04:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbhKLJyp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 04:54:45 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512E7C061203;
        Fri, 12 Nov 2021 01:51:55 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso7168360pjb.2;
        Fri, 12 Nov 2021 01:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BYa2ixmP5+ZbmuACH1OAe6ovA/lf0vf497vEbvhmcEY=;
        b=PdBKieacJHToHzHK7icJJZhnZkjwlbPSgmcT645hfz5v7qQN/II6/VVEt6323ICAtD
         b8EgNtP+gXbnDcYNyFgVlAQT6behk9wCocia40FUGsqMqa6G4sNYEcFhB5CTdYDmGMfz
         56U7vNBHSdrtSD6dZVK30p78DVTvkudXhx26rdZNIBRtbecG40L6OOQPtEQScoBh4UEZ
         omy9DtzEv+i8rrWffoDJonkE/TWb1KkznlTQzgE2fwmPlXHp2E2ktIS2VFuhRNA3J/Vp
         6QQt9DDC6nYHlUskWLgxeRQGEhRU5RI15btLX5ysn5B1/bOxlxGlVngo9mJxuCGCM7AH
         DxtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BYa2ixmP5+ZbmuACH1OAe6ovA/lf0vf497vEbvhmcEY=;
        b=pOKnGQ9iXXcaS19Q2dJQbmzzRMOv1sFUWs7OBHZ3E+2rN8YyY7RnkNmUzXNqQddToA
         OjhhiLd5Dfun71B+0Liz2thtGeDzqIr3vZNnvbjMYI41SXdYFSv9Vjxp7dThQg4Yt1Jd
         R4F0cPiOHxZi3MhkgS7Dr72vZM332rNK5NOtaKrBOWfV4gRsBIZXgHtUTLUSscME+8cA
         wkgYG/jhqkkSRUGQQQNVyhI84MHThK38SoXR3AE72Fzka8ypXzK7rVFLvwe6wzaN8x/O
         ljzzamSH6CopkXz4TQXKOWmuFDr2HHelTH22TI5Dbgd+XDsE27p5fEyGTjF5/LduPfyw
         uklg==
X-Gm-Message-State: AOAM533NcBzXEkncHgqHPu/OFtJxduo3/byaaumKioz4amhRN39nZp84
        eLBZYY6XYae3Cd/l0bdHBLo=
X-Google-Smtp-Source: ABdhPJwlgQYkrEISGBdPdIkOGZDBgGjPUnUzhMsi904kCjEBoKyHn/vuXQ7RLF40JYu8de96WnEmfQ==
X-Received: by 2002:a17:90b:1b52:: with SMTP id nv18mr35042334pjb.43.1636710714931;
        Fri, 12 Nov 2021 01:51:54 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id f3sm5799403pfg.167.2021.11.12.01.51.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Nov 2021 01:51:54 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 2/7] KVM: x86/pmu: Fix available_event_types check for REF_CPU_CYCLES event
Date:   Fri, 12 Nov 2021 17:51:34 +0800
Message-Id: <20211112095139.21775-3-likexu@tencent.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211112095139.21775-1-likexu@tencent.com>
References: <20211112095139.21775-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

For the CPUID 0x0A.EBX bit vector, the [7] event should be the Intel
unrealized architectural performance events "Topdown Slots" instead
of the *kernel* generalized common hardware event "REF_CPU_CYCLES", so
we can skip the cpuid unavaliblity check in the intel_find_arch_event()
for the last REF_CPU_CYCLES event and update the confusing comment.

Fixes: 62079d8a43128 ("KVM: PMU: add proper support for fixed counter 2")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index b8e0d21b7c8a..bc6845265362 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -21,7 +21,6 @@
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
 
 static struct kvm_event_hw_type_mapping intel_arch_events[] = {
-	/* Index must match CPUID 0x0A.EBX bit vector */
 	[0] = { 0x3c, 0x00, PERF_COUNT_HW_CPU_CYCLES },
 	[1] = { 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },
 	[2] = { 0x3c, 0x01, PERF_COUNT_HW_BUS_CYCLES  },
@@ -29,6 +28,7 @@ static struct kvm_event_hw_type_mapping intel_arch_events[] = {
 	[4] = { 0x2e, 0x41, PERF_COUNT_HW_CACHE_MISSES },
 	[5] = { 0xc4, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
 	[6] = { 0xc5, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
+	/* The above index must match CPUID 0x0A.EBX bit vector */
 	[7] = { 0x00, 0x03, PERF_COUNT_HW_REF_CPU_CYCLES },
 };
 
@@ -75,9 +75,9 @@ static unsigned intel_find_arch_event(struct kvm_pmu *pmu,
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++)
-		if (intel_arch_events[i].eventsel == event_select
-		    && intel_arch_events[i].unit_mask == unit_mask
-		    && (pmu->available_event_types & (1 << i)))
+		if (intel_arch_events[i].eventsel == event_select &&
+		    intel_arch_events[i].unit_mask == unit_mask &&
+		    ((i > 6) || pmu->available_event_types & (1 << i)))
 			break;
 
 	if (i == ARRAY_SIZE(intel_arch_events))
-- 
2.33.0

