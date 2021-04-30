Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D9E36F42B
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 04:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhD3C5U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 22:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhD3C5T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 22:57:19 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D79FC06138B;
        Thu, 29 Apr 2021 19:56:26 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id i22so3070543ila.11;
        Thu, 29 Apr 2021 19:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=glOkDPvaVe3HL+R51noq4zWPvsimsVVd6SRQNZVquXE=;
        b=p17DtaT4YWPXkXLWjB9OpGfwnH8gWdzixFynXody6DLvworbFhc+KrauMjdhW1XV0n
         lhIs6sObFXzBiY05am3Lttj6/t3N+nSH91KGjN0wNi6rB4CMN8PdEpfqea5v7szCjzZA
         q+Xym89mrRhS2IjCayVRvOtqT4LhydNqViEk7jvjrKBTrEYLGbxa5A1PBNGPCiTfrkcL
         YXPad0M3pzzW2kyV9UvSiGCSAMUGn/MFewsFWYpMUS75ctP1q1j/1lCwLox/gqBfv4LA
         HtANgXoMnAmtO/slgIWq8/bZomgzodOVCg6JtlAoP4X7LNN9pGJez86n18AbnLyxxKiZ
         2FVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=glOkDPvaVe3HL+R51noq4zWPvsimsVVd6SRQNZVquXE=;
        b=mMPp/RYXpcLgJfAHltAKZjwoERbBCgFgEOudcibYEYdlLUR0317RHFCoVA+IYGTqtp
         M+kgJ32daLLAFJmcgQdS6HOlnKKDdumWJIWez50oaLpED8hvrCBmuqE3Ns3BIcugBeVi
         9DepW81cN5KNyi2LyoZWJa+Vi1V4QluWneQRJSfEYpoK0jGSmH0DpOUCx20DQGQinSOO
         byIYe4m3tHUi2KWDlR7zEFpwHr3W1aug4wH03kM6RK7poqt6BHFfuvAq8c/U8OSzOjcm
         TOQ/VJ7gaOdUzLlw2svsBvOK4pGGj7HexDYdARTGMs1RXypZYxv06Zh3i5zjnlCdU5b9
         iwSw==
X-Gm-Message-State: AOAM533kpbrrqM3OWeDjsq+Mzh6XCM3GBOE71uXUZZDU+cb/KtIujtfH
        n3ELZWqtHPY0/5thwo3LmVhQArCpFnnJ5V3jF98=
X-Google-Smtp-Source: ABdhPJxTI59jhNZ8AbVlHZmKqrywg3cBgRlvL358Ad34oQhVail3S922p5KSPwY2ApJgSHFD9qhXCl4tGsFV0p+sE08=
X-Received: by 2002:a05:6e02:1d16:: with SMTP id i22mr2264430ila.164.1619751386194;
 Thu, 29 Apr 2021 19:56:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200915191505.10355-1-sean.j.christopherson@intel.com>
 <20200915191505.10355-3-sean.j.christopherson@intel.com> <CAJhGHyBOLUeqnwx2X=WToE2oY8Zkqj_y4KZ0hoq-goe+UWcR9g@mail.gmail.com>
 <bb2c2d93-8046-017a-5711-c61c8f1a4c09@redhat.com> <CAJhGHyDrAwKO1iht=d0j+OKD1U7e1fzLminudxo2sPHbF53TKQ@mail.gmail.com>
 <2fd450a9-0f59-8d88-d4bc-431245f3b565@redhat.com>
In-Reply-To: <2fd450a9-0f59-8d88-d4bc-431245f3b565@redhat.com>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Fri, 30 Apr 2021 10:56:15 +0800
Message-ID: <CAJhGHyDnZ8sNLXTRddB81OpHSz+EQEEiemvwodRdHcY-yfa+aA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: VMX: Invoke NMI handler via indirect call
 instead of INTn
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 27, 2021 at 3:05 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 27/04/21 02:54, Lai Jiangshan wrote:
> > The C NMI handler can handle the case of nested NMIs, which is useful
> > here.  I think we should change it to call the C NMI handler directly
> > here as Andy Lutomirski suggested:
>
> Great, can you send a patch?
>

Hello, I sent it several days ago, could you have a review please, and
then I will update
the patchset with feedbacks applied. And thanks Steven for the reviews.

https://lore.kernel.org/lkml/20210426230949.3561-4-jiangshanlai@gmail.com/

thanks
Lai
