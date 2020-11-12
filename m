Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6342AFD3A
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 02:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgKLBcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 20:32:02 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:41558 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728214AbgKLBNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 20:13:40 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605143617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NC+uvhL2XYSO0lp2yao70R5XrrcbGD310dMy9lHjfk0=;
        b=oMtBw1dK6hwnAziR1Sa8n0nrEDU67WCC95A9JQj6dM7qem4HR9yausWmN9pKdbDKCOa8Mv
        +nrKwuVUTvpRAO87CKbY+AmPfqP2eQAjgoYG/QCJxYG7Xc7xcMQukj0Uo6EP/7v4FIwgI5
        O6hlKMxqfK5T/XkbyK3dIP0W6jTM5udWg8ZL/QuHEuYgTsPeEC4A39q74mAp6eDAk+CNFh
        He38a8YVfbtGVOQ68jieQy7DRRBnpZUdo3zV2Q5GzBSeY2eaCl4SGXbzFaUwbJxvaSPgYw
        ORSXBbLnH22RYGtcWC85d+QSiDkulHsCIdI5W7W0+8ZcjUPYeVsQhVqUM+NTaw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605143617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NC+uvhL2XYSO0lp2yao70R5XrrcbGD310dMy9lHjfk0=;
        b=3z7QskZLwhekH6gqUujryf4f99GewEXIaxAyVy1SSUshTt6+NGvqmhEamYRXIm1BM35TBc
        TIOmhz8YKbDE5oDA==
To:     "Raj\, Ashok" <ashok.raj@intel.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Tian\, Kevin" <kevin.tian@intel.com>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul\@kernel.org" <vkoul@kernel.org>,
        "Dey\, Megha" <megha.dey@intel.com>,
        "maz\@kernel.org" <maz@kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "alex.williamson\@redhat.com" <alex.williamson@redhat.com>,
        "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu\, Yi L" <yi.l.liu@intel.com>,
        "Lu\, Baolu" <baolu.lu@intel.com>,
        "Kumar\, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        "jing.lin\@intel.com" <jing.lin@intel.com>,
        "kwankhede\@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger\@redhat.com" <eric.auger@redhat.com>,
        "parav\@mellanox.com" <parav@mellanox.com>,
        "rafael\@kernel.org" <rafael@kernel.org>,
        "netanelg\@mellanox.com" <netanelg@mellanox.com>,
        "shahafs\@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao\@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "Ortiz\, Samuel" <samuel.ortiz@intel.com>,
        "Hossain\, Mona" <mona.hossain@intel.com>,
        "dmaengine\@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
In-Reply-To: <20201111230321.GC83266@otc-nc-03>
References: <20201106131415.GT2620339@nvidia.com> <20201106164850.GA85879@otc-nc-03> <20201106175131.GW2620339@nvidia.com> <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com> <20201107001207.GA2620339@nvidia.com> <87pn4nk7nn.fsf@nanos.tec.linutronix.de> <d69953378bd1fdcdda54a2fbe285f6c0b1484e8a.camel@infradead.org> <20201111154159.GA24059@infradead.org> <20201111160922.GA83266@otc-nc-03> <87k0uro7fz.fsf@nanos.tec.linutronix.de> <20201111230321.GC83266@otc-nc-03>
Date:   Thu, 12 Nov 2020 02:13:36 +0100
Message-ID: <877dqrnzr3.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ashok,

On Wed, Nov 11 2020 at 15:03, Ashok Raj wrote:
> On Wed, Nov 11, 2020 at 11:27:28PM +0100, Thomas Gleixner wrote:
>> which is the obvious sane and safe logic. But sure, why am I asking for
>> sane and safe in the context of virtualization?
>
> We can pick how to solve this, and just waiting for you to tell, what
> mechanism you prefer that's less painful and architecturally acceptible for
> virtualization and linux. We are all ears!

Obviously we can't turn the time back. The point I was trying to make is
that the general approach of just bolting things on top of the exiting
maze is bad in general.

Opt-out bits are error prone simply because anything which exists before
that point does not know that it should set that bit. Obvious, right?

CPUID bits are 'Feature available' and not 'Feature not longer
available' for a reason.

So with the introduction of VT this stringent road was left and the
approach was: Don't tell the guest OS that it's not running on bare
metal.

That's a perfectly fine approach for running existing legacy OSes which
do not care at all because they don't know about anything of this
newfangled stuff.

But it's a falls flat on it's nose for anything which comes past that
point simply because there is no reliable way to tell in which context
the OS runs.

The VMM can decide not to set or is not having support for setting the
software CPUID bit which tells the guest OS that it does NOT run on bare
metal and still hand in new fangled PCI devices for which the guest OS
happens to have a driver which then falls flat on it's nose because some
magic functionality is not there.

So we have the following matrix:

VMM   		Guest OS
Old             Old             -> Fine, does not support any of that
New             Old             -> Fine, does not support any of that
New             New             -> Fine, works as expected
Old             New             -> FAIL

To fix this we have to come up with heuristics again to figure out which
context we are running in and whether some magic feature can be
supported or not:

probably_on_bare_metal()
{
        if (CPUID(FEATURE_HYPERVISOR))
        	return false;
       	if (dmi_match_hypervisor_vendor())
        	return false;

        return PROBABLY_RUNNING_ON_BARE_METAL;
}

Yes, it works probably in most cases, but it still works by chance and
that's what I really hate about this; indeed 'hate' is not a strong
enough word.

Why on earth did VT not introduce a reliable way (instruction, CPUID
leaf, MSR, whatever, which can't be manipulated by the VMM to let the OS
figure out where it runs?)

Just because the general approach to these problems is: We can fix that
in software.

No, you can't fix inconsistency in software at all.

This is not the first time that we tell HW folks to stop this 'Fix this
in software' attitude which has caused more problems than it solved.

And you can argue in circles until you are blue, that inconsistency is
not going away. 

Everytime new (mis)features are added which need awareness of the OS
whether it runs on bare-metal or in a VM we have this unsolvable dance
of requiring that the underlying VMM has to tell the guest OS NOT to use
it instead of having the guest OS making the simple decision:

   if (!definitely_on_bare_metal())
   	return -ENOTSUPP;

or with a newer version of the guest OS:

   if (!definitely_on_bare_metal() && !hypervisor->supportsthis())
   	return -ENOTSUPP;

I'm halfways content to go with the above probably_on_bare_metal()
function as a replacement for definitely_on_bare_metal() to go forward,
but only for the very simple reason that this is the only option we
have.

Thanks,

        tglx
