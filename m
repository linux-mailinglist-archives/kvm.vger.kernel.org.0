Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8C3167AFA
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 11:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgBUKmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 05:42:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32808 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726325AbgBUKmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 05:42:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582281734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SxUDH729ImYJWoEJ7OBwmWzajRZSSJWfF59Hr+aoows=;
        b=UAD5I7NCPFc16opvCWjL2WUS5nABV5qSYb8LO8pSLfc6tP1xQTj5UZIPvaRu/NSf+mG/l/
        ka1FG1U34izq9q3sQpokNlPCiPz4bUeTwQb7q+OB3WNqRSVNXz6HDJlkhlK0GIDTCQKGe6
        V0Y0eN6P9VZFmpNAbSwkkaNRLaieKCc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-LZqUQ3abOY2i8_yjgdAZLw-1; Fri, 21 Feb 2020 05:42:07 -0500
X-MC-Unique: LZqUQ3abOY2i8_yjgdAZLw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 447238017CC;
        Fri, 21 Feb 2020 10:42:05 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB2AD1001F43;
        Fri, 21 Feb 2020 10:42:00 +0000 (UTC)
Date:   Fri, 21 Feb 2020 11:41:58 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Ulrich.Weigand@de.ibm.com, david@redhat.com,
        frankja@linux.vnet.ibm.com, gor@linux.ibm.com,
        imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, mimu@linux.ibm.com, thuth@redhat.com
Subject: Re: [PATCH v3.1 02/37] KVM: s390/interrupt: do not pin adapter
 interrupt pages
Message-ID: <20200221114158.2eeca512.cohuck@redhat.com>
In-Reply-To: <20200221080942.10334-1-borntraeger@de.ibm.com>
References: <20200220104020.5343-3-borntraeger@de.ibm.com>
        <20200221080942.10334-1-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Feb 2020 03:09:42 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
> 
> The adapter interrupt page containing the indicator bits is currently
> pinned. That means that a guest with many devices can pin a lot of
> memory pages in the host. This also complicates the reference tracking
> which is needed for memory management handling of protected virtual
> machines. It might also have some strange side effects for madvise
> MADV_DONTNEED and other things.
> 
> We can simply try to get the userspace page set the bits and free the
> page. By storing the userspace address in the irq routing entry instead
> of the guest address we can actually avoid many lookups and list walks
> so that this variant is very likely not slower.
> 
> If userspace messes around with the memory slots the worst thing that
> can happen is that we write to some other memory within that process.
> As we get the the page with FOLL_WRITE this can also not be used to
> write to shared read-only pages.
> 
> Signed-off-by: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
> [borntraeger@de.ibm.com: patch simplification]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  Documentation/virt/kvm/devices/s390_flic.rst |  11 +-
>  arch/s390/include/asm/kvm_host.h             |   3 -
>  arch/s390/kvm/interrupt.c                    | 172 ++++++-------------
>  3 files changed, 52 insertions(+), 134 deletions(-)

(...)

