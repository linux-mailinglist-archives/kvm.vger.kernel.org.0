Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6522B11F3
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 23:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgKLWmu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 17:42:50 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:47642 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgKLWmt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Nov 2020 17:42:49 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605220967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PtB9NAxfiQap1pp3nxZvuOoDIPTo5gMSqFn75f0MaeA=;
        b=CaP8VQrefkrhEsMv82YyMOkLUQLnQrgjnx+zJ0mgvuj2W68b+aHj4w6Uaodv2sbISHhEas
        EKY0yrf/JpGwK2hS1KWrZDW6Xp5dqVNjjTeyUNvss4YGrBdQiJqqE37DCm7/K8oAoQLzBr
        Pd9ohCrwCnEXl/ESMTycYl5A6wVkmXKpVqs/Xh1LB0ogHanr+wrfYxihrXxqucTvPhRA/5
        VInbRhmTNOqRVCsxUnSgp1/MGYf5JkOozUpZq/b9FGw6fTPVgVhvLK6DTEM8nvL7jH946M
        Km8pSZ2DHX1318zKHZie9/q1ZW3ZZXLZar/hLTI1KgwRp8i5S1JhNeWVNbn/2A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605220967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PtB9NAxfiQap1pp3nxZvuOoDIPTo5gMSqFn75f0MaeA=;
        b=Qf1JSP13w9S5KLD1yG48HF9wSR15pf//4+ooA3P81lwVidKykHYNwB9SX6zA8aqo5txh44
        pJNl5CB8Ar/IsRBQ==
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Tian\, Kevin" <kevin.tian@intel.com>
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
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
In-Reply-To: <20201112193253.GG19638@char.us.oracle.com>
References: <20201107001207.GA2620339@nvidia.com> <87pn4nk7nn.fsf@nanos.tec.linutronix.de> <20201108235852.GC32074@araj-mobl1.jf.intel.com> <874klykc7h.fsf@nanos.tec.linutronix.de> <20201109173034.GG2620339@nvidia.com> <87pn4mi23u.fsf@nanos.tec.linutronix.de> <20201110051412.GA20147@otc-nc-03> <875z6dik1a.fsf@nanos.tec.linutronix.de> <20201110141323.GB22336@otc-nc-03> <MWHPR11MB16455B594B1B48B6E3C97C108CE80@MWHPR11MB1645.namprd11.prod.outlook.com> <20201112193253.GG19638@char.us.oracle.com>
Date:   Thu, 12 Nov 2020 23:42:46 +0100
Message-ID: <877dqqmc2h.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 12 2020 at 14:32, Konrad Rzeszutek Wilk wrote:
>> 4. Using CPUID to detect running as guest. But as Thomas pointed out, this
>> approach is less reliable as not all hypervisors do this way.
>
> Is that truly true? It is the first time I see the argument that extra
> steps are needed and that checking for X86_FEATURE_HYPERVISOR is not enough.
>
> Or is it more "Some hypervisor probably forgot about it, so lets make sure we patch
> over that possible hole?"

Nothing enforces that bit to be set. The bit is a pure software
convention and was proposed by VMWare in 2008 with the following
changelog:

 "This patch proposes to use a cpuid interface to detect if we are
  running on an hypervisor.

  The discovery of a hypervisor is determined by bit 31 of CPUID#1_ECX,
  which is defined to be "hypervisor present bit". For a VM, the bit is
  1, otherwise it is set to 0. This bit is not officially documented by
  either Intel/AMD yet, but they plan to do so some time soon, in the
  meanwhile they have promised to keep it reserved for virtualization."

The reserved promise seems to hold. AMDs APM has it documented. The
Intel SDM not so.

Also the kernel side of KVM does not enforce that bit, it's up to the user
space management to set it.

And yes, I've tripped over this with some hypervisors and even qemu KVM
failed to set it in the early days because it was masked with host CPUID
trimming as there the bit is obviously 0.

DMI vendor name is pretty good final check when the bit is 0. The
strings I'm aware of are:

QEMU, Bochs, KVM, Xen, VMware, VMW, VMware Inc., innotek GmbH, Oracle
Corporation, Parallels, BHYVE, Microsoft Corporation

which is not complete but better than nothing ;)

Thanks,

        tglx
