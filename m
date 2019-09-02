Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF76AA5697
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2019 14:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731010AbfIBMqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Sep 2019 08:46:24 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41583 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729878AbfIBMqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Sep 2019 08:46:23 -0400
Received: by mail-pg1-f196.google.com with SMTP id x15so7432678pgg.8;
        Mon, 02 Sep 2019 05:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pgpliINIcPhRc7BoPrS9B0ow1dlVmDoEwaS8EkZIGsk=;
        b=iKcHDACooIYXG12YqobbLfwrs0m9jJ0g9pUEG/yHkkVSUkM+4P2KHKsylGwM7IFasO
         77lLo5fMqVvA1ZyFcVvUs9kp97t7EYK9xLbVze9DNahb00gwgfTrT7i6NftOA7WOFszY
         BQm26EUDi9RHFXHYXMgnFfZYRopoBYYZK8p+sd3Koqh5TbLKd5wi0n/Mm7UtAsrQjeFs
         n/Z6jMYgcDOvMn+KGep5g5kdw5Ct9tg4tfK6fPPf2dY9tnz3iF+t0SiGmHqnQXI+tZpJ
         AovmJaUzEHmO+HmLgO+yqXmIDkrKWIfHx51iUR3DplGeOYQ4uQ3QwGCr8/TqhGJH/6IK
         vf4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pgpliINIcPhRc7BoPrS9B0ow1dlVmDoEwaS8EkZIGsk=;
        b=A4KOY9h4wtF2HQWMuvaAf9cuKlr319RZKVSNpARiKbY7nWf9nZ8JmNUre4CDHEIWa9
         7+zbNz0H5DnN69u9SKvLo6RQlc/ESScLtat52W63O343jOn5vkqRf+meHJknOsjQxIFq
         7MvyGaniDT7s/RUfg1SJHqUYRh8lQV9KgYw5cUzuQ7fOPrkslKt0TpYaqOYKb7TM7HT4
         1htSiJFYPcECnit2mky8Wm6NrEZ5i5Og2saTLw3fpOm22+AtpV7WIk2PL+Uo6e6FOR1y
         wW7FJkwLMGow8TreHaKz48DVPp3MIIC54hp1/EcP2EUIn8z5/JErysJAWunrXqp8d2hG
         NJRA==
X-Gm-Message-State: APjAAAW4xTMRFH1gBaxZPDbsvIHe5dCUoTQlAWBiseVmkH15nzbx1vtv
        jOULevzs0UEt96w535bqIc7dBe2ESo222mHhAQA=
X-Google-Smtp-Source: APXvYqxXfUfYYlSHCGT8QWcRuQ7m0TRU6YfPCzIJqacGx9wipMEOCpcJgFUg1vZ65kU4tE0DEW8M4geXJQCCfGj37x8=
X-Received: by 2002:aa7:8219:: with SMTP id k25mr34409763pfi.72.1567428382975;
 Mon, 02 Sep 2019 05:46:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190830061540.211072-1-Tianyu.Lan@microsoft.com> <DM5PR21MB0137B7C2AAD0FC65CB3E1306D7BD0@DM5PR21MB0137.namprd21.prod.outlook.com>
In-Reply-To: <DM5PR21MB0137B7C2AAD0FC65CB3E1306D7BD0@DM5PR21MB0137.namprd21.prod.outlook.com>
From:   Tianyu Lan <lantianyu1986@gmail.com>
Date:   Mon, 2 Sep 2019 20:46:15 +0800
Message-ID: <CAOLK0pwEMg7kSsRNfKa6=uQ1eVGa-HdNG=qMBernoe7XwS-0_w@mail.gmail.com>
Subject: Re: [PATCH] x86/Hyper-V: Fix overflow issue in the fill_gva_list()
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 31, 2019 at 1:41 AM Michael Kelley <mikelley@microsoft.com> wrote:
>
> From: lantianyu1986@gmail.com  Sent: Thursday, August 29, 2019 11:16 PM
> >
> > From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> >
> > fill_gva_list() populates gva list and adds offset
> > HV_TLB_FLUSH_UNIT(0x1000000) to variable "cur"
> > in the each loop. When diff between "end" and "cur" is
> > less than HV_TLB_FLUSH_UNIT, the gva entry should
> > be the last one and the loop should be end.
> >
> > If cur is equal or greater than 0xFF000000 on 32-bit
> > mode, "cur" will be overflow after adding HV_TLB_FLUSH_UNIT.
> > Its value will be wrapped and less than "end". fill_gva_list()
> > falls into an infinite loop and fill gva list out of
> > border finally.
> >
> > Set "cur" to be "end" to make loop end when diff is
> > less than HV_TLB_FLUSH_UNIT and add HV_TLB_FLUSH_UNIT to
> > "cur" when diff is equal or greater than HV_TLB_FLUSH_UNIT.
> > Fix the overflow issue.
>
> Let me suggest simplifying the commit message a bit.  It
> doesn't need to describe every line of the code change.   I think
> it should also make clear that the same problem could occur on
> 64-bit systems with the right "start" address.  My suggestion:
>
> When the 'start' parameter is >=  0xFF000000 on 32-bit
> systems, or >= 0xFFFFFFFF'FF000000 on 64-bit systems,
> fill_gva_list gets into an infinite loop.  With such inputs,
> 'cur' overflows after adding HV_TLB_FLUSH_UNIT and always
> compares as less than end.  Memory is filled with guest virtual
> addresses until the system crashes
>
> Fix this by never incrementing 'cur' to be larger than 'end'.
>
> >
> > Reported-by: Jong Hyun Park <park.jonghyun@yonsei.ac.kr>
> > Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> > Fixes: 2ffd9e33ce4a ("x86/hyper-v: Use hypercall for remote
> > TLB flush")
>
> The "Fixes:" line needs to not wrap.  It's exempt from the
> "wrap at 75 columns" rule in order to simplify parsing scripts.
>
> The code itself looks good.

Hi Michael:
       Thanks for suggestion. Update commit log in V2.
-- 
Best regards
Tianyu Lan
