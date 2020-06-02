Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49751EB4ED
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 07:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgFBFK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 01:10:26 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34763 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725781AbgFBFK0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Jun 2020 01:10:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591074624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Omt9gJipjlxk0xAiBkDipMLYpK/jCtWILzTzD1eFi2g=;
        b=NdviXW1fp70i2/+tPWhhJyP5JSoKtZQl3NHWvSR4UNBqq2/lGn2cTB1n3zpuYg42OKqBQ8
        3DN3gxgkj7USAZxjhSpiNtiOW7aUUcodVHYReqTqUkrioe2QkpAR5uCe0ZLpz3rqvADvIm
        Cfq3Y5PeB1XoF/w0zwmWmS+Hl9jVlug=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-hyGGNli4NzytiqMQvvWigQ-1; Tue, 02 Jun 2020 01:09:38 -0400
X-MC-Unique: hyGGNli4NzytiqMQvvWigQ-1
Received: by mail-wr1-f70.google.com with SMTP id p10so878111wrn.19
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 22:09:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Omt9gJipjlxk0xAiBkDipMLYpK/jCtWILzTzD1eFi2g=;
        b=X5kwvmAmk8xKd9G/p6NNwS2xKESE6wKmeWXP8brhCuRDg6FAhZ9lhCnxyK6sdgGajW
         5L9Uwg8fopDqKbYar41WtHvSfV1+lcUhaflQVgiJxXIs8j2e7/fmMuOMhkgNQSMJLKwV
         7A2a8bbQIrp7mNl8zgZ+JfDLjEC817P3hkZFmA7zbByHrogSgEpiCVmapw0Gmqc9UGq3
         q2jc1WrDuvExArxqgAJqZ+amcTmktnF++oY47wT70OmtwTlIwh3L8VLmbR/6a0waaIZI
         77cZ8qe0gE/b3oQ2lg33ynA1DurosU0qvDoLDyWFKf+YxsC9b3N+zsqSYlsxSJ/aHcm+
         NhHQ==
X-Gm-Message-State: AOAM531fZWWVpQNQSj/pcCUIfOaBr7sHIWlhLfW9CUFgDSOqp3x8A9P1
        SyZF9JDHkwpRVgqIdWdU4N56saZ5i7FwEmWN45mtXttbmYiCMErzM/Sp6yz3hlyKs3sY1YftRno
        2bYeKUPiw34rl
X-Received: by 2002:a05:6000:11cd:: with SMTP id i13mr23481648wrx.141.1591074577588;
        Mon, 01 Jun 2020 22:09:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzC4LVeDOhERR8qf9AS4nc4Mi6WpaPRsevGBTu/GWRHQywd6PHu2y8E93bGd9V5IBqDeftUgQ==
X-Received: by 2002:a05:6000:11cd:: with SMTP id i13mr23481639wrx.141.1591074577444;
        Mon, 01 Jun 2020 22:09:37 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id a3sm1785369wmb.7.2020.06.01.22.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 22:09:36 -0700 (PDT)
Date:   Tue, 2 Jun 2020 01:09:34 -0400
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
Message-ID: <20200602010809-mutt-send-email-mst@kernel.org>
References: <20200529080303.15449-1-jasowang@redhat.com>
 <20200529080303.15449-6-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529080303.15449-6-jasowang@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 29, 2020 at 04:03:02PM +0800, Jason Wang wrote:
> Note that since virtio specification does not support get/restore
> virtqueue state. So we can not use this driver for VM. This can be
> addressed by extending the virtio specification.

Looks like exactly the kind of hardware limitation VDPA is supposed to
paper over within guest. So I suggest we use this as
a litmus test, and find ways for VDPA to handle this without
spec changes.

-- 
MST

