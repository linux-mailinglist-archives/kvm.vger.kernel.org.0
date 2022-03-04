Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28BE4CD0A3
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 10:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbiCDJFn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 04:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235610AbiCDJFe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 04:05:34 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8AC18BA7B;
        Fri,  4 Mar 2022 01:04:43 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id w37so6989188pga.7;
        Fri, 04 Mar 2022 01:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gq1o7WGIH3JdN7S1qyzepXgwx+3m0mMf2+t1e4tkj4o=;
        b=qFyhezXuL3aAkC6+HZ65TFuo0I9wNkgP1A0vGP1lFEh/itroWsAqUHmQDEA/vgv7zQ
         9cOjIwFbVFlYwt+4y/Tf79QyktCDuuPB9Mmx5xhoroMLFNzhLf+MekbKJYAqYgbpXcgv
         idRKAACE7+sL/8X9o3DzlYfYeab9ujEBKUqH1Mk3Acmtk4XJoenr6/CrzpM2w2Euj8Oj
         yCVNVRTg3HVhrKHWQ69u9Uki/BogZHjB5mc5nmZCGHwU3KqIi7FoerXETiApvDlcTzEk
         OnAHdT5B3ihACxC0B/gWjHqubC4GoRcs/hgs954ggWa2dI9C5lVGjbftEnT0nYgIO+A6
         aCbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gq1o7WGIH3JdN7S1qyzepXgwx+3m0mMf2+t1e4tkj4o=;
        b=LfeUV8nWhAK5TifaIsiSFG8IbAzOODZEN6n6K8wBfKct8snCllFSN5xczCH6MBLz6A
         LyLo7Twqu92TzEB3tJf5dM1h4DhFGeq2vc1LtDMiz+bE078dZDC/T6OZNtznFF6AfH7V
         QpDCaqr0OZwd41tnfQa2mVahNbtRQo8kXQccC2t18v+ZyZEWSYBDd+mWREmYp8FwcueR
         lzbt2PYGw8BXn428ANHhBNxONFgjy5yfR7HOkS9UcMsooTARuTQ/mPcZ+CrTvuUKmU0g
         oOk3R2fSyKl/3cQrqXvKBUksdj3JtNT+paHImyaQvYMgQ4d38oOenF5cbMdfGyoclhjN
         rjcg==
X-Gm-Message-State: AOAM5305DyefFr8qzx8OozEzYfwTI18Xz285AhaW+Z4UaVUZM9qziv5a
        Mb871XEQ5PqpAzbV3KOz6N9iZcWKVKW1XuaT
X-Google-Smtp-Source: ABdhPJw6ZLXnkkMDyzLGKgXxpfS6onc3H+jrpIJmEdfpDhyiK1g8UCxoXk5Bzkg+meeppD1ugWNwBQ==
X-Received: by 2002:a63:8ac8:0:b0:34e:403c:4349 with SMTP id y191-20020a638ac8000000b0034e403c4349mr34100672pgd.145.1646384683018;
        Fri, 04 Mar 2022 01:04:43 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j2-20020a655582000000b00372b2b5467asm4192968pgs.10.2022.03.04.01.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 01:04:42 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 01/17] perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server
Date:   Fri,  4 Mar 2022 17:04:11 +0800
Message-Id: <20220304090427.90888-2-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304090427.90888-1-likexu@tencent.com>
References: <20220304090427.90888-1-likexu@tencent.com>
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

Add support for EPT-Friendly PEBS, a new CPU feature that enlightens PEBS
to translate guest linear address through EPT, and facilitates handling
VM-Exits that occur when accessing PEBS records.  More information can
be found in the December 2021 release of Intel's SDM, Volume 3,
18.9.5 "EPT-Friendly PEBS". This new hardware facility makes sure the
guest PEBS records will not be lost, which is available on Intel Ice Lake
Server platforms (and later).

KVM will check this field through perf_get_x86_pmu_capability() instead
of hard coding the CPU models in the KVM code. If it is supported, the
guest PEBS capability will be exposed to the guest. Guest PEBS can be
enabled when and only when "EPT-Friendly PEBS" is supported and
EPT is enabled.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/events/core.c            | 1 +
 arch/x86/events/intel/core.c      | 1 +
 arch/x86/events/perf_event.h      | 3 ++-
 arch/x86/include/asm/perf_event.h | 1 +
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index e686c5e0537b..7e3d0a019444 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2994,5 +2994,6 @@ void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 	cap->bit_width_fixed	= x86_pmu.cntval_bits;
 	cap->events_mask	= (unsigned int)x86_pmu.events_maskl;
 	cap->events_mask_len	= x86_pmu.events_mask_len;
+	cap->pebs_ept		= x86_pmu.pebs_ept;
 }
 EXPORT_SYMBOL_GPL(perf_get_x86_pmu_capability);
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index a3c7ca876aeb..7723fa6ed65e 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6113,6 +6113,7 @@ __init int intel_pmu_init(void)
 
 	case INTEL_FAM6_ICELAKE_X:
 	case INTEL_FAM6_ICELAKE_D:
+		x86_pmu.pebs_ept = 1;
 		pmem = true;
 		fallthrough;
 	case INTEL_FAM6_ICELAKE_L:
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 150261d929b9..0998742760c8 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -815,7 +815,8 @@ struct x86_pmu {
 			pebs_prec_dist		:1,
 			pebs_no_tlb		:1,
 			pebs_no_isolation	:1,
-			pebs_block		:1;
+			pebs_block		:1,
+			pebs_ept		:1;
 	int		pebs_record_size;
 	int		pebs_buffer_size;
 	int		max_pebs_events;
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8fc1b5003713..2c9dce37d095 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -192,6 +192,7 @@ struct x86_pmu_capability {
 	int		bit_width_fixed;
 	unsigned int	events_mask;
 	int		events_mask_len;
+	unsigned int	pebs_ept	:1;
 };
 
 /*
-- 
2.35.1

