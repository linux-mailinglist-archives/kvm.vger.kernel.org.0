Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B768728E0BF
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 14:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730893AbgJNMu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 08:50:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41692 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727061AbgJNMu2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Oct 2020 08:50:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602679827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MMxmagzUGQGP4XInFkt7451v8xVF11xKUk5UyjYEMMU=;
        b=JJVoI9zz4deLypUhW762AihleYHLZ7f4lcEii20kkMbgbBEh+9VZzw8+6UKDzjwulA8lz/
        3WtYI9rz9sZe8myICylAt8HeuXcGQg41P8/gVk6ioXTwueSy7juVS6YXibroi5XesagPbs
        MG0YpPnvM/mGQwExmDriq035XmLR/K4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-2Lq70kDlO0Sv7pwogcjvXg-1; Wed, 14 Oct 2020 08:50:25 -0400
X-MC-Unique: 2Lq70kDlO0Sv7pwogcjvXg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E12571062721;
        Wed, 14 Oct 2020 12:50:23 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0C9760BE2;
        Wed, 14 Oct 2020 12:50:21 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Filter out more Intel-specific PMU MSRs in kvm_init_msr_list()
Date:   Wed, 14 Oct 2020 14:50:20 +0200
Message-Id: <20201014125020.2406434-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running KVM selftest in a Hyper-V VM they stumble upon

  Unexpected result from KVM_GET_MSRS, r: 14 (failed MSR was 0x309)

MSR_ARCH_PERFMON_FIXED_CTR[0..3] along with MSR_CORE_PERF_FIXED_CTR_CTRL,
MSR_CORE_PERF_GLOBAL_STATUS, MSR_CORE_PERF_GLOBAL_CTRL,
MSR_CORE_PERF_GLOBAL_OVF_CTRL are only valid for Intel PMU ver > 1 but
Hyper-V instances have CPUID.0AH.EAX == 0 (so perf code falls back to
p6_pmu instead of intel_pmu). Surprisingly, unlike on AMD hardware for
example, our rdmsr_safe() check passes and MSRs are not filtered out.

MSR_ARCH_PERFMON_FIXED_CTR[0..3] can probably be checked against
x86_pmu.num_counters_fixed and the rest is only present with
x86_pmu.version > 1.

Unfortunately, full elimination of the disconnection between system-wide
KVM_GET_MSR_INDEX_LIST/KVM_GET_MSR_FEATURE_INDEX_LIST and per-VCPU
KVM_GET_MSRS/KVM_SET_MSRS seem to be impossible as per-vCPU PMU setup
depends on guest CPUIDs which can always be altered.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/x86.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ce856e0ece84..85d72b125fba 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5436,6 +5436,15 @@ static void kvm_init_msr_list(void)
 			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
 				continue;
 			break;
+		case MSR_ARCH_PERFMON_FIXED_CTR0 ... MSR_ARCH_PERFMON_FIXED_CTR0 + 3:
+			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_FIXED_CTR0 >=
+			    min(INTEL_PMC_MAX_FIXED, x86_pmu.num_counters_fixed))
+				continue;
+			break;
+		case MSR_CORE_PERF_FIXED_CTR_CTRL ... MSR_CORE_PERF_GLOBAL_OVF_CTRL:
+			if (x86_pmu.version <= 1)
+				continue;
+			break;
 		default:
 			break;
 		}
-- 
2.25.4

