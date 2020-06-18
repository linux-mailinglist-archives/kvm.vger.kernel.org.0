Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5485C1FF053
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 13:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbgFRLNs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 07:13:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26074 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728262AbgFRLNg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 07:13:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592478814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dAjSN5aDL+hVRsYsF7/VthZ3MY7xiAzNFu4+vdSACNM=;
        b=HiYSsdPrQ4WA5YRuQB2k54tYe5BIYF6NX2SHReOPGjYShxC4VHW3pmDf1M7xQGOouq2l4s
        BYbV39c14Hn4UAUrF6XBdds9ELsZCIXHMYp1+1OkZzFYbjvYUrClwAQBKmfe43A8EITMy6
        GcqMftPU7i3p97W2LAd8Ww5DrY3PJ9w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-aqOfGQKUNQKHtDcjW29_eg-1; Thu, 18 Jun 2020 07:13:33 -0400
X-MC-Unique: aqOfGQKUNQKHtDcjW29_eg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D907E801504;
        Thu, 18 Jun 2020 11:13:31 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FAE910013D6;
        Thu, 18 Jun 2020 11:13:29 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Like Xu <like.xu@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: SVM: emulate MSR_IA32_PERF_CAPABILITIES
Date:   Thu, 18 Jun 2020 13:13:28 +0200
Message-Id: <20200618111328.429931-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

state_test/smm_test selftests are failing on AMD with:
"Unexpected result from KVM_GET_MSRS, r: 51 (failed MSR was 0x345)"

MSR_IA32_PERF_CAPABILITIES is an emulated MSR on Intel but it is not
known to AMD code, emulate it there too (by returning 0 and allowing
userspace to write 0). This way the code is better prepared to the
eventual appearance of the feature in AMD hardware.

Fixes: 27461da31089 ("KVM: x86/pmu: Support full width counting")
Suggested-by: Jim Mattson <jmattson@google.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/pmu.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 035da07500e8..f13ee3cd6d0f 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -200,7 +200,13 @@ static struct kvm_pmc *amd_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 
 static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
-	/* All MSRs refer to exactly one PMC, so msr_idx_to_pmc is enough.  */
+	switch (msr) {
+	case MSR_IA32_PERF_CAPABILITIES:
+		return true;
+	default:
+		break;
+	}
+
 	return false;
 }
 
@@ -221,6 +227,14 @@ static int amd_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	struct kvm_pmc *pmc;
 	u32 msr = msr_info->index;
 
+	if (msr == MSR_IA32_PERF_CAPABILITIES) {
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
+			return 1;
+		msr_info->data = vcpu->arch.perf_capabilities;
+		return 0;
+	}
+
 	/* MSR_PERFCTRn */
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
 	if (pmc) {
@@ -244,6 +258,18 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
 
+	if (msr == MSR_IA32_PERF_CAPABILITIES) {
+		if (!msr_info->host_initiated)
+			return 1;
+
+		/* No feature bits are currently supported */
+		if (data)
+			return 1;
+
+		vcpu->arch.perf_capabilities = data;
+		return 0;
+	}
+
 	/* MSR_PERFCTRn */
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
 	if (pmc) {
@@ -281,6 +307,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->nr_arch_fixed_counters = 0;
 	pmu->global_status = 0;
 	bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counters);
+	vcpu->arch.perf_capabilities = 0;
 }
 
 static void amd_pmu_init(struct kvm_vcpu *vcpu)
-- 
2.25.4

