Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F216944B132
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 17:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240186AbhKIQby (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 11:31:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52555 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240006AbhKIQbv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Nov 2021 11:31:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636475344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iKy55mKV1NzfbvfbGh+De+/qOmp0zhljJZrMrc5hoRw=;
        b=IkGTYOHkM2AI3AgtGnAmYf0G+BrDE9aGytlaH7xnAW1+dApZbVQUzVGVNxCGgptQwWGiZw
        rUZ5s34MkCIGyk801gSQQ4yutnxxUZiCx/5wu4Mr5G05c1FuDdMZP2fPcQ79tSk5R4Z0d1
        A/vyKB5dxEy9Oj0sCzAT7IHq2vtoLrU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-8F0seZgEO-WRBFhDrbImKQ-1; Tue, 09 Nov 2021 11:29:01 -0500
X-MC-Unique: 8F0seZgEO-WRBFhDrbImKQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B2B415722;
        Tue,  9 Nov 2021 16:29:00 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3953A62A44;
        Tue,  9 Nov 2021 16:28:58 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 7/8] KVM: nVMX: Track whether changes in L0 require MSR bitmap for L2 to be rebuilt
Date:   Tue,  9 Nov 2021 17:28:34 +0100
Message-Id: <20211109162835.99475-8-vkuznets@redhat.com>
In-Reply-To: <20211109162835.99475-1-vkuznets@redhat.com>
References: <20211109162835.99475-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
 arch/x86/kvm/vmx/vmx.h    | 9 +++++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 341c50816822..f02e846c944a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -664,6 +664,8 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 
 	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
 
+	vmx->nested.force_msr_bitmap_recalc = false;
+
 	return true;
 }
 
@@ -2018,10 +2020,13 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 	 * Clean fields data can't be used on VMLAUNCH and when we switch
 	 * between different L2 guests as KVM keeps a single VMCS12 per L1.
 	 */
-	if (from_launch || evmcs_gpa_changed)
+	if (from_launch || evmcs_gpa_changed) {
 		vmx->nested.hv_evmcs->hv_clean_fields &=
 			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 
+		vmx->nested.force_msr_bitmap_recalc = true;
+	}
+
 	return EVMPTRLD_SUCCEEDED;
 }
 
@@ -5238,6 +5243,7 @@ static void set_current_vmptr(struct vcpu_vmx *vmx, gpa_t vmptr)
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
 	}
 	vmx->nested.dirty_vmcs12 = true;
+	vmx->nested.force_msr_bitmap_recalc = true;
 }
 
 /* Emulate the VMPTRLD instruction */
@@ -6364,6 +6370,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		goto error_guest_mode;
 
 	vmx->nested.dirty_vmcs12 = true;
+	vmx->nested.force_msr_bitmap_recalc = true;
 	ret = nested_vmx_enter_non_root_mode(vcpu, false);
 	if (ret)
 		goto error_guest_mode;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1e6bf2cd7be0..ec6635d1bcc4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3686,6 +3686,8 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
 	 */
 	if (static_branch_unlikely(&enable_evmcs))
 		evmcs_touch_msr_bitmap();
+
+	vmx->nested.force_msr_bitmap_recalc = true;
 }
 
 void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 86c093da0d63..8ad23f94917d 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -148,6 +148,15 @@ struct nested_vmx {
 	bool need_vmcs12_to_shadow_sync;
 	bool dirty_vmcs12;
 
+	/*
+	 * Indicates whether MSR bitmap for L2 needs to be rebuilt due to
+	 * changes in MSR bitmap for L1 or switching to a different L2. Note,
+	 * this flag can only be used reliably in conjunction with a paravirt L1
+	 * which informs L0 whether any changes to MSR bitmap for L2 were done
+	 * on its side.
+	 */
+	bool force_msr_bitmap_recalc;
+
 	/*
 	 * Indicates lazily loaded guest state has not yet been decached from
 	 * vmcs02.
-- 
2.31.1

