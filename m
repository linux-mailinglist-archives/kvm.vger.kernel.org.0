Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBBD4701B8
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 14:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241927AbhLJNjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 08:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241922AbhLJNjU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 08:39:20 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E66C061746;
        Fri, 10 Dec 2021 05:35:45 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id g19so8496405pfb.8;
        Fri, 10 Dec 2021 05:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hqu8vyG7yPFJXxjcuKhos5Y6YEOCCEkLSoLXjY4a+cQ=;
        b=LyXHBZTYsjVQhI5J0HhKoBxVmBfFzwPC+EKRjY9+fgMk8Mmt3ZBSZjFTLoOYrnjLAJ
         /9Avno48ZrpczROp3JrOhPb8/uwQBBtnCUwxH86gvE8B+c5GEnPb3lC4PnOEB9FPMC3g
         ihbreMU8WWsw1Dw9kmMnL3P1OpW700VupY2mWVUcQIZOeLyl9aZeap8xl/1qzhWFVpAN
         zCsHGzwLp33bM+7gy1y2/8onopBK29PHExC9uf5YIFGZL6ViWPOtAOYnLWWiDi62XHzk
         rJANGPxVmR9LxwC3lCJAJyeOtu7qYXMUwxMfcyvCE1wHdtNCmUVgPUM4e3uX+4kYqyTw
         UIOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hqu8vyG7yPFJXxjcuKhos5Y6YEOCCEkLSoLXjY4a+cQ=;
        b=iBUXVS2d8CYilS6uEx0ygKi4RgcZUWkpakFV/qQw5DGWxdEzvZjNBhHl8h+T5ws/Vj
         zLupqcLSAXYL8mkqeX8Zl0omwrkiaLnuAJQr4S2dN013r1xwXT0rS1BuVNSEJx3wc9RK
         S40VSt+/8BfKoV/X/TXAC8YeDOW9W8drI0C0J56oY6Py2FZxg8Wrxy1uIxdZfAxrfj5o
         P/RQ3b1C3Ml3kJhNDdH16f3ZBrgkdofZATI8PBkbJN547tbX0KJGFqBm93Yh/iMb7djJ
         8SR/mKBWN4sPv3huNWSHYE1lDqVoaehnopn7MxYWjH6qddsa5obaRsCqOh0vuNNGn1fr
         gx6w==
X-Gm-Message-State: AOAM532MiBJwCoeuOOzsxmY4rddVxfcQ2KNnEt09j4Pu6nmpoLjppNe4
        FKiFmtg6XWSe2sU+mP1tviM=
X-Google-Smtp-Source: ABdhPJxnUGTwAeD8WVNtwmESnGfcpZNRL8hS8jsf+LHon7RW6m3kEty4HD81WlxEn+vPTvv/tK6T0g==
X-Received: by 2002:a63:461c:: with SMTP id t28mr26319210pga.171.1639143345021;
        Fri, 10 Dec 2021 05:35:45 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t4sm3596068pfj.168.2021.12.10.05.35.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:35:44 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Like Xu <likexu@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v11 01/17] perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server
Date:   Fri, 10 Dec 2021 21:35:09 +0800
Message-Id: <20211210133525.46465-2-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210133525.46465-1-likexu@tencent.com>
References: <20211210133525.46465-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

From: Like Xu <like.xu@linux.intel.com>

The new hardware facility supporting guest PEBS is only available on
Intel Ice Lake Server platforms for now. KVM will check this field
through perf_get_x86_pmu_capability() instead of hard coding the cpu
models in the KVM code. If it is supported, the guest PEBS capability
will be exposed to the guest.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/events/core.c            | 1 +
 arch/x86/events/intel/core.c      | 1 +
 arch/x86/events/perf_event.h      | 3 ++-
 arch/x86/include/asm/perf_event.h | 1 +
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 38b2c779146f..03133e96ddb0 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2993,5 +2993,6 @@ void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 	cap->bit_width_fixed	= x86_pmu.cntval_bits;
 	cap->events_mask	= (unsigned int)x86_pmu.events_maskl;
 	cap->events_mask_len	= x86_pmu.events_mask_len;
+	cap->pebs_vmx		= x86_pmu.pebs_vmx;
 }
 EXPORT_SYMBOL_GPL(perf_get_x86_pmu_capability);
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index ec6444f2c9dc..869684ed55b1 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6103,6 +6103,7 @@ __init int intel_pmu_init(void)
 
 	case INTEL_FAM6_ICELAKE_X:
 	case INTEL_FAM6_ICELAKE_D:
+		x86_pmu.pebs_vmx = 1;
 		pmem = true;
 		fallthrough;
 	case INTEL_FAM6_ICELAKE_L:
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 5480db242083..fdda099867c2 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -814,7 +814,8 @@ struct x86_pmu {
 			pebs_prec_dist		:1,
 			pebs_no_tlb		:1,
 			pebs_no_isolation	:1,
-			pebs_block		:1;
+			pebs_block		:1,
+			pebs_vmx		:1;
 	int		pebs_record_size;
 	int		pebs_buffer_size;
 	int		max_pebs_events;
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8fc1b5003713..42d7bcf1a896 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -192,6 +192,7 @@ struct x86_pmu_capability {
 	int		bit_width_fixed;
 	unsigned int	events_mask;
 	int		events_mask_len;
+	unsigned int	pebs_vmx	:1;
 };
 
 /*
-- 
2.33.1

