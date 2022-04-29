Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3ECE5140C4
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 05:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbiD2DHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 23:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234847AbiD2DHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 23:07:47 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EED1BF304
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 20:04:30 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id p6so5988631plf.9
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 20:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5VVgFc+AWvo5UdP8jPH8kMYu27hfTPHx7TcE08ruWnQ=;
        b=IR/xKb+GabRkSbkhHaocsMPuhj4+DswB7PeaFqXyL5ZCswzf+2jRMoChLc7LEI6GoG
         pWpKwQrOX3hFPBUwyDnlNrEbg4iGQ1/BRI22Yj6Ow/FLmxaasrJK5GHJ9mOYCBB8VX7p
         vOhomVSn/Jb9cvvd3HyWrCIRQDpD2CVgCnIjhGXjhbazcInjTmXGM0Em/R0Lp+kAsF+1
         XnnFuduYAprfX1W2w09E2RkF9QA8/VG3WSAUI3pCasm2GnuCJqWwQgFzifBD56dL/f4e
         YZP++qNEiK7Wc9Y7tYIAYrfNr+S0n/ZhxX+ZT5daJZ/dFaFSBhn/MYis8k8LQufVqY96
         POPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5VVgFc+AWvo5UdP8jPH8kMYu27hfTPHx7TcE08ruWnQ=;
        b=jgHPs4Sb9bc5dsh9cnXomhn0tArawD18CnwsE4OgHdoGtJ2DEyFsoZsFe42dO8jN5c
         PpamdLOXANvIy/4Sm5x4SCf9BhdyMIEz6rYt39DD0RNQPJxcUercaUNhfae4pLvscO0I
         P9GGHAkdgO8+UoQDhHfM0T3CFhueyGYBezMdQlideqfFgvJfFB30RsiQeeiQs2bbpseM
         g0VIpt0DF4+jNKn1QBjqmqLD2h5nED0tOl1pNQLcDkQi5CLiC88LfLVFjz/yJ4fxFkJ/
         iTGw5g6YUh1t2wtKlIw8RzgUvKhoNijOykyEGUmO24ag/+Q4PdPofey8oXLpmI7YRgCm
         QyzQ==
X-Gm-Message-State: AOAM533Zda4f3ot9PtZiYOquHhLImXPypFYnzq7LaYPpqM0wXAJU9J45
        f2/cLUDKv9H7ifAKhhTKFDqpKiI/v/lSD1LRWnWU3Q==
X-Google-Smtp-Source: ABdhPJzlzgG4+md3WPt7mPqg66q3zRmdw58tFxmZdy9Oa/PGMQN0pBnrwycAdpTKW4vv20P5zf/JoPGGGTJNqlAMYHk=
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id
 d22-20020a170902729600b0014b4bc60e81mr36466562pll.132.1651201470117; Thu, 28
 Apr 2022 20:04:30 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1649219184.git.kai.huang@intel.com> <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
 <ecf718abf864bbb2366209f00d4315ada090aedc.camel@intel.com>
 <de24ac7e-349c-e49a-70bb-31b9bc867b10@intel.com> <9b388f54f13b34fe684ef77603fc878952e48f87.camel@intel.com>
 <d98ca73b-2d2d-757d-e937-acc83cfedfb0@intel.com> <c90a10763969077826f42be6f492e3a3e062326b.camel@intel.com>
 <fc1ca04d94ad45e79c0297719d5ef50a7c33c352.camel@intel.com>
