Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77381E823D
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgE2PmI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:42:08 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21610 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727842AbgE2Pjn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 11:39:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590766782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZUcv6KywkWh0MvwU01dbh4cm2JoFhhHgq5VXKcO/XrM=;
        b=f7H9ByZvO/jAw+dnfSkK490fH4jFAA6ijWI2eoP8J69wDf7mENOXcxm/PbqTsvt81m1Nrb
        AzLs28z7eJoCWWOVzIeHySosMR3k/O2wz+a2Ncg8G6kTQknC9keQiNK+bJC7pBs5ZIiP+F
        wF8xwlMsNlBJdchejqlfe0aZ1rvjOs0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-U54byFrcPxGKIeWayM8tzg-1; Fri, 29 May 2020 11:39:38 -0400
X-MC-Unique: U54byFrcPxGKIeWayM8tzg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4649107ACF8;
        Fri, 29 May 2020 15:39:37 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C76D5D9D5;
        Fri, 29 May 2020 15:39:37 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 04/30] KVM: nSVM: remove exit_required
Date:   Fri, 29 May 2020 11:39:08 -0400
Message-Id: <20200529153934.11694-5-pbonzini@redhat.com>
In-Reply-To: <20200529153934.11694-1-pbonzini@redhat.com>
References: <20200529153934.11694-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
index 1ae13fd17028..3d17c62a84a3 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -792,8 +792,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool block_nested_events =
-		kvm_event_needs_reinjection(vcpu) || svm->nested.exit_required ||
-		svm->nested.nested_run_pending;
+		kvm_event_needs_reinjection(vcpu) || svm->nested.nested_run_pending;
 
 	if (vcpu->arch.exception.pending) {
 		if (block_nested_events)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 89b6fb1e0abc..545f63ebc720 100644
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
2.26.2


