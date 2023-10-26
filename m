Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02B17D8253
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 14:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjJZMN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 08:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjJZMN2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 08:13:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E90CB9
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 05:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698322359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sw0ciuKp3G615G2MMkLr4CNXXMI+u1W0xGXFFb8/g9M=;
        b=S4yAqejp9/2hIbp8Ra1IoshAnrrcDWqrLrVH7ul5C3F09iBwCJeDrpCoRJZlchrsOIlzA/
        V67g0lmyx1hZ6m8PeUDLvdiaG1GFvvv7A/dVgd+s3ivh9q6xcbWQ2FRh+v5srPF6qAG75h
        2aMElVzWfzlsizVuKWH/QTUJ9Lyy86s=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-8M5ZqAo6PRuvPq2yPGiZbA-1; Thu, 26 Oct 2023 08:12:36 -0400
X-MC-Unique: 8M5ZqAo6PRuvPq2yPGiZbA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9b2cf504e3aso58914266b.2
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 05:12:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698322355; x=1698927155;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sw0ciuKp3G615G2MMkLr4CNXXMI+u1W0xGXFFb8/g9M=;
        b=PcvoaSdNRlLQw2oGaA5YPnYVgsg3lrn9KGKq5UaOfhlrR5bYvYdqQ/ZccRmRjxqgIQ
         Mhcl3Bj8hGaLQ5u2OzKhbXRh1aFWpI3jxSgafTVd2i7ggn3AHZtjJUGtDJP2Jc+40kOr
         1x0FAMoDNTPEHAa9ea46xoYgs26Z5hJWthy4fSHSwYe5k77l8KErIxb742W8dIptnw/F
         vKXBIDhb9CBlavGX1IxQ5/ZF29s/xuHHE5Tz9hfhItUab+3ZH0/TGoCgB83lYro/MNE0
         +icp+eQgo6yOpGMU/mq6Axn3bvIaRjmvMUcBtJ3EGw0q95d2FPuGOxOx5I2AsQvgG1+H
         GblA==
X-Gm-Message-State: AOJu0YzsYXDF67+7N0o6Hkk3RU3JYGtcPlEDk/xRQ15WrIDoegxI5zrA
        Orq9vtWMKnA2pnsfRadTvR98BPK5eiwJBHOaoyGb7g/l2VK+lvlPIN5sGT/Sc7znTqODwqu3DvO
        0/LYrhBNUH8EQ
X-Received: by 2002:a17:906:c155:b0:9be:3c7e:7f38 with SMTP id dp21-20020a170906c15500b009be3c7e7f38mr14812219ejc.10.1698322355269;
        Thu, 26 Oct 2023 05:12:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFHVa3xvaMnJebgjah5302uh7+94jbODNYbjHlprQ/tZEJoXbNESX/f6UNZCk2l/eXC+oRQSQ==
X-Received: by 2002:a17:906:c155:b0:9be:3c7e:7f38 with SMTP id dp21-20020a170906c15500b009be3c7e7f38mr14812195ejc.10.1698322354926;
        Thu, 26 Oct 2023 05:12:34 -0700 (PDT)
Received: from redhat.com ([2a02:14f:17b:37eb:8e1f:4b3b:22c7:7722])
        by smtp.gmail.com with ESMTPSA id g1-20020a1709063b0100b0099b8234a9fesm11560164ejf.1.2023.10.26.05.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Oct 2023 05:12:34 -0700 (PDT)
Date:   Thu, 26 Oct 2023 08:12:25 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, jasowang@redhat.com,
        jgg@nvidia.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, si-wei.liu@oracle.com,
        leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20231026081033-mutt-send-email-mst@kernel.org>
References: <20231017134217.82497-1-yishaih@nvidia.com>
 <20231017134217.82497-10-yishaih@nvidia.com>
 <20231024135713.360c2980.alex.williamson@redhat.com>
 <d6c720a0-1575-45b7-b96d-03a916310699@nvidia.com>
 <20231025131328.407a60a3.alex.williamson@redhat.com>
 <a55540a1-b61c-417b-97a5-567cfc660ce6@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55540a1-b61c-417b-97a5-567cfc660ce6@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 26, 2023 at 03:08:12PM +0300, Yishai Hadas wrote:
> > > Makes sense ?
> > So do I understand correctly that virtio dictates the subsystem device
> > ID for all subsystem vendor IDs that implement a legacy virtio
> > interface?  Ok, but this device didn't actually implement a legacy
> > virtio interface.  The device itself is not tranistional, we're imposing
> > an emulated transitional interface onto it.  So did the subsystem vendor
> > agree to have their subsystem device ID managed by the virtio committee
> > or might we create conflicts?  I imagine we know we don't have a
> > conflict if we also virtualize the subsystem vendor ID.
> > 
> The non transitional net device in the virtio spec defined as the below
> tuple.
> T_A: VID=0x1AF4, DID=0x1040, Subsys_VID=FOO, Subsys_DID=0x40.
> 
> And transitional net device in the virtio spec for a vendor FOO is defined
> as:
> T_B: VID=0x1AF4,DID=0x1000,Subsys_VID=FOO, subsys_DID=0x1
> 
> This driver is converting T_A to T_B, which both are defined by the virtio
> spec.
> Hence, it does not conflict for the subsystem vendor, it is fine.

You are talking about legacy guests, what 1.X spec says about them
is much less important than what guests actually do.
Check the INF of the open source windows drivers and linux code, at least.

-- 
MST

