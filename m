Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9324F3E410F
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 09:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbhHIHsm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 03:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233533AbhHIHsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 03:48:35 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1FFC0613CF;
        Mon,  9 Aug 2021 00:48:14 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id ca5so26557208pjb.5;
        Mon, 09 Aug 2021 00:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C85qCSugEcqkhP9sJqsX8NhHPkwOW8SIOj7a90Xvxf0=;
        b=FoSOf3fe97dAktFJrsyO2Jm8eZW3V2hbTtl4YqOpsH3q6LFrMlcsdEspXGHh/HT6tg
         qsUFdUMAe9Wo/Tp5jw+IYsw+1uMGLhUsw1O7i7DPFqjzjR0mOwgyUyXjtjpPc21nkAIj
         vPY4Klo0WX73N0wprV+3jw8rn0FBQ7qzbrWNcek1B9oDnRrLGRCxz23sxgDg7RJqbR83
         F68ZsfhXTzj2SQBe/O720stwmBjxNlzzEtaOt1bKYA49Rg6XILnyqpjz7XZqj7uIUEEE
         v4TNn/Ekve1v39xAItQxyzHEquDCoWJqaNa8ibXKHvpTXGzCcZUA/1fme6ZvgRZmMg5c
         oDHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C85qCSugEcqkhP9sJqsX8NhHPkwOW8SIOj7a90Xvxf0=;
        b=IhLsKQLILWkZF7xhofIB5FluZhBX/yg1cAI8JgTXfS88gEaS04aA2d7bClR+p8DXiY
         EvPMSlntldJShxNAlvidVweSDFcVbFFn4FkpxND1mT1zT5P1KXXKEOpA98CMHIv/dxV9
         f7ySnQfoLlNjrbbU920HW2GmlY3nWu/d6LtzwjROhnqRWJDNjkDwUpiGcPPNFYDoqIxY
         ygxU9Ft1Ellvi7m20RCaSJG8jLXiFsIC+B4S14i8iAO9P5500z98nocWY8SYMWI7giln
         n0Rhx5CnE5h1sMMYz4JaXHISty5st695IcS+3cn7/WTvA60jDCjPLEAC+yw/Qn8KkmfZ
         A07w==
X-Gm-Message-State: AOAM531KisTz4oGvdHtRp9t/JFfGrngf2hl6BHgT/eCG0WXvRWWDwy5H
        ybJsrUyK2r6dDvZrCzvIR/vYYqlQNjlGlA==
X-Google-Smtp-Source: ABdhPJzDkvBu4hnlJ2QQXDeMmude9oYDgLJbFwDOrBwImh0r+qPVap7hNSuMhrAdn3p+B9RRObhBjQ==
X-Received: by 2002:a17:90a:17cc:: with SMTP id q70mr2347701pja.1.1628495294159;
        Mon, 09 Aug 2021 00:48:14 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id n35sm18609297pfv.152.2021.08.09.00.48.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Aug 2021 00:48:13 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>
Cc:     Andi Kleen <ak@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: Don't expose guest LBR if the LBR_SELECT is shared per physical core
Date:   Mon,  9 Aug 2021 15:48:03 +0800
Message-Id: <20210809074803.43154-1-likexu@tencent.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

According to Intel SDM, the Last Branch Record Filtering Select Register
(R/W) is defined as shared per physical core rather than per logical core
on some older Intel platforms: Silvermont, Airmont, Goldmont and Nehalem.

To avoid LBR attacks or accidental data leakage, on these specific
platforms, KVM should not expose guest LBR capability even if HT is
disabled on the host, considering that the HT state can be dynamically
changed, yet the KVM capabilities are initialized at module initialisation.

Fixes: be635e34c284 ("KVM: vmx/pmu: Expose LBR_FMT in the MSR_IA32_PERF_CAPABILITIES")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/intel-family.h |  1 +
 arch/x86/kvm/vmx/capabilities.h     | 19 ++++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 27158436f322..f35c915566e3 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -119,6 +119,7 @@
 
 #define INTEL_FAM6_ATOM_SILVERMONT	0x37 /* Bay Trail, Valleyview */
 #define INTEL_FAM6_ATOM_SILVERMONT_D	0x4D /* Avaton, Rangely */
+#define INTEL_FAM6_ATOM_SILVERMONT_X3	0x5D /* X3-C3000 based on Silvermont */
 #define INTEL_FAM6_ATOM_SILVERMONT_MID	0x4A /* Merriefield */
 
 #define INTEL_FAM6_ATOM_AIRMONT		0x4C /* Cherry Trail, Braswell */
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 4705ad55abb5..ff9596d7112d 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -3,6 +3,7 @@
 #define __KVM_X86_VMX_CAPS_H
 
 #include <asm/vmx.h>
+#include <asm/cpu_device_id.h>
 
 #include "lapic.h"
 
@@ -376,6 +377,21 @@ static inline bool vmx_pt_mode_is_host_guest(void)
 	return pt_mode == PT_MODE_HOST_GUEST;
 }
 
+static const struct x86_cpu_id lbr_select_shared_cpu[] = {
+	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_MID, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_D, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_X3, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT_MID, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_PLUS, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(NEHALEM_EP, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(NEHALEM, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(NEHALEM_G, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(NEHALEM_EX, NULL),
+	{}
+};
+
 static inline u64 vmx_get_perf_capabilities(void)
 {
 	u64 perf_cap = 0;
@@ -383,7 +399,8 @@ static inline u64 vmx_get_perf_capabilities(void)
 	if (boot_cpu_has(X86_FEATURE_PDCM))
 		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
 
-	perf_cap &= PMU_CAP_LBR_FMT;
+	if (!x86_match_cpu(lbr_select_shared_cpu))
+		perf_cap &= PMU_CAP_LBR_FMT;
 
 	/*
 	 * Since counters are virtualized, KVM would support full
-- 
2.32.0

