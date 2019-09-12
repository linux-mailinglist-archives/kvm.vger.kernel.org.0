Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB6AB09D0
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 10:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbfILIAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 04:00:02 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:45598 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbfILIAC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 04:00:02 -0400
Received: by mail-vs1-f68.google.com with SMTP id s3so15572467vsi.12
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 01:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Eu/5sWvAievp6gWNiLnO5r98ZIO1VP6fR7oQzUWhDlw=;
        b=CfQF9z7U55w10dAIoGCimaGflwkjWIGEH45iZm0PFjAO1wFjSQNNyciV06xMvyDCmB
         E+uEIsdwskgYXk27+lpCwGm+l0kIKzcEczJv2EKMdTO2UkLY+NoxKxHL//KGNEXu1D6F
         ReWaXdaqGhXXK6lnbqWzN/yofK60WgReuQ9IzoFICgrUsvbtigIsSoow29zEBg2XnxAl
         BYPo1Y4kAPghj+Q/vTgBuz36157cGD1/mEQo4RR8Ycx0DNskqT8b8ag2cQ14hPplB3yQ
         1DJctQsKQk1P126KWm26fLdSwFkFDYvj6X4cTatOamqcT3z0wVvvtwhYueik+A8lvBX5
         +8Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Eu/5sWvAievp6gWNiLnO5r98ZIO1VP6fR7oQzUWhDlw=;
        b=rnbPp6YFYg/falDJADRyYuMa7fdCU4Vi/uvYd/rFb7HpSrJgzmqUw0WMI/Bl9JM6FC
         +c6ttrQfa5GR1EGW1FhlOibRtvAQnKyYiAJ/39ewNmlCNKjJ2fIIlyPwKyU9u2r10euh
         3mnPeeCpEeubfiJTkR+aQHA6SguhR8Coto499rru3o6aYNfBHcTKfOeQx8j2MBVcwegX
         utDu7YK1aRzGzZaGXLMnNwWVsqZUtsdRlPpk8SBVYRK5KOm8AdgApVxXEDNO2Zc+moIi
         ZWjcdAyYm5aj3ReQiBsML5q/O5RcY3gipZAv2Yz+XDiUOShdug5eA9UJVEhAP6xp6MuT
         pJIw==
X-Gm-Message-State: APjAAAVALYElrJOlqKd1wZ7s+RS0pPsDZk72tpqZmQDRFmIJcXbPuwlm
        AEqsl66TgoJOLYJm1i2jJn43rtQwpkEergUkNXo=
X-Google-Smtp-Source: APXvYqza2KOruKDxd8x2N4X0MTl0Q1gj7s6R5RWsJ0v+324ScPBsRTuMx6Jb9LZ8N7IQdKZkHzE9hRLeP8uf7ia9pUw=
X-Received: by 2002:a67:2d95:: with SMTP id t143mr22140210vst.47.1568275201285;
 Thu, 12 Sep 2019 01:00:01 -0700 (PDT)
MIME-Version: 1.0
References: <CA+X5Wn4CbU305tDeu4UM=rBEzVyVgf0+YLsx70RtUJMZCFhXXw@mail.gmail.com>
 <20190910183255.GB11151@linux.intel.com>
In-Reply-To: <20190910183255.GB11151@linux.intel.com>
From:   James Harvey <jamespharvey20@gmail.com>
Date:   Thu, 12 Sep 2019 03:59:50 -0400
Message-ID: <CA+X5Wn4ngf92GEU=9fuxL1FVfPtq9tJE5D5VMBq6gGp5pd4Nkw@mail.gmail.com>
Subject: Re: 5.2.11+ Regression: > nproc/2 lockups during initramfs
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Alex Willamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, gregkh@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 10, 2019 at 2:32 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Sun, Sep 08, 2019 at 06:37:43AM -0400, James Harvey wrote:
> > Host is up to date Arch Linux, with exception of downgrading linux to
> > track this down to 5.2.11 - 5.2.13.  QEMU 4.1.0, but have also
> > downgraded to 4.0.0 to confirm no change.
> >
> > Host is dual E5-2690 v1 Xeons.  With hyperthreading, 32 logical cores.
> > I've always been able to boot qemu with "-smp
> > cpus=30,cores=15,threads=1,sockets=2".  I leave 2 free for host
> > responsiveness.
> >
> > Upgrading from 5.2.10 to 5.2.11 causes the VM to lock up while loading
> > the initramfs about 90-95% of the time.  (Probably a slight race
> > condition.)  On host, QEMU shows as nVmCPUs*100% CPU usage, so around
> > 3000% for 30 cpus.
> >
> > If I back down to "cpus=16,cores=8", it always boots.  If I increase
> > to "cpus=18,cores=9", it goes back to locking up 90-95% of the time.
> >
> > Omitting "-accel=kvm" allows 5.2.11 to work on the host without issue,
> > so combined with that the only package needing to be downgraded is
> > linux to 5.2.10 to prevent the issue with KVM, I think this must be a
> > KVM issue.
> >
> > Using version of QEMU with debug symbols gives:
> > * gdb backtrace: http://ix.io/1UyO
>
> Fudge.
>
> One of the threads is deleting a memory region, and v5.2.11 reverted a
> change related to flushing sptes on memory region deletion.
>
> Can you try reverting the following commit?  Reverting the revert isn't a
> viable solution, but it'll at least be helpful to confirm this it's the
> source of your troubles.
>
> commit 2ad350fb4c924f611d174e2b0da4edba8a6e430a
> Author: Paolo Bonzini <pbonzini@redhat.com>
> Date:   Thu Aug 15 09:43:32 2019 +0200
>
>     Revert "KVM: x86/mmu: Zap only the relevant pages when removing a memslot"
>
>     commit d012a06ab1d23178fc6856d8d2161fbcc4dd8ebd upstream.
>
>     This reverts commit 4e103134b862314dc2f2f18f2fb0ab972adc3f5f.
>     Alex Williamson reported regressions with device assignment with
>     this patch.  Even though the bug is probably elsewhere and still
>     latent, this is needed to fix the regression.
>
>     Fixes: 4e103134b862 ("KVM: x86/mmu: Zap only the relevant pages when removing a memslot", 2019-02-05)
>     Reported-by: Alex Willamson <alex.williamson@redhat.com>
>     Cc: stable@vger.kernel.org
>     Cc: Sean Christopherson <sean.j.christopherson@intel.com>
>     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Yes, confirmed reverting this commit (to restore the originally
reverted commit) fixes the issue.

I'm really surprised to have not found similar reports, especially of
Arch users which had 5.2.11 put into the repos on Aug 29.  Makes me
wonder if it's reproducible on all hardware using host hyperthreading
and giving a VM > nproc/2 virtual cpus.

In the meantime, what should go into distro decisions on whether to
revert?  Since you mentioned: "Reverting the revert isn't a viable
solution."
