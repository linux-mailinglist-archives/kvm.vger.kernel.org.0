Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0F94BBFD3
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 03:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408449AbfIXBzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 21:55:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40188 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408444AbfIXBzb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 21:55:31 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E2A2F3DE0F;
        Tue, 24 Sep 2019 01:55:30 +0000 (UTC)
Received: from mail (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F0F8601A2;
        Tue, 24 Sep 2019 01:55:28 +0000 (UTC)
Date:   Mon, 23 Sep 2019 21:55:27 -0400
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/17] KVM: monolithic: x86: inline more exit handlers in
 vmx.c
Message-ID: <20190924015527.GC4658@redhat.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-15-aarcange@redhat.com>
 <6a1d66a1-74c0-25b9-692f-8875e33b2fae@redhat.com>
 <20190924010056.GB4658@redhat.com>
 <a75d04e1-cfd6-fa2e-6120-1f3956e14153@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a75d04e1-cfd6-fa2e-6120-1f3956e14153@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 24 Sep 2019 01:55:30 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 24, 2019 at 03:25:34AM +0200, Paolo Bonzini wrote:
> On 24/09/19 03:00, Andrea Arcangeli wrote:
> > Before and after this specific commit there is a difference with gcc 8.3.
> > 
> > full patchset applied
> > 
> >  753699   87971    9616  851286   cfd56 build/arch/x86/kvm/kvm-intel.ko
> > 
> > git revert
> > 
> >  753739   87971    9616  851326   cfd7e  build/arch/x86/kvm/kvm-intel.ko
> > 
> > git reset --hard HEAD^
> > 
> >  753699   87971    9616  851286   cfd56  build/arch/x86/kvm/kvm-intel.ko
> > 
> > git revert
> > 
> >  753739   87971    9616  851326   cfd7e  build/arch/x86/kvm/kvm-intel.ko
> 
> So it's forty bytes.  I think we can leave this out.

This commit I reverted adds literally 3 inlines called by 3 functions,
in a very fast path, how many bytes of .text difference did you expect
by dropping some call/ret from a very fast path when you asked me to
test it? I mean it's just a couple of insn each.

I thought the question was if gcc was already inlining without the
hint or not or if it actually grew in size in case I got it wrong and
there were many callers and it was better off not inline, so now I
don't get what was the point of this test if with the result that
confirms it's needed, the patch should be dropped.

It's possible that this patch may not be relevant anymore with the
rename in place of the vmx/svm functions, but if this patch is to be
dropped with the optimal result, then I recommend you to go ahead and
submit a patch to drop __always_inline from the whole kernel because
if it's not good to use it here in a extreme fast path like
handle_external_interrupt and handle_halt, then I don't know what
__always_inline is good for anywhere else in the kernel.

Thanks,
Andrea
