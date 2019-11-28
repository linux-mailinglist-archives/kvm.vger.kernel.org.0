Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7940E10C5A6
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 10:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfK1JIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 04:08:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22672 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727090AbfK1JIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 04:08:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574932085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LQyMIOq1brhBX2bUMaM6TFXqa3RnBbkv7h2aLB1dU5Q=;
        b=Ld4ueGqnZKPx4dNjtYdjIb739E2lG5QLQUHrajg5oxhafViAuBP+DL0WEuiU2WaT49T/Gu
        RrJwsf/4FfejqfyW5eP8MYfBQhvxvZ0P7ZnNd5MA7KvAQD23JX/ngJQqNzEA4GgS51tmRh
        Q7N0P9j9KwS5CqPW21Fv+PGYckFwzpU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-0ZLVFI1nP2WETMSLr2dzlg-1; Thu, 28 Nov 2019 04:08:03 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B577980183C;
        Thu, 28 Nov 2019 09:08:00 +0000 (UTC)
Received: from [10.36.116.37] (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 552426084E;
        Thu, 28 Nov 2019 09:07:54 +0000 (UTC)
Subject: Re: [PATCH] KVM: vgic: Use warpper function to lock/unlock all vcpus
 in kvm_vgic_create()
To:     linmiaohe <linmiaohe@huawei.com>, maz@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, catalin.marinas@arm.com,
        gregkh@linuxfoundation.org, will@kernel.org,
        andre.przywara@arm.com, tglx@linutronix.de
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1574910551-14351-1-git-send-email-linmiaohe@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <cdd7ef36-70ae-3e56-2ea3-48d7051991c3@redhat.com>
Date:   Thu, 28 Nov 2019 10:07:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1574910551-14351-1-git-send-email-linmiaohe@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 0ZLVFI1nP2WETMSLr2dzlg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/28/19 4:09 AM, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> Use warpper function lock_all_vcpus()/unlock_all_vcpus()
s/warpper/wrapper and also in the title.
> in kvm_vgic_create() to remove duplicated code dealing
> with locking and unlocking all vcpus in a vm.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  virt/kvm/arm/vgic/vgic-init.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index b3c5de48064c..53e3969dfb52 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -70,7 +70,7 @@ void kvm_vgic_early_init(struct kvm *kvm)
>   */
>  int kvm_vgic_create(struct kvm *kvm, u32 type)
>  {
> -	int i, vcpu_lock_idx = -1, ret;
> +	int i, ret;
>  	struct kvm_vcpu *vcpu;
>  
>  	if (irqchip_in_kernel(kvm))
> @@ -92,11 +92,8 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>  	 * that no other VCPUs are run while we create the vgic.
>  	 */
>  	ret = -EBUSY;
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		if (!mutex_trylock(&vcpu->mutex))
> -			goto out_unlock;
> -		vcpu_lock_idx = i;
> -	}
> +	if (!lock_all_vcpus(kvm))
> +		return ret;
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		if (vcpu->arch.has_run_once)
> @@ -125,10 +122,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>  		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
>  
>  out_unlock:
> -	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
> -		vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
> -		mutex_unlock(&vcpu->mutex);
> -	}
> +	unlock_all_vcpus(kvm);
>  	return ret;
>  }
>  
> 
Besides, looks good to me
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

