Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36DC51DBB4F
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 19:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgETRWD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 13:22:03 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24743 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727918AbgETRWA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 13:22:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589995319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=3b4tcQFYxfckOxLBmeC1hOIW6HRUkgSyBcFd6KivnZY=;
        b=cUqrUChFxBxgLGcBpS/uYgG8rn6NSUffBEMIcgjyAgKpAekxgHnugvYSdHsmTM9AR+qc5q
        Lb7hZVDRLAA+E8Kk1FDQmrEvyAZkhUJSKsWFl5RqXR5RG/ITcCwg7rpAQx1MuqUmOdQ6eb
        +n9JKvHqkc4mYsfHgnX/fBie3qKVFiw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-zeOqZ5aqNfeE6xDcpqY4uA-1; Wed, 20 May 2020 13:21:56 -0400
X-MC-Unique: zeOqZ5aqNfeE6xDcpqY4uA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A5CC81CBF5;
        Wed, 20 May 2020 17:21:50 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9147182A33;
        Wed, 20 May 2020 17:21:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 04/24] KVM: nSVM: remove exit_required
Date:   Wed, 20 May 2020 13:21:25 -0400
Message-Id: <20200520172145.23284-5-pbonzini@redhat.com>
In-Reply-To: <20200520172145.23284-1-pbonzini@redhat.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All events now inject vmexits before vmentry rather than after vmexit.  Therefore,
exit_required is not set anymore and we can remove it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c |  3 +--
 arch/x86/kvm/svm/svm.c    | 14 --------------
 arch/x86/kvm/svm/svm.h    |  3 ---
 3 files changed, 1 insertion(+), 19 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e80349132ea1..dd2868dd6129 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -785,8 +785,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool block_nested_events =
-		kvm_event_needs_reinjection(vcpu) || svm->nested.exit_required ||
-		svm->nested.nested_run_pending;
+		kvm_event_needs_reinjection(vcpu) || svm->nested.nested_run_pending;
 
 	if (vcpu->arch.exception.pending) {
 		if (block_nested_events)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9da4e5b6d724..04332d0efa5f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2889,13 +2889,6 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	if (npt_enabled)
 		vcpu->arch.cr3 = svm->vmcb->save.cr3;
 
-	if (unlikely(svm->nested.exit_required)) {
-		nested_svm_vmexit(svm);
-		svm->nested.exit_required = false;
-
-		return 1;
-	}
-
 	if (is_guest_mode(vcpu)) {
 		int vmexit;
 
@@ -3327,13 +3320,6 @@ static fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
 	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
 
-	/*
-	 * A vmexit emulation is required before the vcpu can be executed
-	 * again.
-	 */
-	if (unlikely(svm->nested.exit_required))
-		return EXIT_FASTPATH_NONE;
-
 	/*
 	 * Disable singlestep if we're injecting an interrupt/exception.
 	 * We don't want our modified rflags to be pushed on the stack where
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8342032291fc..89fab75dd4f5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -95,9 +95,6 @@ struct nested_state {
 	u64 vmcb_msrpm;
 	u64 vmcb_iopm;
 
-	/* A VMEXIT is required but not yet emulated */
-	bool exit_required;
-
 	/* A VMRUN has started but has not yet been performed, so
 	 * we cannot inject a nested vmexit yet.  */
 	bool nested_run_pending;
-- 
2.18.2


