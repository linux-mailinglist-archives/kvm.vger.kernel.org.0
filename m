Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673E137F6E3
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 13:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbhEMLix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 07:38:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20848 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233462AbhEMLif (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 May 2021 07:38:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620905845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=POOI9TCezc4J5RJIxcGbqShjc8zde1SEv1yU+Nd1U/A=;
        b=IE8FZww4CW7XMKunzZuyaRrCFDIprnZW2azb1HYqypQKAGuSSAsMfwOcRa6LZ0uGyu8F6w
        eoXfQ7htgseVGng2o88Lpf6PdlCUQNn40u6bMr00sK9MjQYMWnksQkOZeGI7vTBOSNOHsZ
        yuyW9IGkC6FFFuRMm8wf36Ue7WwotWU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-FwTgx3IBPfy3bDywU2sc7Q-1; Thu, 13 May 2021 07:37:21 -0400
X-MC-Unique: FwTgx3IBPfy3bDywU2sc7Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78E518015DB;
        Thu, 13 May 2021 11:37:20 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4183010074E5;
        Thu, 13 May 2021 11:37:18 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Kechen Lu <kechenl@nvidia.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: x86: hyper-v: Deactivate APICv only when AutoEOI feature is in use
Date:   Thu, 13 May 2021 13:37:10 +0200
Message-Id: <20210513113710.1740398-3-vkuznets@redhat.com>
In-Reply-To: <20210513113710.1740398-1-vkuznets@redhat.com>
References: <20210513113710.1740398-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

APICV_INHIBIT_REASON_HYPERV is currently unconditionally forced upon
SynIC activation as SynIC's AutoEOI is incompatible with APICv/AVIC. It is,
however, possible to track whether the feature was actually used by the
guest and only inhibit APICv/AVIC when needed.

TLFS suggests a dedicated 'HV_DEPRECATING_AEOI_RECOMMENDED' flag to let
Windows know that AutoEOI feature should be avoided. While it's up to
KVM userspace to set the flag, KVM can help a bit by exposing global
APICv/AVIC enablement: in case APICv/AVIC usage is impossible, AutoEOI
is still preferred.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/hyperv.c           | 27 +++++++++++++++++++++------
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ffafdb7b24cb..98391c9c18df 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -936,6 +936,9 @@ struct kvm_hv {
 	/* How many vCPUs have VP index != vCPU index */
 	atomic_t num_mismatched_vp_indexes;
 
+	/* How many SynICs use 'AutoEOI' feature */
+	atomic_t synic_auto_eoi_used;
+
 	struct hv_partition_assist_pg *hv_pa_pg;
 	struct kvm_hv_syndbg hv_syndbg;
 };
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index f98370a39936..e1ecc2143794 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -87,6 +87,10 @@ static bool synic_has_vector_auto_eoi(struct kvm_vcpu_hv_synic *synic,
 static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 				int vector)
 {
+	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
+	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
+	int auto_eoi_old, auto_eoi_new;
+
 	if (vector < HV_SYNIC_FIRST_VALID_VECTOR)
 		return;
 
@@ -95,10 +99,25 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
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
+						 APICV_INHIBIT_REASON_HYPERV);
+	} else if (!auto_eoi_new && auto_eoi_old) {
+		if (atomic_dec_return(&hv->synic_auto_eoi_used) == 0)
+			kvm_request_apicv_update(vcpu->kvm, true,
+						 APICV_INHIBIT_REASON_HYPERV);
+	}
 }
 
 static int synic_set_sint(struct kvm_vcpu_hv_synic *synic, int sint,
@@ -931,12 +950,6 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
 
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
@@ -2198,6 +2211,8 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 				ent->eax |= HV_X64_ENLIGHTENED_VMCS_RECOMMENDED;
 			if (!cpu_smt_possible())
 				ent->eax |= HV_X64_NO_NONARCH_CORESHARING;
+			if (kvm_x86_ops.apicv_supported())
+				ent->eax |= HV_DEPRECATING_AEOI_RECOMMENDED;
 			/*
 			 * Default number of spinlock retry attempts, matches
 			 * HyperV 2016.
-- 
2.31.1

