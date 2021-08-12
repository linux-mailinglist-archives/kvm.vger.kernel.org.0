Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2138E3EA180
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 11:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235575AbhHLJFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 05:05:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52701 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235580AbhHLJF3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 05:05:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628759103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JgMWN7/eNl2nw6MdbRkVkIrc4drjFaFJaW8jw61Jzlk=;
        b=L9IhEPWzugPGj5W+AveFkpeQh/XKcDSx8l3CgP0m2uJgNBOYN6xuzuQOXdEdhlntdZOey5
        TAQlVEiAWZC8w00tGyhatKej+Bxh2VEfSfRVZBeh4w0r8AVinvWgWRVuB9FsN1GyQJ7k/7
        Y1owOm45Z7m3ZT43QChjKZ/RtOaqbhk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-mMPTQngMP5uJ-g4XMyf8dQ-1; Thu, 12 Aug 2021 05:05:02 -0400
X-MC-Unique: mMPTQngMP5uJ-g4XMyf8dQ-1
Received: by mail-wr1-f71.google.com with SMTP id q11-20020a5d61cb0000b02901550c3fccb5so1598823wrv.14
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 02:05:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=JgMWN7/eNl2nw6MdbRkVkIrc4drjFaFJaW8jw61Jzlk=;
        b=amW+9ezg3rdVHjYxXGMYZEx1IdRoDA7xKd++LcpPKY7PIQO2kK5Vfxi4DmeSfqyPaX
         l4LW2Xt1/kGwUjrvriGtEensCU4Q+aiy/1wrB8NdEfGIOzbbjz09nx6//iK0Jb8ktuwT
         KgeGeaV+J1whvMZuUS/lYPLPWib1vulxfaBCVJ5Mnpzi7uqF31BdMab4qGtu08XFPA+4
         r2+1bH8VEDt/TEr65gD92Dk1wUC5d4PQ5SYbXbzwgkgUVehfrDU20kiV2J6sLxN+aUl4
         XgeRX0TwSoTZ5yZzNDEo6x7xPDVZy9r4cdU3ctkY1LUhz6TLHfCmMRzb3LyXNvZS/Sj+
         1P2w==
X-Gm-Message-State: AOAM530N7G30//74P/Y/kkG7ErwIxeywHafy/esUMFkz9lmyNrDlxtfj
        KzbhunYraoLzwR092xwJE7inL1GiTHmGu2pm4ujhgxywOcwN/Hydf0Ag0yVfuvOXlR8qFoVITZt
        joHVwN2RMqk0L
X-Received: by 2002:a5d:6d03:: with SMTP id e3mr2798718wrq.153.1628759100835;
        Thu, 12 Aug 2021 02:05:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw14l6W1wkrgjVxsT5cj4nrtOlS6mn0en/HDpnzJRRlmx+RwnP3XwnlZp0HL14993xrDLfaIA==
X-Received: by 2002:a5d:6d03:: with SMTP id e3mr2798682wrq.153.1628759100598;
        Thu, 12 Aug 2021 02:05:00 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23d8b.dip0.t-ipconnect.de. [79.242.61.139])
        by smtp.gmail.com with ESMTPSA id i21sm2300276wrb.62.2021.08.12.02.04.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 02:05:00 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] KVM: Refactor kvm_arch_vcpu_fault() to return a
 struct page pointer
To:     Hou Wenlong <houwenlong93@linux.alibaba.com>, kvm@vger.kernel.org
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
References: <YRQcZqCWwVH8bCGc@google.com>
 <1c510b24fc1d7cbae8aa4b69c0799ebd32e65b82.1628739116.git.houwenlong93@linux.alibaba.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <98adbd3c-ec6f-5689-1686-2a8a7909951a@redhat.com>
