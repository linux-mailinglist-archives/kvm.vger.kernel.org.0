Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200183E97F4
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 20:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhHKSxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 14:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhHKSwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 14:52:55 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F28C0613D3
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 11:52:29 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t3so3869642plg.9
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 11:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rB1P7ZMdfDxRhek6bwBIPgVxZ83WIAxliOmpxn+7B9g=;
        b=JFHgGD7tGa+rPoRGbH7JNiNotGXWBhSGvoQu/zOXs27WCSYhyUgt7K2JvF/X+U14uR
         uTDPTak85k0MgmTk5H7mUtMyEcsc9HWoYw9xf50y+FgZEIVBoYIIcVvjFwCbaVUkrHxA
         inXAxM8rF5bJ6oNb9KkPn8boQD8MEltf+VlzhilG/BBISfubj9gDZ0mduCIS/kwXroiD
         GuoU4dW7VGQZj4fCN6x8Fx/QtCxIJqfeRICAgN7hC4z+hLcrsPbnsEeXij8Uhys3jhgM
         a/1ByPszNeQbDJcCGp3ZKdVaCk0kMTJ6vwqmeMmqZHmkTeQ9XaHTeV1lLM8beq35qs5V
         sfbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rB1P7ZMdfDxRhek6bwBIPgVxZ83WIAxliOmpxn+7B9g=;
        b=dhXh8VkDS96ikcM1//G/W4rDr6R6CLnvstAFCso1u+J8jtJFgS7Zsw8ritWhraY7Fp
         Wa5jhIxMncYQK9T4qkJggPoWBSuE27KwzuXAT7dUpdYL3Z7eCOl0cuCPSe4Oi8Sy1Lnz
         BJSufcNrroGC30CU3KLIwpH0iwznp02cQpG62b+eiSJtlqS8r64BRk6nbcRJiS5f/nVt
         9seNdFmogUiT5pCThzUBkm1Ai+ccZG8yYZLf2D1Jj77GxNFqjzipUGzaB5/K/Vn/yza5
         V5a9u8a8cud9SsAqX2Fxy76meycyFJEN8j1v6qa35xwLKWBMbZI6qtMx6DBTxdl4gDhq
         9JIQ==
X-Gm-Message-State: AOAM532gFZDnM37tW4IQzjlLuu+wv/Z6rcsN6Ss+1jY/x4RRoih7jRab
        tfCCOMToEqI8RtKldPjbDhZRiw==
X-Google-Smtp-Source: ABdhPJwdIy0lhyJ/W9MNpayK1e0rYCuqijogj4ocOOPLRQvLxZdg6TSakb/OPTASJHDU1fMa1FYvEQ==
X-Received: by 2002:aa7:8014:0:b029:3cd:b6f3:5dd6 with SMTP id j20-20020aa780140000b02903cdb6f35dd6mr200018pfi.39.1628707948973;
        Wed, 11 Aug 2021 11:52:28 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 19sm238682pfw.203.2021.08.11.11.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 11:52:28 -0700 (PDT)
Date:   Wed, 11 Aug 2021 18:52:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong93@linux.alibaba.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: x86: move architecture-specific code into
 kvm_arch_vcpu_fault
Message-ID: <YRQcZqCWwVH8bCGc@google.com>
References: <c000d393a832e4cbf586caa364005f13fbddef9e.1628651371.git.houwenlong93@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c000d393a832e4cbf586caa364005f13fbddef9e.1628651371.git.houwenlong93@linux.alibaba.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 11, 2021, Hou Wenlong wrote:
> The function kvm_arch_vcpu_fault can handle architecture-specific
> case, so move pio-data fault case into it for x86.
> 
> Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
> ---
>  arch/x86/kvm/x86.c  | 8 ++++++++
>  virt/kvm/kvm_main.c | 4 ----
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e5d5c5ed7dd4..30b0706eced8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5348,6 +5348,14 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  
>  vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
>  {
> +	if (vmf->pgoff == KVM_PIO_PAGE_OFFSET) {
> +		struct page *page = virt_to_page(vcpu->arch.pio_data);
> +
> +		get_page(page);
> +		vmf->page = page;
> +		return 0;
> +	}
> +
>  	return VM_FAULT_SIGBUS;

What about a prep patch (below) to refactor kvm_arch_vcpu_fault() to return
a struct page pointer instead of vm_fault_t?  That would simplify this patch to:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8c1871f0211c..1c5d68ced3be 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5348,6 +5348,8 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 {
+       if (vmf->pgoff == KVM_PIO_PAGE_OFFSET)
+               virt_to_page(vcpu->arch.pio_data);
        return NULL;
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a75848799712..c3b1e8f55251 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3486,10 +3486,6 @@ static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
 
        if (vmf->pgoff == 0)
                page = virt_to_page(vcpu->run);
-#ifdef CONFIG_X86
-       else if (vmf->pgoff == KVM_PIO_PAGE_OFFSET)
-               page = virt_to_page(vcpu->arch.pio_data);
-#endif
 #ifdef CONFIG_KVM_MMIO
        else if (vmf->pgoff == KVM_COALESCED_MMIO_PAGE_OFFSET)
                page = virt_to_page(vcpu->kvm->coalesced_mmio_ring);


From 94ce06a001af4bd79635f1c8d681f560bca13cba Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Aug 2021 11:28:03 -0700
Subject: [PATCH] KVM: Refactor kvm_arch_vcpu_fault() to return a struct page
 pointer

Refactor kvm_arch_vcpu_fault() to return 'struct page *' instead of
'vm_fault_t' to simplify architecture specific implementations that do
more than return SIGBUS.  Currently this only applies to s390, but a
future patch will move x86's pio_data handling into x86 where it belongs.

No functional changed intended.

Cc: Hou Wenlong <houwenlong93@linux.alibaba.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
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
index 75c6f264c626..ecfbcfe00b78 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1049,9 +1049,9 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
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
index 4dc7e966a720..eab9c4820185 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4975,17 +4975,13 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
index fdc0c18339fb..8c1871f0211c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5346,9 +5346,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
index 03f37e4def6f..7df730cdc935 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1000,7 +1000,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg);
-vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf);
+struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf);

 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext);

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3e67c93ca403..a75848799712 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3499,7 +3499,10 @@ static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
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
2.33.0.rc1.237.g0d66db33f3-goog


