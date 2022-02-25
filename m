Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FECF4C47F0
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 15:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241895AbiBYOxz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 09:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241877AbiBYOxw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 09:53:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0812316AA49;
        Fri, 25 Feb 2022 06:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=6tmTHm4xCK6AijCeVLDYpyN2UleQWbr9fKTKM3nM+jA=; b=ehdcjjUjkpckHjdB0h4HhXNlKW
        Fyw5R4++BODwixFeNyL0GwwpJCXYcDC1lAkMbda93snb7S0M5MennnYWJkBflPJ8PFcVeNZI3e+ad
        yvqrCUuMEgOtPmiKoyJKgKFsxbcjcF9LYGte7f7WZ04BX4UhWqrNMZbmnWtg7RXaQiuTo3vyXI9cK
        /mp4DRG0e0T1TSxsHGoJIBls8okJobNSMuK+Ebgk+HUe8eUtyevLbFmeY7f08AuBpcW+V88IjwPsS
        0UZl6VfiEFKKMQGrHDkh3SiZi3Szzp2SoKWUhUVXq9zG2p2DpSCe0mjH2mD31A9yqgaz+PXwjsUde
        NU+jUHpA==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNbxy-005rry-Ie; Fri, 25 Feb 2022 14:53:06 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNbxx-0009Pe-R4; Fri, 25 Feb 2022 14:53:05 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Suleiman Souhlal <suleiman@google.com>,
        Anton Romanov <romanton@google.com>
Subject: [PATCH 1/3] KVM: x86: Accept KVM_[GS]ET_TSC_KHZ as a VM ioctl.
Date:   Fri, 25 Feb 2022 14:53:02 +0000
Message-Id: <20220225145304.36166-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220225145304.36166-1-dwmw2@infradead.org>
References: <20220225145304.36166-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

This sets the default TSC frequency for subsequently created vCPUs.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst  | 11 +++++++----
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/x86.c              | 26 +++++++++++++++++++++++++-
 include/uapi/linux/kvm.h        |  4 +++-
 4 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 046b386f6ce3..982fcdf8cfa8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1903,22 +1903,25 @@ the future.
 4.55 KVM_SET_TSC_KHZ
 --------------------
 
-:Capability: KVM_CAP_TSC_CONTROL
+:Capability: KVM_CAP_TSC_CONTROL / KVM_CAP_VM_TSC_CONTROL
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl / vm ioctl
 :Parameters: virtual tsc_khz
 :Returns: 0 on success, -1 on error
 
 Specifies the tsc frequency for the virtual machine. The unit of the
 frequency is KHz.
 
+If the KVM_CAP_VM_TSC_CONTROL capability is advertised, this can also
+be used as a vm ioctl to set the initial tsc frequency of subsequently
+created vCPUs.
 
 4.56 KVM_GET_TSC_KHZ
 --------------------
 
-:Capability: KVM_CAP_GET_TSC_KHZ
+:Capability: KVM_CAP_GET_TSC_KHZ / KVM_CAP_VM_TSC_CONTROL
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl / vm ioctl
 :Parameters: none
 :Returns: virtual tsc-khz on success, negative value on error
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a3385db39d3e..e4696a578f41 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1119,6 +1119,8 @@ struct kvm_arch {
 	u64 cur_tsc_generation;
 	int nr_vcpus_matched_tsc;
 
+	u32 default_tsc_khz;
+
 	seqcount_raw_spinlock_t pvclock_sc;
 	bool use_master_clock;
 	u64 master_kernel_ns;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83accd3e7502..bb3e9916229a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4308,6 +4308,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = boot_cpu_has(X86_FEATURE_XSAVE);
 		break;
 	case KVM_CAP_TSC_CONTROL:
+	case KVM_CAP_VM_TSC_CONTROL:
 		r = kvm_has_tsc_control;
 		break;
 	case KVM_CAP_X2APIC_API:
@@ -6483,6 +6484,28 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_GET_CLOCK:
 		r = kvm_vm_ioctl_get_clock(kvm, argp);
 		break;
+	case KVM_SET_TSC_KHZ: {
+		u32 user_tsc_khz;
+
+		r = -EINVAL;
+		user_tsc_khz = (u32)arg;
+
+		if (kvm_has_tsc_control &&
+		    user_tsc_khz >= kvm_max_guest_tsc_khz)
+			goto out;
+
+		if (user_tsc_khz == 0)
+			user_tsc_khz = tsc_khz;
+
+		WRITE_ONCE(kvm->arch.default_tsc_khz, user_tsc_khz);
+		r = 0;
+
+		goto out;
+	}
+	case KVM_GET_TSC_KHZ: {
+		r = READ_ONCE(kvm->arch.default_tsc_khz);
+		goto out;
+	}
 	case KVM_MEMORY_ENCRYPT_OP: {
 		r = -ENOTTY;
 		if (!kvm_x86_ops.mem_enc_ioctl)
@@ -11165,7 +11188,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kvm_xen_init_vcpu(vcpu);
 	kvm_vcpu_mtrr_init(vcpu);
 	vcpu_load(vcpu);
-	kvm_set_tsc_khz(vcpu, max_tsc_khz);
+	kvm_set_tsc_khz(vcpu, vcpu->kvm->arch.default_tsc_khz);
 	kvm_vcpu_reset(vcpu, false);
 	kvm_init_mmu(vcpu);
 	vcpu_put(vcpu);
@@ -11614,6 +11637,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	pvclock_update_vm_gtod_copy(kvm);
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
+	kvm->arch.default_tsc_khz = max_tsc_khz;
 	kvm->arch.guest_can_read_msr_platform_info = true;
 
 #if IS_ENABLED(CONFIG_HYPERV)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 22a1aa98fa9e..01ae8b0e90f8 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1134,6 +1134,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
+#define KVM_CAP_VM_TSC_CONTROL 210
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1461,7 +1462,8 @@ struct kvm_s390_ucas_mapping {
 #define KVM_SET_PIT2              _IOW(KVMIO,  0xa0, struct kvm_pit_state2)
 /* Available with KVM_CAP_PPC_GET_PVINFO */
 #define KVM_PPC_GET_PVINFO	  _IOW(KVMIO,  0xa1, struct kvm_ppc_pvinfo)
-/* Available with KVM_CAP_TSC_CONTROL */
+/* Available with KVM_CAP_TSC_CONTROL for a vCPU, or with
+*  KVM_CAP_VM_TSC_CONTROL to set defaults for a VM */
 #define KVM_SET_TSC_KHZ           _IO(KVMIO,  0xa2)
 #define KVM_GET_TSC_KHZ           _IO(KVMIO,  0xa3)
 /* Available with KVM_CAP_PCI_2_3 */
-- 
2.33.1

