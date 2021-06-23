Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B113B1FD1
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 19:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhFWRrP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 13:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWRrO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 13:47:14 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E005DC061574
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 10:44:56 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id hc16so5196377ejc.12
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 10:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f9/U/jLXud2GQd2KmYWMdYMdKs/YOulP7g1Ex/feogc=;
        b=XJae6CI6DxRHPvJ/Z/1pUqc8nOpWrPds3nttmgbGJ1zMQPTnBszxKhOqV2vbJQ2DRz
         2gY6cYzTtNaMXcXgqBw3W5wzOmzq2G+f0pqFwhjpkG6yt5jsfFoaJi7JJ2lhE/HzDhTc
         G4SsLgySUi+X0lkmnzCHg+Q/sNfJ3j9EgxEWma8kjfmd5z+Bo3dzwJRrIq8LIIAsRHmx
         o1wDjdrWtz9W4KPL7EEHDd14VPmpFBB0nMtvntnIMktCXYHUnj4mMHoTNTBpzIT5q8gx
         lEghXhsGnc45zZs/mB54ycPs7zfhGKWlzg1TpDy15kViITPvIra5ZM3sz5mt2wRaqzBR
         00Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f9/U/jLXud2GQd2KmYWMdYMdKs/YOulP7g1Ex/feogc=;
        b=gBS+GqKnL7qbNsSxCe/P3cMcfPv3DHQQY2GXWL0Nc1EuhIAqYWyad8MF5GlKo6do+t
         iYke1Wka3i6vpzX3EYFIEKSGyecU3OzS1lAFHrxyufWe5T7uCwze2T3gRrYkNPYHjy00
         2O7p0aR/kYWzu2zOSPBAzaLs7nLtKeFftcson7IgLVUjH0CfqzPqS6oB1N1T5scztRJI
         lmqPZK3Svbtuxi4Q7uyTij0rD6sj3IXQ+4KwciZ2iY0+daE/z9JB7Dc+a9fA3RRcix8I
         3EM8jr/aVMk301ZLldoDkOfOt6ApWCXGpK4aM9qzch3sTtBxdKfkmuPml6aTyZViJeMZ
         DCaA==
X-Gm-Message-State: AOAM5335gMo6Mi/21jGfxYBXXZBI2Ncu90eKLfYE/FXN5KjPxjMGaZVE
        HTsA1dO3vmMyPHFnWTYTq+SQhoFt43gQJCNaLeAlrw==
X-Google-Smtp-Source: ABdhPJwhqoBgy2ZgFMmq67Pkgw9SZlPIpvoIsrlwm38yEl8+dz+nfbcgo5l9RSFaJ8G2LoL5ToOHQEkdJumCOIvmWVk=
X-Received: by 2002:a17:906:1c84:: with SMTP id g4mr1188496ejh.99.1624470295247;
 Wed, 23 Jun 2021 10:44:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210510144834.658457-1-aaronlewis@google.com>
 <20210510144834.658457-2-aaronlewis@google.com> <CALMp9eQ_42r-S-JPD-n7oXEaeMRVZdUG1UQkYJkhmHCSUkjvrw@mail.gmail.com>
In-Reply-To: <CALMp9eQ_42r-S-JPD-n7oXEaeMRVZdUG1UQkYJkhmHCSUkjvrw@mail.gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 23 Jun 2021 10:44:44 -0700
Message-ID: <CAAAPnDEQUG0_0+UuJoybdbQOv_p+267n_3it9m64wR1Nar7cOw@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] kvm: x86: Allow userspace to handle emulation errors
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Edmondson <david.edmondson@oracle.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 3, 2021 at 1:35 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Mon, May 10, 2021 at 7:48 AM Aaron Lewis <aaronlewis@google.com> wrote:
> >
> > Add a fallback mechanism to the in-kernel instruction emulator that
> > allows userspace the opportunity to process an instruction the emulator
> > was unable to.  When the in-kernel instruction emulator fails to process
> > an instruction it will either inject a #UD into the guest or exit to
> > userspace with exit reason KVM_INTERNAL_ERROR.  This is because it does
> > not know how to proceed in an appropriate manner.  This feature lets
> > userspace get involved to see if it can figure out a better path
> > forward.
> >
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > Reviewed-by: David Edmondson <david.edmondson@oracle.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>

Hi Paolo,

Does this change look okay to you?  Can I get it queued?

Thanks,
Aaron
