Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FC1455C3B
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 14:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhKRNJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 08:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbhKRNHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 08:07:34 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DFCC061200;
        Thu, 18 Nov 2021 05:03:30 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 206so223343pgb.4;
        Thu, 18 Nov 2021 05:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YkQ0L6ov2Ory4vQt6aQEMjJBE8NyFL5tDp9I+7VLkvk=;
        b=UvSjLrChPyOxJoCoR2N463zw6Yi5XH52FrUqYT0H6H2npToGJPWvtuRuRrFiNn5mpE
         gKxVuxXZDosf2FstvS5n6w7o20nR1pye6jwXa/T1WoK12aMVpNkMnEHZ74FC17LrBZtJ
         91YPEiw0hb7g5zNy4rfjqsA3QQLu1CsSgnwAfmqSRyGAuErpuq2+iM+2tFOl2nFMEP5w
         XgMxQjNvkwKNO8BQMuqcS0BdNpE1ONVKHnGO68ALjJAfKZVaTUZ5dyXGFppw7pjnQVdh
         Amux6FRI/wlzsidovr6PL3hb+aYbSwE0mJLUH9kCNYbCVXyvmHgWwMXKZoXfhAQaOd4e
         JHKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YkQ0L6ov2Ory4vQt6aQEMjJBE8NyFL5tDp9I+7VLkvk=;
        b=IZEpaA4LsfJ7MtRHvqkZpkyoKv9BrzV8LVnBlsOKUaxUgSL6T74PrVmMjgpgNhQ+L/
         rqSd1cHm0GUJFhK1U4yh/GyWP05SZiu6lKvDXcSICqyJqCb2esMokJcXJxxe6MrgbFLP
         Fm3FIunu0lk2v/z3lQEPYFm6FScIlcTixt/VGwvbCEG+G3QquUIQOh75usZlhetmrPGb
         DPzxoa52W7e99SWgd8tjECjjk6Y5SeKP2IX3tFmt3QfbT/wc6xfstD/r481st24DjwW3
         XswdMKDWljl03nh7/T6bQPFvB8FJ6vcr+X/icONCnOv+a09AIPDzGUIiSHIMPdK8ItDz
         facw==
X-Gm-Message-State: AOAM5328kQjrouJWPgxvv7gD29zCG/uHI4u0sSQ3hFgHZFq46x+QwbLk
        XJvmqqz6sM6otxXnJZg8gnY=
X-Google-Smtp-Source: ABdhPJytthsNWRyHkl5u4MZgBEyE85NEi6df3AZHNa2xO3GbwD7XWpb4DLj5PtOATfpvkM8dC9lHCw==
X-Received: by 2002:a65:6854:: with SMTP id q20mr11073627pgt.38.1637240610362;
        Thu, 18 Nov 2021 05:03:30 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id pf15sm9416265pjb.40.2021.11.18.05.03.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 05:03:29 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: Fix reserved bits for AMD PerfEvtSeln register
Date:   Thu, 18 Nov 2021 21:03:20 +0800
Message-Id: <20211118130320.95997-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

If we run the following perf command in an AMD Milan guest:

  perf stat \
  -e cpu/event=0x1d0/ \
  -e cpu/event=0x1c7/ \
  -e cpu/umask=0x1f,event=0x18e/ \
  -e cpu/umask=0x7,event=0x18e/ \
  -e cpu/umask=0x18,event=0x18e/ \
  ./workload

dmesg will report a #GP warning from an unchecked MSR access
error on MSR_F15H_PERF_CTLx.

This is because according to APM (Revision: 4.03) Figure 13-7,
the bits [35:32] of AMD PerfEvtSeln register is a part of the
event select encoding, which extends the EVENT_SELECT field
from 8 bits to 12 bits.

Opportunistically update pmu->reserved_bits for reserved bit 19.

Reported-by: Jim Mattson <jmattson@google.com>
Fixes: ca724305a2b0 ("KVM: x86/vPMU: Implement AMD vPMU code for KVM")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/svm/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 871c426ec389..b4095dfeeee6 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -281,7 +281,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS;
 
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;
-	pmu->reserved_bits = 0xffffffff00200000ull;
+	pmu->reserved_bits = 0xfffffff000280000ull;
 	pmu->version = 1;
 	/* not applicable to AMD; but clean them to prevent any fall out */
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
-- 
2.33.1

