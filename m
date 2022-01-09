Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72AD5488731
	for <lists+kvm@lfdr.de>; Sun,  9 Jan 2022 02:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbiAIBXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Jan 2022 20:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiAIBXd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Jan 2022 20:23:33 -0500
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCEDC061401
        for <kvm@vger.kernel.org>; Sat,  8 Jan 2022 17:23:32 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id v7-20020a4a2447000000b002daf9b0cb1eso2630757oov.8
        for <kvm@vger.kernel.org>; Sat, 08 Jan 2022 17:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KWd93wXW+PtOFmAsriAntRr2vtSjbNFJ/ENWP+nV9xk=;
        b=YuYD1WkWABq6cFSbH6lSKIHPsdEtS32k3OLqoX0GkTK0BwjfFVHZE0kjM3YJiYxvvi
         mTgRbN1YW83hMscbzxdq91Du7VZ/Re5+MOo8bZpUGVsDEd6q69xoIN00lq8a6OfewlLI
         FSTa6V4Dk8IFO1+ag7r+gLeQpIKlnOaW+w6EbAxHqvZNtiqJUIT0sETRkSlNyEuVcMs9
         ijv67wFPCgl1uV0BZiHX50BNdJ825BOD2R3LLOG0HJhqNqV/GlM4TerSfcZgfi8GhQlY
         Q1CtONLvkeBYHfEhUIyGM4G0Qw7gn4GjD5yZEbHX7jklSVJfpYF164SDG8IkZjQdu2lC
         tRWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KWd93wXW+PtOFmAsriAntRr2vtSjbNFJ/ENWP+nV9xk=;
        b=M1UdjL3tklTfuhvf/qP+6Ym5Az9ZKm/Nfj9fY0zFLci6EY97FDyxFqShA0hb4+Vh4T
         gskGSh7SDpyfQNzlkTvTFvRWQH/Bl1WkUn88sQVvFKlCmzvSGxGMSNTYChqnXRQHfLs5
         3Eu4vtvsDVjhtyldDz8YjHpm/ZYGEiUl2YFt18oVRibdTQWJdJuV8zUvHwy6erWi7TiB
         LnWGOnlbTo1PW3J2jAvIHlvrKdzCpyS88f8cGLW1dLa+bYinOelJfHwfmAZS6l+LVGNl
         dE6qKGCOGpG0RUpW29VwA6meYhWv/Lwqy+GxHlD41haZv3LcuUcncGYVRfXQh6yZ8KqQ
         Ulew==
X-Gm-Message-State: AOAM532jKp+SkDzStgSjGaBU2z2I41A5asDXyy3Pxz1IoRM9znGLKlCq
        cmiDhzSVpvT6STL2wv08ZM0C+j11+LHt8nla1s716g==
X-Google-Smtp-Source: ABdhPJy2/GJ3oPm108mq4PmY98sb07xxEeUZese8C/FIj1Gq06KYpnE52/pHsarwnMSIFWTwSks9FVLk5DZbD6PiKJs=
X-Received: by 2002:a4a:e385:: with SMTP id l5mr10684626oov.85.1641691411850;
 Sat, 08 Jan 2022 17:23:31 -0800 (PST)
MIME-Version: 1.0
References: <20211117080304.38989-1-likexu@tencent.com> <c840f1fe-5000-fb45-b5f6-eac15e205995@redhat.com>
 <CALMp9eRA8hw9zVEwnZEX56Gao-MibX5A+XXYS-n-+X0BkhrSvQ@mail.gmail.com>
 <438d42de-78e1-0ce9-6a06-38194de4abd4@redhat.com> <CALMp9eSLU1kfffC3Du58L8iPY6LmKyVO0yU7c3wEnJAD9JZw4w@mail.gmail.com>
In-Reply-To: <CALMp9eSLU1kfffC3Du58L8iPY6LmKyVO0yU7c3wEnJAD9JZw4w@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Sat, 8 Jan 2022 17:23:20 -0800
Message-ID: <CALMp9eR3PEgXhe_z8ArHK0bPeW4=htta_f3LHTm9jqL2rtcT7A@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/svm: Add module param to control PMU virtualization
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Dunn <daviddunn@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 10, 2021 at 7:48 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Fri, Dec 10, 2021 at 6:15 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 12/10/21 20:25, Jim Mattson wrote:
> > > In the long run, I'd like to be able to override this system-wide
> > > setting on a per-VM basis, for VMs that I trust. (Of course, this
> > > implies that I trust the userspace process as well.)
> > >
> > > How would you feel if we were to add a kvm ioctl to override this
> > > setting, for a particular VM, guarded by an appropriate permissions
> > > check, like capable(CAP_SYS_ADMIN) or capable(CAP_SYS_MODULE)?
> >
> > What's the rationale for guarding this with a capability check?  IIRC
> > you don't have such checks for perf_event_open (apart for getting kernel
> > addresses, which is not a problem for virtualization).
>
> My reasoning was simply that for userspace to override a mode 0444
> kernel module parameter, it should have the rights to reload the
> module with the parameter override. I wasn't thinking specifically
> about PMU capabilities.

Assuming that we trust userspace to decide whether or not to expose a
virtual PMU to a guest (as we do on the Intel side), perhaps we could
make use of the existing PMU_EVENT_FILTER to give us per-VM control,
rather than adding a new module parameter for per-host control. If
userspace calls KVM_SET_PMU_EVENT_FILTER with an action of
KVM_PMU_EVENT_ALLOW and an empty list of allowed events, KVM could
just disable the virtual PMU for that VM.

Today, the semantics of an empty allow list are quite different from
the proposed pmuv module parameter being false. However, it should be
an easy conversion. Would anyone be concerned about changing the
current semantics of an empty allow list? Is there a need for
disabling PMU virtualization for legacy userspace implementations that
can't be modified to ask for an empty allow list?
