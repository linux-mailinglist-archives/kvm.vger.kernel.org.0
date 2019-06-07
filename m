Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 138C938D00
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 16:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbfFGO3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 10:29:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51648 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729256AbfFGO3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 10:29:34 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7446C30BC582;
        Fri,  7 Jun 2019 14:29:34 +0000 (UTC)
Received: from [10.36.116.67] (ovpn-116-67.ams2.redhat.com [10.36.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 072FC60634;
        Fri,  7 Jun 2019 14:29:30 +0000 (UTC)
Subject: Re: [PATCH 4/8] KVM: arm/arm64: vgic-its: Add kvm parameter to
 vgic_its_free_collection
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>
References: <20190606165455.162478-1-marc.zyngier@arm.com>
 <20190606165455.162478-5-marc.zyngier@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <42b2f7fe-60e1-90b2-bc8a-515dc17f9d9c@redhat.com>
Date:   Fri, 7 Jun 2019 16:29:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190606165455.162478-5-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 07 Jun 2019 14:29:34 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,
On 6/6/19 6:54 PM, Marc Zyngier wrote:
> As we are going to perform some VM-wide operations when freeing
> a collection, add the kvm pointer to vgic_its_free_collection.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Eventually do you use that commit in subsequent patches?

Thanks

Eric
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index bc370b6c5afa..f637edd77e1f 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -885,7 +885,8 @@ static int vgic_its_alloc_collection(struct vgic_its *its,
>  	return 0;
>  }
>  
> -static void vgic_its_free_collection(struct vgic_its *its, u32 coll_id)
> +static void vgic_its_free_collection(struct kvm *kvm,
> +				     struct vgic_its *its, u32 coll_id)
>  {
>  	struct its_collection *collection;
>  	struct its_device *device;
> @@ -974,7 +975,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>  	ite = vgic_its_alloc_ite(device, collection, event_id);
>  	if (IS_ERR(ite)) {
>  		if (new_coll)
> -			vgic_its_free_collection(its, coll_id);
> +			vgic_its_free_collection(kvm, its, coll_id);
>  		return PTR_ERR(ite);
>  	}
>  
> @@ -984,7 +985,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>  	irq = vgic_add_lpi(kvm, lpi_nr, vcpu);
>  	if (IS_ERR(irq)) {
>  		if (new_coll)
> -			vgic_its_free_collection(its, coll_id);
> +			vgic_its_free_collection(kvm, its, coll_id);
>  		its_free_ite(kvm, ite);
>  		return PTR_ERR(irq);
>  	}
> @@ -1025,7 +1026,7 @@ static void vgic_its_free_collection_list(struct kvm *kvm, struct vgic_its *its)
>  	struct its_collection *cur, *temp;
>  
>  	list_for_each_entry_safe(cur, temp, &its->collection_list, coll_list)
> -		vgic_its_free_collection(its, cur->collection_id);
> +		vgic_its_free_collection(kvm, its, cur->collection_id);
>  }
>  
>  /* Must be called with its_lock mutex held */
> @@ -1110,7 +1111,7 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
>  		return E_ITS_MAPC_PROCNUM_OOR;
>  
>  	if (!valid) {
> -		vgic_its_free_collection(its, coll_id);
> +		vgic_its_free_collection(kvm, its, coll_id);
>  	} else {
>  		collection = find_collection(its, coll_id);
>  
> 
