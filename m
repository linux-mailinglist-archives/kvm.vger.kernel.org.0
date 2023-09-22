Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456A47AB488
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 17:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbjIVPOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 11:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbjIVPOR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 11:14:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1642A1
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 08:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695395607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1fwravdlQW+TfYmAP3Jwly7QmycP8GgTViJStGE1Ymw=;
        b=iSJzZ08Y1tchgWCRAOBlIetO70YM3gVneoC3GCIz7Fwh+XaAh62/DYFlQOx05g7+GYYfKz
        4CkkbUVURqtK9vehuOG9h2NGl31/wt/4CbkQhja2iS0E2K/YuFClTB57c5OiZ2I9uiiL2d
        Mp/iBiPvIdi5PcR6ZQcjFL5CgbRau88=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-Ay-8FLRPNpusy5NCpRL9Hw-1; Fri, 22 Sep 2023 11:13:25 -0400
X-MC-Unique: Ay-8FLRPNpusy5NCpRL9Hw-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-53344a17f79so1346389a12.1
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 08:13:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695395603; x=1696000403;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1fwravdlQW+TfYmAP3Jwly7QmycP8GgTViJStGE1Ymw=;
        b=Ul8fuq6mFdxXKjoF+7GC/q5XG+RTpsKHrSUMnbMof0P0gbEYUXLxyvYt2iMaBglP4M
         cWLvhoteRUduybw0ylZD5/s98uAt+XQOJuIYUG/FOWXoJo49vlfdTk70CTq5d/pFpny2
         II6KM53kQxGJbTzIJ02DaB2Z6jZIcUwcMEdpVVNm+JxnTt7RoeS8bLOGnm/CRDArnqN2
         /Jp9/Y4Nw2q868wXm4hciLKEf/1XmCNbV2K3kwTocN7mQ+ZET968gxPvQgCztv0LeMHm
         CTTFXnreLTLBe3U/s4ZjZCgjSuAg4LJ4WHv2K5O51TxEAUwvb51Qem61Gk7fT63fW8h7
         4fsA==
X-Gm-Message-State: AOJu0Yy5WMk08LZTuziZPuU+7SXVgDM1KQpBXloc+fObP49ehhHrWrQY
        +3US/XNGyD7AbLyBiB+LQ6oTFnLmN8MDzAR/ZRUO7KY3NU4IuzozZR8EOTs0LpGZrVKKpTGDjmS
        VRnNAQWcHn5j8PvZ4VfIo
X-Received: by 2002:a50:ed19:0:b0:52a:943:9ab5 with SMTP id j25-20020a50ed19000000b0052a09439ab5mr7345425eds.31.1695395603655;
        Fri, 22 Sep 2023 08:13:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0GrOD/17wfL7ZvOlZyM/FdueLD1tF3NbMlJUxhkMCutGNKq9CV+OCyqlu/MCmwJVlx6neRA==
X-Received: by 2002:a50:ed19:0:b0:52a:943:9ab5 with SMTP id j25-20020a50ed19000000b0052a09439ab5mr7345404eds.31.1695395603338;
        Fri, 22 Sep 2023 08:13:23 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id e9-20020aa7d7c9000000b00532acb014a6sm2366924eds.68.2023.09.22.08.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Sep 2023 08:13:22 -0700 (PDT)
Date:   Fri, 22 Sep 2023 11:13:18 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Jason Wang <jasowang@redhat.com>,
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
Message-ID: <20230922111132-mutt-send-email-mst@kernel.org>
References: <20230921131035-mutt-send-email-mst@kernel.org>
 <20230921174450.GT13733@nvidia.com>
 <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <20230921155834-mutt-send-email-mst@kernel.org>
 <CACGkMEvD+cTyRtax7_7TBNECQcGPcsziK+jCBgZcLJuETbyjYw@mail.gmail.com>
 <20230922122246.GN13733@nvidia.com>
 <PH0PR12MB548127753F25C45B7EFF203DDCFFA@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB548127753F25C45B7EFF203DDCFFA@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 12:25:06PM +0000, Parav Pandit wrote:
> 
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Friday, September 22, 2023 5:53 PM
> 
> 
> > > And what's more, using MMIO BAR0 then it can work for legacy.
> > 
> > Oh? How? Our team didn't think so.
> 
> It does not. It was already discussed.
> The device reset in legacy is not synchronous.
> The drivers do not wait for reset to complete; it was written for the sw backend.
> Hence MMIO BAR0 is not the best option in real implementations.

Or maybe they made it synchronous in hardware, that's all.
After all same is true for the IO BAR0 e.g. for the PF: IO writes are posted anyway.

Whether that's possible would depend on the hardware architecture.

-- 
MST

