Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F99485F27
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 04:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiAFDV3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 22:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiAFDV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 22:21:28 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20953C061245;
        Wed,  5 Jan 2022 19:21:28 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id q14so1572542plx.4;
        Wed, 05 Jan 2022 19:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tEPOl6WBbxtpmGNTfqniAvqTV4WFMzRNYr4mY/ilgcY=;
        b=o/J3+ItZGt862U17CUDwLME3HfmwNUJ9LtdM++CsDtVrKXE1rhHzg3y4rwqNQiZUi3
         OMHP7dzsbfJaWsKKFA6cTBgp2pHIf1PAhHaX+2SYHZvydEwUSI2TAbek+In6FruFPPiB
         YJriM7UTD5iGGHIcAuo3I/IyPtZArrKe7ZzQfKj/p/NZFFHm1O1WXszVmJOm+KhdbMdx
         BKvHJNLjkCakykmE6fHG6BYe9hw8IY0ndwUWEpS5gaNAchNvfpRBzkmX8YZ4J+fHMyyp
         hB5REgNkqt6H4RVTMcybfOols7slgmTp0j8FVSbtF/PXQzfDB5+7CeNsmueRxWqpUQMr
         x3pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tEPOl6WBbxtpmGNTfqniAvqTV4WFMzRNYr4mY/ilgcY=;
        b=LY0q6o8U1cQhcEIltXc7FiTA1u0FGmItL45ukcCq33HeneQAqx2jvL72guMJcj8BpP
         V6cdx43m9qT0BkrQkSQcwL6Z/h7Ugtja1fqHLpu8PcYiRLeYh7caraa945QJwd8JS9b5
         v36OPDtPR+Jy+bb+14ozYhdgvqOBE2NiUaMCLrYZ14jz20NfrCD9C3/o/r2g0oEGZkV3
         ZaMHBJ6vWaG146pBBP6YM9Q3RQdvJbT5PQ35Zf0H3TBSyd8tX4GumE2vUbMgLOcAqObn
         4JEmbXmX+PPSM1otJsl2jTfGObd2yG4ECOHSKUOkG0Qc7XZ6zIO6LXavTYHAJfdt25wx
         hEuw==
X-Gm-Message-State: AOAM531bcOvNmSlsWRCKymeK+vov5l8ZIG1IlX1NIRUn1ME+MPgJe/Sm
        r/nwjKSbvX34mq+GF2C4GnU=
X-Google-Smtp-Source: ABdhPJzZhHSyhOL30UTh+4XpMXnBLst+jA55JfVAndmfd8TBVcfubteD+376QDXWRfkC3St+JCQvbQ==
X-Received: by 2002:a17:90a:cf90:: with SMTP id i16mr949608pju.67.1641439287684;
        Wed, 05 Jan 2022 19:21:27 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x5sm366665pjq.39.2022.01.05.19.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 19:21:27 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: x86/pmu: Make top-down.slots event unavailable in supported leaf
Date:   Thu,  6 Jan 2022 11:21:18 +0800
Message-Id: <20220106032118.34459-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

When we choose to disable the fourth fixed counter TOPDOWN.SLOTS,
we also need to comply with the specification and set 0AH.EBX.[bit 7]
to 1 if the guest (e.g. on the ICX) has a value of 0AH.EAX[31:24] > 7.

Fixes: 2e8cd7a3b8287 ("kvm: x86: limit the maximum number of vPMU fixed counters to 3")
Signed-off-by: Like Xu <likexu@tencent.com>
---
v1 -> v2 Changelog:
- Make it simpler to keep forward compatibility; (Sean)
- Wrap related comment at ~80 chars; (Sean)

Previous:
https://lore.kernel.org/kvm/20220105050711.67280-1-likexu@tencent.com/

 arch/x86/kvm/cpuid.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0b920e12bb6d..4fe17a537084 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -782,6 +782,18 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		eax.split.mask_length = cap.events_mask_len;
 
 		edx.split.num_counters_fixed = min(cap.num_counters_fixed, MAX_FIXED_COUNTERS);
+
+		/*
+		 * The 8th Intel architectural event (Topdown Slots) will be supported
+		 * if the 4th fixed counter exists && EAX[31:24] > 7 && EBX[7] = 0.
+		 *
+		 * Currently, KVM needs to set EAX[31:24] < 8 or EBX[7] == 1
+		 * to make this event unavailable in a consistent way.
+		 */
+		if (edx.split.num_counters_fixed < 4 &&
+		    eax.split.mask_length > 7)
+			cap.events_mask |= BIT_ULL(7);
+
 		edx.split.bit_width_fixed = cap.bit_width_fixed;
 		if (cap.version)
 			edx.split.anythread_deprecated = 1;
-- 
2.33.1

