Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7324952BC07
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 16:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237978AbiERN2B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 09:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237927AbiERNZq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 09:25:46 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8342CE1C;
        Wed, 18 May 2022 06:25:43 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id i8so1735503plr.13;
        Wed, 18 May 2022 06:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AfO0NLcJeQALgqj1J+QSjTgv2c+H8QHy+g5kdNkMJ7M=;
        b=IiQfUJbnQVhSdENbcqcJSJXCmhgKbUEjfrBb6BaRYmF0mIK2OjAacKriEIAiBbdqw5
         XbEjTNJvSLMygitmTFnJhNWTVbU3h5/49xhgrKfolHmAJs/UfD3GwmfgFiFM1hHCir2B
         /IMsh8APrpS8EeOoIYwsIogklrScL94RvFn0SHMYLNGmzAK5UgrKuKCnMIDvFl/am6MZ
         oeRjnu0KYrNxbCXpZH4IR/KH0IFXkSZQoj8FA2+BA8hgHObOBZAG6AFGeLEuZIUQ+1ft
         fBWc2tONJ040Lh3RwSg+ELoC0smRwAzepaxhpE5SAJAXHSHYadlaIwFliodn6s0Te3Ye
         YfmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AfO0NLcJeQALgqj1J+QSjTgv2c+H8QHy+g5kdNkMJ7M=;
        b=LxKYzKdcHP/iWiTr3smoJGb5n5y97riJYuU6jfIQaTQZ3fdeeYHPEXiEL8+0i4MbYu
         FjdE/LtCX1Yr9e8krhTLKWP2yvvgV6Zzn0vzbPR3EdLM/S+5ksDDez9Kg1CoKfH0ys32
         gQsZzw8l8dB9wRkNZGfuTd1SXSqoUjDJduOV/1/m63+FD9xSj45YMk+xVMUUH1yEprMA
         wWNOnIBFq0fAUZKhn5+FgnsJlhCKQqc6V2/IvSKg4qpw8ixiTMVoiCH81Ahq/7aPVelz
         3kKatTOznnaooPMX4BwDxcTCYf9JzyPuvbxYHOLW5ObYaYg6HBtruLlz7ud8ZvCW4I2x
         cr2A==
X-Gm-Message-State: AOAM533L5Mf+oRS+wAd73GGhWWOnTrTCI2yW6OeV6wbfBKdMZvy9b5ts
        M53OE1R338rRO2aeCNKZm6g=
X-Google-Smtp-Source: ABdhPJyeSfY3EL0jyog7JKG5CzqT4tKWx4OegLVs7LzTRGzETI0wQHoYx9HNB6qV1Qc8HYrwrUdoAw==
X-Received: by 2002:a17:902:b418:b0:15f:713:c914 with SMTP id x24-20020a170902b41800b0015f0713c914mr27608231plr.171.1652880342910;
        Wed, 18 May 2022 06:25:42 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id s13-20020a17090302cd00b0015e8d4eb244sm1625549plk.142.2022.05.18.06.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 06:25:42 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v3 09/11] perf: x86/core: Add interface to query perfmon_event_map[] directly
Date:   Wed, 18 May 2022 21:25:10 +0800
Message-Id: <20220518132512.37864-10-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518132512.37864-1-likexu@tencent.com>
References: <20220518132512.37864-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/events/core.c            | 11 +++++++++++
 arch/x86/include/asm/perf_event.h |  6 ++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 7f1d10dbabc0..99cf67d63cf3 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2997,3 +2997,14 @@ void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 	cap->pebs_ept		= x86_pmu.pebs_ept;
 }
 EXPORT_SYMBOL_GPL(perf_get_x86_pmu_capability);
+
+u64 perf_get_hw_event_config(int hw_event)
+{
+	int max = x86_pmu.max_events;
+
+	if (hw_event < max)
+		return x86_pmu.event_map(array_index_nospec(hw_event, max));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(perf_get_hw_event_config);
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index dc295b8c8def..396f0ce7a0f4 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -478,6 +478,7 @@ struct x86_pmu_lbr {
 };
 
 extern void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap);
+extern u64 perf_get_hw_event_config(int hw_event);
 extern void perf_check_microcode(void);
 extern void perf_clear_dirty_counters(void);
 extern int x86_perf_rdpmc_index(struct perf_event *event);
@@ -487,6 +488,11 @@ static inline void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 	memset(cap, 0, sizeof(*cap));
 }
 
+static inline u64 perf_get_hw_event_config(int hw_event)
+{
+	return 0;
+}
+
 static inline void perf_events_lapic_init(void)	{ }
 static inline void perf_check_microcode(void) { }
 #endif
-- 
2.36.1