Date:   Thu, 12 Aug 2021 11:04:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1c510b24fc1d7cbae8aa4b69c0799ebd32e65b82.1628739116.git.houwenlong93@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12.08.21 06:02, Hou Wenlong wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Refactor kvm_arch_vcpu_fault() to return 'struct page *' instead of
> 'vm_fault_t' to simplify architecture specific implementations that do
> more than return SIGBUS.  Currently this only applies to s390, but a
> future patch will move x86's pio_data handling into x86 where it belongs.
> 
> No functional changed intended.
> 
> Cc: Hou Wenlong <houwenlong93@linux.alibaba.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
> ---
>   arch/arm64/kvm/arm.c       |  4 ++--
>   arch/mips/kvm/mips.c       |  4 ++--
>   arch/powerpc/kvm/powerpc.c |  4 ++--
>   arch/s390/kvm/kvm-s390.c   | 12 ++++--------
>   arch/x86/kvm/x86.c         |  4 ++--
>   include/linux/kvm_host.h   |  2 +-
>   virt/kvm/kvm_main.c        |  5 ++++-
>   7 files changed, 17 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e9a2b8f27792..83f4ffe3e4f2 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -161,9 +161,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	return ret;
>   }
>   
> -vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
> +struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
>   {
> -	return VM_FAULT_SIGBUS;
> +	return NULL;
>   }
>   
>   
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index af9dd029a4e1..ae79874e6fd2 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -1053,9 +1053,9 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
>   	return -ENOIOCTLCMD;
>   }
>   
> -vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
> +struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
>   {
> -	return VM_FAULT_SIGBUS;
> +	return NULL;
>   }
>   
>   int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index be33b5321a76..b9c21f9ab784 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -2090,9 +2090,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   	return r;
>   }
>   
> -vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
> +struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
>   {
> -	return VM_FAULT_SIGBUS;
> +	return NULL;
>   }
>   
>   static int kvm_vm_ioctl_get_pvinfo(struct kvm_ppc_pvinfo *pvinfo)
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 02574d7b3612..e1b69833e228 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4979,17 +4979,13 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   	return r;
>   }
>   
> -vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
> +struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
>   {
>   #ifdef CONFIG_KVM_S390_UCONTROL
> -	if ((vmf->pgoff == KVM_S390_SIE_PAGE_OFFSET)
> -		 && (kvm_is_ucontrol(vcpu->kvm))) {
> -		vmf->page = virt_to_page(vcpu->arch.sie_block);
> -		get_page(vmf->page);
> -		return 0;
> -	}
> +	if (vmf->pgoff == KVM_S390_SIE_PAGE_OFFSET && kvm_is_ucontrol(vcpu->kvm))
> +		return virt_to_page(vcpu->arch.sie_block);
>   #endif
> -	return VM_FAULT_SIGBUS;
> +	return NULL;
>   }
>   
>   /* Section: memory related */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3cedc7cc132a..1e3bbe5cd33a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5347,9 +5347,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   	return r;
>   }
>   
> -vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
> +struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
>   {
> -	return VM_FAULT_SIGBUS;
> +	return NULL;
>   }
>   
>   static int kvm_vm_ioctl_set_tss_addr(struct kvm *kvm, unsigned long addr)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 492d183dd7d0..a949de534722 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -995,7 +995,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
>   			unsigned int ioctl, unsigned long arg);
>   long kvm_arch_vcpu_ioctl(struct file *filp,
>   			 unsigned int ioctl, unsigned long arg);
> -vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf);
> +struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf);
>   
>   int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext);
>   
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 30d322519253..f7d21418971b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3448,7 +3448,10 @@ static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
>   		    &vcpu->dirty_ring,
>   		    vmf->pgoff - KVM_DIRTY_LOG_PAGE_OFFSET);
>   	else
> -		return kvm_arch_vcpu_fault(vcpu, vmf);
> +		page = kvm_arch_vcpu_fault(vcpu, vmf);
> +	if (!page)
> +		return VM_FAULT_SIGBUS;
> +
>   	get_page(page);
>   	vmf->page = page;
>   	return 0;
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

But at the same time I wonder if we should just get rid of 
CONFIG_KVM_S390_UCONTROL and consequently kvm_arch_vcpu_fault().


In practice CONFIG_KVM_S390_UCONTROL, is never enabled in any reasonable 
kernel build and consequently it's never tested; further, exposing the 
sie_block to user space allows user space to generate random SIE 
validity intercepts.

CONFIG_KVM_S390_UCONTROL feels like something that should just be 
maintained out of tree by someone who really needs to hack deep into hw 
virtualization for testing purposes etc.

-- 
Thanks,

David / dhildenb

