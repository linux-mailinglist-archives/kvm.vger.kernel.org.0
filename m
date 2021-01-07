Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2FDD2ECCF5
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 10:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbhAGJkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 04:40:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36152 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725974AbhAGJkk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Jan 2021 04:40:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610012354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NxSMAaCU1+Ace6MFz6Sw2uCAGbOsmC/c4cEEXACLBU0=;
        b=dKjTCMerh1hi7vEvDnCGxRP5I8Sen4iIXGYfzShsIDrMz/QNHcwGns1E+j6ModsvWqf5YO
        MUKSFik0tNVUGKAYsafxsms9/c+aUMV90eMoomWb8QeeLBY76pQJNXUDFbNG05+PZqX1z1
        d8jFHXWyoQfjl3HK4FlpLFjUkeGQCFU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-I16WtAcZMLqPnyUM8YngAg-1; Thu, 07 Jan 2021 04:39:12 -0500
X-MC-Unique: I16WtAcZMLqPnyUM8YngAg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9400918C89C4;
        Thu,  7 Jan 2021 09:39:10 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BDD219714;
        Thu,  7 Jan 2021 09:39:03 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 1/4] KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES on nested vmexit
Date:   Thu,  7 Jan 2021 11:38:51 +0200
Message-Id: <20210107093854.882483-2-mlevitsk@redhat.com>
In-Reply-To: <20210107093854.882483-1-mlevitsk@redhat.com>
References: <20210107093854.882483-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is possible to exit the nested guest mode, entered by
svm_set_nested_state prior to first vm entry to it (e.g due to pending event)
if the nested run was not pending during the migration.

In this case we must not switch to the nested msr permission bitmap.
Also add a warning to catch similar cases in the future.

Fixes: a7d5c7ce41ac1 ("KVM: nSVM: delay MSR permission processing to first nested VM run")

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b0b667456b2e7..ee4f2082ad1bd 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -199,6 +199,10 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (WARN_ON_ONCE(!is_guest_mode(&svm->vcpu)))
+		return false;
+
 	if (!nested_svm_vmrun_msrpm(svm)) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror =
@@ -595,6 +599,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	svm->nested.vmcb12_gpa = 0;
 	WARN_ON_ONCE(svm->nested.nested_run_pending);
 
+	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, &svm->vcpu);
+
 	/* in case we halted in L2 */
 	svm->vcpu.arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
-- 
2.26.2

