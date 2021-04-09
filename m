Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BC53591E4
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 04:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbhDICOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 22:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbhDICOm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 22:14:42 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DADC061760
        for <kvm@vger.kernel.org>; Thu,  8 Apr 2021 19:14:30 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id w31-20020a9d36220000b02901f2cbfc9743so4296793otb.7
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 19:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eXmJQ1AQ2dRLJ4BxuERMk4u8MbmU3jknhUZiqY1lU/Q=;
        b=DTIkRQpR73KkDZBJlGU97X8eDtqylL6AGiQOOoeDgZcb5WcTxmNNZIw0z0TJy+GHCy
         WDfzAfiRT1ssFIb43yj0mOciKngoXBP4SgV4mIZR3yDFNKlxVBgtZ/e7HvXrcMRwg/9Y
         dOasV7mDxdTcf1PG9Y+GImNzcdnwx9R5ZKOE3ghGbLHixviFyNav5oX+YyMliFIVW/nU
         OsJju4ipGuHl+gcZWZnezkkjmgBhPL9gstF1wc4uDurM9qQGMzgx1mpMk1n1RZYJsew5
         fJ1KF4hAeXKwN0gUr7xgtmxLzXOF+Pih46HvgFv5GCE+EW+dj2K7grBipw/bNI1WwSY2
         /5Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eXmJQ1AQ2dRLJ4BxuERMk4u8MbmU3jknhUZiqY1lU/Q=;
        b=Q4DCce05gOkzG6XwAUJpKH/ksYXXc+/CBZv6pc7NJq9mCqnMEN+n03m2WWofWWKLnA
         p2S/9o0efRdycepb+3P6KY9SNuldLRkp9gEyBA+gVMpsSJva39ywtYsCzpIVxuvrT08+
         ooZ3Dpjtk41PQ002T/2+rWVF9rbBurugMvpYjvdYkoswEuJIM923FFpZHRi0NqV9/w2J
         tl5OefToU4NwRXqc74IEdJrBJcaE5khdd83qVIM4NB8bvmt1/7K6IHTImz+FWPE/vI3t
         9s4gGaCMl2ikc1DiGrqKAJckwgPdIMkbfU9D2r7BLGOTUU5pkfl87vtQqIssxWlass7Y
         Go7A==
X-Gm-Message-State: AOAM53118Io1yDWy/6Ipbe9GKfibZdVFoeJ9gX6RWIzdpW4wwKNjFTNr
        BCUd9Z1dbKLy3BmL9rMqBH1NQDzdGpAQFoNS95w=
X-Google-Smtp-Source: ABdhPJwgM8xvPK7XoMLDwmCEzPt1KNcZ9oblpitnqOqMICSSQdtqJKbLXcogRDAU9M8eU+rxfQUTXRelLzpiOyVtp+Q=
X-Received: by 2002:a9d:470b:: with SMTP id a11mr9961591otf.254.1617934469962;
 Thu, 08 Apr 2021 19:14:29 -0700 (PDT)
MIME-Version: 1.0
References: <YGzW/Pa/p7svg5Rr@google.com> <874kgg29uo.ffs@nanos.tec.linutronix.de>
In-Reply-To: <874kgg29uo.ffs@nanos.tec.linutronix.de>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 9 Apr 2021 10:14:18 +0800
Message-ID: <CANRm+Cz4FGBOEYOc9grx76pUT8uVbPDgbvqnDiZV42LQB8GQ_A@mail.gmail.com>
Subject: Re: Commit "x86/kvm: Move context tracking where it belongs" broke
 guest time accounting
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Sean Christopherson <seanjc@google.com>,
        Michael Tokarev <mjt@tls.msk.ru>, kvm <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 8 Apr 2021 at 21:19, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Tue, Apr 06 2021 at 21:47, Sean Christopherson wrote:
> > On Tue, Apr 06, 2021, Michael Tokarev wrote:
> >> broke kvm guest cpu time accounting - after this commit, when running
> >> qemu-system-x86_64 -enable-kvm, the guest time (in /proc/stat and
> >> elsewhere) is always 0.
> >>
> >> I dunno why it happened, but it happened, and all kernels after 5.9
> >> are affected by this.
> >>
> >> This commit is found in a (painful) git bisect between kernel 5.8 and 5.10.
> >
> > Yes :-(
> >
> > There's a bugzilla[1] and two proposed fixes[2][3].  I don't particularly like
> > either of the fixes, but an elegant solution hasn't presented itself.
> >
> > Thomas/Paolo, can you please weigh in?
> >
> > [1] https://bugzilla.kernel.org/show_bug.cgi?id=209831
> > [2] https://lkml.kernel.org/r/1617011036-11734-1-git-send-email-wanpengli@tencent.com
> > [3] https://lkml.kernel.org/r/20210206004218.312023-1-seanjc@google.com
>
> All of the solutions I looked at so far are ugly as hell. The problem is
> that the accounting is plumbed into the context tracking and moving
> context tracking around to a different place is just wrong.
>
> I think the right solution is to seperate the time accounting logic out
> from guest_enter/exit_irqoff() and have virt time specific helpers which
> can be placed at the proper spots in kvm.

Good suggestion, I will have a try. :)

    Wanpeng
