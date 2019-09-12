Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 542F8B0E73
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 14:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731458AbfILMCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 08:02:33 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40534 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731106AbfILMCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 08:02:33 -0400
Received: by mail-ed1-f67.google.com with SMTP id v38so23696488edm.7;
        Thu, 12 Sep 2019 05:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=U/0egg2l/8/sf6OVNLDHzc/+TeOVJmdKP2W9EOOrXuM=;
        b=M2E++I2Ns2RrNNsY01QnhgBt0bkK9Ydxw1b0fze7A88rWXXpYBezAHPpV61/rVxlRw
         R1O7RuqhD0Hng0BwD9q0eNUnmS7OVPEWg7huYIRveHh9mQqiy2E0TA8PrGizkKs5dsm0
         PlXWRf03hbC0TK8xLq70xq0jm/qsjSf5DsRymVao9zyiQLf8gzHSGg8SOJTruCxLR/Tn
         9MUGPhrNdR745VODf31HpM6HvoglvgLTgsaUnogpfECuZkmR+Z451gq5sZ/aZY9JGZCO
         /zMBAdc+CiwjYwamTpYJAyjcE6/KB3a9l2Cg7EPxKODJt6TNJaFLfmkIs+99A+G6kz/c
         2pXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=U/0egg2l/8/sf6OVNLDHzc/+TeOVJmdKP2W9EOOrXuM=;
        b=cq1wxI17Mf2lHvxPKTO+hqbUWeoE6yRkJXedEwG4dZfxcq359o95HBY7YRY8OCCCYR
         Hk9ov0SQkGPFDUToBGXDSgi6QabJDcpBctkqn3viV6BWeVrENOVUs7OBejS8aUTEY/np
         oyUIHkv66tL3j8gJYP0wuy8uB3bgUhu4O6CH5Y+ChSnsQEZTkVDZLOdh+EUXh2kZS0Pk
         O9cDjD0LvOXm5tmgwTs2mls0hHb2b4eG4HsY8c6pccTqdqhmRNxWgKoUx4x0SNdCd48A
         vw9n8aRHLzHbcjjSrDLl5aZlLXMn6XhC2q4tiY3WCEXCX6evRSQcfHeNCDcHG3d/LAhU
         XEtA==
X-Gm-Message-State: APjAAAUDlGTiN02jMh6GaEv55hvedc9IQzL/S1efCCwxxYl7X1qbCn2g
        F8ekTl8doZ36Ba/IM7AZU3fiHaZwPkWHbiusnPZwh4tZ
X-Google-Smtp-Source: APXvYqz597d5U5MNfZEgYrRho9of5Rjo/0gxEoj4ox7+gwGIILWVaE1rASXHQ0kSA+O8fLHkpVKtvY4eMrkvGTdm5GU=
X-Received: by 2002:a05:6402:611:: with SMTP id n17mr42169718edv.33.1568289751677;
 Thu, 12 Sep 2019 05:02:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190912041817.23984-1-huangfq.daxian@gmail.com>
 <87tv9hew2k.fsf@vitty.brq.redhat.com> <CABXRUiTD=yRRQFfSdS=2e9QaO-PEgvZ=LBar927rL04G59nHxQ@mail.gmail.com>
 <87r24leqf4.fsf@vitty.brq.redhat.com>
In-Reply-To: <87r24leqf4.fsf@vitty.brq.redhat.com>
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Date:   Thu, 12 Sep 2019 20:02:20 +0800
Message-ID: <CABXRUiR0YSANWukwij0LNaJK24CiRFy878TE1AqVDAa91R-edg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: work around leak of uninitialized stack contents
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> =E6=96=BC 2019=E5=B9=B49=E6=9C=8812=
=E6=97=A5=E9=80=B1=E5=9B=9B =E4=B8=8B=E5=8D=886:53=E5=AF=AB=E9=81=93=EF=BC=
=9A
>
> Fuqian Huang <huangfq.daxian@gmail.com> writes:
>
> > Vitaly Kuznetsov <vkuznets@redhat.com> =E6=96=BC 2019=E5=B9=B49=E6=9C=
=8812=E6=97=A5=E9=80=B1=E5=9B=9B =E4=B8=8B=E5=8D=884:51=E5=AF=AB=E9=81=93=
=EF=BC=9A
> >>
> >> Fuqian Huang <huangfq.daxian@gmail.com> writes:
> >>
> >> > Emulation of VMPTRST can incorrectly inject a page fault
> >> > when passed an operand that points to an MMIO address.
> >> > The page fault will use uninitialized kernel stack memory
> >> > as the CR2 and error code.
> >> >
> >> > The right behavior would be to abort the VM with a KVM_EXIT_INTERNAL=
_ERROR
> >> > exit to userspace;
> >>
> >> Hm, why so? KVM_EXIT_INTERNAL_ERROR is basically an error in KVM, this
> >> is not a proper reaction to a userspace-induced condition (or ever).
> >>
> >> I also looked at VMPTRST's description in Intel's manual and I can't
> >> find and explicit limitation like "this must be normal memory". We're
> >> just supposed to inject #PF "If a page fault occurs in accessing the
> >> memory destination operand."
> >>
> >> In case it seems to be too cumbersome to handle VMPTRST to MMIO and we
> >> think that nobody should be doing that I'd rather prefer injecting #GP=
.
> >>
> >> Please tell me what I'm missing :-)
> >
> > I found it during the code review, and it looks like the problem the
> > commit 353c0956a618 ("KVM: x86: work around leak of uninitialized
> > stack contents (CVE-2019-7222)")
> > mentions. So I fixed it in a similar way.
> >
>
> Oh, yes, I'm not against the fix at all, I was just wondering about why
> you think we need to kill the guest in this case.

I don't know what is the proper way to handle this case, I just initialize =
the
memory to avoid information leakage.
(Actually, I am not an expert on KVM's code)
I will be appreciated if the bug is fixed. :)

>
> --
> Vitaly
