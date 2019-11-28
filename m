Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 149B110C7B6
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 12:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfK1LEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 06:04:40 -0500
Received: from foss.arm.com ([217.140.110.172]:33936 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbfK1LEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 06:04:40 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2F411FB;
        Thu, 28 Nov 2019 03:04:39 -0800 (PST)
Received: from [10.37.9.137] (unknown [10.37.9.137])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB81F3F6C4;
        Thu, 28 Nov 2019 03:04:35 -0800 (PST)
Subject: Re: [PATCH v2] KVM: vgic: Use wrapper function to lock/unlock all
 vcpus in kvm_vgic_create()
To:     linmiaohe <linmiaohe@huawei.com>, maz@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, catalin.marinas@arm.com,
        eric.auger@redhat.com, gregkh@linuxfoundation.org, will@kernel.org,
        andre.przywara@arm.com, tglx@linutronix.de
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1574933208-24911-1-git-send-email-linmiaohe@huawei.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <ea23652a-8a1a-7bfe-96d6-838038f3a93b@arm.com>
Date:   Thu, 28 Nov 2019 11:04:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1574933208-24911-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/11/2019 09:26, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> Use wrapper function lock_all_vcpus()/unlock_all_vcpus()
> in kvm_vgic_create() to remove duplicated code dealing
> with locking and unlocking all vcpus in a vm.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
> -v2:
> 	Fix some spelling mistake in patch title and commit log.
> ---
>   virt/kvm/arm/vgic/vgic-init.c | 14 ++++----------
>   1 file changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index b3c5de48064c..53e3969dfb52 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -70,7 +70,7 @@ void kvm_vgic_early_init(struct kvm *kvm)
>    */
>   int kvm_vgic_create(struct kvm *kvm, u32 type)
>   {
> -	int i, vcpu_lock_idx = -1, ret;
> +	int i, ret;
>   	struct kvm_vcpu *vcpu;
>   
>   	if (irqchip_in_kernel(kvm))
> @@ -92,11 +92,8 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
Extra context:

	/*
	 * Any time a vcpu is run, vcpu_load is called which tries to grab the
	 * vcpu->mutex.  By grabbing the vcpu->mutex of all VCPUs we ensure
>   	 * that no other VCPUs are run while we create the vgic.
>   	 */

That comment no longer makes sense here - there's a very similar one already
in lock_all_vcpus(). With that removed:

Reviewed-by: Steven Price <steven.price@arm.com>

>   	ret = -EBUSY;
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		if (!mutex_trylock(&vcpu->mutex))
> -			goto out_unlock;
> -		vcpu_lock_idx = i;
> -	}
> +	if (!lock_all_vcpus(kvm))
> +		return ret;
>   
>   	kvm_for_each_vcpu(i, vcpu, kvm) {
>   		if (vcpu->arch.has_run_once)
> @@ -125,10 +122,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>   		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
>   
>   out_unlock:
> -	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
> -		vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
> -		mutex_unlock(&vcpu->mutex);
> -	}
> +	unlock_all_vcpus(kvm);
>   	return ret;
>   }
>   
> 

