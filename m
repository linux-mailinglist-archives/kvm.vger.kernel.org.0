Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86CC47AFEA
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 16:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238798AbhLTPWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 10:22:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54029 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239701AbhLTPVx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Dec 2021 10:21:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640013712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/8Rm7dLdwRnhjP9KG5tYNpsd+eF5dfO/0l1xiqlf+F0=;
        b=Zf5VLRw8U2xka1ifUeBDYAov1Siz+Pk5Es4fh6s9dMAs13/kBtaePhXW+2c4wIXoiJVzKY
        ux+XEChNfIlpYID9fsp/m4qDQ8MalRuMQxuA+QjnYQBYWvaDQkoCZaCoxaiHNQAkoW1gTs
        MdPsWuFa3m42+Em4ejjm78YiwDzp90M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-120-c4Nk6iAzOfqgU9HDw2muGQ-1; Mon, 20 Dec 2021 10:21:49 -0500
X-MC-Unique: c4Nk6iAzOfqgU9HDw2muGQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70021874980;
        Mon, 20 Dec 2021 15:21:48 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BD987B6CF;
        Mon, 20 Dec 2021 15:21:44 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] KVM: SVM: Drop stale comment from svm_hv_vmcb_dirty_nested_enlightenments()
Date:   Mon, 20 Dec 2021 16:21:35 +0100
Message-Id: <20211220152139.418372-2-vkuznets@redhat.com>
In-Reply-To: <20211220152139.418372-1-vkuznets@redhat.com>
References: <20211220152139.418372-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 3fa5e8fd0a0e4 ("KVM: SVM: delay svm_vcpu_init_msrpm after
svm->vmcb is initialized") re-arranged svm_vcpu_init_msrpm() call in
svm_create_vcpu() making the comment about vmcb being NULL
obsolete. Drop it.

While on it, drop superfluous vmcb_is_clean() check: vmcb_mark_dirty()
is a bit flip, an extra check is unlikely to bring any performance gain.
Drop now-unneeded vmcb_is_clean() helper as well.

Fixes: 3fa5e8fd0a0e4 ("KVM: SVM: delay svm_vcpu_init_msrpm after svm->vmcb is initialized")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/svm.h          | 5 -----
 arch/x86/kvm/svm/svm_onhyperv.h | 9 +--------
 2 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index daa8ca84afcc..5d197aae3a19 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -305,11 +305,6 @@ static inline void vmcb_mark_all_clean(struct vmcb *vmcb)
 			       & ~VMCB_ALWAYS_DIRTY_MASK;
 }
 
-static inline bool vmcb_is_clean(struct vmcb *vmcb, int bit)
-{
-	return (vmcb->control.clean & (1 << bit));
-}
-
 static inline void vmcb_mark_dirty(struct vmcb *vmcb, int bit)
 {
 	vmcb->control.clean &= ~(1 << bit);
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index c53b8bf8d013..cdbcfc63d171 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -83,14 +83,7 @@ static inline void svm_hv_vmcb_dirty_nested_enlightenments(
 	struct hv_enlightenments *hve =
 		(struct hv_enlightenments *)vmcb->control.reserved_sw;
 
-	/*
-	 * vmcb can be NULL if called during early vcpu init.
-	 * And its okay not to mark vmcb dirty during vcpu init
-	 * as we mark it dirty unconditionally towards end of vcpu
-	 * init phase.
-	 */
-	if (vmcb_is_clean(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS) &&
-	    hve->hv_enlightenments_control.msr_bitmap)
+	if (hve->hv_enlightenments_control.msr_bitmap)
 		vmcb_mark_dirty(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
 }
 
-- 
2.33.1

