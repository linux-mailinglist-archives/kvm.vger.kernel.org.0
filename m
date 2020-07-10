Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBDD21B7FA
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 16:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgGJOMn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 10:12:43 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44344 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728283AbgGJOMa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jul 2020 10:12:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594390348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XmvusRmRBvAWHNl6x2vdSNs3ESLbQ79QZieDa9NwqUw=;
        b=SqvGH9DInChS9dgQTCmuhIxClUETR7fBVrqpO3mZdjTxFv3+EYsxomKlkeCZ+zFGlws1UY
        GeeGUFat38GzgwYRNxh2J2QqpQfuacjmfbndOs0EzzWu4nNpp+PNavMjSyO414X34jc4ro
        ls7/eJ21S8fchWtikv8EKrI6ZYfSNB8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-sh3p7GSJOGCcPKFg0z6B8w-1; Fri, 10 Jul 2020 10:12:25 -0400
X-MC-Unique: sh3p7GSJOGCcPKFg0z6B8w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C48251080;
        Fri, 10 Jul 2020 14:12:23 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4AC81CA;
        Fri, 10 Jul 2020 14:12:19 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 8/9] KVM: nSVM: use nested_svm_load_cr3() on guest->host switch
Date:   Fri, 10 Jul 2020 16:11:56 +0200
Message-Id: <20200710141157.1640173-9-vkuznets@redhat.com>
In-Reply-To: <20200710141157.1640173-1-vkuznets@redhat.com>
References: <20200710141157.1640173-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make nSVM code resemble nVMX where nested_vmx_load_cr3() is used on
both guest->host and host->guest transitions. Also, we can now
eliminate unconditional kvm_mmu_reset_context() and speed things up.

Note, nVMX has two different paths: load_vmcs12_host_state() and
nested_vmx_restore_host_state() and the later is used to restore from
'partial' switch to L2, it always uses kvm_mmu_reset_context().
nSVM doesn't have this yet. Also, nested_svm_vmexit()'s return value
is almost always ignored nowadays.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 219871752dc5..434e527096b7 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -317,7 +317,7 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 }
 
 /*
- * Load guest's cr3 at nested entry. @nested_npt is true if we are
+ * Load guest's/host's cr3 at nested entry. @nested_npt is true if we are
  * emulating VM-Entry into a guest with NPT enabled.
  */
 static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
@@ -651,15 +651,12 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	nested_svm_uninit_mmu_context(&svm->vcpu);
 
-	if (npt_enabled) {
-		svm->vmcb->save.cr3 = hsave->save.cr3;
-		svm->vcpu.arch.cr3 = hsave->save.cr3;
-	} else {
-		(void)kvm_set_cr3(&svm->vcpu, hsave->save.cr3);
-	}
+	rc = nested_svm_load_cr3(&svm->vcpu, hsave->save.cr3, false);
+	if (rc)
+		return 1;
 
-	kvm_mmu_reset_context(&svm->vcpu);
-	kvm_mmu_load(&svm->vcpu);
+	if (npt_enabled)
+		svm->vmcb->save.cr3 = hsave->save.cr3;
 
 	/*
 	 * Drop what we picked up for L2 via svm_complete_interrupts() so it
-- 
2.25.4

