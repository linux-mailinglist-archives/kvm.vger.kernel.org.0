Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD566162D25
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 18:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgBRRix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 12:38:53 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58838 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgBRRix (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 12:38:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582047531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VPeYzOAMQ8FgLqPaErZPy2hASxQ2B0sHV/N2+DDsmZE=;
        b=VJip2H9sc8+Y3Job7HOfFi6KNjlqo5q7SPtkC/miDv+wE5bwHBhtxorY/kgGhSORDzoYUh
        8Ho8rlUEP6+C3lZtGS9z5w/GBia312PpspEf/fotyYu/5z8uFV94kdo06ATekJyIdVIs7A
        I0XQoP8Gzky6NySPmQ1noEAqcr2Nsfs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-U6UJM6iTNXS2setSQXu83w-1; Tue, 18 Feb 2020 12:38:49 -0500
X-MC-Unique: U6UJM6iTNXS2setSQXu83w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21C8C800D54;
        Tue, 18 Feb 2020 17:38:48 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 381BC90089;
        Tue, 18 Feb 2020 17:38:44 +0000 (UTC)
Date:   Tue, 18 Feb 2020 18:38:41 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH 02/13] fixup! KVM: selftests: Add support for
 vcpu_args_set to aarch64 and s390x
Message-ID: <20200218173841.llr73vagnviejmuu@kamzik.brq.redhat.com>
References: <20200214145920.30792-1-drjones@redhat.com>
 <20200214145920.30792-3-drjones@redhat.com>
 <CANgfPd-zr3joOCAmW4a0MO7MjYTowYv5r4wxAMo7ddPhhumssw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd-zr3joOCAmW4a0MO7MjYTowYv5r4wxAMo7ddPhhumssw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 18, 2020 at 09:30:25AM -0800, Ben Gardon wrote:
> On Fri, Feb 14, 2020 at 6:59 AM Andrew Jones <drjones@redhat.com> wrote:
> >
> > [Fixed array index (num => i) and made some style changes.]
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  .../selftests/kvm/lib/aarch64/processor.c     | 24 ++++---------------
> >  1 file changed, 4 insertions(+), 20 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > index 839a76c96f01..f7dffccea12c 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > @@ -334,36 +334,20 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
> >         aarch64_vcpu_add_default(vm, vcpuid, NULL, guest_code);
> >  }
> >
> > -/* VM VCPU Args Set
> > - *
> > - * Input Args:
> > - *   vm - Virtual Machine
> > - *   vcpuid - VCPU ID
> > - *   num - number of arguments
> > - *   ... - arguments, each of type uint64_t
> > - *
> > - * Output Args: None
> > - *
> > - * Return: None
> > - *
> > - * Sets the first num function input arguments to the values
> > - * given as variable args.  Each of the variable args is expected to
> > - * be of type uint64_t. The registers set by this function are r0-r7.
> > - */
> I'm sad to see this comment go. I realize it might be more verbose
> than necessary, but calling out that the args will all be interpreted
> as uint_64s and which registers are set feels like useful context to
> have here.

For me the code makes that super obvious, and I prefer not to describe what
code does. Also, I'd put these type of comment blocks, written more
generally, in the header files if they're functions that are implemented
by all architectures, rather than duplicating them in each source file.

> 
> >  void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
> >  {
> >         va_list ap;
> >         int i;
> >
> >         TEST_ASSERT(num >= 1 && num <= 8, "Unsupported number of args,\n"
> > -                   "  num: %u\n",
> > -                   num);
> > +                   "  num: %u\n", num);
> >
> >         va_start(ap, num);
> >
> > -       for (i = 0; i < num; i++)
> > -               set_reg(vm, vcpuid, ARM64_CORE_REG(regs.regs[num]),
> > +       for (i = 0; i < num; i++) {
> > +               set_reg(vm, vcpuid, ARM64_CORE_REG(regs.regs[i]),
> >                         va_arg(ap, uint64_t));
> > +       }
> Woops, I should have caught this in the original demand paging test
> series, but didn't notice because this function was only ever called
> with one argument.
> Thank you for fixing this.
> 
> >
> >         va_end(ap);
> >  }
> > --
> > 2.21.1
> >
>

Thanks,
drew 

