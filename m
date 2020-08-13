Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66342243578
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 09:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgHMHxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 03:53:08 -0400
Received: from smtpout1.mo804.mail-out.ovh.net ([79.137.123.220]:45379 "EHLO
        smtpout1.mo804.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726072AbgHMHxH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Aug 2020 03:53:07 -0400
X-Greylist: delayed 545 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Aug 2020 03:53:06 EDT
Received: from mxplan5.mail.ovh.net (unknown [10.109.146.44])
        by mo804.mail-out.ovh.net (Postfix) with ESMTPS id B511756B4AAC;
        Thu, 13 Aug 2020 09:43:58 +0200 (CEST)
Received: from kaod.org (37.59.142.96) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 13 Aug
 2020 09:43:57 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-96R001a338f13f-8b53-4c2c-ba13-6cfdcd9e7581,
                    56FC6CFA6F9FB878813463EC2CBCCD0911300B36) smtp.auth=groug@kaod.org
Date:   Thu, 13 Aug 2020 09:43:56 +0200
From:   Greg Kurz <groug@kaod.org>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
CC:     David Gibson <david@gibson.dropbear.id.au>, <pair@us.ibm.com>,
        "Cornelia Huck" <cohuck@redhat.com>, <brijesh.singh@amd.com>,
        <frankja@linux.ibm.com>, <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David Hildenbrand" <david@redhat.com>, <qemu-devel@nongnu.org>,
        <mdroth@linux.vnet.ibm.com>, <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        <qemu-s390x@nongnu.org>, <qemu-ppc@nongnu.org>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        <marcel.apfelbaum@gmail.com>, Thomas Huth <thuth@redhat.com>,
        <pbonzini@redhat.com>, Richard Henderson <rth@twiddle.net>,
        <ehabkost@redhat.com>
Subject: Re: [for-5.2 v4 09/10] host trust limitation: Alter virtio default
 properties for protected guests
Message-ID: <20200813094356.651f323c@bahia.lan>
In-Reply-To: <20200727150514.GQ3040@work-vm>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
        <20200724025744.69644-10-david@gibson.dropbear.id.au>
        <20200727150514.GQ3040@work-vm>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.96]
X-ClientProxiedBy: DAG2EX1.mxp5.local (172.16.2.11) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: f5836199-13f5-4a5c-840c-5c8b35579b5f
X-Ovh-Tracer-Id: 17239216424127404499
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduiedrleefgdduvdehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfhisehtjeertdertddvnecuhfhrohhmpefirhgvghcumfhurhiiuceoghhrohhugheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeefuddtieejjeevheekieeltefgleetkeetheettdeifeffvefhffelffdtfeeljeenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddrleeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehgrhhouhhgsehkrghougdrohhrghdprhgtphhtthhopegvhhgrsghkohhsthesrhgvughhrghtrdgtohhm
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Jul 2020 16:05:14 +0100
"Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:

> * David Gibson (david@gibson.dropbear.id.au) wrote:
> > The default behaviour for virtio devices is not to use the platforms normal
> > DMA paths, but instead to use the fact that it's running in a hypervisor
> > to directly access guest memory.  That doesn't work if the guest's memory
> > is protected from hypervisor access, such as with AMD's SEV or POWER's PEF.
> > 
> > So, if a host trust limitation mechanism is enabled, then apply the
> > iommu_platform=on option so it will go through normal DMA mechanisms.
> > Those will presumably have some way of marking memory as shared with the
> > hypervisor or hardware so that DMA will work.
> > 
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> 
> Good, it's just too easy to forget them at the moment and get hopelessly
> confused.
> 
> 
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> 
> > ---
> >  hw/core/machine.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/hw/core/machine.c b/hw/core/machine.c
> > index b599b0ba65..2a723bf07b 100644
> > --- a/hw/core/machine.c
> > +++ b/hw/core/machine.c
> > @@ -28,6 +28,8 @@
> >  #include "hw/mem/nvdimm.h"
> >  #include "migration/vmstate.h"
> >  #include "exec/host-trust-limitation.h"
> > +#include "hw/virtio/virtio.h"
> > +#include "hw/virtio/virtio-pci.h"
> >  
> >  GlobalProperty hw_compat_5_0[] = {
> >      { "virtio-balloon-device", "page-poison", "false" },
> > @@ -1161,6 +1163,15 @@ void machine_run_board_init(MachineState *machine)
> >           * areas.
> >           */
> >          machine_set_mem_merge(OBJECT(machine), false, &error_abort);
> > +
> > +        /*
> > +         * Virtio devices can't count on directly accessing guest
> > +         * memory, so they need iommu_platform=on to use normal DMA
> > +         * mechanisms.  That requires disabling legacy virtio support
> > +         * for virtio pci devices
> > +         */
> > +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-legacy", "on");

What about non-transitional devices (eg. vhost-user-fs-pci) ? They don't know
about "disable-legacy" since they don't need it.

> > +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_platform", "on");
> >      }
> >  
> >      machine_class->init(machine);
> > -- 
> > 2.26.2
> > 
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
> 

