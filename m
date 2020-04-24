Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547951B7CAB
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 19:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgDXRYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 13:24:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49833 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728853AbgDXRYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 13:24:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587749080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=UmAA9/+IHhfnv934e38JcU8oC7FPZN3AvIwnCiympQ4=;
        b=dKqGg5xc+tzz2xbR6UPfYrB0D1sc/4uT4JvPeM5xJdzdQW9pPvh/6rq2v4xm/RhCaGve+a
        E7izftbADIfK33sos92KxnSzK5suBYWI/32h6DrMm+v8H0w4fK8G6AaRb/v+cJQWOrtHyQ
        hsjfonBj8kRA8COPSGWFXnXwxEn5zJM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-4DmxmMS2NQWsZlywIa1Pcg-1; Fri, 24 Apr 2020 13:24:34 -0400
X-MC-Unique: 4DmxmMS2NQWsZlywIa1Pcg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0383F18B641F;
        Fri, 24 Apr 2020 17:24:24 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0383625277;
        Fri, 24 Apr 2020 17:24:22 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wei.huang2@amd.com, cavery@redhat.com, vkuznets@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH v2 05/22] KVM: nVMX: Preserve exception priority irrespective of exiting behavior
Date:   Fri, 24 Apr 2020 13:23:59 -0400
Message-Id: <20200424172416.243870-6-pbonzini@redhat.com>
In-Reply-To: <20200424172416.243870-1-pbonzini@redhat.com>
References: <20200424172416.243870-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Short circuit vmx_check_nested_events() if an exception is pending and
needs to be injected into L2, priority between coincident events is not
dependent on exiting behavior.  This fixes a bug where a single-step #DB
that is not intercepted by L1 is incorrectly dropped due to servicing a
VMX Preemption Timer VM-Exit.

Injected exceptions also need to be blocked if nested VM-Enter is
pending or an exception was already injected, otherwise injecting the
exception could overwrite an existing event injection from L1.
Technically, this scenario should be impossible, i.e. KVM shouldn't
inject its own exception during nested VM-Enter.  This will be addressed
in a future patch.

Note, event priority between SMI, NMI and INTR is incorrect for L2, e.g.
SMI should take priority over VM-Exit on NMI/INTR, and NMI that is
injected into L2 should take priority over VM-Exit INTR.  This will also
be addressed in a future patch.

Fixes: b6b8a1451fc4 ("KVM: nVMX: Rework interception of IRQs and NMIs")
Reported-by: Jim Mattson <jmattson@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Peter Shier <pshier@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200423022550.15113-2-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b516c24494e3..490dba7d0504 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3716,11 +3716,11 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	/*
 	 * Process any exceptions that are not debug traps before MTF.
 	 */
-	if (vcpu->arch.exception.pending &&
-	    !vmx_pending_dbg_trap(vcpu) &&
-	    nested_vmx_check_exception(vcpu, &exit_qual)) {
+	if (vcpu->arch.exception.pending && !vmx_pending_dbg_trap(vcpu)) {
 		if (block_nested_events)
 			return -EBUSY;
+		if (!nested_vmx_check_exception(vcpu, &exit_qual))
+			goto no_vmexit;
 		nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
 		return 0;
 	}
@@ -3733,10 +3733,11 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	if (vcpu->arch.exception.pending &&
-	    nested_vmx_check_exception(vcpu, &exit_qual)) {
+	if (vcpu->arch.exception.pending) {
 		if (block_nested_events)
 			return -EBUSY;
+		if (!nested_vmx_check_exception(vcpu, &exit_qual))
+			goto no_vmexit;
 		nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
 		return 0;
 	}
@@ -3771,6 +3772,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
+no_vmexit:
 	vmx_complete_nested_posted_interrupt(vcpu);
 	return 0;
 }
-- 
2.18.2


