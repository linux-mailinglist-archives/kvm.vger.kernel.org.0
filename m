Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61DC920AA
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 11:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfHSJtg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 05:49:36 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:31357 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfHSJtf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 05:49:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566208174; x=1597744174;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=5dkSQiGHA49685aX5yHIV1484xLY3TplO6edQp6C6Ic=;
  b=UUg2MN3JhzMxR/CKHsJDHQm4K/L/6aOPxjQ3nGrxB6qVNpjt0aR8+E5X
   D8fEalglx7AIjEcgFrOX/Y5O3gSaoRkHJAfswY8KXyputxYnxlyISJzLt
   3+OuMiPDnUqynktIPvC/GBJdtmB3XBEn4ufZehUCmrN6WWKsHkFX6XqlO
   U=;
X-IronPort-AV: E=Sophos;i="5.64,403,1559520000"; 
   d="scan'208";a="695072317"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 19 Aug 2019 09:49:18 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id 0D7ABA2451;
        Mon, 19 Aug 2019 09:49:15 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 19 Aug 2019 09:49:15 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.20) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 19 Aug 2019 09:49:12 +0000
Subject: Re: [PATCH v2 02/15] kvm: x86: Introduce KVM APICv state
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1565886293-115836-3-git-send-email-suravee.suthikulpanit@amd.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <7c71379b-d94c-dc8e-f684-331183f8a594@amazon.com>
Date:   Mon, 19 Aug 2019 11:49:10 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1565886293-115836-3-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.160.20]
X-ClientProxiedBy: EX13D22UWC004.ant.amazon.com (10.43.162.198) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 15.08.19 18:25, Suthikulpanit, Suravee wrote:
> Currently, after a VM boots with APICv enabled, it could go into
> the following states:
>    * activated   = VM is running w/ APICv
>    * deactivated = VM deactivate APICv (temporary)
>    * disabled    = VM deactivate APICv (permanent)
> 
> Introduce KVM APICv state enum to help keep track of the APICv states
> along with a new variable struct kvm_arch.apicv_state to store
> the current state.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 11 +++++++++++
>   arch/x86/kvm/x86.c              | 14 +++++++++++++-
>   2 files changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 56bc702..04d7066 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -845,6 +845,15 @@ enum kvm_irqchip_mode {
>   	KVM_IRQCHIP_SPLIT,        /* created with KVM_CAP_SPLIT_IRQCHIP */
>   };
>   
> +/*
> + * KVM assumes all vcpus in a VM operate in the same mode.
> + */
> +enum kvm_apicv_state {
> +	APICV_DISABLED,		/* Disabled (such as for Hyper-V case) */
> +	APICV_DEACTIVATED,	/* Deactivated tempoerary */

typo

I'm also not sure the name is 100% obvious. How about something like 
"suspended" or "paused"?

> +	APICV_ACTIVATED,	/* Default status when APICV is enabled */
> +};
> +
>   struct kvm_arch {
>   	unsigned long n_used_mmu_pages;
>   	unsigned long n_requested_mmu_pages;
> @@ -873,6 +882,8 @@ struct kvm_arch {
>   	struct kvm_apic_map *apic_map;
>   
>   	bool apic_access_page_done;
> +	struct mutex apicv_lock;
> +	enum kvm_apicv_state apicv_state;
>   
>   	gpa_t wall_clock;
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7daf0dd..f9c3f63 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4584,6 +4584,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		kvm->arch.irqchip_mode = KVM_IRQCHIP_SPLIT;
>   		kvm->arch.nr_reserved_ioapic_pins = cap->args[0];
>   		r = 0;
> +		if (kvm_x86_ops->get_enable_apicv(kvm))
> +			kvm->arch.apicv_state = APICV_ACTIVATED;
>   split_irqchip_unlock:
>   		mutex_unlock(&kvm->lock);
>   		break;
> @@ -4701,6 +4703,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
>   		/* Write kvm->irq_routing before enabling irqchip_in_kernel. */
>   		smp_wmb();
>   		kvm->arch.irqchip_mode = KVM_IRQCHIP_KERNEL;
> +		if (kvm_x86_ops->get_enable_apicv(kvm))
> +			kvm->arch.apicv_state = APICV_ACTIVATED;
>   	create_irqchip_unlock:
>   		mutex_unlock(&kvm->lock);
>   		break;
> @@ -9150,13 +9154,18 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>   		goto fail_free_pio_data;
>   
>   	if (irqchip_in_kernel(vcpu->kvm)) {
> -		vcpu->arch.apicv_active = kvm_x86_ops->get_enable_apicv(vcpu->kvm);

Why are you moving this into a locked section?

>   		r = kvm_create_lapic(vcpu, lapic_timer_advance_ns);
>   		if (r < 0)
>   			goto fail_mmu_destroy;
>   	} else
>   		static_key_slow_inc(&kvm_no_apic_vcpu);
>   
> +	mutex_lock(&vcpu->kvm->arch.apicv_lock);
> +	if (irqchip_in_kernel(vcpu->kvm) &&
> +	    vcpu->kvm->arch.apicv_state == APICV_ACTIVATED)
> +		vcpu->arch.apicv_active = kvm_x86_ops->get_enable_apicv(vcpu->kvm);
> +	mutex_unlock(&vcpu->kvm->arch.apicv_lock);
> +
>   	vcpu->arch.mce_banks = kzalloc(KVM_MAX_MCE_BANKS * sizeof(u64) * 4,
>   				       GFP_KERNEL_ACCOUNT);
>   	if (!vcpu->arch.mce_banks) {
> @@ -9255,6 +9264,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	kvm_page_track_init(kvm);
>   	kvm_mmu_init_vm(kvm);
>   
> +	/* APICV initialization */
> +	mutex_init(&kvm->arch.apicv_lock);

In fact, the whole lock story is not part of the patch description :).


Alex

> +
>   	if (kvm_x86_ops->vm_init)
>   		return kvm_x86_ops->vm_init(kvm);
>   
> 
