Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FBA4BA7B8
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 19:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243999AbiBQSIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 13:08:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239522AbiBQSIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 13:08:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E51C515DB3D
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 10:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645121315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NddvV5YdcdOzeYriNQptNRl/fzAcSqQNp8LjUvptsnA=;
        b=Xakcx2dA/cEdqqWJdwxssNswH73D+laM5Wt3jpQeRULEVM/NREOCmn2VzttpvAn2FrdX7X
        QvPdAOGo+CK6NuReIJS/ee5Ti61vRXw+x2oVH92+ieATRqFfkv4b9QisG6Zd7t97pp6fos
        1es6o61jMGcqy9riRzYz2raAL9xFq/s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-xPaeMU26MY-7O86hV9xyYQ-1; Thu, 17 Feb 2022 13:08:34 -0500
X-MC-Unique: xPaeMU26MY-7O86hV9xyYQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD6E0814249;
        Thu, 17 Feb 2022 18:08:32 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DF7B8276C;
        Thu, 17 Feb 2022 18:08:32 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v3 1/6] KVM: x86: return 1 unconditionally for availability of KVM_CAP_VAPIC
Date:   Thu, 17 Feb 2022 13:08:26 -0500
Message-Id: <20220217180831.288210-2-pbonzini@redhat.com>
In-Reply-To: <20220217180831.288210-1-pbonzini@redhat.com>
References: <20220217180831.288210-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The two ioctl used to implement userspace-accelerated TPR,
KVM_TPR_ACCESS_REPORTING and KVM_SET_VAPIC_ADDR, are available
even if hardware-accelerated TPR can be used.  So there is
no reason not to report KVM_CAP_VAPIC.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 1 -
 arch/x86/include/asm/kvm_host.h    | 1 -
 arch/x86/kvm/svm/svm.c             | 6 ------
 arch/x86/kvm/vmx/vmx.c             | 6 ------
 arch/x86/kvm/x86.c                 | 4 +---
 5 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 9e37dc3d8863..695ed7feef7e 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -15,7 +15,6 @@ BUILD_BUG_ON(1)
 KVM_X86_OP_NULL(hardware_enable)
 KVM_X86_OP_NULL(hardware_disable)
 KVM_X86_OP_NULL(hardware_unsetup)
-KVM_X86_OP_NULL(cpu_has_accelerated_tpr)
 KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
 KVM_X86_OP(vm_init)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 10815b672a26..e0d2cdfe54ab 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1318,7 +1318,6 @@ struct kvm_x86_ops {
 	int (*hardware_enable)(void);
 	void (*hardware_disable)(void);
 	void (*hardware_unsetup)(void);
-	bool (*cpu_has_accelerated_tpr)(void);
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4243bb355db0..abced3fe2013 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3912,11 +3912,6 @@ static int __init svm_check_processor_compat(void)
 	return 0;
 }
 
-static bool svm_cpu_has_accelerated_tpr(void)
-{
-	return false;
-}
-
 /*
  * The kvm parameter can be NULL (module initialization, or invocation before
  * VM creation). Be sure to check the kvm parameter before using it.
@@ -4529,7 +4524,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.hardware_unsetup = svm_hardware_unsetup,
 	.hardware_enable = svm_hardware_enable,
 	.hardware_disable = svm_hardware_disable,
-	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
 	.has_emulated_msr = svm_has_emulated_msr,
 
 	.vcpu_create = svm_vcpu_create,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 70e7f00362bc..d8547144d3b7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -541,11 +541,6 @@ static inline bool cpu_need_virtualize_apic_accesses(struct kvm_vcpu *vcpu)
 	return flexpriority_enabled && lapic_in_kernel(vcpu);
 }
 
-static inline bool vmx_cpu_has_accelerated_tpr(void)
-{
-	return flexpriority_enabled;
-}
-
 static int possible_passthrough_msr_slot(u32 msr)
 {
 	u32 i;
@@ -7714,7 +7709,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.hardware_enable = vmx_hardware_enable,
 	.hardware_disable = vmx_hardware_disable,
-	.cpu_has_accelerated_tpr = vmx_cpu_has_accelerated_tpr,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
 	.vm_size = sizeof(struct kvm_vmx),
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eaa3b5b89c5e..746f72ae2c95 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4234,6 +4234,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_EXIT_ON_EMULATION_FAILURE:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_SYS_ATTRIBUTES:
+	case KVM_CAP_VAPIC:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
@@ -4274,9 +4275,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		 */
 		r = static_call(kvm_x86_has_emulated_msr)(kvm, MSR_IA32_SMBASE);
 		break;
-	case KVM_CAP_VAPIC:
-		r = !static_call(kvm_x86_cpu_has_accelerated_tpr)();
-		break;
 	case KVM_CAP_NR_VCPUS:
 		r = min_t(unsigned int, num_online_cpus(), KVM_MAX_VCPUS);
 		break;
-- 
2.31.1


