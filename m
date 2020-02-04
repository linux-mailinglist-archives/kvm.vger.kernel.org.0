Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3759152205
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 22:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbgBDVnu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 16:43:50 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38700 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbgBDVnu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 16:43:50 -0500
Received: by mail-ot1-f65.google.com with SMTP id z9so18661318oth.5
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 13:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h4sd+ZATda3xgd2Cabp+ey5GfoagpPrGA3dH0HD9uD4=;
        b=om0IxymUwPkvWyb01X9tGRJ2/DQx9Zp+ONzq9K7omFBcxtLbIr+tzBJigBSQmHj8ji
         gecf238XvqhNWCuCqz2KAnrN3hTNL031wGf8u0cF3krNJjO2TYR57Dh5Iw9/Q50LRnkl
         QuE9a58jgymDElHyDs9NcX4/me9PQ561Fcz/F9UKFm3td3WJmgu2NBt2/IM50iZA2jYR
         ynmSHN6PcWaa83ih4P3Dpic9Y+SrcIIVXw5jNyh5WQPZRLL9gyDTVPllEJgs5elyQq2f
         f0vXXrc67OfZVvCrI/PryDxZ6ot5Kg/9J5OGoqR0kSXlTMTH4V1nKwTKuhVR/rFzH6xV
         XGow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h4sd+ZATda3xgd2Cabp+ey5GfoagpPrGA3dH0HD9uD4=;
        b=SdkW37Fm8pbKXlgwMUqpzCQbPmIRuOuTt+miuR9Q2Ept7KL2osKlGgOBQJCaU63xtV
         47u6T17e20N/dIxaMJvVjXsJamuBtGulh0wKOuoxQWgGgUDQOZbA/zWne7v0UKKlh9k5
         AhsWBL+Xiwxx6WcWuN2GzPYszLBKYX65jS1n+XkI6MBQNwgAsHz+6uSalWIzQebLk+a+
         ac5LSYUEQqifnLxiPJBa5ad4Hx11qv4SEx6fSlrYlU2AYx9kkOjKSO3tc1Rd7XQt2co2
         xldEDiO4xGSZ+XsEfuw0bA55nTqHa2K+kWmNSUQcKf/iybp/nowvQWkBbps/d5cXcL9R
         sQOw==
X-Gm-Message-State: APjAAAW59A2T4pd1Wr/z2qiDAqYiLLfmUUiPttImCsql9RJnQYyhNOiW
        2LG5pf3fe3JHx5wjVHb5DebmC5EI4GUSj3nc4YQUIg==
X-Google-Smtp-Source: APXvYqyzRa/EgbcHWU5oWYs3EwkkIOeOuYIq70nRVJ+YY8OVe8Drtam8ArdPOslMqNhBe4zCRcUBk63gv56UchKAyW4=
X-Received: by 2002:a9d:4e99:: with SMTP id v25mr24222626otk.363.1580852628908;
 Tue, 04 Feb 2020 13:43:48 -0800 (PST)
MIME-Version: 1.0
References: <20200110190313.17144-1-joao.m.martins@oracle.com>
 <20200110190313.17144-11-joao.m.martins@oracle.com> <e605fed8-46f5-6a07-11e6-2cc079a1159b@google.com>
 <CAPcyv4iiSsEOsfEwLQcV3bNDjBSxw1OgWoBdEWPQEymq6=xm-A@mail.gmail.com> <ae788015-616f-96e6-3a0e-39c1911c4b01@google.com>
In-Reply-To: <ae788015-616f-96e6-3a0e-39c1911c4b01@google.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 4 Feb 2020 13:43:37 -0800
Message-ID: <CAPcyv4ibWZgCSTqnYLicVR3vXeNKwuWSnV5K8fCwvyhz_h=0GQ@mail.gmail.com>
Subject: Re: [PATCH RFC 10/10] nvdimm/e820: add multiple namespaces support
To:     Barret Rhoden <brho@google.com>
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 4, 2020 at 10:20 AM Barret Rhoden <brho@google.com> wrote:
>
> Hi -
>
> On 2/4/20 11:44 AM, Dan Williams wrote:
> > On Tue, Feb 4, 2020 at 7:30 AM Barret Rhoden <brho@google.com> wrote:
> >>
> >> Hi -
> >>
> >> On 1/10/20 2:03 PM, Joao Martins wrote:
> >>> User can define regions with 'memmap=size!offset' which in turn
> >>> creates PMEM legacy devices. But because it is a label-less
> >>> NVDIMM device we only have one namespace for the whole device.
> >>>
> >>> Add support for multiple namespaces by adding ndctl control
> >>> support, and exposing a minimal set of features:
> >>> (ND_CMD_GET_CONFIG_SIZE, ND_CMD_GET_CONFIG_DATA,
> >>> ND_CMD_SET_CONFIG_DATA) alongside NDD_ALIASING because we can
> >>> store labels.
> >>
> >> FWIW, I like this a lot.  If we move away from using memmap in favor of
> >> efi_fake_mem, ideally we'd have the same support for full-fledged
> >> pmem/dax regions and namespaces that this patch brings.
> >
> > No, efi_fake_mem only supports creating dax-regions. What's the use
> > case that can't be satisfied by just specifying multiple memmap=
> > ranges?
>
> I'd like to be able to create and destroy dax regions on the fly.  In
> particular, I want to run guest VMs using the dax files for guest
> memory, but I don't know at boot time how many VMs I'll have, or what
> their sizes are.  Ideally, I'd have separate files for each VM, instead
> of a single /dev/dax.
>
> I currently do this with fs-dax with one big memmap region (ext4 on
> /dev/pmem0), and I use the file system to handle the
> creation/destruction/resizing and metadata management.  But since fs-dax
> won't work with device pass-through, I started looking at dev-dax, with
> the expectation that I'd need some software to manage the memory (i.e.
> allocation).  That led me to ndctl, which seems to need namespace labels
> to have the level of control I was looking for.

Ah, got it, you only ended up at wanting namespace labels because
there was no other way to carve up device-dax. That's changing as part
of the efi_fake_mem= enabling and I have a patch set in the works to
allow discontiguous sub-divisions of a device-dax range. Note that is
this branch rebases frequently:

https://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm.git/log/?h=libnvdimm-pending


>
> Thanks,
>
> Barret
>
