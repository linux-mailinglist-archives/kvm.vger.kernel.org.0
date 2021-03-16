Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3FA33D5E7
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 15:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236841AbhCPOil (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 10:38:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60359 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236666AbhCPOiA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 10:38:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615905479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3anau4W1sR3F+1XYiO38M5VgZHOhqYLVsP8561DZzT4=;
        b=dB+mk7n655EfCufj0S5fp0XiQlISTQfBAI8e1wMW1gmAm8pc2QfKamVOwwNEGACJCKkkNL
        hgdJX+mu0yViKQ3WSxAukyGJ8EARlP/BOO08ZBrIt4CAb0slX71ACmVSMSCTg40ME4XTmk
        xjC/s+Z8NT7y8FUrpru3WVn/hQvRvL4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-xMZ5r7hVOzurJCflrCKnJQ-1; Tue, 16 Mar 2021 10:37:57 -0400
X-MC-Unique: xMZ5r7hVOzurJCflrCKnJQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BFBF94EE1;
        Tue, 16 Mar 2021 14:37:56 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB9305D9D3;
        Tue, 16 Mar 2021 14:37:48 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v2 4/4] KVM: x86: hyper-v: Don't touch TSC page values when guest opted for re-enlightenment
Date:   Tue, 16 Mar 2021 15:37:36 +0100
Message-Id: <20210316143736.964151-5-vkuznets@redhat.com>
In-Reply-To: <20210316143736.964151-1-vkuznets@redhat.com>
References: <20210316143736.964151-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When guest opts for re-enlightenment notifications upon migration, it is
in its right to assume that TSC page values never change (as they're only
supposed to change upon migration and the host has to keep things as they
are before it receives confirmation from the guest). This is mostly true
until the guest is migrated somewhere. KVM userspace (e.g. QEMU) will
trigger masterclock update by writing to HV_X64_MSR_REFERENCE_TSC, by
calling KVM_SET_CLOCK,... and as TSC value and kvmclock reading drift
apart (even slightly), the update causes TSC page values to change.

The issue at hand is that when Hyper-V is migrated, it uses stale (cached)
TSC page values to compute the difference between its own clocksource
(provided by KVM) and its guests' TSC pages to program synthetic timers
and in some cases, when TSC page is updated, this puts all stimer
expirations in the past. This, in its turn, causes an interrupt storm
and L2 guests not making much forward progress.

Note, KVM doesn't fully implement re-enlightenment notification. Basically,
the support for reenlightenment MSRs is just a stub and userspace is only
expected to expose the feature when TSC scaling on the expected destination
hosts is available. With TSC scaling, no real re-enlightenment is needed
as TSC frequency doesn't change. With TSC scaling becoming ubiquitous, it
likely makes little sense to fully implement re-enlightenment in KVM.

Prevent TSC page from being updated after migration. In case it's not the
guest who's initiating the change and when TSC page is already enabled,
just keep it as it is: TSC value is supposed to be preserved across
migration and TSC frequency can't change with re-enlightenment enabled.
The guest is doomed anyway if any of this is not true.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 5c0f10a2b3ab..f98370a39936 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1077,6 +1077,21 @@ static bool compute_tsc_page_parameters(struct pvclock_vcpu_time_info *hv_clock,
 	return true;
 }
 
+/*
+ * Don't touch TSC page values if the guest has opted for TSC emulation after
+ * migration. KVM doesn't fully support reenlightenment notifications and TSC
+ * access emulation and Hyper-V is known to expect the values in TSC page to
+ * stay constant before TSC access emulation is disabled from guest side
+ * (HV_X64_MSR_TSC_EMULATION_STATUS). KVM userspace is expected to preserve TSC
+ * frequency and guest visible TSC value across migration (and prevent it when
+ * TSC scaling is unsupported).
+ */
+static inline bool tsc_page_update_unsafe(struct kvm_hv *hv)
+{
+	return (hv->hv_tsc_page_status != HV_TSC_PAGE_GUEST_CHANGED) &&
+		hv->hv_tsc_emulation_control;
+}
+
 void kvm_hv_setup_tsc_page(struct kvm *kvm,
 			   struct pvclock_vcpu_time_info *hv_clock)
 {
@@ -1104,6 +1119,14 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 				    &tsc_seq, sizeof(tsc_seq))))
 		goto out_err;
 
+	if (tsc_seq && tsc_page_update_unsafe(hv)) {
+		if (kvm_read_guest(kvm, gfn_to_gpa(gfn), &hv->tsc_ref, sizeof(hv->tsc_ref)))
+			goto out_err;
+
+		hv->hv_tsc_page_status = HV_TSC_PAGE_SET;
+		goto out_unlock;
+	}
+
 	/*
 	 * While we're computing and writing the parameters, force the
 	 * guest to use the time reference count MSR.
@@ -1151,7 +1174,8 @@ void kvm_hv_invalidate_tsc_page(struct kvm *kvm)
 	u64 gfn;
 
 	if (hv->hv_tsc_page_status == HV_TSC_PAGE_BROKEN ||
-	    hv->hv_tsc_page_status == HV_TSC_PAGE_UNSET)
+	    hv->hv_tsc_page_status == HV_TSC_PAGE_UNSET ||
+	    tsc_page_update_unsafe(hv))
 		return;
 
 	mutex_lock(&hv->hv_lock);
-- 
2.30.2

