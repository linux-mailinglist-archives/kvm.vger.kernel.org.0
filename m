Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD054E77CB
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 16:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376633AbiCYPcn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 11:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376947AbiCYPce (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 11:32:34 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95805C58
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 08:28:02 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id q8-20020a656a88000000b003810f119b61so4054781pgu.10
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 08:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=jseiWq5rrotCj6SE0FBptrsHZWDpsUi2UXSPKIK8dgk=;
        b=qyj0I5f/xCwa7XbbOHfpc0HtWHoZJDCrm8oH5zdbf6PWdOkuMnRWCRwpmeJLFy6Pk4
         BD9jxrgwW4DibjBjEecGiDmhKz6q4KBJt05GfIZgi02QmSSyWZTMIa5Z2ocgabwfPwRb
         KgYR1kDmFYtPRQOAcz58wG5migaS//k4C4jcdJT3v7hK91gdAyrGlmxuHxtJmnD6pZhL
         TWQlp+8iC2YP03AWDyWz5sUsT71gOhJv2wAUio4R9/lV8PGN2WoD7KY2T3oG3Qbl2Pkw
         RlgtSK1l85bdwlEiiiBIqRI4ZhHNmshjH/uebn69L5DpK/w1eRU9mPm9PujE9YrVCsSg
         iegQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=jseiWq5rrotCj6SE0FBptrsHZWDpsUi2UXSPKIK8dgk=;
        b=X2YiSrSkBv8ZSLBgVzziZ6itOZYfcGqKCM5bcHXIzydc+sc2b4q/9aWKKuF2mv5WzL
         RywyTFUkqJQGr2zfsxujByygi2SpqlIPfEs9/65SYb/SqFFXHwa+Vush5jxtmh7p4x4M
         d5/y8BRDyTUYFA25CFX3JwWNRrduNQPymUqaaC1H3kDLJaDvf6NmW2zbq5+PwIgzEFox
         /H/gTFElQdNF+qG4kzya8L5m+bpJ769g62yj9MBx1PwKfJivD+6ZUW2lVDFBFNmPW3km
         eCpbSNvrvyTfrz3+0RgwvxkDA5+kWi73NYYQbNfe/xKVHTP0FzoAHONJ0yhjm4Q5ogUm
         9/wA==
X-Gm-Message-State: AOAM531/1RhgIt6cs15EzbCgIklVUbEd7IQa9LACAHjF68kRz+zKMA4s
        U0x1wQS3yRkwMncuXiZyvv9wMvsms48Q3B11FtOm9lyHNKmwkZCN9w+38IdgPWkQ3L74bbZCPza
        l+kUJEzaN/Un6xUOD7bTzwhl3ZnMExlEwfU6aU3l0+jPHsBsw4vi3R/Q4Gg==
X-Google-Smtp-Source: ABdhPJxnHXPOftbmUzztnT/5uAtdts5+6+KWOTXoOsKFfFQLqGLDAimI3h4Cn0X0PA8ojfUlnRZuom5jMQE=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:655c:5ed9:95b6:394a])
 (user=pgonda job=sendgmr) by 2002:a17:90a:e545:b0:1c6:d783:6e64 with SMTP id
 ei5-20020a17090ae54500b001c6d7836e64mr26086984pjb.222.1648222081542; Fri, 25
 Mar 2022 08:28:01 -0700 (PDT)
Date:   Fri, 25 Mar 2022 08:27:58 -0700
Message-Id: <20220325152758.335626-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v2] Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Marc Orr <marcorr@google.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV-ES guests can request termination using the GHCB's MSR protocol. See
AMD's GHCB spec section '4.1.13 Termination Request'. Currently when a
guest does this the userspace VMM sees an KVM_EXIT_UNKNOWN (-EVINAL)
return code from KVM_RUN. By adding a KVM_EXIT_SHUTDOWN_ENTRY to kvm_run
struct the userspace VMM can clear see the guest has requested a SEV-ES
termination including the termination reason code set and reason code.

Signed-off-by: Peter Gonda <pgonda@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Marc Orr <marcorr@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---

V2
 * Add KVM_CAP_EXIT_SHUTDOWN_REASON check for KVM_CHECK_EXTENSION.

Tested by making an SEV-ES guest call sev_es_terminate() with hardcoded
reason code set and reason code and then observing the codes from the
userspace VMM in the kvm_run.shutdown.data fields.

---
 arch/x86/kvm/svm/sev.c   |  9 +++++++--
 include/uapi/linux/kvm.h | 13 +++++++++++++
 virt/kvm/kvm_main.c      |  1 +
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 75fa6dd268f0..5f9d37dd3f6f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2735,8 +2735,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 		pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
 			reason_set, reason_code);
 
-		ret = -EINVAL;
-		break;
+		vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
+		vcpu->run->shutdown.reason = KVM_SHUTDOWN_SEV_TERM;
+		vcpu->run->shutdown.ndata = 2;
+		vcpu->run->shutdown.data[0] = reason_set;
+		vcpu->run->shutdown.data[1] = reason_code;
+
+		return 0;
 	}
 	default:
 		/* Error, keep GHCB MSR value as-is */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 8616af85dc5d..017c03421c48 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -271,6 +271,12 @@ struct kvm_xen_exit {
 #define KVM_EXIT_XEN              34
 #define KVM_EXIT_RISCV_SBI        35
 
+/* For KVM_EXIT_SHUTDOWN */
+/* Standard VM shutdown request. No additional metadata provided. */
+#define KVM_SHUTDOWN_REQ	0
+/* SEV-ES termination request */
+#define KVM_SHUTDOWN_SEV_TERM	1
+
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
 #define KVM_INTERNAL_ERROR_EMULATION	1
@@ -311,6 +317,12 @@ struct kvm_run {
 		struct {
 			__u64 hardware_exit_reason;
 		} hw;
+		/* KVM_EXIT_SHUTDOWN */
+		struct {
+			__u64 reason;
+			__u32 ndata;
+			__u64 data[16];
+		} shutdown;
 		/* KVM_EXIT_FAIL_ENTRY */
 		struct {
 			__u64 hardware_entry_failure_reason;
@@ -1145,6 +1157,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PMU_CAPABILITY 212
 #define KVM_CAP_DISABLE_QUIRKS2 213
 #define KVM_CAP_VM_TSC_CONTROL 214
+#define KVM_CAP_EXIT_SHUTDOWN_REASON 215
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 70e05af5ebea..03b6e472f32c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4299,6 +4299,7 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_CHECK_EXTENSION_VM:
 	case KVM_CAP_ENABLE_CAP_VM:
 	case KVM_CAP_HALT_POLL:
+	case KVM_CAP_EXIT_SHUTDOWN_REASON:
 		return 1;
 #ifdef CONFIG_KVM_MMIO
 	case KVM_CAP_COALESCED_MMIO:
-- 
2.35.1.1021.g381101b075-goog

