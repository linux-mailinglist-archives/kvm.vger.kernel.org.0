Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1331F50C3F2
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 01:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbiDVWpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 18:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233793AbiDVWpJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 18:45:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 51DE61FB0EC
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650663222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OVdpySho78QxGwo+0KGsjIyCa6WEEXxXhaufuAQU1LY=;
        b=F/j7xPz8acMjzPUSlM8NxXKF8OwTDvVBdiGbk54ebrnpK1eXKgYDzRI1iAVxiRvfLVv7qz
        JAV1+yivH4SomdguPDJ4tKsFIg2daiKAr39WyB5IdIDC/5ZcxpyUmaL61zLJR3t0iATwdD
        3ER6JTMJP4e++Qng+R7PbUvnps5R/Uc=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622--l2LkvtCO0Ozm483LNQquw-1; Fri, 22 Apr 2022 17:33:33 -0400
X-MC-Unique: -l2LkvtCO0Ozm483LNQquw-1
Received: by mail-io1-f71.google.com with SMTP id j6-20020a5d93c6000000b0064fbbf9566bso6173516ioo.12
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:33:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=OVdpySho78QxGwo+0KGsjIyCa6WEEXxXhaufuAQU1LY=;
        b=FoEL2mFlBsI9j2ieey286dTh1yvTtIEQNeU0WbT9Mk1T3PjU1C8MPcmfb90fynWlSo
         3kgjnq4j6UjRr9AZJ5J2oHqlOg2s9X9Y1ryoLXO94Clj4/dwRujRXpMGonmeZt8qAuQr
         OfmrwVnng8QmQc3h0Iaz1sAwZUKYCQGszoe/JJ3PW78DOxWobKlj5Y0KrcFhsmQPNq5B
         tite61+nhGBcJ22+JcJrXRF7yLd6niWHBZjtJWYMauF7PRNO+WBOtoHgb9xayMvbFY4C
         v8M/xtdxYnLGJXVie9XK2/Jr69YQHbUBY8hjNB6BOc0ypHs/5pl0YKYp4N73nzIdN2Ee
         4/8Q==
X-Gm-Message-State: AOAM532sg+aO5oRe8XsqEooifhl+uBPGPG89simvQ91yGXVWsear4g6R
        CKasbOPKYgTTWG4qDE6p5qn6YI7/ggCoUBaoU+CS+G1AE1zTlz9zulesAGTLg4cWFbuQnLsE+PU
        1RmGgwfFf2322
X-Received: by 2002:a6b:ce01:0:b0:64c:ad0b:9a65 with SMTP id p1-20020a6bce01000000b0064cad0b9a65mr2733061iob.147.1650663212444;
        Fri, 22 Apr 2022 14:33:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHQuEJ/4+XIAxI8nDJGV2Ar3DbGZhR50PQUrjkKMeDChjKbDWeZkXiL8fKTuOT4FzFCDsVZg==
X-Received: by 2002:a6b:ce01:0:b0:64c:ad0b:9a65 with SMTP id p1-20020a6bce01000000b0064cad0b9a65mr2733044iob.147.1650663212250;
        Fri, 22 Apr 2022 14:33:32 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s7-20020a5eaa07000000b00654bf640320sm2210052ioe.55.2022.04.22.14.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 14:33:31 -0700 (PDT)
Date:   Fri, 22 Apr 2022 15:33:30 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, cohuck@redhat.com,
        qemu-devel@nongnu.org, david@gibson.dropbear.id.au,
        thuth@redhat.com, farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, nicolinc@nvidia.com,
        eric.auger@redhat.com, eric.auger.pro@gmail.com,
        kevin.tian@intel.com, chao.p.peng@intel.com, yi.y.sun@intel.com,
        peterx@redhat.com
Subject: Re: [RFC 15/18] vfio/iommufd: Implement iommufd backend
Message-ID: <20220422153330.7e0a3956.alex.williamson@redhat.com>
In-Reply-To: <20220422145815.GK2120790@nvidia.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
        <20220414104710.28534-16-yi.l.liu@intel.com>
        <20220422145815.GK2120790@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Apr 2022 11:58:15 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> I don't see IOMMU_IOAS_IOVA_RANGES called at all, that seems like a
> problem..

Not as much as you might think.  Note that you also won't find QEMU
testing VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE in the QEMU vfio-pci
driver either.  The vfio-nvme driver does because it has control of the
address space it chooses to use, but for vfio-pci the address space is
dictated by the VM and there's not a lot of difference between knowing
in advance that a mapping conflicts with a reserved range or just
trying add the mapping and taking appropriate action if it fails.
Thanks,

Alex

