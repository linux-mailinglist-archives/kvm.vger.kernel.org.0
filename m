Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE41CC9BCB
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 12:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbfJCKKY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 06:10:24 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44894 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfJCKKY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 06:10:24 -0400
Received: by mail-wr1-f66.google.com with SMTP id z9so2251896wrl.11;
        Thu, 03 Oct 2019 03:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=ottjOaTEs3Ikgb7CnHP3dioI7rwiHnXtk/G5yLxaaPo=;
        b=seTVmCw1DuIF0JANo3cCvEMKzbuNRA6FupcEyAP8s+iQ44VKrfzN+QttsFwMgdYEvi
         JWawy6V9Uuy/2t3xVz/mKTS9lHiIYFvcZ26TmH9229Ab8WkIbg5K3PWhw8S21jDXG1M+
         Zegi3vYe3exoL/+Ld8mflSsckdCRJ1iFHTFKU8Va6rumr7Edid7Chc2OXs5uOBcc6wf/
         Rkh0lBsO98fXe3pF/DJWcNM5uIfZm9zwIUf+vD8lydzCGHPi6RSbVirIrGcAtHIN8QSx
         ch7CBYluAImlhLCWwquTokGx2Seh3oooWzeRxte5NFx/3Vrmo7Pu2uYmpwR8b8NW/37c
         b3FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=ottjOaTEs3Ikgb7CnHP3dioI7rwiHnXtk/G5yLxaaPo=;
        b=hdy2PG+f5xh+GxQDsyzNjzGGTYuPXJaVBrVhAaU1OhxNLZtL+mYclA5mHfTcJOtY3u
         NSJXYPKVO1Lzn63mpdEzx5PPGbzH1e+fvNdwx+cc2n8gPdctXYMaSqez//OJMfdZO9r+
         BGwfrMRjqDO+IGdpvJDLBZTj8bNdZO/TQEn/nBhzGpTB5kmweaSehHJ+9iAOSRG5F4ry
         Hdr1/rEZ/7dWdSh17DrIImFmK2nFhzPUFP1ELvGPt1GWUgMlxz84e4x4tja5o4ZPhuy9
         KQgJBkHl6v9CTiqMpSevqgDOmXBT9G65Wgj0/VyJZehasBhl9BJy6vUvdZAXZzrXn/aI
         81Aw==
X-Gm-Message-State: APjAAAWERNdEASr0nLxM3N3BOdTIfhTyezhxRS4rfRXenJsVhm+8aM12
        fRITVM1Z3fYgFDNRIq+ZVnJOQcm/
X-Google-Smtp-Source: APXvYqzwwBM7nhU8aTEIMRdR49D+1r0ygejlqnwQRZf0IJ0xhbv8FN6y/iMkGbXaYlnQCQuHGc6nBw==
X-Received: by 2002:a5d:4b46:: with SMTP id w6mr6827233wrs.223.1570097421982;
        Thu, 03 Oct 2019 03:10:21 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id r20sm4003148wrg.61.2019.10.03.03.10.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 03:10:21 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Jim Mattson <jmattson@google.com>
Subject: [PATCH v2] KVM: x86: omit absent pmu MSRs from MSR list
Date:   Thu,  3 Oct 2019 12:10:18 +0200
Message-Id: <1570097418-42233-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

INTEL_PMC_MAX_GENERIC is currently 32, which exceeds the 18 contiguous
MSR indices reserved by Intel for event selectors.  Since some machines
actually have MSRs past the reserved range, these may survive the
filtering of msrs_to_save array and would be rejected by KVM_GET/SET_MSR.
To avoid this, cut the list to whatever CPUID reports for the host's
architectural PMU.

Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Jim Mattson <jmattson@google.com>
Fixes: e2ada66ec418 ("kvm: x86: Add Intel PMU MSRs to msrs_to_save[]", 2019-08-21)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8072acaaf028..31607174f442 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5105,13 +5105,14 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 static void kvm_init_msr_list(void)
 {
+	struct x86_pmu_capability x86_pmu;
 	u32 dummy[2];
 	unsigned i, j;
 
 	BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED != 4,
 			 "Please update the fixed PMCs in msrs_to_save[]");
-	BUILD_BUG_ON_MSG(INTEL_PMC_MAX_GENERIC != 32,
-			 "Please update the generic perfctr/eventsel MSRs in msrs_to_save[]");
+
+	perf_get_x86_pmu_capability(&x86_pmu);
 
 	for (i = j = 0; i < ARRAY_SIZE(msrs_to_save); i++) {
 		if (rdmsr_safe(msrs_to_save[i], &dummy[0], &dummy[1]) < 0)
@@ -5153,6 +5154,15 @@ static void kvm_init_msr_list(void)
 				intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
 				continue;
 			break;
+		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 31:
+			if (msrs_to_save[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
+			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
+				continue;
+			break;
+		case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 31:
+			if (msrs_to_save[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
+			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
+				continue;
 		}
 		default:
 			break;
-- 
1.8.3.1

