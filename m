Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61692406EE0
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 18:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbhIJQJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 12:09:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46438 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229714AbhIJQIC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Sep 2021 12:08:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631290010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OvdDJP6dp/HxZOCJKCR/V7o9pdTZRaIJAcWcVkYQDnQ=;
        b=QJ+jbXlEsNM9xh6LnN7puKlfFuOTM2JZM+jJ/P9thvA0YbtD+tFymygKZeZFYuNxTm4O8s
        dE3W9gcOOehTs2PNsajUHP9ELaNlnhX5FpgmBu/Vchp/25xvrkEIZycJ8epPGRumhCU0Y+
        oGeG/cUs5pkOCNDbxhKhEw7l7kuhvlE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-tsYmb-5eP4G3hB68pGzgIg-1; Fri, 10 Sep 2021 12:06:49 -0400
X-MC-Unique: tsYmb-5eP4G3hB68pGzgIg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BD6B835DE6;
        Fri, 10 Sep 2021 16:06:48 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6760A5C1A1;
        Fri, 10 Sep 2021 16:06:46 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] KVM: nVMX: Track whether changes in L0 require MSR bitmap for L2 to be rebuilt
Date:   Fri, 10 Sep 2021 18:06:32 +0200
Message-Id: <20210910160633.451250-4-vkuznets@redhat.com>
In-Reply-To: <20210910160633.451250-1-vkuznets@redhat.com>
References: <20210910160633.451250-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a flag to keep track of whether MSR bitmap for L2 needs to be
rebuilt due to changes in MSR bitmap for L1 or switching to a different
L2. This information will be used for Enlightened MSR Bitmap feature for
Hyper-V guests.

Note, setting msr_bitmap_changed to 'true' from set_current_vmptr() is
not really needed for Enlightened MSR Bitmap as the feature can only
be used in conjunction with Enlightened VMCS but let's keep tracking
information complete, it's cheap and in the future similar PV feature can
easily be implemented for KVM on KVM too.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 9 ++++++++-
 arch/x86/kvm/vmx/vmx.c    | 2 ++
 arch/x86/kvm/vmx/vmx.h    | 6 ++++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ccb03d69546c..42cd95611892 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2053,10 +2053,13 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 	 * Clean fields data can't be used on VMLAUNCH and when we switch
 	 * between different L2 guests as KVM keeps a single VMCS12 per L1.
 	 */
-	if (from_launch || evmcs_gpa_changed)
+	if (from_launch || evmcs_gpa_changed) {
 		vmx->nested.hv_evmcs->hv_clean_fields &=
 			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 
+		vmx->nested.msr_bitmap_changed = true;
+	}
+
 	return EVMPTRLD_SUCCEEDED;
 }
 
@@ -3240,6 +3243,8 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 	else
 		exec_controls_clearbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
 
+	vmx->nested.msr_bitmap_changed = false;
+
 	return true;
 }
 
@@ -5273,6 +5278,7 @@ static void set_current_vmptr(struct vcpu_vmx *vmx, gpa_t vmptr)
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
 	}
 	vmx->nested.dirty_vmcs12 = true;
+	vmx->nested.msr_bitmap_changed = true;
 }
 
 /* Emulate the VMPTRLD instruction */
@@ -6393,6 +6399,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		goto error_guest_mode;
 
 	vmx->nested.dirty_vmcs12 = true;
+	vmx->nested.msr_bitmap_changed = true;
 	ret = nested_vmx_enter_non_root_mode(vcpu, false);
 	if (ret)
 		goto error_guest_mode;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ad33032e8588..2dbfb5d838db 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3734,6 +3734,8 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
 	 */
 	if (static_branch_unlikely(&enable_evmcs))
 		evmcs_touch_msr_bitmap();
+
+	vmx->nested.msr_bitmap_changed = true;
 }
 
 void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 4858c5fd95f2..b6596fc2943a 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -148,6 +148,12 @@ struct nested_vmx {
 	bool need_vmcs12_to_shadow_sync;
 	bool dirty_vmcs12;
 
+	/*
+	 * Indicates whether MSR bitmap for L2 needs to be rebuilt due to
+	 * changes in MSR bitmap for L1 or switching to a different L2.
+	 */
+	bool msr_bitmap_changed;
+
 	/*
 	 * Indicates lazily loaded guest state has not yet been decached from
 	 * vmcs02.
-- 
2.31.1

