Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3653517B053
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 22:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgCEVLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 16:11:11 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:35229 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgCEVLL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 16:11:11 -0500
Received: by mail-io1-f66.google.com with SMTP id h8so8068823iob.2
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 13:11:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KgCiuleqCzLTSUjw22UCoY8ZDkk7GEszoFBVAof0Qx8=;
        b=Xo9Ym8orTM9HyxCSsaVHy9BymP4VD2UA8iON1jyOyciEx7yuFQ2g6QIf+oCNtf3VKB
         L/dwI6a2LpncfRwMifkF/UcA8o+ZXg2lCnfetTi8RqtExWq6NT0pp+2s5lAlI/Ej3nSb
         ccGVm74s6E1eaTDrvIiWu+2HxhA33gA48NvkSqC6zF5Ae6/mJw9iQHKLYZqw63z6edrd
         cziYbZqVklcKZ6z/wmuqPO/FTFVC6UaIpNJITYpFTRb7TEKJOQqc5hnSoEdeSWg5fwCg
         tHRmvbiyNZt7al5MhrpYknx7AuhpQOiBzg59pdlxXJ+i6IH24NDX4+2b5peE26utXGBv
         oEoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KgCiuleqCzLTSUjw22UCoY8ZDkk7GEszoFBVAof0Qx8=;
        b=CDMvn9vxD0Yb+Dp33tbWNVGrYmBRQJ+e1L1cOaxugzcvOiLaUeEXgguYEbSDBAZKoh
         soQNAtzVObmn8fRCiGS+fqe2fHkOWtFSlNv2B7D+xqGUd0OgjEGxMFNGL61AbNzedG8K
         OCEMGqZfQgjRW9g02C4pxXMIoo3ZFpcTghaJrHI/8/R5kxMo5B0LykxJO1QqGysH/Bvv
         +KKcEoGLfOCrt86ajjHqrFEEjwA90QLnCErMTJ2l2REyiZvlmvcjbSgvn2zpAFrXz1Uq
         6xti6KVc0Y+cthfGAwoANobCAk/4SYeweIbbtK6HZjZK0t8BMq9db4X+YT0NUnoL4yUF
         9tbw==
X-Gm-Message-State: ANhLgQ3vJBlxVJwf/pfe0YCMADtqtad1oGO780nJgi98EYkwipzzspmV
        zILVNg22zZwwbKPfFEzj7sKUuvAvZW0PYZHdlBbNzA==
X-Google-Smtp-Source: ADFU+vsFyC5bNS5mHTNH/+8qxZn2g9Lgm1XqoRI5hT88liOMctbkO5KYjmjv4UGZslJc50zLrCUKM9MeYbSdoFd5m1k=
X-Received: by 2002:a05:6602:27cf:: with SMTP id l15mr313933ios.70.1583442668601;
 Thu, 05 Mar 2020 13:11:08 -0800 (PST)
MIME-Version: 1.0
References: <20200305013437.8578-1-sean.j.christopherson@intel.com>
 <20200305013437.8578-5-sean.j.christopherson@intel.com> <CALMp9eRRWZ54kzMXdTqRCy2KmaUAq+HVVVzbxJNVdgktg65XCA@mail.gmail.com>
 <20200305192532.GN11500@linux.intel.com>
In-Reply-To: <20200305192532.GN11500@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 5 Mar 2020 13:10:57 -0800
Message-ID: <CALMp9eRxdGj0DL0_g-an0YC+gTMcWcSk7=md=k4-8S0Zcankbg@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] KVM: x86: Fix CPUID range checks for Hypervisor
 and Centaur classes
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Pu Wen <puwen@hygon.cn>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 5, 2020 at 11:25 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, Mar 05, 2020 at 10:43:51AM -0800, Jim Mattson wrote:
> > On Wed, Mar 4, 2020 at 5:34 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > Rework the masking in the out-of-range CPUID logic to handle the
> > > Hypervisor sub-classes, as well as the Centaur class if the guest
> > > virtual CPU vendor is Centaur.
> > >
> > > Masking against 0x80000000 only handles basic and extended leafs, which
> > > results in Hypervisor range checks being performed against the basic
> > > CPUID class, and Centuar range checks being performed against the
> > > Extended class.  E.g. if CPUID.0x40000000.EAX returns 0x4000000A and
> > > there is no entry for CPUID.0x40000006, then function 0x40000006 would
> > > be incorrectly reported as out of bounds.
> > >
> > > While there is no official definition of what constitutes a class, the
> > > convention established for Hypervisor classes effectively uses bits 31:8
> > > as the mask by virtue of checking for different bases in increments of
> > > 0x100, e.g. KVM advertises its CPUID functions starting at 0x40000100
> > > when HyperV features are advertised at the default base of 0x40000000.
> > >
> > > The bad range check doesn't cause functional problems for any known VMM
> > > because out-of-range semantics only come into play if the exact entry
> > > isn't found, and VMMs either support a very limited Hypervisor range,
> > > e.g. the official KVM range is 0x40000000-0x40000001 (effectively no
> > > room for undefined leafs) or explicitly defines gaps to be zero, e.g.
> > > Qemu explicitly creates zeroed entries up to the Cenatur and Hypervisor
> > > limits (the latter comes into play when providing HyperV features).
> > >
> > > The bad behavior can be visually confirmed by dumping CPUID output in
> > > the guest when running Qemu with a stable TSC, as Qemu extends the limit
> > > of range 0x40000000 to 0x40000010 to advertise VMware's cpuid_freq,
> > > without defining zeroed entries for 0x40000002 - 0x4000000f.
> > >
> > > Note, documentation of Centaur/VIA CPUs is hard to come by.  Designating
> > > 0xc0000000 - 0xcfffffff as the Centaur class is a best guess as to the
> > > behavior of a real Centaur/VIA CPU.
> >
> > Don't forget Transmeta's CPUID range at 0x80860000 through 0x8086FFFF!
>
> Hmm, is it actually needed here?  KVM doesn't advertise support for that
> range in KVM_GET_SUPPORTED_CPUID.  That's also why I limited the Centaur
> range to vendor==CENTAUR, as KVM_GET_SUPPORTED_CPUID enumerates the
> Centaur range if and only if the host CPU is Centaur.

Ah. So cross-vendor CPUID specifications are not supported?
