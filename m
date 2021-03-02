Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699E132B5B5
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382787AbhCCHT3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28403 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1836001AbhCBTfg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:35:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bBkHO7y0zCiUNtxmtqqvHcDCQp8TtyKEa9QtIMAzyKA=;
        b=NA82FDgVze2hhBkoz/ltXUzujP+WZRUp0uB2AEE3MNdFZIGDFp2CfUsRJvh15HTkYJF5Zy
        Bg9x4S+0yNLiXvouSucC5U2smJyuij6iIDmZHUEKrrpEIJRLUjuMHkiJ96vDlf0Wa+zfn6
        lOlNWcW0skfsHB3NZtN4pNxHM2J/3YA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-JQunDdptOEW7VGMJdO8l7Q-1; Tue, 02 Mar 2021 14:33:55 -0500
X-MC-Unique: JQunDdptOEW7VGMJdO8l7Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 772751E563;
        Tue,  2 Mar 2021 19:33:54 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20E3C60CC5;
        Tue,  2 Mar 2021 19:33:54 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 18/23] KVM: SVM: Don't manually emulate RDPMC if nrips=0
Date:   Tue,  2 Mar 2021 14:33:38 -0500
Message-Id: <20210302193343.313318-19-pbonzini@redhat.com>
In-Reply-To: <20210302193343.313318-1-pbonzini@redhat.com>
References: <20210302193343.313318-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Remove bizarre code that causes KVM to run RDPMC through the emulator
when nrips is disabled.  Accelerated emulation of RDPMC doesn't rely on
any additional data from the VMCB, and SVM has generic handling for
updating RIP to skip instructions when nrips is disabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210205005750.3841462-9-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8cb31603bce5..3725a4636930 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2424,14 +2424,6 @@ static int rsm_interception(struct kvm_vcpu *vcpu)
 	return kvm_emulate_instruction_from_buffer(vcpu, rsm_ins_bytes, 2);
 }
 
-static int rdpmc_interception(struct kvm_vcpu *vcpu)
-{
-	if (!nrips)
-		return emulate_on_interception(vcpu);
-
-	return kvm_emulate_rdpmc(vcpu);
-}
-
 static bool check_selective_cr0_intercepted(struct kvm_vcpu *vcpu,
 					    unsigned long val)
 {
@@ -3058,7 +3050,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_SMI]				= kvm_emulate_as_nop,
 	[SVM_EXIT_INIT]				= kvm_emulate_as_nop,
 	[SVM_EXIT_VINTR]			= interrupt_window_interception,
-	[SVM_EXIT_RDPMC]			= rdpmc_interception,
+	[SVM_EXIT_RDPMC]			= kvm_emulate_rdpmc,
 	[SVM_EXIT_CPUID]			= kvm_emulate_cpuid,
 	[SVM_EXIT_IRET]                         = iret_interception,
 	[SVM_EXIT_INVD]                         = kvm_emulate_invd,
-- 
2.26.2


