Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B368415A949
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 13:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbgBLMj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 07:39:29 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47135 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726728AbgBLMj3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Feb 2020 07:39:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581511167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lrOf0m5SvxP5QCA86tTGN9hUolA1Hd0GGjFfSXWjAYA=;
        b=ZoiwioTsuOiMiNpJW9yQv4i32Q9jWS4GwFKD9eWVpkG/Qx33AmPZNJZ9udc0GTSf/e33iP
        p2S+v5QM2gNtkTAmvSH0enExBIIP71HiNj9Yjku/GpWWT+y4f3f6q4owfDGM0xMqrYddMV
        pu9FYAZ9ob4ewS+Jvifljfm2Oucqo8w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-kW5tyTK4OfajhoaOohWPdg-1; Wed, 12 Feb 2020 07:39:16 -0500
X-MC-Unique: kW5tyTK4OfajhoaOohWPdg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33328107ACC7;
        Wed, 12 Feb 2020 12:39:15 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E0B0388;
        Wed, 12 Feb 2020 12:39:10 +0000 (UTC)
Date:   Wed, 12 Feb 2020 13:39:08 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     david@redhat.com, Ulrich.Weigand@de.ibm.com, aarcange@redhat.com,
        akpm@linux-foundation.org, frankja@linux.vnet.ibm.com,
        gor@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-s390@vger.kernel.org, mimu@linux.ibm.com,
        thuth@redhat.com
Subject: Re: [PATCH v2 RFC] KVM: s390/interrupt: do not pin adapter
 interrupt pages
Message-ID: <20200212133908.6c6c9072.cohuck@redhat.com>
In-Reply-To: <20200211092341.3965-1-borntraeger@de.ibm.com>
References: <567B980B-BDA5-4EF3-A96E-1542D11F2BD4@redhat.com>
        <20200211092341.3965-1-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Feb 2020 04:23:41 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
> 
> The adapter interrupt page containing the indicator bits is currently
> pinned. That means that a guest with many devices can pin a lot of
> memory pages in the host. This also complicates the reference tracking
> which is needed for memory management handling of protected virtual
> machines.
> We can simply try to get the userspace page set the bits and free the
> page. By storing the userspace address in the irq routing entry instead
> of the guest address we can actually avoid many lookups and list walks
> so that this variant is very likely not slower.
> 
> Signed-off-by: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
> [borntraeger@de.ibm.com: patch simplification]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
> quick and dirty, how this could look like
> 
> 
>  arch/s390/include/asm/kvm_host.h |   3 -
>  arch/s390/kvm/interrupt.c        | 146 +++++++++++--------------------
>  2 files changed, 49 insertions(+), 100 deletions(-)
> 

(...)

