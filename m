Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261E421B9EA
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 17:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgGJPsy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 11:48:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49972 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728276AbgGJPsv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 11:48:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594396130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FfpxmN5laAl/y/N2q1Y7cTgVN6qGZtCHt/1dR+y0tY8=;
        b=PoCI2Bro5qGPMhLR5fchEupLQvAiLcochmcn59nTnBO/SiOtZqRzk/bfptPdPe6PLfGLaW
        WLGtb7OQArhZuNUqkktyqh6Hfo0MUaXs4dIVAyCZlS+MAwolVXRal1v2n6CPL5UQiDPBPg
        +5dSJ6u0QknSqkOymxo3bskfoph2Snc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-l2N29321O0ieKsqQhVWYWQ-1; Fri, 10 Jul 2020 11:48:48 -0400
X-MC-Unique: l2N29321O0ieKsqQhVWYWQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67BBF1083;
        Fri, 10 Jul 2020 15:48:46 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-235.ams2.redhat.com [10.36.114.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33A265BAC3;
        Fri, 10 Jul 2020 15:48:44 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org,
        Mohammed Gamal <mgamal@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Babu Moger <babu.moger@amd.com>
Subject: [PATCH v3 9/9] KVM: x86: SVM: VMX: Make GUEST_MAXPHYADDR < HOST_MAXPHYADDR support configurable
Date:   Fri, 10 Jul 2020 17:48:11 +0200
Message-Id: <20200710154811.418214-10-mgamal@redhat.com>
In-Reply-To: <20200710154811.418214-1-mgamal@redhat.com>
References: <20200710154811.418214-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The reason behind including this patch is unexpected behaviour we see
with NPT vmexit handling in AMD processor.

With previous patch ("KVM: SVM: Add guest physical address check in
NPF/PF interception") we see the followning error multiple times in
the 'access' test in kvm-unit-tests:

            test pte.p pte.36 pde.p: FAIL: pte 2000021 expected 2000001
            Dump mapping: address: 0x123400000000
            ------L4: 24c3027
            ------L3: 24c4027
            ------L2: 24c5021
            ------L1: 1002000021

This shows that the PTE's accessed bit is apparently being set by
the CPU hardware before the NPF vmexit. This completely handled by
hardware and can not be fixed in software.

This patch introduces a workaround. We add a boolean variable:
'allow_smaller_maxphyaddr'
Which is set individually by VMX and SVM init routines. On VMX it's
always set to true, on SVM it's only set to true when NPT is not
enabled.

We also add a new capability KVM_CAP_SMALLER_MAXPHYADDR which
allows userspace to query if the underlying architecture would
support GUEST_MAXPHYADDR < HOST_MAXPHYADDR and hence act accordingly
(e.g. qemu can decide if it would ignore the -cpu ..,phys-bits=X)

CC: Tom Lendacky <thomas.lendacky@amd.com>
CC: Babu Moger <babu.moger@amd.com>
Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm/svm.c          | 15 +++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  7 +++++++
 arch/x86/kvm/x86.c              |  6 ++++++
 include/uapi/linux/kvm.h        |  1 +
 5 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bb4044ffb7b7..26002e1b47f7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1304,7 +1304,7 @@ struct kvm_arch_async_pf {
 };
 
 extern u64 __read_mostly host_efer;
-
+extern bool __read_mostly allow_smaller_maxphyaddr;
 extern struct kvm_x86_ops kvm_x86_ops;
 
 #define __KVM_HAVE_ARCH_VM_ALLOC
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 79c33b3539f0..f3d7ae26875c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -924,6 +924,21 @@ static __init int svm_hardware_setup(void)
 
 	svm_set_cpu_caps();
 
+	/*
+	 * It seems that on AMD processors PTE's accessed bit is
+	 * being set by the CPU hardware before the NPF vmexit.
+	 * This is not expected behaviour and our tests fail because
+	 * of it.
+	 * A workaround here is to disable support for
+	 * GUEST_MAXPHYADDR < HOST_MAXPHYADDR if NPT is enabled.
+	 * In this case userspace can know if there is support using
+	 * KVM_CAP_SMALLER_MAXPHYADDR extension and decide how to handle
+	 * it
+	 * If future AMD CPU models change the behaviour described above,
+	 * this variable can be changed accordingly
+	 */
+	allow_smaller_maxphyaddr = !npt_enabled;
+
 	return 0;
 
 err:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0cebc4832805..8a8e85e6c529 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8294,6 +8294,13 @@ static int __init vmx_init(void)
 #endif
 	vmx_check_vmcs12_offsets();
 
+	/*
+	 * Intel processors don't have problems with
+	 * GUEST_MAXPHYADDR < HOST_MAXPHYADDR so enable
+	 * it for VMX by default
+	 */
+	allow_smaller_maxphyaddr = true;
+
 	return 0;
 }
 module_init(vmx_init);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 03c401963062..167becd6a634 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -187,6 +187,9 @@ static struct kvm_shared_msrs __percpu *shared_msrs;
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
 
+bool __read_mostly allow_smaller_maxphyaddr;
+EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
+
 static u64 __read_mostly host_xss;
 u64 __read_mostly supported_xss;
 EXPORT_SYMBOL_GPL(supported_xss);
@@ -3538,6 +3541,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
 		r = kvm_x86_ops.nested_ops->enable_evmcs != NULL;
 		break;
+	case KVM_CAP_SMALLER_MAXPHYADDR:
+		r = (int) allow_smaller_maxphyaddr;
+		break;
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4fdf30316582..68cd3a0af9bb 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_SECURE_GUEST 181
 #define KVM_CAP_HALT_POLL 182
 #define KVM_CAP_ASYNC_PF_INT 183
+#define KVM_CAP_SMALLER_MAXPHYADDR 184
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.26.2

