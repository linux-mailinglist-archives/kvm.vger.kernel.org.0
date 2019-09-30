Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 356ADC259D
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 19:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730485AbfI3RCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 13:02:24 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:36815 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730563AbfI3RCY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 13:02:24 -0400
Received: by mail-vs1-f68.google.com with SMTP id v19so7294516vsv.3
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 10:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dfWInwpAaXhuNaRHnFqf5Kb0nv75VBrMC3/txP8hcfk=;
        b=vfEU9S+JHbvVzsKuQ850SjGfpwveObEbl3z5Q/cPU15GOhQM4I7irCZ/+GhRxmC7lu
         VVNixPmC6dHcGkJE2agCguJjjB/pWBe36d15sL1qdrG0hDSryvAEhLUvxHeG1eQtOJdY
         zH/QA3r767biQIir7H4+/iIfa5e1SoicT6pxFAXkflR6deUOmLgKVGm0WaDsvjuH+42e
         QCqBt2KWtGf7H8kP1mbRvHuK6nqz1KqixB08aq00t3NzfRMHW9nFk8kPkYsHc55+yKPw
         h6TW70DGiyS/Dy0JV3IWQ5tDCWkLRCJA5qiG3N0vDDrf88FXkS+fJLTsRPfRnDY0m8eM
         xE5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dfWInwpAaXhuNaRHnFqf5Kb0nv75VBrMC3/txP8hcfk=;
        b=RoqPoxuJGh4ybuU/GThd7u7QC++Mmb3kMgvzxBq52eqhjqwdzRIfro8jYlzRm4RXtL
         oMl/WYBpEOcEcSpUNoJ0SbuLz1GhKQsMoSDVFc7NyljCPmz2PfiT3M5Si9/RgVCSviGk
         hR8dpXI3ZK1MrpzMDl4iXU9BboMwGwm9iyvXA2UYdjjnOBqgoAzq7RElkG5w+JFMZUme
         8fInIZcsHTdkJ9gzLTvKTy0YJ1iBuGG3svgPMWMnOKPfumYlqaol4Q4zXJ52FKBCDqLj
         Sg+moZEVjl97kWpM93R9l0o56YijT7uBuKgOHrz4+wvsgUuPcMEmS7+Nd+Vr/8FEt+rn
         vjWA==
X-Gm-Message-State: APjAAAUZnWb1yHKynhk/aCwVAoYpRex93LdV5kJCZZcmiQeJLho1lEpT
        yMvJyJlW7yqWzZOX4V7IvepadrjZtEAIDz0WLrz/xA==
X-Google-Smtp-Source: APXvYqyqIeQ5pCQuEg2Zk62SjgpRI5+Pr2OmwMlOVkeeamN+h5XjCIT83r7aH1UTCZQjK5qi2XaXf9Oaw/wGHikvAfE=
X-Received: by 2002:a67:db93:: with SMTP id f19mr10235459vsk.49.1569862942843;
 Mon, 30 Sep 2019 10:02:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190927161836.57978-1-bgardon@google.com> <20190929072248.GB8903@xz-x1>
In-Reply-To: <20190929072248.GB8903@xz-x1>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 30 Sep 2019 10:02:11 -0700
Message-ID: <CANgfPd-=OWEiVkQMzh2mkH1ch9VeZsoc_KykPp6AqtkpQh-7EQ@mail.gmail.com>
Subject: Re: [PATCH 0/9] Create a userfaultfd demand paging test
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cannon Matthews <cannonmatthews@google.com>,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,
You're absolutely right that we could demonstrate more contention by
avoiding UFFD and just letting the kernel resolve page faults. I used
UFFD in this test and benchmarking for the other MMU patch set because
I believe it's a more realistic scenario. A simpler page access
benchmark would be better for identifying further scaling problems
within the MMU, but the only situation I can think of where that would
be used is VM boot. However, we don't usually see many vCPUs touching
memory all over the place on boot. In a migration or restore without
demand paging, the memory would have to be pre-populated with the
contents of guest memory and the KVM MMU fault handler wouldn't be
taking a fault in get_user_pages. In the interest of eliminating the
delay from UFFD, I will add an option to use anonymous page faults or
prefault memory instead.

I don't have any plans to customize the UFFD implementation at the
moment, but experimenting with UFFD strategies will be useful for
building higher performance post-copy in QEMU and other userspaces in
the future.
Thank you for taking a look at these patches.
Ben

On Sun, Sep 29, 2019 at 12:23 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Sep 27, 2019 at 09:18:28AM -0700, Ben Gardon wrote:
> > When handling page faults for many vCPUs during demand paging, KVM's MMU
> > lock becomes highly contended. This series creates a test with a naive
> > userfaultfd based demand paging implementation to demonstrate that
> > contention. This test serves both as a functional test of userfaultfd
> > and a microbenchmark of demand paging performance with a variable number
> > of vCPUs and memory per vCPU.
> >
> > The test creates N userfaultfd threads, N vCPUs, and a region of memory
> > with M pages per vCPU. The N userfaultfd polling threads are each set up
> > to serve faults on a region of memory corresponding to one of the vCPUs.
> > Each of the vCPUs is then started, and touches each page of its disjoint
> > memory region, sequentially. In response to faults, the userfaultfd
> > threads copy a static buffer into the guest's memory. This creates a
> > worst case for MMU lock contention as we have removed most of the
> > contention between the userfaultfd threads and there is no time required
> > to fetch the contents of guest memory.
>
> Hi, Ben,
>
> Even though I may not have enough MMU knowledge to say this... this of
> course looks like a good test at least to me.  I'm just curious about
> whether you have plan to customize the userfaultfd handler in the
> future with this infrastructure?
>
> Asked because IIUC with this series userfaultfd only plays a role to
> introduce a relatively adhoc delay to page faults.  In other words,
> I'm also curious what would be the number look like (as you mentioned
> in your MMU rework cover letter) if you simply start hundreds of vcpu
> and do the same test like this, but use the default anonymous page
> faults rather than uffd page faults.  I feel like even without uffd
> that could be a huge contention already there.  Or did I miss anything
> important on your decision to use userfaultfd?
>
> Thanks,
>
> --
> Peter Xu
