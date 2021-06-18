Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442A83AC303
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 08:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbhFRGCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 02:02:12 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:56900 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbhFRGCL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 02:02:11 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2C57621AB1;
        Fri, 18 Jun 2021 06:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1623996002; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Etb+e8FSSeXWZbq2Xf9BFn2ebx78s4yb03Of9slw210=;
        b=qgX66veJVOAz8w/h06hvEAy8tj7LJjm5kroBTguRv6+yqaHR+HF86BS5Q3nBuTgu9TT3bm
        iCeVwMkvKakAibJlJv4QHp0BYt++KCebhnO7eyG1NVL/0wEgZwsd9lnHm0IghQ42F2uc9m
        sFwT1ETlMcSACt+8efwjXONSPFB6AUs=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E0E8AA3B9D;
        Fri, 18 Jun 2021 06:00:01 +0000 (UTC)
Date:   Fri, 18 Jun 2021 08:00:01 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Denis Efremov <efremov@linux.com>,
        Paolo Bonzini <pbonzini@redhat.com>, joe@perches.com,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: Use vmemdup_user()
Message-ID: <YMw2YeWHFsn+AFmN@dhcp22.suse.cz>
References: <0c00d96c46d34d69f5f459baebf3c89a507730fc.camel@perches.com>
 <20200603101131.2107303-1-efremov@linux.com>
 <CALMp9eSFkRrWLjegJ5OC7kZ4oWtZypKRDjXFQD5=tFX4YLpUgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSFkRrWLjegJ5OC7kZ4oWtZypKRDjXFQD5=tFX4YLpUgw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu 17-06-21 17:25:04, Jim Mattson wrote:
> On Wed, Jun 3, 2020 at 3:10 AM Denis Efremov <efremov@linux.com> wrote:
> >
> > Replace opencoded alloc and copy with vmemdup_user().
> >
> > Signed-off-by: Denis Efremov <efremov@linux.com>
> > ---
> > Looks like these are the only places in KVM that are suitable for
> > vmemdup_user().
> >
> >  arch/x86/kvm/cpuid.c | 17 +++++++----------
> >  virt/kvm/kvm_main.c  | 19 ++++++++-----------
> >  2 files changed, 15 insertions(+), 21 deletions(-)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 901cd1fdecd9..27438a2bdb62 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -182,17 +182,14 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
> >         r = -E2BIG;
> >         if (cpuid->nent > KVM_MAX_CPUID_ENTRIES)
> >                 goto out;
> > -       r = -ENOMEM;
> >         if (cpuid->nent) {
> > -               cpuid_entries =
> > -                       vmalloc(array_size(sizeof(struct kvm_cpuid_entry),
> > -                                          cpuid->nent));
> > -               if (!cpuid_entries)
> > -                       goto out;
> > -               r = -EFAULT;
> > -               if (copy_from_user(cpuid_entries, entries,
> > -                                  cpuid->nent * sizeof(struct kvm_cpuid_entry)))
> > +               cpuid_entries = vmemdup_user(entries,
> > +                                            array_size(sizeof(struct kvm_cpuid_entry),
> > +                                                       cpuid->nent));
> 
> Does this break memcg accounting? I ask, because I'm really not sure.

What do you mean by that? The original code uses plain vmalloc so the
allocation is not memcg accounted (please note that __GFP_ACCOUNT needs
to be specified explicitly). vmemdup_user is the same in that regards.

-- 
Michal Hocko
SUSE Labs
