Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05DCE3B3F4F
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 10:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhFYIby (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 04:31:54 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60168 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbhFYIbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 04:31:53 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624609771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fn6G/qgwKubMixi1h+nQ51xRNKf4+bW+OOidmseH19Y=;
        b=jfJwCVJ2f3aHzGfs0V3+zxEgmszn8DhAXnBfJHs8FNXfWvysxHkkykm003xaRuoHGJcpCF
        vIKv2E59rItp+CbOkae9rFiO0r9iXQEsc6b2sw9a5ZPixR6uDkoOJgz9WQKrj4hkoyQd4y
        d1seNB7ChiWZp5OexCg2Si7T8HSSgRthO//hI8d0Fc0k1ISwKM6iB2pu1FwKENSCGMeUM2
        RWpcc2D2uz84IDJiISuLmYuTAXJ6/RrzQDWXakkBoTsuNshJnOsR+BVRt68Vs+tGQwLRxO
        4SOzl/xBMqaieT/Hl6hP3NvIUeLtqy+TxxKBgOGJ42G6rQdtABDWNEwuOnDkJA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624609771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fn6G/qgwKubMixi1h+nQ51xRNKf4+bW+OOidmseH19Y=;
        b=cDGbcBEaYI4Ay7EQ5MEQt2JuWlC9e+0ZeBTseXnxTx2zEUajia4GWqeRpOQr3O66c/gSUz
        /Gd6k0zA4jmS4DDg==
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian\, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Dey\, Megha" <megha.dey@intel.com>,
        "Raj\, Ashok" <ashok.raj@intel.com>,
        "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        "Liu\, Yi L" <yi.l.liu@intel.com>,
        "Lu\, Baolu" <baolu.lu@intel.com>,
        "Williams\, Dan J" <dan.j.williams@intel.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        "Kumar\, Sanjay K" <sanjay.k.kumar@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: Virtualizing MSI-X on IMS via VFIO
In-Reply-To: <20210624154434.11809b8f.alex.williamson@redhat.com>
References: <MWHPR11MB1886E14C57689A253D9B40C08C079@MWHPR11MB1886.namprd11.prod.outlook.com> <8735t7wazk.ffs@nanos.tec.linutronix.de> <20210624154434.11809b8f.alex.williamson@redhat.com>
Date:   Fri, 25 Jun 2021 10:29:30 +0200
Message-ID: <87r1gquz2t.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alex!

On Thu, Jun 24 2021 at 15:44, Alex Williamson wrote:
> On Thu, 24 Jun 2021 17:14:39 +0200
> Thomas Gleixner <tglx@linutronix.de> wrote:
>
>> After studying the MSI-X specification again, I think there is another
>> option to solve this for MSI-X, i.e. the dynamic sizing part:
>> 
>> MSI requires to disable MSI in order to update the number of enabled
>> vectors in the control word.
>
> Exactly what part of the spec requires this?  This is generally the
> convention I expect too, and there are complications around contiguous
> vectors and data field alignment, but I'm not actually able to find a
> requirement in the spec that MSI Enable must be 0 when modifying other
> writable fields or that writable fields are latched when MSI Enable is
> set.

There is nothing in the spec which mandates that, but based on
experience I know that devices latch the number of vectors field when
the enable bit goes from 0 to 1, which makes sense. Devices derive their
internal interrupt routing from that.

>> which means that the function must reread the table entry when the mask
>> bit in the vector control word is cleared.
>
> What is a "valid" message as far as the device is concerned?  "Valid"
> is meaningful to system software and hardware, the device doesn't
> care.

That's correct, it uses whatever is there.

> So caching/latching occurs on unmask for MSI-X, but I can't find
> similar statements for MSI.  If you have, please note them.  It's
> possible MSI is per interrupt.

MSI is mostly implementation defined due to the blury specification.

Also the fact that MSI masking is optional does not make it any
better. Most devices (even new ones) do not have MSI masking.

> Anyway, at least MSI-X if not also MSI could have a !NORESIZE
> implementation, which is why this flag exists in vfio.

MSI-X yes with a pretty large surgery.

MSI, no way. Contrary to MSI-X you cannot just update the $N entry in
the table because there is no table. MSI has a base message and derives
the $Nth vector message from it by modifying the lower bits of the data
word.

So without masking updating the base message for multi-msi is close
to impossible. Look at the dance we have to do in msi_set_affinity().

But even with masking there is still the issue of the 'number of
vectors' field and you can't set that to maximum at init time either
because some devices derive from that how interrupts are routed and you
surely don't want to change that behaviour while devices are active.

Even if that'd be possible, then we'd need to allocate the full IRTE
space, which would be just another corner case and require extra
handling.

MSI is a badly specified trainwreck and we already have enough horrible
code dealing with it. No need to add more of that which is going to
cause more problems than it solves.

The sad thing is that despite the fact that the problems of MSI are
known for more than a decade MSI is still widely used in new silicon
and most of the time even without masking.

> Anyway, at least MSI-X if not also MSI could have a !NORESIZE
> implementation, which is why this flag exists in vfio.

Right, it's there to be ignored for MSI-X in the current implementation
of QEMU and VFIO/PCI.

Thanks,

        tglx
