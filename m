Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFB3696AC9
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 18:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbjBNRHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 12:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbjBNRHP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 12:07:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE842BF02
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 09:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676394380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/euHEF+eBWWTQ8m/l/D6fDr7orW6a7TC7pVbt5gTApY=;
        b=XQiW7MFmmBwVO1xmVXg4kUT5knbBz3kfNTV6UD2dnjeQ5pNGg+RVauyCYwZzpmtGDfcQKJ
        etNkIKok/dgnCWBkJ5qq2N+Br7WR/oOtDLqrm0QgZHKxsVJiosbVTg6ccUJDcwagmodpFr
        u2eGq5A3DLy0oYYwFkX9gaShIW+j1cc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-C0fQVVuhO-WnFDA0WU__Lg-1; Tue, 14 Feb 2023 12:06:16 -0500
X-MC-Unique: C0fQVVuhO-WnFDA0WU__Lg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B464857F44;
        Tue, 14 Feb 2023 17:06:16 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E536C15BA0;
        Tue, 14 Feb 2023 17:06:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     thomas.lendacky@amd.com
Subject: [PATCH 2/3] KVM: x86: Mitigate the cross-thread return address predictions bug
Date:   Tue, 14 Feb 2023 12:06:14 -0500
Message-Id: <20230214170615.1297202-3-pbonzini@redhat.com>
In-Reply-To: <20230214170615.1297202-1-pbonzini@redhat.com>
References: <20230214170615.1297202-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

By default, KVM/SVM will intercept attempts by the guest to transition
out of C0. However, the KVM_CAP_X86_DISABLE_EXITS capability can be used
by a VMM to change this behavior. To mitigate the cross-thread return
address predictions bug (X86_BUG_SMT_RSB), a VMM must not be allowed to
override the default behavior to intercept C0 transitions.

Use a module parameter to control the mitigation on processors that are
vulnerable to X86_BUG_SMT_RSB. If the processor is vulnerable to the
X86_BUG_SMT_RSB bug and the module parameter is set to mitigate the bug,
KVM will not allow the disabling of the HLT, MWAIT and CSTATE exits.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Message-Id: <4019348b5e07148eb4d593380a5f6713b93c9a16.1675956146.git.thomas.lendacky@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index da4bbd043a7b..f0fa3de2ceb8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -191,6 +191,10 @@ module_param(enable_pmu, bool, 0444);
 bool __read_mostly eager_page_split = true;
 module_param(eager_page_split, bool, 0644);
 
+/* Enable/disable SMT_RSB bug mitigation */
+bool __read_mostly mitigate_smt_rsb;
+module_param(mitigate_smt_rsb, bool, 0444);
+
 /*
  * Restoring the host value for MSRs that are only consumed when running in
  * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
@@ -4448,10 +4452,15 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_CLOCK_VALID_FLAGS;
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:
-		r |=  KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_PAUSE |
-		      KVM_X86_DISABLE_EXITS_CSTATE;
-		if(kvm_can_mwait_in_guest())
-			r |= KVM_X86_DISABLE_EXITS_MWAIT;
+		r = KVM_X86_DISABLE_EXITS_PAUSE;
+
+		if (!mitigate_smt_rsb) {
+			r |= KVM_X86_DISABLE_EXITS_HLT |
+			     KVM_X86_DISABLE_EXITS_CSTATE;
+
+			if (kvm_can_mwait_in_guest())
+				r |= KVM_X86_DISABLE_EXITS_MWAIT;
+		}
 		break;
 	case KVM_CAP_X86_SMM:
 		if (!IS_ENABLED(CONFIG_KVM_SMM))
@@ -6227,15 +6236,26 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
 			break;
 
-		if ((cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT) &&
-			kvm_can_mwait_in_guest())
-			kvm->arch.mwait_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
-			kvm->arch.hlt_in_guest = true;
 		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
 			kvm->arch.pause_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
-			kvm->arch.cstate_in_guest = true;
+
+#define SMT_RSB_MSG "This processor is affected by the Cross-Thread Return Predictions vulnerability. " \
+		    "KVM_CAP_X86_DISABLE_EXITS should only be used with SMT disabled or trusted guests."
+
+		if (!mitigate_smt_rsb) {
+			if (boot_cpu_has_bug(X86_BUG_SMT_RSB) && cpu_smt_possible() &&
+			    (cap->args[0] & ~KVM_X86_DISABLE_EXITS_PAUSE))
+				pr_warn_once(SMT_RSB_MSG);
+
+			if ((cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT) &&
+			    kvm_can_mwait_in_guest())
+				kvm->arch.mwait_in_guest = true;
+			if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
+				kvm->arch.hlt_in_guest = true;
+			if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
+				kvm->arch.cstate_in_guest = true;
+		}
+
 		r = 0;
 		break;
 	case KVM_CAP_MSR_PLATFORM_INFO:
@@ -13456,6 +13476,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
 static int __init kvm_x86_init(void)
 {
 	kvm_mmu_x86_module_init();
+	mitigate_smt_rsb &= boot_cpu_has_bug(X86_BUG_SMT_RSB) && cpu_smt_possible();
 	return 0;
 }
 module_init(kvm_x86_init);
-- 
2.39.1


