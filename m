Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1CC2709F3
	for <lists+kvm@lfdr.de>; Sat, 19 Sep 2020 04:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgISCLg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 22:11:36 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43505 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726054AbgISCLf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Sep 2020 22:11:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600481494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1fWqbBBRX5EVeWNpvGlaoHo5M6bYu8vy+AmYAkNS+X4=;
        b=OknGu3MIRbHewbgap3bX5HxDnGaO1o+Rc908/ejK+arT69nRVQKbF/35o2Z9aaq9FYABmq
        15+uK2yupQWuhGfoOxdbCZ9DvRYHryBq4IfZElKAVW1wMQThC1D3lbDKTMo0/pZhAACyWY
        E+kXZH4tW/bfgATUPZ24v3dtC3VvvJE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-eSdF0UN0OC6HpK54gdFNUQ-1; Fri, 18 Sep 2020 22:11:30 -0400
X-MC-Unique: eSdF0UN0OC6HpK54gdFNUQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F46E1074665;
        Sat, 19 Sep 2020 02:11:29 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5D6D60BF1;
        Sat, 19 Sep 2020 02:11:28 +0000 (UTC)
Date:   Fri, 18 Sep 2020 20:11:28 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wanghaibin.wang@huawei.com>
Subject: Re: [PATCH 2/2] vfio/pci: Remove bardirty from vfio_pci_device
Message-ID: <20200918201128.16cf0a1c@x1.home>
In-Reply-To: <3b5214f9-9e17-2bcd-1b92-57bacc1c1b31@huawei.com>
References: <20200917033128.872-1-yuzenghui@huawei.com>
        <20200917033128.872-2-yuzenghui@huawei.com>
        <20200917133537.17af2ef3.cohuck@redhat.com>
        <20200917160742.4e4d6efd@x1.home>
        <3b5214f9-9e17-2bcd-1b92-57bacc1c1b31@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 19 Sep 2020 09:54:00 +0800
Zenghui Yu <yuzenghui@huawei.com> wrote:

> Hi Alex,
> 
> On 2020/9/18 6:07, Alex Williamson wrote:
> > On Thu, 17 Sep 2020 13:35:37 +0200
> > Cornelia Huck <cohuck@redhat.com> wrote:
> >   
> >> On Thu, 17 Sep 2020 11:31:28 +0800
> >> Zenghui Yu <yuzenghui@huawei.com> wrote:
> >>  
> >>> It isn't clear what purpose the @bardirty serves. It might be used to avoid
> >>> the unnecessary vfio_bar_fixup() invoking on a user-space BAR read, which
> >>> is not required when bardirty is unset.
> >>>
> >>> The variable was introduced in commit 89e1f7d4c66d ("vfio: Add PCI device
> >>> driver") but never actually used, so it shouldn't be that important. Remove
> >>> it.
> >>>
> >>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> >>> ---
> >>>   drivers/vfio/pci/vfio_pci_config.c  | 7 -------
> >>>   drivers/vfio/pci/vfio_pci_private.h | 1 -
> >>>   2 files changed, 8 deletions(-)  
> >>
> >> Yes, it seems to have been write-only all the time.  
> > 
> > I suspect the intent was that vfio_bar_fixup() could test
> > vdev->bardirty to avoid doing work if no BARs had been written since
> > they were last read.  As it is now we regenerate vconfig for all the
> > BARs every time any offset of any of them are read.  BARs aren't
> > re-read regularly and config space is not a performance path,  
> 
> Yes, it seems that Qemu itself emulates all BAR registers and will read
> the BAR from the kernel side only at initialization time.
> 
> > but maybe
> > we should instead test if we see any regressions from returning without
> > doing any work in vfio_bar_fixup() if vdev->bardirty is false.  Thanks,  
> 
> I will test it with the following diff. Please let me know which way do
> you prefer.
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c 
> b/drivers/vfio/pci/vfio_pci_config.c
> index d98843feddce..77c419d536d0 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -515,7 +515,7 @@ static int vfio_basic_config_read(struct 
> vfio_pci_device *vdev, int pos,
>                                    int count, struct perm_bits *perm,
>                                    int offset, __le32 *val)
>   {
> -       if (is_bar(offset)) /* pos == offset for basic config */
> +       if (is_bar(offset) && vdev->bardirty) /* pos == offset for basic 
> config */
>                  vfio_bar_fixup(vdev);
> 
>          count = vfio_default_config_read(vdev, pos, count, perm, 
> offset, val);


There's only one caller currently, but I'd think it cleaner to put this
in vfio_bar_fixup(), ie. return immediately if !bardirty.  Thanks,

Alex

