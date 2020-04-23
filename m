Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6161B5B39
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 14:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgDWMSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 08:18:35 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2879 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726056AbgDWMSf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 08:18:35 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B62D4A5E8B3BB75455A8;
        Thu, 23 Apr 2020 20:18:31 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Thu, 23 Apr 2020
 20:18:25 +0800
Subject: Re: [PATCH v3 5/6] KVM: arm64: vgic-v3: Retire all pending LPIs on
 vcpu destroy
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Julien Grall <julien@xen.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200422161844.3848063-1-maz@kernel.org>
 <20200422161844.3848063-6-maz@kernel.org>
 <2a0d1542-1964-c818-aae8-76f9227676b8@arm.com>
 <c4b89164d79b733bcc38801c9483417d@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <5e611150-ce2a-7e90-ba9c-80275269b436@huawei.com>
Date:   Thu, 23 Apr 2020 20:18:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <c4b89164d79b733bcc38801c9483417d@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/4/23 20:03, Marc Zyngier wrote:
> 
> I think this is slightly more concerning. The issue is that we have
> started freeing parts of the interrupt state already (we free the
> SPIs early in kvm_vgic_dist_destroy()).
> 
> If a SPI was pending or active at this stage (i.e. present in the
> ap_list), we are going to iterate over memory that has been freed
> already. This is bad, and this can happen on GICv3 as well.

Ah, I think this should be the case.

> 
> I think this should solve it, but I need to test it on a GICv2 system:

Agreed.

> 
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 53ec9b9d9bc43..30dbec9fe0b4a 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -365,10 +365,10 @@ static void __kvm_vgic_destroy(struct kvm *kvm)
> 
>       vgic_debug_destroy(kvm);
> 
> -    kvm_vgic_dist_destroy(kvm);
> -
>       kvm_for_each_vcpu(i, vcpu, kvm)
>           kvm_vgic_vcpu_destroy(vcpu);
> +
> +    kvm_vgic_dist_destroy(kvm);
>   }
> 
>   void kvm_vgic_destroy(struct kvm *kvm)

Thanks for the fix,
Zenghui

