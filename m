Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1600F288158
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 06:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731257AbgJIE3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 00:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbgJIE3p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 00:29:45 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7793C0613D2;
        Thu,  8 Oct 2020 21:29:44 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id dt13so11160628ejb.12;
        Thu, 08 Oct 2020 21:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1F7aYVEZF5q16a3jyVNYHgdOJZG/vnxh0WHbePxIvus=;
        b=CyF3+7gxhvX386B4lGhsR7yZoMxu4PJsNI8P6TyGutJPSINEYhHe2Jlc7XurJkw+2g
         banpt+5yJnBrCGgl9ugQRzPpnpXj5dSKgjupWsZ0/1FjFMKG8OnvKgCFF8OZPRL5+Zsf
         L9kDYNNa+AzPusFeGyUEFRSneTBNMZdEaBzimSzZFBvhtkh2sizj2znaCj8kAiQvI9Q5
         20QK5bLgXz+Bk12Ua7+tdflTWSZYEXSdvJqEUJQdFM8+BoFDOLotcT9/Qjj9W8qFfeUI
         HXoscamp9bndFf+Mq+4ErU1mmLXqiJjwpa2J06Oj/PCXEF657RDyCsMxFqw7hdXkNJtQ
         fkIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1F7aYVEZF5q16a3jyVNYHgdOJZG/vnxh0WHbePxIvus=;
        b=gJk756TsELcdlLC90CIPQAjKlAFrZA3yB0wOVh9rAzzBurll/XlbVY8npUTAZZcrcX
         YiViU54fPTwBz27xAWPGqO7+vNPP4Gqg2OlSoFIukUjToQZ5B4RmPX0m8am9lZDmlSRM
         MeCYYUauqhiXcwMHQ1J8gdg97iwHNAOi7IphPixUDSBBBI++qvjkTpeTxQ0mEMxZli7w
         3hJ9AwxYAUEKS+rJdGaYlKvqRJi6MabCK/9VausAqwoWsbKJM3r1WZ7YxKW4LU0Blv9W
         u5jWyN0M7w+z7r1NEcO1FGDeLQXIDWPtD8HVWUQ/bc2ND6pnZijSFidx+uoEBRRmapYc
         wkgQ==
X-Gm-Message-State: AOAM533UrLLSkhOSON2YBi2Doj3tLyLoXRKB7uJHS2YTV/8cOPHlE3/d
        I5W0VQpoxlTObUWv43esMLAvwypEvIl5n06rq84=
X-Google-Smtp-Source: ABdhPJzX1Xi0zdvI/PNLAnLQFsEV1IrrVegdTfM9Uvrslb2fDFuejPhalmRXMgvr5koWMDbGFknJMv0lh9Jfbxr9wxU=
X-Received: by 2002:a17:906:b2d1:: with SMTP id cf17mr12149778ejb.321.1602217783399;
 Thu, 08 Oct 2020 21:29:43 -0700 (PDT)
MIME-Version: 1.0
References: <1601470479-26848-1-git-send-email-guomin_chen@sina.com> <20200930080919.1a9c66f8@x1.home>
In-Reply-To: <20200930080919.1a9c66f8@x1.home>
From:   gchen chen <gchen.guomin@gmail.com>
Date:   Fri, 9 Oct 2020 12:30:04 +0800
Message-ID: <CAEEwsfRZt=r54SWOqbKvF60zPKu2tiTeQtFcFW14Hp92kT6M9Q@mail.gmail.com>
Subject: Re: [PATCH] irqbypass: fix error handle when irq_bypass_register_producer()
 return fails
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     guomin_chen@sina.com, Cornelia Huck <cohuck@redhat.com>,
        Jiang Yi <giangyi@amazon.com>, Marc Zyngier <maz@kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alex Williamson <alex.williamson@redhat.com> =E4=BA=8E2020=E5=B9=B49=E6=9C=
=8830=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=8810:09=E5=86=99=E9=81=93=
=EF=BC=9A
>
>
> Please version your postings so we know which one to consider as the
> current proposal.
>
> On Wed, 30 Sep 2020 20:54:39 +0800
> guomin_chen@sina.com wrote:
>
> > From: guomin chen <guomin_chen@sina.com>
> >
> > When the producer object registration fails,In the future, due to
> > incorrect matching when unregistering, list_del(&producer->node)
> > may still be called, then trigger a BUG:
> >
> >     vfio-pci 0000:db:00.0: irq bypass producer (token 0000000060c8cda5)=
 registration fails: -16
> >     vfio-pci 0000:db:00.0: irq bypass producer (token 0000000060c8cda5)=
 registration fails: -16
