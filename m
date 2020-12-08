Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47FE2D2D34
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 15:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbgLHO1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 09:27:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30439 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729821AbgLHO1t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Dec 2020 09:27:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607437582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BoaVJ7D/WH3esexkBK+axOcygW6TYJVR+Q3CShuQcMI=;
        b=TA8ANBplqPsA0ADFYEtgksYfgn2JVHlnnY7Mi1zAerXjdmQabbLLKzFskx7Ym+F8cYRmTL
        LEtO/HrHDA0qJHGasgDF/m/lILV/80n30Vv4s0ZY1AGTvan8J68/1d+YyVspDDIBZSbAoX
        hEduhAkZ9owEKhrBIZQozL6vy76AykM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-uljrJWCNOr2xk1vvDlW85w-1; Tue, 08 Dec 2020 09:26:19 -0500
X-MC-Unique: uljrJWCNOr2xk1vvDlW85w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E6258049C0;
        Tue,  8 Dec 2020 14:26:18 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.169])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 11118100238C;
        Tue,  8 Dec 2020 14:26:12 +0000 (UTC)
Date:   Tue, 8 Dec 2020 15:26:10 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>, KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, cohuck@redhat.com,
        lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 4/7] lib/alloc_page: complete rewrite
 of the page allocator
Message-ID: <20201208142610.sp3ytst6jlelbzxy@kamzik.brq.redhat.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
 <20201002154420.292134-5-imbrenda@linux.ibm.com>
 <C812A718-DCD6-4485-BB5A-B24DE73A0FD3@gmail.com>
 <11863F45-D4E5-4192-9541-EC4D26AC3634@gmail.com>
 <20201208101510.4e3866dc@ibm-vm>
 <A32A8A40-5581-4A3D-9DC8-4591C3A034C7@gmail.com>
 <20201208110010.7d05bd3a@ibm-vm>
 <7D823148-A383-470A-9611-E77C2E442524@gmail.com>
 <20201208144139.1054d411@ibm-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201208144139.1054d411@ibm-vm>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 08, 2020 at 02:41:39PM +0100, Claudio Imbrenda wrote:
> On Tue, 8 Dec 2020 04:48:09 -0800
> Nadav Amit <nadav.amit@gmail.com> wrote:
> 
> [...]
> 
> > >> And other VM-entry failures, which are not easy to debug,
> > >> especially on bare-metal.  
> > > 
> > > so you are running the test on bare metal?
> > > 
> > > that is something I had not tested  
> > 
> > Base-metal / VMware.
> > 
> > >   
> > >> Note that the failing test is not new, and unfortunately these
> > >> kind of errors (wrong assumption that memory is zeroed) are not
> > >> rare, since KVM indeed zeroes the memory (unlike other hypervisors
> > >> and bare-metal).
> > >> 
> > >> The previous allocator had the behavior of zeroing the memory to  
> > > 
> > > I don't remember such behaviour, but I'll have a look  
> > 
> > See https://www.spinics.net/lists/kvm/msg186474.html
> 
> hmmm it seems I had completely missed it, oops
> 
> > >   
> > >> avoid such problems. I would argue that zeroing should be the
> > >> default behavior, and if someone wants to have the memory
> > >> “untouched” for a specific test (which one?) he should use an
> > >> alternative function for this matter.  
> > > 
> > > probably we need some commandline switches to change the behaviour
> > > of the allocator according to the specific needs of each testcase
> > > 
> > > 
> > > I'll see what I can do  
> > 
> > I do not think commandline switches are the right way. I think that
> > reproducibility requires the memory to always be on a given state
> 
> there are some bugs that are only exposed when the memory has never
> been touched. zeroing the memory on allocation guarantees that we will
> __never__ be able to detect those bugs.
> 
> > before the tests begin. There are latent bugs in kvm-unit-tests that
> 
> then maybe it's the case to fix those bugs? :)
> 
> > are not apparent when the memory is zeroed. I do not think anyone
> > wants to waste time on resolving these bugs.
> 
> I disagree. if a unit test has a bug, it should be fixed.
> 
> some tests apparently need the allocator to clear the memory, while
> other tests depend on the memory being untouched. this is clearly
> impossible to solve without some kind of switch
> 
> 
> I would like to know what the others think about this issue too
>

If the allocator supports memory being returned and then reallocated, then
the generic allocation API cannot guarantee that the memory is untouched
anyway. So, if a test requires untouched memory, it should use a specific
API. I think setup() should probably just set some physical memory regions
aside for that purpose, exposing them somehow to unit tests. The unit
tests can then do anything they want with them. The generic API might
as well continue zeroing memory by default.

I never got around to finishing my review of the memory areas. Maybe that
can be modified to support this "untouched" area simply by labeling an
area as such and by not accepting returned pages to that area.

Thanks,
drew

