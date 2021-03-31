Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A008345A08
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 09:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhCWIpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 04:45:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33589 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229548AbhCWIpW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Mar 2021 04:45:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616489122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bWgjxBic5KxGRp4l3xszbSrPWge16zEazFDHmYAecQY=;
        b=QJa9LbTnr66aQ3lJZJXrICN6xEe/4IaU2gS9B50qya8qwPqqTSzKIDq2GrN2zmxUGmfS/R
        6L69Jdt22b5IHn56H3185TOenK9YcrmXG8bDWSN7llh1apjUXrz3XjF86OikyZPd1xhIIK
        LiyS62cP5D2fu7s0SSi2SlyD1MZxErY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-ODt21XKFOvWp4gOtUumWzA-1; Tue, 23 Mar 2021 04:45:20 -0400
X-MC-Unique: ODt21XKFOvWp4gOtUumWzA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2E7183DD26;
        Tue, 23 Mar 2021 08:45:18 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43A3A1F7;
        Tue, 23 Mar 2021 08:45:16 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Wei Huang <wei.huang2@amd.com>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/vPMU: Forbid writing to MSR_F15H_PERF MSRs when guest doesn't have X86_FEATURE_PERFCTR_CORE
Date:   Tue, 23 Mar 2021 09:45:15 +0100
Message-Id: <20210323084515.1346540-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

MSR_F15H_PERF_CTL0-5, MSR_F15H_PERF_CTR0-5 MSRs are only available when
X86_FEATURE_PERFCTR_CORE CPUID bit was exposed to the guest. KVM, however,
allows these MSRs unconditionally because kvm_pmu_is_valid_msr() ->
amd_msr_idx_to_pmc() check always passes and because kvm_pmu_set_msr() ->
amd_pmu_set_msr() doesn't fail.

In case of a counter (CTRn), no big harm is done as we only increase
internal PMC's value but in case of an eventsel (CTLn), we go deep into
perf internals with a non-existing counter.

Note, kvm_get_msr_common() just returns '0' when these MSRs don't exist
and this also seems to contradict architectural behavior which is #GP
(I did check one old Opteron host) but changing this status quo is a bit
scarier.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/pmu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 035da07500e8..fdf587f19c5f 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -98,6 +98,8 @@ static enum index msr_to_index(u32 msr)
 static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 					     enum pmu_type type)
 {
+	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
+
 	switch (msr) {
 	case MSR_F15H_PERF_CTL0:
 	case MSR_F15H_PERF_CTL1:
@@ -105,6 +107,9 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 	case MSR_F15H_PERF_CTL3:
 	case MSR_F15H_PERF_CTL4:
 	case MSR_F15H_PERF_CTL5:
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
+			return NULL;
+		fallthrough;
 	case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
 		if (type != PMU_TYPE_EVNTSEL)
 			return NULL;
@@ -115,6 +120,9 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 	case MSR_F15H_PERF_CTR3:
 	case MSR_F15H_PERF_CTR4:
 	case MSR_F15H_PERF_CTR5:
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
+			return NULL;
+		fallthrough;
 	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
 		if (type != PMU_TYPE_COUNTER)
 			return NULL;
-- 
2.30.2

