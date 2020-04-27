Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A391BAB6E
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 19:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgD0Rhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 13:37:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgD0Rhz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 13:37:55 -0400
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C7A621556
        for <kvm@vger.kernel.org>; Mon, 27 Apr 2020 17:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588009074;
        bh=CRnrGSfeXKE04SYiSfLjK47OzoOEUP1L82XDJvKWoR4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nu+Pwm8C7ZzEGBJLMJ9VwcO6z51c/SaWNuYsdGhtItHu3A+6FYmc/eXSNmTVAb2uK
         tneA1fuX8ZfPP79F3RSubUzWXXK8kKasgds0aHFbkTeJbXUGK2foYTtQ/f6xlDFlN3
         djowQs6+Y1171rpUGBcqSzTO520lNKT2mJFacNgE=
Received: by mail-wr1-f54.google.com with SMTP id g13so21536214wrb.8
        for <kvm@vger.kernel.org>; Mon, 27 Apr 2020 10:37:54 -0700 (PDT)
X-Gm-Message-State: AGi0PubQWYSiHMVHzXbopjntRHEum32hNBhuUbYK9XBhcKOP4w8i11YT
        lK7ijgTgVRSzWJkSfy1Q6V9+WU/IqL3ygA1EAQO7xg==
X-Google-Smtp-Source: APiQypK2liBn30m34/Dp/fYtTgQDcIlhKU2o3YS7OuvYuy5s6viTinmEVCuKGI6u9wjEWkrN2rR1dZgH24YAvZ+2RGI=
X-Received: by 2002:adf:f648:: with SMTP id x8mr27923047wrp.257.1588009072661;
 Mon, 27 Apr 2020 10:37:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200425191032.GK21900@8bytes.org> <910AE5B4-4522-4133-99F7-64850181FBF9@amacapital.net>
 <20200425202316.GL21900@8bytes.org> <CALCETrW2Y6UFC=zvGbXEYqpsDyBh0DSEM4NQ+L=_pp4aOd6Fuw@mail.gmail.com>
In-Reply-To: <CALCETrW2Y6UFC=zvGbXEYqpsDyBh0DSEM4NQ+L=_pp4aOd6Fuw@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 27 Apr 2020 10:37:41 -0700
X-Gmail-Original-Message-ID: <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
Message-ID: <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
Subject: Should SEV-ES #VC use IST? (Re: [PATCH] Allow RDTSC and RDTSCP from userspace)
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Mike Stunes <mstunes@vmware.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Juergen Gross <JGross@suse.com>,
        Jiri Slaby <jslaby@suse.cz>, Kees Cook <keescook@chromium.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        X86 ML <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 25, 2020 at 3:10 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> On Sat, Apr 25, 2020 at 1:23 PM Joerg Roedel <joro@8bytes.org> wrote:
> >
> > On Sat, Apr 25, 2020 at 12:47:31PM -0700, Andy Lutomirski wrote:
> > > I assume the race you mean is:
> > >
> > > #VC
> > > Immediate NMI before IST gets shifted
> > > #VC
> > >
> > > Kaboom.
> > >
> > > How are you dealing with this?  Ultimately, I think that NMI will need
> > > to turn off IST before engaging in any funny business. Let me ponder
> > > this a bit.
> >
> > Right, I dealt with that by unconditionally shifting/unshifting the #VC IST entry
> > in do_nmi() (thanks to Davin Kaplan for the idea). It might cause
> > one of the IST stacks to be unused during nesting, but that is fine. The
> > stack memory for #VC is only allocated when SEV-ES is active (in an
> > SEV-ES VM).
>
> Blech.  It probably works, but still, yuck.  It's a bit sad that we
> seem to be growing more and more poorly designed happens-anywhere
> exception types at an alarming rate.  We seem to have #NM, #MC, #VC,
> #HV, and #DB.  This doesn't really scale.

I have a somewhat serious question: should we use IST for #VC at all?
As I understand it, Rome and Naples make it mandatory for hypervisors
to intercept #DB, which means that, due to the MOV SS mess, it's sort
of mandatory to use IST for #VC.  But Milan fixes the #DB issue, so,
if we're running under a sufficiently sensible hypervisor, we don't
need IST for #VC.

So I think we have two choices:

1. Use IST for #VC and deal with all the mess that entails.

2. Say that we SEV-ES client support on Rome and Naples is for
development only and do a quick boot-time check for whether #DB is
intercepted.  (Just set TF and see what vector we get.)  If #DB is
intercepted, print a very loud warning and refuse to boot unless some
special sev_es.insecure_development_mode or similar option is set.

#2 results in simpler and more robust entry code.  #1 is more secure.

So my question is: will anyone actually use SEV-ES in production on
Rome or Naples?  As I understand it, it's not really ready for prime
time on those chips.  And do we care if the combination of a malicious
hypervisor and malicious guest userspace on Milan can compromise the
guest kernel?  I don't think SEV-ES is really mean to resist a
concerted effort by the hypervisor to compromise the guest.

--Andy
