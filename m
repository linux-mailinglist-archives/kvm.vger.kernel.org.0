Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6EC3B6B02
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 00:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236057AbhF1Wi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 18:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235195AbhF1Wi1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 18:38:27 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9817C061574
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 15:36:00 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id d21-20020a9d72d50000b02904604cda7e66so18802959otk.7
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 15:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ig38IK1Pty8SQ29kO3bVer/Wa4mSza00QPZmDfzYxTE=;
        b=KusMY/u5uaeQLGnqD+utiMVdKALLm3GauRWAAHSmkmSk5rIhyQsNWcPBgV6JORnynv
         ahrZ8AwPQHzo00yEyBTQMJhF1EXNbNP7SV1VFoc/IvNupvejkDZ3OAehSJLi0Ry/ikhz
         bl5KidXnOuIrk48KXFXsMPZSqM5GXmSbnaTb2gQwkO+RxvSOdoaCr5VY7niRFgHLPmx2
         NIPWT6k5Xyzc/ATmMlunQdXHYqqhHAQDYkpwQa1RvrJ0SbOd2lkcuZ4hFH/+tZrU0U2S
         WF1L2gNNq6iCdpmov6jxk79XyiSj5t6DQkJgy4k6o8GzwYxOpov/lEbq3cuAW4cJ/jmu
         txjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ig38IK1Pty8SQ29kO3bVer/Wa4mSza00QPZmDfzYxTE=;
        b=FK9Ecrg80DPfp+Ig2GUQqIDMawx+gA31ayBm9faYqUIWZMzrZNMGH7RnCG4NMtSapZ
         7EM40m6pVSo9ijO22tVX6oD8FOR0e4/GlwYPAtecdIlld8a+NAq9+RkpnaRzHrL665I6
         Euih5tVfkLCxf6IDRqRNo+WMezpeW7GpDR3pXwkqb6NR07U4vCCGJ3n9z8wszAdqQ296
         B0AHvQRshVdBSw1S056YvEHKKcJtQTZco+JPS1ChUHu/XFGLxYCqTX5zkXbj28w/90fx
         JvmS/WCJCm+/3Hf2MYzbD+9ENpYEYStVAaFWHpmOcEzxX3kKQ0qnaMT/sI0XeUCIBzmh
         oifw==
X-Gm-Message-State: AOAM531O+Il3WlwPvV97JfqaoUeWH6BXsfPg4TZiU/8BGwzdEGHsRcjW
        F2vhsXf/6XCUBXJvvQi1cbfOWXd5bEB8CdhFF5jr/w==
X-Google-Smtp-Source: ABdhPJzrOXUYPX4il0/7KPy8wXHyAHVtoOrEreiL0W5dnTQEZBOb+4KJRcVfAxi0JXov0uWSxqrGkAmLhgowUoQbFFs=
X-Received: by 2002:a9d:67ce:: with SMTP id c14mr389131otn.295.1624919760073;
 Mon, 28 Jun 2021 15:36:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210627233819.857906-1-stsp2@yandex.ru> <CALMp9eQdxTy4w6NBPbXbJEpyatYB_zhiwykRKCpeoC9Cbuv5gw@mail.gmail.com>
 <de0a87e6-6e2a-bb0c-d3ef-3a70347d59c0@yandex.ru>
In-Reply-To: <de0a87e6-6e2a-bb0c-d3ef-3a70347d59c0@yandex.ru>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 28 Jun 2021 15:35:48 -0700
Message-ID: <CALMp9eSW6ZuLbbrosJtG=ejjQCRDuPBs_g4j3SXPZXHjQ7zqDg@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Fix exception untrigger on ret to user
To:     stsp <stsp2@yandex.ru>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 28, 2021 at 3:23 PM stsp <stsp2@yandex.ru> wrote:
>
> 28.06.2021 19:19, Jim Mattson =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > It seems to me that the crux of the problem here is that
> > run->ready_for_interrupt_injection returns true when it should return
> > false. That's probably where you should focus your efforts.
>
> OK, it was occasionally found that
> it actually worked that way in the
> past. This patch:
> https://www.lkml.org/lkml/2020/12/1/324
> from Paolo removes the
> !kvm_event_needs_reinjection(vcpu)
> check.
>
> Paolo, maybe you can comment?
>
>
> > This isn't CPU-specific. Even when using EPT, you can potentially end
> > up in this state after an EPT violation during IDT vectoring.
>
> Well, in that case you will at
> least return the proper status
> about the EPT violation.
> But for EINTR this is definitely
> going to be CPU-specific.

No; it's not. After fixing up the EPT violation, when the interrupted
IDT vectoring operation is reinjected via the VM-entry
interruption-information field, you can still get kicked out of the
vcpu run loop by an alarm, and you're in exactly the same boat.

> And a rather nasty one: running
> a ring3 guest with CPL=3D0 and IF
> always set, and having to check
> for ready_to_injection upon EINTR
> on just one CPU, is very unexpected.

You should *always* be checking ready_for_interrupt_injection before
injecting an interrupt, regardless of CPU. That's the API.

> So I won't be claiming that Paolo's
> patch is incorrect. Maybe someone
> can think of the way to just not
> get such scenario on EINTR?

How long are you willing to defer the EINTR? What if you're running at
the target of a live migration, and the guest's IDT page needs to be
demand-fetched over the network? It may be quite some time before you
can actually deliver that exception.
