Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33F90106446
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 07:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbfKVGQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 01:16:31 -0500
Received: from 5.mo177.mail-out.ovh.net ([46.105.39.154]:59300 "EHLO
        5.mo177.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728589AbfKVGQb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 01:16:31 -0500
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Nov 2019 01:16:30 EST
Received: from player789.ha.ovh.net (unknown [10.108.42.202])
        by mo177.mail-out.ovh.net (Postfix) with ESMTP id 218BA114F31
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2019 07:09:27 +0100 (CET)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player789.ha.ovh.net (Postfix) with ESMTPSA id C68B9C5C89B7;
        Fri, 22 Nov 2019 06:09:14 +0000 (UTC)
Date:   Fri, 22 Nov 2019 07:09:13 +0100
From:   Greg Kurz <groug@kaod.org>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Alex Williamson <alex.williamson@redhat.com>, clg@kaod.org,
        philmd@redhat.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, Riku Voipio <riku.voipio@iki.fi>,
        =?UTF-8?B?TWFyYy1BbmRyw6k=?= Lureau <marcandre.lureau@redhat.com>
Subject: Re: [PATCH 0/5] vfio/spapr: Handle changes of master irq chip for
 VFIO devices
Message-ID: <20191122070913.5aa6f784@bahia.lan>
In-Reply-To: <20191121005607.274347-1-david@gibson.dropbear.id.au>
References: <20191121005607.274347-1-david@gibson.dropbear.id.au>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 8905305313223219686
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrudehfedgledtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdqfffguegfifdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfesthejredtredtvdenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecukfhppedtrddtrddtrddtpdekvddrvdehfedrvddtkedrvdegkeenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrjeekledrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehgrhhouhhgsehkrghougdrohhrghdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Nov 2019 11:56:02 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> Due to the way feature negotiation works in PAPR (which is a
> paravirtualized platform), we can end up changing the global irq chip
> at runtime, including it's KVM accelerate model.  That causes
> complications for VFIO devices with INTx, which wire themselves up
> directly to the KVM irqchip for performance.
> 
> This series introduces a new notifier to let VFIO devices (and
> anything else that needs to in the future) know about changes to the
> master irqchip.  It modifies VFIO to respond to the notifier,
> reconnecting itself to the new KVM irqchip as necessary.
> 
> In particular this removes a misleading (though not wholly inaccurate)
> warning that occurs when using VFIO devices on a pseries machine type
> guest.
> 
> Open question: should this go into qemu-4.2 or wait until 5.0?  It's
> has medium complexity / intrusiveness, but it *is* a bugfix that I
> can't see a simpler way to fix.  It's effectively a regression from
> qemu-4.0 to qemu-4.1 (because that introduced XIVE support by
> default), although not from 4.1 to 4.2.
> 
> Changes since RFC:
>  * Fixed some incorrect error paths pointed by aw in 3/5
>  * 5/5 had some problems previously, but they have been obsoleted by
>    other changes merged in the meantime
> 
> David Gibson (5):
>   kvm: Introduce KVM irqchip change notifier
>   vfio/pci: Split vfio_intx_update()
>   vfio/pci: Respond to KVM irqchip change notifier
>   spapr: Handle irq backend changes with VFIO PCI devices
>   spapr: Work around spurious warnings from vfio INTx initialization
> 
>  accel/kvm/kvm-all.c    | 18 ++++++++++++
>  accel/stubs/kvm-stub.c | 12 ++++++++
>  hw/ppc/spapr_irq.c     | 17 +++++++++++-
>  hw/vfio/pci.c          | 62 +++++++++++++++++++++++++++---------------
>  hw/vfio/pci.h          |  1 +
>  include/sysemu/kvm.h   |  5 ++++
>  6 files changed, 92 insertions(+), 23 deletions(-)
> 

With the issue spotted in patch 3/5 fixed, the series looks good:

Reviewed-by: Greg Kurz <groug@kaod.org>

Then I've tried passthrough of a BCM5719 gigabit adapter to a guest. It works
as expected with MSIs but if I force LSI, either through /sys or with the
pci=nomsi kernel command line, I get no interrupts for the device in the guest.
Note that the same device works ok with LSI in the host.
