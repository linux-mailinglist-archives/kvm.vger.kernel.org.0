Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9425227F184
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 20:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgI3Smy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 14:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgI3Smy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 14:42:54 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA4DC061755
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 11:42:53 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id q5so2910637ilj.1
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 11:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=baVH8D4ycog5eLQHQ1VEWx+mLxOlpC3JYeRNA6pOF4M=;
        b=BgDX9tTUCb8DXlDo/3vG5xiod+SvtLEWtMf3EqWdYGu1CNpOMYswndy+C26ARLoVjy
         87/G/kE6dtE9eb4Cxyczof++WX9+n0obxoHMgJGun3Arzf3R8R80zbdwJXT4VH7pZV4x
         D4BgPXZcf4MqPDt5d+QP7NP7OhBGp02e4CADYLFlPE13k22wW5zm4GG04Dy0TtJYmC+5
         TXQyDR16wU59bKsvgh6Ib9gxL0z3K6aCbC77XdYZyWZrB2/AnDSKPYDxzDG9lGnLCBHL
         NlYwVTvcGnPGwcZ9QNnOYegfItwqnybyxm2D0vMBa6koVuOjWJs5bj6XCr3dy1DBjM7U
         H+Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=baVH8D4ycog5eLQHQ1VEWx+mLxOlpC3JYeRNA6pOF4M=;
        b=NyyFWsJqvEUHn1nCoU1AtpNsFs6xj6xV9GthZPyMufbLq3NToiPZcI5BeZrHNNZrbh
         mHSPgBDzEhINiwDRg/SKXO7fCxPzqHtpfgFzoqPSkn6AbV9YKGpwJIHFYvvoNdIvtnCe
         kYxgr9riosaB8eYkQBiX9xtYXM2B1MgT6fR+1HOa6gEyZjLbtM3A7tOlupz1+/Q0ZAbe
         4ZkEEyfdS0EXIarGSgqDTrMXwiTmbVZLs+fjgVje2MX5z/GFRgWAy/VtirowiPz9+hC3
         jIexkTUgfZE309v7TWBcslJv/l8T0JScdNX0ypKlFzDKltpE3OwMff2qHHkf0rts/7pH
         7Ygg==
X-Gm-Message-State: AOAM533WksRWwKTmfplZxxKwhQ4IwlD3Xsc4njjzrTJexv8AoPY1wHl3
        VbzxijAK9bC45HU2FkhM1/c/hyjf0x/I+G7EPMQtzA==
X-Google-Smtp-Source: ABdhPJxZ/ifnxPqNMAuVGsrBI8knZ5ukEyX/3MLbg0PHpe9uRKkbEaTKhDC47ECxk+6nrXFZVMIlaVHtdL7f7FsKCNk=
X-Received: by 2002:a92:5b02:: with SMTP id p2mr2776850ilb.283.1601491372954;
 Wed, 30 Sep 2020 11:42:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com> <20200925212302.3979661-4-bgardon@google.com>
 <20200930165734.GE32672@linux.intel.com> <2633cc07-f106-25ba-0ab9-d4a422aca171@redhat.com>
In-Reply-To: <2633cc07-f106-25ba-0ab9-d4a422aca171@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 30 Sep 2020 11:42:42 -0700
Message-ID: <CANgfPd_NABYVqWqQLoxW8AVNQCL3jXYM+u7_oToQFm+SDa3AvA@mail.gmail.com>
Subject: Re: [PATCH 03/22] kvm: mmu: Init / Uninit the TDP MMU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 30, 2020 at 10:39 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 30/09/20 18:57, Sean Christopherson wrote:
> >> +
> >> +static bool __read_mostly tdp_mmu_enabled = true;
> >> +module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
> > This param should not exist until the TDP MMU is fully functional, e.g. running
> > KVM against "kvm: mmu: Support zapping SPTEs in the TDP MMU" immediately hits a
> > BUG() in the rmap code.  I haven't wrapped my head around the entire series to
> > grok whether it make sense to incrementally enable the TDP MMU, but my gut says
> > that's probably non-sensical.
>
> No, it doesn't.  Whether to add the module parameter is kind of
> secondary, but I agree it shouldn't be true---not even at the end of
> this series, since fast page fault for example is not implemented yet.
>
> Paolo
>
I fully agree, sorry about that. I should have at least defaulted the
module parameter to false before sending the series out. I'll remedy
that in the next patch set. (Unless you beat me to it, Paolo)
