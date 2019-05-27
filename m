Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 353702AF37
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 09:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfE0HKG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 03:10:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57452 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfE0HKG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 03:10:06 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 530D480F6D
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 07:10:06 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EB7236A25F;
        Mon, 27 May 2019 07:09:59 +0000 (UTC)
Date:   Mon, 27 May 2019 09:09:57 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        thuth@redhat.com
Subject: Re: [PATCH 2/4] kvm: selftests: introduce vm_vcpu_add
Message-ID: <20190527070957.56zbt52a3v2ktgph@kamzik.brq.redhat.com>
References: <20190523125756.4645-1-drjones@redhat.com>
 <20190523125756.4645-3-drjones@redhat.com>
 <20190527063552.GH2517@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190527063552.GH2517@xz-x1>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Mon, 27 May 2019 07:10:06 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 27, 2019 at 02:35:52PM +0800, Peter Xu wrote:
> On Thu, May 23, 2019 at 02:57:54PM +0200, Andrew Jones wrote:
> > vm_vcpu_add() just adds a vcpu to the vm, but doesn't do any
> > additional vcpu setup.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  .../testing/selftests/kvm/include/kvm_util.h  |  1 +
> >  tools/testing/selftests/kvm/lib/kvm_util.c    | 32 +++++++++++++++----
> >  2 files changed, 26 insertions(+), 7 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index 4e92f34cf46a..32fabbc98803 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -88,6 +88,7 @@ int _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
> >  		void *arg);
> >  void vm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
> >  void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
> > +void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
> >  void vm_vcpu_add_memslots(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot,
> >  			  int gdt_memslot);
> >  vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 937292dca81b..ae6d4b274ddd 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -756,23 +756,20 @@ static int vcpu_mmap_sz(void)
> >  }
> >  
> >  /*
> > - * VM VCPU Add with provided memslots
> > + * VM VCPU Add
> >   *
> >   * Input Args:
> >   *   vm - Virtual Machine
> >   *   vcpuid - VCPU ID
> > - *   pgd_memslot - Memory region slot for new virtual translation tables
> > - *   gdt_memslot - Memory region slot for data pages
> 
> Would it make sense to squash the first two patches together?  They
> are somehow related, and also no lines will be added and quickly removed.

I had them separated for easier review. If Paolo wants to squash on merge,
I've got no problem with that.

> 
> Nitpicking on the name: vm_vcpu_add_memslots() makes me feel like
> "vcpu is adding memslots" rather than adding vcpu itself.  How about
> vm_vcpu_add_with_memslots()?

I can do that, although it's getting pretty verbose. Anybody else want
to vote on the name?

Thanks,
drew
