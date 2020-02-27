Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC913172C83
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 00:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbgB0Xta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 18:49:30 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:36297 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729809AbgB0Xt3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 18:49:29 -0500
Received: by mail-pj1-f65.google.com with SMTP id gv17so477184pjb.1
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2020 15:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0ZF5PxVG84+TcO4AGDk4hTXuR0g3a2lAghAPZZezWAQ=;
        b=FGNJJ8TIZbEQeDUTHLzthiH7gYzaIpI1ZJA3XXho7n4IcK4vq2ltzAcqbjsmvYzX36
         zD7ixqbETkWw2eDR1zKFmbrGVME7/TxjiJ0ZdP1+cA6LI4TSIDmovCW1qDEUHfRwqOiE
         3iTQ81jQ5pn4CkXS5zbAphSmUx4QVkdWj1krgdBnAPuUm+/gujo32b14iqFpETsrDuv4
         Fbafx5Sq6NfItx31yjOO/mkBiQ8vkSiGQs+dHET8yMBirlarM/xa73kVEcbN39cFa9I4
         Vu3UDVIghVT5PWwEcnxXhBM+UPjN3nkVWg96faRN9plrIZg77Yyl4UfYIAmRMQ/hGQWD
         YzYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0ZF5PxVG84+TcO4AGDk4hTXuR0g3a2lAghAPZZezWAQ=;
        b=SvwvwaFhSbm5m1FAaoDYOT723MEWcslQxvWj9xOvz/Win/M3/3SUCGj1aKwJcPPBE2
         4norlx2YlukHdcCNmKc2oNhvZUlnAcrHu3me7Fe/GSBsu8QpyWM487CwKkDCbvf2KAdA
         o2ZkUNlzm3C9RYo0EUEZMjW7BcuRwtPHTPIM0CaofMJQH+aVl3ca9K9S84k/88AK/K3K
         RJ9RflhzKt2Fsn8ipUPPW7NTHJUQ9XKf9XTXbUlM5oX5R//jFFhmNglvVKP+p0fPz3kS
         L+JDYjGvIcb6bYdIauu/GsGaIwCoSvSI/vT3VeutHa8pIJezLXYeW7+7pfIP8U7TWZhf
         C5Lg==
X-Gm-Message-State: APjAAAWrTJ4jFreVXXfxNvnmPmxRshTzdfvrh45MnBXWKqtKvyderGUp
        5U5vqpKulfVhvcM5LXfKYQsHmkGenoBPO6tX1S5zEw==
X-Google-Smtp-Source: APXvYqw0egRKbJSIQcP/k3vUTH6RVXMgfH+NgFS+3a2pz81BzPEZzxWwvZzJpQRmMCe+9YjvwY5iOzKNBRHn/yxwaAo=
X-Received: by 2002:a17:902:760e:: with SMTP id k14mr1194526pll.119.1582847368858;
 Thu, 27 Feb 2020 15:49:28 -0800 (PST)
MIME-Version: 1.0
References: <1581988104-16628-1-git-send-email-wanpengli@tencent.com>
 <1581988104-16628-2-git-send-email-wanpengli@tencent.com> <CANRm+CyHmdbsw572x=8=GYEOw-YQCXhz89i9+VEmROBVAu+rvg@mail.gmail.com>
 <CAKwvOd=bDW6K3PC7S5fiG5n_kwgqhbnVsBHUSGgYaPQY-L_YmA@mail.gmail.com>
 <87mu95jxy7.fsf@vitty.brq.redhat.com> <9506da2d-53fb-c4a3-55b4-fb78e185e9c2@redhat.com>
In-Reply-To: <9506da2d-53fb-c4a3-55b4-fb78e185e9c2@redhat.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 27 Feb 2020 15:49:17 -0800
Message-ID: <CAKwvOd=tOURgAFUNQPX3DDqd-eAbZ9kMmyksXEUK-a2N_Gky1g@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 2/2] KVM: Pre-allocate 1 cpumask variable per
 cpu for both pv tlb and pv ipis
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 26, 2020 at 5:27 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 26/02/20 14:10, Vitaly Kuznetsov wrote:
> > Nick Desaulniers <ndesaulniers@google.com> writes:
> >
> >> (putting Paolo in To: field, in case email filters are to blame.
> >> Vitaly, maybe you could ping Paolo internally?)
> >>
> >
> > I could, but the only difference from what I'm doing right now would
> > proabbly be the absence of non-@redaht.com emails in To/Cc: fields of
> > this email :-)
> >
> > Do we want this fix for one of the last 5.6 RCs or 5.7 would be fine?
> > Personally, I'd say we're not in a great hurry and 5.7 is OK.
>
> I think we can do it for 5.6, but we're not in a great hurry. :)  The
> rc4 pull request was already going to be relatively large and I had just
> been scolded by Linus so I postponed this, but I am going to include it
> this week.

No rush; soak time is good.
-- 
Thanks,
~Nick Desaulniers
