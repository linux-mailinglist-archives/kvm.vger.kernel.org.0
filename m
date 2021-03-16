Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB7C33D5E6
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 15:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236697AbhCPOig (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 10:38:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46030 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236650AbhCPOhy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 10:37:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615905473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tVHxxWU0Zpf6w6k4Imqt6vI6WtSdLUURgplrT4qpOdw=;
        b=WXcIQbH9PaFan3aaUNv2IWp+K0/XjPPa9FGeVNNZyZwS0jpskhEEn3fWUOqruWRV/3cT2w
        mAUM6GEL0JqS6R293Fi5ESPNHLlu3WUr08br0diUluH9VoUamzq2hFUY4a2SmKzGh/SjKY
        TF/7eLrHS+jeBhse4u8lY8yzNTmZ5N8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-taj8UvgNNzegh9ZSTcAisw-1; Tue, 16 Mar 2021 10:37:49 -0400
X-MC-Unique: taj8UvgNNzegh9ZSTcAisw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F070800FF0;
        Tue, 16 Mar 2021 14:37:48 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE48D5D9D3;
        Tue, 16 Mar 2021 14:37:46 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v2 3/4] KVM: x86: hyper-v: Track Hyper-V TSC page status
Date:   Tue, 16 Mar 2021 15:37:35 +0100
Message-Id: <20210316143736.964151-4-vkuznets@redhat.com>
In-Reply-To: <20210316143736.964151-1-vkuznets@redhat.com>
References: <20210316143736.964151-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create an infrastructure for tracking Hyper-V TSC page status, i.e. if it
was updated from guest/host side or if we've failed to set it up (because
e.g. guest wrote some garbage to HV_X64_MSR_REFERENCE_TSC) and there's no
need to retry.

Also, in a hypothetical situation when we are in 'always catchup' mode for
TSC we can now avoid contending 'hv->hv_lock' on every guest enter by
setting the state to HV_TSC_PAGE_BROKEN after compute_tsc_page_parameters()
returns false.

Check for HV_TSC_PAGE_SET state instead of '!hv->tsc_ref.tsc_sequence' in
get_time_ref_counter() to properly handle the situation when we failed to
write the updated TSC page values to the guest.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 10 +++++++
 arch/x86/kvm/hyperv.c           | 49 +++++++++++++++++++++++----------
 2 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9bc091ecaaeb..71b14e51fdc0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -884,12 +884,22 @@ struct kvm_hv_syndbg {
 	u64 options;
 };
 