> >     vfio-pci 0000:db:00.0: irq bypass producer (token 0000000060c8cda5)=
 registration fails: -16
> >     ...
> >     list_del corruption, ffff8f7fb8ba0828->next is LIST_POISON1 (dead00=
0000000100)
> >     ------------[ cut here ]------------
> >     kernel BUG at lib/list_debug.c:47!
> >     invalid opcode: 0000 [#1] SMP NOPTI
> >     CPU: 29 PID: 3914 Comm: qemu-kvm Kdump: loaded Tainted: G      E
> >     -------- - -4.18.0-193.6.3.el8.x86_64 #1
> >     Hardware name: Lenovo ThinkSystem SR650 -[7X06CTO1WW]-/-[7X06CTO1WW=
]-,
> >     BIOS -[IVE636Z-2.13]- 07/18/2019
> >     RIP: 0010:__list_del_entry_valid.cold.1+0x12/0x4c
> >     Code: ce ff 0f 0b 48 89 c1 4c 89 c6 48 c7 c7 40 85 4d 88 e8 8c bc
> >           ce ff 0f 0b 48 89 fe 48 89 c2 48 c7 c7 d0 85 4d 88 e8 78 bc
> >           ce ff <0f> 0b 48 c7 c7 80 86 4d 88 e8 6a bc ce ff 0f 0b 48
> >           89 f2 48 89 fe
> >     RSP: 0018:ffffaa9d60197d20 EFLAGS: 00010246
> >     RAX: 000000000000004e RBX: ffff8f7fb8ba0828 RCX: 0000000000000000
> >     RDX: 0000000000000000 RSI: ffff8f7fbf4d6a08 RDI: ffff8f7fbf4d6a08
> >     RBP: 0000000000000000 R08: 000000000000084b R09: 000000000000005d
> >     R10: 0000000000000000 R11: ffffaa9d60197bd0 R12: ffff8f4fbe863000
> >     R13: 00000000000000c2 R14: 0000000000000000 R15: 0000000000000000
> >     FS:  00007f7cb97fa700(0000) GS:ffff8f7fbf4c0000(0000)
> >     knlGS:0000000000000000
> >     CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >     CR2: 00007fcf31da4000 CR3: 0000005f6d404001 CR4: 00000000007626e0
> >     DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >     DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >     PKRU: 55555554
> >     Call Trace:
> >         irq_bypass_unregister_producer+0x9b/0xf0 [irqbypass]
> >         vfio_msi_set_vector_signal+0x8c/0x290 [vfio_pci]
> >         ? load_fixmap_gdt+0x22/0x30
> >         vfio_msi_set_block+0x6e/0xd0 [vfio_pci]
> >         vfio_pci_ioctl+0x218/0xbe0 [vfio_pci]
> >         ? kvm_vcpu_ioctl+0xf2/0x5f0 [kvm]
> >         do_vfs_ioctl+0xa4/0x630
> >         ? syscall_trace_enter+0x1d3/0x2c0
> >         ksys_ioctl+0x60/0x90
> >         __x64_sys_ioctl+0x16/0x20
> >         do_syscall_64+0x5b/0x1a0
> >         entry_SYSCALL_64_after_hwframe+0x65/0xca
> >
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Cornelia Huck <cohuck@redhat.com>
> > Cc: Jiang Yi <giangyi@amazon.com>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > Cc: Jason Wang <jasowang@redhat.com>
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: guomin chen <guomin_chen@sina.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_intrs.c | 13 +++++++++++--
> >  drivers/vhost/vdpa.c              |  7 +++++++
> >  2 files changed, 18 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_=
pci_intrs.c
> > index 1d9fb25..c371943 100644
> > --- a/drivers/vfio/pci/vfio_pci_intrs.c
> > +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> > @@ -352,12 +352,21 @@ static int vfio_msi_set_vector_signal(struct vfio=
_pci_device *vdev,
> >       vdev->ctx[vector].producer.token =3D trigger;
> >       vdev->ctx[vector].producer.irq =3D irq;
> >       ret =3D irq_bypass_register_producer(&vdev->ctx[vector].producer)=
;
> > -     if (unlikely(ret))
> > +     if (unlikely(ret)) {
> >               dev_info(&pdev->dev,
> >               "irq bypass producer (token %p) registration fails: %d\n"=
,
> >               vdev->ctx[vector].producer.token, ret);
> >
> > -     vdev->ctx[vector].trigger =3D trigger;
> > +             kfree(vdev->ctx[vector].name);
> > +             eventfd_ctx_put(trigger);
> > +
> > +             cmd =3D vfio_pci_memory_lock_and_enable(vdev);
> > +             free_irq(irq, trigger);
> > +             vfio_pci_memory_unlock_and_restore(vdev, cmd);
> > +
> > +             vdev->ctx[vector].trigger =3D NULL;
> > +     } else
> > +             vdev->ctx[vector].trigger =3D trigger;
> >
> >       return 0;
> >  }
>
> Once again, the irq bypass registration cannot cause the vector setup
> to fail, either by returning an error code or failing to configure the
> vector while returning success.  It's my assertion that we simply need
> to set the producer.token to NULL on failure such that unregistering
> the producer will not generate a match, as you've done below.  The
> vector still works even if this registration fails.
>
Yes,  the irq bypass registration cannot cause the vector setup to fail.
But if I simply set producer.token to NULL when fails, instead of
cleaning up vector, it will trigger the following BUG:

vfio_ecap_init: 0000:db:00.0 hiding ecap 0x1e@0x310
vfio-pci 0000:db:00.0: irq bypass producer (token 000000004409229f)
registration fails: -16
------------[ cut here ]------------
kernel BUG at drivers/pci/msi.c:352!
invalid opcode: 0000 [#1] SMP NOPTI
CPU: 55 PID: 9389 Comm: qemu-kvm Kdump: loaded Tainted: G
E    --------- -  - 4.18.0-193.irqb.r1.el8.x86_64 #1
Hardware name: Lenovo ThinkSystem SR650 -[7X06CTO1WW]-/-[7X06CTO1WW]-,
  BIOS -[IVE636Z-2.13]- 07/18/2019
RIP: 0010:free_msi_irqs+0x180/0x1b0
Code: 14 85 c0 0f 84 d5 fe ff ff 31 ed eb 0f 83 c5 01 39 6b 14 0f 86
      c5 fe ff ff 8b 7b 10 01 ef e8 d7 4a c9 ff 48 83 78 70 00 74 e3
  <0f> 0b 49 8d b5 b0 00 00 00 e8 e2 e3 c9 ff e9 c7 fe ff ff 48
  8b 7b
RSP: 0018:ffffaeca4f4bfcd8 EFLAGS: 00010286
RAX: ffff8bec77441600 RBX: ffff8bbcdb637e40 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 00000000000001ab RDI: ffffffff8ea5b2a0
RBP: 0000000000000000 R08: ffff8bec7e746828 R09: ffff8bec7e7466a8
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8bbcde921308
R13: ffff8bbcde921000 R14: 000000000000000b R15: 0000000000000021
FS:  00007fd18d7fa700(0000) GS:ffff8bec7f6c0000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f83650024a0 CR3: 000000476e70c001 CR4: 00000000007626e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 pci_disable_msix+0xf3/0x120
 pci_free_irq_vectors+0xe/0x20
 vfio_msi_disable+0x89/0xd0 [vfio_pci]
 vfio_pci_set_msi_trigger+0x229/0x2d0 [vfio_pci]
 vfio_pci_ioctl+0x24f/0xdb0 [vfio_pci]
 ? pollwake+0x74/0x90
 ? wake_up_q+0x70/0x70
 do_vfs_ioctl+0xa4/0x630
 ? __alloc_fd+0x33/0x140
 ? syscall_trace_enter+0x1d3/0x2c0
 ksys_ioctl+0x60/0x90
 __x64_sys_ioctl+0x16/0x20
 do_syscall_64+0x5b/0x1a0
 entry_SYSCALL_64_after_hwframe+0x65/0xca


> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index 796fe97..4e082b8 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -107,6 +107,13 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_v=
dpa *v, u16 qid)
> >       vq->call_ctx.producer.token =3D vq->call_ctx.ctx;
> >       vq->call_ctx.producer.irq =3D irq;
> >       ret =3D irq_bypass_register_producer(&vq->call_ctx.producer);
> > +     if (unlikely(ret)) {
> > +             /*
> > +              * If registration failed,
> > +              * there is no need to unregister later.
> > +              */
> > +             vq->call_ctx.producer.token =3D NULL;
> > +     }
> >       spin_unlock(&vq->call_ctx.ctx_lock);
> >  }
> >
>
> 'ret' is otherwise unused in this function, so we could simply remove
> ret and change this to
>
>         if (irq_bypass_register_producer(&vq->call_ctx.producer)) {
>                 /* avoid generating bogus match on unregister */
>                 vq->call_ctx.producer.token =3D NULL;
>         }
>
> Also please submit vfio and vdpa as separate patches so that the
> respective maintainer for each area can handle them.  Thanks,
>
> Alex
>
OK, thank you, I'll submit it again in two separate patches.
Thanks Alex.
