Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF89325CC34
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 23:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbgICV1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 17:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbgICV1K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 17:27:10 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5089BC061245
        for <kvm@vger.kernel.org>; Thu,  3 Sep 2020 14:27:10 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id h17so3271489otr.1
        for <kvm@vger.kernel.org>; Thu, 03 Sep 2020 14:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aDDCxUq5LYXZ2vWhxqpUhB793LjuCmYKYt240ziQivQ=;
        b=flXhhVWWhNBcfgPFbSoJ7dRSwbXxNizmHPAIsj23YZlfVwoSOJdwd5cRtKavfCouWo
         ynjvydUPvgYTL72rYUDSEbEd+Vzau4WHprxZpoQV9g7eFZa1EBIGOQyQ6U2uQnGN5/fS
         d8tfxntyw2vjR8R+0DZQ5NaSRVjpBg8C0wnKWar0sLTieE9H0IQny3afACakGvDkrBZR
         PTWaE1JTL3PB3q9pqGZ6lse9sHpU7bwSCKMmjcFNWCLnifratRe2rKUMB7JArDUfOIjk
         Qx2eU3pbiFUdNndcypC9C4tlblWlaaKEcNsP2EMz9i2ARTFjJRiL7PjzPXeCY+c2IjZE
         XbMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aDDCxUq5LYXZ2vWhxqpUhB793LjuCmYKYt240ziQivQ=;
        b=TRYPulnmDvnbDB2+CmQyKeJ4XCvKQpglJtLZ2q8u5TEhAulBuxYnryg8EPvoswTVes
         Q608VbBxZfy5fKcTPgSuO8HIWNiWdWEF6JUB1ekJkVGx9V3IIDFb59Z9nEnVbV1zIwvA
         u+arbw/AQKXeeApwpHt08koyVSOeoewbmpDvRYH3w5Temb4R6Jih1/SHR2OEEO2DNgFt
         A/y+SRSKWdvyvOP2yWQvIDcP/R4BiDb4SjE5Da80smfMryGhrIqMjIEGK4vkeAK24yMm
         dLQIpsmsKviqLSYs1GJ2hSqFbC4vXyGSfNhu3r8ahStTe1DSpd7R1/ZIj32rg8AvtA5N
         TuWQ==
X-Gm-Message-State: AOAM533aweql5c/3Bc/ROuGUhhqO2vIhASNCeiv7GJP1fcz2faha9hjS
        2NGLln4XdmNLrgrOKVQvR0uNsy7meqGKy8HpwRgs/g==
X-Google-Smtp-Source: ABdhPJwaWdTpa/DNKpDuyca6UfKn2JJFpMZ/65YVZxbQhKEzZqWnrZXd/AB8AvPQ5/gesxUVWpJGeavsVVGS1mZEnVU=
X-Received: by 2002:a9d:1c8f:: with SMTP id l15mr3111739ota.241.1599168429267;
 Thu, 03 Sep 2020 14:27:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200903141122.72908-1-mgamal@redhat.com> <CALMp9eTrc8_z3pKBtLVmbnMvC+KtzXMYbYTXZPPz5F0UWW8oNQ@mail.gmail.com>
 <00b0f9eb-286b-72e8-40b5-02f9576f2ce3@redhat.com> <CALMp9eS6O18WcEyw8b6npRSazsyKiGtBjV+coZVGxDNU1JEOsQ@mail.gmail.com>
 <208da546-e8e3-ccd5-9686-f260d07b73fd@redhat.com>
In-Reply-To: <208da546-e8e3-ccd5-9686-f260d07b73fd@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 3 Sep 2020 14:26:57 -0700
Message-ID: <CALMp9eTheeaYcBjx50-JC4_93mxudgOeyNbT6stVMfx3FjXFCQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: VMX: Make smaller physical guest address space
 support user-configurable
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mohammed Gamal <mgamal@redhat.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 3, 2020 at 1:02 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 03/09/20 20:32, Jim Mattson wrote:
> >> [Checking writes to CR3] would be way too slow.  Even the current
> >> trapping of present #PF can introduce some slowdown depending on the
> >> workload.
> >
> > Yes, I was concerned about that...which is why I would not want to
> > enable pedantic mode. But if you're going to be pedantic, why go
> > halfway?
>
> Because I am not sure about any guest, even KVM, caring about setting
> bits 51:46 in CR3.
>
> >>> Does the typical guest care about whether or not setting any of the
> >>> bits 51:46 in a PFN results in a fault?
> >>
> >> At least KVM with shadow pages does, which is a bit niche but it shows
> >> that you cannot really rely on no one doing it.  As you guessed, the
> >> main usage of the feature is for machines with 5-level page tables where
> >> there are no reserved bits; emulating smaller MAXPHYADDR allows
> >> migrating VMs from 4-level page-table hosts.
> >>
> >> Enabling per-VM would not be particularly useful IMO because if you want
> >> to disable this code you can just set host MAXPHYADDR = guest
> >> MAXPHYADDR, which should be the common case unless you want to do that
> >> kind of Skylake to Icelake (or similar) migration.
> >
> > I expect that it will be quite common to run 46-bit wide legacy VMs on
> > Ice Lake hardware, as Ice Lake machines start showing up in
> > heterogeneous data centers.
>
> If you'll be okay with running _all_ 46-bit wide legacy VMs without
> MAXPHYADDR emulation, that's what this patch is for.  If you'll be okay
> with running _only_ 46-bit wide VMs without emulation, you still don't
> need special enabling per-VM beyond the automatic one based on
> CPUID[0x8000_0008].  Do you think you'll need to enable it for some
> special 46-bit VMs?

Yes. From what you've said above, we would only want to enable this
for the niche case of 46-bit KVM guests using shadow paging. I would
expect that to be a very small number of VMs. :-)
