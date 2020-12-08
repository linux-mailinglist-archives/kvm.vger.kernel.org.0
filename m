Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA46B2D2150
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 04:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbgLHDLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 22:11:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbgLHDLL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 22:11:11 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9DAC061793
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 19:10:25 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id n4so15535311iow.12
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 19:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=auekhxsRVaU2xdGB+XB7bIw995+V9t1hsCC4VWHRTfU=;
        b=pvj/ZtbaNI+Gb/IT4EYFkirsiNDx4/SpFfjw8e3GsMS8DajMkfWsX1+hqGPC2kNRcu
         QvbjfNg3o3hEhtIhXGOOkk6zyk5sN4JeGCHl6My6updiKekW3VECGUVxpsbKjWpUUcCO
         od9BKVkjgGYOzdJX4Cg+5RdiEW3MVn4f9yzZPtui7QEz3aS+tmoszGo4Dxd6CJNS1U/i
         Sp3RLVMnWcY7PdrNSBjFNaMlOIrvGy+0a80qhVfFDCW46KhxKR9DGYGeTjFtYg39wDPK
         syXWYQUFzUuh5RGP68hrsItfaNst6FEBKoXIqbicHOYpMf2is525+Z3bh6N7YZ0wvwJZ
         TK1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=auekhxsRVaU2xdGB+XB7bIw995+V9t1hsCC4VWHRTfU=;
        b=fNKLhaXId5bUt1aHT7tOiiwCc1O+dQTzrXz55ec+eS0Hkp1hGnteQFbhBEBbhMb7Wi
         tpOT0kI7mCxjyxVgkpiRLUIPDGTsAj84iggO0qHBla+GvexAiUcmiU33iwyC2iiytdkz
         v18d6+XjIOpRPCj1fgtmHiAO2yMjdGXsYTXjb6cfiFvMDw6zCr89lHHN08sqQpU8EEYY
         38qKL6hhCqfVKzcca0oidxbTh2DW44YnlY2twKOz9AXfyI8EYty1OJ9JtCqXthwRcsEi
         3P4/z08THOBnxyvn+vRdnednpEKo4lknnmEF/H6/8zcY/b4IogivFkgy88L1IsZ59RYb
         CYMw==
X-Gm-Message-State: AOAM533CTf/dccMR79+e47V4bphKpi2H8miFfa4oUBncRxnzZF0rkS+k
        CepUc+CFxQmhZZL4HlUTehZEYPcrvQaJOby+vnpZOw==
X-Google-Smtp-Source: ABdhPJyVp1eAb2lE+ls10mMWZHU+kkBY0h+dZ7tRuTcvD51ImT0d46IE+BCCAIp/kdHzIXimdsWdrp57zG4cggXcQPQ=
X-Received: by 2002:a05:6602:20ca:: with SMTP id 10mr22754959ioz.51.1607397024627;
 Mon, 07 Dec 2020 19:10:24 -0800 (PST)
MIME-Version: 1.0
References: <cover.1606782580.git.ashish.kalra@amd.com> <b6bc54ed6c8ae4444f3acf1ed4386010783ad386.1606782580.git.ashish.kalra@amd.com>
 <X8gyhCsEMf8QU9H/@google.com> <d63529ce-d613-9f83-6cfc-012a8b333e38@redhat.com>
 <X86Tlin14Ct38zDt@google.com>
In-Reply-To: <X86Tlin14Ct38zDt@google.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 7 Dec 2020 19:09:48 -0800
Message-ID: <CABayD+esy0yeKi9W3wQw+ou4y4840LPCwd-PHhN1J6Uh_fvSjA@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] KVM: x86: Add AMD SEV specific Hypercall3
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        dovmurik@linux.vnet.ibm.com, tobin@ibm.com, jejb@linux.ibm.com,
        frankeh@us.ibm.com, dgilbert@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 7, 2020 at 12:42 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Sun, Dec 06, 2020, Paolo Bonzini wrote:
> > On 03/12/20 01:34, Sean Christopherson wrote:
> > > On Tue, Dec 01, 2020, Ashish Kalra wrote:
> > > > From: Brijesh Singh <brijesh.singh@amd.com>
> > > >
> > > > KVM hypercall framework relies on alternative framework to patch the
> > > > VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
> > > > apply_alternative() is called then it defaults to VMCALL. The approach
> > > > works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
> > > > will be able to decode the instruction and do the right things. But
> > > > when SEV is active, guest memory is encrypted with guest key and
> > > > hypervisor will not be able to decode the instruction bytes.
> > > >
> > > > Add SEV specific hypercall3, it unconditionally uses VMMCALL. The hypercall
> > > > will be used by the SEV guest to notify encrypted pages to the hypervisor.
> > >
> > > What if we invert KVM_HYPERCALL and X86_FEATURE_VMMCALL to default to VMMCALL
> > > and opt into VMCALL?  It's a synthetic feature flag either way, and I don't
> > > think there are any existing KVM hypercalls that happen before alternatives are
> > > patched, i.e. it'll be a nop for sane kernel builds.
> > >
> > > I'm also skeptical that a KVM specific hypercall is the right approach for the
> > > encryption behavior, but I'll take that up in the patches later in the series.
> >
> > Do you think that it's the guest that should "donate" memory for the bitmap
> > instead?
>
> No.  Two things I'd like to explore:
>
>   1. Making the hypercall to announce/request private vs. shared common across
>      hypervisors (KVM, Hyper-V, VMware, etc...) and technologies (SEV-* and TDX).
>      I'm concerned that we'll end up with multiple hypercalls that do more or
>      less the same thing, e.g. KVM+SEV, Hyper-V+SEV, TDX, etc...  Maybe it's a
>      pipe dream, but I'd like to at least explore options before shoving in KVM-
>      only hypercalls.
>
>
>   2. Tracking shared memory via a list of ranges instead of a using bitmap to
>      track all of guest memory.  For most use cases, the vast majority of guest
>      memory will be private, most ranges will be 2mb+, and conversions between
>      private and shared will be uncommon events, i.e. the overhead to walk and
>      split/merge list entries is hopefully not a big concern.  I suspect a list
>      would consume far less memory, hopefully without impacting performance.

For a fancier data structure, I'd suggest an interval tree. Linux
already has an rbtree-based interval tree implementation, which would
likely work, and would probably assuage any performance concerns.

Something like this would not be worth doing unless most of the shared
pages were physically contiguous. A sample Ubuntu 20.04 VM on GCP had
60ish discontiguous shared regions. This is by no means a thorough
search, but it's suggestive. If this is typical, then the bitmap would
be far less efficient than most any interval-based data structure.

You'd have to allow userspace to upper bound the number of intervals
(similar to the maximum bitmap size), to prevent host OOMs due to
malicious guests. There's something nice about the guest donating
memory for this, since that would eliminate the OOM risk.
