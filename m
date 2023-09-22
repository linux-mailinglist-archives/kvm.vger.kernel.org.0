Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539FE7AB4EE
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 17:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbjIVPmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 11:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbjIVPl7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 11:41:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA0B83
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 08:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695397266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h8GGyR26HgCvGZhzwOcL9OwZXNmbEGB0FfnJLE3ENiQ=;
        b=duQw8ZX1Apm8KXKSdN0EgOCoanMK1rlIACJFWVJiNhm+bv1u9OVBnf7N3nzUz8p3VeRChU
        OtiqGe7EZSo91sKTPHFu/WEB3bkDIkNUUMwkEpuFBt8gP1IN/9P5vLonvuglsPzdbVlG6R
        vmyZmquunYBQT+TOBOS8BTst+yWbMCE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-686-azZyepM6PiqUpu2aXQvXPQ-1; Fri, 22 Sep 2023 11:41:04 -0400
X-MC-Unique: azZyepM6PiqUpu2aXQvXPQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9a647551b7dso499194566b.1
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 08:41:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695397263; x=1696002063;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h8GGyR26HgCvGZhzwOcL9OwZXNmbEGB0FfnJLE3ENiQ=;
        b=OwzYzSDOtQMn+iEFi81fXl+L4fLDx/JnA0tRW0lY6Kglg8IlcP/kQk8EgvWvMBlBFl
         rMqpjY7jUeIncYUY0J53W0BU+kJAEs42qAXoMGM+dc/xqJx820Q3UtMc1TvyDBKc8Umn
         1LdCDx8mJIalLJ7/ITI1tUYpgtSmYckpHY8NLAFyJkC5GUDYRYb8NKH2P2MEQ2inmZG/
         THmkow+m2v0UNXVrk1A/NhXkA47x/BYAn4zsrdHnaxpjOPcEqCyvZWx7+44sC4c2pTvS
         Fu4TYmtc08I8uH9th57297wKivRgJnWQabFKiZBNA0jIsoerBKWo9Wer2WC0TLLXzH6D
         Z6xw==
X-Gm-Message-State: AOJu0YyIqH9oZzFO8m+5DicaTiWZFR2ZmCNdcmxzspDKQvK0HYFMA6SJ
        rX5/EZ01mYXgmlr3081rtK7Gri6t7LdNyKpbb+etdUCCNA4PgZhWPrnHH4WZdXqvPy2kVlU+47A
        Zu6WfhE0YiDQx
X-Received: by 2002:a17:907:6d04:b0:9ae:6648:9b53 with SMTP id sa4-20020a1709076d0400b009ae66489b53mr3779634ejc.23.1695397263539;
        Fri, 22 Sep 2023 08:41:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEF6Im2F1q9fQJV66ag6DVrZfORAIji4sdcacv5WHHxSTwxyC0yMCUrXkbhWQkVCbgte5hXHQ==
X-Received: by 2002:a17:907:6d04:b0:9ae:6648:9b53 with SMTP id sa4-20020a1709076d0400b009ae66489b53mr3779605ejc.23.1695397263189;
        Fri, 22 Sep 2023 08:41:03 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id lo18-20020a170906fa1200b0099bd1a78ef5sm2864932ejb.74.2023.09.22.08.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Sep 2023 08:41:02 -0700 (PDT)
Date:   Fri, 22 Sep 2023 11:40:58 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Parav Pandit <parav@nvidia.com>, Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230922113941-mutt-send-email-mst@kernel.org>
References: <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <20230921155834-mutt-send-email-mst@kernel.org>
 <CACGkMEvD+cTyRtax7_7TBNECQcGPcsziK+jCBgZcLJuETbyjYw@mail.gmail.com>
 <20230922122246.GN13733@nvidia.com>
 <PH0PR12MB548127753F25C45B7EFF203DDCFFA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20230922111132-mutt-send-email-mst@kernel.org>
 <20230922151534.GR13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230922151534.GR13733@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 12:15:34PM -0300, Jason Gunthorpe wrote:
> On Fri, Sep 22, 2023 at 11:13:18AM -0400, Michael S. Tsirkin wrote:
> > On Fri, Sep 22, 2023 at 12:25:06PM +0000, Parav Pandit wrote:
> > > 
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Friday, September 22, 2023 5:53 PM
> > > 
> > > 
> > > > > And what's more, using MMIO BAR0 then it can work for legacy.
> > > > 
> > > > Oh? How? Our team didn't think so.
> > > 
> > > It does not. It was already discussed.
> > > The device reset in legacy is not synchronous.
> > > The drivers do not wait for reset to complete; it was written for the sw backend.
> > > Hence MMIO BAR0 is not the best option in real implementations.
> > 
> > Or maybe they made it synchronous in hardware, that's all.
> > After all same is true for the IO BAR0 e.g. for the PF: IO writes
> > are posted anyway.
> 
> IO writes are not posted in PCI.

Aha, I was confused. Thanks for the correction. I guess you just buffer
subsequent transactions while reset is going on and reset quickly enough
for it to be seemless then?

-- 
MST

