Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60061F15CF
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 11:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbgFHJpk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 05:45:40 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32580 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729238AbgFHJpj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 05:45:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591609538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kol/mTHTVhoGIwKuk6EIdanpIihMAd/NI3dQP6aMTfw=;
        b=JK20nP9LVdqx6nPmQRTCMiX97aUjQbwJKGkCwW0l2ricxfYieigpNtiU8l22q33Ha0Lnwj
        oeekL9ZO/M+g/G2n3bfKIXJVpAlUWZewXIev8oEgwXPaCcxW3KSFCL7b9eNX9KXu9EkC3N
        BQvRf7abyO9YMo6/nzKYz3Lsb4K46IA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-4rmlr00LMfe9Gtegao4VMA-1; Mon, 08 Jun 2020 05:45:36 -0400
X-MC-Unique: 4rmlr00LMfe9Gtegao4VMA-1
Received: by mail-wr1-f71.google.com with SMTP id f4so6928556wrp.21
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 02:45:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kol/mTHTVhoGIwKuk6EIdanpIihMAd/NI3dQP6aMTfw=;
        b=OYk6WfViM3l4GXd9QTbwwpP0UFjo7HzfxR71vRZw8bDlBIgzO0nvHvFGtDsqduMwaq
         klEWcnEfYtoaQSF312GwbVryggRh18d2qBCnwTs8Op0FdleNY/DZ40ghanUt1A/f1AkW
         BHXCdcdk4qQ6e0VfEUWkFOICEoWcs3ncLCWbk4zq9vSGwZKFV+YVb595YejYc1AQmPRt
         /KTXRaM0hBWNH6ZltQ41U3DVnpPaDcYoDjC4120sDAIi2B0l5vZ/UNIPqQZa3dFzjNW1
         dG7IiU631nybvBArTCwWhe3uCD0x0Gut3eKzTZ+NPVs4XvOngfQjvi1kPiN6ICxCTIOc
         T63Q==
X-Gm-Message-State: AOAM531qFBk6KgV1oVdRW5K5OBmRtwQq9zxlynxomyn/Tj9eD4sBbd1/
        6kxpczUMkuEbMCLckNE4/O0lIWAVUm5yzsDqwebf6uZfcKDAr/UjttPadiubHrzFMwf6SG5xaQf
        FaJaQrdp3Vw1y
X-Received: by 2002:a1c:6606:: with SMTP id a6mr14991261wmc.37.1591609535376;
        Mon, 08 Jun 2020 02:45:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxxXd0c9S/NR+8Ws+FH4J22BlV9unbe3nngLympHYF/P34pWnt/4AiItXOTdFoZndGfb3hfQ==
X-Received: by 2002:a1c:6606:: with SMTP id a6mr14991247wmc.37.1591609535163;
        Mon, 08 Jun 2020 02:45:35 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id o10sm23169984wrj.37.2020.06.08.02.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 02:45:34 -0700 (PDT)
Date:   Mon, 8 Jun 2020 05:45:31 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, eli@mellanox.com
Subject: Re: [PATCH 5/6] vdpa: introduce virtio pci driver
Message-ID: <20200608054453-mutt-send-email-mst@kernel.org>
References: <20200529080303.15449-6-jasowang@redhat.com>
 <20200602010332-mutt-send-email-mst@kernel.org>
 <5dbb0386-beeb-5bf4-d12e-fb5427486bb8@redhat.com>
 <6b1d1ef3-d65e-08c2-5b65-32969bb5ecbc@redhat.com>
 <20200607095012-mutt-send-email-mst@kernel.org>
 <9b1abd2b-232c-aa0f-d8bb-03e65fd47de2@redhat.com>
 <20200608021438-mutt-send-email-mst@kernel.org>
 <a1b1b7fb-b097-17b7-2e3a-0da07d2e48ae@redhat.com>
 <20200608052041-mutt-send-email-mst@kernel.org>
 <9d2571b6-0b95-53b3-6989-b4d801eeb623@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d2571b6-0b95-53b3-6989-b4d801eeb623@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 08, 2020 at 05:43:58PM +0800, Jason Wang wrote:
> > 
> > > Looking at
> > > pci_match_one_device() it checks both subvendor and subdevice there.
> > > 
> > > Thanks
> > 
> > But IIUC there is no guarantee that driver with a specific subvendor
> > matches in presence of a generic one.
> > So either IFC or virtio pci can win, whichever binds first.
> 
> 
> I'm not sure I get there. But I try manually bind IFCVF to qemu's
> virtio-net-pci, and it fails.
> 
> Thanks

Right but the reverse can happen: virtio-net can bind to IFCVF first.

-- 
MST

