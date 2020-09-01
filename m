Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C52259F8D
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 22:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731162AbgIAUAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 16:00:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46511 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727107AbgIAUAe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Sep 2020 16:00:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598990432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vc3R4m+8MTjsRaa5gUjV4LA0oqfm1u6CW8ImByjlE7A=;
        b=OATQFdU2ghR72FVMuoJTeAM8fgO8hDXPKLHGnh7zIi921kJMJ6KpQdibH7qlMI+RxEVkeQ
        cKUQwHXPylsKNNBmQa/LD/Y3S+bvL8GuVMPyRdZNctadImggpDIFca/bGXJUCMa4qrNmFI
        mLYmuTIJLkJL/ADVMaANzJfyb9yoKVw=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-O9gPLIQ6PHGMfrPAm5yUWg-1; Tue, 01 Sep 2020 16:00:26 -0400
X-MC-Unique: O9gPLIQ6PHGMfrPAm5yUWg-1
Received: by mail-qt1-f200.google.com with SMTP id g1so1864043qtc.22
        for <kvm@vger.kernel.org>; Tue, 01 Sep 2020 13:00:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Vc3R4m+8MTjsRaa5gUjV4LA0oqfm1u6CW8ImByjlE7A=;
        b=pc5pcwV89NagoWidDLI7JJN6Fill7tgsYLb/rIaC5aLjLa6sNS8oRdI0QWomaXaB3j
         diuaaVyame9Es5xQvGXQ4ufc/8jSw9mf/IsW41hSRV4oLrQX827jg1HudvaAPpvTvAwb
         wGfVucjNKYNq9ezBAfLI+fKJczgV9mInfCezi9KxO0OYkoY1IurRG/11m35VYgQuvOp8
         sxIt8bNk2m5weJEK6WMol+tV0HIvq896bCe+XC4q5FjiUvO84YjrxCbavXAbnD896jhO
         VIdX63Sovx72M7/z+uFC6BKLJK5vEfCVoLOKu7Z64B9+sqZcTjcAueRJLMzRzMykVgQu
         0VDw==
X-Gm-Message-State: AOAM530DhoskDwcoYTetcn0r4eKjH8l2iewdl7wDCQkij0c1TXUIn/qc
        G44iGkWsvhFr3UZr2AeMOJQsrrpZtBz1zotbN/BKZcUVih7QCEYKddO7p2MFq+FkqKFkIqfPRo9
        43LaKhy3LAzPt
X-Received: by 2002:a37:64d4:: with SMTP id y203mr3623674qkb.359.1598990424706;
        Tue, 01 Sep 2020 13:00:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyu0YmC5kC1aUFd9w+Ovk9eAmNQQBT7X2Nm9TKQFxFHF2t+4Nd1e2v1kCKNfsvGi8l6orS7/A==
X-Received: by 2002:a37:64d4:: with SMTP id y203mr3623648qkb.359.1598990424405;
        Tue, 01 Sep 2020 13:00:24 -0700 (PDT)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-11-70-53-122-15.dsl.bell.ca. [70.53.122.15])
        by smtp.gmail.com with ESMTPSA id x126sm2733262qkb.101.2020.09.01.13.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 13:00:22 -0700 (PDT)
Date:   Tue, 1 Sep 2020 16:00:21 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: x86: KVM_MEM_PCI_HOLE memory
Message-ID: <20200901200021.GB3053@xz-x1>
References: <20200807141232.402895-1-vkuznets@redhat.com>
 <20200825212526.GC8235@xz-x1>
 <87eenlwoaa.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87eenlwoaa.fsf@vitty.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 01, 2020 at 04:43:25PM +0200, Vitaly Kuznetsov wrote:
> Peter Xu <peterx@redhat.com> writes:
> 
> > On Fri, Aug 07, 2020 at 04:12:29PM +0200, Vitaly Kuznetsov wrote:
> >> When testing Linux kernel boot with QEMU q35 VM and direct kernel boot
> >> I observed 8193 accesses to PCI hole memory. When such exit is handled
> >> in KVM without exiting to userspace, it takes roughly 0.000001 sec.
> >> Handling the same exit in userspace is six times slower (0.000006 sec) so
> >> the overal; difference is 0.04 sec. This may be significant for 'microvm'
> >> ideas.
> >
> > Sorry to comment so late, but just curious... have you looked at what's those
> > 8000+ accesses to PCI holes and what they're used for?  What I can think of are
> > some port IO reads (e.g. upon vendor ID field) during BIOS to scan the devices
> > attached.  Though those should be far less than 8000+, and those should also be
> > pio rather than mmio.
> 
> And sorry for replying late)
> 
> We explicitly want MMIO instead of PIO to speed things up, afaiu PIO
> requires two exits per device (and we exit all the way to
> QEMU). Julia/Michael know better about the size of the space.
> 
> >
> > If this is only an overhead for virt (since baremetal mmios should be fast),
> > I'm also thinking whether we can make it even better to skip those pci hole
> > reads.  Because we know we're virt, so it also gives us possibility that we may
> > provide those information in a better way than reading PCI holes in the guest?
> 
> This means let's invent a PV interface and if we decide to go down this
> road, I'd even argue for abandoning PCI completely. E.g. we can do
> something similar to Hyper-V's Vmbus.

My whole point was more about trying to understand the problem behind.
Providing a fast path for reading pci holes seems to be reasonable as is,
however it's just that I'm confused on why there're so many reads on the pci
holes after all.  Another important question is I'm wondering how this series
will finally help the use case of microvm.  I'm not sure I get the whole point
of it, but... if microvm is the major use case of this, it would be good to
provide some quick numbers on those if possible.

For example, IIUC microvm uses qboot (as a better alternative than seabios) for
fast boot, and qboot has:

https://github.com/bonzini/qboot/blob/master/pci.c#L20

I'm kind of curious whether qboot will still be used when this series is used
with microvm VMs?  Since those are still at least PIO based.

Thanks,

-- 
Peter Xu

