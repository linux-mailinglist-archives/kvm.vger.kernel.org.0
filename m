Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3759106542
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 07:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbfKVGXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 01:23:15 -0500
Received: from ozlabs.org ([203.11.71.1]:45807 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728274AbfKVFvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 00:51:49 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 47K5Ck45Xfz9sRt; Fri, 22 Nov 2019 16:51:46 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1574401906;
        bh=apma14zKbbpSFvOBnkuzw6uhuoPtWouDzz/N3NAm0d8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lqq5TvTH+vcQfatPBwEmtGAzNBK9YhEcBmWW/JaGh02AlscWYCovKh/6UeJ1JuipC
         yhs2GZ/oM7iVDNX7JInGdVgOylY6akY/rWHIyjy1QG3guo5ZLYx3Xktwzagro2Pe5t
         r+CmVg5+IcXftVb/QuDI3ZDA0sD1YFPaPoT67CdQ=
Date:   Fri, 22 Nov 2019 16:50:41 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Greg Kurz <groug@kaod.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>, clg@kaod.org,
        philmd@redhat.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, Riku Voipio <riku.voipio@iki.fi>,
        =?iso-8859-1?Q?Marc-Andr=E9?= Lureau 
        <marcandre.lureau@redhat.com>, Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: Re: [PATCH 3/5] vfio/pci: Respond to KVM irqchip change notifier
Message-ID: <20191122055041.GF5582@umbus.fritz.box>
References: <20191121005607.274347-1-david@gibson.dropbear.id.au>
 <20191121005607.274347-4-david@gibson.dropbear.id.au>
 <20191122061257.7633bcdd@bahia.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="P5jslYRVNanHST2M"
Content-Disposition: inline
In-Reply-To: <20191122061257.7633bcdd@bahia.lan>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--P5jslYRVNanHST2M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 22, 2019 at 06:12:57AM +0100, Greg Kurz wrote:
> On Thu, 21 Nov 2019 11:56:05 +1100
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
> > VFIO PCI devices already respond to the pci intx routing notifier, in o=
rder
> > to update kernel irqchip mappings when routing is updated.  However this
> > won't handle the case where the irqchip itself is replaced by a differe=
nt
> > model while retaining the same routing.  This case can happen on
> > the pseries machine type due to PAPR feature negotiation.
> >=20
> > To handle that case, add a handler for the irqchip change notifier, whi=
ch
> > does much the same thing as the routing notifier, but is unconditional,
> > rather than being a no-op when the routing hasn't changed.
> >=20
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Alexey Kardashevskiy <aik@ozlabs.ru>
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > ---
> >  hw/vfio/pci.c | 23 ++++++++++++++++++-----
> >  hw/vfio/pci.h |  1 +
> >  2 files changed, 19 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> > index 521289aa7d..95478c2c55 100644
> > --- a/hw/vfio/pci.c
> > +++ b/hw/vfio/pci.c
> > @@ -256,6 +256,14 @@ static void vfio_intx_routing_notifier(PCIDevice *=
pdev)
> >      }
> >  }
> > =20
> > +static void vfio_irqchip_change(Notifier *notify, void *data)
> > +{
> > +    VFIOPCIDevice *vdev =3D container_of(notify, VFIOPCIDevice,
> > +                                       irqchip_change_notifier);
> > +
> > +    vfio_intx_update(vdev, &vdev->intx.route);
> > +}
> > +
> >  static int vfio_intx_enable(VFIOPCIDevice *vdev, Error **errp)
> >  {
> >      uint8_t pin =3D vfio_pci_read_config(&vdev->pdev, PCI_INTERRUPT_PI=
N, 1);
> > @@ -2973,16 +2981,18 @@ static void vfio_realize(PCIDevice *pdev, Error=
 **errp)
> >                                                    vfio_intx_mmap_enabl=
e, vdev);
> >          pci_device_set_intx_routing_notifier(&vdev->pdev,
> >                                               vfio_intx_routing_notifie=
r);
> > +        vdev->irqchip_change_notifier.notify =3D vfio_irqchip_change;
> > +        kvm_irqchip_add_change_notifier(&vdev->irqchip_change_notifier=
);
> >          ret =3D vfio_intx_enable(vdev, errp);
> >          if (ret) {
> > -            goto out_teardown;
> > +            goto out_deregister;
> >          }
> >      }
> > =20
> >      if (vdev->display !=3D ON_OFF_AUTO_OFF) {
> >          ret =3D vfio_display_probe(vdev, errp);
> >          if (ret) {
> > -            goto out_teardown;
> > +            goto out_deregister;
> >          }
> >      }
> >      if (vdev->enable_ramfb && vdev->dpy =3D=3D NULL) {
> > @@ -2992,11 +3002,11 @@ static void vfio_realize(PCIDevice *pdev, Error=
 **errp)
> >      if (vdev->display_xres || vdev->display_yres) {
> >          if (vdev->dpy =3D=3D NULL) {
> >              error_setg(errp, "xres and yres properties require display=
=3Don");
> > -            goto out_teardown;
> > +            goto out_deregister;
> >          }
> >          if (vdev->dpy->edid_regs =3D=3D NULL) {
> >              error_setg(errp, "xres and yres properties need edid suppo=
rt");
> > -            goto out_teardown;
> > +            goto out_deregister;
> >          }
> >      }
> > =20
>=20
> After this change, we end up with:
>=20
>     if (vfio_pci_read_config(&vdev->pdev, PCI_INTERRUPT_PIN, 1)) {
>         vdev->intx.mmap_timer =3D timer_new_ms(QEMU_CLOCK_VIRTUAL,
>                                                   vfio_intx_mmap_enable, =
vdev);
>         pci_device_set_intx_routing_notifier(&vdev->pdev,
>                                              vfio_intx_routing_notifier);
>         vdev->irqchip_change_notifier.notify =3D vfio_irqchip_change;
>         kvm_irqchip_add_change_notifier(&vdev->irqchip_change_notifier);
>         ret =3D vfio_intx_enable(vdev, errp);
>         if (ret) {
>             goto out_deregister;
>         }
>     }
>=20
>     if (vdev->display !=3D ON_OFF_AUTO_OFF) {
>         ret =3D vfio_display_probe(vdev, errp);
>         if (ret) {
>             goto out_deregister;
>         }
>     }
>     if (vdev->enable_ramfb && vdev->dpy =3D=3D NULL) {
>         error_setg(errp, "ramfb=3Don requires display=3Don");
>         goto out_teardown;
>              ^^^^^^^^^^^^
>=20
> This should be out_deregister.

Oops, fixed in my tree.

> The enable_ramfb property belongs to the nohotplug variant. It
> means QEMU is going to terminate and we probably don't really
> care to leak notifiers, but this still looks weird and fragile,
> if enable_ramfb ever becomes usable by hotpluggable devices
> one day.
>=20
>     }
>     if (vdev->display_xres || vdev->display_yres) {
>         if (vdev->dpy =3D=3D NULL) {
>             error_setg(errp, "xres and yres properties require display=3D=
on");
>             goto out_deregister;
>         }
>         if (vdev->dpy->edid_regs =3D=3D NULL) {
>             error_setg(errp, "xres and yres properties need edid support"=
);
>             goto out_deregister;
>         }
>     }
>=20
>=20
> > @@ -3020,8 +3030,10 @@ static void vfio_realize(PCIDevice *pdev, Error =
**errp)
> > =20
> >      return;
> > =20
> > -out_teardown:
> > +out_deregister:
> >      pci_device_set_intx_routing_notifier(&vdev->pdev, NULL);
> > +    kvm_irqchip_remove_change_notifier(&vdev->irqchip_change_notifier);
> > +out_teardown:
> >      vfio_teardown_msi(vdev);
> >      vfio_bars_exit(vdev);
> >  error:
> > @@ -3064,6 +3076,7 @@ static void vfio_exitfn(PCIDevice *pdev)
> >      vfio_unregister_req_notifier(vdev);
> >      vfio_unregister_err_notifier(vdev);
> >      pci_device_set_intx_routing_notifier(&vdev->pdev, NULL);
> > +    kvm_irqchip_remove_change_notifier(&vdev->irqchip_change_notifier);
> >      vfio_disable_interrupts(vdev);
> >      if (vdev->intx.mmap_timer) {
> >          timer_free(vdev->intx.mmap_timer);
> > diff --git a/hw/vfio/pci.h b/hw/vfio/pci.h
> > index b329d50338..35626cd63e 100644
> > --- a/hw/vfio/pci.h
> > +++ b/hw/vfio/pci.h
> > @@ -169,6 +169,7 @@ typedef struct VFIOPCIDevice {
> >      bool enable_ramfb;
> >      VFIODisplay *dpy;
> >      Error *migration_blocker;
> > +    Notifier irqchip_change_notifier;
> >  } VFIOPCIDevice;
> > =20
> >  uint32_t vfio_pci_read_config(PCIDevice *pdev, uint32_t addr, int len);
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--P5jslYRVNanHST2M
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl3Xdy0ACgkQbDjKyiDZ
s5IRSQ/7B6ScYm5J87bjzK8E2iuuNROYDSmgAoECca06mnQ3x7j1JPU+8jeHa19e
sl03KucF0NBy2F+CJtgaGhbGKbAUQK6TCV3mMWpTQmDEIlTloH9zCol0WhOKp2s3
9cJiPCOx3bx1WqQODjBAUyuDjS/gDuudQLJyN0hnS1yhzYIXIe3eeRGzUjXzsYu5
/HC8rwyhwWU3KzUAqPHMPUqQj3QXgw9e1b6zvuTu1R2cgwHNpZZtLK9HWWN85u2i
1PCwQMSIBAl1rdvAzm1HNn93z/BXkRJxcMJkofSnpcsLajvd2NggnGS9679iu+Gr
DJoLkugDCrkCOu/M7uJnf65nWrEN83PAl1WKRB9/VXeTfphnQf3o3mNX3JKlM7CC
uvUpWVfcfNKYp1mjwlU2zOA7GEhOE6RRGlulhiO/ni7rHznXKAwB7FSUsh2sXgk5
IVhhwC1nYSvtzBp2Ob7bMmA69oWwbulFjqCMqceoBZDlyRm3362nbipmklm4b4mg
retQMDc1db3tT8THunktZP+bpB/DfxyWWdvJBnStLxwTQslZY1uwJ4B2NWoHN6cm
FLW9o6yRbvW8yCacAom3a7RKIOHMoE81VkiCDHWnKeA9gOetWE9p4ChgedXMsUfo
0hNJMF2ameELGu58mBIUid2M3CPqRnhZreIWkFs1PXI99LXrBGg=
=AaAb
-----END PGP SIGNATURE-----

--P5jslYRVNanHST2M--
