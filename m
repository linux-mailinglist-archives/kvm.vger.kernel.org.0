Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 669B4B9900
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 23:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394008AbfITV0Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 17:26:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40482 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730151AbfITVZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 17:25:13 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B089530833C1;
        Fri, 20 Sep 2019 21:25:12 +0000 (UTC)
Received: from mail (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1868819C68;
        Fri, 20 Sep 2019 21:25:10 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/17] KVM: monolithic: x86: convert the kvm_pmu_ops methods to external functions
Date:   Fri, 20 Sep 2019 17:24:56 -0400
Message-Id: <20190920212509.2578-5-aarcange@redhat.com>
In-Reply-To: <20190920212509.2578-1-aarcange@redhat.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 20 Sep 2019 21:25:12 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This replaces all kvm_pmu_ops pointer to functions with regular
external functions that don't require indirect calls.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/kvm/pmu_amd_ops.c       | 68 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/pmu_ops.h           | 22 +++++++++++
 arch/x86/kvm/vmx/pmu_intel_ops.c | 68 ++++++++++++++++++++++++++++++++
 3 files changed, 158 insertions(+)
 create mode 100644 arch/x86/kvm/pmu_amd_ops.c
 create mode 100644 arch/x86/kvm/pmu_ops.h
 create mode 100644 arch/x86/kvm/vmx/pmu_intel_ops.c

