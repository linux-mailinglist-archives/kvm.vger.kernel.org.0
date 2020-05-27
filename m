Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946CB1E3CF8
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 11:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388323AbgE0JBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 05:01:14 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46344 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388213AbgE0JBO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 May 2020 05:01:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590570072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=H3stnU91LhnxpV8eTnwJlnlF2JcqMMwBmM20JYfVSKI=;
        b=Wx+0RN9KF2oESFyp8/XuIs0T/rJWihBM5xuxUuvn3zQnlQu2KXHNSCICmE/0MoIsuJ4br7
        3VcM9RsOskltg2SCXJqrUjjCk4zimJwEvZpr/Eo8nqU2bLVxaJWIPZKc9Rmu6pT6lKuSqg
        8Tn4NH1Z5nwalHaYd3ET8To2djkdyYc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-3BAWVqMbMdCBGWSrTSe0cA-1; Wed, 27 May 2020 05:01:07 -0400
X-MC-Unique: 3BAWVqMbMdCBGWSrTSe0cA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A01CD107B26F;
        Wed, 27 May 2020 09:01:06 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B1F25D9E5;
        Wed, 27 May 2020 09:01:03 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Cathy Avery <cavery@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2] KVM: nSVM: Preserve registers modifications done before nested_svm_vmexit()
Date:   Wed, 27 May 2020 11:01:02 +0200
Message-Id: <20200527090102.220647-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

L2 guest hang is observed after 'exit_required' was dropped and nSVM
switched to check_nested_events() completely. The hang is a busy loop when
e.g. KVM is emulating an instruction (e.g. L2 is accessing MMIO space and
we drop to userspace). After nested_svm_vmexit() and when L1 is doing VMRUN
nested guest's RIP is not advanced so KVM goes into emulating the same
instruction which caused nested_svm_vmexit() and the loop continues.

nested_svm_vmexit() is not new, however, with check_nested_events() we're
now calling it later than before. In case by that time KVM has modified
register state we may pick stale values from VMCB when trying to save
nested guest state to nested VMCB.

nVMX code handles this case correctly: sync_vmcs02_to_vmcs12() called from
nested_vmx_vmexit() does e.g 'vmcs12->guest_rip = kvm_rip_read(vcpu)' and
this ensures KVM-made modifications are preserved. Do the same for nSVM.

Generally, nested_vmx_vmexit()/nested_svm_vmexit() need to pick up all
nested guest state modifications done by KVM after vmexit. It would be
great to find a way to express this in a way which would not require to
manually track these changes, e.g. nested_{vmcb,vmcs}_get_field().

Co-debugged-with: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
- Changes from v1:
 s,nVMX,nSVM,g + typos [Sean Christopherson]

- To certain extent we're fixing currently-pending 'KVM: SVM: immediately
 inject INTR vmexit' commit but I'm not certain about that. We had so many
 problems with nested events before switching to check_nested_events() that
 what worked before could just be treated as a miracle. Miracles tend to
 appear and disappear all of a sudden.
---
 arch/x86/kvm/svm/nested.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 0f02521550b9..6b1049148c1b 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -537,9 +537,9 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	nested_vmcb->save.cr2    = vmcb->save.cr2;
 	nested_vmcb->save.cr4    = svm->vcpu.arch.cr4;
 	nested_vmcb->save.rflags = kvm_get_rflags(&svm->vcpu);
-	nested_vmcb->save.rip    = vmcb->save.rip;
-	nested_vmcb->save.rsp    = vmcb->save.rsp;
-	nested_vmcb->save.rax    = vmcb->save.rax;
+	nested_vmcb->save.rip    = kvm_rip_read(&svm->vcpu);
+	nested_vmcb->save.rsp    = kvm_rsp_read(&svm->vcpu);
+	nested_vmcb->save.rax    = kvm_rax_read(&svm->vcpu);
 	nested_vmcb->save.dr7    = vmcb->save.dr7;
 	nested_vmcb->save.dr6    = svm->vcpu.arch.dr6;
 	nested_vmcb->save.cpl    = vmcb->save.cpl;
-- 
2.25.4

