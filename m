Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCDC6254AB1
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 18:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgH0Q1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 12:27:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40586 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726200AbgH0Q1m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 12:27:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598545660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V71RRp7TnJ/MIg+3QA5K7sfS8dmsGyA9hhRFvDd6tOE=;
        b=Rx9e3GcfLrJwjlXsYdv04LlGuNuNwCnE4XAfa8S6iyyyv2fXxE//WfbbDTh41kzpCmTR/B
        EIu8rKG8iphLfb9jz+slVLzpz4YYXdHylPQ1TDacsLgD+cpCCb0Ljyu6Y0EkmVgB/CP/yF
        v+sI4o1siZSrenwXhZZKGbnOs0N/2po=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-P-f5qfj3PCWWsSTjTBaCqg-1; Thu, 27 Aug 2020 12:27:37 -0400
X-MC-Unique: P-f5qfj3PCWWsSTjTBaCqg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4894918BA288;
        Thu, 27 Aug 2020 16:27:35 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 286BB5C1C2;
        Thu, 27 Aug 2020 16:27:29 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/3] SVM: nSVM: correctly restore GIF on vmexit from nesting after migration
Date:   Thu, 27 Aug 2020 19:27:18 +0300
Message-Id: <20200827162720.278690-2-mlevitsk@redhat.com>
In-Reply-To: <20200827162720.278690-1-mlevitsk@redhat.com>
References: <20200827162720.278690-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently code in svm_set_nested_state copies the current vmcb control
area to L1 control area (hsave->control), under assumption that
it mostly reflects the defaults that kvm choose, and later qemu
overrides  these defaults with L2 state using standard KVM interfaces,
like KVM_SET_REGS.

However nested GIF (which is AMD specific thing) is by default is true,
and it is copied to hsave area as such.

This alone is not a big deal since on VMexit, GIF is always set to false,
regardless of what it was on VM entry.

However in nested_svm_vmexit we were first were setting GIF to false,
but then we overwrite this with value from the hsave area.

Now on normal vm entry this is not a problem, since GIF is false
prior to normal vm entry,
and this is the value that copied to hsave, and then restored,
but this is not always the case when the nested state is loaded as
explained above.

Anyway to fix this issue, move svm_set_gif after we restore the L1 control
state in nested_svm_vmexit, so that even with wrong GIF in the
saved L1 control area, we still clear GIF as the spec says.

All of this is only relevant when GIF virtualization is enabled,
(otherwise nested GIF doesn't reside in the vmcb).

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index fb68467e60496..95fdf068fe4c1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -586,7 +586,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	svm->vcpu.arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
 	/* Give the current vmcb to the guest */
-	svm_set_gif(svm, false);
 
 	nested_vmcb->save.es     = vmcb->save.es;
 	nested_vmcb->save.cs     = vmcb->save.cs;
@@ -632,6 +631,9 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	/* Restore the original control entries */
 	copy_vmcb_control_area(&vmcb->control, &hsave->control);
 
+	/* On vmexit the  GIF is set to false */
+	svm_set_gif(svm, false);
+
 	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
 		svm->vcpu.arch.l1_tsc_offset;
 
-- 
2.26.2