diff --git a/arch/x86/kvm/pmu_amd_ops.c b/arch/x86/kvm/pmu_amd_ops.c
new file mode 100644
index 000000000000..d2e9a244caa8
--- /dev/null
+++ b/arch/x86/kvm/pmu_amd_ops.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ *  arch/x86/kvm/pmu_amd_ops.c
+ *
+ *  Copyright 2019 Red Hat, Inc.
+ */
+
+unsigned kvm_pmu_ops_find_arch_event(struct kvm_pmu *pmu, u8 event_select,
+				     u8 unit_mask)
+{
+	return amd_find_arch_event(pmu, event_select, unit_mask);
+}
+
+unsigned kvm_pmu_ops_find_fixed_event(int idx)
+{
+	return amd_find_fixed_event(idx);
+}
+
+bool kvm_pmu_ops_pmc_is_enabled(struct kvm_pmc *pmc)
+{
+	return amd_pmc_is_enabled(pmc);
+}
+
+struct kvm_pmc *kvm_pmu_ops_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
+{
+	return amd_pmc_idx_to_pmc(pmu, pmc_idx);
+}
+
+struct kvm_pmc *kvm_pmu_ops_msr_idx_to_pmc(struct kvm_vcpu *vcpu, unsigned idx,
+					   u64 *mask)
+{
+	return amd_msr_idx_to_pmc(vcpu, idx, mask);
+}
+
+int kvm_pmu_ops_is_valid_msr_idx(struct kvm_vcpu *vcpu, unsigned idx)
+{
+	return amd_is_valid_msr_idx(vcpu, idx);
+}
+
+bool kvm_pmu_ops_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
+{
+	return amd_is_valid_msr(vcpu, msr);
+}
+
+int kvm_pmu_ops_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
+{
+	return amd_pmu_get_msr(vcpu, msr, data);
+}
+
+int kvm_pmu_ops_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+{
+	return amd_pmu_set_msr(vcpu, msr_info);
+}
+
+void kvm_pmu_ops_refresh(struct kvm_vcpu *vcpu)
+{
+	amd_pmu_refresh(vcpu);
+}
+
+void kvm_pmu_ops_init(struct kvm_vcpu *vcpu)
+{
+	amd_pmu_init(vcpu);
+}
+
+void kvm_pmu_ops_reset(struct kvm_vcpu *vcpu)
+{
+	amd_pmu_reset(vcpu);
+}
diff --git a/arch/x86/kvm/pmu_ops.h b/arch/x86/kvm/pmu_ops.h
new file mode 100644
index 000000000000..6230ce300cbe
--- /dev/null
+++ b/arch/x86/kvm/pmu_ops.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __KVM_X86_PMU_OPS_H
+#define __KVM_X86_PMU_OPS_H
+
+extern unsigned kvm_pmu_ops_find_arch_event(struct kvm_pmu *pmu,
+					    u8 event_select, u8 unit_mask);
+extern unsigned kvm_pmu_ops_find_fixed_event(int idx);
+extern bool kvm_pmu_ops_pmc_is_enabled(struct kvm_pmc *pmc);
+extern struct kvm_pmc *kvm_pmu_ops_pmc_idx_to_pmc(struct kvm_pmu *pmu,
+						  int pmc_idx);
+extern struct kvm_pmc *kvm_pmu_ops_msr_idx_to_pmc(struct kvm_vcpu *vcpu,
+						  unsigned idx, u64 *mask);
+extern int kvm_pmu_ops_is_valid_msr_idx(struct kvm_vcpu *vcpu, unsigned idx);
+extern bool kvm_pmu_ops_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr);
+extern int kvm_pmu_ops_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
+extern int kvm_pmu_ops_set_msr(struct kvm_vcpu *vcpu,
+			       struct msr_data *msr_info);
+extern void kvm_pmu_ops_refresh(struct kvm_vcpu *vcpu);
+extern void kvm_pmu_ops_init(struct kvm_vcpu *vcpu);
+extern void kvm_pmu_ops_reset(struct kvm_vcpu *vcpu);
+
+#endif /* __KVM_X86_PMU_OPS_H */
diff --git a/arch/x86/kvm/vmx/pmu_intel_ops.c b/arch/x86/kvm/vmx/pmu_intel_ops.c
new file mode 100644
index 000000000000..39f1b4af85e3
--- /dev/null
+++ b/arch/x86/kvm/vmx/pmu_intel_ops.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ *  arch/x86/kvm/vmx/pmu_intel_ops.c
+ *
+ *  Copyright 2019 Red Hat, Inc.
+ */
+
+unsigned kvm_pmu_ops_find_arch_event(struct kvm_pmu *pmu, u8 event_select,
+				     u8 unit_mask)
+{
+	return intel_find_arch_event(pmu, event_select, unit_mask);
+}
+
+unsigned kvm_pmu_ops_find_fixed_event(int idx)
+{
+	return intel_find_fixed_event(idx);
+}
+
+bool kvm_pmu_ops_pmc_is_enabled(struct kvm_pmc *pmc)
+{
+	return intel_pmc_is_enabled(pmc);
+}
+
+struct kvm_pmc *kvm_pmu_ops_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
+{
+	return intel_pmc_idx_to_pmc(pmu, pmc_idx);
+}
+
+struct kvm_pmc *kvm_pmu_ops_msr_idx_to_pmc(struct kvm_vcpu *vcpu, unsigned idx,
+					   u64 *mask)
+{
+	return intel_msr_idx_to_pmc(vcpu, idx, mask);
+}
+
+int kvm_pmu_ops_is_valid_msr_idx(struct kvm_vcpu *vcpu, unsigned idx)
+{
+	return intel_is_valid_msr_idx(vcpu, idx);
+}
+
+bool kvm_pmu_ops_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
+{
+	return intel_is_valid_msr(vcpu, msr);
+}
+
+int kvm_pmu_ops_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
+{
+	return intel_pmu_get_msr(vcpu, msr, data);
+}
+
+int kvm_pmu_ops_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+{
+	return intel_pmu_set_msr(vcpu, msr_info);
+}
+
+void kvm_pmu_ops_refresh(struct kvm_vcpu *vcpu)
+{
+	intel_pmu_refresh(vcpu);
+}
+
+void kvm_pmu_ops_init(struct kvm_vcpu *vcpu)
+{
+	intel_pmu_init(vcpu);
+}
+
+void kvm_pmu_ops_reset(struct kvm_vcpu *vcpu)
+{
+	intel_pmu_reset(vcpu);
+}
