Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F15F42C2EF
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236921AbhJMOZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:25:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22603 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235840AbhJMOZW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 10:25:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634134992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YcbIaIFmLcSI/vhU67IBzzFPXVlkOAtf5s1w+5KgaeI=;
        b=ijgFyrXrOLfOhNfgMiMAAwXhkb7smv3icr3NtG8COeixIfK2sgfbzu1CUKnP/spGxtQbm/
        KBpMBPTHXV2jHRMMzWSHvZaz9O3zTRzOuegHrORGOMgFa7licQkqAcaR503KiCUcsKx2g7
        1NkXNwnfn+40aQQAL7B8CCSxq8pMztc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-vt2A9PADP5Wtm2ncfClzmQ-1; Wed, 13 Oct 2021 10:23:10 -0400
X-MC-Unique: vt2A9PADP5Wtm2ncfClzmQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 747761006AA2;
        Wed, 13 Oct 2021 14:23:09 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E42157CA5;
        Wed, 13 Oct 2021 14:23:07 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] KVM: nVMX: Track whether changes in L0 require MSR bitmap for L2 to be rebuilt
Date:   Wed, 13 Oct 2021 16:22:57 +0200
Message-Id: <20211013142258.1738415-4-vkuznets@redhat.com>
In-Reply-To: <20211013142258.1738415-1-vkuznets@redhat.com>
References: <20211013142258.1738415-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
index af1bbb73430a..bf4fa63ed371 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -700,6 +700,8 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 
 	kvm_vcpu_unmap(vcpu, &to_vmx(vcpu)->nested.msr_bitmap_map, false);
 
+	vmx->nested.msr_bitmap_force_recalc = false;
+
 	return true;
 }
 
@@ -2054,10 +2056,13 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 	 * Clean fields data can't be used on VMLAUNCH and when we switch
 	 * between different L2 guests as KVM keeps a single VMCS12 per L1.
 	 */
-	if (from_launch || evmcs_gpa_changed)
+	if (from_launch || evmcs_gpa_changed) {
 		vmx->nested.hv_evmcs->hv_clean_fields &=
 			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 
+		vmx->nested.msr_bitmap_force_recalc = true;
+	}
+
 	return EVMPTRLD_SUCCEEDED;
 }
 
@@ -5274,6 +5279,7 @@ static void set_current_vmptr(struct vcpu_vmx *vmx, gpa_t vmptr)
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
 	}
 	vmx->nested.dirty_vmcs12 = true;
+	vmx->nested.msr_bitmap_force_recalc = true;
 }
 
 /* Emulate the VMPTRLD instruction */
@@ -6400,6 +6406,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		goto error_guest_mode;
 
 	vmx->nested.dirty_vmcs12 = true;
+	vmx->nested.msr_bitmap_force_recalc = true;
 	ret = nested_vmx_enter_non_root_mode(vcpu, false);
 	if (ret)
 		goto error_guest_mode;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3fdaaef291e8..c78c315def59 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3735,6 +3735,8 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
 	 */
 	if (static_branch_unlikely(&enable_evmcs))
 		evmcs_touch_msr_bitmap();
+
+	vmx->nested.msr_bitmap_force_recalc = true;
 }
 
 void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 592217fd7d92..2cdf66e6d1b0 100644
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
+	bool msr_bitmap_force_recalc;
+
 	/*
 	 * Indicates lazily loaded guest state has not yet been decached from
 	 * vmcs02.
-- 
2.31.1