+enum hv_tsc_page_status {
+	HV_TSC_PAGE_UNSET = 0,
+	HV_TSC_PAGE_GUEST_CHANGED,
+	HV_TSC_PAGE_HOST_CHANGED,
+	HV_TSC_PAGE_SET,
+	HV_TSC_PAGE_UPDATING,
+	HV_TSC_PAGE_BROKEN,
+};
+
 /* Hyper-V emulation context */
 struct kvm_hv {
 	struct mutex hv_lock;
 	u64 hv_guest_os_id;
 	u64 hv_hypercall;
 	u64 hv_tsc_page;
+	enum hv_tsc_page_status hv_tsc_page_status;
 
 	/* Hyper-v based guest crash (NT kernel bugcheck) parameters */
 	u64 hv_crash_param[HV_X64_MSR_CRASH_PARAMS];
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a0e3c49233d4..5c0f10a2b3ab 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -520,10 +520,10 @@ static u64 get_time_ref_counter(struct kvm *kvm)
 	u64 tsc;
 
 	/*
-	 * The guest has not set up the TSC page or the clock isn't
-	 * stable, fall back to get_kvmclock_ns.
+	 * Fall back to get_kvmclock_ns() when TSC page hasn't been set up,
+	 * is broken, disabled or being updated.
 	 */
-	if (!hv->tsc_ref.tsc_sequence)
+	if (hv->hv_tsc_page_status != HV_TSC_PAGE_SET)
 		return div_u64(get_kvmclock_ns(kvm), 100);
 
 	vcpu = kvm_get_vcpu(kvm, 0);
@@ -1087,7 +1087,8 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 	BUILD_BUG_ON(sizeof(tsc_seq) != sizeof(hv->tsc_ref.tsc_sequence));
 	BUILD_BUG_ON(offsetof(struct ms_hyperv_tsc_page, tsc_sequence) != 0);
 
-	if (!(hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE))
+	if (hv->hv_tsc_page_status == HV_TSC_PAGE_BROKEN ||
+	    hv->hv_tsc_page_status == HV_TSC_PAGE_UNSET)
 		return;
 
 	mutex_lock(&hv->hv_lock);
@@ -1101,7 +1102,7 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 	 */
 	if (unlikely(kvm_read_guest(kvm, gfn_to_gpa(gfn),
 				    &tsc_seq, sizeof(tsc_seq))))
-		goto out_unlock;
+		goto out_err;
 
 	/*
 	 * While we're computing and writing the parameters, force the
@@ -1110,15 +1111,15 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 	hv->tsc_ref.tsc_sequence = 0;
 	if (kvm_write_guest(kvm, gfn_to_gpa(gfn),
 			    &hv->tsc_ref, sizeof(hv->tsc_ref.tsc_sequence)))
-		goto out_unlock;
+		goto out_err;
 
 	if (!compute_tsc_page_parameters(hv_clock, &hv->tsc_ref))
-		goto out_unlock;
+		goto out_err;
 
 	/* Ensure sequence is zero before writing the rest of the struct.  */
 	smp_wmb();
 	if (kvm_write_guest(kvm, gfn_to_gpa(gfn), &hv->tsc_ref, sizeof(hv->tsc_ref)))
-		goto out_unlock;
+		goto out_err;
 
 	/*
 	 * Now switch to the TSC page mechanism by writing the sequence.
@@ -1131,8 +1132,15 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 	smp_wmb();
 
 	hv->tsc_ref.tsc_sequence = tsc_seq;
-	kvm_write_guest(kvm, gfn_to_gpa(gfn),
-			&hv->tsc_ref, sizeof(hv->tsc_ref.tsc_sequence));
+	if (kvm_write_guest(kvm, gfn_to_gpa(gfn),
+			    &hv->tsc_ref, sizeof(hv->tsc_ref.tsc_sequence)))
+		goto out_err;
+
+	hv->hv_tsc_page_status = HV_TSC_PAGE_SET;
+	goto out_unlock;
+
+out_err:
+	hv->hv_tsc_page_status = HV_TSC_PAGE_BROKEN;
 out_unlock:
 	mutex_unlock(&hv->hv_lock);
 }
@@ -1142,7 +1150,8 @@ void kvm_hv_invalidate_tsc_page(struct kvm *kvm)
 	struct kvm_hv *hv = to_kvm_hv(kvm);
 	u64 gfn;
 
-	if (!(hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE))
+	if (hv->hv_tsc_page_status == HV_TSC_PAGE_BROKEN ||
+	    hv->hv_tsc_page_status == HV_TSC_PAGE_UNSET)
 		return;
 
 	mutex_lock(&hv->hv_lock);
@@ -1150,11 +1159,16 @@ void kvm_hv_invalidate_tsc_page(struct kvm *kvm)
 	if (!(hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE))
 		goto out_unlock;
 
+	/* Preserve HV_TSC_PAGE_GUEST_CHANGED/HV_TSC_PAGE_HOST_CHANGED states */
+	if (hv->hv_tsc_page_status == HV_TSC_PAGE_SET)
+		hv->hv_tsc_page_status = HV_TSC_PAGE_UPDATING;
+
 	gfn = hv->hv_tsc_page >> HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT;
 
 	hv->tsc_ref.tsc_sequence = 0;
-	kvm_write_guest(kvm, gfn_to_gpa(gfn),
-			&hv->tsc_ref, sizeof(hv->tsc_ref.tsc_sequence));
+	if (kvm_write_guest(kvm, gfn_to_gpa(gfn),
+			    &hv->tsc_ref, sizeof(hv->tsc_ref.tsc_sequence)))
+		hv->hv_tsc_page_status = HV_TSC_PAGE_BROKEN;
 
 out_unlock:
 	mutex_unlock(&hv->hv_lock);
@@ -1216,8 +1230,15 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 	}
 	case HV_X64_MSR_REFERENCE_TSC:
 		hv->hv_tsc_page = data;
-		if (hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE)
+		if (hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE) {
+			if (!host)
+				hv->hv_tsc_page_status = HV_TSC_PAGE_GUEST_CHANGED;
+			else
+				hv->hv_tsc_page_status = HV_TSC_PAGE_HOST_CHANGED;
 			kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
+		} else {
+			hv->hv_tsc_page_status = HV_TSC_PAGE_UNSET;
+		}
 		break;
 	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
 		return kvm_hv_msr_set_crash_data(kvm,
-- 
2.30.2

