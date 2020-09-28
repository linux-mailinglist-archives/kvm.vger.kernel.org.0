Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5159E27AD3B
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 13:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgI1Lvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 07:51:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47955 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726513AbgI1Lvx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 07:51:53 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601293912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fDOS6DSkiqgARlqHo0dxCfQnRp70dFnYkmO53ea5U0A=;
        b=SrNhpS0bGVL0AX4UheEqx/TiEOWTMHqI23G3ZkXldhIYV9mQuOAE+UhKcapBa0UIBk6hP+
        BVfFokmkw11yRofig7eVswJgjFXHEsrfWLW4DJlWWmZVOxUCGQW2hnnN/xwiXwXounabo/
        MyNqQ7yyf1VkLNY5YoaVtAzwWvq6nKE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-9DHJjD7BOeSuK3-Nsh9PQw-1; Mon, 28 Sep 2020 07:51:50 -0400
X-MC-Unique: 9DHJjD7BOeSuK3-Nsh9PQw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 360EB100559D;
        Mon, 28 Sep 2020 11:51:46 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D49F719D7D;
        Mon, 28 Sep 2020 11:51:45 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com
Subject: [PATCH 2/2] nSVM: delay MSR permission processing to first nested VM run
Date:   Mon, 28 Sep 2020 07:51:44 -0400
Message-Id: <20200928115144.2446240-3-pbonzini@redhat.com>
In-Reply-To: <20200928115144.2446240-1-pbonzini@redhat.com>
References: <20200928115144.2446240-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow userspace to set up the memory map after KVM_SET_NESTED_STATE;
to do so, move the call to nested_svm_vmrun_msrpm inside the
KVM_REQ_GET_NESTED_STATE_PAGES handler (which is currently
not used by nSVM).  This is similar to what VMX does already.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 598a769f1961..ab7ff2701dec 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -200,6 +200,20 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 	return true;
 }
 
+static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
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
 static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 {
 	if ((control->intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
@@ -702,6 +716,8 @@ void svm_leave_nested(struct vcpu_svm *svm)
 		copy_vmcb_control_area(&vmcb->control, &hsave->control);
 		nested_svm_uninit_mmu_context(&svm->vcpu);
 	}
+
+	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, &svm->vcpu);
 }
 
 static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
@@ -1147,8 +1163,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	load_nested_vmcb_control(svm, ctl);
 	nested_prepare_vmcb_control(svm);
 
-	if (!nested_svm_vmrun_msrpm(svm))
-		return -EINVAL;
+	kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 
 out_set_gif:
 	svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
@@ -1163,6 +1178,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 struct kvm_x86_nested_ops svm_nested_ops = {
 	.check_events = svm_check_nested_events,
+	.get_nested_state_pages = svm_get_nested_state_pages,
 	.get_state = svm_get_nested_state,
 	.set_state = svm_set_nested_state,
 };
-- 
2.26.2

