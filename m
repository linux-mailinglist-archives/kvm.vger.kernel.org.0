Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC0C1E28B2
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 19:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389519AbgEZRZL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 13:25:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47783 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389183AbgEZRXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 13:23:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590513804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fix62+yXIEwhQT8pT+Ezxe5NkSkqTahVbDMIy8YhWHE=;
        b=P7Agg5LrzE/33JL5uT8XpIU/IASRV2olyu2W8T4YGaEjANO2vSi7Jmp0TKT9i58tz0diIm
        MIMZyAEwpIip5evN/oHQUkZCByD9SA8B7lZ3b5xtk66nhBAH0yJ78pQt8aiQITc2QrFmYT
        gL1KpMUY3YZQ9ttz94/0CzCajRRMR4A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-tOIGW1zLNTKQLvoYrlVYyQ-1; Tue, 26 May 2020 13:23:22 -0400
X-MC-Unique: tOIGW1zLNTKQLvoYrlVYyQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1316D107ACF7;
        Tue, 26 May 2020 17:23:21 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D59055C1D6;
        Tue, 26 May 2020 17:23:19 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 12/28] KVM: nSVM: clean up tsc_offset update
Date:   Tue, 26 May 2020 13:22:52 -0400
Message-Id: <20200526172308.111575-13-pbonzini@redhat.com>
In-Reply-To: <20200526172308.111575-1-pbonzini@redhat.com>
References: <20200526172308.111575-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use l1_tsc_offset to compute svm->vcpu.arch.tsc_offset and
svm->vmcb->control.tsc_offset, instead of relying on hsave.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 7fbd7aaa4ce0..5a9d131a153e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -241,8 +241,6 @@ static void load_nested_vmcb_control(struct vcpu_svm *svm,
 	svm->nested.intercept_dr         = control->intercept_dr;
 	svm->nested.intercept_exceptions = control->intercept_exceptions;
 	svm->nested.intercept            = control->intercept;
-
-	svm->vcpu.arch.tsc_offset += control->tsc_offset;
 }
 
 static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
@@ -288,7 +286,8 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm, struct vmcb *neste
 	else
 		svm->vcpu.arch.hflags &= ~HF_VINTR_MASK;
 
-	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset;
+	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
+		svm->vcpu.arch.l1_tsc_offset + nested_vmcb->control.tsc_offset;
 
 	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
 	svm->vmcb->control.virt_ext = nested_vmcb->control.virt_ext;
@@ -553,7 +552,9 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	/* Restore the original control entries */
 	copy_vmcb_control_area(vmcb, hsave);
 
-	svm->vcpu.arch.tsc_offset = svm->vmcb->control.tsc_offset;
+	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
+		svm->vcpu.arch.l1_tsc_offset;
+
 	kvm_clear_exception_queue(&svm->vcpu);
 	kvm_clear_interrupt_queue(&svm->vcpu);
 
-- 
2.26.2


