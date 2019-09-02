Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 710D8A5DAE
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2019 23:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbfIBVze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Sep 2019 17:55:34 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:38090 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbfIBVze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Sep 2019 17:55:34 -0400
Received: by mail-ot1-f66.google.com with SMTP id r20so14768725ota.5;
        Mon, 02 Sep 2019 14:55:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kbkFoHfe8fPAibjd09tg9MHuZLwP83SyDJa1I+gY8Hg=;
        b=LJm0sump3NCb87Q/JcoWYRQ6z6VQzjEbS7LtWk9lB2O/j2gVsqHRFayDT7/Y3XV33s
         UhsnirDt83eiR1xHCN3V9KcqQssNaQ/7yCzn2kAQExB2bCLzkaUe6drn6WPqZuJpfXBu
         kKQrOQvUmZB7f+Zd6jz8/8ucJYwuzr5VFXDFABYIMqt8OjrjncCTB63ZDqk2Wnj+fW2M
         ninNfPkQsx5uUK7FxetZmOMtrsSDFUJ6nkOlqkUeT7UyxojLvA7INSn/6Dt2HIa1DThH
         3QUrkn92U3Jetcnq9j0SBxZ64b9OjVThQWtgLariK3E63htMJJSEF0YluLRl8Xj8k+TP
         WfYQ==
X-Gm-Message-State: APjAAAXAv8fXP+DJFpgnCcOzeH5iOtoAdotOGYX73W4seviM/tdlRz0L
        z11K1M6EmLoNT1Gmyh0QB/dXq6MMZKCKeH/xHDk=
X-Google-Smtp-Source: APXvYqxAht9LVOa2t9u7X03tdDeqs7UpubwWSaIOwzY/uBk+antfAmoF/NxZoJYV/R6o1BdSzpUoMz8JSDDop2yZ5GU=
X-Received: by 2002:a9d:7411:: with SMTP id n17mr5914286otk.118.1567461332790;
 Mon, 02 Sep 2019 14:55:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190829151027.9930-1-joao.m.martins@oracle.com>
 <c8cf8dcc-76a3-3e15-f514-2cb9df1bbbdc@oracle.com> <20190829172343.GA18825@amt.cnet>
In-Reply-To: <20190829172343.GA18825@amt.cnet>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 2 Sep 2019 23:55:21 +0200
Message-ID: <CAJZ5v0j8BEjdNyAn=ut9BxSH5Gphs_AivADPwXX=rJ1TF1+88A@mail.gmail.com>
Subject: Re: Is: Default governor regardless of cpuidle driver Was: [PATCH v2]
 cpuidle-haltpoll: vcpu hotplug support
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        kvm-devel <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 7:24 PM Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> On Thu, Aug 29, 2019 at 06:16:05PM +0100, Joao Martins wrote:
> > On 8/29/19 4:10 PM, Joao Martins wrote:
> > > When cpus != maxcpus cpuidle-haltpoll will fail to register all vcpus
> > > past the online ones and thus fail to register the idle driver.
> > > This is because cpuidle_add_sysfs() will return with -ENODEV as a
> > > consequence from get_cpu_device() return no device for a non-existing
> > > CPU.
> > >
> > > Instead switch to cpuidle_register_driver() and manually register each
> > > of the present cpus through cpuhp_setup_state() callback and future
> > > ones that get onlined. This mimmics similar logic that intel_idle does.
> > >
> > > Fixes: fa86ee90eb11 ("add cpuidle-haltpoll driver")
> > > Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> > > Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> > > ---
> >
> > While testing the above, I found out another issue on the haltpoll series.
> > But I am not sure what is best suited to cpuidle framework, hence requesting
> > some advise if below is a reasonable solution or something else is preferred.
> >
> > Essentially after haltpoll governor got introduced and regardless of the cpuidle
> > driver the default governor is gonna be haltpoll for a guest (given haltpoll
> > governor doesn't get registered for baremetal).
>
> Right.
>
> > Right now, for a KVM guest, the
> > idle governors have these ratings:
> >
> >  * ladder            -> 10
> >  * teo               -> 19
> >  * menu              -> 20
> >  * haltpoll          -> 21
> >  * ladder + nohz=off -> 25
>
> Yes. PowerPC KVM guests crash currently due to the use of the haltpoll
> governor (have a patch in my queue to fix this, but your solution
> embraces more cases).
>
> > When a guest is booted with MWAIT and intel_idle is probed and sucessfully
> > registered, we will end up with a haltpoll governor being used as opposed to
> > 'menu' (which used to be the default case). This would prevent IIUC that other
> > C-states get used other than poll_state (state 0) and state 1.
> >
> > Given that haltpoll governor is largely only useful with a cpuidle-haltpoll
> > it doesn't look reasonable to be the default? What about using haltpoll governor
> > as default when haltpoll idle driver registers or modloads.
> >
> > My idea to achieve the above would be to decrease the rating to 9 (before the
> > lowest rated governor) and retain old defaults before haltpoll. Then we would
> > allow a cpuidle driver to define a preferred governor to switch on idle driver
> > registration. Naturally all of would be ignored if overidden by
> > cpuidle.governor=.
> >
> > The diff below the scissors line is an example of that.
> >
> > Thoughts?
>
> Works for me. Rafael?

It works for me too, basically, except that I would rename
cpuidle_default_governor in the patch to cpuidle_prev_governor.
