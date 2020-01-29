Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33A2E14C9EB
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 12:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgA2Lvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 06:51:32 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53321 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726067AbgA2Lvc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Jan 2020 06:51:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580298691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H6jaW2S+odlaQy0KIFqAU+bpuLsglbrvaxzUp7pUckY=;
        b=Q5xLQJL17rL0BnyBsSd0nn7/VNu3HN0gdlwLMp7wHfo2CS2N4yrvZtx18vUJ9u1t1DQ4GW
        ViEuPLTpf3lVsLYrA8XWkBr3Yjo7VdndBLy7mlodGtfph3Q6boaDqx2ufifYNpi5AVp7C+
        3R+l780tYYxcrvyKF4zFDJckWmtiAMA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-mn4g7pguNBicsBokMMELLw-1; Wed, 29 Jan 2020 06:51:27 -0500
X-MC-Unique: mn4g7pguNBicsBokMMELLw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AAC2C13E2;
        Wed, 29 Jan 2020 11:51:26 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ADAE45D9C5;
        Wed, 29 Jan 2020 11:51:25 +0000 (UTC)
Date:   Wed, 29 Jan 2020 12:51:23 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        thuth@redhat.com
Subject: Re: [PATCH v2] kvm: selftests: Introduce num-pages conversion
 utilities
Message-ID: <20200129115123.kswbeza33atbfk47@kamzik.brq.redhat.com>
References: <20200128093443.25414-1-drjones@redhat.com>
 <CANgfPd-xYX5Y=ajjP62z-jwKepeFaRVwSMQKq3N1oc1zO57mRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd-xYX5Y=ajjP62z-jwKepeFaRVwSMQKq3N1oc1zO57mRg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 28, 2020 at 09:37:21AM -0800, Ben Gardon wrote:
> On Tue, Jan 28, 2020 at 1:34 AM Andrew Jones <drjones@redhat.com> wrote:
> >
> > Guests and hosts don't have to have the same page size. This means
> > calculations are necessary when selecting the number of guest pages
> > to allocate in order to ensure the number is compatible with the
> > host. Provide utilities to help with those calculations.
> >
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> > ---
> >  tools/testing/selftests/kvm/dirty_log_test.c  | 10 ++++----
> >  .../testing/selftests/kvm/include/kvm_util.h  |  3 +++
> >  .../testing/selftests/kvm/include/test_util.h |  2 ++
> >  tools/testing/selftests/kvm/lib/kvm_util.c    | 24 +++++++++++++++++++
> >  4 files changed, 33 insertions(+), 6 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> > index 5614222a6628..2383c55a1a1a 100644
> > --- a/tools/testing/selftests/kvm/dirty_log_test.c
> > +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> > @@ -178,12 +178,11 @@ static void *vcpu_worker(void *data)
> >         return NULL;
> >  }
> >
> > -static void vm_dirty_log_verify(unsigned long *bmap)
> > +static void vm_dirty_log_verify(struct kvm_vm *vm, unsigned long *bmap)
> >  {
> > +       uint64_t step = vm_num_host_pages(vm, 1);
> >         uint64_t page;
> >         uint64_t *value_ptr;
> > -       uint64_t step = host_page_size >= guest_page_size ? 1 :
> > -                               guest_page_size / host_page_size;
> >
> >         for (page = 0; page < host_num_pages; page += step) {
> >                 value_ptr = host_test_mem + page * host_page_size;
> > @@ -295,8 +294,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
> >         guest_num_pages = (guest_num_pages + 0xff) & ~0xffUL;
> >  #endif
> >         host_page_size = getpagesize();
> > -       host_num_pages = (guest_num_pages * guest_page_size) / host_page_size +
> > -                        !!((guest_num_pages * guest_page_size) % host_page_size);
> > +       host_num_pages = vm_num_host_pages(vm, guest_num_pages);
> >
> >         if (!phys_offset) {
> >                 guest_test_phys_mem = (vm_get_max_gfn(vm) -
> > @@ -369,7 +367,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
> >                 kvm_vm_clear_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap, 0,
> >                                        host_num_pages);
> >  #endif
> > -               vm_dirty_log_verify(bmap);
> > +               vm_dirty_log_verify(vm, bmap);
> >                 iteration++;
> >                 sync_global_to_guest(vm, iteration);
> >         }
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index 29cccaf96baf..0d05ade3022c 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -158,6 +158,9 @@ unsigned int vm_get_page_size(struct kvm_vm *vm);
> >  unsigned int vm_get_page_shift(struct kvm_vm *vm);
> >  unsigned int vm_get_max_gfn(struct kvm_vm *vm);
> >
> > +unsigned int vm_num_host_pages(struct kvm_vm *vm, unsigned int num_guest_pages);
> > +unsigned int vm_num_guest_pages(struct kvm_vm *vm, unsigned int num_host_pages);
> > +
> >  struct kvm_userspace_memory_region *
> >  kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
> >                                  uint64_t end);
> > diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> > index a41db6fb7e24..25c27739e085 100644
> > --- a/tools/testing/selftests/kvm/include/test_util.h
> > +++ b/tools/testing/selftests/kvm/include/test_util.h
> > @@ -19,6 +19,8 @@
> >  #include <fcntl.h>
> >  #include "kselftest.h"
> >
> > +#define getpageshift() (__builtin_ffs(getpagesize()) - 1)
> > +
> >  ssize_t test_write(int fd, const void *buf, size_t count);
> >  ssize_t test_read(int fd, void *buf, size_t count);
> >  int test_seq_read(const char *path, char **bufp, size_t *sizep);
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 41cf45416060..d9bca2f1cc95 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -1667,3 +1667,27 @@ unsigned int vm_get_max_gfn(struct kvm_vm *vm)
> >  {
> >         return vm->max_gfn;
> >  }
> > +
> > +static unsigned int vm_calc_num_pages(unsigned int num_pages,
> > +                                     unsigned int page_shift,
> > +                                     unsigned int new_page_shift)
> > +{
> > +       unsigned int n = 1 << (new_page_shift - page_shift);
> > +
> > +       if (page_shift >= new_page_shift)
> > +               return num_pages * (1 << (page_shift - new_page_shift));
> > +
> > +       return num_pages / n + !!(num_pages % n);
> > +}
> > +
> > +unsigned int vm_num_host_pages(struct kvm_vm *vm, unsigned int num_guest_pages)
> > +{
> > +       return vm_calc_num_pages(num_guest_pages, vm_get_page_shift(vm),
> > +                                getpageshift());
> > +}
> > +
> > +unsigned int vm_num_guest_pages(struct kvm_vm *vm, unsigned int num_host_pages)
> > +{
> > +       return vm_calc_num_pages(num_host_pages, getpageshift(),
> > +                                vm_get_page_shift(vm));
> > +}
> 
> This function appears to be unused. I don't have any opposition to
> adding it since it is simple, unlikely to bitrot, and seems like a
> useful utility.
>

Yeah, I was thinking it might be useful for tests to calculate the
number of guest pages from a given memory size

  num_host_pages = DIV_ROUND_UP(memory_size, getpagesize());
  num_guest_pages = vm_num_guest_pages(vm, num_host_pages);

But now I see we need a v3 of this patch. When calculating the
number of guest pages from host pages we should round down, not
up. Also, I should have used DIV_ROUND_UP() which is defined in
tools/include/linux/kernel.h. I see it's even defined in
lib/kvm_util_internal.h too, but we can delete it from there
and just use linux/kernel.h. I'll do the deleting as a separate
cleanup patch though.

Thanks,
drew

