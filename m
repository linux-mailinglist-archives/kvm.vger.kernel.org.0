Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1667641E38E
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 23:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbhI3V7H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 17:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhI3V7G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 17:59:06 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3523DC06176A
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 14:57:23 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id e15so31105380lfr.10
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 14:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1VJrgIZzgtxa6YpK70z/m29SP7Hw5UszTAKK7fc3/DA=;
        b=A5QE5aV4FIKYCFm4FmQJcVJLo3lzWAM2HM8tjo7vFO3aObQQQ6S1vDpJQNxxmaRfQb
         NV84RP6IXgMoedcU3jSVFTm7rWCTWZ3jDyux6m+dsVXjQfvMstMsaaywrhjpRc8WIMyC
         9VnoFr868cR1XBqTKlANmDLBnmPd9EqeljHG9vP8jv06ft+yU53GPjvX9cr+yQ7jK7Jh
         6vrar2o/0bvLjjcXancx3vxwwXyw4j7FjxmniEHSiMqyinpIEajGEjylyZpLzrqBskgp
         2KNOzYBGd24afmcU9Y57qwZed6D5lqOJJcVxsrYl0Z1WQkYfFAvKAXivvQUac0HuGbx2
         YwkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1VJrgIZzgtxa6YpK70z/m29SP7Hw5UszTAKK7fc3/DA=;
        b=wZcCA834xxPweQKiFTpsZcsKmFQYrrq6ZM2cw1tmio2gSCrj8dMwbi1yoZElo/HC9D
         6PsKIZL23vtnGFZgt10g8bnVh3jEq5YSwuy2vxuYhVFpnWTq7dDgv7OltDTtgHs0TNL5
         KM1xEB1G9HOw9okDT1S32zB7jnnjaa+woPYbrFSVjYvM6e6Y0IaBF5FCb6Y4w1c6oqAq
         PcZm4/FCqPa43uqtLZ8rObE5pR1Z7looDx6BBjeIYPR/slaGXr/r2t+VXXBqlF2dpAbP
         8viu3AqczIutrH2DM+i/Vo4k4n5bw9y7dC5weN6gcOndZroAxEyaWQCvctz709yuFKKv
         ngzQ==
X-Gm-Message-State: AOAM533mAzLMhIOu3YljZSiBRxCHoJqYwLgLQaV4YdYxhZMGJ8M3DPwx
        A3DLchi/YiCi6KQNIU8jn3nC1YLvsH7qu4XqMx6mpw==
X-Google-Smtp-Source: ABdhPJwNjZ1Ft7Rzgz1bsFFoRB4MAZdYHAhGAclXUZdIGmyqv+o7vcKq3MEtf03pMU0UI0S/+P5WJEKkm/8e6nprZTQ=
X-Received: by 2002:a2e:719:: with SMTP id 25mr8749326ljh.251.1633039041032;
 Thu, 30 Sep 2021 14:57:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com> <20210923191610.3814698-6-oupton@google.com>
 <878rzetk0o.wl-maz@kernel.org> <YVXvM2kw8PDou4qO@google.com>
 <CAOQ_QsjXs8sF+QY0NrSVBvO4xump7CttBU3et6V3O_hNYmCSig@mail.gmail.com> <YVX9IOb1vyoJowQl@google.com>
In-Reply-To: <YVX9IOb1vyoJowQl@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 30 Sep 2021 14:57:10 -0700
Message-ID: <CAOQ_QshZsDEt6T2=EwyzwUi-hPoz5u-BnjOnuOj=ufmRWUB=0A@mail.gmail.com>
Subject: Re: [PATCH v2 05/11] KVM: arm64: Defer WFI emulation as a requested event
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 11:08 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Sep 30, 2021, Oliver Upton wrote:
> > On Thu, Sep 30, 2021 at 10:09 AM Sean Christopherson <seanjc@google.com> wrote:
> > > Unlike PSCI power-off, WFI isn't cross-vCPU, thus there's no hard requirement
> > > for using a request.  And KVM_REQ_SLEEP also has an additional guard in that it
> > > doesn't enter rcuwait if power_off (or pause) was cleared after the request was
> > > made, e.g. if userspace stuffed vCPU state and set the vCPU RUNNABLE.
> >
> > Yeah, I don't think the punt is necessary for anything but the case
> > where userspace sets the MP state to request WFI behavior. A helper
> > method amongst all WFI cases is sufficient, and using the deferral for
> > everything is a change in behavior.
>
> Is there an actual use case for letting userspace request WFI behavior?

So for the system event exits we say that userspace can ignore them
and call KVM_RUN again. Running the guest after the suspend exit
should appear to the guest as though it had resumed. Userspace could
do something fancy to handle the suspend (save the VM, wait for an
implementation defined event) or ask the kernel to do it. To that end,
the MP state is needed to tell KVM to WFI instead of starting the
guest immediately.
