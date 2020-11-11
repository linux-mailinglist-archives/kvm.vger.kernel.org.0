Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF122AEBD9
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 09:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgKKI3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 03:29:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60148 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725909AbgKKI3o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Nov 2020 03:29:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605083382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ug+ymKx1iu9O5AXJpMIA/PxQuQYJ7df0/nAmcrPdt04=;
        b=hniaS6wjrZHe8TOdYQ+xXDk0QfdB+4NXuC5DRdZTuTF2zVZSyqwWCbYlD2q0WJpXErhoPu
        5uKU6vjm6sEXR7JrBEt4c/jpbU2vSKv0Khh551GDWeeETvSW4LJZ4E/H2oK0dheaErgqcp
        akUKuVhbn7TW7FexChKicdwPkpW9xPo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-6MNWee9qMK2WflbBVs3ebw-1; Wed, 11 Nov 2020 03:29:39 -0500
X-MC-Unique: 6MNWee9qMK2WflbBVs3ebw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF8A5E06A1;
        Wed, 11 Nov 2020 08:29:37 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.216])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E32B56E70C;
        Wed, 11 Nov 2020 08:29:35 +0000 (UTC)
Date:   Wed, 11 Nov 2020 09:29:32 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH 5/8] KVM: selftests: Introduce
 vm_create_[default_]_with_vcpus
Message-ID: <20201111082932.g5ndrmeatb7x7sjc@kamzik.brq.redhat.com>
References: <20201110204802.417521-1-drjones@redhat.com>
 <20201110204802.417521-6-drjones@redhat.com>
 <CANgfPd8M0eBMGSu7di_OKx-VK16DgLd4iKA=syU8cdL9JntxbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd8M0eBMGSu7di_OKx-VK16DgLd4iKA=syU8cdL9JntxbQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 10, 2020 at 02:13:14PM -0800, Ben Gardon wrote:
> On Tue, Nov 10, 2020 at 12:48 PM Andrew Jones <drjones@redhat.com> wrote:
> >
> > Introduce new vm_create variants that also takes a number of vcpus,
> > an amount of per-vcpu pages, and optionally a list of vcpuids. These
> > variants will create default VMs with enough additional pages to
> > cover the vcpu stacks, per-vcpu pages, and pagetable pages for all.
> > The new 'default' variant uses VM_MODE_DEFAULT, whereas the other
> > new variant accepts the mode as a parameter.
> >
> > Reviewed-by: Peter Xu <peterx@redhat.com>
> > Reviewed-by: Ben Gardon <bgardon@google.com>
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  .../testing/selftests/kvm/include/kvm_util.h  | 10 ++++++
> >  tools/testing/selftests/kvm/lib/kvm_util.c    | 35 ++++++++++++++++---
> >  2 files changed, 40 insertions(+), 5 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index 48b48a0014e2..bc8db80309f5 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -261,6 +261,16 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
> >  struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
> >                                  void *guest_code);
> >
> > +/* Same as vm_create_default, but can be used for more than one vcpu */
> > +struct kvm_vm *vm_create_default_with_vcpus(uint32_t nr_vcpus, uint64_t extra_mem_pages,
> > +                                           uint32_t num_percpu_pages, void *guest_code,
> > +                                           uint32_t vcpuids[]);
> > +
> > +/* Like vm_create_default_with_vcpus, but accepts mode as a parameter */
> > +struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
> > +                                   uint64_t extra_mem_pages, uint32_t num_percpu_pages,
> > +                                   void *guest_code, uint32_t vcpuids[]);
> > +
> >  /*
> >   * Adds a vCPU with reasonable defaults (e.g. a stack)
> >   *
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index a7e28e33fc3b..b31a4e988a5d 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -272,8 +272,9 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
> >         return vm;
> >  }
> >
> > -struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
> > -                                void *guest_code)
> > +struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
> > +                                   uint64_t extra_mem_pages, uint32_t num_percpu_pages,
> > +                                   void *guest_code, uint32_t vcpuids[])
> >  {
> >         /* The maximum page table size for a memory region will be when the
> >          * smallest pages are used. Considering each page contains x page
> > @@ -281,10 +282,18 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
> >          * N pages) will be: N/x+N/x^2+N/x^3+... which is definitely smaller
> >          * than N/x*2.
> >          */
> > -       uint64_t extra_pg_pages = (extra_mem_pages / PTES_PER_MIN_PAGE) * 2;
> > +       uint64_t vcpu_pages = (DEFAULT_STACK_PGS + num_percpu_pages) * nr_vcpus;
> > +       uint64_t extra_pg_pages = (extra_mem_pages + vcpu_pages) / PTES_PER_MIN_PAGE * 2;
> > +       uint64_t pages = DEFAULT_GUEST_PHY_PAGES + vcpu_pages + extra_pg_pages;
> >         struct kvm_vm *vm;
> > +       int i;
> > +
> > +       TEST_ASSERT(nr_vcpus <= kvm_check_cap(KVM_CAP_MAX_VCPUS),
> > +                   "nr_vcpus = %d too large for host, max-vcpus = %d",
> > +                   nr_vcpus, kvm_check_cap(KVM_CAP_MAX_VCPUS));
> >
> > -       vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
> > +       pages = vm_adjust_num_guest_pages(mode, pages);
> > +       vm = vm_create(mode, pages, O_RDWR);
> 
> I think this will substantially change the behavior of this function
> to create a much larger memslot 0. In the existing code, the memslot
> created in vm_create is just sized large enough for the stacks and
> page tables. Another memslot is then created for the memory under
> test.
> 
> I think separating the memslots is a good arrangement because it
> limits the extent to which kernel bugs could screw up the test and
> makes it easier to debug if you're testing something like dirty
> logging. It's also useful if you wanted to back the memslot under test
> with a different kind of memory from memslot 0. e.g. memslot 0 could
> use anonymous pages and the slot(s) under test could use hugetlbfs.
> You might also want multiple memslots to assign them to different NUMA
> nodes.
> 
> Is that change intentional? I would suggest not adding vcpu_pages to
> the calculation for pages above, similar to what it was before:
> uint64_t pages = DEFAULT_GUEST_PHY_PAGES + extra_pg_pages;

It was definitely intentional to create API that allows us to allocate
per-vcpu pages for the VM created with vcpus. But, to do what you want,
we just need to change the

 vm = vm_create_with_vcpus(mode, vcpus, 0,
                           vcpu_memory_bytes / perf_test_args.guest_page_size,
                           guest_code, NULL);

line in perf_test_util.h in the "KVM: selftests: Use vm_create_with_vcpus
in create_vm" patch to


 vm = vm_create_with_vcpus(mode, vcpus,
                           (vcpus * vcpu_memory_bytes) / perf_test_args.guest_page_size,
                           0, guest_code, NULL);


Notice how that moves the per-vcpu pages to the extra_mem_pages, which
only get used to calculate page table pages.

I'll do that in v2.

Thanks,
drew