> @@ -2456,12 +2378,13 @@ static int modify_io_adapter(struct kvm_device *dev,
>  		if (ret > 0)
>  			ret = 0;
>  		break;
> +	/*
> +	 * We resolve the gpa to hva when setting the IRQ routing. the set_irq
> +	 * code uses get_user_pages_remote() to do the actual write.
> +	 */

What about:

"The following operations are no longer needed and therefore no-ops.
The gpa to hva translation is done when an IRQ route is set up. The
set_irq code uses get_user_pages_remote() to do the actual write."

>  	case KVM_S390_IO_ADAPTER_MAP:
> -		ret = kvm_s390_adapter_map(dev->kvm, req.id, req.addr);
> -		break;
>  	case KVM_S390_IO_ADAPTER_UNMAP:
> -		ret = kvm_s390_adapter_unmap(dev->kvm, req.id, req.addr);
> -		break;
> +		return 0;

I think
		ret = 0;
		break;

would be better, as the other cases do not do a direct return, either.

>  	default:
>  		ret = -EINVAL;
>  	}
> @@ -2699,19 +2622,17 @@ static unsigned long get_ind_bit(__u64 addr, unsigned long bit_nr, bool swap)
>  	return swap ? (bit ^ (BITS_PER_LONG - 1)) : bit;
>  }
>  
> -static struct s390_map_info *get_map_info(struct s390_io_adapter *adapter,
> -					  u64 addr)
> +static struct page *get_map_page(struct kvm *kvm,
> +				 struct s390_io_adapter *adapter,

adapter seems to be unused in this function now? Should we remove it from the parameter list?


> +				 u64 uaddr)
>  {
> -	struct s390_map_info *map;
> -
> -	if (!adapter)
> -		return NULL;
> +	struct page *page = NULL;
>  
> -	list_for_each_entry(map, &adapter->maps, list) {
> -		if (map->guest_addr == addr)
> -			return map;
> -	}
> -	return NULL;
> +	down_read(&kvm->mm->mmap_sem);
> +	get_user_pages_remote(NULL, kvm->mm, uaddr, 1, FOLL_WRITE,
> +			      &page, NULL, NULL);
> +	up_read(&kvm->mm->mmap_sem);
> +	return page;
>  }
>  
>  static int adapter_indicators_set(struct kvm *kvm,
> @@ -2720,30 +2641,35 @@ static int adapter_indicators_set(struct kvm *kvm,
>  {
>  	unsigned long bit;
>  	int summary_set, idx;
> -	struct s390_map_info *info;
> +	struct page *ind_page, *summary_page;
>  	void *map;
>  
> -	info = get_map_info(adapter, adapter_int->ind_addr);
> -	if (!info)
> +	ind_page = get_map_page(kvm, adapter, adapter_int->ind_addr);
> +	if (!ind_page)
>  		return -1;
> -	map = page_address(info->page);
> -	bit = get_ind_bit(info->addr, adapter_int->ind_offset, adapter->swap);
> -	set_bit(bit, map);
> -	idx = srcu_read_lock(&kvm->srcu);
> -	mark_page_dirty(kvm, info->guest_addr >> PAGE_SHIFT);
> -	set_page_dirty_lock(info->page);
> -	info = get_map_info(adapter, adapter_int->summary_addr);
> -	if (!info) {
> -		srcu_read_unlock(&kvm->srcu, idx);
> +	summary_page = get_map_page(kvm, adapter, adapter_int->summary_addr);
> +	if (!summary_page) {
> +		put_page(ind_page);
>  		return -1;
>  	}
> -	map = page_address(info->page);
> -	bit = get_ind_bit(info->addr, adapter_int->summary_offset,
> -			  adapter->swap);
> +
> +	idx = srcu_read_lock(&kvm->srcu);
> +	map = page_address(ind_page);
> +	bit = get_ind_bit(adapter_int->ind_addr,
> +			  adapter_int->ind_offset, adapter->swap);
> +	set_bit(bit, map);
> +	mark_page_dirty(kvm, adapter_int->ind_addr >> PAGE_SHIFT);
> +	set_page_dirty_lock(ind_page);
> +	map = page_address(summary_page);
> +	bit = get_ind_bit(adapter_int->summary_addr,
> +			  adapter_int->summary_offset, adapter->swap);
>  	summary_set = test_and_set_bit(bit, map);
> -	mark_page_dirty(kvm, info->guest_addr >> PAGE_SHIFT);
> -	set_page_dirty_lock(info->page);
> +	mark_page_dirty(kvm, adapter_int->summary_addr >> PAGE_SHIFT);
> +	set_page_dirty_lock(summary_page);
>  	srcu_read_unlock(&kvm->srcu, idx);
> +
> +	put_page(ind_page);
> +	put_page(summary_page);
>  	return summary_set ? 0 : 1;
>  }
>  
> @@ -2765,9 +2691,7 @@ static int set_adapter_int(struct kvm_kernel_irq_routing_entry *e,
>  	adapter = get_io_adapter(kvm, e->adapter.adapter_id);
>  	if (!adapter)
>  		return -1;
> -	down_read(&adapter->maps_lock);
>  	ret = adapter_indicators_set(kvm, adapter, &e->adapter);
> -	up_read(&adapter->maps_lock);
>  	if ((ret > 0) && !adapter->masked) {
>  		ret = kvm_s390_inject_airq(kvm, adapter);
>  		if (ret == 0)
> @@ -2818,23 +2742,27 @@ int kvm_set_routing_entry(struct kvm *kvm,
>  			  struct kvm_kernel_irq_routing_entry *e,
>  			  const struct kvm_irq_routing_entry *ue)
>  {
> -	int ret;
> +	u64 uaddr;
>  
>  	switch (ue->type) {
> +	/* we store the userspace addresses instead of the guest addresses */
>  	case KVM_IRQ_ROUTING_S390_ADAPTER:
>  		e->set = set_adapter_int;
> -		e->adapter.summary_addr = ue->u.adapter.summary_addr;
> -		e->adapter.ind_addr = ue->u.adapter.ind_addr;
> +		uaddr =  gmap_translate(kvm->arch.gmap, ue->u.adapter.summary_addr);
> +		if (uaddr == -EFAULT)
> +			return -EFAULT;
> +		e->adapter.summary_addr = uaddr;
> +		uaddr =  gmap_translate(kvm->arch.gmap, ue->u.adapter.ind_addr);
> +		if (uaddr == -EFAULT)
> +			return -EFAULT;
> +		e->adapter.ind_addr = uaddr;
>  		e->adapter.summary_offset = ue->u.adapter.summary_offset;
>  		e->adapter.ind_offset = ue->u.adapter.ind_offset;
>  		e->adapter.adapter_id = ue->u.adapter.adapter_id;
> -		ret = 0;
> -		break;
> +		return 0;
>  	default:
> -		ret = -EINVAL;
> +		return -EINVAL;
>  	}
> -
> -	return ret;
>  }
>  
>  int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,

