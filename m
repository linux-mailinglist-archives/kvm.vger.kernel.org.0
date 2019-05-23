Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF7827E9B
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 15:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730829AbfEWNrW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 09:47:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55060 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729698AbfEWNrW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 09:47:22 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5068C317916C
        for <kvm@vger.kernel.org>; Thu, 23 May 2019 13:47:21 +0000 (UTC)
Received: from xz-x1 (ovpn-12-16.pek2.redhat.com [10.72.12.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8577E7BE78;
        Thu, 23 May 2019 13:47:18 +0000 (UTC)
Date:   Thu, 23 May 2019 21:47:09 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com
Subject: Re: [PATCH] kvm: selftests: aarch64: dirty_log_test: fix unaligned
 memslot size
Message-ID: <20190523134709.GC2517@xz-x1>
References: <20190523093405.17887-1-drjones@redhat.com>
 <20190523094859.GB2517@xz-x1>
 <20190523100527.cp5ij43scb3m2hel@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190523100527.cp5ij43scb3m2hel@kamzik.brq.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 23 May 2019 13:47:21 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 23, 2019 at 12:05:27PM +0200, Andrew Jones wrote:
> On Thu, May 23, 2019 at 05:48:59PM +0800, Peter Xu wrote:
> > On Thu, May 23, 2019 at 11:34:05AM +0200, Andrew Jones wrote:
> > > The memory slot size must be aligned to the host's page size. When
> > > testing a guest with a 4k page size on a host with a 64k page size,
> > > then 3 guest pages are not host page size aligned. Since we just need
> > > a nearly arbitrary number of extra pages to ensure the memslot is not
> > > aligned to a 64 host-page boundary for this test, then we can use
> > > 16, as that's 64k aligned, but not 64 * 64k aligned.
> > > 
> > > Fixes: 76d58e0f07ec ("KVM: fix KVM_CLEAR_DIRTY_LOG for memory slots of unaligned size", 2019-04-17)
> > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > 
> > > ---
> > > Note, the commit "KVM: fix KVM_CLEAR_DIRTY_LOG for memory slots of
> > > unaligned size" was somehow committed twice. 76d58e0f07ec is the
> > > first instance.
> > > 
> > >  tools/testing/selftests/kvm/dirty_log_test.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> > > index f50a15c38f9b..bf85afbf1b5f 100644
> > > --- a/tools/testing/selftests/kvm/dirty_log_test.c
> > > +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> > > @@ -292,7 +292,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
> > >  	 * A little more than 1G of guest page sized pages.  Cover the
> > >  	 * case where the size is not aligned to 64 pages.
> > >  	 */
> > > -	guest_num_pages = (1ul << (30 - guest_page_shift)) + 3;
> > > +	guest_num_pages = (1ul << (30 - guest_page_shift)) + 16;
> > 
> > Hi, Drew,
> > 
> > Could you help explain what's the error on ARM?  Since I still cannot
> > understand how it failed from the first glance...
> 
> The KVM_SET_USER_MEMORY_REGION ioctl will fail because of
> 
>     if (mem->memory_size & (PAGE_SIZE - 1))
>             goto out;
> 
> in __kvm_set_memory_region(). And that's because PAGE_SIZE == 64k
> on the host (kvm), but we're attempting to allocate a size of 3*4k.

Oops yes.  I merely forgot we've got two memory regions for the test,
sorry.

> 
> > 
> > Also, even if we want to have the alignment, shall we do the math
> > using known host/guest page size rather than another adhoc number or
> > could it still break with some other combinations of host/guest page
> > sizes?
> 
> I don't think we need to worry too much about > 64k pages being a
> thing any time soon and I'd rather not change the number of pages
> allocated based on the page sizes, so other than maybe doing something
> like
> 
> /*
>  * Comment stating why we have this.
>  */
> #define GUEST_EXTRA_PAGES 16
> 
> then I think we're already fine.

IMHO it would be as simple as replacing 3 with "3 * host_size /
guest_size", but both work for me.

Thanks,

-- 
Peter Xu
