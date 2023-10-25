Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74E787D71C5
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 18:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbjJYQc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 12:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjJYQcY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 12:32:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5F591
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 09:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698251501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=owj/IgbM605bV8Yu7nR7E/zNBKuxTVn/TxVFSd4A+Wg=;
        b=TKWT4Kyl9+ZQO3V5MCBIwrrIQ12MsqNMZAbU+o0XD7rfcnqisNJKmBAqDdDjCN48R+n8NZ
        5P5d0kGXK90SbdGAcMjOgGkTZvvFtbL7CaJWApNVSh6PG8XVrxgCOZgtYF8Skt1LsxBE0F
        ggnYHdx8woPnN7/I3/NUF6APsL2CEI8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-NNGrkdhoPVKKt5rSC9bkLg-1; Wed, 25 Oct 2023 12:31:37 -0400
X-MC-Unique: NNGrkdhoPVKKt5rSC9bkLg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4083717431eso35659925e9.1
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 09:31:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698251496; x=1698856296;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=owj/IgbM605bV8Yu7nR7E/zNBKuxTVn/TxVFSd4A+Wg=;
        b=J4aTeZJyHWeYfLR3A76hIT+ClCL4CJmUeQaowSsv59jyZEg0bTg3ucuTzrDyOv3Jpv
         FIrCYxylZWwHsNoLQDKyOZqcdTSHqbTuO2aar4tEwYnngXY1K0xe65PsQ0KwyoX+CnpR
         lopE+5SPal6xhT1eOI2ZPl8uLw/D4fqz3jot3tdXtQMn7IbQO91/Pgo4yBNjx9kuXY0e
         3ibQzG9YPsE6jECY9C3R6ZDyPBUf37He0jq9Wc7IDpZC7WzCXMMS2UnCcyNdXUmvx/27
         WKAlXwNsmwxbEJmgUaOhHK9+wmsDcs/OpwFw3vQg13CFxr/XUd4lSfA44kG/uGgXRRvt
         6xpA==
X-Gm-Message-State: AOJu0YxULPrOBlIp3NsqK2E/8lL7gfn4+/90WlVq1debgK+VO877m3uy
        RgtbKPM+nQHKOYuIkWztO/om+PK048QIb8833sF5A1S4pRVYNpP6PBVgGmB5sQoTDzxve1S4xix
        oerCqn6qLuM+U
X-Received: by 2002:a05:600c:1d22:b0:408:4475:8cc1 with SMTP id l34-20020a05600c1d2200b0040844758cc1mr13426462wms.35.1698251496407;
        Wed, 25 Oct 2023 09:31:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDm9/V4aKQCUkrPB+NkD3U1VePFB4INruAwiAqMqgKfjYNyEo1VUV9pgHR3nBbainlDQFKXQ==
X-Received: by 2002:a05:600c:1d22:b0:408:4475:8cc1 with SMTP id l34-20020a05600c1d2200b0040844758cc1mr13426436wms.35.1698251496049;
        Wed, 25 Oct 2023 09:31:36 -0700 (PDT)
Received: from redhat.com ([2a02:14f:1f6:3c98:7fa5:a31:81ed:a5e2])
        by smtp.gmail.com with ESMTPSA id r22-20020a05600c159600b004075d5664basm210861wmf.8.2023.10.25.09.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 09:31:35 -0700 (PDT)
Date:   Wed, 25 Oct 2023 12:31:30 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com,
        si-wei.liu@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 vfio 6/9] virtio-pci: Introduce APIs to execute legacy
 IO admin commands
Message-ID: <20231025122913-mutt-send-email-mst@kernel.org>
References: <20231017134217.82497-1-yishaih@nvidia.com>
 <20231017134217.82497-7-yishaih@nvidia.com>
 <20231024165210-mutt-send-email-mst@kernel.org>
 <5a83e6c1-1d32-4edb-a01c-3660ab74d875@nvidia.com>
 <20231025060501-mutt-send-email-mst@kernel.org>
 <03c4e0da-7a5c-44bc-98f8-fca8228a9674@nvidia.com>
 <20231025094118-mutt-send-email-mst@kernel.org>
 <c6c849b6-e1ff-4319-a199-5abcac032a25@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6c849b6-e1ff-4319-a199-5abcac032a25@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 25, 2023 at 05:03:55PM +0300, Yishai Hadas wrote:
> > Yes - I think some kind of API will be needed to setup/cleanup.
> > Then 1st call to setup would do the list/use dance? some ref counting?
> 
> OK, we may work to come in V2 with that option in place.
> 
> Please note that the initialization 'list/use' commands would be done as
> part of the admin queue activation but we can't enable the admin queue for
> the upper layers before that it was done.

I don't know what does this mean.

> So, we may consider skipping the ref count set/get as part of the
> initialization flow with some flag/detection of the list/use commands as the
> ref count setting enables the admin queue for upper-layers which we would
> like to prevent by that time.

You can init on 1st use but you can't destroy after last use.
For symmetry it's better to just have explicit constructor/destructor.


> > 
> > And maybe the API should just be
> > bool virtio_pci_admin_has_legacy_io()
> 
> This can work as well.
> 
> In that case, the API will just get the VF PCI to get from it the PF +
> 'admin_queue' context and will check internally that all current 5 legacy
> commands are supported.
> 
> Yishai

Yes, makes sense.

-- 
MST

