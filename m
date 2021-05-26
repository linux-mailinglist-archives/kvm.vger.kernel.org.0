Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A312C391E08
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 19:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbhEZRZG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 13:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbhEZRYk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 13:24:40 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5404C06138C
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 10:23:08 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id z24so1835948ioi.3
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 10:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xXqdvXVIi2BTMQVuMR+ERicAWv//Z2jtTIRswIPhlJw=;
        b=iPH7/QUqg68fUwmfweOJTajKopapSuUJfYXJNUijF69hNFm+WlgN18exJoYiY5B0mS
         mmnvAUZDFfvLLZZ3dENcidj3nRm3xsuoSuS/EPm1rg5pKwVEtAlHRtW4t1P30AjYUpKM
         IKTKlFifjr+pJh1dTCOP5d1Txp8H5N1alicmb5e3rAfl25+pL8I8hYC54DXklUcJxZO+
         huTUEDxWacMx7+PebG9S/8UzwOVKajzbocyvb9t0tY6BirXG9+4s5H9eXzfvarrCK7bB
         yBzTSYH9Rh4s1KuFYLCjx3R+qTbJS5t4J/LWHJPFdHHc7KaZGZvhBxn0nJ0x0au73u94
         kMIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xXqdvXVIi2BTMQVuMR+ERicAWv//Z2jtTIRswIPhlJw=;
        b=oxKFDCluZxBsb4hr7JVaGpebuf8iCdxAth9Sb3JmLUS+25u/21QRqm+vnsdnRIlnL1
         CuYqFAAUnhogYoO3awpFgo+NxbaUUCf17atxjcovtK1qzWzwqwv3f9fvPHyN/S6Bo4C/
         z9KC+GItWcfWvBiSaD7tBoY3sGm3TdTe0+HXpcLwtNjRn6AQl06k/NTiJrCUVn78qMXz
         fuyPn9ZjPKiUAi0N9fYoIkQDqNDg5uepkcQC0xCiaI/7kYtv/4hDFHBOVyyYl7dXVxSC
         1TVdgws/hXWdgfUX49ZYtRR9AnzFAVROu84ksNgMqSO+qFHRRVYXtyCcJlmaIKttZtLV
         fq8g==
X-Gm-Message-State: AOAM530Uc4s2hLWQCeYeIMJmebFXP2l0NZR7H494uwdebc/QG1UtjYFd
        vKUJsI6IbDUKmaHEgD3eOrE27wUd19YW38CbYeVAFw==
X-Google-Smtp-Source: ABdhPJxaM0WqpetiyIHXAqAdGubPPZineHyZfo4UwsQQru0bHgfLF4fEQaD15VcN35CYzCMHDsqz/3kK7ndS2K8Cxz0=
X-Received: by 2002:a6b:3b92:: with SMTP id i140mr25430682ioa.23.1622049787744;
 Wed, 26 May 2021 10:23:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210519200339.829146-1-axelrasmussen@google.com>
 <20210519200339.829146-9-axelrasmussen@google.com> <CALzav=eGi2_TBx=LDYpg6hRi8JabGPsHLC8M5-Vzf8DJHomSVQ@mail.gmail.com>
In-Reply-To: <CALzav=eGi2_TBx=LDYpg6hRi8JabGPsHLC8M5-Vzf8DJHomSVQ@mail.gmail.com>
From:   Axel Rasmussen <axelrasmussen@google.com>
Date:   Wed, 26 May 2021 10:22:32 -0700
Message-ID: <CAJHvVcjFJT8E35nhiNCLzT=f3DsPaWu1RjJNQqPWK9zspoBnSw@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] KVM: selftests: create alias mappings when using
 shared memory
To:     David Matlack <dmatlack@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Alexander Graf <graf@amazon.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Gardon <bgardon@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jacob Xu <jacobhxu@google.com>,
        Makarand Sonare <makarandsonare@google.com>,
        Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I applied this change on top of kvm/master and tested it, and indeed
it compiles and works correctly.

Paolo, feel free to take this with a:

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>

Or alternatively if you prefer I'm happy to send it as a real
git-send-email patch.

