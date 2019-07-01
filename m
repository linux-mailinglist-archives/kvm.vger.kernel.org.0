Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02EA35BBA2
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 14:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbfGAMi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 08:38:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44694 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727320AbfGAMi0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 08:38:26 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EC77836887;
        Mon,  1 Jul 2019 12:38:25 +0000 (UTC)
Received: from [10.36.116.89] (ovpn-116-89.ams2.redhat.com [10.36.116.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 372891B4B0;
        Mon,  1 Jul 2019 12:38:17 +0000 (UTC)
Subject: Re: [PATCH v2 4/9] KVM: arm/arm64: vgic-its: Invalidate MSI-LPI
 translation cache on specific commands
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        "Saidi, Ali" <alisaidi@amazon.com>
References: <20190611170336.121706-1-marc.zyngier@arm.com>
 <20190611170336.121706-5-marc.zyngier@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <9ff329a3-44f2-1de3-b6cc-58ed38a63665@redhat.com>
Date:   Mon, 1 Jul 2019 14:38:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190611170336.121706-5-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 01 Jul 2019 12:38:26 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 6/11/19 7:03 PM, Marc Zyngier wrote:
> The LPI translation cache needs to be discarded when an ITS command
> may affect the translation of an LPI (DISCARD and MAPD with V=0) or
> the routing of an LPI to a redistributor with disabled LPIs (MOVI,
> MOVALL).
> 
> We decide to perform a full invalidation of the cache, irrespective
> of the LPI that is affected. Commands are supposed to be rare enough
> that it doesn't matter.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 9b6b66204b97..5254bb762e1b 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -733,6 +733,8 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
>  		 * don't bother here since we clear the ITTE anyway and the
>  		 * pending state is a property of the ITTE struct.
>  		 */
> +		vgic_its_invalidate_cache(kvm);
> +
>  		its_free_ite(kvm, ite);
>  		return 0;
>  	}
> @@ -768,6 +770,8 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
>  	ite->collection = collection;
>  	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
>  
> +	vgic_its_invalidate_cache(kvm);
> +
>  	return update_affinity(ite->irq, vcpu);
>  }
>  
> @@ -996,6 +1000,8 @@ static void vgic_its_free_device(struct kvm *kvm, struct its_device *device)
>  	list_for_each_entry_safe(ite, temp, &device->itt_head, ite_list)
>  		its_free_ite(kvm, ite);
>  
> +	vgic_its_invalidate_cache(kvm);
> +
>  	list_del(&device->dev_list);
>  	kfree(device);
>  }
> @@ -1249,6 +1255,8 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
>  		vgic_put_irq(kvm, irq);
>  	}
>  
> +	vgic_its_invalidate_cache(kvm);
All the commands are executed with the its_lock held. Now we don't take
it anymore on the fast cache injection path. Don't we have a window
where the move has been applied at table level and the cache is not yet
invalidated? Same question for vgic_its_free_device().

Thanks

Eric


> +
>  	kfree(intids);
>  	return 0;
>  }
> 
