Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E9B492F54
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 21:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343552AbiARU01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 15:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349022AbiARU01 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 15:26:27 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D047CC06161C
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 12:26:26 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id bu18so130638lfb.5
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 12:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=03H0oTsaoOJAVZroctwt5LNhXL/5/pvtJL1WK73zL4I=;
        b=EZI+N5TPNsYGSEEP5udv90ztg+d10rOBWo0oS6CZy6ayJg9vspmRINQQ23ZsK2x3WE
         fsVZ6UjHH11JuwZd2hHEdulDYeF0i/12p1N1+s6RAZ55S+4R0Oqe9IIPXwKFWG86TAPP
         MOOwht0RoXbyTwIzY0O/saU54N3BAvWM7e6tCAlScWSMZiXr5F2tI/kV4pApStDBfMUw
         d1JBMfvUzGjVD7DKs8P2oN54ssu0br9vA/ADCNDadV2WNfKCU+7kgpKh7+bHe9u6k/3j
         Q+Nobgcj8jm7ElmI6/ATWDOa8y4K9ktRrsOA9QZea9/WUpoQDnV4SPpO9Tz147NM/xry
         XTTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=03H0oTsaoOJAVZroctwt5LNhXL/5/pvtJL1WK73zL4I=;
        b=pLr0hdwrZlz6X+2Xf0nEyyfJpj/63S9wEJA7lGxrWfOjm8rHABW+FjClsm6QJwuF8B
         GYwAhMny102I7gTFR9rcJq4/8zY+CLE08CCuWzuy6tgiez0mjBgbOKS59yGzb/NNGwis
         V+Ub0fJfHnPD4a4lNWbHf+02hbh8nfYJNLNgeCm0T3utJ0tcqc76Ayn1seYnMJECmO0u
         MVIGffjByJIqKu4GyD4w48Tt/Dy5r7GER87vUqutH88WBDerUjvHNI0koaoU1tEec2xf
         lUouFXyHTl7gMXNZFF3+mt80zxtqLUDpRFWJXfgMD+kub+e2U+4nIPX/ZQ4vjL6pvDzu
         oNVA==
X-Gm-Message-State: AOAM533Qmlw4P5wROFQpCBpioOy8b0VcKfxMCRLwzruJj1ABsb/CtIQd
        WTrZahDdFPxSwamAxI2VrvKaWx6X46TGTvafsG+tAg==
X-Google-Smtp-Source: ABdhPJzc9ck1UwdUMMdQz8cxvECHxynhABvRW5uhhAK6Ub95oUeBsQpia1cShTVEXNHhvJ6zAxcf7fkBXyfzVdNpwGA=
X-Received: by 2002:a2e:bd11:: with SMTP id n17mr21127646ljq.508.1642537584879;
 Tue, 18 Jan 2022 12:26:24 -0800 (PST)
MIME-Version: 1.0
References: <20211222225350.1912249-1-vipinsh@google.com> <20220105180420.GC6464@blackbody.suse.cz>
In-Reply-To: <20220105180420.GC6464@blackbody.suse.cz>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 18 Jan 2022 12:25:48 -0800
Message-ID: <CAHVum0e84nUcGtdPYQaJDQszKj-QVP5gM+nteBpSTaQ2sWYpmQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
To:     =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, tj@kernel.org,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, dmatlack@google.com,
        jiangshanlai@gmail.com, kvm@vger.kernel.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Michal,

Thanks for looking into this patch. I will be using Sean's suggestion
and use real_parent of the task. This will avoid my ugly code in the
cgroup APIs.

On Wed, Jan 5, 2022 at 10:04 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrote=
:
>
> Hi Vipin.
>
> On Wed, Dec 22, 2021 at 10:53:50PM +0000, Vipin Sharma <vipinsh@google.co=
m> wrote:
> > VM worker kthreads can linger in the VM process's cgroup for sometime
> > after KVM terminates the VM process.
>
> Why is it a problem? And how long are we talking about?
>

Automated tools/scripts which delete VM cgroups after the main KVM
process ends were seeing deletion errors because kernel worker threads
were still running inside those cgroups. This is not a very frequent
issue but we noticed it happens every now and then.


> > A VM process can terminate between the time window of exit_mm() to
> > cgroup_exit(), leaving only worker kthreads in the cgroup.
>
> Even kthreads should eventually have PF_EXITING set, they shouldd be
> treated as "user-space" zombies by cgroups, i.e. mostly invisible (e.g.
> it doesn't prevent rmdir'ing the cgroup).
>

Since that eventual time period is not known, we can either pause the
script for sometime before starting the cleanup or add some x number
of retries. Both of which are not preferable due to indeterministic
nature.

> (And after the last task_struct reference is gone, the cgroup structs
> can be released too. Maybe the cause is holding the reference to the KVM
> worker thread somewhere for too long.)
>
> > Moving worker kthreads back to the original cgroup (kthreadd_task's
> > cgroup) makes sure that cgroup is empty as soon as the main VM process
> > is terminated.
>
> BTW this used to be done for "user-space" tasks too (migrate to root
> cgroup) but it was replaced with the less transactional "ignore zombies"
> approach. So this change seems inconsistent.
>
Interesting, however, until PF_EXITING is set those threads will also
exhibit the same behavior if it comes to deletion. Thanks for the
background, good to know.

Thanks
