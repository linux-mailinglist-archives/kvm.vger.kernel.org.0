Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CF7201157
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 17:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405007AbgFSPkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 11:40:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46032 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404605AbgFSPkY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 11:40:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592581222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bODDM+3AVzKI37y3j1eonT1rRnDcORAjQarN8GKg2oQ=;
        b=IzNVJbpoH687zs3rbvjDGjIifnum6B/f+eTRdhesA4tYF1IySqhW8m4DsdQlDS+4nNtUZ0
        998yLNavmGARKm4VRZbeFWEW0QNdLPggiyKm0dvSvGiaBBIzYGZM52n/cV7IAmgRX6JjkF
        NXcLFpn4OXid1MRcqVE0bgfHCvV9wXs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-7EEgdOwJPbSOnRM3PhWo8g-1; Fri, 19 Jun 2020 11:40:18 -0400
X-MC-Unique: 7EEgdOwJPbSOnRM3PhWo8g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2B8218A8220;
        Fri, 19 Jun 2020 15:40:16 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A043460BF4;
        Fri, 19 Jun 2020 15:40:14 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, thomas.lendacky@amd.com,
        babu.moger@amd.com, Mohammed Gamal <mgamal@redhat.com>
Subject: [PATCH v2 11/11] KVM: x86: SVM: VMX: Make GUEST_MAXPHYADDR < HOST_MAXPHYADDR support configurable
Date:   Fri, 19 Jun 2020 17:39:25 +0200
Message-Id: <20200619153925.79106-12-mgamal@redhat.com>
In-Reply-To: <20200619153925.79106-1-mgamal@redhat.com>
References: <20200619153925.79106-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
index 7ebdb43632e0..b25f7497307d 100644
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
index ec3224a2e7c2..1b8880b89e9f 100644
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
index 8daf78b2d4cb..fe0ca39c0887 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8316,6 +8316,13 @@ static int __init vmx_init(void)
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
index 84f1f0084d2e..5bca6d6d24e9 100644
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
@@ -3533,6 +3536,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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

