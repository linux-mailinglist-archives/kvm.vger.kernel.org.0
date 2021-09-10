Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7441406EED
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 18:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbhIJQJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 12:09:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31629 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229524AbhIJQIE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Sep 2021 12:08:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631290012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nZ9m8GB+SRNPd987F+aUm8xDcHRH1ey6FXHn0bKLQqE=;
        b=exAl4z7ygeI3S/EUkHFOvvDQIBwxL9bMQK/dFraN9NoywkH77sKoIjAhNmLm40BrdFXRci
        d7PaWRb4zHcYaPKeJvHRLBtB2lhpG0QOFg3PG5+ZGtYw8AnRrAsB7bdKL1bG7IL9ovluRM
        oQYNqL1YqSf4rONuU4OnQ6wGFodRmOc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-z7KQJQ2hP6S8PJA48x5-ug-1; Fri, 10 Sep 2021 12:06:51 -0400
X-MC-Unique: z7KQJQ2hP6S8PJA48x5-ug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7871B1084682;
        Fri, 10 Sep 2021 16:06:50 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D18B5C1A1;
        Fri, 10 Sep 2021 16:06:48 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] KVM: nVMX: Implement Enlightened MSR Bitmap feature
Date:   Fri, 10 Sep 2021 18:06:33 +0200
Message-Id: <20210910160633.451250-5-vkuznets@redhat.com>
In-Reply-To: <20210910160633.451250-1-vkuznets@redhat.com>
References: <20210910160633.451250-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Updating MSR bitmap for L2 is not cheap and rearly needed. TLFS for Hyper-V
offers 'Enlightened MSR Bitmap' feature which allows L1 hypervisor to
inform L0 when it changes MSR bitmap, this eliminates the need to examine
L1's MSR bitmap for L2 every time when 'real' MSR bitmap for L2 gets
constructed.

Use 'vmx->nested.msr_bitmap_changed' flag to implement the feature.

Note, KVM already uses 'Enlightened MSR bitmap' feature when it runs as a
nested hypervisor on top of Hyper-V. The newly introduced feature is going
to be used by Hyper-V guests on KVM.

When the feature is enabled for Win10+WSL2, it shaves off around 700 CPU
cycles from a nested vmexit cost (tight cpuid loop test).

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c     |  2 ++
 arch/x86/kvm/vmx/nested.c | 19 +++++++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 232a86a6faaf..7124dbe79ac2 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2517,6 +2517,8 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 
 		case HYPERV_CPUID_NESTED_FEATURES:
 			ent->eax = evmcs_ver;
+			if (evmcs_ver)
+				ent->eax |= HV_X64_NESTED_MSR_BITMAP;
 
 			break;
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 42cd95611892..5ac5ba2f6191 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -607,15 +607,30 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 						 struct vmcs12 *vmcs12)
 {
 	int msr;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long *msr_bitmap_l1;
-	unsigned long *msr_bitmap_l0 = to_vmx(vcpu)->nested.vmcs02.msr_bitmap;
-	struct kvm_host_map *map = &to_vmx(vcpu)->nested.msr_bitmap_map;
+	unsigned long *msr_bitmap_l0 = vmx->nested.vmcs02.msr_bitmap;
+	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
+	struct kvm_host_map *map = &vmx->nested.msr_bitmap_map;
 
 	/* Nothing to do if the MSR bitmap is not in use.  */
 	if (!cpu_has_vmx_msr_bitmap() ||
 	    !nested_cpu_has(vmcs12, CPU_BASED_USE_MSR_BITMAPS))
 		return false;
 
+	/*
+	 * MSR bitmap update can be skipped when:
+	 * - MSR bitmap for L1 hasn't changed.
+	 * - Nested hypervisor (L1) is attempting to launch the same L2 as
+	 *   before.
+	 * - Nested hypervisor (L1) has enabled 'Enlightened MSR Bitmap' feature
+	 *   and tells KVM (L0) there were no changes in MSR bitmap for L2.
+	 */
+	if (!vmx->nested.msr_bitmap_changed && evmcs &&
+	    evmcs->hv_enlightenments_control.msr_bitmap &&
+	    evmcs->hv_clean_fields & HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP)
+		return true;
+
 	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->msr_bitmap), map))
 		return false;
 
-- 
2.31.1

