Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088E17BFFCF
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 16:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233237AbjJJOzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 10:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbjJJOzW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 10:55:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756FAA7
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 07:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696949670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vH/MnbtKKOMlCHZOBuk2f+A+YeXj1EEx7KSK3diMmgU=;
        b=K5nt1xCBh6gzWxWZZ/lt3Q/iNRijQA6yNiCEJ64tSjn1gJ5NpPSoUy3veag54ZwBgbyYsQ
        9tSLSZ87cTuNubFhczdHV5Ztrn5bGtzKuPthJF6CznsRzJ1lHqqUcfIbtz/8oY/hQhbyjN
        A1YIYU1ixZ0ZVIaX+KVfD06mTXbu4Pw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-e9unS-ZMPZW-eBaUcOBogw-1; Tue, 10 Oct 2023 10:54:29 -0400
X-MC-Unique: e9unS-ZMPZW-eBaUcOBogw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3fe1521678fso44833055e9.1
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 07:54:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696949668; x=1697554468;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vH/MnbtKKOMlCHZOBuk2f+A+YeXj1EEx7KSK3diMmgU=;
        b=Xi7qhxjol/LQkHTNHAgNEfkzZ7zeb5ydc9v8r5SA9yUlMueMQI4tHmYQAGzwxxgFS1
         myW4rY3XqgEsMlo8SZyLdyIgqtEK+Av7nX02JGCvk9EMMDXLIRsNnmccEikJUH/fQWly
         QNCV3Q71MWxYg9ftUXimQix6kQot+q1mJpxaetpWuL4VODssQI+gRuCQQt5THD8nBuc/
         9ihDMKbVj8hKw0+9Sy3PLM7SWpwAwDjWqjYhkaavEDnmQSquf/MMffaLuwtbmuWhmoVj
         glbYQsFAxRYuN16bL/rMo6Gl2Qj9hoy2T1M28/CDdZ6zN8tuKpbj464ixOaaE1f01eI5
         bUAw==
X-Gm-Message-State: AOJu0YyUQKh3VjZzSYJDguBv+FO1vQcnnof6PMQmr5Ey30c0poAfU1lF
        fazHkTxMDKqlt2ZAv0dJWzhVfNB2Sh1C3hB8gntS38THxeLXo+WRyo7yOwSyjPyGaG2CdkyhrJE
        cO4rIX+qq9TEh
X-Received: by 2002:a05:600c:d1:b0:405:3a3d:6f42 with SMTP id u17-20020a05600c00d100b004053a3d6f42mr16390020wmm.39.1696949668258;
        Tue, 10 Oct 2023 07:54:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHwxS+5Hdl6YIlvPeBVrNrp4ft3RNUHoqkj2WG1fNEpSoTU00S2AQrMpg6XmmwADS1I11lK7w==
X-Received: by 2002:a05:600c:d1:b0:405:3a3d:6f42 with SMTP id u17-20020a05600c00d100b004053a3d6f42mr16390004wmm.39.1696949667941;
        Tue, 10 Oct 2023 07:54:27 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73d2:bf00:e379:826:5137:6b23])
        by smtp.gmail.com with ESMTPSA id s11-20020a7bc38b000000b003fbe4cecc3bsm16612016wmj.16.2023.10.10.07.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 07:54:27 -0700 (PDT)
Date:   Tue, 10 Oct 2023 10:54:24 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231010105339-mutt-send-email-mst@kernel.org>
References: <c3724e2f-7938-abf7-6aea-02bfb3881151@nvidia.com>
 <20230926072538-mutt-send-email-mst@kernel.org>
 <ZRpjClKM5mwY2NI0@infradead.org>
 <20231002151320.GA650762@nvidia.com>
 <ZR54shUxqgfIjg/p@infradead.org>
 <20231005111004.GK682044@nvidia.com>
 <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231010140849.GL3952@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 11:08:49AM -0300, Jason Gunthorpe wrote:
> On Tue, Oct 10, 2023 at 09:56:00AM -0400, Michael S. Tsirkin wrote:
> 
> > > However - the Intel GPU VFIO driver is such a bad experiance I don't
> > > want to encourage people to make VFIO drivers, or code that is only
> > > used by VFIO drivers, that are not under drivers/vfio review.
> > 
> > So if Alex feels it makes sense to add some virtio functionality
> > to vfio and is happy to maintain or let you maintain the UAPI
> > then why would I say no? But we never expected devices to have
> > two drivers like this does, so just exposing device pointer
> > and saying "use regular virtio APIs for the rest" does not
> > cut it, the new APIs have to make sense
> > so virtio drivers can develop normally without fear of stepping
> > on the toes of this admin driver.
> 
> Please work with Yishai to get something that make sense to you. He
> can post a v2 with the accumulated comments addressed so far and then
> go over what the API between the drivers is.
> 
> Thanks,
> Jason

/me shrugs. I pretty much posted suggestions already. Should not be hard.
Anything unclear - post on list.

-- 
MST

