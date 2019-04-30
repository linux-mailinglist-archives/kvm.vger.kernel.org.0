Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C209DF3D2
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 12:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbfD3KMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 06:12:01 -0400
Received: from ozlabs.org ([203.11.71.1]:37467 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727218AbfD3KL6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 06:11:58 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 44tcky5VJBz9sMM; Tue, 30 Apr 2019 20:11:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1556619114; bh=vqAXzW4IeIYV+oY2o3Prg6Wn6Vz9b0aiVRscX1gcxm4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B5ODvAfVYPSzhvAFFcZ4fLFhUyFgW7cttYItifUN/pf8dyMgB1KPeIIOPEPg8HVUO
         g0Rivut8wr18B5BK5bT4ASmqcAFrhZIduBUeqanJP5xKSUMk8Xa0zg/vT7ZjSwFHms
         IPZXPYFuTrADrZjtcBCMLJ8jtysDgY3FCFyiNujK7RqSM9x4PkGzNpbGaAU7rzt1tc
         96oWF7rT38PwlFe3jlAQtLHNUsG5myXBqFRs80XwH7k7VGaJHVIUmFgo0FAYag8JJ3
         SJvB8P2pmOBzTj56CEA09+ORVk/spr8NLi7yszw4fxT77M/U9o9RkKJyoifLkvrTvQ
         BTvdtaH81oBDg==
Date:   Tue, 30 Apr 2019 20:11:46 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>
Cc:     kvm-ppc@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>, kvm@vger.kernel.org
Subject: Re: [PATCH v6 00/17] KVM: PPC: Book3S HV: add XIVE native
 exploitation mode
Message-ID: <20190430101146.GJ32205@blackberry>
References: <20190418103942.2883-1-clg@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190418103942.2883-1-clg@kaod.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 18, 2019 at 12:39:25PM +0200, Cédric Le Goater wrote:
> On the POWER9 processor, the XIVE interrupt controller can control
> interrupt sources using MMIOs to trigger events, to EOI or to turn off
> the sources. Priority management and interrupt acknowledgment is also
> controlled by MMIO in the CPU presenter sub-engine.
> 
> PowerNV/baremetal Linux runs natively under XIVE but sPAPR guests need
> special support from the hypervisor to do the same. This is called the
> XIVE native exploitation mode and today, it can be activated under the
> PowerPC Hypervisor, pHyp. However, Linux/KVM lacks XIVE native support
> and still offers the old interrupt mode interface using a KVM device
> implementing the XICS hcalls over XIVE.
> 
> The following series is proposal to add the same support under KVM.
> 
> A new KVM device is introduced for the XIVE native exploitation
> mode. It reuses most of the XICS-over-XIVE glue implementation
> structures which are internal to KVM but has a completely different
> interface. A set of KVM device ioctls provide support for the
> hypervisor calls, all handled in QEMU, to configure the sources and
> the event queues. From there, all interrupt control is transferred to
> the guest which can use MMIOs.
> 
> These MMIO regions (ESB and TIMA) are exposed to guests in QEMU,
> similarly to VFIO, and the associated VMAs are populated dynamically
> with the appropriate pages using a fault handler. These are now
> implemented using mmap()s of the KVM device fd.
> 
> Migration has its own specific needs regarding memory. The patchset
> provides a specific control to quiesce XIVE before capturing the
> memory. The save and restore of the internal state is based on the
> same ioctls used for the hcalls.
> 
> On a POWER9 sPAPR machine, the Client Architecture Support (CAS)
> negotiation process determines whether the guest operates with a
> interrupt controller using the XICS legacy model, as found on POWER8,
> or in XIVE exploitation mode. Which means that the KVM interrupt
> device should be created at run-time, after the machine has started.
> This requires extra support from KVM to destroy KVM devices. It is
> introduced at the end of the patchset and requires some attention.
> 
> This is based on Linux 5.1-rc5 and is a candidate for 5.2. The OPAL
> patches have been merged now.

Thanks, patch series applied to my kvm-ppc-next tree.  I added two
patches of mine on top to make sure we exclude other execution paths
in the device release method, and to clear the escalation interrupt
hardware pointers on release.  I also modified your last patch to free
the xive structures in book3s.c rather than powerpc.c in order to fix
compilation for Book E configs.

Paul.
