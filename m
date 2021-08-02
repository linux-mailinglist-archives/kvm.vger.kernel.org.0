Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9203DD615
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 14:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbhHBM4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 08:56:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40579 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233710AbhHBM4r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 08:56:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627908997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2DzC+yjcVqrBoVSC1YNBa9TsPyUNKnFGI0GNkxt8Nu8=;
        b=EJFfv57sWFtcl+MYWbXEujvEcGQKD4WW2cezFl7207ygdBuwIelvGidPCKGbLKs1oY4aLy
        2YF6DYoVN3BUxUavOyCbsWSFLDPd4FaIOAmmE54F/q+8354KoSxTBkIqvZrvun0qdJ0CbL
        6ml2EpjuvyIkoNoDZoUmMe2W103ZPHY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-zV2dXcYROMGONcETvhyTcg-1; Mon, 02 Aug 2021 08:56:36 -0400
X-MC-Unique: zV2dXcYROMGONcETvhyTcg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4D641B18BC0;
        Mon,  2 Aug 2021 12:56:35 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 541AA69CB7;
        Mon,  2 Aug 2021 12:56:35 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com
Subject: [PATCH RFC] KVM: nSVM: remove useless kvm_clear_*_queue
Date:   Mon,  2 Aug 2021 08:56:34 -0400
Message-Id: <20210802125634.309874-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For an event to be in injected state when nested_svm_vmrun executes,
it must have come from exitintinfo when svm_complete_interrupts ran:

  vcpu_enter_guest
   static_call(kvm_x86_run) -> svm_vcpu_run
    svm_complete_interrupts
     // now the event went from "exitintinfo" to "injected"
   static_call(kvm_x86_handle_exit) -> handle_exit
    svm_invoke_exit_handler
      vmrun_interception
       nested_svm_vmrun

However, no event could have been in exitintinfo before a VMRUN
vmexit.  The code in svm.c is a bit more permissive than the one
in vmx.c:

        if (is_external_interrupt(svm->vmcb->control.exit_int_info) &&
            exit_code != SVM_EXIT_EXCP_BASE + PF_VECTOR &&
            exit_code != SVM_EXIT_NPF && exit_code != SVM_EXIT_TASK_SWITCH &&
            exit_code != SVM_EXIT_INTR && exit_code != SVM_EXIT_NMI)

but in any case, a VMRUN instruction would not even start to execute
during an attempted event delivery.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 61738ff8ef33..5e13357da21e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -659,11 +659,6 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		goto out;
 	}
 
-
-	/* Clear internal status */
-	kvm_clear_exception_queue(vcpu);
-	kvm_clear_interrupt_queue(vcpu);
-
 	/*
 	 * Since vmcb01 is not in use, we can use it to store some of the L1
 	 * state.
-- 
2.27.0

