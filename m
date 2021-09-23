Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2AEF416364
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 18:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbhIWQgJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 12:36:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27470 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231171AbhIWQgD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 12:36:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632414871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wWJIS2kE+szXqAFxlHSk2kWCjmNxITRa7Gc/WMUXuy8=;
        b=WfKa+GVM4sg4meqU+H2lxZiFqMxXa1ZziYF+b00tHXNPlwTcSG5RRJKEcov16rIIAM4+QZ
        yuPaoS7mT2xITwRe/7hq6NQgDFoRnyW2rziz/5B9rbxJISwKUON7Tqao1EF3C/wr8WQMFW
        VZFTFPPjwvVged6C7EBrYT3L8q72dR0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-KzDsY3ynO_ycccO-9S1aNQ-1; Thu, 23 Sep 2021 12:34:30 -0400
X-MC-Unique: KzDsY3ynO_ycccO-9S1aNQ-1
Received: by mail-ej1-f70.google.com with SMTP id 22-20020a170906301600b005ca77a21183so99849ejz.20
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 09:34:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wWJIS2kE+szXqAFxlHSk2kWCjmNxITRa7Gc/WMUXuy8=;
        b=Go5mzSPdI05mi4sBun5Ij3m+9hQa3smb3R0YkgRXmBAvYMuuX+3zsd78ulNrKtADxF
         G3ipXzQiKu0iLVqGEuT1vlwlT4ghTNadS0WiXdxUnb5JY0G57hN4AYZ4N0M+lDTcqbCl
         0w/f93fJ0lMwyavBB43uSfg4K6YQBOJM1vLsAWYHdbPQT009P45ubePSS1JH+HKtSrQf
         5mI9Xsjzx4soiOXST9PvnrtUkKS8pqOZ6S0SjnlEpPPbLmwWz5ez+Cy/xR0VZYRW7UjC
         lBSCBGceRH5xou7No6OXonLULuXZsKrEmwX2kCFUqDTXglXR5cWCnyq8Wyb0znvHT3Ze
         nFdg==
X-Gm-Message-State: AOAM532scyJyhSytXAuqisZDKbgzuNvfvCK5puP7gXNnkeq2KuJYukue
        hhHp1ihoJL2Tk+CGieuZYkl3bLWzy1dxphkoExYDyeRDB6BARuXKMWbqEmdk+34fPVnZVkITGdb
        L9Hw43XtZPZt+
X-Received: by 2002:a05:6402:1437:: with SMTP id c23mr6481472edx.247.1632414868846;
        Thu, 23 Sep 2021 09:34:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyUms4bSxmu1S2j/lCVpl/iaye5bwxmfEaXwPEOBI4b/7vkjYl1tRGerBCTiMwIo/f04qiszg==
X-Received: by 2002:a05:6402:1437:: with SMTP id c23mr6481443edx.247.1632414868641;
        Thu, 23 Sep 2021 09:34:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id 6sm3361080ejx.82.2021.09.23.09.34.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 09:34:28 -0700 (PDT)
Subject: Re: [PATCH] kvm: irqfd: avoid update unmodified entries of the
 routing
To:     "Longpeng(Mike)" <longpeng2@huawei.com>
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arei.gonglei@huawei.com
References: <20210827080003.2689-1-longpeng2@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2b8efa4f-36db-a4d5-f07d-987f6053627b@redhat.com>
Date:   Thu, 23 Sep 2021 18:34:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210827080003.2689-1-longpeng2@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/21 10:00, Longpeng(Mike) wrote:
> All of the irqfds would to be updated when update the irq
> routing, it's too expensive if there're too many irqfds.
> 
> However we can reduce the cost by avoid some unnecessary
> updates. For irqs of MSI type on X86, the update can be
> saved if the msi values are not change.
> 
> The vfio migration could receives benefit from this optimi-
> zaiton. The test VM has 128 vcpus and 8 VF (with 65 vectors
> enabled), so the VM has more than 520 irqfds. We mesure the
> cost of the vfio_msix_enable (in QEMU, it would set routing
> for each irqfd) for each VF, and we can see the total cost
> can be significantly reduced.
> 
>                  Origin         Apply this Patch
> 1st             8              4
> 2nd             15             5
> 3rd             22             6
> 4th             24             6
> 5th             36             7
> 6th             44             7
> 7th             51             8
> 8th             58             8
> Total           258ms          51ms
> 
> We're also tring to optimize the QEMU part [1], but it's still
> worth to optimize the KVM to gain more benefits.
> 
> [1] https://lists.gnu.org/archive/html/qemu-devel/2021-08/msg04215.html
> 
> Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
> ---
>   arch/x86/kvm/x86.c       |  9 +++++++++
>   include/linux/kvm_host.h |  2 ++
>   virt/kvm/eventfd.c       | 15 ++++++++++++++-
>   3 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e5d5c5e..22cf20e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12023,6 +12023,15 @@ int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
>   	return static_call(kvm_x86_update_pi_irte)(kvm, host_irq, guest_irq, set);
>   }
>   
> +bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
> +				  struct kvm_kernel_irq_routing_entry *new)
> +{
> +	if (new->type != KVM_IRQ_ROUTING_MSI)
> +		return true;
> +
> +	return !!memcmp(&old->msi, &new->msi, sizeof(new->msi));
> +}
> +
>   bool kvm_vector_hashing_enabled(void)
>   {
>   	return vector_hashing;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ae7735b..c0954ae 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1621,6 +1621,8 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *,
>   void kvm_arch_irq_bypass_start(struct irq_bypass_consumer *);
>   int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
>   				  uint32_t guest_irq, bool set);
> +bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *,
> +				  struct kvm_kernel_irq_routing_entry *);
>   #endif /* CONFIG_HAVE_KVM_IRQ_BYPASS */
>   
>   #ifdef CONFIG_HAVE_KVM_INVALID_WAKEUPS
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index e996989..2ad013b 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -281,6 +281,13 @@ int  __attribute__((weak)) kvm_arch_update_irqfd_routing(
>   {
>   	return 0;
>   }
> +
> +bool __attribute__((weak)) kvm_arch_irqfd_route_changed(
> +				struct kvm_kernel_irq_routing_entry *old,
> +				struct kvm_kernel_irq_routing_entry *new)
> +{
> +	return true;
> +}
>   #endif
>   
>   static int
> @@ -615,10 +622,16 @@ void kvm_irq_routing_update(struct kvm *kvm)
>   	spin_lock_irq(&kvm->irqfds.lock);
>   
>   	list_for_each_entry(irqfd, &kvm->irqfds.items, list) {
> +#ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
> +		/* Under irqfds.lock, so can read irq_entry safely */
> +		struct kvm_kernel_irq_routing_entry old = irqfd->irq_entry;
> +#endif
> +
>   		irqfd_update(kvm, irqfd);
>   
>   #ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
> -		if (irqfd->producer) {
> +		if (irqfd->producer &&
> +		    kvm_arch_irqfd_route_changed(&old, &irqfd->irq_entry)) {
>   			int ret = kvm_arch_update_irqfd_routing(
>   					irqfd->kvm, irqfd->producer->irq,
>   					irqfd->gsi, 1);
> 

Queued, thanks.

Paolo

