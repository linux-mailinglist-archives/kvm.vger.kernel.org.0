Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A105344B135
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 17:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240484AbhKIQcM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 11:32:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40407 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240036AbhKIQb5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Nov 2021 11:31:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636475351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jTjE39e8jakWt8Alz/259TmWxOJnW+bt1WeJo+ADs6I=;
        b=Ymb8Ujcyy223sv//btrb1nYvXmsK63rOSSTGfjtWKP+Xhp2/RyF7yuTvrc4V/em3Umj9pV
        wSDq35vjHuJLQP1Tnx4sEB9U/+44p6op5XJt4bA11u8TiwDSmNYDESp08S0eIg8S5UpBtw
        avhvIh81WhYLmfEqTfUjbSNLAQHhCB8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-tmIxbONQOtK-Ot1vXfNK9g-1; Tue, 09 Nov 2021 11:29:04 -0500
X-MC-Unique: tmIxbONQOtK-Ot1vXfNK9g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A54941019984;
        Tue,  9 Nov 2021 16:29:02 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A0CB64188;
        Tue,  9 Nov 2021 16:29:00 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 8/8] KVM: nVMX: Implement Enlightened MSR Bitmap feature
Date:   Tue,  9 Nov 2021 17:28:35 +0100
Message-Id: <20211109162835.99475-9-vkuznets@redhat.com>
In-Reply-To: <20211109162835.99475-1-vkuznets@redhat.com>
References: <20211109162835.99475-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
 arch/x86/kvm/vmx/nested.c | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 4f15c0165c05..948a34139e04 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2516,6 +2516,8 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 
 		case HYPERV_CPUID_NESTED_FEATURES:
 			ent->eax = evmcs_ver;
+			if (evmcs_ver)
+				ent->eax |= HV_X64_NESTED_MSR_BITMAP;
 
 			break;
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f02e846c944a..5203810dab71 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -591,6 +591,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	int msr;
 	unsigned long *msr_bitmap_l1;
 	unsigned long *msr_bitmap_l0 = vmx->nested.vmcs02.msr_bitmap;
+	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
 	struct kvm_host_map *map = &vmx->nested.msr_bitmap_map;
 
 	/* Nothing to do if the MSR bitmap is not in use.  */
@@ -598,6 +599,19 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
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
+	if (!vmx->nested.force_msr_bitmap_recalc && evmcs &&
+	    evmcs->hv_enlightenments_control.msr_bitmap &&
+	    evmcs->hv_clean_fields & HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP)
+		return true;
+
 	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->msr_bitmap), map))
 		return false;
 
-- 
2.31.1

