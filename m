Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 289A81612C7
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 14:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgBQNMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 08:12:51 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:37669 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727285AbgBQNMv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 08:12:51 -0500
Received: by mail-ot1-f67.google.com with SMTP id l2so9820726otp.4;
        Mon, 17 Feb 2020 05:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xyDoQXaxUnAhbcSh1pD7Fmld76RkwiIErcec174JinM=;
        b=epRTAwIzLUTlnb+/jUX+cHtyDo7U5ekQ1QXhi8Dtx2GLxvNAwcaB7Uv0VQQxmV8ja6
         mvbMtUMfKzn4o+a4bPe1hysnGfVg6UhfoSwKe3Eqdlpguw6o9rj5F1pDx6axSDir0hPH
         K4pFMtOcfzc/jC3kHlze9t+Jjs7+cnWF2ffzOwB0QWAuqlFCO4PUYBv7qwBATZKyUPXO
         DXTjXcVefk6VfasXOhLb03ByM+xyTTGfZssbYOvv3CzB+Q7LkP/pRDymT/Kmak6B6JSL
         /jkwuwwuaeoLbuHX84scx9G2dtMYtKUs2IBeP7uMGj/Hfmqi9Z8267U5dxnaqj2t+lxe
         CbwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xyDoQXaxUnAhbcSh1pD7Fmld76RkwiIErcec174JinM=;
        b=nuwdCIudEnmFNCczJvbMp3NS9/rwxvTEvjKKRLpw/wDjnb4/KhBAO2spBL6Ne3zFwr
         LC92RlR5wG7RzMbYVNRzNuT8lcfejT04LRyzlLhOHjhUSqM8rqFyGsup0lOYa2ersfqr
         i/L8xSNmNUSn/T4K4EBe37kje2sPrI5mRyXrLH6u9OiH3p3RzZEd3j52OoOkPe0+p/ki
         CjSb0zApnCdjHLm6zLjz8dcPsE4zkBpkkfnlF6Ga1EwSi1Vg9JzNsmWZyIGWVCyMmx0t
         a+3hdWEQ+fjXH+QeBii1OUreZ5FfwCHToH4mCunV8vMzbh5JZ+TDrfQa9truYElv1mT6
         jIQw==
X-Gm-Message-State: APjAAAVy+OmHB72glnTHBdeIRzoWypxDq8FXP+RWsKTxVmoqll+knZK3
        yeQQOuSWwtDLYnSW2ffQrJkHW8xS1XaW7RbEpLt60Q6JIkI=
X-Google-Smtp-Source: APXvYqzfL7ZMeN9pKFsyZ9L4G9+Gn2ozS60R8nAHEorU6lGOmN4Eg5nc99nLnEbP0RSwoAMKoOvY7SshdPTjhs4leoQ=
X-Received: by 2002:a9d:7ccd:: with SMTP id r13mr11661299otn.56.1581945170431;
 Mon, 17 Feb 2020 05:12:50 -0800 (PST)
MIME-Version: 1.0
References: <CANRm+Cz6Es1TLFdGxz_65i-4osE6=67J=noqWC6n09TeXSJ5SA@mail.gmail.com>
 <8fd7a83a-6fde-652f-0a2e-ec7b90c13616@redhat.com>
In-Reply-To: <8fd7a83a-6fde-652f-0a2e-ec7b90c13616@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 17 Feb 2020 21:12:39 +0800
Message-ID: <CANRm+CxZRCs6h_mffFQsX6N7KFJFFhSADR4vn1J-1OopU+UEAA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] KVM: X86: Less kvmclock sync induced vmexits after
 VM boots
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 17 Feb 2020 at 19:23, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 17/02/20 11:36, Wanpeng Li wrote:
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index fb5d64e..d0ba2d4 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9390,8 +9390,9 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
> >      if (!kvmclock_periodic_sync)
> >          return;
> >
> > -    schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
> > -                    KVMCLOCK_SYNC_PERIOD);
> > +    if (kvm->created_vcpus == 1)
> > +        schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
> > +                        KVMCLOCK_SYNC_PERIOD);
>
> This is called with kvm->lock not held, so you can have
> kvm->created_vcpus == 2 by the time you get here.  You can test instead
> "if (vcpu->vcpu_idx == 0)".

Agreed.

    Wanpeng
