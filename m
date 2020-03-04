Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C02179672
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 18:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbgCDRNx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 12:13:53 -0500
Received: from mail-io1-f41.google.com ([209.85.166.41]:41761 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbgCDRNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 12:13:52 -0500
Received: by mail-io1-f41.google.com with SMTP id m25so3220853ioo.8
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2020 09:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LccCV/NpVCNcplwkMeJmlIoskRRTJ9nTNKn+RvMhq/k=;
        b=tGDKQyb0/66dbSez+d1maOoZX+onksVYfC4cikQmXFQkkGEOo4T+DpBGhLgsCJJ3bJ
         4qahjgysHT90te4gmUoEY7CyAmFV+ioPpMuTEE/ZiB+PBIgG5RlBFt8mSRwDswIKz/0J
         /WUC96qae6zacHoL5JBWRCLIMKMP/aED6A/IWxp6AILmz5XtKQzFV3/GhTv1clXvjkfh
         z5WCreUYIUZbqdVMAyIYqW3tDOmpvPvId9wtVdzte/4T9N4F/uwowzNGalA1begZ4GO0
         fUyp7y/0SZKBb4Gn/MR4b41Smq2I7WXfQS8f4YpuX3ty++Wnrh720799wEO042UhmaUY
         Zfyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LccCV/NpVCNcplwkMeJmlIoskRRTJ9nTNKn+RvMhq/k=;
        b=FZ5TZSt4ZeUN15GXdUWBwe6XNbIot6tXcKUBUfFhaoJ9na6kavvuVyBePa6MOC8LAO
         6PN93xSqqSbscE3JuxALv8Mx2BTR/6uYvtCImU+eLSZZsEeSeUrSCQ9ykkvf3VJNGB0v
         YdgW1LuZbDnjU64efeUPRnnpwG5j5fn5k/OK32RDQhEsXfkIur0qo7BDM7GGOrbihp6P
         7qJuz+i3qPTi4aYIFWhlMfiFAEWxUFvOBescOkA6mXqk7TQGi4Dmf5esBD7PvsDhSERS
         8RpVutEuu2yICzmwzZoEuvy13OCeUHWY7ErB7A2Yo03qfU/eLFrMUnpl9xUuuaJI7eeA
         IEBQ==
X-Gm-Message-State: ANhLgQ0PBsZfpO0iuacgdv8FonNd/iN0lJSIAAS3AgShqs9tqFxU4W2N
        sB/MCrOXT1DUJL0CiQb+Z1kavw0k25sPBh736n5HcA==
X-Google-Smtp-Source: ADFU+vvLfOuiiw3NhbcYxvmwxCcubxcZbCtZ543KSrZpyd18SOMJycPFGgYRCCMoPYZfks1EN9ElTG2o/FvHG+z7xRM=
X-Received: by 2002:a6b:4e15:: with SMTP id c21mr2856195iob.119.1583342031673;
 Wed, 04 Mar 2020 09:13:51 -0800 (PST)
MIME-Version: 1.0
References: <CALMp9eQqAfehUnNmTU6QuiZPWQ-FtYhLXZ_SNHe=YRkGVJsKLw@mail.gmail.com>
 <CAM3pwhEXonbu-He1KD52ggEHHKVWok4Bac-4Woq7FvYL9pHykA@mail.gmail.com> <20200304161912.GC21662@linux.intel.com>
In-Reply-To: <20200304161912.GC21662@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 4 Mar 2020 09:13:40 -0800
Message-ID: <CALMp9eQepf7TgC3upv1u+zrygXZWQmJcU7Eq=ODTqiYicKXFLA@mail.gmail.com>
Subject: Re: Nested virtualization and software page walks in the L1 hypervsior
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Peter Feiner <pfeiner@google.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 4, 2020 at 8:19 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Mar 03, 2020 at 04:22:57PM -0800, Peter Feiner wrote:
> > On Sat, Feb 29, 2020 at 2:31 PM Jim Mattson <jmattson@google.com> wrote:
> > >
> > > Peter Feiner asked me an intriguing question the other day. If you
> > > have a hypervisor that walks  its guest's x86 page tables in software
> > > during emulation, how can you make that software page walk behave
> > > exactly like a hardware page walk? In particular, when the hypervisor
> > > is running as an L1 guest, how is it possible to write the software
> > > page walk so that accesses to L2's x86 page tables are treated as
> > > reads if L0 isn't using EPT A/D bits, but they're treated as writes if
> > > L0 is using EPT A/D bits? (Paravirtualization is not allowed.)
> > >
> > > It seems to me that this behavior isn't virtualizable. Am I wrong?
> >
> > Jim, I thought about this some more after talking to you. I think it's
> > entirely moot what L0 sees so long as L1 and L2 work correctly. So,
> > the question becomes, is there anything that L0 could possibly rely on
> > this behavior for? My first thought was dirty tracking, but that's not
> > a problem because *writes* to the L2 x86 page tables' A/D bits will
> > still be intercepted by L0. The missing D bit on a guest page that
> > doesn't actually change doesn't matter :-)
>
> Ya.  The hardware behavior of setting the Dirty bit is effectively a
> spurious update.  Not emulating that behavior is arguably a good thing :-).
>
> Presumably, the EPT walks are overzealous in treating IA32 page walks as
> writes to allow for simpler hardware implementations, e.g. the mechanism to
> handle A/D bit updates doesn't need to handle the case where setting an A/D
> bit in an IA32 page walk would also trigger an D bit update for the
> associated EPT walk.

I was actually more concerned about the EPT permissions aspect. With
EPT A/D bits enabled, a non-writable EPT page can't be used for a
hardware page walk, but it can be used for a software page walk. Maybe
that's neither here nor there.
