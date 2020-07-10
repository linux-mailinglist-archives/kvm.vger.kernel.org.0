Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A719C21B7FE
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 16:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgGJOMZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 10:12:25 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50434 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728182AbgGJOMW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jul 2020 10:12:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594390340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MP4M7clNN5oqxLBzjzRxPYbA7YU4zZ8ggMiPan3Nmrc=;
        b=euvQXaXhS7sAN0zDx76Wr9pqZ+qIiwji0TFOFjhJB1AZbt6WyBd3mFReJKpoXIwQmNDwem
        9wEZIaLuIj+lOZtVq6WZ8eZBsBd0bVch9vW5bCff9/eY4Z9Fl8wXJH/znfW4gYV4hJK0eb
        NCBrm0LZd68NTcrmBLyzo+eINkp+oqw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-_wZxCJeGPQmPw-7U03KsDA-1; Fri, 10 Jul 2020 10:12:17 -0400
X-MC-Unique: _wZxCJeGPQmPw-7U03KsDA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99F7480BCA0;
        Fri, 10 Jul 2020 14:12:16 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 728F61CA;
        Fri, 10 Jul 2020 14:12:14 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 6/9] KVM: nSVM: move kvm_set_cr3() after nested_svm_uninit_mmu_context()
Date:   Fri, 10 Jul 2020 16:11:54 +0200
Message-Id: <20200710141157.1640173-7-vkuznets@redhat.com>
In-Reply-To: <20200710141157.1640173-1-vkuznets@redhat.com>
References: <20200710141157.1640173-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_mmu_new_pgd() refers to arch.mmu and at this point it still references
arch.guest_mmu while arch.root_mmu is expected.

Note, the change is effectively a nop: when !npt_enabled,
nested_svm_uninit_mmu_context() does nothing (as we don't do
nested_svm_init_mmu_context()) and with npt_enabled we don't
do kvm_set_cr3() but we're about to switch to nested_svm_load_cr3().

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 180929f3dbef..2c308dfa5468 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -611,12 +611,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	svm_set_efer(&svm->vcpu, hsave->save.efer);
 	svm_set_cr0(&svm->vcpu, hsave->save.cr0 | X86_CR0_PE);
 	svm_set_cr4(&svm->vcpu, hsave->save.cr4);
-	if (npt_enabled) {
-		svm->vmcb->save.cr3 = hsave->save.cr3;
-		svm->vcpu.arch.cr3 = hsave->save.cr3;
-	} else {
-		(void)kvm_set_cr3(&svm->vcpu, hsave->save.cr3);
-	}
 	kvm_rax_write(&svm->vcpu, hsave->save.rax);
 	kvm_rsp_write(&svm->vcpu, hsave->save.rsp);
 	kvm_rip_write(&svm->vcpu, hsave->save.rip);
@@ -636,6 +630,14 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	kvm_vcpu_unmap(&svm->vcpu, &map, true);
 
 	nested_svm_uninit_mmu_context(&svm->vcpu);
+
+	if (npt_enabled) {
+		svm->vmcb->save.cr3 = hsave->save.cr3;
+		svm->vcpu.arch.cr3 = hsave->save.cr3;
+	} else {
+		(void)kvm_set_cr3(&svm->vcpu, hsave->save.cr3);
+	}
+
 	kvm_mmu_reset_context(&svm->vcpu);
 	kvm_mmu_load(&svm->vcpu);
 
-- 
2.25.4

