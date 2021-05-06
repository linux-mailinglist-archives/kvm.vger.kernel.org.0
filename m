Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37552375274
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 12:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbhEFKgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 06:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234406AbhEFKgb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 06:36:31 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42154C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 03:35:33 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4FbVN34MRqzQjmP;
        Thu,  6 May 2021 12:35:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        references:in-reply-to:message-id:date:date:subject:subject:from
        :from:received; s=mail20150812; t=1620297328; bh=9uNWF8Xr0G9/jSz
        HcgQqOcjiTZHBCs03GQfqI3el7nI=; b=OphBRe6c6zbEuPFTv/L43bzPdz29JxA
        YU6Myw0IXDWEzjkI1cXu2YqgCoemMWInnKOlrte9qxqtXO5tLMLarB/UAVoJN79e
        f1Lh9PcpS4KH7Vd0hhArqsam33vD4yz0UZGT4sh1Pz2oqbUPveNx1jbY3EAf6iM6
        amSpQLrMwqe2i/FbRXi5867az/V6Ap8n3xzJSUZyaulhTLGipp7uyEwAzML3kd7G
        pN5d6i8kX/4Mojdqpc5sASmtk6fdnsEZ/F0PN1mwwUbx7/1tFd6BdFD0B7O5WT2m
        UPJJJv7P6w7XrFb1DVJ+hAq3+DV3VH2E6Vgys5gUawHgBNMW3LAoByg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1620297329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=m4l+yaalVSjEbiK6O7xAueJFYpP9C6LsbkEmolHF2zc=;
        b=uBBuXG0UcPOhsiMSOHpa1q7ZBM2y8f0Pg/rS/bl+43t/IJI2TDagvkDpKVpchvnKu589fO
        DUpLQoktRM0hOgFkG308QgpiYVX+qHy0P26RLGMdMXECV7qhqNciBaxfrkcSwEF53l92Mv
        tHDPhNiWmamYcVi+NpTrzWf8ndnRCJ0DbqHoSDFZ7q9xDNYTl8oC14ui0WbMwfRE8IF6a0
        ovXG2vtK+0DG2hYu3MdML53+OcksKgwLSTTe/P3D6Xag/7BMrATKpQAMm05zUwcm0xA9Da
        wMx0/oeR26VDer5Wz4I9cE3CWgPiGj9VGPvHvFGMTrfYYUlCEid5lKRVoMCPTg==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id 9CK4h8sfBaTP; Thu,  6 May 2021 12:35:28 +0200 (CEST)
From:   ilstam@mailbox.org
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     ilstam@amazon.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        haozhong.zhang@intel.com, zamsden@gmail.com, mtosatti@redhat.com,
        dplotnikov@virtuozzo.com, dwmw@amazon.co.uk
Subject: [PATCH 4/8] KVM: VMX: Adjust the TSC-related VMCS fields on L2 entry and exit
Date:   Thu,  6 May 2021 10:32:24 +0000
Message-Id: <20210506103228.67864-5-ilstam@mailbox.org>
In-Reply-To: <20210506103228.67864-1-ilstam@mailbox.org>
References: <20210506103228.67864-1-ilstam@mailbox.org>
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.11 / 15.00 / 15.00
X-Rspamd-Queue-Id: 743A81868
X-Rspamd-UID: 32ff15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ilias Stamatis <ilstam@amazon.com>

When L2 is entered we need to "merge" the TSC multiplier and TSC offset
values of VMCS01 and VMCS12 and store the result into the current
VMCS02.

The 02 values are calculated using the following equations:
  offset_02 = ((offset_01 * mult_12) >> 48) + offset_12
  mult_02 = (mult_01 * mult_12) >> 48

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/nested.c       | 26 ++++++++++++++++++++++----
 arch/x86/kvm/x86.c              | 25 +++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cdddbf0b1177..e7a1eb36f95a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1780,6 +1780,7 @@ void kvm_define_user_return_msr(unsigned index, u32 msr);
 int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
 
 u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc, bool l1);
+u64 kvm_compute_02_tsc_offset(u64 l1_offset, u64 l2_multiplier, u64 l2_offset);
 u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc);
 
 unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bced76637823..a1bf28f33837 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3353,8 +3353,22 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	}
 
 	enter_guest_mode(vcpu);
-	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
-		vcpu->arch.tsc_offset += vmcs12->tsc_offset;
+
+	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING) {
+		if (vmcs12->secondary_vm_exec_control & SECONDARY_EXEC_TSC_SCALING) {
+			vcpu->arch.tsc_offset = kvm_compute_02_tsc_offset(
+					vcpu->arch.l1_tsc_offset,
+					vmcs12->tsc_multiplier,
+					vmcs12->tsc_offset);
+
+			vcpu->arch.tsc_scaling_ratio = mul_u64_u64_shr(
+					vcpu->arch.tsc_scaling_ratio,
+					vmcs12->tsc_multiplier,
+					kvm_tsc_scaling_ratio_frac_bits);
+		} else {
+			vcpu->arch.tsc_offset += vmcs12->tsc_offset;
+		}
+	}
 
 	if (prepare_vmcs02(vcpu, vmcs12, &entry_failure_code)) {
 		exit_reason.basic = EXIT_REASON_INVALID_STATE;
@@ -4454,8 +4468,12 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	if (nested_cpu_has_preemption_timer(vmcs12))
 		hrtimer_cancel(&to_vmx(vcpu)->nested.preemption_timer);
 
-	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
-		vcpu->arch.tsc_offset -= vmcs12->tsc_offset;
+	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING) {
+		vcpu->arch.tsc_offset = vcpu->arch.l1_tsc_offset;
+
+		if (vmcs12->secondary_vm_exec_control & SECONDARY_EXEC_TSC_SCALING)
+			vcpu->arch.tsc_scaling_ratio = vcpu->arch.l1_tsc_scaling_ratio;
+	}
 
 	if (likely(!vmx->fail)) {
 		sync_vmcs02_to_vmcs12(vcpu, vmcs12);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 26a4c0f46f15..87deb119c521 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2266,6 +2266,31 @@ static u64 kvm_compute_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
 	return target_tsc - tsc;
 }
 
+/*
+ * This function computes the TSC offset that is stored in VMCS02 when entering
+ * L2 by combining the offset and multiplier values of VMCS01 and VMCS12.
+ */
+u64 kvm_compute_02_tsc_offset(u64 l1_offset, u64 l2_multiplier, u64 l2_offset)
+{
+	u64 offset;
+
+	/*
+	 * The L1 offset is interpreted as a signed number by the CPU and can
+	 * be negative. So we extract the sign before the multiplication and
+	 * put it back afterwards if needed.
+	 */
+	offset = mul_u64_u64_shr(abs((s64) l1_offset),
+				 l2_multiplier,
+				 kvm_tsc_scaling_ratio_frac_bits);
+
+	if ((s64) l1_offset < 0)
+		offset = -((s64) offset);
+
+	offset += l2_offset;
+	return offset;
+}
+EXPORT_SYMBOL_GPL(kvm_compute_02_tsc_offset);
+
 u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
 {
 	return vcpu->arch.l1_tsc_offset + kvm_scale_tsc(vcpu, host_tsc, true);
-- 
2.17.1

