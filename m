Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2027671FAB
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 15:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbjAROeg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 09:34:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjAROeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 09:34:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE682CD
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 06:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674051698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=8szriLoMWaBZkkRPlHuOrDJ2aQZ7ySn5JLFWbzyQs8I=;
        b=eW2bOfDYQqc0apoTeqHUY18+kJ4MOFLqcV1AR3dVAwwRYWJw1+cBwdh+WfghrGB/Krc/um
        BxI04St1pwKkfTuJH5Ple9/W84LguZOWwI1Em0Q+NlfW/msCnrNZuoeWvnrIeOPGH57r8Z
        vG9LApJuJHa+kc3xEqcn/1d7tDfGlMg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-194-Sxnzt6l7OrastoMdc7YYfw-1; Wed, 18 Jan 2023 09:21:37 -0500
X-MC-Unique: Sxnzt6l7OrastoMdc7YYfw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E407B85C6E0
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 14:21:36 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.208.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9635F140EBF5;
        Wed, 18 Jan 2023 14:21:35 +0000 (UTC)
From:   Anthony Harivel <aharivel@redhat.com>
To:     kvm@vger.kernel.org
Cc:     rjarry@redhat.com, Anthony Harivel <aharivel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christophe Fontaine <cfontain@redhat.com>
Subject: [RFC] KVM: x86: Give host userspace control for MSR_RAPL_POWER_UNIT and MSR_PKG_POWER_STATUS
Date:   Wed, 18 Jan 2023 15:21:23 +0100
Message-Id: <20230118142123.461247-1-aharivel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow userspace to update the MSR_RAPL_POWER_UNIT and
MSR_PKG_POWER_STATUS powercap registers. By default, these MSRs still
return 0.

This enables VMMs running on top of KVM with access to energy metrics
like /sys/devices/virtual/powercap/*/*/energy_uj to compute VMs power
values in proportion with other metrics (e.g. CPU %guest, steal time,
etc.) and periodically update the MSRs with ioctl KVM_SET_MSRS so that
the guest OS can consume them using power metering tools.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christophe Fontaine <cfontain@redhat.com>
Signed-off-by: Anthony Harivel <aharivel@redhat.com>
---

Notes:
    The main goal of this patch is to bring a first step to give energy
    awareness to VMs.
    
    As of today, KVM always report 0 in these MSRs since the entire host
    power consumption needs to be hidden from the guests. However, there is
    no fallback mechanism for VMs to measure their power usage.
    
    The idea is to let the VMMs running on top of KVM periodically update
    those MSRs with representative values of the VM's power consumption.
    
    If this solution is accepted, VMMs like QEMU will need to be patched to
    set proper values in these registers and enable power metering in
    guests.
    
    I am submitting this as an RFC to get input/feedback from a broader
    audience who may be aware of potential side effects of such a mechanism.
    
    Regards,
    Anthony
    
    "If you can’t measure it, you can’t improve it." – Lord Kelvin

 arch/x86/include/asm/kvm_host.h |  4 ++++
 arch/x86/kvm/x86.c              | 18 ++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6aaae18f1854..c6072915f229 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1006,6 +1006,10 @@ struct kvm_vcpu_arch {
 	 */
 	bool pdptrs_from_userspace;
 
+	/* Powercap related MSRs */
+	u64 msr_rapl_power_unit;
+	u64 msr_pkg_energy_status;
+
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t hv_root_tdp;
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index da4bbd043a7b..adc89144f84f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1528,6 +1528,10 @@ static const u32 emulated_msrs_all[] = {
 
 	MSR_K7_HWCR,
 	MSR_KVM_POLL_CONTROL,
+
+	/* The following MSRs can be updated by the userspace */
+	MSR_RAPL_POWER_UNIT,
+	MSR_PKG_ENERGY_STATUS,
 };
 
 static u32 emulated_msrs[ARRAY_SIZE(emulated_msrs_all)];
@@ -3888,6 +3892,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * as to-be-saved, even if an MSRs isn't fully supported.
 		 */
 		return !msr_info->host_initiated || data;
+	case MSR_RAPL_POWER_UNIT:
+		vcpu->arch.msr_rapl_power_unit = data;
+		break;
+	case MSR_PKG_ENERGY_STATUS:
+		vcpu->arch.msr_pkg_energy_status = data;
+		break;
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
@@ -3973,13 +3983,17 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	 * data here. Do not conditionalize this on CPUID, as KVM does not do
 	 * so for existing CPU-specific MSRs.
 	 */
-	case MSR_RAPL_POWER_UNIT:
 	case MSR_PP0_ENERGY_STATUS:	/* Power plane 0 (core) */
 	case MSR_PP1_ENERGY_STATUS:	/* Power plane 1 (graphics uncore) */
-	case MSR_PKG_ENERGY_STATUS:	/* Total package */
 	case MSR_DRAM_ENERGY_STATUS:	/* DRAM controller */
 		msr_info->data = 0;
 		break;
+	case MSR_RAPL_POWER_UNIT:
+		msr_info->data = vcpu->arch.msr_rapl_power_unit;
+		break;
+	case MSR_PKG_ENERGY_STATUS:	/* Total package */
+		msr_info->data = vcpu->arch.msr_pkg_energy_status;
+		break;
 	case MSR_IA32_PEBS_ENABLE:
 	case MSR_IA32_DS_AREA:
 	case MSR_PEBS_DATA_CFG:
-- 
2.39.0

