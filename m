Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F5021A29A
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 16:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgGIOyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 10:54:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28477 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726517AbgGIOyc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 10:54:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594306471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j7yTImMh6+ITQjJDMmXSkQMQueE7UvWx3TTOie3G7M4=;
        b=QVmA6qN+X+96LxIlAuOcWB6dNlPQNGX+X1RJ9I0egOoad1nQgiocHWDLRB+PsJKDnE0edh
        j7jUuvGqkRLEko+hzAcvjQxC1STs20bKJoYgpxfxjpDdDm3TZAS5C/1QvOwqgbLqApDFDs
        tIa8p/so7ySHEoclHPHldGDYix2meNw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-2G9mRWUdOD2xDAPakXMwAA-1; Thu, 09 Jul 2020 10:54:27 -0400
X-MC-Unique: 2G9mRWUdOD2xDAPakXMwAA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 289E61080;
        Thu,  9 Jul 2020 14:54:26 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B924C60E1C;
        Thu,  9 Jul 2020 14:54:21 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/9] KVM: nSVM: move kvm_set_cr3() after nested_svm_uninit_mmu_context()
Date:   Thu,  9 Jul 2020 16:53:55 +0200
Message-Id: <20200709145358.1560330-7-vkuznets@redhat.com>
In-Reply-To: <20200709145358.1560330-1-vkuznets@redhat.com>
References: <20200709145358.1560330-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
index d0fd63e8d835..5f001d2c41d1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -621,12 +621,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
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
@@ -646,6 +640,14 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
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

