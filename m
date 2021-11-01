Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A96C4413FF
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 08:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhKAHOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 03:14:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33915 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229938AbhKAHOF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 03:14:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635750692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WgKK78RszmwGwYgZzJ0AtAbWSTU2tbnY41K+wg9/KY8=;
        b=Aj5789KCsQOBh3VoXI7SGImTMhfSpEG0GpcmVkU00dRE6Torso7KL8zsRr4drMMm+zpviy
        BQeMvrYei/hmaTU9d4SvPF75/gK6PTjAZi9IFpBs/Z9SeHi6FObklYnHshsZYkHBZZQ+qA
        gwO4KcNPIzp3h/PyErwUGGjvJLtHXjA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-S9v_kvIWOb-9wvbi4hN_aw-1; Mon, 01 Nov 2021 03:11:31 -0400
X-MC-Unique: S9v_kvIWOb-9wvbi4hN_aw-1
Received: by mail-ed1-f71.google.com with SMTP id i9-20020a508709000000b003dd4b55a3caso14739533edb.19
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 00:11:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WgKK78RszmwGwYgZzJ0AtAbWSTU2tbnY41K+wg9/KY8=;
        b=FcgvNioEWpzHe1K0Yrgl0P5hXDFVr5AxtahMJ5h23EYswZ3bULOSNrwixUe+TxP0HN
         wmpXmObyzEQAdKj+PSJ+/i/nWRWuWrGR0JxZPlIsleB+3JK59xIsSr/h043Be0OuK60d
         ecZySXaIjWbXh0/gchqpvQVZqaqOaJzELxIYgcbfSEQBJrMdYCe6H8GtxzSoc4U3l2Gr
         V/eZNiNHkz72vUBwjIDRRGTwjBBUchCOPrKpXrCmnZtjmJjfObhmN/jQPajTjyTpqGQy
         kNytci4EFiQUSmFBhDd1Dmqx6h09WIJzF0YrC8Z26zxH3l8kXCgxhWTkMtcwLVc2VBJi
         TbNg==
X-Gm-Message-State: AOAM533ApuoIw0ZFtt+XguiJtSGjG1Mwfg9NhDdm4f6ikorxxxs1qjGf
        JP0CEgzHUSwirf2NoGfD4HGUhuGb1ZKr20iNoaO3JZmaySVsxEbFwTKe7OQYZuOXIUVO0/ZL7Oc
        wJo7Nh1hgXKvP
X-Received: by 2002:a50:8dcb:: with SMTP id s11mr8668674edh.318.1635750690635;
        Mon, 01 Nov 2021 00:11:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzOwdw/d5QRgeDRVL8l1h21e0+ayPuDk+GXgfioy778Vxt4b0jb1bJOOUsjHGXOqOYnRHk8aQ==
X-Received: by 2002:a50:8dcb:: with SMTP id s11mr8668648edh.318.1635750690414;
        Mon, 01 Nov 2021 00:11:30 -0700 (PDT)
Received: from gator.home (cst2-174-89.cust.vodafone.cz. [31.30.174.89])
        by smtp.gmail.com with ESMTPSA id i15sm8441669edk.2.2021.11.01.00.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 00:11:29 -0700 (PDT)
Date:   Mon, 1 Nov 2021 08:11:28 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Zixuan Wang <zxwang42@gmail.com>
Cc:     Marc Orr <marcorr@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v1 0/7] x86_64 UEFI set up process
 refactor and scripts fixes
Message-ID: <20211101071128.osha4ckes2gcrd6i@gator.home>
References: <20211031055634.894263-1-zxwang42@gmail.com>
 <d6c56f03-1da7-1ebf-1d2e-0ec1aa0b241c@redhat.com>
 <CAA03e5GZ6HnW8uk+2nh_vZcKvtt+wcdVchm4cjRm_yPFC-P7Eg@mail.gmail.com>
 <CAEDJ5ZRm6GtH6hL+Y_g7_5O=-GPWrSKu-bpKSf3yWcBuDJEKcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEDJ5ZRm6GtH6hL+Y_g7_5O=-GPWrSKu-bpKSf3yWcBuDJEKcg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 31, 2021 at 02:54:00PM -0700, Zixuan Wang wrote:
