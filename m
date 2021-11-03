Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C69443D78
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhKCHAt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 3 Nov 2021 03:00:49 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:27107 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhKCHAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 03:00:48 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HkcxK313Kz1DJ6x;
        Wed,  3 Nov 2021 14:56:05 +0800 (CST)
Received: from dggpemm100008.china.huawei.com (7.185.36.125) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 3 Nov 2021 14:58:07 +0800
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpemm100008.china.huawei.com (7.185.36.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 3 Nov 2021 14:58:07 +0800
Received: from dggpeml100016.china.huawei.com ([7.185.36.216]) by
 dggpeml100016.china.huawei.com ([7.185.36.216]) with mapi id 15.01.2308.015;
 Wed, 3 Nov 2021 14:58:07 +0800
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: RE: [PATCH v4 6/6] vfio: defer to commit kvm irq routing when enable
 msi/msix
Thread-Topic: [PATCH v4 6/6] vfio: defer to commit kvm irq routing when enable
 msi/msix
Thread-Index: AQHXwJVVD8XLlFVa70m12/QixeY9hKvdc34AgBQIqkA=
Date:   Wed, 3 Nov 2021 06:58:07 +0000
Message-ID: <d5235f149bf240d8bf2703d91825c7dc@huawei.com>
References: <20211014004852.1293-1-longpeng2@huawei.com>
        <20211014004852.1293-7-longpeng2@huawei.com>
 <20211021145114.3fc4436e.alex.williamson@redhat.com>
In-Reply-To: <20211021145114.3fc4436e.alex.williamson@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.148.223]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Friday, October 22, 2021 4:51 AM
> To: Longpeng (Mike, Cloud Infrastructure Service Product Dept.)
> <longpeng2@huawei.com>
> Cc: pbonzini@redhat.com; qemu-devel@nongnu.org; kvm@vger.kernel.org; Gonglei
> (Arei) <arei.gonglei@huawei.com>
> Subject: Re: [PATCH v4 6/6] vfio: defer to commit kvm irq routing when enable
> msi/msix
> 
> On Thu, 14 Oct 2021 08:48:52 +0800
> "Longpeng(Mike)" <longpeng2@huawei.com> wrote:
> 
> > In migration resume phase, all unmasked msix vectors need to be
> > setup when loading the VF state. However, the setup operation would
> > take longer if the VM has more VFs and each VF has more unmasked
> > vectors.
> >
> > The hot spot is kvm_irqchip_commit_routes, it'll scan and update
> > all irqfds that are already assigned each invocation, so more
> > vectors means need more time to process them.
> >
> > vfio_pci_load_config
> >   vfio_msix_enable
> >     msix_set_vector_notifiers
> >       for (vector = 0; vector < dev->msix_entries_nr; vector++) {
> >         vfio_msix_vector_do_use
> >           vfio_add_kvm_msi_virq
> >             kvm_irqchip_commit_routes <-- expensive
> >       }
> >
> > We can reduce the cost by only committing once outside the loop.
> > The routes are cached in kvm_state, we commit them first and then
> > bind irqfd for each vector.
> >
> > The test VM has 128 vcpus and 8 VF (each one has 65 vectors),
> > we measure the cost of the vfio_msix_enable for each VF, and
> > we can see 90+% costs can be reduce.
> >
> > VF      Count of irqfds[*]  Original        With this patch
> >
> > 1st           65            8               2
> > 2nd           130           15              2
> > 3rd           195           22              2
> > 4th           260           24              3
> > 5th           325           36              2
> > 6th           390           44              3
> > 7th           455           51              3
> > 8th           520           58              4
> > Total                       258ms           21ms
> >
> > [*] Count of irqfds
> > How many irqfds that already assigned and need to process in this
> > round.
> >
> > The optimization can be applied to msi type too.
> >
> > Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
> > ---
> >  hw/vfio/pci.c | 129
> ++++++++++++++++++++++++++++++++++++++++++++++------------
> >  hw/vfio/pci.h |   1 +
> >  2 files changed, 105 insertions(+), 25 deletions(-)
> >
> > diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> > index 0bd832b..dca2d0c 100644
> > --- a/hw/vfio/pci.c
> > +++ b/hw/vfio/pci.c
> > @@ -413,8 +413,6 @@ static int vfio_enable_vectors(VFIOPCIDevice *vdev, bool
> msix)
> >  static void vfio_add_kvm_msi_virq(VFIOPCIDevice *vdev, VFIOMSIVector
> *vector,
> >                                    int vector_n, bool msix)
> >  {
> > -    int virq;
> > -
> >      if ((msix && vdev->no_kvm_msix) || (!msix && vdev->no_kvm_msi)) {
> >          return;
> >      }
> > @@ -423,20 +421,31 @@ static void vfio_add_kvm_msi_virq(VFIOPCIDevice *vdev,
> VFIOMSIVector *vector,
> >          return;
> >      }
> >
> > -    virq = kvm_irqchip_add_msi_route(kvm_state, vector_n, &vdev->pdev);
> > -    if (virq < 0) {
> > +    vector->virq = kvm_irqchip_add_deferred_msi_route(kvm_state, vector_n,
> > +                                                      &vdev->pdev);
> > +    if (vector->virq < 0) {
> >          event_notifier_cleanup(&vector->kvm_interrupt);
> > +        vector->virq = -1;
> 
> Nit, it seems like all negative values are equivalent here, I don't
> think we need to explicitly set virq to -1 given that it's already < 0.
> 

OK.

> > +        return;
> > +    }
> > +
> > +    if (vdev->defer_kvm_irq_routing) {
> > +        /*
> > +         * The vector->virq will be reset to -1 if we fail to add the
> > +         * corresponding irqfd in vfio_commit_kvm_msi_virq_batch().
> > +         */
> >          return;
> >      }
> >
> > +    kvm_irqchip_commit_routes(kvm_state);
> > +
> >      if (kvm_irqchip_add_irqfd_notifier_gsi(kvm_state,
> &vector->kvm_interrupt,
> > -                                       NULL, virq) < 0) {
> > -        kvm_irqchip_release_virq(kvm_state, virq);
> > +                                           NULL, vector->virq) < 0) {
> > +        kvm_irqchip_release_virq(kvm_state, vector->virq);
> >          event_notifier_cleanup(&vector->kvm_interrupt);
> > +        vector->virq = -1;
> >          return;
> >      }
> > -
> > -    vector->virq = virq;
> >  }
> >
> >  static void vfio_remove_kvm_msi_virq(VFIOMSIVector *vector)
> > @@ -501,11 +510,13 @@ static int vfio_msix_vector_do_use(PCIDevice *pdev,
> unsigned int nr,
> >       * increase them as needed.
> >       */
> >      if (vdev->nr_vectors < nr + 1) {
> > -        vfio_disable_irqindex(&vdev->vbasedev, VFIO_PCI_MSIX_IRQ_INDEX);
> >          vdev->nr_vectors = nr + 1;
> > -        ret = vfio_enable_vectors(vdev, true);
> > -        if (ret) {
> > -            error_report("vfio: failed to enable vectors, %d", ret);
> > +        if (!vdev->defer_kvm_irq_routing) {
> > +            vfio_disable_irqindex(&vdev->vbasedev,
> VFIO_PCI_MSIX_IRQ_INDEX);
> > +            ret = vfio_enable_vectors(vdev, true);
> > +            if (ret) {
> > +                error_report("vfio: failed to enable vectors, %d", ret);
> > +            }
> >          }
> >      } else {
> >          Error *err = NULL;
> > @@ -567,6 +578,46 @@ static void vfio_msix_vector_release(PCIDevice *pdev,
> unsigned int nr)
> >      }
> >  }
> >
> > +static void vfio_prepare_kvm_msi_virq_batch(VFIOPCIDevice *vdev)
> > +{
> > +    assert(!vdev->defer_kvm_irq_routing);
> > +    vdev->defer_kvm_irq_routing = true;
> > +}
> > +
> > +static void vfio_commit_kvm_msi_virq_batch(VFIOPCIDevice *vdev)
> > +{
> > +    VFIOMSIVector *vector;
> > +    int i;
> > +
> > +    if (!vdev->defer_kvm_irq_routing) {
> > +        return;
> > +    }
> > +
> > +    vdev->defer_kvm_irq_routing = false;
> > +
> > +    if (!vdev->nr_vectors) {
> > +        return;
> > +    }
> > +
> > +    kvm_irqchip_commit_routes(kvm_state);
> > +
> > +    for (i = 0; i < vdev->nr_vectors; i++) {
> > +        vector = &vdev->msi_vectors[i];
> > +
> > +        if (!vector->use || vector->virq < 0) {
> > +            continue;
> > +        }
> > +
> > +        if (kvm_irqchip_add_irqfd_notifier_gsi(kvm_state,
> > +                                               &vector->kvm_interrupt,
> > +                                               NULL, vector->virq) < 0) {
> > +            kvm_irqchip_release_virq(kvm_state, vector->virq);
> > +            event_notifier_cleanup(&vector->kvm_interrupt);
> > +            vector->virq = -1;
> > +        }
> 
> I started trying to get rid of this code that largely duplicates the
> error case of vfio_add_kvm_msi_virq() and questioned why we setup the
> notifier separate from connecting it to the irqfd.  If we setup the
> notifier and irqfd in the same function we can clean things up a bit
> more and confine the deferred state tests in the vector-use code.  I
> think we can also assert if we have an unmatched batch commit call and
> we probably don't need to test both that a vector is in use and has a
> virq, one should not be true without the other.
> 
> Does this look like an improvement to you and would you like to roll it
> into this patch?  Thanks,
> 

Sure, it looks neater! I've tested it for about two days in local and it
works well. I'll send them (v5) out later. Thanks.

> Alex
> 
>  pci.c |   58 ++++++++++++++++++++++------------------------------------
>  1 file changed, 22 insertions(+), 36 deletions(-)
> 
> commit 6fb9336e3fe9e3775b0a0e7aadaff781fb52c0e7
> Author: Alex Williamson <alex.williamson@redhat.com>
> Date:   Thu Oct 21 13:35:12 2021 -0600
> 
>     cleanup
> 
> diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> index 1792c30049da..5b3a86dd5292 100644
> --- a/hw/vfio/pci.c
> +++ b/hw/vfio/pci.c
> @@ -417,35 +417,33 @@ static void vfio_add_kvm_msi_virq(VFIOPCIDevice *vdev,
> VFIOMSIVector *vector,
>          return;
>      }
> 
> -    if (event_notifier_init(&vector->kvm_interrupt, 0)) {
> -        return;
> -    }
> -
>      vector->virq = kvm_irqchip_add_deferred_msi_route(kvm_state, vector_n,
>                                                        &vdev->pdev);
> +}
> +
> +static void vfio_connect_kvm_msi_virq(VFIOMSIVector *vector)
> +{
>      if (vector->virq < 0) {
> -        event_notifier_cleanup(&vector->kvm_interrupt);
> -        vector->virq = -1;
>          return;
>      }
> 
> -    if (vdev->defer_kvm_irq_routing) {
> -        /*
> -         * The vector->virq will be reset to -1 if we fail to add the
> -         * corresponding irqfd in vfio_commit_kvm_msi_virq_batch().
> -         */
> -        return;
> +    if (event_notifier_init(&vector->kvm_interrupt, 0)) {
> +        goto fail_notifier;
>      }
> 
> -    kvm_irqchip_commit_routes(kvm_state);
> -
>      if (kvm_irqchip_add_irqfd_notifier_gsi(kvm_state,
> &vector->kvm_interrupt,
>                                             NULL, vector->virq) < 0) {
> -        kvm_irqchip_release_virq(kvm_state, vector->virq);
> -        event_notifier_cleanup(&vector->kvm_interrupt);
> -        vector->virq = -1;
> -        return;
> +        goto fail_kvm;
>      }
> +
> +    return;
> +
> +fail_kvm:
> +    event_notifier_cleanup(&vector->kvm_interrupt);
> +fail_notifier:
> +    kvm_irqchip_release_virq(kvm_state, vector->virq);
> +    vector->virq = -1;
> +    return;
>  }
> 
>  static void vfio_remove_kvm_msi_virq(VFIOMSIVector *vector)
> @@ -501,6 +499,10 @@ static int vfio_msix_vector_do_use(PCIDevice *pdev,
> unsigned int nr,
>      } else {
>          if (msg) {
>              vfio_add_kvm_msi_virq(vdev, vector, nr, true);
> +            if (!vdev->defer_kvm_irq_routing) {
> +                kvm_irqchip_commit_routes(kvm_state);
> +                vfio_connect_kvm_msi_virq(vector);
> +            }
>          }
>      }
> 
> @@ -586,13 +588,9 @@ static void vfio_prepare_kvm_msi_virq_batch(VFIOPCIDevice
> *vdev)
> 
>  static void vfio_commit_kvm_msi_virq_batch(VFIOPCIDevice *vdev)
>  {
> -    VFIOMSIVector *vector;
>      int i;
> 
> -    if (!vdev->defer_kvm_irq_routing) {
> -        return;
> -    }
> -
> +    assert(vdev->defer_kvm_irq_routing);
>      vdev->defer_kvm_irq_routing = false;
> 
>      if (!vdev->nr_vectors) {
> @@ -602,19 +600,7 @@ static void vfio_commit_kvm_msi_virq_batch(VFIOPCIDevice
> *vdev)
>      kvm_irqchip_commit_routes(kvm_state);
> 
>      for (i = 0; i < vdev->nr_vectors; i++) {
> -        vector = &vdev->msi_vectors[i];
> -
> -        if (!vector->use || vector->virq < 0) {
> -            continue;
> -        }
> -
> -        if (kvm_irqchip_add_irqfd_notifier_gsi(kvm_state,
> -                                               &vector->kvm_interrupt,
> -                                               NULL, vector->virq) < 0) {
> -            kvm_irqchip_release_virq(kvm_state, vector->virq);
> -            event_notifier_cleanup(&vector->kvm_interrupt);
> -            vector->virq = -1;
> -        }
> +        vfio_connect_kvm_msi_virq(&vdev->msi_vectors[i]);
>      }
>  }
> 

