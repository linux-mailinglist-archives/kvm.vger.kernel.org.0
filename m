Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CF445053B
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 14:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhKONWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 08:22:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24457 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231785AbhKONWE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Nov 2021 08:22:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636982349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b4Qg6bfidHi2+sodhiuBIHeJQiQW8HkDiV/qzCDxdG0=;
        b=cc+R53VT35cucFIsYKf4H+Ue3F3f6scjCmAYy+IfvQurlK8BCeUJOrN/NN8Om409q2oZWe
        frfsR4/G9c69J00GZygfVqkr2vFDYNUqRFnU14pEoEeSOvSkZpqALZ1jRlZ+qUtNqcUUuM
        ZPEVQXLQBZXmiI/buX26Ma07YD0wEpo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-Ekj_pfIIPD6EyO097D0W3w-1; Mon, 15 Nov 2021 08:18:53 -0500
X-MC-Unique: Ekj_pfIIPD6EyO097D0W3w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F3DC9F92A;
        Mon, 15 Nov 2021 13:18:52 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 893181017E37;
        Mon, 15 Nov 2021 13:18:48 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 1/2] KVM: nVMX: don't use vcpu->arch.efer when checking host state on nested state load
Date:   Mon, 15 Nov 2021 15:18:36 +0200
Message-Id: <20211115131837.195527-2-mlevitsk@redhat.com>
In-Reply-To: <20211115131837.195527-1-mlevitsk@redhat.com>
References: <20211115131837.195527-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When loading the nested state, due to the way qemu loads
the nested state, vcpu->arch.efer contains L2' IA32_EFER which
can be completely different from L1's IA32_EFER, thus it is
wrong to do consistency check of it vs the vmcs12 exit fields.

To fix this

1. Split the host state consistency check
between current IA32_EFER.LMA and 'host address space' bit in VMCS12 into
nested_vmx_check_address_state_size.

2. Call this check only on a normal VM entry, while skipping this call
on loading the nested state.

3. Trust the 'host address space' bit to contain correct ia32e
value on loading the nested state as it is the best value of
it at that point.
Still do a consistency check of it vs host_ia32_efer in vmcs12.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b4ee5e9f9e201..7b1d5510a7cdc 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2866,6 +2866,17 @@ static int nested_vmx_check_controls(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int nested_vmx_check_address_state_size(struct kvm_vcpu *vcpu,
+				       struct vmcs12 *vmcs12)
+{
+#ifdef CONFIG_X86_64
+	if (CC(!!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE) !=
+		!!(vcpu->arch.efer & EFER_LMA)))
+		return -EINVAL;
+#endif
+	return 0;
+}
+
 static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 				       struct vmcs12 *vmcs12)
 {
@@ -2890,18 +2901,16 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 #ifdef CONFIG_X86_64
-	ia32e = !!(vcpu->arch.efer & EFER_LMA);
+	ia32e = !!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE);
 #else
 	ia32e = false;
 #endif
 
 	if (ia32e) {
-		if (CC(!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE)) ||
-		    CC(!(vmcs12->host_cr4 & X86_CR4_PAE)))
+		if (CC(!(vmcs12->host_cr4 & X86_CR4_PAE)))
 			return -EINVAL;
 	} else {
-		if (CC(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE) ||
-		    CC(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) ||
+		if (CC(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) ||
 		    CC(vmcs12->host_cr4 & X86_CR4_PCIDE) ||
 		    CC((vmcs12->host_rip) >> 32))
 			return -EINVAL;
@@ -3571,6 +3580,9 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	if (nested_vmx_check_controls(vcpu, vmcs12))
 		return nested_vmx_fail(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
 
+	if (nested_vmx_check_address_state_size(vcpu, vmcs12))
+		return nested_vmx_fail(vcpu, VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+
 	if (nested_vmx_check_host_state(vcpu, vmcs12))
 		return nested_vmx_fail(vcpu, VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 
-- 
2.26.3

