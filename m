Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 874485395A3
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 19:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346344AbiEaRy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 13:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346729AbiEaRy4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 13:54:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F50278EF9
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 10:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654019694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JzZEPBs5hq9PBWM1+4wVziew8SNYys5xTSrF8ljlk6E=;
        b=ZQn/Uc+5I6TDlrRuEcB3aQPor2GspEJcP2h9+cxuqjg+s+sUVDqYSFhIySxvPY0M0vmxci
        NC8Bi9xIgd6mkSPlBljnNuq5WN6kBEJcMmMei3DEmM9AfDyWD70HDPi8L8e/pM7cjpXRxm
        QNyRj6fX9GCYmPQqQp/ZY/NSfgpRZGk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-VcvCgzjYPHe47bHRmnZBpg-1; Tue, 31 May 2022 13:54:51 -0400
X-MC-Unique: VcvCgzjYPHe47bHRmnZBpg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1128080B712;
        Tue, 31 May 2022 17:54:51 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E8B9FC23DBF;
        Tue, 31 May 2022 17:54:50 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     likexu@tencent.com
Subject: [PATCH 1/2] KVM: vmx, pmu: accept 0 for absent MSRs when host-initiated
Date:   Tue, 31 May 2022 13:54:49 -0400
Message-Id: <20220531175450.295552-2-pbonzini@redhat.com>
In-Reply-To: <20220531175450.295552-1-pbonzini@redhat.com>
References: <20220531175450.295552-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Whenever an MSR is part of KVM_GET_MSR_INDEX_LIST, as is the case for
MSR_IA32_DS_AREA, MSR_ARCH_LBR_DEPTH or MSR_ARCH_LBR_CTL, it has to be
always settable with KVM_SET_MSR.  Accept a zero value for these MSRs
to obey the contract.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 3e04d0407605..66496cb41494 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -367,8 +367,9 @@ static bool arch_lbr_depth_is_valid(struct kvm_vcpu *vcpu, u64 depth)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
-	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
-		return false;
+	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) ||
+	    !guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
+		return depth == 0;
 
 	return (depth == pmu->kvm_arch_lbr_depth);
 }
@@ -378,7 +379,7 @@ static bool arch_lbr_ctl_is_valid(struct kvm_vcpu *vcpu, u64 ctl)
 	struct kvm_cpuid_entry2 *entry;
 
 	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
-		return false;
+		return ctl == 0;
 
 	if (ctl & ~KVM_ARCH_LBR_CTL_MASK)
 		goto warn;
@@ -510,6 +511,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		break;
 	case MSR_IA32_DS_AREA:
+		if (msr_info->host_initiated && data && !guest_cpuid_has(vcpu, X86_FEATURE_DS))
+			return 1;
 		if (is_noncanonical_address(data, vcpu))
 			return 1;
 		pmu->ds_area = data;
@@ -525,7 +528,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_ARCH_LBR_DEPTH:
 		if (!arch_lbr_depth_is_valid(vcpu, data))
 			return 1;
+
 		lbr_desc->records.nr = data;
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
+			return 0;
+
 		/*
 		 * Writing depth MSR from guest could either setting the
 		 * MSR or resetting the LBR records with the side-effect.
@@ -535,6 +542,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_ARCH_LBR_CTL:
 		if (!arch_lbr_ctl_is_valid(vcpu, data))
 			break;
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
+			return 0;
 
 		vmcs_write64(GUEST_IA32_LBR_CTL, data);
 
-- 
2.31.1


