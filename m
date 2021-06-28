Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF163B5CAE
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 12:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbhF1Krm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 06:47:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52539 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232838AbhF1KrY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 06:47:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624877098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rBfRa821p85I312i32ddAVzacLWsbIFKIiXFAUfQdyc=;
        b=beS28IuiWLpxKcXilhW2Br5anbhvmcfQp8DCyvdpEoTqy8qMA4bhjUfKPkGzfLL3Vg7Ws2
        fllzKlXdvGpbYfe5LfWP6hkJe3GuQJbw/mX+hhOXQrVNqiaisbjeHszyeOZ8AGmMUmpjlV
        OZeQPlT3bnJgVade3sSHvgXiYLr6W0Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-jczH1GhQMFaTHQTv1jc36A-1; Mon, 28 Jun 2021 06:44:55 -0400
X-MC-Unique: jczH1GhQMFaTHQTv1jc36A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B4BE804300;
        Mon, 28 Jun 2021 10:44:54 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C30B85C1CF;
        Mon, 28 Jun 2021 10:44:51 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] KVM: nSVM: Restore nested control upon leaving SMM
Date:   Mon, 28 Jun 2021 12:44:24 +0200
Message-Id: <20210628104425.391276-6-vkuznets@redhat.com>
In-Reply-To: <20210628104425.391276-1-vkuznets@redhat.com>
References: <20210628104425.391276-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In case nested state was saved/resored while in SMM,
nested_load_control_from_vmcb12() which sets svm->nested.ctl was never
called and the first nested_vmcb_check_controls() (either from
nested_svm_vmrun() or from svm_set_nested_state() if save/restore
cycle is repeated) is doomed to fail.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 4 ++--
 arch/x86/kvm/svm/svm.c    | 7 ++++++-
 arch/x86/kvm/svm/svm.h    | 2 ++
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a1dec2c40181..6549e40155fa 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -304,8 +304,8 @@ static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-static void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
-					    struct vmcb_control_area *control)
+void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
+				     struct vmcb_control_area *control)
 {
 	copy_vmcb_control_area(&svm->nested.ctl, control);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fbf1b352a9bb..525b07873927 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4344,6 +4344,7 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 		u64 saved_efer = GET_SMSTATE(u64, smstate, 0x7ed0);
 		u64 guest = GET_SMSTATE(u64, smstate, 0x7ed8);
 		u64 vmcb12_gpa = GET_SMSTATE(u64, smstate, 0x7ee0);
+		struct vmcb *vmcb12;
 
 		if (guest) {
 			if (!guest_cpuid_has(vcpu, X86_FEATURE_SVM))
@@ -4359,7 +4360,11 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 			if (svm_allocate_nested(svm))
 				return 1;
 
-			ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, map.hva);
+			vmcb12 = map.hva;
+
+			nested_load_control_from_vmcb12(svm, &vmcb12->control);
+
+			ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12);
 			kvm_vcpu_unmap(vcpu, &map, true);
 
 			/*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ff2dac2b23b6..13f2d465ca36 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -481,6 +481,8 @@ int nested_svm_check_permissions(struct kvm_vcpu *vcpu);
 int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 			       bool has_error_code, u32 error_code);
 int nested_svm_exit_special(struct vcpu_svm *svm);
+void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
+				     struct vmcb_control_area *control);
 void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
 void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
-- 
2.31.1

