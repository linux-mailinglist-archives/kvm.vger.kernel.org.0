Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA1FBC2AFF
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 01:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbfI3XjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 19:39:03 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:44584 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfI3XjD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 19:39:03 -0400
Received: by mail-pl1-f202.google.com with SMTP id h11so6144238plt.11
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 16:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=iUPETDwQOzy+tWSFOzHVyfsCygr1n/1h4IIKuJoGX2M=;
        b=Uwa1QlFOrpNa9ZrKjpo0/hwszfHJJ8q0x+LT6BlIEIL5CLUil1+zcep30T+qrDiJDN
         znh4vpvipMsXm/Gkm8AHUQC7XHCRoi1Nf8XsM5sW4T/hobVsRkZY5A1MBxsxcggc0qdi
         AcxACNaieYq1WQe3vwrnMV56l2K/BORJ3b21OHd/UgR22la7iukrIX/lAt4/AKYMHMhg
         wn1K3XKx+eJwCAFnCaNB8KMpJgePT7cevhxqzEtVzTKyMH+MbvzIbAMNB0jobxNEEwQM
         Boy1niXxMfqKiNKRYUfH6ozMiVrXJPP4yhNRXNySnpz60qmUlWTxT7AchMjarHPJiHY1
         VomA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=iUPETDwQOzy+tWSFOzHVyfsCygr1n/1h4IIKuJoGX2M=;
        b=BYMexYJdM3Qs3+seg+yBX2dlHUcAmK22rvn8eZYDlWo0fJDhVN88vc7oXSGUTef2sf
         x+NQEtUDjDnnndsVEk9lwu6PJyEAynXEUFdgJ9q6QpbTbu7rVTk7YkpLZ3LJQmJos9cs
         AQLUjUMsp13nnS+dNp7l3HD1XJZMT4xE1okcqn0eqVY1U7535AuVOJ7CLngQaLW/F5pK
         3Rk4gE0TxdP2bBQ4bYlCk2XugE+budIXJraIDW71NKPIRh0ldp3XHYNw4kQk/bbddtXu
         h9jVqbv+sVjExV3UqR3uzGmIgSQgfCPX5aVERYgkSmhdC45GFKws3hktEDQPpv6srgfP
         ME/Q==
X-Gm-Message-State: APjAAAXf/aKSinkKcvdLiB6PzSlPSO3SGvXbleih01tsK6v34SZE2IA2
        yzbn0YqouQlJLHmO8EHJ0BMyZMY3NFxpwS+D6GarevPd21PTzmWkZG9j/ojOtx0L4V8+3UHg7+l
        p+vcvRwAvloKOg7xfTN7AK/mQF3R1D+DVSxFjqUGnnbwPNSjsiDLDbn/gupY3q30=
X-Google-Smtp-Source: APXvYqyxR+yYPwgVw5DnJrJsuxH8VI6jzYJYRicK3ZV+eoeCu98pVcNGELJkM9SxyjzY/jaVMBAJhSWeGUgUug==
X-Received: by 2002:a63:9a11:: with SMTP id o17mr26691806pge.434.1569886740859;
 Mon, 30 Sep 2019 16:39:00 -0700 (PDT)
Date:   Mon, 30 Sep 2019 16:38:54 -0700
Message-Id: <20190930233854.158117-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [PATCH] kvm: vmx: Limit guest PMCs to those supported on the host
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Marc Orr <marcorr@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM can only virtualize as many PMCs as the host supports.

Limit the number of generic counters and fixed counters to the number
of corresponding counters supported on the host, rather than to
INTEL_PMC_MAX_GENERIC and INTEL_PMC_MAX_FIXED, respectively.

Note that INTEL_PMC_MAX_GENERIC is currently 32, which exceeds the 18
contiguous MSR indices reserved by Intel for event selectors. Since
the existing code relies on a contiguous range of MSR indices for
event selectors, it can't possibly work for more than 18 general
purpose counters.

Fixes: f5132b01386b5a ("KVM: Expose a version 2 architectural PMU to a guests")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 4dea0e0e7e392..3e9c059099e94 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -262,6 +262,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct x86_pmu_capability x86_pmu;
 	struct kvm_cpuid_entry2 *entry;
 	union cpuid10_eax eax;
 	union cpuid10_edx edx;
@@ -283,8 +284,10 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (!pmu->version)
 		return;
 
+	perf_get_x86_pmu_capability(&x86_pmu);
+
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
-					INTEL_PMC_MAX_GENERIC);
+					 x86_pmu.num_counters_gp);
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << eax.split.bit_width) - 1;
 	pmu->available_event_types = ~entry->ebx &
 					((1ull << eax.split.mask_length) - 1);
@@ -294,7 +297,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	} else {
 		pmu->nr_arch_fixed_counters =
 			min_t(int, edx.split.num_counters_fixed,
-				INTEL_PMC_MAX_FIXED);
+			      x86_pmu.num_counters_fixed);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
 			((u64)1 << edx.split.bit_width_fixed) - 1;
 	}
-- 
2.23.0.444.g18eeb5a265-goog

