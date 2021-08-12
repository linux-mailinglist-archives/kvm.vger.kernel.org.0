Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE673E9D22
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 06:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhHLECv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 00:02:51 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:39336 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229518AbhHLECu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 00:02:50 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=houwenlong93@linux.alibaba.com;NM=1;PH=DS;RN=38;SR=0;TI=SMTPD_---0UikIOfn_1628740941;
Received: from localhost(mailfrom:houwenlong93@linux.alibaba.com fp:SMTPD_---0UikIOfn_1628740941)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 12 Aug 2021 12:02:21 +0800
From:   Hou Wenlong <houwenlong93@linux.alibaba.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: Refactor kvm_arch_vcpu_fault() to return a struct page pointer
Date:   Thu, 12 Aug 2021 12:02:19 +0800
Message-Id: <1c510b24fc1d7cbae8aa4b69c0799ebd32e65b82.1628739116.git.houwenlong93@linux.alibaba.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <YRQcZqCWwVH8bCGc@google.com>
References: <YRQcZqCWwVH8bCGc@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Refactor kvm_arch_vcpu_fault() to return 'struct page *' instead of
'vm_fault_t' to simplify architecture specific implementations that do
more than return SIGBUS.  Currently this only applies to s390, but a
future patch will move x86's pio_data handling into x86 where it belongs.

No functional changed intended.

Cc: Hou Wenlong <houwenlong93@linux.alibaba.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
---
 arch/arm64/kvm/arm.c       |  4 ++--
 arch/mips/kvm/mips.c       |  4 ++--
 arch/powerpc/kvm/powerpc.c |  4 ++--
 arch/s390/kvm/kvm-s390.c   | 12 ++++--------
 arch/x86/kvm/x86.c         |  4 ++--
 include/linux/kvm_host.h   |  2 +-
 virt/kvm/kvm_main.c        |  5 ++++-
 7 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e9a2b8f27792..83f4ffe3e4f2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -161,9 +161,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return ret;
 }
 
-vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
+struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 {
-	return VM_FAULT_SIGBUS;
+	return NULL;
 }
 
 
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index af9dd029a4e1..ae79874e6fd2 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1053,9 +1053,9 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 	return -ENOIOCTLCMD;
 }
 
-vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
+struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 {
-	return VM_FAULT_SIGBUS;
+	return NULL;
 }
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index be33b5321a76..b9c21f9ab784 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -2090,9 +2090,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	return r;
 }
 
-vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
+struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 {
-	return VM_FAULT_SIGBUS;
+	return NULL;
 }
 
 static int kvm_vm_ioctl_get_pvinfo(struct kvm_ppc_pvinfo *pvinfo)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 02574d7b3612..e1b69833e228 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4979,17 +4979,13 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	return r;
 }
 
-vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
+struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 {
 #ifdef CONFIG_KVM_S390_UCONTROL
-	if ((vmf->pgoff == KVM_S390_SIE_PAGE_OFFSET)
-		 && (kvm_is_ucontrol(vcpu->kvm))) {
-		vmf->page = virt_to_page(vcpu->arch.sie_block);
-		get_page(vmf->page);
-		return 0;
-	}
+	if (vmf->pgoff == KVM_S390_SIE_PAGE_OFFSET && kvm_is_ucontrol(vcpu->kvm))
+		return virt_to_page(vcpu->arch.sie_block);
 #endif
-	return VM_FAULT_SIGBUS;
+	return NULL;
 }
 
 /* Section: memory related */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3cedc7cc132a..1e3bbe5cd33a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5347,9 +5347,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	return r;
 }
 
-vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
+struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 {
-	return VM_FAULT_SIGBUS;
+	return NULL;
 }
 
 static int kvm_vm_ioctl_set_tss_addr(struct kvm *kvm, unsigned long addr)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 492d183dd7d0..a949de534722 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -995,7 +995,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg);
-vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf);
+struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf);
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 30d322519253..f7d21418971b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3448,7 +3448,10 @@ static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
 		    &vcpu->dirty_ring,
 		    vmf->pgoff - KVM_DIRTY_LOG_PAGE_OFFSET);
 	else
-		return kvm_arch_vcpu_fault(vcpu, vmf);
+		page = kvm_arch_vcpu_fault(vcpu, vmf);
+	if (!page)
+		return VM_FAULT_SIGBUS;
+
 	get_page(page);
 	vmf->page = page;
 	return 0;
-- 
2.31.1

