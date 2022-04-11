Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB41A4FB94A
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 12:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345263AbiDKKWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 06:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345259AbiDKKWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 06:22:09 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765533F337;
        Mon, 11 Apr 2022 03:19:56 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id q3so2201799plg.3;
        Mon, 11 Apr 2022 03:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cH6kURbgPdZ+4zTKmVfEZoCeDgIOOogJ7RKUifDA5nc=;
        b=pf+0jOEB+qs5mwVKQeT6IjV+ExaG1Wd8oW6gIWTKbMzgj6HxW7riq/XZvzyI0VpmBM
         UH1EFrifC1jGNkpCbpEmCRrQyD1cLVmJjo/+yBFizRTvCwAi0de+D8AYE9V+wPmd0gfi
         UeOUyfwgAJOkMTe8wu08WDbcIP2wtUjxK1PTjjftYes3UEBYNwR1lGQxrmcXpFJRABbs
         fk1iYve0CgBYB4S23KjnJFQElTqhgFtO+z0osLQn9dhUn0Zgbuk9hetfKlkV5rJh6mdK
         irMazpy0IivviVcSyA7GVAeGJNtiE8ECjR374BF9TG44pieNyXWqoKk34NpARejCYEiC
         lXKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cH6kURbgPdZ+4zTKmVfEZoCeDgIOOogJ7RKUifDA5nc=;
        b=4uRYKnKIYk5d4s11tNQehO6M8OKBiQYtELV/Qj6yn2W9r+zu9QF/4gzAmA/Jg6f7Ss
         dXkN/fxDZP+qFCtUV3Lp/A45RN1rjG1eRcoN/XQXs78RmXyeHAPI6xzxVRuQbCreLnMx
         swKyD6vWWmfVxGy745UgabapHTaYXmyNE+JZYQwuVc4J+k1y963lip9zzWOiL696wPFF
         sOQstFAQOYFQUFkQa/dKYmr5ljBBG0IHaAk8aux6aYtTfsaHB9tR2/jl+CNLZGUZpTim
         oBA3Z4Vw6wgqhT0x39jBvlcyP46kAFKHClpjyrCcGgRgyMgpPbdV0d0XzMyZFUNizvc7
         TsWA==
X-Gm-Message-State: AOAM532nbsXTrS6PznpsWo8KdRphyj2iJHB9RVHIiRV1XENo1QnuSyx6
        IK/+3u58BpnbyGNjbbS6sB0=
X-Google-Smtp-Source: ABdhPJyXVI1kpDPLLq2HhYkCleWky9NlWqiKLBvNR/6mgh7FaJXyBydTlx+SGZ/1HDRyYrdmwwKHsA==
X-Received: by 2002:a17:90b:1b4d:b0:1c6:bd9e:a63d with SMTP id nv13-20020a17090b1b4d00b001c6bd9ea63dmr35857696pjb.56.1649672395794;
        Mon, 11 Apr 2022 03:19:55 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a00230a00b004faa0f67c3esm34012280pfh.23.2022.04.11.03.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 03:19:55 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v12 01/17] perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server
Date:   Mon, 11 Apr 2022 18:19:30 +0800
Message-Id: <20220411101946.20262-2-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411101946.20262-1-likexu@tencent.com>
References: <20220411101946.20262-1-likexu@tencent.com>
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

Cc: linux-perf-users@vger.kernel.org
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/events/core.c            | 1 +
 arch/x86/events/intel/core.c      | 1 +
 arch/x86/events/perf_event.h      | 3 ++-
 arch/x86/include/asm/perf_event.h | 1 +
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index eef816fc216d..adb6d9d3cd4d 100644
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
index e88791b420ee..0988ff3e18fb 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6134,6 +6134,7 @@ __init int intel_pmu_init(void)
 
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
index 58d9e4b1fa0a..44c9a4c20c06 100644
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

