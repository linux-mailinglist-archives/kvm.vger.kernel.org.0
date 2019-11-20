Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097A91043E9
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 20:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfKTTHY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 14:07:24 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35490 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726931AbfKTTHX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Nov 2019 14:07:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574276843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8iPj+5VCfBepZUEX3ZDa/r5aYnpsBf0P0ryt2784Syk=;
        b=TJdXnIF8k73mY5gYQtcr4gvuyqSl/Odr2Go4xWbHMsZgIzvlu6rVC2gSWXlUQkvGVDneKg
        zq9z17/X1A4LjBw82JN0ZsaedtQOOegkuEJAbimc0/QasqFt07w3OB0UH8UwP7KZ1w6VA9
        OPl4pItNw3oO5BM0ZLwh1tvVKl12XAY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-fDZBxbvGOHKoGDUqgwZ0HQ-1; Wed, 20 Nov 2019 14:07:21 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53B2018C35A0;
        Wed, 20 Nov 2019 19:07:18 +0000 (UTC)
Received: from x1.home (ovpn-116-56.phx2.redhat.com [10.3.116.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A384251B9C;
        Wed, 20 Nov 2019 19:07:16 +0000 (UTC)
Date:   Wed, 20 Nov 2019 12:07:15 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     <lantianyu1986@gmail.com>, <cohuck@redhat.com>,
        "KY Srinivasan" <kys@microsoft.com>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        "Stephen Hemminger" <sthemmin@microsoft.com>, <sashal@kernel.org>,
        <mchehab+samsung@kernel.org>, <davem@davemloft.net>,
        <gregkh@linuxfoundation.org>, <robh@kernel.org>,
        <Jonathan.Cameron@huawei.com>, <paulmck@linux.ibm.com>,
        "Michael Kelley" <mikelley@microsoft.com>,
        "Tianyu Lan" <Tianyu.Lan@microsoft.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-hyperv@vger.kernel.org>, "vkuznets" <vkuznets@redhat.com>
Subject: Re: [PATCH] VFIO/VMBUS: Add VFIO VMBUS driver support
Message-ID: <20191120120715.0cecf5ea@x1.home>
In-Reply-To: <20191120103503.5f7bd7c4@hermes.lan>
References: <20191111084507.9286-1-Tianyu.Lan@microsoft.com>
        <20191119165620.0f42e5ba@x1.home>
        <20191120103503.5f7bd7c4@hermes.lan>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: fDZBxbvGOHKoGDUqgwZ0HQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Nov 2019 10:35:03 -0800
Stephen Hemminger <stephen@networkplumber.org> wrote:

> On Tue, 19 Nov 2019 15:56:20 -0800
> "Alex Williamson" <alex.williamson@redhat.com> wrote:
>=20
> > On Mon, 11 Nov 2019 16:45:07 +0800
> > lantianyu1986@gmail.com wrote:
> >  =20
> > > From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> > >=20
> > > This patch is to add VFIO VMBUS driver support in order to expose
> > > VMBUS devices to user space drivers(Reference Hyper-V UIO driver).
> > > DPDK now has netvsc PMD driver support and it may get VMBUS resources
> > > via VFIO interface with new driver support.
> > >=20
> > > So far, Hyper-V doesn't provide virtual IOMMU support and so this
> > > driver needs to be used with VFIO noiommu mode.   =20
> >=20
> > Let's be clear here, vfio no-iommu mode taints the kernel and was a
> > compromise that we can re-use vfio-pci in its entirety, so it had a
> > high code reuse value for minimal code and maintenance investment.  It
> > was certainly not intended to provoke new drivers that rely on this mod=
e
> > of operation.  In fact, no-iommu should be discouraged as it provides
> > absolutely no isolation.  I'd therefore ask, why should this be in the
> > kernel versus any other unsupportable out of tree driver?  It appears
> > almost entirely self contained.  Thanks,
> >=20
> > Alex =20
>=20
> The current VMBUS access from userspace is from uio_hv_generic
> there is (and will not be) any out of tree driver for this.

I'm talking about the driver proposed here.  It can only be used in a
mode that taints the kernel that its running on, so why would we sign
up to support 400 lines of code that has no safe way to use it?
=20
> The new driver from Tianyu is to make VMBUS behave like PCI.
> This simplifies the code for DPDK and other usermode device drivers
> because it can use the same API's for VMBus as is done for PCI.

But this doesn't re-use the vfio-pci API at all, it explicitly defines
a new vfio-vmbus API over the vfio interfaces.  So a user mode driver
might be able to reuse some vfio support, but I don't see how this has
anything to do with PCI.

> Unfortunately, since Hyper-V does not support virtual IOMMU yet,
> the only usage modle is with no-iommu taint.

Which is what makes it unsupportable and prompts the question why it
should be included in the mainline kernel as it introduces a
maintenance burden and normalizes a usage model that's unsafe.  Thanks,

Alex

