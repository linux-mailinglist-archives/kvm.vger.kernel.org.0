Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D8F4067E7
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 09:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbhIJHoh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 03:44:37 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:19023 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbhIJHog (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 03:44:36 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H5SSB2XJGzbmRf;
        Fri, 10 Sep 2021 15:39:22 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 10 Sep 2021 15:43:24 +0800
Received: from [10.174.148.223] (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 10 Sep 2021 15:43:23 +0800
Subject: Re: [PATCH] kvm: irqfd: avoid update unmodified entries of the
 routing
To:     <pbonzini@redhat.com>
CC:     <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <arei.gonglei@huawei.com>
References: <20210827080003.2689-1-longpeng2@huawei.com>
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Message-ID: <8bae4a6d-9b89-2543-fbed-7deb1d75fc41@huawei.com>
Date:   Fri, 10 Sep 2021 15:43:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210827080003.2689-1-longpeng2@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi guys,

Do you have any suggestions ? Thanks.

ÔÚ 2021/8/27 16:00, Longpeng(Mike) Ð´µÀ:
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
>                 Origin         Apply this Patch
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
>  arch/x86/kvm/x86.c       |  9 +++++++++
>  include/linux/kvm_host.h |  2 ++
>  virt/kvm/eventfd.c       | 15 ++++++++++++++-
>  3 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e5d5c5e..22cf20e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12023,6 +12023,15 @@ int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
>  	return static_call(kvm_x86_update_pi_irte)(kvm, host_irq, guest_irq, set);
>  }
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
>  bool kvm_vector_hashing_enabled(void)
>  {
>  	return vector_hashing;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ae7735b..c0954ae 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1621,6 +1621,8 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *,
>  void kvm_arch_irq_bypass_start(struct irq_bypass_consumer *);
>  int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
>  				  uint32_t guest_irq, bool set);
> +bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *,
> +				  struct kvm_kernel_irq_routing_entry *);
>  #endif /* CONFIG_HAVE_KVM_IRQ_BYPASS */
>  
>  #ifdef CONFIG_HAVE_KVM_INVALID_WAKEUPS
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index e996989..2ad013b 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -281,6 +281,13 @@ int  __attribute__((weak)) kvm_arch_update_irqfd_routing(
>  {
>  	return 0;
>  }
> +
> +bool __attribute__((weak)) kvm_arch_irqfd_route_changed(
> +				struct kvm_kernel_irq_routing_entry *old,
> +				struct kvm_kernel_irq_routing_entry *new)
> +{
> +	return true;
> +}
>  #endif
>  
>  static int
> @@ -615,10 +622,16 @@ void kvm_irq_routing_update(struct kvm *kvm)
>  	spin_lock_irq(&kvm->irqfds.lock);
>  
>  	list_for_each_entry(irqfd, &kvm->irqfds.items, list) {
> +#ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
> +		/* Under irqfds.lock, so can read irq_entry safely */
> +		struct kvm_kernel_irq_routing_entry old = irqfd->irq_entry;
> +#endif
> +
>  		irqfd_update(kvm, irqfd);
>  
>  #ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
> -		if (irqfd->producer) {
> +		if (irqfd->producer &&
> +		    kvm_arch_irqfd_route_changed(&old, &irqfd->irq_entry)) {
>  			int ret = kvm_arch_update_irqfd_routing(
>  					irqfd->kvm, irqfd->producer->irq,
>  					irqfd->gsi, 1);
> 
