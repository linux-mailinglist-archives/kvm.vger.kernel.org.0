Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA46A7D858F
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 17:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345414AbjJZPHQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 11:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345388AbjJZPHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 11:07:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32598187
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 08:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698332779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V0KZ7H5+hQgT1kPSrimPTzl67XPfDZ+0EP0kffhfYTM=;
        b=d1wHnai6oh2BgDQzAiNYt9+PmMP3J/Wggcw8+v9TQ2VI32rIJZ1yFDi7w4QqTRaZUglknL
        ZuZROAV8yGh8et4uJpk/7Zx9By7xK4EtFliF8pAl8L6XGHijIejayJTST1VB44Ykq+vwDb
        9LqUqjEpIn/7LPPmnvu/lL2IOGEMKek=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-M4_cwIuIPTGj0FObhXMIrQ-1; Thu, 26 Oct 2023 11:06:15 -0400
X-MC-Unique: M4_cwIuIPTGj0FObhXMIrQ-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9b65c46bca8so71842466b.1
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 08:06:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698332774; x=1698937574;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V0KZ7H5+hQgT1kPSrimPTzl67XPfDZ+0EP0kffhfYTM=;
        b=kzeIWr0e8R59MuF4huMZTMr2viS4TiUp87TIyMqxG60vGvpOi2ar5ibiH3KDpkIgAj
         nAzUW7xFMtrcQPuCjL2H4TppOIPg7WGMZmAsJ5YAt5stoLk6dJhyfzVJu8vc2uda1ZCz
         wt6u09mTWxQ+VzqYS38BpsPxj1Tj4opsehyVkOT5OPQ7lMQJ6HSF76g5V3pStPbeUDsC
         y/BLAy9xmo0HuMhSEs8O9PELMKyvpGqWQEgmYLVieqCr/HDklA9rYj7G56hzECjjeg1+
         qIDyuH0vuFBBWVe8TUENuLYzlpDvLJT7FiHSUw2Jqo9i1RjE5fbDPgWyWsdmLTYSNyel
         E8qw==
X-Gm-Message-State: AOJu0YxsW1Iz2YHoWeGd/P4Hadl9e3gdqVxDvkjtjlspB9c9Xq+qxKub
        7j4AqxkTKziZkPs2Ebz9sYFWsqePc9wu6lqCmIMNsodIP807v4h+/wdfogjf+MDEfWRSUKWBfw6
        xiEiLCjwxA/G1
X-Received: by 2002:a17:907:9451:b0:9be:cdca:dadb with SMTP id dl17-20020a170907945100b009becdcadadbmr13567072ejc.69.1698332774576;
        Thu, 26 Oct 2023 08:06:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE7eML0C7TXRz+am800g23BqKGYJs2pXWaQRh20fik802qzDy3vMIor47Fqn5lTnBAJjrL26g==
X-Received: by 2002:a17:907:9451:b0:9be:cdca:dadb with SMTP id dl17-20020a170907945100b009becdcadadbmr13567040ejc.69.1698332774255;
        Thu, 26 Oct 2023 08:06:14 -0700 (PDT)
Received: from redhat.com ([2a02:14f:17b:37eb:8e1f:4b3b:22c7:7722])
        by smtp.gmail.com with ESMTPSA id vl9-20020a170907b60900b00989828a42e8sm11676724ejc.154.2023.10.26.08.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Oct 2023 08:06:13 -0700 (PDT)
Date:   Thu, 26 Oct 2023 11:06:06 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH V1 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20231026110426-mutt-send-email-mst@kernel.org>
References: <20231017134217.82497-1-yishaih@nvidia.com>
 <20231017134217.82497-10-yishaih@nvidia.com>
 <20231024135713.360c2980.alex.williamson@redhat.com>
 <d6c720a0-1575-45b7-b96d-03a916310699@nvidia.com>
 <20231025131328.407a60a3.alex.williamson@redhat.com>
 <a55540a1-b61c-417b-97a5-567cfc660ce6@nvidia.com>
 <20231026081033-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481E1AF869C1296B987A34BDCDDA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20231026091459-mutt-send-email-mst@kernel.org>
 <PH0PR12MB548167D2A92F3D10E4F02E93DCDDA@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB548167D2A92F3D10E4F02E93DCDDA@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 26, 2023 at 01:28:18PM +0000, Parav Pandit wrote:
> 
> > From: Michael S. Tsirkin <mst@redhat.com>
> > Sent: Thursday, October 26, 2023 6:45 PM
> 
> > > Followed by an open coded driver check for 0x1000 to 0x103f range.
> > > Do you mean windows driver expects specific subsystem vendor id of 0x1af4?
> > 
> > Look it up, it's open source.
> 
> Those are not OS inbox drivers anyway.
> :)

Does not matter at all if guest has drivers installed.
Either you worry about legacy guests or not.


> The current vfio driver is following the virtio spec based on legacy spec, 1.x spec following the transitional device sections.
> There is no need to do something out of spec at this point.

legacy spec wasn't maintained properly, drivers diverged sometimes
significantly. what matters is installed base.

-- 
MST

