Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77DF34BE982
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 19:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356951AbiBULxz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 06:53:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356953AbiBULxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 06:53:14 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2551FA6C;
        Mon, 21 Feb 2022 03:52:37 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id om7so14945238pjb.5;
        Mon, 21 Feb 2022 03:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RHHO1lCTgmUCqGpOMS2hTgwPWrCn1+5dYE38ZQv5fAw=;
        b=FHfU/E2JV17g5GrMCniEYdI+q+m5SY8zzNNLsOdlQqAsNjwezFhFxJ2E8bvPHMdoma
         c7z+zDnUcRLUAnaRfjnRHXaHnvdgpVzr036+ahqfjdFeaUshRzfl1TBn51GIEkMatx+q
         iGuqqgsfvk0dOyMx76qO+gS/NFY7ck+8SFtEGh/u5r1mOqW11k57WoONJWwnjwcjyO/O
         OEDMSnGzoEGCbc6XYiTLh8KKItW6PANzxBDmK3eYc/HbrnQ+m54vXSTpSHDTngiIpArC
         uQwHB20tT30ajLi94283ML4MHb/MsaL/hippmaunhvL72GjfmJdqVhX43uCkEHIfFUyI
         7fQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RHHO1lCTgmUCqGpOMS2hTgwPWrCn1+5dYE38ZQv5fAw=;
        b=XEpOjXvS0XSdTaVr5LRyBevi0AzXa/812hnMYSUI8xNSvBKNra/972EkIryqj6LtpA
         1dVu1mCv5h9ebcZ59gPbIkGkDzzdKZTzS2u5dgmzabUa3RLuidGLgRTPfeJBY/jzKKjV
         xAGKHI0pqXWYrJZBF4gi8bBHeoIYhMDKe3wyplj4SriDw1PWQFfsAZrP3Ne6SWZq3uVq
         E01YV9qPU96rWvq0e3qECFBsrquq5QFOhGZh0sfVnm07LJ9Z9//EIMBTPJpc1jL5f2ty
         WLKn6ToZNK9pKN/XD7dLMm/GlDjgvqfE9hyRol+2miAaQPTTYxbVaWpfyGaIq0yud7FJ
         smsA==
X-Gm-Message-State: AOAM532jfWgxDYXgUTt0aoBQqyk4AfsZfKObzo4X+FzC3/anLEx9zGMv
        UaRsCxgiL2NC77a0q3iuitk=
X-Google-Smtp-Source: ABdhPJzJdZysFmnfkECExgsUIz53tG43FuUEq97WWce3qS0nCaMg1G92mUQ0TZiiKXa0nDWWwEjEZw==
X-Received: by 2002:a17:902:da88:b0:14b:550b:4caa with SMTP id j8-20020a170902da8800b0014b550b4caamr18214777plx.111.1645444356529;
        Mon, 21 Feb 2022 03:52:36 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z14sm13055011pfe.30.2022.02.21.03.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 03:52:36 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 08/11] perf: x86/core: Add interface to query perfmon_event_map[] directly
Date:   Mon, 21 Feb 2022 19:51:58 +0800
Message-Id: <20220221115201.22208-9-likexu@tencent.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220221115201.22208-1-likexu@tencent.com>
References: <20220221115201.22208-1-likexu@tencent.com>
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

Just provide an interface for callers outside the perf subsystem to get
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
2.35.0

