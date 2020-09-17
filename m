Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDA126E7F4
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 00:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgIQWHr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 18:07:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33755 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725874AbgIQWHr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 18:07:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600380466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aViMg+Pc+E39KYInTit03KCHA+7VqkV7P3uI8wkBDXE=;
        b=F/GIdO2YIWxYDgfV30Aow4FmfTftDlNCU6FaM+ycjAw7LK33ax+FfiqX3VRqmSnIKzVdQJ
        rJzHd6g4S42aYT+3MB+XIVARDkIkVTXkVVGmzbyeHoUQRtwelfa1MXIKoT93ZglCK2cdpQ
        oHCRnaMXsnqDDnWXYI2HMrKjBQ+eWXQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-brqZ6OWuMAuh19u2m6FVMg-1; Thu, 17 Sep 2020 18:07:44 -0400
X-MC-Unique: brqZ6OWuMAuh19u2m6FVMg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30B77801AF5;
        Thu, 17 Sep 2020 22:07:43 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F19B55761;
        Thu, 17 Sep 2020 22:07:42 +0000 (UTC)
Date:   Thu, 17 Sep 2020 16:07:42 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Zenghui Yu <yuzenghui@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wanghaibin.wang@huawei.com>
Subject: Re: [PATCH 2/2] vfio/pci: Remove bardirty from vfio_pci_device
Message-ID: <20200917160742.4e4d6efd@x1.home>
In-Reply-To: <20200917133537.17af2ef3.cohuck@redhat.com>
References: <20200917033128.872-1-yuzenghui@huawei.com>
        <20200917033128.872-2-yuzenghui@huawei.com>
        <20200917133537.17af2ef3.cohuck@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Sep 2020 13:35:37 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Thu, 17 Sep 2020 11:31:28 +0800
> Zenghui Yu <yuzenghui@huawei.com> wrote:
> 
> > It isn't clear what purpose the @bardirty serves. It might be used to avoid
> > the unnecessary vfio_bar_fixup() invoking on a user-space BAR read, which
> > is not required when bardirty is unset.
> > 
> > The variable was introduced in commit 89e1f7d4c66d ("vfio: Add PCI device
> > driver") but never actually used, so it shouldn't be that important. Remove
> > it.
> > 
> > Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_config.c  | 7 -------
> >  drivers/vfio/pci/vfio_pci_private.h | 1 -
> >  2 files changed, 8 deletions(-)  
> 
> Yes, it seems to have been write-only all the time.

I suspect the intent was that vfio_bar_fixup() could test
vdev->bardirty to avoid doing work if no BARs had been written since
they were last read.  As it is now we regenerate vconfig for all the
BARs every time any offset of any of them are read.  BARs aren't
re-read regularly and config space is not a performance path, but maybe
we should instead test if we see any regressions from returning without
doing any work in vfio_bar_fixup() if vdev->bardirty is false.  Thanks,

Alex

