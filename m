Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26CB83B18FC
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 13:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhFWLdY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 07:33:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37267 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231168AbhFWLdR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 07:33:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624447859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a+VbfBqva2ZepZH50mdoNvto+ALQgMugS30ADzU4me0=;
        b=WKTZwDCzm9pYetcsM1vYlp3D2l5fVNDZzz7eaIWnViZDTI3kqPZKwkmi+FIOzEQLtqB/9A
        5HMIfTD/CepDRbwUDHif9pUqvVMJchE8c9/Fsu5UO6+g/x3v9ccsiBqh2+zFdtcr+7ThV2
        gdyNXuYByLygMZGv2N3owZOcm28f2Bw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-VefzVtE3P5OELzTcYFhQVA-1; Wed, 23 Jun 2021 07:30:58 -0400
X-MC-Unique: VefzVtE3P5OELzTcYFhQVA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37C51362FE;
        Wed, 23 Jun 2021 11:30:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C0935D740;
        Wed, 23 Jun 2021 11:30:49 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)),
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 10/10] KVM: x86: hyper-v: Deactivate APICv only when AutoEOI feature is in use
Date:   Wed, 23 Jun 2021 14:30:02 +0300
Message-Id: <20210623113002.111448-11-mlevitsk@redhat.com>
In-Reply-To: <20210623113002.111448-1-mlevitsk@redhat.com>
References: <20210623113002.111448-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

APICV_INHIBIT_REASON_HYPERV is currently unconditionally forced upon
SynIC activation as SynIC's AutoEOI is incompatible with APICv/AVIC. It is,
however, possible to track whether the feature was actually used by the
guest and only inhibit APICv/AVIC when needed.

TLFS suggests a dedicated 'HV_DEPRECATING_AEOI_RECOMMENDED' flag to let
Windows know that AutoEOI feature should be avoided. While it's up to
KVM userspace to set the flag, KVM can help a bit by exposing global
APICv/AVIC enablement: in case APICv/AVIC usage is impossible, AutoEOI
is still preferred.

Maxim:
   - Drop SRCU lock around the call to kvm_request_apicv_update
     to avoid deadlock.
   - Always set HV_DEPRECATING_AEOI_RECOMMENDED in kvm_get_hv_cpuid,
     since this feature can be used regardless of APICv.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/hyperv.c           | 34 +++++++++++++++++++++++++++------
 2 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9ed5c55be352..9eb78ec6a290 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -956,6 +956,9 @@ struct kvm_hv {
 	/* How many vCPUs have VP index != vCPU index */
 	atomic_t num_mismatched_vp_indexes;
 
+	/* How many SynICs use 'AutoEOI' feature */
+	atomic_t synic_auto_eoi_used;
+
 	struct hv_partition_assist_pg *hv_pa_pg;
 	struct kvm_hv_syndbg hv_syndbg;
 };
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index b07592ca92f0..6bf47a583d0e 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -85,9 +85,22 @@ static bool synic_has_vector_auto_eoi(struct kvm_vcpu_hv_synic *synic,
 	return false;
 }
 
+
+static void synic_toggle_avic(struct kvm_vcpu *vcpu, bool activate)
+{
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+	kvm_request_apicv_update(vcpu->kvm, activate,
+			APICV_INHIBIT_REASON_HYPERV);
+	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+}
+
 static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 				int vector)
 {
+	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
+	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
+	int auto_eoi_old, auto_eoi_new;
+
 	if (vector < HV_SYNIC_FIRST_VALID_VECTOR)
 		return;
 
@@ -96,10 +109,23 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 	else
 		__clear_bit(vector, synic->vec_bitmap);
 
+	auto_eoi_old = bitmap_weight(synic->auto_eoi_bitmap, 256);
+
 	if (synic_has_vector_auto_eoi(synic, vector))
 		__set_bit(vector, synic->auto_eoi_bitmap);
 	else
 		__clear_bit(vector, synic->auto_eoi_bitmap);
+
+	auto_eoi_new = bitmap_weight(synic->auto_eoi_bitmap, 256);
+
+	/* Hyper-V SynIC auto EOI SINTs are not compatible with APICV */
+	if (!auto_eoi_old && auto_eoi_new) {
+		if (atomic_inc_return(&hv->synic_auto_eoi_used) == 1)
+			synic_toggle_avic(vcpu, false);
+	} else if (!auto_eoi_new && auto_eoi_old) {
+		if (atomic_dec_return(&hv->synic_auto_eoi_used) == 0)
+			synic_toggle_avic(vcpu, true);
+	}
 }
 
 static int synic_set_sint(struct kvm_vcpu_hv_synic *synic, int sint,
@@ -933,12 +959,6 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
 
 	synic = to_hv_synic(vcpu);
 
-	/*
-	 * Hyper-V SynIC auto EOI SINT's are
-	 * not compatible with APICV, so request
-	 * to deactivate APICV permanently.
-	 */
-	kvm_request_apicv_update(vcpu->kvm, false, APICV_INHIBIT_REASON_HYPERV);
 	synic->active = true;
 	synic->dont_zero_synic_pages = dont_zero_synic_pages;
 	synic->control = HV_SYNIC_CONTROL_ENABLE;
@@ -2466,6 +2486,8 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 				ent->eax |= HV_X64_ENLIGHTENED_VMCS_RECOMMENDED;
 			if (!cpu_smt_possible())
 				ent->eax |= HV_X64_NO_NONARCH_CORESHARING;
+
+			ent->eax |= HV_DEPRECATING_AEOI_RECOMMENDED;
 			/*
 			 * Default number of spinlock retry attempts, matches
 			 * HyperV 2016.
-- 
2.26.3

