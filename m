Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E32461153
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 10:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344204AbhK2Jwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 04:52:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40065 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245681AbhK2Jui (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Nov 2021 04:50:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638179241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0qUJTyJu6gcW2XuY0aJhl0MQXWjW8+1IUhO0WvrIMxs=;
        b=OWUybVVXGpNm3Oap3DQoeHa07CqjDcw+BW4BXNfMYIypAlId0Lo13fepECucH0yo/gfyDI
        2dBOFgShRpXYdBaU56SdczGEyJ+/aGMMo+hb/yl8TEQE/bxZOtCC2CmA8ILObFOwVGNLcY
        7caBtR3y3zwufPJ9OBfe5bLAQ/5fd4A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-Ysq5TsKkNoqgTxHGAaKEfg-1; Mon, 29 Nov 2021 04:47:17 -0500
X-MC-Unique: Ysq5TsKkNoqgTxHGAaKEfg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4FED18C89D9;
        Mon, 29 Nov 2021 09:47:16 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.195.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 939C95D6B1;
        Mon, 29 Nov 2021 09:47:15 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/4] KVM: nVMX: Track whether changes in L0 require MSR bitmap for L2 to be rebuilt
Date:   Mon, 29 Nov 2021 10:47:03 +0100
Message-Id: <20211129094704.326635-4-vkuznets@redhat.com>
In-Reply-To: <20211129094704.326635-1-vkuznets@redhat.com>
References: <20211129094704.326635-1-vkuznets@redhat.com>
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
index 95f3823b3a9d..2fe26fc4a4d5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -672,6 +672,8 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 
 	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
 
+	vmx->nested.force_msr_bitmap_recalc = false;
+
 	return true;
 }
 
@@ -2029,10 +2031,13 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
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
 
@@ -5258,6 +5263,7 @@ static void set_current_vmptr(struct vcpu_vmx *vmx, gpa_t vmptr)
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
 	}
 	vmx->nested.dirty_vmcs12 = true;
+	vmx->nested.force_msr_bitmap_recalc = true;
 }
 
 /* Emulate the VMPTRLD instruction */
@@ -6393,6 +6399,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		goto error_guest_mode;
 
 	vmx->nested.dirty_vmcs12 = true;
+	vmx->nested.force_msr_bitmap_recalc = true;
 	ret = nested_vmx_enter_non_root_mode(vcpu, false);
 	if (ret)
 		goto error_guest_mode;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4bd1c5746fe0..cf1368724540 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3697,6 +3697,8 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
 	 */
 	if (static_branch_unlikely(&enable_evmcs))
 		evmcs_touch_msr_bitmap();
+
+	vmx->nested.force_msr_bitmap_recalc = true;
 }
 
 void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index f978699480e3..6c2c1aff1c3d 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -158,6 +158,15 @@ struct nested_vmx {
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
2.33.1

