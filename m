Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A36D2B545
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 14:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfE0Mbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 08:31:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57964 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbfE0Mbh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 08:31:37 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F0A223079B92
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 12:31:36 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 00A6879810;
        Mon, 27 May 2019 12:31:35 +0000 (UTC)
Date:   Mon, 27 May 2019 14:31:33 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com
Subject: Re: [PATCH 1/4] kvm: selftests: rename vm_vcpu_add to
 vm_vcpu_add_memslots
Message-ID: <20190527123133.tzdwrhw7bk7zm42l@kamzik.brq.redhat.com>
References: <20190523125756.4645-1-drjones@redhat.com>
 <20190523125756.4645-2-drjones@redhat.com>
 <eb7473ef-3d78-5858-577c-62abcd15d967@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb7473ef-3d78-5858-577c-62abcd15d967@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Mon, 27 May 2019 12:31:37 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 27, 2019 at 09:27:56AM +0200, Thomas Huth wrote:
> On 23/05/2019 14.57, Andrew Jones wrote:
> > This frees up the name vm_vcpu_add for another use.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  tools/testing/selftests/kvm/include/kvm_util.h       |  4 ++--
> >  tools/testing/selftests/kvm/lib/aarch64/processor.c  |  2 +-
> >  tools/testing/selftests/kvm/lib/kvm_util.c           | 12 +++++++-----
> >  tools/testing/selftests/kvm/lib/x86_64/processor.c   |  2 +-
> >  tools/testing/selftests/kvm/x86_64/evmcs_test.c      |  2 +-
> >  .../selftests/kvm/x86_64/kvm_create_max_vcpus.c      |  2 +-
> >  tools/testing/selftests/kvm/x86_64/smm_test.c        |  2 +-
> >  tools/testing/selftests/kvm/x86_64/state_test.c      |  2 +-
> >  8 files changed, 15 insertions(+), 13 deletions(-)
> [...]
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index e9113857f44e..937292dca81b 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -756,21 +756,23 @@ static int vcpu_mmap_sz(void)
> >  }
> >  
> >  /*
> > - * VM VCPU Add
> > + * VM VCPU Add with provided memslots
> >   *
> >   * Input Args:
> >   *   vm - Virtual Machine
> >   *   vcpuid - VCPU ID
> > + *   pgd_memslot - Memory region slot for new virtual translation tables
> > + *   gdt_memslot - Memory region slot for data pages
> >   *
> >   * Output Args: None
> >   *
> >   * Return: None
> >   *
> > - * Creates and adds to the VM specified by vm and virtual CPU with
> > - * the ID given by vcpuid.
> > + * Adds a virtual CPU to the VM specified by vm with the ID given by vcpuid
> > + * and then sets it up with vcpu_setup() and the provided memslots.
> >   */
> > -void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot,
> > -		 int gdt_memslot)
> > +void vm_vcpu_add_memslots(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot,
> > +			  int gdt_memslot)
> 
> I think the naming and description of the function is somewhat
> unfortunate now. The function is not really about memslots, but about
> setting up some MMU tables in the memory (and for this you need a
> memslot). So maybe rather name it vm_vcpu_add_with_mmu() or something
> similar? Also it would be nice to give the reason for the memslots in
> the comment before the function.
>

Peter Xu suggested almost the same name, so I'll do that for a v2.
I'll add a couple more words to the comment too.

Thanks,
drew 
