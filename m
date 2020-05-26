Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90B51E2893
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 19:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389276AbgEZRXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 13:23:55 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59790 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389321AbgEZRXx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 13:23:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590513832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xoi5g1yvEmgWJC7HI/tB747cYL1hv2e+LSKzK3PkkhU=;
        b=LxajUgjwEurQaqaHT/aJHr7PRtat3ieXLpLmp3aJABANtc4ZryRZGBqPzg/awVe9ljbpLR
        9qmNwo+ODrvZtUmJnxdvJ34m7I5qc7K/sFf2k92U21FV/mznjqwUazgZb/TCCGYN7FyeOW
        QRVuYMvxu8BRfvm7F3QUxXKJqwjqoyY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-MkbBhlCZPumktVlrjFZ5yw-1; Tue, 26 May 2020 13:23:51 -0400
X-MC-Unique: MkbBhlCZPumktVlrjFZ5yw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E740BA0C0E;
        Tue, 26 May 2020 17:23:49 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 382895D9E5;
        Tue, 26 May 2020 17:23:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 23/28] KVM: nSVM: remove HF_HIF_MASK
Date:   Tue, 26 May 2020 13:23:03 -0400
Message-Id: <20200526172308.111575-24-pbonzini@redhat.com>
In-Reply-To: <20200526172308.111575-1-pbonzini@redhat.com>
References: <20200526172308.111575-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
index 0dfc522f96cc..3485f8454088 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1595,7 +1595,6 @@ enum {
 };
 
 #define HF_GIF_MASK		(1 << 0)
-#define HF_HIF_MASK		(1 << 1)
 #define HF_NMI_MASK		(1 << 3)
 #define HF_IRET_MASK		(1 << 4)
 #define HF_GUEST_MASK		(1 << 5) /* VCPU is in guest-mode */
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 56d45fe6eb45..f3e70aee18cd 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -371,11 +371,6 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 			  struct vmcb *nested_vmcb)
 {
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
index d1a6e2f3db55..f0da6f0ebf1b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3105,7 +3105,7 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
 	if (is_guest_mode(vcpu)) {
 		/* As long as interrupts are being delivered...  */
 		if ((svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
-		    ? !(svm->vcpu.arch.hflags & HF_HIF_MASK)
+		    ? !(svm->nested.hsave->save.rflags & X86_EFLAGS_IF)
 		    : !(kvm_get_rflags(vcpu) & X86_EFLAGS_IF))
 			return true;
 
-- 
2.26.2


