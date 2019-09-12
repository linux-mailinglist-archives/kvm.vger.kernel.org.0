Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 711EAB0AB4
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 10:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730398AbfILI4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 04:56:13 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:38692 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfILI4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 04:56:12 -0400
Received: by mail-yw1-f66.google.com with SMTP id f187so8865255ywa.5;
        Thu, 12 Sep 2019 01:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ba0Mg0PjzFl5tyazyjtWzd4MBHG4kyyWf35Son0d6lA=;
        b=QpKGvCltuwLS1EvJHQvNjmcaYy/JUMTCT0iVaXYh9wkBOauFKMUiP0kYkUwR5+bDgH
         0qakOzwgCtqVB/ZqH2NihcyADJAd5R4MhpwmexILx739pxC+qBikD41/PA4sMmQ9YbcF
         K13487GS0MfqO3xVQt7IFbn4Un4c+FbnpWas7ti/I2vlFozGjrYYAJQFYkiyC8Yn2Pco
         VyWW0ZmtMlVUw470exQCGI/hxRpM+5T4RiLhx2gunLQCiWjLh+yGV8+Qoj9b1sy0X26U
         eaO9NwDi+FNx3VwvMRpzp7JrHQwjWvM1jlizyw5h9IeqU3TkN41OpzugLKv5hasQPYyS
         +fwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ba0Mg0PjzFl5tyazyjtWzd4MBHG4kyyWf35Son0d6lA=;
        b=QFvHi1oh8UqebrcZ55BbMgOCnesA9cxDlwLty13VkmukDbRsoDLzw4eVZY1r7YRcCp
         TcIeis+Js3SeFWslLrd2x0ojUCIxhs6VpU9Usyd83QsBRlxNb4fkiTo8+uWPCq7sfnYx
         vY5WgDHzHK1peiDrJST/IIfGbwaBQTR5sneobPMb6GZywArQI7zunRzmJwYEB//tqMcE
         Q6scmGMcfa5xnAB+tStxZW74timxL1vM5Cus3kscDzD95z4OSOFliNN30A0e7x8SxXf4
         6s1k2sLCptN6M7NfSyHj5N4GmSeyj576UizutI8RgaPjy02kS8dH5Im2dUcLnzlNgHrc
         ENEA==
X-Gm-Message-State: APjAAAVf0hk7rrTY6+65ztjSXrmOaDi/XLvOHeud8h51qNzUKThJNClo
        11LNZr46SdXSknesBxmn4F5bXPJJqWRT+qlu9dM=
X-Google-Smtp-Source: APXvYqxo4SZfAeLiIv90NX3eRPxzJ4KtqyBZq8+C62dbsPbxsixwbH1Gt2YyD5fq4Xgxd8rfuSeUHty7pKSI0eZMX5c=
X-Received: by 2002:a81:9404:: with SMTP id l4mr27056745ywg.352.1568278571868;
 Thu, 12 Sep 2019 01:56:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190912041817.23984-1-huangfq.daxian@gmail.com> <87tv9hew2k.fsf@vitty.brq.redhat.com>
In-Reply-To: <87tv9hew2k.fsf@vitty.brq.redhat.com>
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Date:   Thu, 12 Sep 2019 16:56:00 +0800
Message-ID: <CABXRUiTD=yRRQFfSdS=2e9QaO-PEgvZ=LBar927rL04G59nHxQ@mail.gmail.com>
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
=E6=97=A5=E9=80=B1=E5=9B=9B =E4=B8=8B=E5=8D=884:51=E5=AF=AB=E9=81=93=EF=BC=
=9A
>
> Fuqian Huang <huangfq.daxian@gmail.com> writes:
>
> > Emulation of VMPTRST can incorrectly inject a page fault
> > when passed an operand that points to an MMIO address.
> > The page fault will use uninitialized kernel stack memory
> > as the CR2 and error code.
> >
> > The right behavior would be to abort the VM with a KVM_EXIT_INTERNAL_ER=
ROR
> > exit to userspace;
>
> Hm, why so? KVM_EXIT_INTERNAL_ERROR is basically an error in KVM, this
> is not a proper reaction to a userspace-induced condition (or ever).
>
> I also looked at VMPTRST's description in Intel's manual and I can't
> find and explicit limitation like "this must be normal memory". We're
> just supposed to inject #PF "If a page fault occurs in accessing the
> memory destination operand."
>
> In case it seems to be too cumbersome to handle VMPTRST to MMIO and we
> think that nobody should be doing that I'd rather prefer injecting #GP.
>
> Please tell me what I'm missing :-)

I found it during the code review, and it looks like the problem the
commit 353c0956a618 ("KVM: x86: work around leak of uninitialized
stack contents (CVE-2019-7222)")
mentions. So I fixed it in a similar way.

>
> >  however, it is not an easy fix, so for now just ensure
> > that the error code and CR2 are zero.
> >
> > Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
> > ---
> >  arch/x86/kvm/x86.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 290c3c3efb87..7f442d710858 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5312,6 +5312,7 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *=
vcpu, gva_t addr, void *val,
> >       /* kvm_write_guest_virt_system can pull in tons of pages. */
> >       vcpu->arch.l1tf_flush_l1d =3D true;
> >
> > +     memset(exception, 0, sizeof(*exception));
> >       return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
> >                                          PFERR_WRITE_MASK, exception);
> >  }
>
> --
> Vitaly
