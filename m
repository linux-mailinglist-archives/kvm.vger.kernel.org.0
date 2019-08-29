Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E00A7A1658
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 12:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbfH2KhS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 06:37:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41662 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726839AbfH2KhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 06:37:18 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 169CBC0546F2;
        Thu, 29 Aug 2019 10:37:18 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B3E960C44;
        Thu, 29 Aug 2019 10:37:13 +0000 (UTC)
Date:   Thu, 29 Aug 2019 12:37:11 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v2 3/4] KVM: selftests: Introduce VM_MODE_PXXV48_4K
Message-ID: <20190829103711.uqj6rrcktnz2y3wi@kamzik.brq.redhat.com>
References: <20190829022117.10191-1-peterx@redhat.com>
 <20190829022117.10191-4-peterx@redhat.com>
 <20190829094516.fyfhgz7ma2nfazoq@kamzik.brq.redhat.com>
 <20190829100309.GJ8729@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829100309.GJ8729@xz-x1>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 29 Aug 2019 10:37:18 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 06:03:09PM +0800, Peter Xu wrote:
> On Thu, Aug 29, 2019 at 11:45:16AM +0200, Andrew Jones wrote:
> > On Thu, Aug 29, 2019 at 10:21:16AM +0800, Peter Xu wrote:
> > > The naming VM_MODE_P52V48_4K is explicit but unclear when used on
> > > x86_64 machines, because x86_64 machines are having various physical
> > > address width rather than some static values.  Here's some examples:
> > > 
> > >   - Intel Xeon E3-1220:  36 bits
> > >   - Intel Core i7-8650:  39 bits
> > >   - AMD   EPYC 7251:     48 bits
> > > 
> > > All of them are using 48 bits linear address width but with totally
> > > different physical address width (and most of the old machines should
> > > be less than 52 bits).
> > > 
> > > Let's create a new guest mode called VM_MODE_PXXV48_4K for current
> > > x86_64 tests and make it as the default to replace the old naming of
> > > VM_MODE_P52V48_4K because it shows more clearly that the PA width is
> > > not really a constant.  Meanwhile we also stop assuming all the x86
> > > machines are having 52 bits PA width but instead we fetch the real
> > > vm->pa_bits from CPUID 0x80000008 during runtime.
> > > 
> > > We currently make this exclusively used by x86_64 but no other arch.
> > > 
> > > As a slight touch up, moving DEBUG macro from dirty_log_test.c to
> > > kvm_util.h so lib can use it too.
> > > 
> > > Signed-off-by: Peter Xu <peterx@redhat.com>
> > > ---
> > >  tools/testing/selftests/kvm/dirty_log_test.c  |  5 ++--
> > >  .../testing/selftests/kvm/include/kvm_util.h  |  9 +++++-
> > >  .../selftests/kvm/include/x86_64/processor.h  |  3 ++
> > >  .../selftests/kvm/lib/aarch64/processor.c     |  3 ++
> > >  tools/testing/selftests/kvm/lib/kvm_util.c    | 29 ++++++++++++++----
> > >  .../selftests/kvm/lib/x86_64/processor.c      | 30 ++++++++++++++++---
> > >  6 files changed, 65 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> > > index efb7746a7e99..c86f83cb33e5 100644
> > > --- a/tools/testing/selftests/kvm/dirty_log_test.c
> > > +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> > > @@ -19,8 +19,6 @@
> > >  #include "kvm_util.h"
> > >  #include "processor.h"
> > >  
> > > -#define DEBUG printf
> > > -
> > >  #define VCPU_ID				1
> > >  
> > >  /* The memory slot index to track dirty pages */
> > > @@ -256,6 +254,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
> > >  
> > >  	switch (mode) {
> > >  	case VM_MODE_P52V48_4K:
> > > +	case VM_MODE_PXXV48_4K:
> > >  		guest_pa_bits = 52;
> > >  		guest_page_shift = 12;
> > >  		break;
> > > @@ -446,7 +445,7 @@ int main(int argc, char *argv[])
> > >  #endif
> > >  
> > >  #ifdef __x86_64__
> > > -	vm_guest_mode_params_init(VM_MODE_P52V48_4K, true, true);
> > > +	vm_guest_mode_params_init(VM_MODE_PXXV48_4K, true, true);
> > >  #endif
> > >  #ifdef __aarch64__
> > >  	vm_guest_mode_params_init(VM_MODE_P40V48_4K, true, true);
> > > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > > index c78faa2ff7f3..430edbacb9b2 100644
> > > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > > @@ -24,6 +24,10 @@ struct kvm_vm;
> > >  typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
> > >  typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
> > >  
> > > +#ifndef DEBUG
> > > +#define DEBUG printf
> > > +#endif
> > 
> > There's no way to turn this off without modifying code. I suggested
> > 
> > #ifndef NDEBUG
> > #define dprintf printf
> > #endif
> > 
> > which allows the dprintf(...) statements to be removed by compiling with
> > -DNDEBUG added to CFLAGS. And that would also disable all the asserts().
> > That's probably not all that useful, but then again, defining printf() as
> > DEBUG() isn't useful either if the intention is to always print.
> 
> Sorry I misread that...
> 
> Though, I'm afraid even if with above it won't compile with -DNDEBUG
> because the compiler could start to complain about undefined
> "dprintf", or even recognize the dprintf as the libc call, dprintf(3).
> 
> So instead, does below looks ok?
> 
> #ifdef NDEBUG
> #define DEBUG(...)
> #else
> #define DEBUG(...) printf(__VA_ARGS__);
> #endif

yeah, that's what I was looking for, but I wasn't thinking clearly when
I suggested just the name redefinition.

drew
