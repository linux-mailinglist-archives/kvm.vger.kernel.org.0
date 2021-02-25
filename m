Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F4C325A01
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 00:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbhBYXAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 18:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhBYXAq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 18:00:46 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D694DC061756
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 15:00:05 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id e2so6444206ilu.0
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 15:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5XspxK0PdIQsovjLyVyGdSX6BoQMz+G/8K5JhMr+loc=;
        b=pkh4T7ynn+GB+pZAd1CZylm7bj8M2Xc+JTtE118zzJdpjKIMiDStQIRKnGP9zdyYf0
         BcpHSYoF6BYT45oSWTGema+9VDxw3PKp3ap9LoceEXBA/Sknxf7Kr7EZrWKL8BqJ2KUG
         9ELfgX5pqNvwEb5ihIYdyjdykB5OTHsBKxYeu+A2my1Wgq7Rf0D1r5qbi2QA+3pDlbxm
         VqiRRMYFfMxVNCRHFejZHzJwJdGqzbxA1snO5BsDXDbRO4kb4a8niLoE3BlbV71085K7
         h4482SDdLc5pKRUj1JubV008AxQdlD6wElzH+woME/Sk4C/vp1FUil43I/fuMWEtH0tV
         8REw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5XspxK0PdIQsovjLyVyGdSX6BoQMz+G/8K5JhMr+loc=;
        b=ZU+O1dz+PYn8cvUGsiUNzGkmcPlTYmmzUgxuosNwRidDiGrbW8KT69ZdD84JyNn5IL
         DnrWa9N0S6/nUqwWLIY8U/Vsd3VwOsARpK1G0MoCUZfL3ZT+erIAxcxOzqh5QOKBYlpJ
         8ESorRhimAQouhJkByewWhuzKdXbxXDkjFTAy52mlzYd5e+wDhq5c4iX1OnW1UnMYbop
         EvM0D1loT6h8UELOo8x9BSEh0PyX2E0N8zp3415TRr96L5V7v7NynWYdusCCNNT5JyUm
         PgjqFI/7sgutH8D81CrXF+KxEdOwcnJ1ELn33odaKfGOZaWworXQ5F8QC64xj6ALZvha
         pbew==
X-Gm-Message-State: AOAM530FxwfyyYiKK3VnJ1M3WMDumTLIWqct6sNU+aUeC2CybyJdHOVe
        kw9tXfvQR2E6i074v4VEit0FdUQmxVVs66AdA0YQhg==
X-Google-Smtp-Source: ABdhPJwp0cGVsBrOff0RWqDvOFDayYL0EnOuJDctsNFXCzoR26aNVdPACoTevyNH5XNtYOTmSaV/qHGqQOJBUUo4HNI=
X-Received: by 2002:a92:cd8a:: with SMTP id r10mr35361ilb.110.1614294004761;
 Thu, 25 Feb 2021 15:00:04 -0800 (PST)
MIME-Version: 1.0
References: <cover.1612398155.git.ashish.kalra@amd.com> <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
 <YCxrV4u98ZQtInOE@google.com> <SN6PR12MB27672FF8358D122EDD8CC0188E859@SN6PR12MB2767.namprd12.prod.outlook.com>
 <20210224175122.GA19661@ashkalra_ubuntu_server> <YDaZacLqNQ4nK/Ex@google.com> <20210225202008.GA5208@ashkalra_ubuntu_server>
In-Reply-To: <20210225202008.GA5208@ashkalra_ubuntu_server>
From:   Steve Rutherford <srutherford@google.com>
Date:   Thu, 25 Feb 2021 14:59:27 -0800
Message-ID: <CABayD+cn5e3PR6NtSWLeM_qxs6hKWtjEx=aeKpy=WC2dzPdRLw@mail.gmail.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST ioctl
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, "bp@suse.de" <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 25, 2021 at 12:20 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
>
> On Wed, Feb 24, 2021 at 10:22:33AM -0800, Sean Christopherson wrote:
> > On Wed, Feb 24, 2021, Ashish Kalra wrote:
> > > # Samples: 19K of event 'kvm:kvm_hypercall'
> > > # Event count (approx.): 19573
> > > #
> > > # Overhead  Command          Shared Object     Symbol
> > > # ........  ...............  ................  .........................
> > > #
> > >    100.00%  qemu-system-x86  [kernel.vmlinux]  [k] kvm_emulate_hypercall
> > >
> > > Out of these 19573 hypercalls, # of page encryption status hcalls are 19479,
> > > so almost all hypercalls here are page encryption status hypercalls.
> >
> > Oof.
> >
> > > The above data indicates that there will be ~2% more Heavyweight VMEXITs
> > > during SEV guest boot if we do page encryption status hypercalls
> > > pass-through to host userspace.
> > >
> > > But, then Brijesh pointed out to me and highlighted that currently
> > > OVMF is doing lot of VMEXITs because they don't use the DMA pool to minimize the C-bit toggles,
> > > in other words, OVMF bounce buffer does page state change on every DMA allocate and free.
> > >
> > > So here is the performance analysis after kernel and initrd have been
> > > loaded into memory using grub and then starting perf just before booting the kernel.
> > >
> > > These are the performance #'s after kernel and initrd have been loaded into memory,
> > > then perf is attached and kernel is booted :
> > >
> > > # Samples: 1M of event 'kvm:kvm_userspace_exit'
> > > # Event count (approx.): 1081235
> > > #
> > > # Overhead  Trace output
> > > # ........  ........................
> > > #
> > >     99.77%  reason KVM_EXIT_IO (2)
> > >      0.23%  reason KVM_EXIT_MMIO (6)
> > >
> > > # Samples: 1K of event 'kvm:kvm_hypercall'
> > > # Event count (approx.): 1279
> > > #
> > >
> > > So as the above data indicates, Linux is only making ~1K hypercalls,
> > > compared to ~18K hypercalls made by OVMF in the above use case.
> > >
> > > Does the above adds a prerequisite that OVMF needs to be optimized if
> > > and before hypercall pass-through can be done ?
> >
> > Disclaimer: my math could be totally wrong.
> >
> > I doubt it's a hard requirement.  Assuming a conversative roundtrip time of 50k
> > cycles, those 18K hypercalls will add well under a 1/2 a second of boot time.
> > If userspace can push the roundtrip time down to 10k cycles, the overhead is
> > more like 50 milliseconds.
> >
> > That being said, this does seem like a good OVMF cleanup, irrespective of this
> > new hypercall.  I assume it's not cheap to convert a page between encrypted and
> > decrypted.
> >
> > Thanks much for getting the numbers!
>
> Considering the above data and guest boot time latencies
> (and potential issues with OVMF and optimizations required there),
> do we have any consensus on whether we want to do page encryption
> status hypercall passthrough or not ?
>
> Thanks,
> Ashish

Thanks for grabbing the data!

I am fine with both paths. Sean has stated an explicit desire for
hypercall exiting, so I think that would be the current consensus.

If we want to do hypercall exiting, this should be in a follow-up
series where we implement something more generic, e.g. a hypercall
exiting bitmap or hypercall exit list. If we are taking the hypercall
exit route, we can drop the kvm side of the hypercall. Userspace could
also handle the MSR using MSR filters (would need to confirm that).
Then userspace could also be in control of the cpuid bit.

Essentially, I think you could drop most of the host kernel work if
there were generic support for hypercall exiting. Then userspace would
be responsible for all of that. Thoughts on this?

--Steve
