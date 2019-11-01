Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1895EC8E3
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 20:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbfKATJX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 15:09:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727325AbfKATJX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 15:09:23 -0400
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF4B021D56
        for <kvm@vger.kernel.org>; Fri,  1 Nov 2019 19:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572635362;
        bh=oqQ6mc8vMOO6iFg5xkYVj8cqy2/wKHrB+ZBK7dSIJbA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dmi0sKqQdD/CtjGV934ctcBkBqjEG0DD84sdkg6g56WAc44/iodUHl2tYGNestOFC
         vZcSOUvDWCQbeR5qqWw/K67by48GtFmAqzr4y7V660wH9Jq6BXatQy0Oq3PaiGvKtK
         /nhKLYwgNrMWt/f1mOsId2LBZ+VHWPB3y+kp56T4=
Received: by mail-wr1-f47.google.com with SMTP id l10so10610801wrb.2
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2019 12:09:21 -0700 (PDT)
X-Gm-Message-State: APjAAAWkdrLIM237DQCfz2BvKnDy9gPYZALjJcHg4lUFrCm8YNWLWNty
        CKA8opVYEYinEHgo9iEvjUvw4TH/od097hTvFuJJ+g==
X-Google-Smtp-Source: APXvYqyZ9Wly2LV68S8MZlxCRLu2pe2tQOypXuB/IZXMIr+8oftULkBEVxSwZk3JFBwMfvp1qSXU2voo9srBQswlajk=
X-Received: by 2002:a5d:51c2:: with SMTP id n2mr11735442wrv.149.1572635360221;
 Fri, 01 Nov 2019 12:09:20 -0700 (PDT)
MIME-Version: 1.0
References: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com>
 <157262962352.2838.15656190309312238595.stgit@naples-babu.amd.com>
 <CALCETrUSjbjt=U6OpTFXEZsEJQ6zjcqCeqi6nSFOi=rN91zWmg@mail.gmail.com> <288d481f-43c7-ffbb-8aed-c3c4bc19846b@amd.com>
In-Reply-To: <288d481f-43c7-ffbb-8aed-c3c4bc19846b@amd.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 1 Nov 2019 12:09:06 -0700
X-Gmail-Original-Message-ID: <CALCETrX9ztjRvCMFTWrf0WgAv4C9Y9DWcxQ4bBr3ajcAWNF9ZA@mail.gmail.com>
Message-ID: <CALCETrX9ztjRvCMFTWrf0WgAv4C9Y9DWcxQ4bBr3ajcAWNF9ZA@mail.gmail.com>
Subject: Re: [PATCH 2/4] kvm: svm: Enable UMIP feature on AMD
To:     "Moger, Babu" <Babu.Moger@amd.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 1, 2019 at 11:38 AM Moger, Babu <Babu.Moger@amd.com> wrote:
>
>
>
> On 11/1/19 1:24 PM, Andy Lutomirski wrote:
> > On Fri, Nov 1, 2019 at 10:33 AM Moger, Babu <Babu.Moger@amd.com> wrote:
> >>
> >> AMD 2nd generation EPYC processors support UMIP (User-Mode Instruction
> >> Prevention) feature. The UMIP feature prevents the execution of certain
> >> instructions if the Current Privilege Level (CPL) is greater than 0.
> >> If any of these instructions are executed with CPL > 0 and UMIP
> >> is enabled, then kernel reports a #GP exception.
> >>
> >> The idea is taken from articles:
> >> https://lwn.net/Articles/738209/
> >> https://lwn.net/Articles/694385/
> >>
> >> Enable the feature if supported on bare metal and emulate instructions
> >> to return dummy values for certain cases.
> >
> > What are these cases?
>
> It is mentioned in the article https://lwn.net/Articles/738209/
>
> === How does it impact applications?
>
> When enabled, however, UMIP will change the behavior that certain
> applications expect from the operating system. For instance, programs
> running on WineHQ and DOSEMU2 rely on some of these instructions to
> function. Stas Sergeev found that Microsoft Windows 3.1 and dos4gw use the
> instruction SMSW when running in virtual-8086 mode [4]. SGDT and SIDT can
> also be used on virtual-8086 mode.
>

What does that have to do with your series?  Your series is about
enabling UMIP (or emulating UMIP -- your descriptions are quite
unclear) on AMD hardware, and the hypervisor should *not* be emulating
instructions to return dummy values.  The *guest kernel* already knows
how to emulate userspace instructions as needed.

--Andy
