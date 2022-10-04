Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 206445F4313
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 14:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiJDMkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 08:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiJDMk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 08:40:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4384A205CB
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 05:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664887216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tR9EOQR5mBco0nwuRIp5QkJMbwlO8uBuVCmldGlKwK0=;
        b=fZBotuH3phLCGi4If59FI/HZqw80a2a1R2zFl/iZEqaPKhPGplAqkJ5TTfnwiPHnmrzjPh
        hHTFqBJcU3Yi7Weq4ddLgJNgUdzXOyHbRqTKl9jpoahiRfVAxnh9QBTMZAPwSOW4PYkvVf
        sEmPj1zxdE5xUZRqa0PKuA/f5QKjx5E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-CNoQdL3LO16PIpUrY8lXlg-1; Tue, 04 Oct 2022 08:40:13 -0400
X-MC-Unique: CNoQdL3LO16PIpUrY8lXlg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D830805B98;
        Tue,  4 Oct 2022 12:40:13 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DA6F7AE5;
        Tue,  4 Oct 2022 12:40:11 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v11 05/46] KVM: x86: Rename 'enable_direct_tlbflush' to 'enable_l2_tlb_flush'
Date:   Tue,  4 Oct 2022 14:39:15 +0200
Message-Id: <20221004123956.188909-6-vkuznets@redhat.com>
In-Reply-To: <20221004123956.188909-1-vkuznets@redhat.com>
References: <20221004123956.188909-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To make terminology between Hyper-V-on-KVM and KVM-on-Hyper-V consistent,
rename 'enable_direct_tlbflush' to 'enable_l2_tlb_flush'. The change
eliminates the use of confusing 'direct' and adds the missing underscore.

No functional change.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 2 +-
 arch/x86/include/asm/kvm_host.h    | 2 +-
 arch/x86/kvm/svm/svm_onhyperv.c    | 2 +-
 arch/x86/kvm/svm/svm_onhyperv.h    | 6 +++---
 arch/x86/kvm/vmx/vmx.c             | 6 +++---
 arch/x86/kvm/x86.c                 | 6 +++---
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 82ba4a564e58..6033b54963a4 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -123,7 +123,7 @@ KVM_X86_OP_OPTIONAL(guest_memory_reclaimed)
 KVM_X86_OP(get_msr_feature)
 KVM_X86_OP(can_emulate_instruction)
 KVM_X86_OP(apic_init_signal_blocked)
-KVM_X86_OP_OPTIONAL(enable_direct_tlbflush)
+KVM_X86_OP_OPTIONAL(enable_l2_tlb_flush)
 KVM_X86_OP_OPTIONAL(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b3ce723efb43..504daf473092 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1624,7 +1624,7 @@ struct kvm_x86_ops {
 					void *insn, int insn_len);
 
 	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
-	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
+	int (*enable_l2_tlb_flush)(struct kvm_vcpu *vcpu);
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
 	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
index 52c73a8be72b..26a89d0da93e 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.c
+++ b/arch/x86/kvm/svm/svm_onhyperv.c
@@ -14,7 +14,7 @@
 #include "kvm_onhyperv.h"
 #include "svm_onhyperv.h"
 
-int svm_hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
+int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
 {
 	struct hv_vmcb_enlightenments *hve;
 	struct hv_partition_assist_pg **p_hv_pa_pg =
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index d5cb2c62e355..45faf84476ce 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -13,7 +13,7 @@
 
 static struct kvm_x86_ops svm_x86_ops;
 
-int svm_hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu);
+int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu);
 
 static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
 {
@@ -53,8 +53,8 @@ static inline void svm_hv_hardware_setup(void)
 
 			vp_ap->nested_control.features.directhypercall = 1;
 		}
-		svm_x86_ops.enable_direct_tlbflush =
-				svm_hv_enable_direct_tlbflush;
+		svm_x86_ops.enable_l2_tlb_flush =
+				svm_hv_enable_l2_tlb_flush;
 	}
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 94c314dc2393..87ef9aefc4ac 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -526,7 +526,7 @@ static unsigned long host_idt_base;
 static bool __read_mostly enlightened_vmcs = true;
 module_param(enlightened_vmcs, bool, 0444);
 
-static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
+static int hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
 {
 	struct hv_enlightened_vmcs *evmcs;
 	struct hv_partition_assist_pg **p_hv_pa_pg =
@@ -8479,8 +8479,8 @@ static int __init vmx_init(void)
 		}
 
 		if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH)
-			vmx_x86_ops.enable_direct_tlbflush
-				= hv_enable_direct_tlbflush;
+			vmx_x86_ops.enable_l2_tlb_flush
+				= hv_enable_l2_tlb_flush;
 
 	} else {
 		enlightened_vmcs = false;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a532b9dea57b..ee9d88f0e84c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4467,7 +4467,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 			kvm_x86_ops.nested_ops->get_state(NULL, NULL, 0) : 0;
 		break;
 	case KVM_CAP_HYPERV_DIRECT_TLBFLUSH:
-		r = kvm_x86_ops.enable_direct_tlbflush != NULL;
+		r = kvm_x86_ops.enable_l2_tlb_flush != NULL;
 		break;
 	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
 		r = kvm_x86_ops.nested_ops->enable_evmcs != NULL;
@@ -5483,10 +5483,10 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 		}
 		return r;
 	case KVM_CAP_HYPERV_DIRECT_TLBFLUSH:
-		if (!kvm_x86_ops.enable_direct_tlbflush)
+		if (!kvm_x86_ops.enable_l2_tlb_flush)
 			return -ENOTTY;
 
-		return static_call(kvm_x86_enable_direct_tlbflush)(vcpu);
+		return static_call(kvm_x86_enable_l2_tlb_flush)(vcpu);
 
 	case KVM_CAP_HYPERV_ENFORCE_CPUID:
 		return kvm_hv_set_enforce_cpuid(vcpu, cap->args[0]);
-- 
2.37.3

