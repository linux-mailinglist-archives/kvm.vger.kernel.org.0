Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5DA1810A8
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 07:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgCKG1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 02:27:08 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54607 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725976AbgCKG1I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Mar 2020 02:27:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583908026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lmEKgXks/zEjgN+sn5kNszdNlcPSZgDCHuaFZ0ie3as=;
        b=g2tlwZ4Bc9I/63k0RpuWejLRGmQyHsxSucOvWyaBlDWm8nngmeU5UttMhAAZBWWqdD5TDo
        +1p0eU/MA3o6yOS1oX1Yfml7B+dtkN/lmfpDXNkGkiFTodqrAUU69x0PXODIsBY2INQINM
        UH38dS4dck8AWmQLPFMlSJ8lOnSJbV4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-eRwKvcR4OeOKCCnwcrueow-1; Wed, 11 Mar 2020 02:27:02 -0400
X-MC-Unique: eRwKvcR4OeOKCCnwcrueow-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C6A6477;
        Wed, 11 Mar 2020 06:27:01 +0000 (UTC)
Received: from kamzik.brq.redhat.com (ovpn-204-108.brq.redhat.com [10.40.204.108])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7781E5C290;
        Wed, 11 Mar 2020 06:26:56 +0000 (UTC)
Date:   Wed, 11 Mar 2020 07:26:53 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Ben Gardon <bgardon@google.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: kvm/queue demand paging test and s390
Message-ID: <20200311062653.yczihmgrnfqyrwa3@kamzik.brq.redhat.com>
References: <c845637e-d662-993e-2184-fa34bae79495@de.ibm.com>
 <20200310172744.36lawcszzjbebz6d@kamzik.brq.redhat.com>
 <2d1fbe47-75fe-f57c-ab7a-65702e1ea23d@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d1fbe47-75fe-f57c-ab7a-65702e1ea23d@de.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 10, 2020 at 09:18:16PM +0100, Christian Borntraeger wrote:
> 
> 
> On 10.03.20 18:27, Andrew Jones wrote:
> > On Tue, Mar 10, 2020 at 05:54:59PM +0100, Christian Borntraeger wrote:
> >> For s390 the guest memory size must be 1M aligned. I need something like the following to make this work:
> >>
> >> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> >> index c1e326d3ed7f..f85ec3f01a35 100644
> >> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> >> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> >> @@ -164,6 +164,10 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, int vcpus,
> >>         pages += ((2 * vcpus * vcpu_memory_bytes) >> PAGE_SHIFT_4K) /
> >>                  PTES_PER_4K_PT;
> >>         pages = vm_adjust_num_guest_pages(mode, pages);
> >> +#ifdef __s390x__
> >> +       /* s390 requires 1M aligned guest sizes */
> >> +       pages = (pages + 255) & ~0xff;
> >> +#endif
> >>  
> >>         pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
> >>  
> >>
> >> any better idea how to do that?
> >>
> > 
> > For this one we could patch[*] vm_adjust_num_guest_pages(). That would
> > also allow the one on line 382, and another one at dirty_log_test.c:300
> > to be hidden.
> 
> I tried that first but then I ran into several other asserts that checked for
> num_pages = vm_adjust_num_guest_pages(num_pages)
> 
> See kvm_util.c:     TEST_ASSERT(vm_adjust_num_guest_pages(vm->mode, npages) == npages
> 
> So it seems like a bigger rework is necessary to avoid this little hack :-/

There's just this one other assert, and it'll only fire if the number of
guest pages aren't selectect correctly. One must just be sure they
always select the number correctly or do

 adjusted_num_pages = vm_adjust_num_guest_pages(mode, guessed_num_pages);
 vm_userspace_mem_region_add(..., adjusted_num_pages, ...);

to ensure it. If we patch vm_adjust_num_guest_pages() as suggested below
then the assert should never fire when the number is already correct,
because vm_adjust_num_guest_pages() doesn't change an already correct
number, i.e.

 adjusted_num_pages == vm_adjust_num_guest_pages(mode, adjusted_num_pages)

If an assert is firing after making that change, then I wonder if not
all s390 memregions are 1M aligned?

Thanks,
drew

> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index fc84da4b72d4..9569b21eed26 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -261,7 +261,13 @@ unsigned int vm_num_guest_pages(enum vm_guest_mode mode, unsigned int num_host_p
> >  static inline unsigned int
> >  vm_adjust_num_guest_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
> >  {
> > -       return vm_num_guest_pages(mode, vm_num_host_pages(mode, num_guest_pages));
> > +       unsigned int n;
> > +       n = vm_num_guest_pages(mode, vm_num_host_pages(mode, num_guest_pages));
> > +#ifdef __s390x__
> > +       /* s390 requires 1M aligned guest sizes */
> > +       n = (n + 255) & ~0xff;
> > +#endif
> > +       return n;
> >  }
> >  
> >  struct kvm_userspace_memory_region *
> > 
> 

