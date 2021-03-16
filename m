Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F366A33D5E5
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 15:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236694AbhCPOic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 10:38:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43026 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236594AbhCPOhu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 10:37:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615905469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LrBKx+Fe4zdTccUFr/H5FnIhjtZmi5gRYDRf5Uiif6Y=;
        b=TlJEZGBt1iDqaxaZYXY5/3O4fkrxDlzKSWXvzG1ESTJu5XYLVX3eQul+Hn5SorqydF7o6B
        tTRVsG4CCYKvW6Pu35SzTvJ9GDl4TqIp+wMZzP3QjG1fpIe+HwDbeV+3V71GWH5xxN0u3J
        8kC8or11hf4ibkaBSrYraiEhfTwbpNY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-vSfaXPAKP4yMteygre-xQQ-1; Tue, 16 Mar 2021 10:37:47 -0400
X-MC-Unique: vSfaXPAKP4yMteygre-xQQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60AAA94EE9;
        Tue, 16 Mar 2021 14:37:46 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79F705D9D3;
        Tue, 16 Mar 2021 14:37:44 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v2 2/4] KVM: x86: hyper-v: Prevent using not-yet-updated TSC page by secondary CPUs
Date:   Tue, 16 Mar 2021 15:37:34 +0100
Message-Id: <20210316143736.964151-3-vkuznets@redhat.com>
In-Reply-To: <20210316143736.964151-1-vkuznets@redhat.com>
References: <20210316143736.964151-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When KVM_REQ_MASTERCLOCK_UPDATE request is issued (e.g. after migration)
we need to make sure no vCPU sees stale values in PV clock structures and
thus all vCPUs are kicked with KVM_REQ_CLOCK_UPDATE. Hyper-V TSC page
clocksource is global and kvm_guest_time_update() only updates in on vCPU0
but this is not entirely correct: nothing blocks some other vCPU from
entering the guest before we finish the update on CPU0 and it can read
stale values from the page.

Invalidate TSC page in kvm_gen_update_masterclock() to switch all vCPUs
to using MSR based clocksource (HV_X64_MSR_TIME_REF_COUNT).

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 23 +++++++++++++++++++++++
 arch/x86/kvm/hyperv.h |  1 +
 arch/x86/kvm/x86.c    |  2 ++
 3 files changed, 26 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index eefb85b86fe8..a0e3c49233d4 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1137,6 +1137,29 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 	mutex_unlock(&hv->hv_lock);
 }
 
+void kvm_hv_invalidate_tsc_page(struct kvm *kvm)
+{
+	struct kvm_hv *hv = to_kvm_hv(kvm);
+	u64 gfn;
+
+	if (!(hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE))
+		return;
+
+	mutex_lock(&hv->hv_lock);
+
+	if (!(hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE))
+		goto out_unlock;
+
+	gfn = hv->hv_tsc_page >> HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT;
+
+	hv->tsc_ref.tsc_sequence = 0;
+	kvm_write_guest(kvm, gfn_to_gpa(gfn),
+			&hv->tsc_ref, sizeof(hv->tsc_ref.tsc_sequence));
+
+out_unlock:
+	mutex_unlock(&hv->hv_lock);
+}
+
 static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 			     bool host)
 {
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index e951af1fcb2c..60547d5cb6d7 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -133,6 +133,7 @@ void kvm_hv_process_stimers(struct kvm_vcpu *vcpu);
 
 void kvm_hv_setup_tsc_page(struct kvm *kvm,
 			   struct pvclock_vcpu_time_info *hv_clock);
+void kvm_hv_invalidate_tsc_page(struct kvm *kvm);
 
 void kvm_hv_init_vm(struct kvm *kvm);
 void kvm_hv_destroy_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 47e021bdcc94..a5c5b38735e1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2551,6 +2551,8 @@ static void kvm_gen_update_masterclock(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 	struct kvm_arch *ka = &kvm->arch;
 
+	kvm_hv_invalidate_tsc_page(kvm);
+
 	spin_lock(&ka->pvclock_gtod_sync_lock);
 	kvm_make_mclock_inprogress_request(kvm);
 	/* no guest entries from this point */
-- 
2.30.2