> On Sun, Oct 31, 2021 at 9:14 AM Marc Orr <marcorr@google.com> wrote:
> >
> > On Sun, Oct 31, 2021 at 12:28 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > >
> > > On 31/10/21 06:56, Zixuan Wang wrote:
> > > > Hello,
> > > >
> > > > This patch series refactors the x86_64 UEFI set up process and fixes the
> > > > `run-tests.sh` script to run under UEFI. The patches are organized as
> > > > three parts.
> > > >
> > > > The first part (patches 1-2) refactors the x86_64 UEFI set up process.
> > > > The previous UEFI setup calls arch-specific setup functions twice and
> > > > generates arch-specific data structure. As Andrew suggested [1], we
> > > > refactor this process to make only one call to the arch-specific
> > > > function and generate arch-neutral data structures. This simplifies the
> > > > set up process and makes it easier to develop UEFI support for other
> > > > architectures.
> > > >
> > > > The second part (patch 3) converts several x86 test cases to
> > > > Position-Independent Code (PIC) to run under UEFI. This patch is ported
> > > > from the initial UEFI support patchset [2] with fixes to the 32-bit
> > > > compilation.
> > > >
> > > > The third part (patches 4-7) fixes the UEFI runner scripts. Patch 4 sets
> > > > UEFI OVMF image as readonly. Patch 5 fixes test cases' return code under
> > > > UEFI, enabling Patch 6-7 to fix the `run-tests.sh` script under UEFI.
> > > >
> > > > This patch set is based on the `uefi` branch.
> > >
> > > Thank you, for patches 1-6 I have squashed the patches when applicable
> > > (1, 4, 5, 6) and queued the others (2 and 3).
> > >
> > > I did not queue patch 7 yet, it seems okay but I want to understand
> > > better the changes it needs in the harness and what is missing.  I'll
> > > take a look during the week.
> >
> > SGTM, thank you! Zixuan and I discussed a few things that are missing:
> >
> > 1. Test cases that take the `-append` arg are currently marked `SKIP`.
> > Two issues need to be resolved here. First, we're not using QEMU's
> > `-kernel` flag for EFI test cases [1]. And the `-append` flag does not
> > work without the `-kernel` flag. I don't understand the details on why
> > we don't use the `-kernel` flag myself. Maybe Zixuan can elaborate.
> > Second, assuming we fix the first issue, then we need to enlighten the
> > KVM-Unit-Tests under UEFI to parse kernel command line arguments and
> > pass them down to the test cases via `argv`. Zixuan pointed out to me
> > that there is some prior work from Drew [2] that we should be able to
> > follow to make this work. So I'm hoping that Zixuan and I can work
> > together on solving these issues to get the argument passing working
> > next.
> 
> Thank you for the detailed summary!
> 
> Current kvm-unit-tests pass an EFI binary as part of a disk image,
> instead of using the `-kernel` argument.
> 
> I just tested the `-kernel` argument and it seems to work with EFI
> binaries, and more importantly, it's really fast (bypassing the
> default 5-second user input waiting). I will update the `x86/efi/run`
> to use `-kernel` argument to pass the EFI binaries.
> 
> Since `-kernel` is working, I can start to investigate how to use
> `-append` to pass arguments. If that doesn't work well, an alternative
> approach could be:
> 
> 1. (host) create a file `args.txt` in the disk image, which contains
> all the arguments needed
> 2. (guest) call UEFI filesystem interface to read this `args.txt` from
> the disk image, parse it and pass the arguments to `main()`
> 
> > 2. We need a way to annotate test cases in `x86/unittests.cfg` as
> > known to work under SEV. I'm thinking of doing this via new (very
> > broad) test groups in `unittests.cfg`. I _think_ SEV is the primary
> > scenario we care about. However, folks may care about running the test
> > cases under UEFI outside of SEV. For example, last time I checked,
> > emulator runs OK under UEFI minus SEV-ES but fails under SEV-ES. And
> > similarly, while most test cases work under UEFI minus SEV, there are
> > a few that do mis-behave -- and it probably makes sense to document
> > this (e.g., via annotations in `unittests.cfg`). Also, there are many
> > variations of SEV (SEV, SEV-ES, SEV-SNP)... And hopefully some of this
> > will eventually be applicable to TDX as well. So many testgroups is
> > not a good solution. I'm not sure.
> 
> Adding an `efi` group seems helpful. E.g., the current `x86/smap.c`
> does not work under UEFI; but the `run-tests.sh` still tries to run
> this test case, even if this test case is not compiled.
> 
> > 3. Multi-CPU needs to be made to work under UEFI. For now, patch #7
> > forces all EFI test cases to run with 1 vCPU. I chatted with Brijesh,
> > and he mentioned that Varad would like to work on this. However, if
> > anything here changes, please let me know, because we can work on this
> > as well. But for now, I'm not planning to work on it so we can avoid
> > duplicating work.
> > 4. UEFI runs a lot slower than SEABIOS. It doesn't help that the test
> > harness launches QEMU more than once for each test case (i.e., it runs
> > the `_NO_FILE_4Uhere_` scenario to check QEMU arguments). I'm not sure
> > how much of an issue this is in practice. Depending on the answer, I
> > know Zixuan had some ideas on how to speed this up in the current test
> > harness. Or maybe we can explore an alternative to the
> > `_NO_FILE_4Uhere_` approach instead.
> 
> As the `-kernel` argument now works with the EFI binaries and is
> significantly faster, this should not be an issue anymore. We just
> need to update the runner scripts to use `-kernel` argument.

You can add an additional '-kernel' + EFI binary runner if you want, but
the goal of being able to run kvm-unit-tests on bare-metal means we
shouldn't be counting on QEMU/OVMF to do magic stuff with the kernel. We
need to build disk images. Argument passing works with EFI apps, when
implemented, so that's not a problem. I also created a script that uses
the framework's for_each_unittest to generate an EFI script that allowed
each test to be easily run with its arguments.

Thanks,
drew

> 
> > Zixuan: Please add/correct anything as needed!
> >
> > [1] https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/blob/uefi/x86/run#L42-44
> > [2] https://github.com/rhdrjones/kvm-unit-tests/blob/target-efi/scripts/mkefi.sh
> >
> > Thanks,
> > Marc
> 
> Best regards,
> Zixuan
> 

