Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A583E9D1E
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 06:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbhHLECu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 00:02:50 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:34600 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229460AbhHLECt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 00:02:49 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=houwenlong93@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0UikIOfv_1628740942;
Received: from localhost(mailfrom:houwenlong93@linux.alibaba.com fp:SMTPD_---0UikIOfv_1628740942)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 12 Aug 2021 12:02:22 +0800
From:   Hou Wenlong <houwenlong93@linux.alibaba.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] kvm: x86: move architecture specific code into kvm_arch_vcpu_fault
Date:   Thu, 12 Aug 2021 12:02:20 +0800
Message-Id: <146fab9b48eb8554202f91785d0e009757439baf.1628739116.git.houwenlong93@linux.alibaba.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1c510b24fc1d7cbae8aa4b69c0799ebd32e65b82.1628739116.git.houwenlong93@linux.alibaba.com>
References: <1c510b24fc1d7cbae8aa4b69c0799ebd32e65b82.1628739116.git.houwenlong93@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The function kvm_arch_vcpu_fault can handle architecture specific
case, so move x86's pio_data hanlding into it.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
---
 arch/x86/kvm/x86.c  | 2 ++
 virt/kvm/kvm_main.c | 4 ----
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1e3bbe5cd33a..25c0752d6cd9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5349,6 +5349,8 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 {
+	if (vmf->pgoff == KVM_PIO_PAGE_OFFSET)
+		return virt_to_page(vcpu->arch.pio_data);
 	return NULL;
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f7d21418971b..43064df5ad87 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3435,10 +3435,6 @@ static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
 
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

