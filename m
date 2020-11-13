Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757BD2B1BEC
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 14:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgKMNcn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 08:32:43 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51944 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726324AbgKMNcn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Nov 2020 08:32:43 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605274360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TYrlC4Z3oyV9cVDb0VElXHBAri5cQqzUS+x0zq654No=;
        b=o45t2GadHfP+M9w7dgKn+A/+UbJfJNms1E8KxSAdpKBG0H3tUgOgUHIvOYmdKQNiini+GQ
        7YQWs+FtCEUfl3gR3FJW39t/T1MG5y4dCkpHowGjmOfhp6iw/1isx1HIkM1P6UXHu/43Oo
        R34U5hV5hnDSNgBFbfvuP1zeEpbSSeNcX7yV4fx6MCXk+58KxU3nmbLkJJA+iDNBt+La3n
        RVZIxcUw8NfGsR9egcUY0L0Al7wX7UzM6MrVSaR+cqf2TpXwIB+bynFT9Zf0zSlaH4zJCV
        WBjIYE2YT+fer10iN2qfLrD4o+0QZI6Y+3BI1wzV1Ib5g2IAy5IkDrLAlQxGzA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605274360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TYrlC4Z3oyV9cVDb0VElXHBAri5cQqzUS+x0zq654No=;
        b=W/ejevJwovY97xrykdBV3K7LOG7irV5AjqOSvAym9IboHr6RFmx8bfXzYHsf3rSe3y5Gud
        eRVbzLgsOsaeYRAg==
To:     "Tian\, Kevin" <kevin.tian@intel.com>,
        "Wilk\, Konrad" <konrad.wilk@oracle.com>
Cc:     "Raj\, Ashok" <ashok.raj@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Williams\, Dan J" <dan.j.williams@intel.com>,
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
        Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
In-Reply-To: <MWHPR11MB1645F27808F1F5E79646A3A88CE60@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20201107001207.GA2620339@nvidia.com> <87pn4nk7nn.fsf@nanos.tec.linutronix.de> <20201108235852.GC32074@araj-mobl1.jf.intel.com> <874klykc7h.fsf@nanos.tec.linutronix.de> <20201109173034.GG2620339@nvidia.com> <87pn4mi23u.fsf@nanos.tec.linutronix.de> <20201110051412.GA20147@otc-nc-03> <875z6dik1a.fsf@nanos.tec.linutronix.de> <20201110141323.GB22336@otc-nc-03> <MWHPR11MB16455B594B1B48B6E3C97C108CE80@MWHPR11MB1645.namprd11.prod.outlook.com> <20201112193253.GG19638@char.us.oracle.com> <877dqqmc2h.fsf@nanos.tec.linutronix.de> <MWHPR11MB1645F27808F1F5E79646A3A88CE60@MWHPR11MB1645.namprd11.prod.outlook.com>
Date:   Fri, 13 Nov 2020 14:32:40 +0100
Message-ID: <874kltmlfr.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 13 2020 at 02:42, Kevin Tian wrote:
>> From: Thomas Gleixner <tglx@linutronix.de>
> CPUID#1_ECX is a x86 thing. Do we need to figure out probably_on_
> bare_metal for every architecture altogether, or is it OK to just
> handle it for x86 arch at this stage? Based on previous discussions 
> ims is just one piece of multiple technologies to enable SIOV-like
> scalability. Ideally arch-specific enablement beyond ims (e.g. the 
> IOMMU part) will be required for such scaled usage thus we 
> may just leave ims disabled for non-x86 and wait until that time to 
> figure out arch specific probably_on_bare_metal?

Of course is this not only an x86 problem. Every architecture which
supports virtualization has the same issue. ARM(64) has no way to tell
for sure whether the machine runs bare metal either. No idea about the
other architectures.

Thanks,

        tglx
