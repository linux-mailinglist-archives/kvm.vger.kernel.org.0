Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD1BC1595F0
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgBKRGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:06:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36176 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728315AbgBKRGU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:06:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581440779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fEuLmrSsuZ+kbkgjhiTn5RUz/BJlj5bKBYvwQV563Kg=;
        b=Spmsbl8p+gMYD+fi16TrBbxHcl8proPW4IDVzW2lxw6LSJxk2Og9kyJWYAOkq9F5xX1hsF
        7si+1k/EOiZfH9TO6v+k4JH021RvCf5O8WBTfD5Lp4wtmgh5Jnfhz+sQ/JDur/mU6uy7Uz
        K3sO5YrvkTwraJB61ZeM/MwoW/gJc+g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-BFjDWgIQNQCZDaF3bb_OFA-1; Tue, 11 Feb 2020 12:06:16 -0500
X-MC-Unique: BFjDWgIQNQCZDaF3bb_OFA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE5D310054E3;
        Tue, 11 Feb 2020 17:06:13 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F050A60BF1;
        Tue, 11 Feb 2020 17:06:12 +0000 (UTC)
Date:   Tue, 11 Feb 2020 10:06:12 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jerin Jacob <jerinjacobk@gmail.com>
Cc:     kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dpdk-dev <dev@dpdk.org>,
        mtosatti@redhat.com, Thomas Monjalon <thomas@monjalon.net>,
        Luca Boccassi <bluca@debian.org>,
        "Richardson, Bruce" <bruce.richardson@intel.com>,
        cohuck@redhat.com, Vamsi Attunuru <vattunuru@marvell.com>
Subject: Re: [RFC PATCH 0/7] vfio/pci: SR-IOV support
Message-ID: <20200211100612.65cf2433@w520.home>
In-Reply-To: <CALBAE1Oz2u+cmoL8LhEZ-4paXEebKh3DzfWGLQLQx0oaW=tBXw@mail.gmail.com>
References: <158085337582.9445.17682266437583505502.stgit@gimli.home>
        <CALBAE1Oz2u+cmoL8LhEZ-4paXEebKh3DzfWGLQLQx0oaW=tBXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Feb 2020 16:48:47 +0530
Jerin Jacob <jerinjacobk@gmail.com> wrote:

> On Wed, Feb 5, 2020 at 4:35 AM Alex Williamson
> <alex.williamson@redhat.com> wrote:
> >
> > There seems to be an ongoing desire to use userspace, vfio-based
> > drivers for both SR-IOV PF and VF devices.  The fundamental issue
> > with this concept is that the VF is not fully independent of the PF
> > driver.  Minimally the PF driver might be able to deny service to the
> > VF, VF data paths might be dependent on the state of the PF device,
> > or the PF my have some degree of ability to inspect or manipulate the
> > VF data.  It therefore would seem irresponsible to unleash VFs onto
> > the system, managed by a user owned PF.
> >
> > We address this in a few ways in this series.  First, we can use a bus
> > notifier and the driver_override facility to make sure VFs are bound
> > to the vfio-pci driver by default.  This should eliminate the chance
> > that a VF is accidentally bound and used by host drivers.  We don't
> > however remove the ability for a host admin to change this override.
> >
> > The next issue we need to address is how we let userspace drivers
> > opt-in to this participation with the PF driver.  We do not want an
> > admin to be able to unwittingly assign one of these VFs to a tenant
> > that isn't working in collaboration with the PF driver.  We could use
> > IOMMU grouping, but this seems to push too far towards tightly coupled
> > PF and VF drivers.  This series introduces a "VF token", implemented
> > as a UUID, as a shared secret between PF and VF drivers.  The token
> > needs to be set by the PF driver and used as part of the device
> > matching by the VF driver.  Provisions in the code also account for
> > restarting the PF driver with active VF drivers, requiring the PF to
> > use the current token to re-gain access to the PF.  
> 
> Thanks Alex for the series. DPDK realizes this use-case through, an out of
> tree igb_uio module, for non VFIO devices. Supporting this use case, with
> VFIO, will be a great enhancement for DPDK as we are planning to
> get rid of out of tree modules any focus only on userspace aspects.
> 
> From the DPDK perspective, we have following use-cases
> 
> 1) VF representer or OVS/vSwitch  use cases where
> DPDK PF acts as an HW switch to steer traffic to VF
> using the rte_flow library backed by HW CAMs.
> 
> 2) Unlike, other PCI class of devices, Network class of PCIe devices
> would have additional
> capability on the PF devices such as promiscuous mode support etc
> leverage that in DPDK
> PF and VF use cases.
> 
> That would boil down to the use of the following topology.
> a)  PF bound to DPDK/VFIO  and  VF bound to Linux
> b)  PF bound to DPDK/VFIO  and  VF bound to DPDK/VFIO
> 
> Tested the use case (a) and it works this patch. Tested use case(b), it
> works with patch provided both PF and VF under the same application.
> 
> Regarding the use case where  PF bound to DPDK/VFIO and
> VF bound to DPDK/VFIO are _two different_ processes then sharing the UUID
> will be a little tricky thing in terms of usage. But if that is the
> purpose of bringing
> UUID to the equation then it fine.
> 
> Overall this series looks good to me.  We can test the next non-RFC
> series and give
> Tested-by by after testing with DPDK.

Thanks Jerin, that's great feedback.  For case b), it is rather the
intention of the shared VF token proposed here that it imposes some
small barrier in validating the collaboration between the PF and VF
drivers.  In a trusted environment, a common UUID might be exposed in a
shared file and the same token could be used by all PFs and VFs on the
system, or datacenter.  The goal is simply to make sure the
collaboration is explicit, I don't want to be fielding support issues
from users assigning PFs and VFs to unrelated VM instances or
unintentionally creating your scenario a) configuration.

With the positive response from you and Thomas, I'll post a non-RFC
version and barring any blockers maybe we can get this in for the v5.7
kernel.  Thanks,

Alex

