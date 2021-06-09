Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A0D3A0D99
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 09:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbhFIHVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 03:21:25 -0400
Received: from mail-oo1-f43.google.com ([209.85.161.43]:45959 "EHLO
        mail-oo1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235215AbhFIHVX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 03:21:23 -0400
Received: by mail-oo1-f43.google.com with SMTP id q20-20020a4a6c140000b029024915d1bd7cso4004717ooc.12;
        Wed, 09 Jun 2021 00:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+BHctJq4G6Xr6Ip6lTcKa8uU4EOvZqV3z9gMl+bgMSg=;
        b=AZjhMfyznzZ7CaqdWdCG1QVYM8DchQO91O9YCnOQ22DTupG7gBaWvkgN5F5pV1/mtO
         ssvHbO8v1zBqieFvkEOYrXKHZdLdNZC9hu1fAuG0fSxmjcmb+ic6+11KimbpQNC72Ygo
         tglaeubOwmMx8+pCizToZXKypqRfv6ziy/X6VGNh1piyzjvNxQuUnubfcijJAXK1td0J
         lDVYO/0Q76/RYVnh0imbHX+0N0ED/IbYafx4JaMIsbuC5m7odr5tuKDsjt33OADXQjDg
         MMv5bPbxXuawwfn0IvVgD9lgQcNQnQv0v64tjygA2BSi8VDfD03s0gokdjfEiR4GYdMG
         qSCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+BHctJq4G6Xr6Ip6lTcKa8uU4EOvZqV3z9gMl+bgMSg=;
        b=JyQ9lZSsdhAlqoldSjl0DRMvOeSrztb/44PjwIWCiyhf5jBFmfBGgCZkaRED5YWdm5
         0Is4VzvwhRcarKPLOTCKqqAlpzK3HLdLkWg3/ZTXCYrbQKlGwi6rY2DF5iRJv0UgisL6
         t+SWdW0IRbVAdMc5bbNnsWT+Hkn7xr2St6yqkLIUY1i46jORUpErD6vHpw7ote/xS9s0
         V3MwpOx2IA9NbXJcpgWR6p6cBHph290LKeGQEXiEhmFyNtkFbaHld+5eoJwlF2It432L
         0q/Rk9eeyNcZvpvtthQUfl2oXesyxTASNCTh0P5lvg91B7h5iGIigtcl3CBm/WuYKI8m
         RZfA==
X-Gm-Message-State: AOAM531ltPB6tTZCtKkLtb2ZzgugkbKdHhk3b3tEeVdtf9oBEdmsBwI/
        LW6Tbab8KlLPRK34EaNorEKXtsysPxKdbvOsdYk=
X-Google-Smtp-Source: ABdhPJxUDcZdETlsFOkn0jYTarWVUL7yd4g/Xnj4LvTZZro2P5NNGaH6xuCLD0g0sQbJtP5WE1Z8ASiQqPQEseD1k5g=
X-Received: by 2002:a4a:e9fb:: with SMTP id w27mr111006ooc.41.1623223109273;
 Wed, 09 Jun 2021 00:18:29 -0700 (PDT)
MIME-Version: 1.0
References: <1623050385-100988-1-git-send-email-wanpengli@tencent.com>
 <1623050385-100988-2-git-send-email-wanpengli@tencent.com>
 <0584d79d-9f2c-52dd-5dcc-beffd18f265b@redhat.com> <CANRm+Cx3LpnMwWHAvJoTErAdWoceO9DBPqY0UkbQHW-ZUHw5=g@mail.gmail.com>
 <f8c80e8a-0749-eb5b-d5ab-162f504c9d33@redhat.com>
In-Reply-To: <f8c80e8a-0749-eb5b-d5ab-162f504c9d33@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 9 Jun 2021 15:18:18 +0800
Message-ID: <CANRm+Cwee=zwanKQZ1zWA2warRJdp4LVMTn+=uBoWT7-+xm3nQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: LAPIC: Reset TMCCT during vCPU reset
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 9 Jun 2021 at 13:52, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 09/06/21 04:15, Wanpeng Li wrote:
> > On Wed, 9 Jun 2021 at 00:27, Paolo Bonzini <pbonzini@redhat.com> wrote:
> > [...]
> >> Perhaps instead set TMCCT to 0 in kvm_apic_set_state, instead of keeping
> >> the value that was filled in by KVM_GET_LAPIC?
> >
> > Keeping the value that was filled in by KVM_GET_LAPIC is introduced by
> > commit 24647e0a39b6 (KVM: x86: Return updated timer current count
> > register from KVM_GET_LAPIC), could you elaborate more? :)
>
> KVM_GET_LAPIC stores the current value of TMCCT and KVM_SET_LAPIC's
> memcpy stores it in vcpu->arch.apic->regs.  KVM_SET_LAPIC perhaps could
> store zero in vcpu->arch.apic->regs after it uses it, and then the
> stored value would always be zero.

Just do it in a new version, thanks. :)

   Wanpeng
