Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7903231DBD2
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 16:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbhBQO7r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 09:59:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40374 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233680AbhBQO7S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 09:59:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613573872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D6vYOR0dgL/biSGZfHd88o0jtjehBMmGld8Fzmh3jxI=;
        b=HFoG+g50Wc6wVI7HT0v79J7yurVGrkEzhUJW5zZxklzZXmuPemMM2kaS34XiFS/WQdlObz
        EeG14pDKOGc4bmiAKVqvv3PSRY6Wg0Gu/f9ebB3smt4houok1l7RxsJ1GJo08R72wAmslP
        IXoQYGmWzjSEhBaTwonft/gdSHU7xFU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-ABdhTXJ3NLuaTxT6sZ4Pvw-1; Wed, 17 Feb 2021 09:57:50 -0500
X-MC-Unique: ABdhTXJ3NLuaTxT6sZ4Pvw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F268D192AB78;
        Wed, 17 Feb 2021 14:57:48 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9EB7A10023AF;
        Wed, 17 Feb 2021 14:57:45 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 7/7] KVM: nSVM: call nested_svm_load_cr3 on nested state load
Date:   Wed, 17 Feb 2021 16:57:18 +0200
Message-Id: <20210217145718.1217358-8-mlevitsk@redhat.com>
In-Reply-To: <20210217145718.1217358-1-mlevitsk@redhat.com>
References: <20210217145718.1217358-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While KVM's MMU should be fully reset by loading of nested CR0/CR3/CR4
by KVM_SET_SREGS, we are not in nested mode yet when we do it and therefore
only root_mmu is reset.

On regular nested entries we call nested_svm_load_cr3 which both updates the
guest's CR3 in the MMU when it is needed, and it also initializes
the mmu again which makes it initialize the walk_mmu as well when nested
paging is enabled in both host and guest.

Since we don't call nested_svm_load_cr3 on nested state load,
the walk_mmu can be left uninitialized, which can lead to a NULL pointer
dereference while accessing it, if we happen to get a nested page fault
right after entering the nested guest first time after the migration and
if we decide to emulate it.
This makes the emulator access NULL walk_mmu->gva_to_gpa.

Therefore we should call this function on nested state load as well.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 40 +++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 53b9037259b5..ebc7dfaa9f13 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -215,24 +215,6 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 	return true;
 }
 
-static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	if (WARN_ON(!is_guest_mode(vcpu)))
-		return true;
-
-	if (!nested_svm_vmrun_msrpm(svm)) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror =
-			KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
-		return false;
-	}
-
-	return true;
-}
-
 static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 {
 	if (CC(!vmcb_is_intercept(control, INTERCEPT_VMRUN)))
@@ -1311,6 +1293,28 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (WARN_ON(!is_guest_mode(vcpu)))
+		return true;
+
+	if (nested_svm_load_cr3(&svm->vcpu, vcpu->arch.cr3,
+				nested_npt_enabled(svm)))
+		return false;
+
+	if (!nested_svm_vmrun_msrpm(svm)) {
+		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->run->internal.suberror =
+			KVM_INTERNAL_ERROR_EMULATION;
+		vcpu->run->internal.ndata = 0;
+		return false;
+	}
+
+	return true;
+}
+
 struct kvm_x86_nested_ops svm_nested_ops = {
 	.check_events = svm_check_nested_events,
 	.get_nested_state_pages = svm_get_nested_state_pages,
-- 
2.26.2

