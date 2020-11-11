Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869A92AEAE3
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 09:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgKKIOB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 03:14:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54632 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725468AbgKKIOB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Nov 2020 03:14:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605082439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LzK6Oa36pghbJL5DhFZexJO0QTduyN8lshLo+XstoJ8=;
        b=f4eGzcHHXrY1i42iRtbQZpi24O1bsyM2RyWIzOC63CnlHIGR/tLeXCgDOcSpE0G/4wPBkP
        Q5pDTeJ9fAXArlJnkfRS+ctQbOrhEsbz3Y4o2iCtIzyNCs4KvNxd5wUkHxss/bDKLlsTsQ
        6qGWSe3/IP1/Kir/OPnU1wRjKqJ+/50=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-G9hSKE84MdyoDM-bFStx4g-1; Wed, 11 Nov 2020 03:13:57 -0500
X-MC-Unique: G9hSKE84MdyoDM-bFStx4g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C6FC10A0B80;
        Wed, 11 Nov 2020 08:13:56 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.216])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D548068431;
        Wed, 11 Nov 2020 08:13:51 +0000 (UTC)
Date:   Wed, 11 Nov 2020 09:13:48 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH 3/8] KVM: selftests: Factor out guest mode code
Message-ID: <20201111081348.ldzviawj3myzlc5d@kamzik.brq.redhat.com>
References: <20201110204802.417521-1-drjones@redhat.com>
 <20201110204802.417521-4-drjones@redhat.com>
 <CANgfPd-n6bvTedc++Pmq0uS0erqRVJGzWjzVECbHjJw2e-5e2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd-n6bvTedc++Pmq0uS0erqRVJGzWjzVECbHjJw2e-5e2A@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 10, 2020 at 01:52:56PM -0800, Ben Gardon wrote:
> On Tue, Nov 10, 2020 at 12:48 PM Andrew Jones <drjones@redhat.com> wrote:
> >
> > demand_paging_test, dirty_log_test, and dirty_log_perf_test have
> > redundant guest mode code. Factor it out.
> >
> > Also, while adding a new include, remove the ones we don't need.
> >
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |   2 +-
> >  .../selftests/kvm/demand_paging_test.c        | 107 ++++-----------
> >  .../selftests/kvm/dirty_log_perf_test.c       | 119 +++++------------
> >  tools/testing/selftests/kvm/dirty_log_test.c  | 125 ++++++------------
> >  .../selftests/kvm/include/guest_modes.h       |  21 +++
> >  tools/testing/selftests/kvm/lib/guest_modes.c |  70 ++++++++++
> >  6 files changed, 188 insertions(+), 256 deletions(-)
> >  create mode 100644 tools/testing/selftests/kvm/include/guest_modes.h
> >  create mode 100644 tools/testing/selftests/kvm/lib/guest_modes.c
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index 3d14ef77755e..ca6b64d9ab64 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -33,7 +33,7 @@ ifeq ($(ARCH),s390)
> >         UNAME_M := s390x
> >  endif
> >
> > -LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/sparsebit.c lib/test_util.c
> > +LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c
> >  LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
> >  LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c
> >  LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c
> > diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> > index 3d96a7bfaff3..946161a9ce2d 100644
> > --- a/tools/testing/selftests/kvm/demand_paging_test.c
> > +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> > @@ -7,23 +7,20 @@
> >   * Copyright (C) 2019, Google, Inc.
> >   */
> >
> > -#define _GNU_SOURCE /* for program_invocation_name */
> > +#define _GNU_SOURCE /* for program_invocation_name and pipe2 */
> 
> What is the purpose of pipe2 in this patch / why add it to this
> comment but not the comments in the other files modified here?

Only this file uses pipe2. If we do a later cleanup removing the
program_invocation_name usage from this file, then I want to point out
that we need to keep _GNU_SOURCE defined for pipe2. Actually, the only
reason we still need program_invocation_name at this point in the
series is because program_invocation_name is used in perf_test_util.h
in a function we include in this file. I should have removed
program_invocation_name from the comment with the "KVM: selftests: Use
vm_create_with_vcpus in create_vm" patch, but I forgot.

Thanks,
drew

