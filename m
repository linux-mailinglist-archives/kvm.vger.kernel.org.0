Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 097BE4A7CF3
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 01:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348616AbiBCAiR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 19:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbiBCAiP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 19:38:15 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E82C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 16:38:15 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id l12-20020a0568302b0c00b005a4856ff4ceso1070542otv.13
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 16:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YD49kdTguHzXdEG/oqx/6WenkvU1czF9ye8w1Q4r8/Y=;
        b=PiXy5UoirC2CN0Xge0pTnO6N+hpDB3V8n4jOhO4NTVbg2jc1zb2eTeHNYC5SHC51DH
         YfxPtNTK2o8LUshYqyKl0tEbZHaulksN8bKTDPiDTp/xr5l7ydHdlZb/wV+rrfHZp2y9
         GzlVoISwVkW/PgLy6ivS9Q7YJCb6ds0OWjK+hKQ1nFi/V9gVgfMF0Owe560XUhnq0dSh
         MLVJhg9cfK35ttg5OxB5jRaRWQQTSwFD4qZJmFvnLIxgquoVZSEl/jdGHk3nKyR/wj67
         CL8EQAtoloaBu2UIknoHn0Njc+PzmmNCsw1+5QD7ufgpK5PTi/4XOEIyFd65ZjBdY3pN
         XTOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YD49kdTguHzXdEG/oqx/6WenkvU1czF9ye8w1Q4r8/Y=;
        b=JZeTrPLJmWnOHTt+2UTtKnHz2RynU3EBiSeyeZvblY9yMz2t0n/UbgL8aYGfNd4Ljn
         PDJaQILPwshKrop57VDmYeW4uO2acwoU8/MpoRs3kGgYlYfhqjKCGdj3pg6JiiONlZmV
         sVuDoDL11aa2qx37ZUHbT1F0DqYKiuHP9zCE8LXjzvu+2kLPLwQ/dtYvYSY/pH+Ctnui
         MxZFk6PcEZ3Dzefumyzt52QW+VVmO1YXhsoGxUHM/QyVGSvIMG9Uy9oKTOJ2zBJ9kta8
         nZSl7pdU2FoStwZlmIhgairsKkPcQHQ7/M3LueZg+d+HJXSmxzBmUK66KHq5ofKBKGb+
         gY5w==
X-Gm-Message-State: AOAM533uqtwDs+Tdawpxht2yrG5icyX7+eibign7LREgltXvQy3mmAnA
        7g441tFKWBrRKyxOVrx9UPSPSwEbUWePIigX9CW1OA==
X-Google-Smtp-Source: ABdhPJyh8TlidN9VP8rRK7IJRqDw4+isPatiIB+c38SJWY4XA6uXyKSfLvxBjyDAUdJK6hyh+cLGXzKKGQ//QDNP1zo=
X-Received: by 2002:a05:6830:22e3:: with SMTP id t3mr18135300otc.75.1643848694369;
 Wed, 02 Feb 2022 16:38:14 -0800 (PST)
MIME-Version: 1.0
References: <20220202230433.2468479-1-oupton@google.com> <CALMp9eRotJRKXwPp=kVdfDjGBkqMJ+6wM+N=-7WnN7yr-azvxQ@mail.gmail.com>
 <Yfsi2dSZ6Ga3SnIh@google.com>
In-Reply-To: <Yfsi2dSZ6Ga3SnIh@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 2 Feb 2022 16:38:03 -0800
Message-ID: <CALMp9eRDickv-1FYvWTMpoowde=QG+Ar4VUg77XsHgwgzBtBTg@mail.gmail.com>
Subject: Re: [PATCH 0/4] KVM: nVMX: Fixes for VMX capability MSR invariance
To:     Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 2, 2022 at 4:33 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Feb 02, 2022, Jim Mattson wrote:
> > On Wed, Feb 2, 2022 at 3:04 PM Oliver Upton <oupton@google.com> wrote:
> > >
> > > Ultimately, it is the responsibility of userspace to configure an
> > > appropriate MSR value for the CPUID it provides its guest. However,
> > > there are a few bits in VMX capability MSRs where KVM intervenes. The
> > > "load IA32_PERF_GLOBAL_CTRL", "load IA32_BNDCFGS", and "clear
> > > IA32_BNDCFGS" bits in the VMX VM-{Entry,Exit} control capability MSRs
> > > are updated every time userspace sets the guest's CPUID. In so doing,
> > > there is an imposed ordering between ioctls, that userspace must set MSR
> > > values *after* setting the guest's CPUID.
> >
> >  Do you mean *before*?
>
> No, after, otherwise the CPUID updates will override the MSR updates.

Wasn't that the intention behind this code in the first place (to
override KVM_SET_MSR based on CPUID bits)? If not, what was the
intention behind this code?
