Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96273E88C0
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 05:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhHKDR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 23:17:56 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:26905 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232102AbhHKDR4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 23:17:56 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=houwenlong93@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0UieccZq_1628651840;
Received: from localhost(mailfrom:houwenlong93@linux.alibaba.com fp:SMTPD_---0UieccZq_1628651840)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 11 Aug 2021 11:17:20 +0800
From:   Hou Wenlong <houwenlong93@linux.alibaba.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kvm: x86: move architecture-specific code into kvm_arch_vcpu_fault
Date:   Wed, 11 Aug 2021 11:17:20 +0800
Message-Id: <c000d393a832e4cbf586caa364005f13fbddef9e.1628651371.git.houwenlong93@linux.alibaba.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The function kvm_arch_vcpu_fault can handle architecture-specific
case, so move pio-data fault case into it for x86.

Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
---
 arch/x86/kvm/x86.c  | 8 ++++++++
 virt/kvm/kvm_main.c | 4 ----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5d5c5ed7dd4..30b0706eced8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5348,6 +5348,14 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 {
+	if (vmf->pgoff == KVM_PIO_PAGE_OFFSET) {
+		struct page *page = virt_to_page(vcpu->arch.pio_data);
+
+		get_page(page);
+		vmf->page = page;
+		return 0;
+	}
+
 	return VM_FAULT_SIGBUS;
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b50dbe269f4b..084fba09eca0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3370,10 +3370,6 @@ static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
 
 	if (vmf->pgoff == 0)
 		page = virt_to_page(vcpu->run);
-#ifdef CONFIG_X86
-	else if (vmf->pgoff == KVM_PIO_PAGE_OFFSET)
-		page = virt_to_page(vcpu->arch.pio_data);
-#endif
 #ifdef CONFIG_KVM_MMIO
 	else if (vmf->pgoff == KVM_COALESCED_MMIO_PAGE_OFFSET)
 		page = virt_to_page(vcpu->kvm->coalesced_mmio_ring);
-- 
2.31.1

