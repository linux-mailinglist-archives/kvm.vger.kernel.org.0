Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701871BBDA6
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 14:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgD1MbY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 08:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726361AbgD1MbY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 08:31:24 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D84BC03C1A9
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 05:31:24 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id b18so20046191ilf.2
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 05:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UATuAZIBTjtx/G7JbW46tayZNhYjfsptpUptS4omg1A=;
        b=OX54cm9nKZjF15wONLe0ErzdEmu/UVfZt/1SbYa7XJ7EIWdOb8iVY3Ltaq4osZIOa7
         nlNLAaDm/5y2b92kywcoV6paB5oewNgsqn6kIwr1734R681T/A9FoxjWTCM30Cf8FkgC
         cSuuqk/GUoFNQZVG8nl0qe4NubxJ3rA5PfQ+KWUxgbGj4fW5LZQGH22NkmWFUUHLFXoU
         6+ofFCgWN5Vt3pbBxBjUcp9epedDByfTnYY2XZEUahIQgARCVJ/M7aw2KTY7vcvbBpBZ
         gVYPpyUQ8JSGuVPoS0Z/go2+yvWNnzFgcIoDGUqy0O1RSGk+9i11yO/xi0aIG3DslMQ7
         VM1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UATuAZIBTjtx/G7JbW46tayZNhYjfsptpUptS4omg1A=;
        b=Pn0FP4mS8vvlrLhQZdVxTUJ2GmrBfprBuUz12Hn0J1hQ2WqnrgjVKejYvCW6eV2ZoV
         RBcn0qAqIO/j2T/Tk4183BNU/p6vRpkUfbOB2gA/lyov4g//AjADdPXLvqWM0vINP4gy
         QzqElwWrW683i1WuvS8jV1eAVSU+QHCN6wQvPm8XRErNCqJFwPQc9USmdAnuz7i8yieN
         uBVmrFVFMHUtz53mT5EgByda/Jshw/8fjA5kOH+GRosqb1NQm310wetvDteA/XMCk1oH
         WFMtqanyrzWhCo0s8q9r+SGNLcH6xRfcPjnnUg1wGQOgCliYXd3vCGdvAZSc3HTe15wS
         L2hQ==
X-Gm-Message-State: AGi0PubRLsocgH9thenFlzIyqTyz/bx6AHXJGpgqWNgouFz2qiXI5bCH
        ghgh4Zc7z+rZebmtCy3AxqZzp+wMPScRdaxlSFM=
X-Google-Smtp-Source: APiQypLPVqE/Sl1SkWYqb4KcCx+Dd7w4zhMqkkp1XoS4IOd4x0Vq9yniMsZj4jtZ75q/u1ZRX0bxF0pQOYHwzj408b8=
X-Received: by 2002:a92:5a54:: with SMTP id o81mr25315255ilb.128.1588077083956;
 Tue, 28 Apr 2020 05:31:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200426115255.305060-1-ubizjak@gmail.com> <20200427192512.GT14870@linux.intel.com>
 <CAFULd4bJR0bHCkbHdioBtKCs6=cRyrj8v6XYCezrNLUTf8OwgA@mail.gmail.com> <20200427223035.GV14870@linux.intel.com>
In-Reply-To: <20200427223035.GV14870@linux.intel.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Tue, 28 Apr 2020 14:31:12 +0200
Message-ID: <CAFULd4Zy0i_C6xDECHNkeY7kbSdQOA+qU0w6rASLoTKAcSBzNw@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: VMX: Improve handle_external_interrupt_irqoff
 inline assembly
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 12:30 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Apr 27, 2020 at 10:08:01PM +0200, Uros Bizjak wrote:
> > On Mon, Apr 27, 2020 at 9:25 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > On Sun, Apr 26, 2020 at 01:52:55PM +0200, Uros Bizjak wrote:
> > > > Improve handle_external_interrupt_irqoff inline assembly in several ways:
> > > > - use "n" operand constraint instead of "i" and remove
> > >
> > > What's the motivation for using 'n'?  The 'i' variant is much more common,
> > > i.e. less likely to trip up readers.
> > >
> > >   $ git grep -E "\"i\"\s*\(" | wc -l
> > >   768
> > >   $ git grep -E "\"n\"\s*\(" | wc -l
> > >   11
>
> ...
>
> > PUSH is able to use "i" here, since the operand is word wide. But, do
> > we really want to allow symbol references and labels here?
>
> No, but on the other hand, I doubt this particular code is going to change
> much.  I don't have a strong preference.
>
> > > >   unneeded %c operand modifiers and "$" prefixes
> > > > - use %rsp instead of _ASM_SP, since we are in CONFIG_X86_64 part
> > > > - use $-16 immediate to align %rsp
> > >
> > > Heh, this one depends on the reader, I find 0xfffffffffffffff0 to be much
> > > more intuitive, though admittedly also far easier to screw up.
> >
> > I was beaten by this in the past ... but don't want to bikeshed here.
>
> I'm good with either approach.  Same as above, the argument for keeping the
> existing code is that it's there, it works, and from some people it's more
> readable.

Thanks, I'll leave these two discussed points as they were and prepare a v3.

Uros.
