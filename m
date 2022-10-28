Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D68611DEE
	for <lists+kvm@lfdr.de>; Sat, 29 Oct 2022 01:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiJ1XJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 19:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiJ1XIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 19:08:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207C2237979
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 16:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666998472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qKAZXkZJtpUt62IhOwfn3MjnyGa85xWMPC5G5TYNnRk=;
        b=R79jSXz83YB9R70cxkaCVdXpUqn2BNGK4fgRUfN/xuUZbuy82m0XsO3shbr69ehO+AemmO
        Q5+qKkjJzWl01eLnuPzT3qZg+V2gudylPDECHtb3PGjZgANv66k63+jcAaouBvvLjzp62v
        sL3CGi9yCpN9z9FIEwfXtk/ghzmZQBc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-BYpYsE0SNKWnTqvGjhIPUA-1; Fri, 28 Oct 2022 19:07:50 -0400
X-MC-Unique: BYpYsE0SNKWnTqvGjhIPUA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24F3C38041D9;
        Fri, 28 Oct 2022 23:07:50 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53AAC40C955C;
        Fri, 28 Oct 2022 23:07:42 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com, jpoimboe@kernel.org
Subject: [PATCH 7/7] x86, KVM: remove unnecessary argument to x86_virt_spec_ctrl and callers
Date:   Fri, 28 Oct 2022 19:07:23 -0400
Message-Id: <20221028230723.3254250-8-pbonzini@redhat.com>
In-Reply-To: <20221028230723.3254250-1-pbonzini@redhat.com>
References: <20221028230723.3254250-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

x86_virt_spec_ctrl only deals with the paravirtualized
MSR_IA32_VIRT_SPEC_CTRL now and does not handle MSR_IA32_SPEC_CTRL
anymore; remove the corresponding, unused argument.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/spec-ctrl.h | 10 +++++-----
 arch/x86/kernel/cpu/bugs.c       |  2 +-
 arch/x86/kvm/svm/svm.c           |  4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/spec-ctrl.h b/arch/x86/include/asm/spec-ctrl.h
index 5393babc0598..cb0386fc4dc3 100644
--- a/arch/x86/include/asm/spec-ctrl.h
+++ b/arch/x86/include/asm/spec-ctrl.h
@@ -13,7 +13,7 @@
  * Takes the guest view of SPEC_CTRL MSR as a parameter and also
  * the guest's version of VIRT_SPEC_CTRL, if emulated.
  */
-extern void x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bool guest);
+extern void x86_virt_spec_ctrl(u64 guest_virt_spec_ctrl, bool guest);
 
 /**
  * x86_spec_ctrl_set_guest - Set speculation control registers for the guest
@@ -24,9 +24,9 @@ extern void x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bo
  * Avoids writing to the MSR if the content/bits are the same
  */
 static inline
-void x86_spec_ctrl_set_guest(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl)
+void x86_spec_ctrl_set_guest(u64 guest_virt_spec_ctrl)
 {
-	x86_virt_spec_ctrl(guest_spec_ctrl, guest_virt_spec_ctrl, true);
+	x86_virt_spec_ctrl(guest_virt_spec_ctrl, true);
 }
 
 /**
@@ -38,9 +38,9 @@ void x86_spec_ctrl_set_guest(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl)
  * Avoids writing to the MSR if the content/bits are the same
  */
 static inline
-void x86_spec_ctrl_restore_host(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl)
+void x86_spec_ctrl_restore_host(u64 guest_virt_spec_ctrl)
 {
-	x86_virt_spec_ctrl(guest_spec_ctrl, guest_virt_spec_ctrl, false);
+	x86_virt_spec_ctrl(guest_virt_spec_ctrl, false);
 }
 
 /* AMD specific Speculative Store Bypass MSR data */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 6ec0b7ce7453..3e3230cccaa7 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -200,7 +200,7 @@ void __init check_bugs(void)
  * MSR_IA32_SPEC_CTRL for SSBD.
  */
 void
-x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bool setguest)
+x86_virt_spec_ctrl(u64 guest_virt_spec_ctrl, bool setguest)
 {
 	u64 guestval, hostval;
 	struct thread_info *ti = current_thread_info();
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a79cdeebc181..7b87a4e43708 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4011,7 +4011,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * being speculatively taken.
 	 */
 	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
-		x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
+		x86_spec_ctrl_set_guest(svm->virt_spec_ctrl);
 
 	svm_vcpu_enter_exit(vcpu);
 
@@ -4019,7 +4019,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 		reload_tss(vcpu);
 
 	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
-		x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
+		x86_spec_ctrl_restore_host(svm->virt_spec_ctrl);
 
 	if (!sev_es_guest(vcpu->kvm)) {
 		vcpu->arch.cr2 = svm->vmcb->save.cr2;
-- 
2.31.1

