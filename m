Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67C971625A4
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 12:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgBRLjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 06:39:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34807 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726043AbgBRLjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 06:39:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582025992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7APRiDLnFKOl1Hm5YmpZcPSvQLdXeX+PgFbuXcWjjmk=;
        b=NacGTyP7aI4kpe71nb751cvZbBIHDubqntKYppyqjhy30K/VFs9soAlnV798zfSsOIYdZy
        YeK+4bIqS5Ry2KnaUA87bXHs14ss1TycVali4uHOuJA0JKfjJqOsUxXoXquTQSCmjPJx4J
        3iAri94GjSAZtKhWzLV/OzFIxE1jpOI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-TX06FX19Mr6WP1XWfCothw-1; Tue, 18 Feb 2020 06:39:51 -0500
X-MC-Unique: TX06FX19Mr6WP1XWfCothw-1
Received: by mail-wm1-f72.google.com with SMTP id n17so917660wmk.1
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 03:39:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7APRiDLnFKOl1Hm5YmpZcPSvQLdXeX+PgFbuXcWjjmk=;
        b=qGofAIpRyfc3QE6lCQPleO1NCKUzfzdzKVmpOH2sY9sgTLA9wSDx8PY371tGdjI3Kv
         EFGWAZWCqB7fiUBY6iljCfnKNiXDBkVKFl3JFNeUqkZYGEpYE6Djb+MAEb2TNP9xyut+
         K14hCPsarAHe/CmwLhWvRUsKf2HCxgR1q4MKm4+Y47+tEsSHhKFb8HfisA9zXhbHL/ak
         pui7veG93zNYGIJBjxISrZeSPkHxGhn5PbclFpt1+FwNyxgS/tAj0/4AWV47C6zfYtgH
         0GW9QlnC5WPmCBB22gO3+F0cMr7ymI/BcYbptBit/0Je6g/nxMC0jBkeqPHKZekIXyHT
         G/QA==
X-Gm-Message-State: APjAAAX6fBYAWHaBrnoRykWZce8Fnqcm0EOKDsdvkevtDYevoYRUGPhC
        EvuA7fN2mNgo0ZUijVePmcz7s2sb/6yGS9s8SdICI6zu3ZCvffUmySbkfluKfQVS+cPcGMUwQen
        lLyxDcGtK0K5j
X-Received: by 2002:a05:600c:2c50:: with SMTP id r16mr2754432wmg.74.1582025990144;
        Tue, 18 Feb 2020 03:39:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqx7EGWZ8NsandW/4MQndbpJsIk1izr+xEiHcrlLPAuFja1k9oUzKfqZ3ShM8QXngeJVPU6DBA==
X-Received: by 2002:a05:600c:2c50:: with SMTP id r16mr2754399wmg.74.1582025989793;
        Tue, 18 Feb 2020 03:39:49 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id l6sm5528940wrn.26.2020.02.18.03.39.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 03:39:49 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: enable dirty log gradually in small chunks
To:     Jay Zhou <jianjay.zhou@huawei.com>, kvm@vger.kernel.org
Cc:     peterx@redhat.com, wangxinxin.wang@huawei.com,
        linfeng23@huawei.com, weidong.huang@huawei.com
References: <20200218110013.15640-1-jianjay.zhou@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <24b21aee-e038-bc55-a85e-0f64912e7b89@redhat.com>
Date:   Tue, 18 Feb 2020 12:39:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200218110013.15640-1-jianjay.zhou@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/02/20 12:00, Jay Zhou wrote:
> It could take kvm->mmu_lock for an extended period of time when
> enabling dirty log for the first time. The main cost is to clear
> all the D-bits of last level SPTEs. This situation can benefit from
> manual dirty log protect as well, which can reduce the mmu_lock
> time taken. The sequence is like this:
> 
> 1. Set all the bits of the first dirty bitmap to 1 when enabling
>    dirty log for the first time
> 2. Only write protect the huge pages
> 3. KVM_GET_DIRTY_LOG returns the dirty bitmap info
> 4. KVM_CLEAR_DIRTY_LOG will clear D-bit for each of the leaf level
>    SPTEs gradually in small chunks
> 
> Under the Intel(R) Xeon(R) Gold 6152 CPU @ 2.10GHz environment,
> I did some tests with a 128G windows VM and counted the time taken
> of memory_global_dirty_log_start, here is the numbers:
> 
> VM Size        Before    After optimization
> 128G           460ms     10ms

This is a good idea, but could userspace expect the bitmap to be 0 for
pages that haven't been touched?  I think this should be added as a new
bit to the KVM_ENABLE_CAP for KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2.  That is:

- in kvm_vm_ioctl_check_extension_generic, return 3 for
KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 (better: define two constants
KVM_DIRTY_LOG_MANUAL_PROTECT as 1 and KVM_DIRTY_LOG_INITIALLY_SET as 2).

- in kvm_vm_ioctl_enable_cap_generic, allow bit 0 and bit 1 for cap->args[0]

- in kvm_vm_ioctl_enable_cap_generic, check "if
(!(kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET))".

Thanks,

Paolo


> Signed-off-by: Jay Zhou <jianjay.zhou@huawei.com>
> ---
>  arch/x86/kvm/vmx/vmx.c   |  5 +++++
>  include/linux/kvm_host.h |  5 +++++
>  virt/kvm/kvm_main.c      | 10 ++++++++--
>  3 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3be25ec..a8d64f6 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7201,7 +7201,12 @@ static void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
>  static void vmx_slot_enable_log_dirty(struct kvm *kvm,
>  				     struct kvm_memory_slot *slot)
>  {
> +#if CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> +	if (!kvm->manual_dirty_log_protect)
> +		kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
> +#else
>  	kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
> +#endif
>  	kvm_mmu_slot_largepage_remove_write_access(kvm, slot);
>  }
>  
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e89eb67..fd149b0 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -360,6 +360,11 @@ static inline unsigned long *kvm_second_dirty_bitmap(struct kvm_memory_slot *mem
>  	return memslot->dirty_bitmap + len / sizeof(*memslot->dirty_bitmap);
>  }
>  
> +static inline void kvm_set_first_dirty_bitmap(struct kvm_memory_slot *memslot)
> +{
> +	bitmap_set(memslot->dirty_bitmap, 0, memslot->npages);
> +}
> +
>  struct kvm_s390_adapter_int {
>  	u64 ind_addr;
>  	u64 summary_addr;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 70f03ce..08565ed 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -862,7 +862,8 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
>   * Allocation size is twice as large as the actual dirty bitmap size.
>   * See x86's kvm_vm_ioctl_get_dirty_log() why this is needed.
>   */
> -static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
> +static int kvm_create_dirty_bitmap(struct kvm *kvm,
> +				struct kvm_memory_slot *memslot)
>  {
>  	unsigned long dirty_bytes = 2 * kvm_dirty_bitmap_bytes(memslot);
>  
> @@ -870,6 +871,11 @@ static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
>  	if (!memslot->dirty_bitmap)
>  		return -ENOMEM;
>  
> +#if CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> +	if (kvm->manual_dirty_log_protect)
> +		kvm_set_first_dirty_bitmap(memslot);
> +#endif
> +
>  	return 0;
>  }
>  
> @@ -1094,7 +1100,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  
>  	/* Allocate page dirty bitmap if needed */
>  	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
> -		if (kvm_create_dirty_bitmap(&new) < 0)
> +		if (kvm_create_dirty_bitmap(kvm, &new) < 0)
>  			goto out_free;
>  	}
>  
> 

