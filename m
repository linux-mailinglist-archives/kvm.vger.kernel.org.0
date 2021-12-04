Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0DC2468253
	for <lists+kvm@lfdr.de>; Sat,  4 Dec 2021 06:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhLDFR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Dec 2021 00:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhLDFR4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Dec 2021 00:17:56 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98340C061751
        for <kvm@vger.kernel.org>; Fri,  3 Dec 2021 21:14:31 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id h19-20020a9d3e53000000b0056547b797b2so6177437otg.4
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 21:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y/BPPy9m8im+hhuoZQePxpZc51/ab2hLFWDQfb5X/9I=;
        b=H/yNUwm9CmyzcLUNDWhTAbx9TbIVhmUtwt6S8HUeOWOQUkumfeJyGUUBwJZCkQCGEU
         Wd5v6YpjOsoRq+h9GBVAuMtKOkHWzYBXzGI/hojTku8VZe0d9CuWMfyV72VPe4Py4DQU
         RAyZwjgaTFtPBYZMNLJmYJAPkRZAVt5IqbAuuKXaEP5X0r/tyY7PPBA4+IMB/0ZsmJkg
         BdhsVki9tZHwgatH9YKV+VFltcFLkLMbljykbb2zQ3yusTle/TLdcx9Qi6Wm66Ahm+V/
         Oyn6yc2xM28C8AgaLPkN+cqwLDtuQtDm2F0hPD0elLYgtMFTyRTS7Y2QzS8SexxWs25E
         ENtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y/BPPy9m8im+hhuoZQePxpZc51/ab2hLFWDQfb5X/9I=;
        b=zwIzD1X9lfPbOXfiif/ioU703wKh86KXmb4/ORwDa15jAGSVqRh0dRwASeE1Hk2hdV
         1LVMIdQ2IacNkIm8u9h1+YLaw9chkUttulSNMsy0ttMNwQzu6Ydjg1fZ/OBsFiNcAcPg
         ScU4AI5WRHGATTe8xmFuSoAO51AVe8nI8OHoVZejYipEu7cKpY9vpY8pl0c4dIEenxd9
         fmbtYjCcJ7G4iRFz9CIg8YvfdsQLDxkcDKnPdCBORQhduClZOGihpXQ82aWiqNCgscmT
         nSpnVt4TDJODktVEis1nB/wjNohHLvh11L/MRpVQjKIEKDtn9xM3HdAC9rRgesYxaa7y
         luYg==
X-Gm-Message-State: AOAM533P//UKvWG2sIqzw9PX/2DY5o3vHC+vUyrSIYnUN3uqeD2JoURK
        Kog+Jw/ZZlm4JVyKUyjXmAjDs3AQHX+0DXgeb1ATaQ==
X-Google-Smtp-Source: ABdhPJxghcCQpyrr8AC+WikPzYCuxK5sEzUgYuWtzGi5NXwaoYNBCMWGWG914X6+tpfyQSCRghgwxpXCcIclt3k0vsw=
X-Received: by 2002:a9d:6389:: with SMTP id w9mr19659797otk.29.1638594870449;
 Fri, 03 Dec 2021 21:14:30 -0800 (PST)
MIME-Version: 1.0
References: <b57280b5562893e2616257ac9c2d4525a9aeeb42.1638471124.git.thomas.lendacky@amd.com>
 <YapIMYiJ+iIfHI+c@google.com> <9ac5cf9c-0afb-86d1-1ef2-b3a7138010f2@amd.com>
In-Reply-To: <9ac5cf9c-0afb-86d1-1ef2-b3a7138010f2@amd.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 3 Dec 2021 21:14:19 -0800
Message-ID: <CAA03e5EYV785FSEh2mXK=jzEhp-wM8XcaBk0S4vx7h-f7jevjA@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: Do not terminate SEV-ES guests on GHCB
 validation failure
To:     Tom Lendacky <Thomas.Lendacky@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 3, 2021 at 11:00 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 12/3/21 10:39 AM, Sean Christopherson wrote:
> > On Thu, Dec 02, 2021, Tom Lendacky wrote:
>
> >>
> >> -    return -EINVAL;
> >> +    return false;
> >
> > I'd really prefer that this helper continue to return 0/-EINVAL, there's no hint
> > in the function name that this return true/false.  And given the usage, there's
> > no advantage to returning true/false.  On the contrary, if there's a future
> > condition where this needs to exit to userspace, we'll end up switching this all
> > back to int.
>
> I don't have any objection to that.

I think Sean's review makes a pretty compelling case that we should
keep the int return value for `setup_vmgexit_scratch()`. In
particular, failing to allocate a host kernel buffer definitely seems
like a host error that should return to userspace. Though, failing to
read the guest GPA seems less clear cut on who is at fault (host vs.
guest), as Tom mentioned. My understanding from the commit description
is that the entire point of the patch is to protect the guest from
mis-behaving guest userspace code. So I would think that if we have a
case like mapping the guest GPA that could fail due to the guest or
the host, we should probably go ahead and use the new GHCB error codes
to return back to the guest in this case. But either way, having an
int return code seems like the way to go for
`setup_vmgexit_scratch()`. Because if we are wrong in either
direction, it's a trivial fix.

It's not as obvious to me that converting `sev_es_validate_vmgexit()`
to return a bool is not cleaner than returning an int. This function
seems to pretty much just process the GHCB buffer as a self-contained
set of bits. So it's hard to imagine how this could fail in a way
where exiting to userspace is the right thing to do. That being said,
I do not have a strong objection to returning an int. Sean is right
that an int is definitely more future proof. And I'm sure Sean (and
Tom) have much better insight into how validating the bits written
into the GHCB could potentially require code that could justify
exiting out to userspace.
