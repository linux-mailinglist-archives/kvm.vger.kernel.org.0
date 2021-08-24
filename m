Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004433F6A68
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 22:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235191AbhHXUav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 16:30:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51440 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235174AbhHXUau (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Aug 2021 16:30:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629837005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J6zJIonQ8sbLYLpWTPIgRo4g40sNi8HlntfUwF/X63A=;
        b=HsaHy3fkm6zr9PpEbiCAIi53X3A+jr95f0mDBH0T5KkwTFhqx6oXdNd9u7SgtozeBr0KDP
        BhSNAgHwinBP6ovB+2Asnc5T4+Mn3figHwNrC5kEmdkZXx2Z8Npf71MJP0AYU7GBRust1E
        kaoskQzX87fYUkgSsN78y/j7r3w1688=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-Z0P6aTdSOtG7j000SB626Q-1; Tue, 24 Aug 2021 16:30:04 -0400
X-MC-Unique: Z0P6aTdSOtG7j000SB626Q-1
Received: by mail-ot1-f69.google.com with SMTP id 8-20020a9d0588000000b0051defe13038so1788760otd.9
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 13:30:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=J6zJIonQ8sbLYLpWTPIgRo4g40sNi8HlntfUwF/X63A=;
        b=BGUBvTrbBALAeg7Z9xkAPZHZ6twpC2oZvIQQb+EmhutcbnJi+WiSMLNQ8VyVtXx6rK
         2pPk0ec41MhHODNI9Vkd+WxVM/ag+/SWwjkyc9IRcZYiHT5CCmGTsXHTyh+1guZgqQsd
         K1npprb8ncACUUytJNrNet02PNl0WJhImp5/RRRthAUdQkMFzCQ5nCDLyKgdX0+rivBK
         ThLSll6MJGL86Eug5+nIwcmstKir9FEuKH0V3/iHp9ihilm2++JTQqpY62ATbsXJLfJj
         sKbyBMlXKChMDa4ysIjSBfYuxBDXgDubRBTu3GNji55virpshcSpYEAxbtpIwTqOjq9W
         bG0g==
X-Gm-Message-State: AOAM531ID8CMgftnzgfZr3u9AdXchsPSh8Pm+TuUoMi1VHfagj5V0Dtv
        3DJbs5GYSnLmEnFrGxmlx6QMLqBWjUEBY9a2ddz3PmSGIqisBXl48AZWRVAaX5Dlg/bd/blbhw7
        r9eVsCnEmbFri
X-Received: by 2002:aca:e0d7:: with SMTP id x206mr4202527oig.64.1629837003408;
        Tue, 24 Aug 2021 13:30:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7vVhF4XwzKAtQjFHSJbTyCq4g1oiWfoZbe/haR7vHY/Y6rFS9ri4QbRqIzCsPv2xQKnXCJg==
X-Received: by 2002:aca:e0d7:: with SMTP id x206mr4202510oig.64.1629837003228;
        Tue, 24 Aug 2021 13:30:03 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id f3sm5161191otc.49.2021.08.24.13.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 13:30:02 -0700 (PDT)
Date:   Tue, 24 Aug 2021 14:30:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org
Subject: Re: [PATCH v4] vfio/ap_ops: Convert to use
 vfio_register_group_dev()
Message-ID: <20210824143001.37d01a77.alex.williamson@redhat.com>
In-Reply-To: <0-v4-0203a4ab0596+f7-vfio_ap_jgg@nvidia.com>
References: <0-v4-0203a4ab0596+f7-vfio_ap_jgg@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Aug 2021 11:42:04 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This is straightforward conversion, the ap_matrix_mdev is actually serving
> as the vfio_device and we can replace all the mdev_get_drvdata()'s with a
> simple container_of() or a dev_get_drvdata() for sysfs paths.
> 
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c     | 155 +++++++++++++++-----------
>  drivers/s390/crypto/vfio_ap_private.h |   2 +
>  2 files changed, 91 insertions(+), 66 deletions(-)

Jason & Tony,

Would one of you please rebase on the other's series?  The merge
conflict between this and 20210823212047.1476436-1-akrowiak@linux.ibm.com
is more than I'd like to bury into a merge commit and I can't test beyond
a cross compile.  Thanks,

Alex