On Tue, May 25, 2021 at 4:50 PM David Matlack <dmatlack@google.com> wrote:
>
> On Wed, May 19, 2021 at 1:04 PM Axel Rasmussen <axelrasmussen@google.com> wrote:
> >
> > When a memory region is added with a src_type specifying that it should
> > use some kind of shared memory, also create an alias mapping to the same
> > underlying physical pages.
> >
> > And, add an API so tests can get access to these alias addresses.
> > Basically, for a guest physical address, let us look up the analogous
> > host *alias* address.
> >
> > In a future commit, we'll modify the demand paging test to take
> > advantage of this to exercise UFFD minor faults. The idea is, we
> > pre-fault the underlying pages *via the alias*. When the *guest*
> > faults, it gets a "minor" fault (PTEs don't exist yet, but a page is
> > already in the page cache). Then, the userfaultfd theads can handle the
> > fault: they could potentially modify the underlying memory *via the
> > alias* if they wanted to, and then they install the PTEs and let the
> > guest carry on via a UFFDIO_CONTINUE ioctl.
> >
> > Reviewed-by: Ben Gardon <bgardon@google.com>
> > Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
> > ---
> >  .../testing/selftests/kvm/include/kvm_util.h  |  1 +
> >  tools/testing/selftests/kvm/lib/kvm_util.c    | 51 +++++++++++++++++++
> >  .../selftests/kvm/lib/kvm_util_internal.h     |  2 +
> >  3 files changed, 54 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index a8f022794ce3..0624f25a6803 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -146,6 +146,7 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
> >  void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa);
> >  void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
> >  vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
> > +void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
> >
> >  /*
> >   * Address Guest Virtual to Guest Physical
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index e4a8d0c43c5e..0b88d1bbc1e0 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -811,6 +811,19 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
> >
> >         /* Add to linked-list of memory regions. */
> >         list_add(&region->list, &vm->userspace_mem_regions);
> > +
> > +       /* If shared memory, create an alias. */
> > +       if (region->fd >= 0) {
> > +               region->mmap_alias = mmap(NULL, region->mmap_size,
> > +                                         PROT_READ | PROT_WRITE,
> > +                                         vm_mem_backing_src_alias(src_type)->flag,
> > +                                         region->fd, 0);
> > +               TEST_ASSERT(region->mmap_alias != MAP_FAILED,
> > +                           "mmap of alias failed, errno: %i", errno);
> > +
> > +               /* Align host alias address */
> > +               region->host_alias = align(region->mmap_alias, alignment);
> > +       }
> >  }
> >
> >  /*
> > @@ -1239,6 +1252,44 @@ vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva)
> >         return -1;
> >  }
> >
> > +/*
> > + * Address VM physical to Host Virtual *alias*.
> > + *
> > + * Input Args:
> > + *   vm - Virtual Machine
> > + *   gpa - VM physical address
> > + *
> > + * Output Args: None
> > + *
> > + * Return:
> > + *   Equivalent address within the host virtual *alias* area, or NULL
> > + *   (without failing the test) if the guest memory is not shared (so
> > + *   no alias exists).
> > + *
> > + * When vm_create() and related functions are called with a shared memory
> > + * src_type, we also create a writable, shared alias mapping of the
> > + * underlying guest memory. This allows the host to manipulate guest memory
> > + * without mapping that memory in the guest's address space. And, for
> > + * userfaultfd-based demand paging, we can do so without triggering userfaults.
> > + */
> > +void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa)
> > +{
> > +       struct userspace_mem_region *region;
> > +
> > +       list_for_each_entry(region, &vm->userspace_mem_regions, list) {
>
> This patch fails to compile on top of with db0670ce3361 ("KVM:
> selftests: Keep track of memslots more efficiently").
>
> This can be reproduced by checking out kvm/master and running `make -C
> tools/testing/selftests/kvm`.
>
> The following diff fixes the compilation error but I did not have time
> to test it yet:
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c
> b/tools/testing/selftests/kvm/lib/kvm_util.c
> index c98db1846e1b..28e528c19d28 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1374,19 +1374,17 @@ vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva)
>  void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa)
>  {
>         struct userspace_mem_region *region;
> +       uintptr_t offset;
>
> -       list_for_each_entry(region, &vm->userspace_mem_regions, list) {
> -               if (!region->host_alias)
> -                       continue;
> +       region = userspace_mem_region_find(vm, gpa, gpa);
> +       if (!region)
> +               return NULL;
>
> -               if ((gpa >= region->region.guest_phys_addr)
> -                       && (gpa <= (region->region.guest_phys_addr
> -                               + region->region.memory_size - 1)))
> -                       return (void *) ((uintptr_t) region->host_alias
> -                               + (gpa - region->region.guest_phys_addr));
> -       }
> +       if (!region->host_alias)
> +               return NULL;
>
> -       return NULL;
> +       offset = gpa - region->region.guest_phys_addr;
> +       return (void *) ((uintptr_t) region->host_alias + offset);
>  }
>
>  /*
>
>
>
> > +               if (!region->host_alias)
> > +                       continue;
> > +
> > +               if ((gpa >= region->region.guest_phys_addr)
> > +                       && (gpa <= (region->region.guest_phys_addr
> > +                               + region->region.memory_size - 1)))
> > +                       return (void *) ((uintptr_t) region->host_alias
> > +                               + (gpa - region->region.guest_phys_addr));
> > +       }
> > +
> > +       return NULL;
> > +}
> > +
> >  /*
> >   * VM Create IRQ Chip
> >   *
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
> > index 91ce1b5d480b..a25af33d4a9c 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
> > @@ -16,7 +16,9 @@ struct userspace_mem_region {
> >         int fd;
> >         off_t offset;
> >         void *host_mem;
> > +       void *host_alias;
> >         void *mmap_start;
> > +       void *mmap_alias;
> >         size_t mmap_size;
> >         struct list_head list;
> >  };
> > --
> > 2.31.1.751.gd2f1c929bd-goog
> >
