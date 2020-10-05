Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77AA6283DF4
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 20:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgJESEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 14:04:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44361 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726248AbgJESEd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 14:04:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601921071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XG1Rp+u5vv5Be2qRPXa/mDytSYLqQgxc7eXveQCiRcA=;
        b=WKzxNKfgFduX2Fi/nlFTzv929+R8YvH8q359ZHDK6yCXnWDSfexjPgRuAbj29btWEf/yP4
        8/0F/bOsbMMSycJs8Xk0kBoRmqBo+OZwwY3+W2CY8i9DX7AP0eeH464Uj5d9/GjWE5RR4q
        gXqg9gR+4u8MDzo4XEsbi9yX4dlmduI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-tdvdL8E0OVi8iNEPseHhag-1; Mon, 05 Oct 2020 14:04:27 -0400
X-MC-Unique: tdvdL8E0OVi8iNEPseHhag-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05208100854A;
        Mon,  5 Oct 2020 18:04:26 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.195.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 11FC875120;
        Mon,  5 Oct 2020 18:04:20 +0000 (UTC)
Date:   Mon, 5 Oct 2020 20:04:18 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 4/7] lib/alloc_page: complete rewrite
 of the page allocator
Message-ID: <20201005180418.elbco6jifqtu36lq@kamzik.brq.redhat.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
 <20201002154420.292134-5-imbrenda@linux.ibm.com>
 <20201005124039.sf6mbytv5da3hxed@kamzik.brq.redhat.com>
 <20201005175613.1215b61e@ibm-vm>
 <20201005165311.w37u3b2fpuqvf2ob@kamzik.brq.redhat.com>
 <20201005191817.608eb451@ibm-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005191817.608eb451@ibm-vm>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 05, 2020 at 07:18:17PM +0200, Claudio Imbrenda wrote:
> On Mon, 5 Oct 2020 18:53:11 +0200
> Andrew Jones <drjones@redhat.com> wrote:
> > That won't work for 32-bit processors that support physical addresses
> > that are larger than 32-bits - if the target has more than 4G and the
> > unit test wants to access that high memory. Using phys_addr_t
> > everywhere you want a physical address avoids that problem.
> 
> no it doesn't. you can't even handle the freelist if it's in high
> memory. consider that the current allocator also does not handle high
> memory. and there is no infrastructure to shortly map high memory.
> 
> if a 32 bit test wants to access high memory, it will have to manage it
> manually

But the point of this series is to rewrite the allocator in order to
add features such as allocations from different memory zones, like
high memory, and also to fix its shortcomings. It seems like we should
start by fixing the current allocator's lack of concern for physical
and virtual address distinctions.

> > Using a list member for list operations and container_of() to get
> > back to the object would help readability.
> 
> except that the "object" is the block of free memory, and the only
> thing inside it is the list object at the very beginning. I think it's
> overkill to use container_of in that case, since the only thing is the
> list itself, and it's at the beginning of the free block.

Fair enough, but I'm also thinking it might be overkill to introduce
a general list API at all if all we need to do is insert and delete
blocks, and ones where we're aware of where the pointers are.

> so what I gather at the end is that I have to write a physical memory
> allocator for a complex OS that has to seamlessly access high memory.

We definitely don't want complexity. Trade-offs for simplicity are
good, but they should be implemented in a way that assert when
assumptions fail. If we want to limit memory access to 4G for 32-bit
architectures, then we should add some code to clamp upper physical
addresses and some asserts for unit tests that try to use them. If
the allocator wants to depend on the identity map to simplify its
implementation, then that's probably OK too, but I'd still keep
the interfaces clean: physical addresses should be phys_addr_t,
virtual addresses that should be the identity mapping of physical
addresses should be checked, e.g. assert(virt_to_phys(vaddr) == vaddr)

> 
> I'll try to come up with something
> 

Thanks,
drew

