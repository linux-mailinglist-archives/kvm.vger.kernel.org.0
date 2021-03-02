Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FC932B5B3
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382778AbhCCHT0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23671 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1836006AbhCBTfg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:35:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tn8nxUkOnMTO5dlRCxByClti3TtIcwPTrbSb0/ZLdGo=;
        b=B3TR6fe3+Y8YJIIwrCXs+0FHlDTLoIQeJ15JiAOzEyVDcSpTw5h2XHJ4+OI3hWC7RSG5SO
        BHtqpYHm254m6F2rBELQoAeuFD+0QLXT2gnFkdlFjOlUM7GssURmfYCp5byuDyG2mZ5T/m
        KBbew9v6bNOdhCp3JAPyAnzJcHQcvg4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-2QBCVp7zPwe3Y5zC3obmsQ-1; Tue, 02 Mar 2021 14:33:57 -0500
X-MC-Unique: 2QBCVp7zPwe3Y5zC3obmsQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 479DF801977;
        Tue,  2 Mar 2021 19:33:56 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4D045B4B6;
        Tue,  2 Mar 2021 19:33:55 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 20/23] KVM: SVM: move VMLOAD/VMSAVE to C code
Date:   Tue,  2 Mar 2021 14:33:40 -0500
Message-Id: <20210302193343.313318-21-pbonzini@redhat.com>
In-Reply-To: <20210302193343.313318-1-pbonzini@redhat.com>
References: <20210302193343.313318-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks to the new macros that handle exception handling for SVM
instructions, it is easier to just do the VMLOAD/VMSAVE in C.
This is safe, as shown by the fact that the host reload is
already done outside the assembly source.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c     |  2 ++
 arch/x86/kvm/svm/vmenter.S | 14 +-------------
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1c62d3ec7e53..a0df44f6c239 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3719,7 +3719,9 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	} else {
 		struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
 
+		vmload(svm->vmcb_pa);
 		__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&vcpu->arch.regs);
+		vmsave(svm->vmcb_pa);
 
 		vmload(__sme_page_pa(sd->save_area));
 	}
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 6feb8c08f45a..343108bf0f8c 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -79,12 +79,6 @@ SYM_FUNC_START(__svm_vcpu_run)
 
 	/* Enter guest mode */
 	sti
-1:	vmload %_ASM_AX
-	jmp 3f
-2:	cmpb $0, kvm_rebooting
-	jne 3f
-	ud2
-	_ASM_EXTABLE(1b, 2b)
 
 3:	vmrun %_ASM_AX
 	jmp 5f
@@ -93,13 +87,7 @@ SYM_FUNC_START(__svm_vcpu_run)
 	ud2
 	_ASM_EXTABLE(3b, 4b)
 
-5:	vmsave %_ASM_AX
-	jmp 7f
-6:	cmpb $0, kvm_rebooting
-	jne 7f
-	ud2
-	_ASM_EXTABLE(5b, 6b)
-7:
+5:
 	cli
 
 #ifdef CONFIG_RETPOLINE
-- 
2.26.2


