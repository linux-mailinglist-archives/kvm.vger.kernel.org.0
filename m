Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0634AA0F1
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 21:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235784AbiBDUKG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 15:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiBDUKF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 15:10:05 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9B9C061714
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 12:10:03 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id v67so9765985oie.9
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 12:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V4N6cYDAO2LskNyybNl9nWoZ7mQxBKE2Y1VMxDAj7Ik=;
        b=D3cgvDrhEXrpU1eKCS9+iTSCfix3tLtycZly6L5WfanWm0TgHm/vEHs48Ts3Vdll6u
         XcuBRc6VnayMuMehxaPXpBQf4rw5w+zOzJzxt3XIX50jGCtRqQtjNqgPvkVPMnFLe4kS
         8Nttaeoeb2FMQV3c0le6gQS9EUo/6CbAWQK4r/e7OFA1bcHJjZntvWJ22Kp76qR6m4Hx
         6jfov3ULibK4g47isbXP3d4AypVhWjRMCYg+auPqLqqjweRpglxpT5TMnq4GWoOYc7Am
         vmfgs573WB/Rgk1OyIeISIM0+dCKLmkQ/FDRx83ZZdoRY7zUQc9Zt09yFH/2SUZ2o/WE
         MEtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V4N6cYDAO2LskNyybNl9nWoZ7mQxBKE2Y1VMxDAj7Ik=;
        b=7AcaIa/m1qqs5BAWzrFNffIUF8MyGHXTnyhk7A8exguVZlwdc5krg/ak9s5iunW1a0
         wyTXiFRiKoCj5FlliMzLzH812rE3l7ViZbLH/LLsv2X1ywsp65bEFMFNlaZ/0ijKM/Jr
         /LFKcIJOAPRFEzdGQvBq/57DbQDb2jXc7MK8UMDb4wcTHYnRjGHeIfrkssMsJJxExCLL
         viqfRgMU2TDBoCypa1Mr79svm6VuXVzlmZWIK8DZZ9wklwBgg9yctQwwV0NISGjvFf4C
         WJ22eqcvTB4d+wUZU4U8nc9BeMb4bRR490brbWOKFN8gV5t44h0qL6+IaqhCAnZtFy7v
         EXoA==
X-Gm-Message-State: AOAM5316CYceURyRciRFxQezJYwm+Apat1a3KUCskBJ7YfxObLa6wrqs
        cXyWRw5GKLMGuJMtCqD3C1dvEPDlrsmmSJh275DZyg==
X-Google-Smtp-Source: ABdhPJyhjbD1PTqjvUE58jhlN6vmNnnX3owtrollNKpILa86mF6NehEDpAbqNQaILs23qzzf640yLllkaIlyHaWuzLE=
X-Received: by 2002:a05:6808:1391:: with SMTP id c17mr301643oiw.333.1644005402828;
 Fri, 04 Feb 2022 12:10:02 -0800 (PST)
MIME-Version: 1.0
References: <20220120125122.4633-1-varad.gautam@suse.com> <20220120125122.4633-3-varad.gautam@suse.com>
 <CAA03e5FbSoRo9tXwJocBtZHEc7xisJ3gEFuOW0FPvchbL9X8PQ@mail.gmail.com>
 <Yf0GO8EydyQSdZvu@suse.de> <CAA03e5HnyqZqDOyK8cbJgq_-zMPYEcrAuKr_CF8+=3DeykfV5A@mail.gmail.com>
 <Yf1UqmkfirgX1Nl+@google.com>
In-Reply-To: <Yf1UqmkfirgX1Nl+@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 4 Feb 2022 12:09:51 -0800
Message-ID: <CAA03e5G19K12UAt-1JLWXK2QEy2rSLDtzrj0LCv-DL1bYXOAsA@mail.gmail.com>
Subject: Re: [kvm-unit-tests 02/13] x86: AMD SEV-ES: Setup #VC exception
 handler for AMD SEV-ES
To:     Sean Christopherson <seanjc@google.com>
Cc:     Joerg Roedel <jroedel@suse.de>,
        Varad Gautam <varad.gautam@suse.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 4, 2022 at 8:30 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Feb 04, 2022, Marc Orr wrote:
> > On Fri, Feb 4, 2022 at 2:55 AM Joerg Roedel <jroedel@suse.de> wrote:
> > >         3) The firmware #VC handler might use state which is not
> > >            available anymore after ExitBootServices.
> >
> > Of all the issues listed, this one seems the most serious.
> >
> > >         4) If the firmware uses the kvm-unit-test GHCB after
> > >            ExitBootServices, it has the get the GHCB address from the
> > >            GHCB MSR, requiring an identity mapping.
> > >            Moreover it requires to keep the address of the GHCB in the
> > >            MSR at all times where a #VC could happen. This could be a
> > >            problem when we start to add SEV-ES specific tests to the
> > >            unit-tests, explcitily testing the MSR protocol.
> >
> > Ack. I'd think we could require tests to save/restore the GHCB MSR.
> >
> > > It is easy to violate this implicit protocol and breaking kvm-unit-tests
> > > just by a new version of OVMF being used. I think that is not a very
> > > robust approach and a separate #VC handler in the unit-test framework
> > > makes sense even now.
> >
> > Thanks for the explanation! I hope we can keep the UEFI #VC handler
> > working, because like I mentioned, I think this work can be used to
> > test that code inside of UEFI. But I guess time will tell.
> >
> > Of all the points listed above, I think point #3 is the most
> > concerning. The others seem like they can be managed.
>
>   5) Debug.  I don't want to have to reverse engineer assembly code to understand
>      why a #VC handler isn't doing what I expect, or to a debug the exchanges
>      between guest and host.

Ack. But this can also be viewed as a benefit. Because the bug is
probably something that should be followed up and fixed inside of
UEFI.

And that's my end goal. Can we reuse this work to test the #VC handler
in the UEFI?

This shouldn't be onerous. Because the #VC should follow the APM and
GHCB specs. And both UEFI and kvm-unit-tests #VC handlers should be
coded to those specs. If they're not, then one of them has a bug.

> On Thu, Jan 20, 2022 at 4:52 AM Varad Gautam <varad.gautam@suse.com> wrote:
> > If --amdsev-efi-vc is passed during ./configure, the tests will
> > continue using the UEFI #VC handler.
>
> Why bother?  I would prefer we ditch the UEFI #VC handler entirely and not give
> users the option to using anything but the built-in handler.  What do we gain
> other than complexity?

See above. If we keep the ability to run off the UEFI #VC handler then
we can get continuous testing running inside of Google to verify the
UEFI used to launch every SEV VM on Google cloud.
