Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D121D4C79BC
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 21:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbiB1UIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 15:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiB1UI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 15:08:29 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8131A63BFD
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 12:07:44 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id 189-20020a4a03c6000000b003179d7b30d8so20099014ooi.2
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 12:07:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hkGtpfDWoxhU+WXXG5JXImCthpIlrVBbWwN0Two57tY=;
        b=IgaWMu7GZT5WuYn/pDSLQPaiewIaWrh0az8EgyPHcOCsezh/XA6Vj2YDlFtSKqUTCi
         s5GzzGpUSTc2IoHb3BDVpNZbjxIYU4jqUUl1e2iyn+58HqeZ8t+vdHKq7/NGS3N7++hJ
         PwRnrGsau60B7Utb/d/UwW0gpaM9+a+pWxa0a68++esMAqjh5+bSVAGQMRxkH+SGyka1
         exCccq4C4k6mWllkr1w5gE714zXUHn38uP8fhresyahEycn3urK490eqd8mjMSI+IuWb
         u+eNHQLc/fDtjanxUMoOvCWHBsO+mfl/53aF62hQJ9Oq6VWz1y2SIAH4zWWw4t9jOob8
         3sDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hkGtpfDWoxhU+WXXG5JXImCthpIlrVBbWwN0Two57tY=;
        b=Peg8uGluzy/cx74mgbl9NhPKhlVPLl7NVdllvrdCbW0oouD/s436lSKspnU9LI6Iew
         ix6now+7szvU3pF0u3Gv24izfwq++3e6BWzmQQVi4LHOS5VkRsjygfobXKkr8lhMuTVq
         17cV2snTtu0vJRVCe7fO1iklwa4FMlO4suU0ErRD+1RJr3NalcOgTaVnxup9vUKf+nk8
         izs9QBnE06mSjxdCKC5p2eVvJDrWkCJXf/C6cVduyQveIzisFv8ABYCY77wLMQ3SWaPx
         etyRPHU6tnH9z4EpE9XnoyrrnGMMFVNVTzbKDXvYMRtW1AOG72ysGqCkLto26QV+J2Aj
         PUmA==
X-Gm-Message-State: AOAM530NKicqj8Rhbai5RMxHSbawtkTeCVZCCkN6J6K1XV9gOg1x+ZLu
        DUAugpo/GBTmxhmLVWpBjg3c7eo2nR3z+p6u6kYS+w==
X-Google-Smtp-Source: ABdhPJyHDr2nDUg5WulHR8LlPcQt/nMjDCJNnkGGggSveAxdsGq4VeB8pWaHeNq8XbmDMBxT0jSk4sWxeRxoTKCaCwQ=
X-Received: by 2002:a05:6871:1d6:b0:d6:ccb6:94e6 with SMTP id
 q22-20020a05687101d600b000d6ccb694e6mr9289625oad.68.1646078863561; Mon, 28
 Feb 2022 12:07:43 -0800 (PST)
MIME-Version: 1.0
References: <20220226234131.2167175-1-jmattson@google.com> <53954c03-49ff-c84e-e062-142e103f735c@gmail.com>
In-Reply-To: <53954c03-49ff-c84e-e062-142e103f735c@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 28 Feb 2022 12:07:32 -0800
Message-ID: <CALMp9eRGj1M38k0ABpg8VNGtq=ZUx4sHzaE5HkfRJYgNbiZ5mA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/svm: Clear reserved bits written to PerfEvtSeln MSRs
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     pbonzini@redhat.com, Lotus Fenn <lotusf@google.com>,
        kvm list <kvm@vger.kernel.org>,
        "Bangoria, Ravikumar" <ravi.bangoria@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 28, 2022 at 12:27 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 27/2/2022 7:41 am, Jim Mattson wrote:
> > AMD EPYC CPUs never raise a #GP for a WRMSR to a PerfEvtSeln MSR. Some
> > reserved bits are cleared, and some are not. Specifically, on
> > Zen3/Milan, bits 19 and 42 are not cleared.
>
> Curiously, is there any additional documentation on what bits 19 and 42 are for?
> And we only need this part of logic specifically for at least (guest cpu model)
> Zen3.

With the help of an older revision of the APM I found at
https://www.ii.uib.no/~osvik/x86-64/24593.pdf, we can see that bit 19,
on AMD as well as Intel, is the deprecated "Pin Control" bit. I
believe bit 42 is new on Zen3/Milan, but aside from being useful for
fixing erratum #1292, I don't have any idea what it does. Note that
bits 40 and 41 were reserved bits before SVM was introduced, and
should be treated as such for VMs that do not support SVM. Hence, the
motivation for this change is still, as previously mentioned, the
egregious behavior of the Intel perf subsystem with respect to the
Host-Only bit. This is necessary for all AMD vCPUs that do not support
SVM, regardless of model.

> >
> > When emulating such a WRMSR, KVM should not synthesize a #GP, > regardless of which bits are set. However, undocumented bits should
>
> If KVM chooses to emulate different #GP behavior on AMD and Intel for
> "reserved bits without qualification"[0], there should be more code for almost
> all MSRs to be checked one by one.

I think you are manufacturing a problem that doesn't exist.

> [0] "If a field is marked reserved without qualification, software must not
> change the state of that field; it must reload that field with the same value
> returned from a prior read."

Unfortunately, some software (e.g. Linux perf) ignores this
restriction. If, in spite of its misbehavior, the software works fine
on bare metal, we should do whatever is necessary to make it work in a
VM as well.

> > not be passed through to the hardware MSR. So, rather than checking
> > for reserved bits and synthesizing a #GP, just clear the reserved
> > bits.
>
> wrmsr -a 0xc0010200 0xfffffcf000280000
> rdmsr -a 0xc0010200 | sort | uniq
> # 0x40000080000 (expected)
>
> According to the test, there will be memory bits somewhere on the host
> recording the bit status of bits 19 and 42.
>
> Shouldn't KVM emulate this bit-memory behavior as well ?

I'm happy to revert your change that added bit 19 to the reserved
bits. I can remove bit 42 as well, but I don't see the need. Bit 42,
unlike bit 19, has never been documented.

> >
> > This may seem pedantic, but since KVM currently does not support the
> > "Host/Guest Only" bits (41:40), it is necessary to clear these bits
>
> I would have thought you had code to emulate the "Host/Guest Only"
> bits for nested SVM PMU to fix this issue fundamentally.

GCP doesn't support nested SVM at all, so we have no such code.
Regardless, as you can see from the old APM referenced above, these
bits were reserved on AMD CPUs that don't support SVM. They should
also be reserved on virtual CPUs that don't support SVM. That much, at
least, KVM gets right today.

> > rather than synthesizing #GP, because some popular guests (e.g Linux)
> > will set the "Host Only" bit even on CPUs that don't support
> > EFER.SVME, and they don't expect a #GP.
>
> IMO, this fix is just a reprieve.
>
> The logic of special handling of #GP only for AMD PMU MSR's
> "reserved without qualification" bits is asymmetric in the KVM/svm
> context and will confuse users even more.

I'm happy to entertain alternative suggestions.
