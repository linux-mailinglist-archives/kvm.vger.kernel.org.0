Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA1533BDC8
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 15:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbhCOOij (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 10:38:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39527 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239821AbhCOOhU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 10:37:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615819040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=twIrqfzsNtHvqJ7vSwQnUKzlQW5N7NMT68476wDhutM=;
        b=c1IvyNWorNEUEQhFDYjChroHv63Ekrd31vDJiP6/IaNATGPS0ttq8h42Nk/0DNg7qyjHZr
        7qoLf1PcPviF0m5zdNJkGjwn9gKLSdg2Nk4pHIm1EnafEJLINAG4/1zqPEFD7tDUSvuoHl
        YbMnfV95nGor/UQ0WRXTTT6TeYeicpM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-n5mCGrdjOb-lBdbH3LQt-w-1; Mon, 15 Mar 2021 10:37:18 -0400
X-MC-Unique: n5mCGrdjOb-lBdbH3LQt-w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6E21108BD08;
        Mon, 15 Mar 2021 14:37:16 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D3E15C3E6;
        Mon, 15 Mar 2021 14:37:14 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 3/4] KVM: x86: hyper-v: Track Hyper-V TSC page status
Date:   Mon, 15 Mar 2021 15:37:05 +0100
Message-Id: <20210315143706.859293-4-vkuznets@redhat.com>
In-Reply-To: <20210315143706.859293-1-vkuznets@redhat.com>
References: <20210315143706.859293-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  9 +++++++++
 arch/x86/kvm/hyperv.c           | 23 +++++++++++++++++------
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9bc091ecaaeb..87448e9e6b28 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -884,12 +884,21 @@ struct kvm_hv_syndbg {
 	u64 options;
 };
 
+enum hv_tsc_page_status {
+	HV_TSC_PAGE_UNSET = 0,
+	HV_TSC_PAGE_GUEST_CHANGED,
+	HV_TSC_PAGE_HOST_CHANGED,
+	HV_TSC_PAGE_SET,
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
index eefb85b86fe8..2a8d078b16cb 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1087,7 +1087,7 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 	BUILD_BUG_ON(sizeof(tsc_seq) != sizeof(hv->tsc_ref.tsc_sequence));
 	BUILD_BUG_ON(offsetof(struct ms_hyperv_tsc_page, tsc_sequence) != 0);
 
-	if (!(hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE))
+	if (hv->hv_tsc_page_status == HV_TSC_PAGE_BROKEN)
 		return;
 
 	mutex_lock(&hv->hv_lock);
@@ -1101,7 +1101,7 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 	 */
 	if (unlikely(kvm_read_guest(kvm, gfn_to_gpa(gfn),
 				    &tsc_seq, sizeof(tsc_seq))))
-		goto out_unlock;
+		goto out_err;
 
 	/*
 	 * While we're computing and writing the parameters, force the
@@ -1110,15 +1110,15 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
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
@@ -1133,6 +1133,12 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 	hv->tsc_ref.tsc_sequence = tsc_seq;
 	kvm_write_guest(kvm, gfn_to_gpa(gfn),
 			&hv->tsc_ref, sizeof(hv->tsc_ref.tsc_sequence));
+
+	hv->hv_tsc_page_status = HV_TSC_PAGE_SET;
+	goto out_unlock;
+
+out_err:
+	hv->hv_tsc_page_status = HV_TSC_PAGE_BROKEN;
 out_unlock:
 	mutex_unlock(&hv->hv_lock);
 }
@@ -1193,8 +1199,13 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
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
+		}
 		break;
 	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
 		return kvm_hv_msr_set_crash_data(kvm,
-- 
2.30.2

