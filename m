Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8C3213B74
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 16:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgGCOA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 10:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgGCOAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jul 2020 10:00:25 -0400
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB35C08C5DD
        for <kvm@vger.kernel.org>; Fri,  3 Jul 2020 07:00:25 -0700 (PDT)
Received: by mail-vk1-xa44.google.com with SMTP id s192so7131197vkh.3
        for <kvm@vger.kernel.org>; Fri, 03 Jul 2020 07:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x5F3VEjoP3FKUljXbLKCPFmED7t6N7RsImdk24VNfSc=;
        b=ilCOu9gYBMdqPI/WloUGvxq/+wnGHnQ1ZAHN1ZxENszq7GPp9XNKx9zUBnE+fK9TgU
         kQxMN49VEXWiecCYQDAL/WKl0bVLcsUEfsmWRF1OqyDngNlhJxLHKL5br824jjZHpUjJ
         7hdtRocMgi9/yp6SHT51EkOw9NH2gxFvrwG3GVZa6/L7YD+wxw1rIg9Gl4V8GOyMVAaE
         cpP+FflthlLgMOCHyBLj9hCGNiq5UWE+L7Cd0KnzVOHXaoX++5r96myY1zSsJ810tV+B
         fijJbiHJsmfDJ/u/k7Z4OHk1777RqOIaN0m4d2ZRnvaostA+caNpfnc2Ov0C5PnO46BU
         +LoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x5F3VEjoP3FKUljXbLKCPFmED7t6N7RsImdk24VNfSc=;
        b=aoThFSUUSvrXx9UYG6LhfY6ci2V1KOGlvCaOebQ0Equf5CI+v72QzN5n0vzw+G4Lx4
         qnrITediz0FqHQC28Qecn+4vn5VBP/YzW+ekJ3g+C4qLAb2i2iUdj4TMTKL/Wlj9HrmS
         0nq45ECTgzrzotgSQkRgI2oc/F3bwFOhKjDGw7ph6zlfapJcb8DpXMLDwsh517XIZYae
         VdzHpqmPWFSeYZcPuF5PrhXVnee5+4rqnAzD3vbPgHKzD6vwtTVvVHJwgJZ40mETp8td
         Da2+XezMJQCBNAfZbQFIULKJUG30So6RKaXbnuHRPR9FRC9Ki+a/8YBiydloBSTlCL68
         rPNA==
X-Gm-Message-State: AOAM531TOVsU0EyKV05WC+wqx1+8VYnPlo6+ec1xX1fuaIgppkY9L3WK
        s2X1LWVA9Uctg6TOJ69Z9m6BEVVKafCxPH1M8QfC1g==
X-Google-Smtp-Source: ABdhPJwx16TCC0yxwEDEAWqU8RVaCCWww0gPA4ZSJHucJ6hbfJede4vfqOlpKj94dbBKxrLzf14j6uvN3giH1XMSxM4=
X-Received: by 2002:a1f:3f05:: with SMTP id m5mr1556534vka.92.1593784823956;
 Fri, 03 Jul 2020 07:00:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200702221237.2517080-1-abhishekbh@google.com>
 <e7bc00fc-fe53-800e-8439-f1fbdca5dd26@redhat.com> <CAN_oZf2t+gUqXe19Yo1mTzAgk2xNhssE-9p58EvH-gw5jpuvzA@mail.gmail.com>
 <CA+noqoj6u9n_KKohZw+QCpD-Qj0EgoCXaPEsryD7ABZ7QpqQfg@mail.gmail.com> <20200703114037.GD2999146@linux.ibm.com>
In-Reply-To: <20200703114037.GD2999146@linux.ibm.com>
From:   Doug Anderson <dianders@google.com>
Date:   Fri, 3 Jul 2020 07:00:11 -0700
Message-ID: <CAD=FV=XRbrFqSbR619h+9HXNyrYNbqfBF2e-+iUZco9qQ8Wokg@mail.gmail.com>
Subject: Re: [PATCH v3] x86/speculation/l1tf: Add KConfig for setting the L1D
 cache flush mode
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     Abhishek Bhardwaj <abhishekbh@google.com>,
        Anthony Steinhauser <asteinhauser@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Waiman Long <longman@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86 <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Fri, Jul 3, 2020 at 4:40 AM Mike Rapoport <rppt@linux.ibm.com> wrote:
>
> On Thu, Jul 02, 2020 at 11:43:47PM -0700, Abhishek Bhardwaj wrote:
> > We have tried to steer away from kernel command line args for a few reasons.
> >
> > I am paraphrasing my colleague Doug's argument here (CC'ed him as well) -
> >
> > - The command line args are getting unwieldy. Kernel command line
> > parameters are not a scalable way to set kernel config. It's intended
> > as a super limited way for the bootloader to pass info to the kernel
> > and also as a way for end users who are not compiling the kernel
> > themselves to tweak kernel behavior.
>
> Why cannot you simply add this option to CONFIG_CMDLINE at your kernel build
> scripts?

At least in the past I've seen that 'CONFIG_CMDLINE' interacts badly
with the bootloader provided command line in some architectures.  In
days of yore I tried to post a patch to fix this, at least on ARM
targets, but it never seemed to go anywhere upstream.  I'm going to
assume this is still a problem because I still see an ANDROID tagged
patch in the Chrome OS 5.4 tree:

In any case, as per my previous arguments, stuffing lots of config
into the cmdline is a bit clunky and doesn't scale well.  You end up
with a really long run on command line and it's hard to tell where one
config option ends and the next one starts and if the same concept is
there more than one time it's hard to tell and something might cancel
out a previous config option or maybe it won't and by the time you end
up finishing this it's hard to tell where you started.  :-)


> > - Also, we know we want this setting from the start. This is a
> > definite smell that it deserves to be a compile time thing rather than
> > adding extra code + whatever miniscule time at runtime to pass an
> > extra arg.
>
> This might be a compile time thing in your environment, but not
> necessarily it must be the same in others. For instance, what option
> should distro kernels select?

Nothing prevents people from continuing to use the command line
options if they want, right?  This just allows a different default.
So if a distro is security focused and decided that it wanted a slower
/ more secure default then it could ship that way but individual users
could still override, right?


> > I think this was what CONFIGS were intended for. I'm happy to add all
> > this to the commit message once it's approved in spirit by the
> > maintainers.
> >
> > On Thu, Jul 2, 2020 at 8:18 PM Anthony Steinhauser
> > <asteinhauser@google.com> wrote:
> > >
> > > Yes, this probably requires an explanation why the change is necessary
> > > or useful. Without that it is difficult to give some meaningful
> > > feedback.
> >
> >
> >
> > --
> > Abhishek
>
> --
> Sincerely yours,
> Mike.
