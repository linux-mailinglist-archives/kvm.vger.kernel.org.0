Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32464ECC4F
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 20:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350059AbiC3ScA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 14:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350540AbiC3Sbg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 14:31:36 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC31D5BD12
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 11:28:25 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y193-20020a25dcca000000b00636d788e549so15161398ybe.5
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 11:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=jmgCw6kISPnali1TsGqrUP2G6TvOrvnV5m3QbxQ3ssQ=;
        b=kEdBAyQBFBp4Qp370oNm6uwMhIbqmivDpG4x7fY59Eb7SP6v68K3JYFXDoABc9rAy3
         YfqWdY9J061PoYjrth242bXd1LDvoKTbBTby7PhTO7RfY51SdX7qA1ubTgE20STzRcbz
         tTavbw/GBGy+AZpnAnIaFPTaZ17Pg2JDs46ON5Dh4D/MxnVhzUOQ+hjYn5cgiY77f/QB
         L5Wj3aihbe/ahGFKdFyEFJ6PwW1iRevrszRDKJm1sV9dK7BKPjns1ihnwGnr0c2c9ZO3
         irzBXN8L7a2TTpbW+v5Akd8Z9rGrgSQkPWNO8bgA7IXluomk1AQZApeKEIjV7jPtVCWw
         yFqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=jmgCw6kISPnali1TsGqrUP2G6TvOrvnV5m3QbxQ3ssQ=;
        b=1G2GICfVCmDUKfJjQstfLl8Cr8he1w7QFEZyLvv14t6K2Xu8mLo5Afn7ZFXVJYUG6D
         bU19QEIuo7YW2zquxUJpcNHm/ca0GwWVDMoB4K+QJe+5zYIAt3SZcLRZYNdmR+YMydYY
         8NJ26fzGzwtxrJ+Lof/VOg9iC3MNXbiSNS0/0n94U/lB63Yn7ASf6b110rSSIVJw1nRM
         MgLvvs1Ggl/nsbmiTH4XsH4CpJbygjh4DXFqdORbc6ZrkZBequLI7QFv9wSp7PNiz6nM
         Xw9ikdcfgbyc4XnEWn7B/C4cgzfb+xaOrDkX+vkFpDwL2OaZEqn/te9qG1OA//X8qXxL
         GegA==
X-Gm-Message-State: AOAM533SKJJCl69TqzQcTGa/m5IZqqynWgXbqcOo5ZPxOu+6gTQRFQn4
        rHzdWIVG3OxutaMn1ap/4SYEleen6+/3jTM022dVnBEVwlvAIAs/QT1wsFXMW5XYfypLvIg/Y8C
        CHNO7GXjKs2PZ0Iw8eixOhBVVjRl5dRtjsQBDJK2Ik0heV2EdUHXeZXphSQ==
X-Google-Smtp-Source: ABdhPJyRZIjpFV9+Yx2mRL79pA3Rp0G3GDJQzgMvekoEb1wy8pluFXuFuUuuY/RFQJGQ7mSAOhMWjB8j21g=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:7348:3252:2b73:955c])
 (user=pgonda job=sendgmr) by 2002:a25:8c10:0:b0:61d:b17e:703d with SMTP id
 k16-20020a258c10000000b0061db17e703dmr988403ybl.154.1648664904800; Wed, 30
 Mar 2022 11:28:24 -0700 (PDT)
Date:   Wed, 30 Mar 2022 11:28:21 -0700
Message-Id: <20220330182821.2633150-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>
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
struct the userspace VMM can clearly see the guest has requested a SEV-ES
termination including the termination reason code set and reason code.

Signed-off-by: Peter Gonda <pgonda@google.com>

---
V3
 * Add Documentation/ update.
 * Updated other KVM_EXIT_SHUTDOWN exits to clear ndata and set reason
   to KVM_SHUTDOWN_REQ.

V2
 * Add KVM_CAP_EXIT_SHUTDOWN_REASON check for KVM_CHECK_EXTENSION.

Tested by making an SEV-ES guest call sev_es_terminate() with hardcoded
reason code set and reason code and then observing the codes from the
userspace VMM in the kvm_run.shutdown.data fields.

Change-Id: I55dcdf0f42bfd70d0e59829ae70c2fb067b60809
---
 Documentation/virt/kvm/api.rst | 12 ++++++++++++
 arch/x86/kvm/svm/sev.c         |  9 +++++++--
 arch/x86/kvm/svm/svm.c         |  2 ++
 arch/x86/kvm/vmx/vmx.c         |  2 ++
 arch/x86/kvm/x86.c             |  2 ++
 include/uapi/linux/kvm.h       | 13 +++++++++++++
 virt/kvm/kvm_main.c            |  1 +
 7 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 2aebb89576d1..d53a66a3760e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7834,3 +7834,15 @@ only be invoked on a VM prior to the creation of VCPUs.
 At this time, KVM_PMU_CAP_DISABLE is the only capability.  Setting
 this capability will disable PMU virtualization for that VM.  Usermode
 should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
+
+8.36 KVM_CAP_EXIT_SHUTDOWN_REASON
+---------------------------
+
+:Capability KVM_CAP_EXIT_SHUTDOWN_REASON
+:Architectures: x86
+:Type: vm
+
+This capability means shutdown metadata may be included in
+kvm_run.shutdown when a vCPU exits with KVM_EXIT_SHUTDOWN. This
+may help userspace determine the guest's reason for termination and
+if the guest should be restarted or an error caused the shutdown.
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
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6535adee3e9c..c2cc10776517 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1953,6 +1953,8 @@ static int shutdown_interception(struct kvm_vcpu *vcpu)
 	kvm_vcpu_reset(vcpu, true);
 
 	kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
+	vcpu->run->shutdown.reason = KVM_SHUTDOWN_REQ;
+	vcpu->run->shutdown.ndata = 0;
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 84a7500cd80c..85b21fc490e4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4988,6 +4988,8 @@ static __always_inline int handle_external_interrupt(struct kvm_vcpu *vcpu)
 static int handle_triple_fault(struct kvm_vcpu *vcpu)
 {
 	vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
+	vcpu->run->shutdown.reason = KVM_SHUTDOWN_REQ;
+	vcpu->run->shutdown.ndata = 0;
 	vcpu->mmio_needed = 0;
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d3a9ce07a565..f7cd224a4c32 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9999,6 +9999,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 				kvm_x86_ops.nested_ops->triple_fault(vcpu);
 			} else {
 				vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
+				vcpu->run->shutdown.reason = KVM_SHUTDOWN_REQ;
+				vcpu->run->shutdown.ndata = 0;
 				vcpu->mmio_needed = 0;
 				r = 0;
 				goto out;
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
2.35.1.1094.g7c7d902a7c-goog

