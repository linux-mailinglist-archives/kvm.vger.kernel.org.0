Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F17F37157F
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 14:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbhECM4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 08:56:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43248 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233941AbhECM4A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 08:56:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620046507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rOdBnrV/ozgPq/E+ZPxQpbDjj2a9qSCe2Sxf9ThL1PM=;
        b=ebO47rYauteEBM/YV1Z4hLv4ShJJhf/3+0plNU6AFgGeXyHYePqTVEm3DwlGeOz2s5A7Qv
        BIeoe5ycSC3dQMb4itusaBwaiYXNvkLPP4jxWwlXFa9+pQSpGjwoVMLd+govfBeJ+3rsWJ
        GAKazgk+O6/wr8oy+ONPadLPz1ZVNEo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-spOVnigBOqiaQKDQpJhLag-1; Mon, 03 May 2021 08:55:03 -0400
X-MC-Unique: spOVnigBOqiaQKDQpJhLag-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A88A8042AE;
        Mon,  3 May 2021 12:55:01 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5586660C4A;
        Mon,  3 May 2021 12:54:57 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Sean Christopherson <seanjc@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/5] KVM: nSVM: fix few bugs in the vmcb02 caching logic
Date:   Mon,  3 May 2021 15:54:43 +0300
Message-Id: <20210503125446.1353307-3-mlevitsk@redhat.com>
In-Reply-To: <20210503125446.1353307-1-mlevitsk@redhat.com>
References: <20210503125446.1353307-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Define and use an invalid GPA (all ones) for init value of last
  and current nested vmcb physical addresses.

* Reset the current vmcb12 gpa to the invalid value when leaving
  the nested mode, similar to what is done on nested vmexit.

* Reset	the last seen vmcb12 address when disabling the nested SVM,
  as it relies on vmcb02 fields which are freed at that point.

Fixes: 4995a3685f1b ("KVM: SVM: Use a separate vmcb for the nested L2 guest")

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/nested.c       | 11 +++++++++++
 arch/x86/kvm/svm/svm.c          |  4 ++--
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3e5fc80a35c8..4b95e7c4a4e3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -113,6 +113,7 @@
 #define VALID_PAGE(x) ((x) != INVALID_PAGE)
 
 #define UNMAPPED_GVA (~(gpa_t)0)
+#define INVALID_GPA (~(gpa_t)0)
 
 /* KVM Hugepage definitions for x86 */
 #define KVM_MAX_HUGEPAGE_LEVEL	PG_LEVEL_1G
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 3321220f3deb..a88c64e004c3 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -872,6 +872,15 @@ void svm_free_nested(struct vcpu_svm *svm)
 	__free_page(virt_to_page(svm->nested.vmcb02.ptr));
 	svm->nested.vmcb02.ptr = NULL;
 
+	/*
+	 * When last_vmcb12_gpa matches the current vmcb12 gpa,
+	 * some vmcb12 fields are not loaded if they are marked clean
+	 * in the vmcb12, since in this case they are up to date already.
+	 *
+	 * When the vmcb02 is freed, this optimization becomes invalid.
+	 */
+	svm->nested.last_vmcb12_gpa = INVALID_GPA;
+
 	svm->nested.initialized = false;
 }
 
@@ -884,6 +893,8 @@ void svm_leave_nested(struct vcpu_svm *svm)
 
 	if (is_guest_mode(vcpu)) {
 		svm->nested.nested_run_pending = 0;
+		svm->nested.vmcb12_gpa = INVALID_GPA;
+
 		leave_guest_mode(vcpu);
 
 		svm_switch_vmcb(svm, &svm->vmcb01);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a7271f31df47..987173e1f954 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1235,8 +1235,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	svm->current_vmcb->asid_generation = 0;
 	svm->asid = 0;
 
-	svm->nested.vmcb12_gpa = 0;
-	svm->nested.last_vmcb12_gpa = 0;
+	svm->nested.vmcb12_gpa = INVALID_GPA;
+	svm->nested.last_vmcb12_gpa = INVALID_GPA;
 	vcpu->arch.hflags = 0;
 
 	if (!kvm_pause_in_guest(vcpu->kvm)) {
-- 
2.26.2