In-Reply-To: <fc1ca04d94ad45e79c0297719d5ef50a7c33c352.camel@intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 28 Apr 2022 20:04:19 -0700
Message-ID: <CAPcyv4gEwjnNE9cWb_KLZ6C7-UxKdUMZKFPF+LAJ4L1SjByisw@mail.gmail.com>
Subject: Re: [PATCH v3 00/21] TDX host kernel support
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 28, 2022 at 6:40 PM Kai Huang <kai.huang@intel.com> wrote:
>
> On Thu, 2022-04-28 at 12:58 +1200, Kai Huang wrote:
> > On Wed, 2022-04-27 at 17:50 -0700, Dave Hansen wrote:
> > > On 4/27/22 17:37, Kai Huang wrote:
> > > > On Wed, 2022-04-27 at 14:59 -0700, Dave Hansen wrote:
> > > > > In 5 years, if someone takes this code and runs it on Intel hardware
> > > > > with memory hotplug, CPU hotplug, NVDIMMs *AND* TDX support, what happens?
> > > >
> > > > I thought we could document this in the documentation saying that this code can
> > > > only work on TDX machines that don't have above capabilities (SPR for now).  We
> > > > can change the code and the documentation  when we add the support of those
> > > > features in the future, and update the documentation.
> > > >
> > > > If 5 years later someone takes this code, he/she should take a look at the
> > > > documentation and figure out that he/she should choose a newer kernel if the
> > > > machine support those features.
> > > >
> > > > I'll think about design solutions if above doesn't look good for you.
> > >
> > > No, it doesn't look good to me.
> > >
> > > You can't just say:
> > >
> > >     /*
> > >      * This code will eat puppies if used on systems with hotplug.
> > >      */
> > >
> > > and merrily await the puppy bloodbath.
> > >
> > > If it's not compatible, then you have to *MAKE* it not compatible in a
> > > safe, controlled way.
> > >
> > > > > You can't just ignore the problems because they're not present on one
> > > > > version of the hardware.
> > >
> > > Please, please read this again ^^
> >
> > OK.  I'll think about solutions and come back later.
> > >
>
> Hi Dave,
>
> I think we have two approaches to handle memory hotplug interaction with the TDX
> module initialization.
>
> The first approach is simple.  We just block memory from being added as system
> RAM managed by page allocator when the platform supports TDX [1]. It seems we
> can add some arch-specific-check to __add_memory_resource() and reject the new
> memory resource if platform supports TDX.  __add_memory_resource() is called by
> both __add_memory() and add_memory_driver_managed() so it prevents from adding
> NVDIMM as system RAM and normal ACPI memory hotplug [2].

What if the memory being added *is* TDX capable? What if someone
wanted to manage a memory range as soft-reserved and move it back and
forth from the core-mm to device access. That should be perfectly
acceptable as long as the memory is TDX capable.

> The second approach is relatively more complicated.  Instead of directly
> rejecting the new memory resource in __add_memory_resource(), we check whether
> the memory resource can be added based on CMR and the TDX module initialization
> status.   This is feasible as with the latest public P-SEAMLDR spec, we can get
> CMR from P-SEAMLDR SEAMCALL[3].  So we can detect P-SEAMLDR and get CMR info
> during kernel boots.  And in __add_memory_resource() we do below check:
>
>         tdx_init_disable();     /*similar to cpu_hotplug_disable() */
>         if (tdx_module_initialized())
>                 // reject memory hotplug
>         else if (new_memory_resource NOT in CMRs)
>                 // reject memory hotplug
>         else
>                 allow memory hotplug
>         tdx_init_enable();      /*similar to cpu_hotplug_enable() */
>
> tdx_init_disable() temporarily disables TDX module initialization by trying to
> grab the mutex.  If the TDX module initialization is already on going, then it
> waits until it completes.
>
> This should work better for future platforms, but would requires non-trivial
> more code as we need to add VMXON/VMXOFF support to the core-kernel to detect
> CMR using  SEAMCALL.  A side advantage is with VMXON in core-kernel we can
> shutdown the TDX module in kexec().
>
> But for this series I think the second approach is overkill and we can choose to
> use the first simple approach?

This still sounds like it is trying to solve symptoms and not the root
problem. Why must the core-mm never have non-TDX memory when VMs are
fine to operate with either core-mm pages or memory from other sources
like hugetlbfs and device-dax?
