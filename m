Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9065935F0E2
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 11:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhDNJgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 05:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbhDNJgr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 05:36:47 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0E9C061574;
        Wed, 14 Apr 2021 02:36:26 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id i16-20020a9d68d00000b0290286edfdfe9eso8159022oto.3;
        Wed, 14 Apr 2021 02:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LvbZE0bzJgrJNxl8GOScMXc9Qv71H83ehJgok/+nI18=;
        b=ZccMPBQpA/Tr1GdFRu5OeEnZtZAquSH6eVDJrQ7DgAUzXxScqEoMmprhaKWWnZZLd+
         kSZ1Zzj8EV07gP5pRwhXrt2ty6rNIjSb7C2Jm3f0uxROrwj+iNevPSvcyS8zCV6mNOQB
         8Zlt2Ut5MPYj7fEF6eYDfNMOjQgaVu+GVqJkd8v3HektiFEb1GzjuzLqBA3WV/HGOpK1
         JdVN8Q6sLHswNma4VUoBRZnZ5bsdMSQxtqvlEB+gSaF+8fuRi6rrzAzKSPzzN5jKsreH
         o0difFaPjNG4Rc2VtaY5+ZmhXQ0spDVkZjL8Nj1RqSRg7H7sYOchnJne9VdgmMAZTTbv
         kA6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LvbZE0bzJgrJNxl8GOScMXc9Qv71H83ehJgok/+nI18=;
        b=oih2VjPHBvt89xwvdR+6b2dcK8PXmf3CHh8v8z46N0+HvYPWxNSP7GolirkcTvTzbm
         xgYuNb4y8YItqI0NzQnKRrTOi+vhW32nhuVNLRq7axpEl5XZczaOoPRIj6fFK3Tc+Y2b
         9+HhT7bFwlLKPmnbPlA7M9yGcv8NqgQkMja/J9rT/qwajqjDYYW1/efUmyNiFZ9te6re
         QP9Fd2Pe/0GXWJbOW3DxQPjuNzLv0NCr86cWoPB9qotuJuxZPjbUllZBgmQyJutI/Tmj
         7jGRB+9fS1PSBe26MV4yPeTCugJMX67M/rmaDLb6UhVnWPbVTacd9WWFGPssv90Qp5G7
         NLYA==
X-Gm-Message-State: AOAM532dR2OkNZU2z8hIW6QKXVGRzNOAShOkvw0lqxYGQ06WJBOQIMAl
        rkppBDrhrsPQYmyRKSO49cnnp4PVCcFrh2+PIiQZROsq3UI=
X-Google-Smtp-Source: ABdhPJwhHx0A2Nawso9X+DVHuSqPykG/TMxxH1T7cTxUyAKAAWfcV4q0/C4oS0nkVvuiT5rSSIkhhSx1fmFfwB2TAA0=
X-Received: by 2002:a9d:66c9:: with SMTP id t9mr2617447otm.56.1618392985669;
 Wed, 14 Apr 2021 02:36:25 -0700 (PDT)
MIME-Version: 1.0
References: <1618298169-3831-1-git-send-email-wanpengli@tencent.com> <YHXUFJuLXY8VZw3B@google.com>
In-Reply-To: <YHXUFJuLXY8VZw3B@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 14 Apr 2021 17:36:14 +0800
Message-ID: <CANRm+CzDW_5SPM0131OvRn3UPBp1nahxCykCP61XWeUpYeHU5Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] KVM: Properly account for guest CPU time
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 14 Apr 2021 at 01:25, Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Apr 13, 2021, Wanpeng Li wrote:
> > The bugzilla https://bugzilla.kernel.org/show_bug.cgi?id=209831
> > reported that the guest time remains 0 when running a while true
> > loop in the guest.
> >
> > The commit 87fa7f3e98a131 ("x86/kvm: Move context tracking where it
> > belongs") moves guest_exit_irqoff() close to vmexit breaks the
> > tick-based time accouting when the ticks that happen after IRQs are
> > disabled are incorrectly accounted to the host/system time. This is
> > because we exit the guest state too early.
> >
> > This patchset splits both context tracking logic and the time accounting
> > logic from guest_enter/exit_irqoff(), keep context tracking around the
> > actual vmentry/exit code, have the virt time specific helpers which
> > can be placed at the proper spots in kvm. In addition, it will not
> > break the world outside of x86.
>
> IMO, this is going in the wrong direction.  Rather than separate context tracking,
> vtime accounting, and KVM logic, this further intertwines the three.  E.g. the
> context tracking code has even more vtime accounting NATIVE vs. GEN vs. TICK
> logic baked into it.
>
> Rather than smush everything into context_tracking.h, I think we can cleanly
> split the context tracking and vtime accounting code into separate pieces, which
> will in turn allow moving the wrapping logic to linux/kvm_host.h.  Once that is
> done, splitting the context tracking and time accounting logic for KVM x86
> becomes a KVM detail as opposed to requiring dedicated logic in the context
> tracking code.
>
> I have untested code that compiles on x86, I'll send an RFC shortly.

We need an easy to backport fix and then we might have some further
cleanups on top.

    Wanpeng
