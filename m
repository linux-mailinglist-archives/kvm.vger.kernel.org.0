Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 593E34CA2FB
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 12:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238306AbiCBLPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 06:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241324AbiCBLOt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 06:14:49 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6756E60AA8;
        Wed,  2 Mar 2022 03:14:05 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id p17so1262004plo.9;
        Wed, 02 Mar 2022 03:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=epyCD5JOodngCk58+WB9SJFl/4h2CqzFfv4VxTsof4Q=;
        b=Id+ayrUBZIZvkIK2+whn67yrEM7YOnZ2qplr4gf5gkGDWxJc5kVFkg6dqPvObxfEgu
         UWEu2a3+nsUMg5kSsYjkNblt823TMb2lDglLmiBljRvHSlQtUqY+IgHZho6s4TeJD0gs
         apFyrMdYsujCkoE0nu7R5ag0wYkfuAGlrqYeJizlDx08A8Z9fTS9gt5qpsRVSi2GRqSs
         OsxeHeCzbcsESoy+jjkajBMj/W3MOs5S0tJ+s+fl5+Q9NTC7RLvCLt6r/fJSzwLzLtG/
         PiLckC8gSNnZvG42LPC1cRsulGwfP0MMpHc+t4QEWZp8hyD6hEd4M9GkvXmG/e1s5Wax
         viIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=epyCD5JOodngCk58+WB9SJFl/4h2CqzFfv4VxTsof4Q=;
        b=UVCxhvn61u839kgq5FDJ5wOgICaeO29bOOOjHmnA30XFMnJnEaS1gt0lwlu+YGbFBv
         hvvg46lINkkqJopMsJDE7UEZLAI6Qlr+LHjMBuAYeMjrPqkFdQCby91H4Se3/EfKR7zo
         +gvFYJ942kghsI/7ZG1fbkBIb6IxwplLsEQRaL68ir/kB28KmNIR6OFF4D1ZCBmpyzvD
         22Rf5alKMvCydmoL892hk7HWbheLsj4fdsAgtzkBmKlzWXHyX1DECn+qvbGZRES8Rs7b
         yb0NDO5TyId61UuGTLeX4N3MkxUx4MqBSbGEgAIPEnV+gFuHNfsgKuiaa1GCZHJ2pltf
         nN4A==
X-Gm-Message-State: AOAM531/EAkARdjVCesj6cPdW9Ur0sUeax4r2IuySaYizHXHIwIJsWgD
        8hEgwwrGsQKpqzCIVGCP+UQ=
X-Google-Smtp-Source: ABdhPJxl0CXU3s/Y0tgUbnmO5/ega6Rd6cq8U0g4bQ4kd1qfnYOWdFEyAXaz0HX94G0LDbdi+17w7w==
X-Received: by 2002:a17:90a:2e0e:b0:1bc:dbe:2d04 with SMTP id q14-20020a17090a2e0e00b001bc0dbe2d04mr26674143pjd.74.1646219644770;
        Wed, 02 Mar 2022 03:14:04 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v22-20020a17090ad59600b001b7deb42251sm4681847pju.15.2022.03.02.03.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 03:14:04 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v2 08/12] perf: x86/core: Add interface to query perfmon_event_map[] directly
Date:   Wed,  2 Mar 2022 19:13:30 +0800
Message-Id: <20220302111334.12689-9-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220302111334.12689-1-likexu@tencent.com>
References: <20220302111334.12689-1-likexu@tencent.com>
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
---
 arch/x86/events/core.c            | 11 +++++++++++
 arch/x86/include/asm/perf_event.h |  6 ++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index e686c5e0537b..e760a1348c62 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2996,3 +2996,14 @@ void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 	cap->events_mask_len	= x86_pmu.events_mask_len;
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
index 8fc1b5003713..822927045406 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -477,6 +477,7 @@ struct x86_pmu_lbr {
 };
 
 extern void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap);
+extern u64 perf_get_hw_event_config(int hw_event);
 extern void perf_check_microcode(void);
 extern void perf_clear_dirty_counters(void);
 extern int x86_perf_rdpmc_index(struct perf_event *event);
@@ -486,6 +487,11 @@ static inline void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
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
2.35.1

