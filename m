Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 443741467B6
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 13:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgAWMPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 07:15:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46531 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728139AbgAWMPj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 07:15:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579781739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3uxZUkgrNTOroZtqnJ9cYlspecUEZ/taij7sWcFNnzk=;
        b=Fo+FPiWakfkBZumwsZNfpRwCVtCGxHqRk/xT78LwoBVTeam0cf3jkTG+RJYpbQlU09jmqm
        q7N7ymPMeYQxkNEWIi14nU8Dx3GIQ425ECLhF6BmoS6Pvb/H3POig0217On1Uz4tIzn9N9
        C+Lz7brY1BlZmpzXU0Q7Bvnkv9iTKtQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-fy_GZ7CaPYiB0vVI-AgngA-1; Thu, 23 Jan 2020 07:15:37 -0500
X-MC-Unique: fy_GZ7CaPYiB0vVI-AgngA-1
Received: by mail-wm1-f72.google.com with SMTP id z2so494587wmf.5
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 04:15:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3uxZUkgrNTOroZtqnJ9cYlspecUEZ/taij7sWcFNnzk=;
        b=rCOEwuoGl/sMXXMSMel8Tk0ioQE7APS3M0mT/2mm/dSGwmx8XgMoSklH3AQ9rxwpTB
         9aePAy5cUx3YNUOffzUVBm8vQM6e0jOzo8hjqg8BvzqhfBOaxhu6Owp8QYHD0Dgckxuj
         WleXDIEUiTe482ZnLFiFdH100pjz/7WnYhE7EjuGKRcBmiR2gTRx4GUvdZdyhQEPV8vq
         589xkMeuY0dZ1xYaTtsp4cH8qlPaRiqE0g4LZauNMVUjrIVuGSLP7dTWdLnIFUlZtpmg
         uSOj5PFIaLATOARc1Q1Oc3YLZZ7ZcsK1L2BCDAV8CV8IVhSskLmdW72/t9c6woRAArWz
         kD/Q==
X-Gm-Message-State: APjAAAUKjQjhM2ECDYhvvtnRJrbSiGbeP1tWKWpjJfXew/0GozLWKdvf
        rz0OEMiMb9Zsq53ziz8chIgr3mKm3sFGPFepVoetnq7+JCnh/sbHuGeM5EfO4487ZP9/1yfNVCl
        S3w0qCv++lPRE
X-Received: by 2002:a05:600c:507:: with SMTP id i7mr4035592wmc.135.1579781736163;
        Thu, 23 Jan 2020 04:15:36 -0800 (PST)
X-Google-Smtp-Source: APXvYqyLchET5m6nxiyyIfett/X6yiyHn4kRf+kYA+WL90j1+aDsgYfZz8k+HM7m7PIs/HImA0dVuA==
X-Received: by 2002:a05:600c:507:: with SMTP id i7mr4035565wmc.135.1579781735923;
        Thu, 23 Jan 2020 04:15:35 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id n16sm2747662wro.88.2020.01.23.04.15.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 04:15:35 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: avoid some unnecessary copy in
 __x86_set_memory_region()
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1579748413-432-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2cb1c43c-932e-d587-bc0d-5d433649abb1@redhat.com>
Date:   Thu, 23 Jan 2020 13:15:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1579748413-432-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/01/20 04:00, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> Only userspace_addr and npages are passed to vm_munmap() when remove a
> memory region. So we shouldn't copy the integral kvm_memory_slot struct.

The compiler should be able to do this change, so I prefer to keep the
old code.  Also, moving the assignments inside the "if" risks causing
uninitialized variable warnings, even though indeed they are only used
if size == 0.

Thanks,

Paolo

> No functional change intended.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/x86.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d1faa74981d9..767f29877938 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9735,9 +9735,9 @@ void kvm_arch_sync_events(struct kvm *kvm)
>  int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
>  {
>  	int i, r;
> -	unsigned long hva;
> +	unsigned long hva, uaddr, npages;
>  	struct kvm_memslots *slots = kvm_memslots(kvm);
> -	struct kvm_memory_slot *slot, old;
> +	struct kvm_memory_slot *slot;
>  
>  	/* Called with kvm->slots_lock held.  */
>  	if (WARN_ON(id >= KVM_MEM_SLOTS_NUM))
> @@ -9761,9 +9761,10 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
>  			return 0;
>  
>  		hva = 0;
> +		uaddr = slot->userspace_addr;
> +		npages = slot->npages;
>  	}
>  
> -	old = *slot;
>  	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
>  		struct kvm_userspace_memory_region m;
>  
> @@ -9778,7 +9779,7 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
>  	}
>  
>  	if (!size)
> -		vm_munmap(old.userspace_addr, old.npages * PAGE_SIZE);
> +		vm_munmap(uaddr, npages * PAGE_SIZE);
>  
>  	return 0;
>  }
> 

