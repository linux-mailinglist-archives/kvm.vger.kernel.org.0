Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF351BD0A
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 20:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfEMSNt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 14:13:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbfEMSNs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 14:13:48 -0400
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D808221881
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 18:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557771228;
        bh=xJ43iv8JIVJV06BJOR4VuJn38wWKCPs7W85gx3/vesQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RQPALaR6keNNHhj8kl3glR48+4D0lO7laKwPgRYV8567VOOFIXHDjKkg4xGJhScWb
         labg/8d2rAmbFLVxOpRtKCey7nrN1s2ho0RzWjCYuUfEbJTrEghal93ee9vAJf1Pnm
         S8G4pEFs3kYyxWFbSwmeacsHNaaYT1Rp4xIJ9P+Y=
Received: by mail-wm1-f48.google.com with SMTP id q15so304144wmj.0
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 11:13:47 -0700 (PDT)
X-Gm-Message-State: APjAAAWmgSEUE1001Z7Oa+PbXwp/AanzzrZzfi/XwMWvwcImVCew8+0n
        OO00mFpafHzUgvrhyCFLNLuk5r/+Vna5z3kJtmE0WQ==
X-Google-Smtp-Source: APXvYqztb6DXKSV98pGukQDqOFwqMu/V3s8tPP2GGuT4Cv2LUpFQncmLCR59lo0OgdzKpWMqip0WeWd2JxL5FMlZQhU=
X-Received: by 2002:a1c:486:: with SMTP id 128mr15655411wme.83.1557771226305;
 Mon, 13 May 2019 11:13:46 -0700 (PDT)
MIME-Version: 1.0
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <1557758315-12667-7-git-send-email-alexandre.chartre@oracle.com>
 <CALCETrUzAjUFGd=xZRmCbyLfvDgC_WbPYyXB=OznwTkcV-PKNw@mail.gmail.com> <64c49aa6-e7f2-4400-9254-d280585b4067@oracle.com>
In-Reply-To: <64c49aa6-e7f2-4400-9254-d280585b4067@oracle.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 13 May 2019 11:13:34 -0700
X-Gmail-Original-Message-ID: <CALCETrUd2UO=+JOb_008mGbPdfW5YJgQyw5H7D_CxOgaWv=gxw@mail.gmail.com>
Message-ID: <CALCETrUd2UO=+JOb_008mGbPdfW5YJgQyw5H7D_CxOgaWv=gxw@mail.gmail.com>
Subject: Re: [RFC KVM 06/27] KVM: x86: Exit KVM isolation on IRQ entry
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Liran Alon <liran.alon@oracle.com>,
        Jonathan Adams <jwadams@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 13, 2019 at 9:28 AM Alexandre Chartre
<alexandre.chartre@oracle.com> wrote:
>
>
>
> On 5/13/19 5:51 PM, Andy Lutomirski wrote:
> > On Mon, May 13, 2019 at 7:39 AM Alexandre Chartre
> > <alexandre.chartre@oracle.com> wrote:
> >>
> >> From: Liran Alon <liran.alon@oracle.com>
> >>
> >> Next commits will change most of KVM #VMExit handlers to run
> >> in KVM isolated address space. Any interrupt handler raised
> >> during execution in KVM address space needs to switch back
> >> to host address space.
> >>
> >> This patch makes sure that IRQ handlers will run in full
> >> host address space instead of KVM isolated address space.
> >
> > IMO this needs to be somewhere a lot more central.  What about NMI and
> > MCE?  Or async page faults?  Or any other entry?
> >
>
> Actually, I am not sure this is effectively useful because the IRQ
> handler is probably faulting before it tries to exit isolation, so
> the isolation exit will be done by the kvm page fault handler. I need
> to check that.
>

The whole idea of having #PF exit with a different CR3 than was loaded
on entry seems questionable to me.  I'd be a lot more comfortable with
the whole idea if a page fault due to accessing the wrong data was an
OOPS and the code instead just did the right thing directly.

--Andy
