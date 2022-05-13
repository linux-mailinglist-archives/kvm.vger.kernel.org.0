Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182A7525F53
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 12:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350241AbiEMJ2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 05:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379089AbiEMJ0V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 05:26:21 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3D415721;
        Fri, 13 May 2022 02:26:16 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id q4so7379103plr.11;
        Fri, 13 May 2022 02:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4Fl9YRg3lybj0A+SLC/IEMp8cNpVOztdbgPj51TjJ/Q=;
        b=XWsCnrQq+wuM/Qpf4MrQ49slj4Eh/XVkfg106+runlYDDvdUOq9/6T+3Gf6w1v+Vr9
         D6wT5wYqzsvJUvvieqzuvt8Tenuhr483rOXsYHlZS33c6+V9Z2JrLonax4vay4bmY6MS
         dkjohi0fqLRJPJBVlCiEzmKLtxHZ+5aHNAaBzrvxnBWnucyxZDL42JvzIp34GMps7iYh
         vUUg97R+awEhMLhDRtwOh4O9ZiFtO/m347mqyE2Q9gLFOgoVfXMvU04o5CEkLyyl0fM4
         R0gMOk3UnfaS6nrn6MC/j1HxC46ePPFgfKdX+ZjD/Ii7T4YfKg515EbzkKobklEHXrPi
         3puw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4Fl9YRg3lybj0A+SLC/IEMp8cNpVOztdbgPj51TjJ/Q=;
        b=kFZbDT5BvBzSVmnejb8DBhpwHqMuFWejecabXbnLf9TW1pxf2W2zXSdxbZSpFnbvem
         XzMSMvC/iPZIq1OT7VD1JHA3vWcqVoqLdSkb/jSozm0yVV6pnQ5+YW2vhhxJ6XLbqEQ/
         PHINHosHK4SPl/r+KIKHUXt0waQgMXV+t1IkC8mxBeQzHlam4fQQnC8XdQs7CgHL/A/J
         bhxcaMbhx5zhIX5+/6Yr5TcvOQiFAnBkz793tIYW21uJbQ/a9vWT0N5HkrA/Fu8cDWIT
         fv15JZLw2gdRic8rBiVqwAdo+1Bj2hX0rxG9hHkn9rgAPUZlo7bDm37LRhL+/TGxyffD
         VStA==
X-Gm-Message-State: AOAM530YUVI9TFJIzhUP++zDGvrSkmJkrOrBKJ6If3KL0AZHkpYL99jE
        d3NMhcmNhoftJ/EMb24VoDg=
X-Google-Smtp-Source: ABdhPJwaYjXq+z83/qwDwoXkJhd6TjzfMoI4iuLA8jsCmvicv/kOa2lB82NC0kJ6OvIBM6ju8sz43A==
X-Received: by 2002:a17:902:ea0e:b0:15e:c0e4:cf15 with SMTP id s14-20020a170902ea0e00b0015ec0e4cf15mr4034800plg.63.1652433976446;
        Fri, 13 May 2022 02:26:16 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.22])
        by smtp.gmail.com with ESMTPSA id m13-20020a170902f64d00b0015e8d4eb299sm1331558plg.227.2022.05.13.02.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 02:26:16 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     pbonzini@redhat.com
Cc:     jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com
Subject: [PATCH v13 09/17] KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR counter
Date:   Fri, 13 May 2022 17:26:11 +0800
Message-Id: <20220513092611.13291-1-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220411101946.20262-10-likexu@tencent.com>
References: <20220411101946.20262-10-likexu@tencent.com>
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

The PEBS-PDIR facility on Ice Lake server is supported on IA31_FIXED0 only.
If the guest configures counter 32 and PEBS is enabled, the PEBS-PDIR
facility is supposed to be used, in which case KVM adjusts attr.precise_ip
to 3 and request host perf to assign the exactly requested counter or fail.

The CPU model check is also required since some platforms may place the
PEBS-PDIR facility in another counter index.

Signed-off-by: Like Xu <likexu@tencent.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
v12 -> v13 Changelog:
- Move vmx_icl_pebs_cpu[] from pmu.h to pmu.c;
- Drop unrelated change about arch/x86/events/intel/core.c;

 arch/x86/kvm/pmu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 36487088f72c..0b8fc86839ba 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -16,6 +16,7 @@
 #include <linux/bsearch.h>
 #include <linux/sort.h>
 #include <asm/perf_event.h>
+#include <asm/cpu_device_id.h>
 #include "x86.h"
 #include "cpuid.h"
 #include "lapic.h"
@@ -24,6 +25,12 @@
 /* This is enough to filter the vast majority of currently defined events. */
 #define KVM_PMU_EVENT_FILTER_MAX_EVENTS 300
 
+static const struct x86_cpu_id vmx_icl_pebs_cpu[] = {
+	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, NULL),
+	{}
+};
+
 /* NOTE:
  * - Each perf counter is defined as "struct kvm_pmc";
  * - There are two types of perf counters: general purpose (gp) and fixed.
@@ -175,6 +182,8 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		 * could possibly care here is unsupported and needs changes.
 		 */
 		attr.precise_ip = 1;
+		if (x86_match_cpu(vmx_icl_pebs_cpu) && pmc->idx == 32)
+			attr.precise_ip = 3;
 	}
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
-- 
2.36.1

