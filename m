Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A451DBB49
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 19:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgETRXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 13:23:33 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25502 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728085AbgETRWO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 13:22:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589995333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=O5C/wpSFG+A10gW4g2b6rirce6pktuJyF39GSqi1oN0=;
        b=GHc2S5SHzhuV2Amk+g9EFMhCXllgna4KcGc4mlJxB9u3DT/0NLU6sQ40rM8cq2kmNiTgN4
        Ef065IMAqIzZAwMviWkTbpnmdTtQC3mgnEZwSTWrmiq/pMuBwydEzPi7UKBRdVs+r2W14H
        zuAy9I+wXooVH958Gz3GD12CBVwGMoY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-s9k8H_HhOjmzYZiuQVsb3g-1; Wed, 20 May 2020 13:22:06 -0400
X-MC-Unique: s9k8H_HhOjmzYZiuQVsb3g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E58E5835BB8;
        Wed, 20 May 2020 17:22:04 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBF3670461;
        Wed, 20 May 2020 17:22:03 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 15/24] KVM: nSVM: remove HF_HIF_MASK
Date:   Wed, 20 May 2020 13:21:36 -0400
Message-Id: <20200520172145.23284-16-pbonzini@redhat.com>
In-Reply-To: <20200520172145.23284-1-pbonzini@redhat.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The L1 flags can be found in the save area of svm->nested.hsave, fish
it from there so that there is one fewer thing to migrate.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/svm/nested.c       | 5 -----
 arch/x86/kvm/svm/svm.c          | 2 +-
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f1c4cb2d0541..019dafaddc1f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1593,7 +1593,6 @@ enum {
 };
 
 #define HF_GIF_MASK		(1 << 0)
-#define HF_HIF_MASK		(1 << 1)
 #define HF_NMI_MASK		(1 << 3)
 #define HF_IRET_MASK		(1 << 4)
 #define HF_GUEST_MASK		(1 << 5) /* VCPU is in guest-mode */
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 9e4d24acadd7..cbe96a08b080 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -310,11 +310,6 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 		is_intercept(svm, INTERCEPT_IRET);
 
 	svm->nested.vmcb = vmcb_gpa;
-	if (kvm_get_rflags(&svm->vcpu) & X86_EFLAGS_IF)
-		svm->vcpu.arch.hflags |= HF_HIF_MASK;
-	else
-		svm->vcpu.arch.hflags &= ~HF_HIF_MASK;
-
 	load_nested_vmcb_control(svm, &nested_vmcb->control);
 	nested_prepare_vmcb_save(svm, nested_vmcb);
 	nested_prepare_vmcb_control(svm);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 10c80c13b679..6a19cb3e3b1f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3081,7 +3081,7 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
 	if (is_guest_mode(vcpu)) {
 		/* As long as interrupts are being delivered...  */
 		if ((svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
-		    ? !(svm->vcpu.arch.hflags & HF_HIF_MASK)
+		    ? !(svm->nested.hsave->save.rflags & X86_EFLAGS_IF)
 		    : !(kvm_get_rflags(vcpu) & X86_EFLAGS_IF))
 			return true;
 
-- 
2.18.2


