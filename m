Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC9B359275
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 05:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbhDIDGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 23:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbhDIDGS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 23:06:18 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6584C061760;
        Thu,  8 Apr 2021 20:06:06 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id i20-20020a4a8d940000b02901bc71746525so1022033ook.2;
        Thu, 08 Apr 2021 20:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cL5GT17LbDiAN0jep9SUWm1qBts4IXsLVpBK9NlAJl8=;
        b=ElSv20jLr2LCFCxLXbQ1iY8G1+leRxoU0fb0jsjMpopysrkd65xcgshcrNwXzwbKCg
         zFIl54ZF+qVNBAfReQhrATH+QQ8J8pIvFzL0EJ7mOy5E0ai60BAIo4E7ZNRx7sZ9iZ2a
         yqNm5IdWWAViGAQ3ySvOV6S9Sbc1UcscSPJ7tk98uIBi9nHR5ptOGIh7r5sGJoVbeFA6
         onNSUxlKKLl59jJ1OX3cHz/XOxpxldJVR1iMfA9qtQPyCP/ZQI1P60CsJt9V9K+Ie9Bj
         2p63gcGpHsIlYzmxPnLpAPIJPnPmftus2uiLHQSZiUqNYWRZXbJyUkW4YL2apgczys6g
         O9cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cL5GT17LbDiAN0jep9SUWm1qBts4IXsLVpBK9NlAJl8=;
        b=ilNdmOniVr0s5hv0KFiJ9OmXo9NnGJM5l92y0N/CIOcVAseC8PBbeMgLY8zUsbJDkH
         FkVk2F2NOaUTQfBKntvav6zPcbZdbH5C/lfeHld948PoCFncAyL5cBuAclOLFXo+nTU5
         lL9i08ioGbvL3EQx/Q0sd6OxfboSvKNEeTi1FAxKyho8MvUhEGesiEfgHKJ6m33Imoku
         cRumwzNq+cAWL5yjW0c0f1vGGtYGnCwHPsc0VI4K7E3dYxIVGvXXhjrut/jaYjMMLtUX
         zlN51ljUeM5mgg/ttSvwCe2KX9a5r8Ic0P75SY8esv5kCvWodiiz1uiVWgmGrRBt1gk4
         zP+g==
X-Gm-Message-State: AOAM533RUL6kOHzxKqemsD2nrpiAC5J+nZAhIQrrd6A+WUUCiOH/ZJeT
        8kNJMh7n3U3lj0zM35WPCDhL+VKrw2Lwrm6E9dQ=
X-Google-Smtp-Source: ABdhPJx1oFnOhZGTHEGTOpEZpCpauBfgUTdWJQhgkSmDT/arvJwizFK0vtGPn8t3CW+ASjRl9LS+fM3/fkjhLrxytyQ=
X-Received: by 2002:a4a:244d:: with SMTP id v13mr10368933oov.66.1617937566242;
 Thu, 08 Apr 2021 20:06:06 -0700 (PDT)
MIME-Version: 1.0
References: <1617880989-8019-1-git-send-email-wanpengli@tencent.com> <YG81to0nF/M7DEGA@google.com>
In-Reply-To: <YG81to0nF/M7DEGA@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 9 Apr 2021 11:05:54 +0800
Message-ID: <CANRm+CwC0RF-QZ40YSgSidQjGFK4NGxwjg3iLVSb2r=uEH=LCA@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Do not yield to self
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 9 Apr 2021 at 00:56, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Apr 08, 2021, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > If the target is self we do not need to yield, we can avoid malicious
> > guest to play this.
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> > Rebased on https://lore.kernel.org/kvm/1617697935-4158-1-git-send-email-wanpengli@tencent.com/
> >
> >  arch/x86/kvm/x86.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 43c9f9b..260650f 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -8230,6 +8230,10 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
> >       if (!target)
> >               goto no_yield;
> >
> > +     /* yield to self */
>
> If you're going to bother with a comment, maybe elaborate a bit, e.g.
>
>         /* Ignore requests to yield to self. */

Looks good, thanks.

    Wanpeng
