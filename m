Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34023420DE
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 16:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhCSPYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 11:24:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58368 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230397AbhCSPXv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 11:23:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616167430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FfFFsBkqDbyOuUBpyrx2aIg9R1MizVQFJzxYjdgh+z4=;
        b=DtBYTTMRNNsPLXtl+MPBn/qbW+Ge8n/VGR2dtyadJtD3jSGoxTkRNnETpozjLWSFek/70y
        BsDBedrJGrf1AGR93DugzYnzqn2OViVGt1z5geEPO7mTIKwiKKtWeG+YD+eRYmMoXYndpE
        Q2RgMxhvlxJgFJ3atUER+HCyV9pwvNc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-PqctppkdNuy4YXBr0zhHaQ-1; Fri, 19 Mar 2021 11:23:45 -0400
X-MC-Unique: PqctppkdNuy4YXBr0zhHaQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECDDE190D341;
        Fri, 19 Mar 2021 15:23:42 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-120.phx2.redhat.com [10.3.112.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93F6560C04;
        Fri, 19 Mar 2021 15:23:41 +0000 (UTC)
Date:   Fri, 19 Mar 2021 09:23:41 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, <jgg@nvidia.com>,
        <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <cjia@nvidia.com>, <yishaih@nvidia.com>, <mjrosato@linux.ibm.com>,
        <hch@lst.de>
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210319092341.14bb179a@omen.home.shazbot.org>
In-Reply-To: <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
        <20210309083357.65467-9-mgurtovoy@nvidia.com>
        <19e73e58-c7a9-03ce-65a7-50f37d52ca15@ozlabs.ru>
        <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Mar 2021 14:57:57 +0200
Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
> On 3/10/2021 8:39 AM, Alexey Kardashevskiy wrote:
> > On 09/03/2021 19:33, Max Gurtovoy wrote: =20
> >> +static const struct pci_device_id nvlink2gpu_vfio_pci_table[] =3D {
> >> +=C2=A0=C2=A0=C2=A0 { PCI_VDEVICE(NVIDIA, 0x1DB1) }, /* GV100GL-A NVID=
IA Tesla=20
> >> V100-SXM2-16GB */
> >> +=C2=A0=C2=A0=C2=A0 { PCI_VDEVICE(NVIDIA, 0x1DB5) }, /* GV100GL-A NVID=
IA Tesla=20
> >> V100-SXM2-32GB */
> >> +=C2=A0=C2=A0=C2=A0 { PCI_VDEVICE(NVIDIA, 0x1DB8) }, /* GV100GL-A NVID=
IA Tesla=20
> >> V100-SXM3-32GB */
> >> +=C2=A0=C2=A0=C2=A0 { PCI_VDEVICE(NVIDIA, 0x1DF5) }, /* GV100GL-B NVID=
IA Tesla=20
> >> V100-SXM2-16GB */ =20
> >
> >
> > Where is this list from?
> >
> > Also, how is this supposed to work at the boot time? Will the kernel=20
> > try binding let's say this one and nouveau? Which one is going to win? =
=20
>=20
> At boot time nouveau driver will win since the vfio drivers don't=20
> declare MODULE_DEVICE_TABLE

This still seems troublesome, AIUI the MODULE_DEVICE_TABLE is
responsible for creating aliases so that kmod can figure out which
modules to load, but what happens if all these vfio-pci modules are
built into the kernel or the modules are already loaded?

In the former case, I think it boils down to link order while the
latter is generally considered even less deterministic since it depends
on module load order.  So if one of these vfio modules should get
loaded before the native driver, I think devices could bind here first.

Are there tricks/extensions we could use in driver overrides, for
example maybe a compatibility alias such that one of these vfio-pci
variants could match "vfio-pci"?  Perhaps that, along with some sort of
priority scheme to probe variants ahead of the base driver, though I'm
not sure how we'd get these variants loaded without something like
module aliases.  I know we're trying to avoid creating another level of
driver matching, but that's essentially what we have in the compat
option enabled here, and I'm not sure I see how userspace makes the
leap to understand what driver to use for a given device.  Thanks,

Alex

