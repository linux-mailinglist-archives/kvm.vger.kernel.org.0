Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF1E372258
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 23:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhECVSg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 17:18:36 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:33927 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhECVSg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 17:18:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1620076663; x=1651612663;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=04TqWL9x3kySh2dDc818s2E7ADPYmdphIO/5JHsPMSc=;
  b=rH+QVhBhwaJS+0U5EPixs8azYWre4dvVBrbNTeKgDbbbyyHKUrDza3vx
   Zmk2hehkk94dkLHt0QLneMQS3vJ4f4QPVJSuD+6oazt92nc+L+SvogcXR
   4B0lxhPRa9V1iy13uiAkGLYeGeDlzw49PbG9R9KlWgrq6oK1SdifRWuTe
   Q=;
X-IronPort-AV: E=Sophos;i="5.82,271,1613433600"; 
   d="scan'208";a="105449271"
Subject: Re: [PATCH] KVM: x86: Hoist input checks in kvm_add_msr_filter()
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 03 May 2021 21:17:35 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com (Postfix) with ESMTPS id 02C54A059E;
        Mon,  3 May 2021 21:17:32 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.162.28) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 3 May 2021 21:17:27 +0000
Date:   Mon, 3 May 2021 23:17:23 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <20210503211722.GA8688@uc8bbc9586ea454.ant.amazon.com>
References: <20210503122111.13775-1-sidcha@amazon.de>
 <YJBitcip8/WIsaB9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YJBitcip8/WIsaB9@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.162.28]
X-ClientProxiedBy: EX13D18UWA003.ant.amazon.com (10.43.160.238) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 03, 2021 at 08:53:09PM +0000, Sean Christopherson wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> On Mon, May 03, 2021, Siddharth Chandrasekaran wrote:
> > In ioctl KVM_X86_SET_MSR_FILTER, input from user space is validated
> > after a memdup_user(). For invalid inputs we'd memdup and then call
> > kfree unnecessarily. Hoist input validation to avoid kfree altogether.
> >
> > Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> > ---
> >  arch/x86/kvm/x86.c | 21 ++++++---------------
> >  1 file changed, 6 insertions(+), 15 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index ee0dc58ac3a5..15c20b31cc91 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5393,11 +5393,16 @@ static int kvm_add_msr_filter(struct kvm_x86_msr_filter *msr_filter,
> >       struct msr_bitmap_range range;
> >       unsigned long *bitmap = NULL;
> >       size_t bitmap_size;
> > -     int r;
> >
> >       if (!user_range->nmsrs)
> >               return 0;
> >
> > +     if (user_range->flags & ~(KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE))
> > +             return -EINVAL;
> > +
> > +     if (!user_range->flags)
> > +             return -EINVAL;
> > +
> >       bitmap_size = BITS_TO_LONGS(user_range->nmsrs) * sizeof(long);
> >       if (!bitmap_size || bitmap_size > KVM_MSR_FILTER_MAX_BITMAP_SIZE)
> >               return -EINVAL;
> > @@ -5413,24 +5418,10 @@ static int kvm_add_msr_filter(struct kvm_x86_msr_filter *msr_filter,
> >               .bitmap = bitmap,
> >       };
> >
> > -     if (range.flags & ~(KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE)) {
> > -             r = -EINVAL;
> > -             goto err;
> > -     }
> > -
> > -     if (!range.flags) {
> > -             r = -EINVAL;
> > -             goto err;
> > -     }
> > -
> > -     /* Everything ok, add this range identifier. */
> >       msr_filter->ranges[msr_filter->count] = range;
> 
> Might be worth elminating the intermediate "range", too.  Doesn't affect output,
> but it would make it a little more obvious that the new range is mostly coming
> straight from userspace input.  E.g.
> 
>         msr_filter->ranges[msr_filter->count] = (struct msr_bitmap_range) {
>                 .flags = user_range->flags,
>                 .base = user_range->base,
>                 .nmsrs = user_range->nmsrs,
>                 .bitmap = bitmap,
>         };
> 
> Either way:
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Thanks for the review. Changed as suggested.

~ Sid.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