> @@ -2488,83 +2485,26 @@ int kvm_s390_mask_adapter(struct kvm *kvm, unsigned int id, bool masked)
>  
>  static int kvm_s390_adapter_map(struct kvm *kvm, unsigned int id, __u64 addr)
>  {
> -	struct s390_io_adapter *adapter = get_io_adapter(kvm, id);
> -	struct s390_map_info *map;
> -	int ret;
> -
> -	if (!adapter || !addr)
> -		return -EINVAL;
> -
> -	map = kzalloc(sizeof(*map), GFP_KERNEL);
> -	if (!map) {
> -		ret = -ENOMEM;
> -		goto out;
> -	}
> -	INIT_LIST_HEAD(&map->list);
> -	map->guest_addr = addr;
> -	map->addr = gmap_translate(kvm->arch.gmap, addr);
> -	if (map->addr == -EFAULT) {
> -		ret = -EFAULT;
> -		goto out;
> -	}
> -	ret = get_user_pages_fast(map->addr, 1, FOLL_WRITE, &map->page);
> -	if (ret < 0)
> -		goto out;
> -	BUG_ON(ret != 1);
> -	down_write(&adapter->maps_lock);
> -	if (atomic_inc_return(&adapter->nr_maps) < MAX_S390_ADAPTER_MAPS) {
> -		list_add_tail(&map->list, &adapter->maps);
> -		ret = 0;
> -	} else {
> -		put_page(map->page);
> -		ret = -EINVAL;
> +	/*
> +	 * We resolve the gpa to hva when setting the IRQ routing. If userspace
> +	 * decides to mess with the memslots it better also updates the irq
> +	 * routing. Otherwise we will write to the wrong userspace address.
> +	 */
> +	return 0;

Given that this function now always returns 0, we basically get a
completely useless roundtrip into the kernel when userspace is trying
to setup the mappings.

Can we define a new IO_ADAPTER_MAPPING_NOT_NEEDED or so capability that
userspace can check?

This change in behaviour probably wants a change in the documentation
as well.

>  	}
> -	up_write(&adapter->maps_lock);
> -out:
> -	if (ret)
> -		kfree(map);
> -	return ret;
> -}
>  
>  static int kvm_s390_adapter_unmap(struct kvm *kvm, unsigned int id, __u64 addr)
>  {
> -	struct s390_io_adapter *adapter = get_io_adapter(kvm, id);
> -	struct s390_map_info *map, *tmp;
> -	int found = 0;
> -
> -	if (!adapter || !addr)
> -		return -EINVAL;
> -
> -	down_write(&adapter->maps_lock);
> -	list_for_each_entry_safe(map, tmp, &adapter->maps, list) {
> -		if (map->guest_addr == addr) {
> -			found = 1;
> -			atomic_dec(&adapter->nr_maps);
> -			list_del(&map->list);
> -			put_page(map->page);
> -			kfree(map);
> -			break;
> -		}
> -	}
> -	up_write(&adapter->maps_lock);
> -
> -	return found ? 0 : -EINVAL;
> +	return 0;

Same here.

>  }
>  
>  void kvm_s390_destroy_adapters(struct kvm *kvm)
>  {
>  	int i;
> -	struct s390_map_info *map, *tmp;
>  
>  	for (i = 0; i < MAX_S390_IO_ADAPTERS; i++) {
>  		if (!kvm->arch.adapters[i])
>  			continue;
> -		list_for_each_entry_safe(map, tmp,
> -					 &kvm->arch.adapters[i]->maps, list) {
> -			list_del(&map->list);
> -			put_page(map->page);
> -			kfree(map);
> -		}
>  		kfree(kvm->arch.adapters[i]);

Call kfree() unconditionally?

>  	}
>  }
> @@ -2831,19 +2771,25 @@ static unsigned long get_ind_bit(__u64 addr, unsigned long bit_nr, bool swap)
>  	return swap ? (bit ^ (BITS_PER_LONG - 1)) : bit;
>  }
>  
> -static struct s390_map_info *get_map_info(struct s390_io_adapter *adapter,
> -					  u64 addr)
> +static struct page *get_map_page(struct kvm *kvm,
> +				 struct s390_io_adapter *adapter,
> +				 u64 uaddr)
>  {
> -	struct s390_map_info *map;
> +	struct page *page;
> +	int ret;
>  
>  	if (!adapter)
>  		return NULL;
> -
> -	list_for_each_entry(map, &adapter->maps, list) {
> -		if (map->guest_addr == addr)
> -			return map;
> -	}
> -	return NULL;
> +	page = NULL;
> +	if (!uaddr)
> +		return NULL;
> +	down_read(&kvm->mm->mmap_sem);
> +	ret = get_user_pages_remote(NULL, kvm->mm, uaddr, 1, FOLL_WRITE,
> +				    &page, NULL, NULL);
> +	if (ret < 1)
> +		page = NULL;
> +	up_read(&kvm->mm->mmap_sem);
> +	return page;
>  }
>  
>  static int adapter_indicators_set(struct kvm *kvm,

(...)

> @@ -2951,12 +2900,15 @@ int kvm_set_routing_entry(struct kvm *kvm,
>  			  const struct kvm_irq_routing_entry *ue)
>  {
>  	int ret;
> +	u64 uaddr;
>  
>  	switch (ue->type) {
>  	case KVM_IRQ_ROUTING_S390_ADAPTER:
>  		e->set = set_adapter_int;
> -		e->adapter.summary_addr = ue->u.adapter.summary_addr;
> -		e->adapter.ind_addr = ue->u.adapter.ind_addr;
> +		uaddr =  gmap_translate(kvm->arch.gmap, ue->u.adapter.summary_addr);

Can gmap_translate() return -EFAULT here? The code above only seems to
check for 0... do we want to return an error here?

> +		e->adapter.summary_addr = uaddr;
> +		uaddr =  gmap_translate(kvm->arch.gmap, ue->u.adapter.ind_addr);
> +		e->adapter.ind_addr = uaddr;
>  		e->adapter.summary_offset = ue->u.adapter.summary_offset;
>  		e->adapter.ind_offset = ue->u.adapter.ind_offset;
>  		e->adapter.adapter_id = ue->u.adapter.adapter_id;

