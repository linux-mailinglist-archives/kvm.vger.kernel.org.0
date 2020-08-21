Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4E724D8B6
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 17:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbgHUPgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 11:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgHUPgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 11:36:09 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C211C061573;
        Fri, 21 Aug 2020 08:36:09 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id g14so2145496iom.0;
        Fri, 21 Aug 2020 08:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dTsdEvmeR7/8ARBPzPDo5H4/RL/HljTYjHOoJ2D+HGk=;
        b=oG3H/4qgY6IZeh11qQCNeaOyHtavKEMR464ybkKS9cibi3xG6UiYZmHGSxprqoeKZx
         30qLE+paOBcBV6sGjUUx+ZmfjBIm1uFKSughgeRlfmwNpycy7r27utMOzY5z9LnVTPhg
         MYNQFCDeltwbaRNXh3WgmACm9hLemnauKbxaK5+06YZsGuRkiX31H8W1SNLrSg7KPxKs
         2Lg8QE5GpJ+9iznDvRuhrf7egkMRLyZyYAdRhUgg27xW+r2/BZCiurF3bUjYUeOwfIBL
         PosLFU3dezoIHJEnGujK3dYDsEi0ulTKnMSrOBL41xPp0//84XYxMhWKjkd3RnTtMWkZ
         ln+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dTsdEvmeR7/8ARBPzPDo5H4/RL/HljTYjHOoJ2D+HGk=;
        b=G5sIOXzjbpF+p3tgjl7yS53Ab8wDuyDTEkH0SX7Ga49o8NZP7K6O4r/vUa1CSy60hq
         coNv8LUbiuFlP5S45WXFS/MdPMK8M5cdYljarFNOIxOhzNPCk6gWMKAlcmmBUZ0ERzkT
         xuFqCexfma3GevcgMBLGkT84f8OmOsQpwgX+JfNiwjxcx1efzFfuyheU9Oxvp5OklTOs
         oxECqNswjUt+ItFArouHUHaHhT1s95pzfwj4ARSmTHbCxRG3HazqhBcsSwSzjYpO/xXM
         zhHidxXax/W7sgICLC9CsIQjTTnuu2rsQdu7fjeU+kPnmccIqBKtyCNbfHCcDW+FZXpI
         bmlg==
X-Gm-Message-State: AOAM532FXLFxIkieijBphE9Mebg3g+vrp/kSSIjdZ3csRCDQnHhMNkCb
        GTAO5lwJdehhHKiRxnsOkrNLjEXA4F9vXS8cpA==
X-Google-Smtp-Source: ABdhPJw4zUY2nPRkcrI1iVgkAlff3Y8KRk0bZpGsMIrVoKZ6EshwlsivnB6CcpyYk4rmRXNlUneDcikzsDIJQXjIIao=
X-Received: by 2002:a5d:841a:: with SMTP id i26mr2754197ion.144.1598024168875;
 Fri, 21 Aug 2020 08:36:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200821105229.18938-1-pbonzini@redhat.com> <20200821142152.GA6330@sjchrist-ice>
In-Reply-To: <20200821142152.GA6330@sjchrist-ice>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Fri, 21 Aug 2020 11:35:57 -0400
Message-ID: <CAMzpN2h79bi5dd7PxjY45xYy71UdYomKa1t2gNxLtRpDkMs+Lw@mail.gmail.com>
Subject: Re: [PATCH v2] x86/entry/64: Do not use RDPID in paranoid entry to
 accomodate KVM
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Chang Seok Bae <chang.seok.bae@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andy Lutomirski <luto@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 21, 2020 at 10:22 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Aug 21, 2020 at 06:52:29AM -0400, Paolo Bonzini wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> >
> > Don't use RDPID in the paranoid entry flow, as it can consume a KVM
> > guest's MSR_TSC_AUX value if an NMI arrives during KVM's run loop.
> >
> > In general, the kernel does not need TSC_AUX because it can just use
> > __this_cpu_read(cpu_number) to read the current processor id.  It can
> > also just block preemption and thread migration at its will, therefore
> > it has no need for the atomic rdtsc+vgetcpu provided by RDTSCP.  For this
> > reason, as a performance optimization, KVM loads the guest's TSC_AUX when
> > a CPU first enters its run loop.  On AMD's SVM, it doesn't restore the
> > host's value until the CPU exits the run loop; VMX is even more aggressive
> > and defers restoring the host's value until the CPU returns to userspace.
> >
> > This optimization obviously relies on the kernel not consuming TSC_AUX,
> > which falls apart if an NMI arrives during the run loop and uses RDPID.
> > Removing it would be painful, as both SVM and VMX would need to context
> > switch the MSR on every VM-Enter (for a cost of 2x WRMSR), whereas using
> > LSL instead RDPID is a minor blip.
> >
> > Both SAVE_AND_SET_GSBASE and GET_PERCPU_BASE are only used in paranoid entry,
> > therefore the patch can just remove the RDPID alternative.
> >
> > Fixes: eaad981291ee3 ("x86/entry/64: Introduce the FIND_PERCPU_BASE macro")
> > Cc: Dave Hansen <dave.hansen@intel.com>
> > Cc: Chang Seok Bae <chang.seok.bae@intel.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Sasha Levin <sashal@kernel.org>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: kvm@vger.kernel.org
> > Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
> > Debugged-by: Tom Lendacky <thomas.lendacky@amd.com>
> > Suggested-by: Andy Lutomirski <luto@kernel.org>
> > Suggested-by: Peter Zijlstra <peterz@infradead.org>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/entry/calling.h | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
> > index 98e4d8886f11..ae9b0d4615b3 100644
> > --- a/arch/x86/entry/calling.h
> > +++ b/arch/x86/entry/calling.h
> > @@ -374,12 +374,14 @@ For 32-bit we have the following conventions - kernel is built with
> >   * Fetch the per-CPU GSBASE value for this processor and put it in @reg.
> >   * We normally use %gs for accessing per-CPU data, but we are setting up
> >   * %gs here and obviously can not use %gs itself to access per-CPU data.
> > + *
> > + * Do not use RDPID, because KVM loads guest's TSC_AUX on vm-entry and
> > + * may not restore the host's value until the CPU returns to userspace.
> > + * Thus the kernel would consume a guest's TSC_AUX if an NMI arrives
> > + * while running KVM's run loop.
> >   */
> >  .macro GET_PERCPU_BASE reg:req
> > -     ALTERNATIVE \
> > -             "LOAD_CPU_AND_NODE_SEG_LIMIT \reg", \
> > -             "RDPID  \reg", \
>
> This was the only user of the RDPID macro, I assume we want to yank that out
> as well?

No.  That one should be kept until the minimum binutils version is
raised to one that supports the RDPID opcode.

--
Brian Gerst
