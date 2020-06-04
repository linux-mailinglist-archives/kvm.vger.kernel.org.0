Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966341EE6B0
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 16:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbgFDOcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 10:32:23 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44992 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728919AbgFDOcX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 10:32:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591281142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=h9M1fLh8Ru9H4w+WFRAfiLMCmRmx0L8dSLxiYIXuu4E=;
        b=Csgr9ZYNuGxpyogb4pKIA22w6EqtVTG9gg/1Uh8UVvOy9mHelu/iQ8yxLTs2Ic1BYsdUkQ
        1gAhlvHDwZG8P2LToCUgGcyHXpfDz8RIhfhgJXeTF1zBN+8FL3d+vbTeYUAOdiy1FdDbJw
        HAEuoqADy31TJco5nWIrrTMlwL1WHjA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-QJFS2nS7OyOa-MMajM20aw-1; Thu, 04 Jun 2020 10:32:20 -0400
X-MC-Unique: QJFS2nS7OyOa-MMajM20aw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B75B1800D42;
        Thu,  4 Jun 2020 14:32:02 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C6FB7CCC1;
        Thu,  4 Jun 2020 14:32:00 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: nVMX: Inject #GP when nested_vmx_get_vmptr() fails to read guest memory
Date:   Thu,  4 Jun 2020 16:31:58 +0200
Message-Id: <20200604143158.484651-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Syzbot reports the following issue:

WARNING: CPU: 0 PID: 6819 at arch/x86/kvm/x86.c:618 kvm_inject_emulated_page_fault+0x210/0x290 arch/x86/kvm/x86.c:618
...
Call Trace:
...
RIP: 0010:kvm_inject_emulated_page_fault+0x210/0x290 arch/x86/kvm/x86.c:618
...
 nested_vmx_get_vmptr+0x1f9/0x2a0 arch/x86/kvm/vmx/nested.c:4638
 handle_vmon arch/x86/kvm/vmx/nested.c:4767 [inline]
 handle_vmon+0x168/0x3a0 arch/x86/kvm/vmx/nested.c:4728
 vmx_handle_exit+0x29c/0x1260 arch/x86/kvm/vmx/vmx.c:6067

'exception' we're trying to inject with kvm_inject_emulated_page_fault() comes from
  nested_vmx_get_vmptr()
   kvm_read_guest_virt()
     kvm_read_guest_virt_helper()
       vcpu->arch.walk_mmu->gva_to_gpa()

but it is only set when GVA to GPA conversion fails. In case it doesn't but
we still fail kvm_vcpu_read_guest_page(), X86EMUL_IO_NEEDED is returned and
nested_vmx_get_vmptr() calls kvm_inject_emulated_page_fault() with zeroed
'exception'. This happen when e.g. VMXON/VMPTRLD/VMCLEAR argument is MMIO.

KVM could've handled the request correctly by going to userspace and
performing I/O but there doesn't seem to be a good need for such requests
in the first place. Sane guests should not call VMXON/VMPTRLD/VMCLEAR with
anything but normal memory. Just inject #GP to find insane ones.

Reported-by: syzbot+2a7156e11dc199bdbd8a@syzkaller.appspotmail.com
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9c74a732b08d..05d57c3cb1ce 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4628,14 +4628,29 @@ static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer)
 {
 	gva_t gva;
 	struct x86_exception e;
+	int r;
 
 	if (get_vmx_mem_address(vcpu, vmx_get_exit_qual(vcpu),
 				vmcs_read32(VMX_INSTRUCTION_INFO), false,
 				sizeof(*vmpointer), &gva))
 		return 1;
 
-	if (kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e)) {
-		kvm_inject_emulated_page_fault(vcpu, &e);
+	r = kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e);
+	if (r != X86EMUL_CONTINUE) {
+		if (r == X86EMUL_PROPAGATE_FAULT) {
+			kvm_inject_emulated_page_fault(vcpu, &e);
+		} else {
+			/*
+			 * X86EMUL_IO_NEEDED is returned when kvm_vcpu_read_guest_page()
+			 * fails to read guest's memory (e.g. when 'gva' points to MMIO
+			 * space). While KVM could've handled the request correctly by
+			 * exiting to userspace and performing I/O, there doesn't seem
+			 * to be a real use-case behind such requests, just inject #GP
+			 * for now.
+			 */
+			kvm_inject_gp(vcpu, 0);
+		}
+
 		return 1;
 	}
 
-- 
2.25.4

