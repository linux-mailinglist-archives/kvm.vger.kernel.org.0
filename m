Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF14C48CEA4
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 00:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234937AbiALXBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 18:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234747AbiALXBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 18:01:45 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F643C06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 15:01:45 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id s22so5344222oie.10
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 15:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H4lheeV5kIfTrFQIbf1Q2cy1E6K3tAamGXUKHaseCAM=;
        b=eANKUfUqNaiXf+4ydsoDgFJQUDyAvSmKJ9IKMgZw/D5Q3bbIeBvghBv8euKXG7KT9g
         Ke5KMbfYnnzEHA951iHW527Lozq52zu8RLdhbCjC16YKjxdhVr+iku2iLiHKCUFNHHcl
         +HV0NQ9Y0i75dK/ypfGDgYhBrIkMxkdsog1C41XvwqiAqXFRAgPziFpK2zGRQYFdgyz9
         GNtBJ2eQgM6BTsIyICEcXII2VQjAquL1snP39PTXKEvsXKByhr2I2hN+F0FokZ/LxkoU
         mJyDlNViOyLp7r6mg0Xmo4dsXK3/wKyOo9d8KHVH1qDqZhMmKNoRUoBC5JEUkNXKF4wd
         eUIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H4lheeV5kIfTrFQIbf1Q2cy1E6K3tAamGXUKHaseCAM=;
        b=7mjG+BWgP/BH948B59W4gTtvdMy1rQMEQJxm11xYDZtsc7VzCJdD7HLy7n9pdo+sFI
         B2H6nauizXGALihNnJut7iBpiT5HScqMINTF53qVb4eGDLrhs/o4VELnAuUb+TLKYfX5
         fdBASL2H3tvdyjZlfoVVz+jA/YS65GMrP51d6CE67bVHuIe2opL2o6IJe+ueeCDGJujS
         XTimQnmVEfvuSnVkFVXKWTea+lvOwkEb2AfTt3dBFZuP+4uLjKD9rp2ByaLv4uTzciU4
         CgbTvA4/FwTQOBNxXDkEWReO2EJt+42piaGKAtRpH6PafNjZ6jN9YWNEdsqk6IpNmDZd
         gdKw==
X-Gm-Message-State: AOAM533RmypOK8aquf4iWuswcF3R0LBaxvR32uEoe0aKByDMarLLrzeg
        2/n4OLwqQOq+QVaDD/yNbzhAXd68lnMLxuys/V4smQ==
X-Google-Smtp-Source: ABdhPJxdWf39Zn8Xt27jZXInQ20nW8WFh2LcZegM4iNXs0UA2Nzg94tzhYKHdlpBkVIwpW2F5xJWbp1+KGS61i/tttk=
X-Received: by 2002:a05:6808:14cd:: with SMTP id f13mr1309165oiw.76.1642028504285;
 Wed, 12 Jan 2022 15:01:44 -0800 (PST)
MIME-Version: 1.0
References: <20211227081515.2088920-1-chao.gao@intel.com> <20211227081515.2088920-7-chao.gao@intel.com>
 <YdzTfIEZ727L4g2R@google.com> <20220111053205.GD2175@gao-cwp> <Yd8VSCghD3OvuGJ7@google.com>
In-Reply-To: <Yd8VSCghD3OvuGJ7@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 12 Jan 2022 15:01:32 -0800
Message-ID: <CALMp9eQKTn_oYVom8x+HU_voe+tRQTfbTsRpfQuD_JsONWvLOw@mail.gmail.com>
Subject: Re: [PATCH 6/6] KVM: Do compatibility checks on hotplugged CPUs
To:     Sean Christopherson <seanjc@google.com>
Cc:     Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, kevin.tian@intel.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022 at 9:54 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jan 11, 2022, Chao Gao wrote:
> > On Tue, Jan 11, 2022 at 12:46:52AM +0000, Sean Christopherson wrote:
> > >This has a fairly big flaw in that it prevents KVM from creating VMs even if the
> > >offending CPU is offlined.  That seems like a very reasonable thing to do, e.g.
> > >admin sees that hotplugging a CPU broke KVM and removes the CPU to remedy the
> > >problem.  And if KVM is built-in, reloading KVM to wipe hardware_incompatible
> > >after offlining the CPU isn't an option.
>
> ...
>
> > >That said, I'm not convinced that continuing with the hotplug in this scenario
> > >is ever the right thing to do.  Either the CPU being hotplugged really is a different
> > >CPU, or it's literally broken.  In both cases, odds are very, very good that running
> > >on the dodgy CPU will hose the kernel sooner or later, i.e. KVM's compatibility checks
> > >are just the canary in the coal mine.
> >
> > Ok. Then here are two options:
> > 1. KVM always prevents incompatible CPUs from being brought up regardless of running VMs
> > 2. make "disabling KVM on incompatible CPUs" an opt-in feature.
> >
> > Which one do you think is better?
>
> IMO, #1.  It's simpler to implement and document, and is less likely to surprise
> the user.  We can always pivot to #2 _if_ anyone requests the ability to dynamically
> disable KVM in order to bring up heterogenous CPUs and has a reasonable, sane use
> case for doing so.  But that's a big "if" as I would be very surprised if it's even
> possible to encounter such a setup without a hardware bug, firmware bug, and/or user
> error.

How quickly we forget the Woodcrest B/G fiasco.
