Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488EF3647A5
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 18:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241979AbhDSQCQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 12:02:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21193 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241922AbhDSQCM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 12:02:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618848102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hDjTFU4u3Q5yKNWC/K1UCc4KX527vLKY4RfKABhPVx8=;
        b=RzARej9BCuEdkmNsBasmc0tvLNlLa362gmIiXuZT1zQF89VAWWbNWYUNUEK/DbYHsXMBDn
        wZBeD2dpHwOKGHzRx3WH7omJ8qesSNiQ0z2kfX4mrkbjwT6KxPuvo4lcGNrn569Recvs7b
        DMUR5q8Dzia8kXQZ0rrn6wAhQnJ8DDc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-j2DCp_R8OhKBcS32uFlPrQ-1; Mon, 19 Apr 2021 12:01:39 -0400
X-MC-Unique: j2DCp_R8OhKBcS32uFlPrQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 825011922043;
        Mon, 19 Apr 2021 16:01:38 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A744460636;
        Mon, 19 Apr 2021 16:01:36 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/30] KVM: x86: hyper-v: Cache guest CPUID leaves determining features availability
Date:   Mon, 19 Apr 2021 18:01:00 +0200
Message-Id: <20210419160127.192712-4-vkuznets@redhat.com>
In-Reply-To: <20210419160127.192712-1-vkuznets@redhat.com>
References: <20210419160127.192712-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Limiting exposed Hyper-V features requires a fast way to check if the
particular feature is exposed in guest visible CPUIDs or not. To aboid
looping through all CPUID entries on every hypercall/MSR access cache
the required leaves on CPUID update.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  8 ++++++
 arch/x86/kvm/hyperv.c           | 49 ++++++++++++++++++++++++++-------
 2 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dc40897c41bc..6525d2716b09 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -531,6 +531,14 @@ struct kvm_vcpu_hv {
 	DECLARE_BITMAP(stimer_pending_bitmap, HV_SYNIC_STIMER_COUNT);
 	cpumask_t tlb_flush;
 	bool enforce_cpuid;
+	struct {
+		u32 features_eax; /* HYPERV_CPUID_FEATURES.EAX */
+		u32 features_ebx; /* HYPERV_CPUID_FEATURES.EBX */
+		u32 features_edx; /* HYPERV_CPUID_FEATURES.EDX */
+		u32 enlightenments_eax; /* HYPERV_CPUID_ENLIGHTMENT_INFO.EAX */
+		u32 enlightenments_ebx; /* HYPERV_CPUID_ENLIGHTMENT_INFO.EBX */
+		u32 syndbg_cap_eax; /* HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX */
+	} cpuid_cache;
 };
 
 /* Xen HVM per vcpu emulation context */
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 557897c453a9..ccb298cfc933 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -273,15 +273,10 @@ static int synic_set_msr(struct kvm_vcpu_hv_synic *synic,
 
 static bool kvm_hv_is_syndbg_enabled(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpuid_entry2 *entry;
-
-	entry = kvm_find_cpuid_entry(vcpu,
-				     HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES,
-				     0);
-	if (!entry)
-		return false;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 
-	return entry->eax & HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING;
+	return hv_vcpu->cpuid_cache.syndbg_cap_eax &
+		HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING;
 }
 
 static int kvm_hv_syndbg_complete_userspace(struct kvm_vcpu *vcpu)
@@ -1801,12 +1796,46 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, u64 ingpa, u64 outgpa,
 void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *entry;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 
 	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_INTERFACE, 0);
-	if (entry && entry->eax == HYPERV_CPUID_SIGNATURE_EAX)
+	if (entry && entry->eax == HYPERV_CPUID_SIGNATURE_EAX) {
 		vcpu->arch.hyperv_enabled = true;
-	else
+	} else {
 		vcpu->arch.hyperv_enabled = false;
+		return;
+	}
+
+	if (!to_hv_vcpu(vcpu) && kvm_hv_vcpu_init(vcpu))
+		return;
+
+	hv_vcpu = to_hv_vcpu(vcpu);
+
+	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_FEATURES, 0);
+	if (entry) {
+		hv_vcpu->cpuid_cache.features_eax = entry->eax;
+		hv_vcpu->cpuid_cache.features_ebx = entry->ebx;
+		hv_vcpu->cpuid_cache.features_edx = entry->edx;
+	} else {
+		hv_vcpu->cpuid_cache.features_eax = 0;
+		hv_vcpu->cpuid_cache.features_ebx = 0;
+		hv_vcpu->cpuid_cache.features_edx = 0;
+	}
+
+	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_ENLIGHTMENT_INFO, 0);
+	if (entry) {
+		hv_vcpu->cpuid_cache.enlightenments_eax = entry->eax;
+		hv_vcpu->cpuid_cache.enlightenments_ebx = entry->ebx;
+	} else {
+		hv_vcpu->cpuid_cache.enlightenments_eax = 0;
+		hv_vcpu->cpuid_cache.enlightenments_ebx = 0;
+	}
+
+	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES, 0);
+	if (entry)
+		hv_vcpu->cpuid_cache.syndbg_cap_eax = entry->eax;
+	else
+		hv_vcpu->cpuid_cache.syndbg_cap_eax = 0;
 }
 
 int kvm_hv_set_enforce_cpuid(struct kvm_vcpu *vcpu, bool enforce)
-- 
2.30.2

