Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14683429216
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 16:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242256AbhJKOjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 10:39:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30859 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242300AbhJKOjV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Oct 2021 10:39:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633963041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5SGnjwJYKT9kxtCeEPcFMsB8tcigkHGedH8kDv4gdOA=;
        b=Tb6NaYG2gRGhz++C12NTULbZjf+b3K5FgarzHZX5A8lAFA04VC9+/DMDnlL6n9BIueL0Ov
        dRq18VOXGhQ0qBy4fNhZQpfIsHcoUvEfBA5npoUWluUC+mwpkOzPBnP/rG8c7iG5B+Nq4g
        Ui4pPKzKO8TubMgY1dhI6bwNTPIrivM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-JVADViw9P8Gl8T0kiPagJA-1; Mon, 11 Oct 2021 10:37:18 -0400
X-MC-Unique: JVADViw9P8Gl8T0kiPagJA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49B90138CA84;
        Mon, 11 Oct 2021 14:37:16 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 368EA380;
        Mon, 11 Oct 2021 14:37:15 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [PATCH v3 8/8] nSVM: remove unnecessary parameter in nested_vmcb_check_controls
Date:   Mon, 11 Oct 2021 10:37:02 -0400
Message-Id: <20211011143702.1786568-9-eesposit@redhat.com>
In-Reply-To: <20211011143702.1786568-1-eesposit@redhat.com>
References: <20211011143702.1786568-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just as in nested_vmcb_valid_sregs, we only need the vcpu param
to perform the checks on vmcb nested state, since we always
look at the cached fields.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 13be1002ad1c..19bce3819cce 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -209,9 +209,11 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
 	    kvm_vcpu_is_legal_gpa(vcpu, addr + size - 1);
 }
 
-static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
-				       struct vmcb_ctrl_area_cached *control)
+static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_ctrl_area_cached *control = &svm->nested.ctl;
+
 	if (CC(!vmcb12_is_intercept(control, INTERCEPT_VMRUN)))
 		return false;
 
@@ -651,7 +653,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
 
 	if (!nested_vmcb_valid_sregs(vcpu) ||
-	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
+	    !nested_vmcb_check_controls(vcpu)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_code_hi = 0;
 		vmcb12->control.exit_info_1  = 0;
@@ -1367,7 +1369,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	ret = -EINVAL;
 	nested_copy_vmcb_control_to_cache(svm, ctl);
-	if (!nested_vmcb_check_controls(vcpu, &svm->nested.ctl))
+	if (!nested_vmcb_check_controls(vcpu))
 		goto out_free_ctl;
 
 	/*
-- 
2.27.0

