Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5D63DDF4F
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 20:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhHBSej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 14:34:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41452 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230476AbhHBSe3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 14:34:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627929258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yCQmkgEYVr5JS2a+oZWJBe5wJdCYRMuNflWXlTknMwU=;
        b=fUEe5tbufxda3HTwJ9eBgS00fOS+mtvVwtXIxiY4Rph9txZc6Xn8lcxogWm3F/thszp2cU
        CDcpNoYrqLPzzlcFH9zkJ0wKeHypPcQ0QwbNRnQ/GhR6M9kv1XOLxug0LHSiSbCbdkYTyk
        wrY+gnCVYIwx7y6MzKphvOlLV6iX/VE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-ouG2-4alN9mUnc4gdhynaQ-1; Mon, 02 Aug 2021 14:34:14 -0400
X-MC-Unique: ouG2-4alN9mUnc4gdhynaQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5587801E72;
        Mon,  2 Aug 2021 18:34:12 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4601E3B02;
        Mon,  2 Aug 2021 18:34:09 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 09/12] KVM: x86: hyper-v: Deactivate APICv only when AutoEOI feature is in use
Date:   Mon,  2 Aug 2021 21:33:26 +0300
Message-Id: <20210802183329.2309921-10-mlevitsk@redhat.com>
In-Reply-To: <20210802183329.2309921-1-mlevitsk@redhat.com>
References: <20210802183329.2309921-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
APICv/AVIC enablement.

Maxim:
   - always set HV_DEPRECATING_AEOI_RECOMMENDED in kvm_get_hv_cpuid,
     since this feature can be used regardless of AVIC

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/hyperv.c           | 27 +++++++++++++++++++++------
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 80323b5fb20a..55b1f79d9c43 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -988,6 +988,9 @@ struct kvm_hv {
 	/* How many vCPUs have VP index != vCPU index */
 	atomic_t num_mismatched_vp_indexes;
 
+	/* How many SynICs use 'AutoEOI' feature */
+	atomic_t synic_auto_eoi_used;
+
 	struct hv_partition_assist_pg *hv_pa_pg;
 	struct kvm_hv_syndbg hv_syndbg;
 };
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index b07592ca92f0..638f3c559623 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -88,6 +88,10 @@ static bool synic_has_vector_auto_eoi(struct kvm_vcpu_hv_synic *synic,
 static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 				int vector)
 {
+	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
+	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
+	int auto_eoi_old, auto_eoi_new;
+
 	if (vector < HV_SYNIC_FIRST_VALID_VECTOR)
 		return;
 
@@ -96,10 +100,25 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
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
+			kvm_request_apicv_update(vcpu->kvm, false,
+						APICV_INHIBIT_REASON_HYPERV);
+	} else if (!auto_eoi_new && auto_eoi_old) {
+		if (atomic_dec_return(&hv->synic_auto_eoi_used) == 0)
+			kvm_request_apicv_update(vcpu->kvm, true,
+						APICV_INHIBIT_REASON_HYPERV);
+	}
 }
 
 static int synic_set_sint(struct kvm_vcpu_hv_synic *synic, int sint,
@@ -933,12 +952,6 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
 
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
@@ -2466,6 +2479,8 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
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

