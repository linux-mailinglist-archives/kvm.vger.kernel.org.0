Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0115D1B89BA
	for <lists+kvm@lfdr.de>; Sun, 26 Apr 2020 00:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgDYWKn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 18:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:32770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgDYWKn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 18:10:43 -0400
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD2BF21841
        for <kvm@vger.kernel.org>; Sat, 25 Apr 2020 22:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587852642;
        bh=xuqmIzDpOCho8iZFxLKt+Gkxw+5vPYAZTLSjtItPycU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VQq6Mz7smcr3zNIcC9pKupyHyFvsFY8q4jW93o4Pvp61DKtny6S1PN1CVtESTMt1x
         0YOy/VXa+OfZBvFpSU6eteA54tRtaoUDqUeg9gPjIMkG43XV6c3n6wN2gXYsQk4uLU
         CqnubEshLb3LjDTEOxBI+/8+ibDs0pY1ir/VgnPY=
Received: by mail-wr1-f49.google.com with SMTP id d17so15967605wrg.11
        for <kvm@vger.kernel.org>; Sat, 25 Apr 2020 15:10:42 -0700 (PDT)
X-Gm-Message-State: AGi0PuaLYOCZKlkP8h4Ng8vBvxvgXX6/jPzchmcX/dlojpX5d9CLMJJT
        qMLl876L+kiDCVP+sJFqyHu3se/9u481jSxP+Hd1Ww==
X-Google-Smtp-Source: APiQypJY9gdxtTJ8GRawCUdcR1DxC8wlogE3i2vYIogcFwlTEoBRip4uY50PmovAxmm9X2kGA1bOgOh4cBwbd1QBjkA=
X-Received: by 2002:a5d:62cc:: with SMTP id o12mr18433808wrv.75.1587852641044;
 Sat, 25 Apr 2020 15:10:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200425191032.GK21900@8bytes.org> <910AE5B4-4522-4133-99F7-64850181FBF9@amacapital.net>
 <20200425202316.GL21900@8bytes.org>
In-Reply-To: <20200425202316.GL21900@8bytes.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 25 Apr 2020 15:10:29 -0700
X-Gmail-Original-Message-ID: <CALCETrW2Y6UFC=zvGbXEYqpsDyBh0DSEM4NQ+L=_pp4aOd6Fuw@mail.gmail.com>
Message-ID: <CALCETrW2Y6UFC=zvGbXEYqpsDyBh0DSEM4NQ+L=_pp4aOd6Fuw@mail.gmail.com>
Subject: Re: [PATCH] Allow RDTSC and RDTSCP from userspace
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Andy Lutomirski <luto@kernel.org>, Joerg Roedel <jroedel@suse.de>,
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
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 25, 2020 at 1:23 PM Joerg Roedel <joro@8bytes.org> wrote:
>
> On Sat, Apr 25, 2020 at 12:47:31PM -0700, Andy Lutomirski wrote:
> > I assume the race you mean is:
> >
> > #VC
> > Immediate NMI before IST gets shifted
> > #VC
> >
> > Kaboom.
> >
> > How are you dealing with this?  Ultimately, I think that NMI will need
> > to turn off IST before engaging in any funny business. Let me ponder
> > this a bit.
>
> Right, I dealt with that by unconditionally shifting/unshifting the #VC IST entry
> in do_nmi() (thanks to Davin Kaplan for the idea). It might cause
> one of the IST stacks to be unused during nesting, but that is fine. The
> stack memory for #VC is only allocated when SEV-ES is active (in an
> SEV-ES VM).

Blech.  It probably works, but still, yuck.  It's a bit sad that we
seem to be growing more and more poorly designed happens-anywhere
exception types at an alarming rate.  We seem to have #NM, #MC, #VC,
#HV, and #DB.  This doesn't really scale.

--Andy
