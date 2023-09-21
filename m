Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83BB57A9E4A
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjIUT76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 15:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbjIUT7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 15:59:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2908846DDC
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695317055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A/UaA3dwsjl/5n39ZInDe8A7bNv9U9kL0fxecQB4u1g=;
        b=AwtkSQyr5dmgV2dRXwKtdgryW0l72rgfQvOsvkZS9D0jtOISQHeEue6a1bNmyZ4KQWkM4Y
        1+4rUJBWukkXMdGQCQ2pLquSOZMYD6KiD/7NI9AeV18h12Z2nUwama7kkrFbIwpc8YB0DA
        zN3PXg4acCqA/HHXdf18M7nJiMigMX8=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-82-YaChpToDNTmp2kev7xaV0Q-1; Thu, 21 Sep 2023 13:24:13 -0400
X-MC-Unique: YaChpToDNTmp2kev7xaV0Q-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2bffd454256so16854351fa.1
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:24:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695317052; x=1695921852;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A/UaA3dwsjl/5n39ZInDe8A7bNv9U9kL0fxecQB4u1g=;
        b=prQSWbSkh//OezB+JlBEWuuvZGA/OLycNpj/5S/XbyIT0oOS1PFgA0V+QfLiBmRCUg
         M7Ho7DevDwmMVWmV4vmXTnECqpRL/lbJz8oVpWxgtuPvBfkAQYI4VAtaFwSNnFLMk4MG
         hKK1s6qEh7w1TqUW3RlQl4q2Lv4Ebxv2M9BLqgwY1AgmnHwpFUM3vbXrn3aUHaL5H+OO
         0fagnLxJRkkUqVUjo3nk1tOSbxe8XrzYvwCyW1pM7hifEn499aLVXpCJ49FnuS++6R1O
         /fQjYX+DCNcVPUtDAp48PStkwWJNrMA7PM2aNjfojjQadnjXdfE7MywimwDBRGBiLUVi
         /AMQ==
X-Gm-Message-State: AOJu0Yye42+6Zd0opxABaQuCZ1Nw/rDfOh8uEUsKKimZpNCLyhyerDek
        cEDJiglmG1pRnnpZKf5YSXhuQ8lHW3l0Xg8CdPybhg5AcXDumfUCuOoNKB9iRz03EdqyCHDuF/k
        Z2z7spGpjTzab
X-Received: by 2002:a2e:7a15:0:b0:2c0:18b8:9656 with SMTP id v21-20020a2e7a15000000b002c018b89656mr5417401ljc.24.1695317052275;
        Thu, 21 Sep 2023 10:24:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGuyY22Pu4JJbcepqQfut19xS8d93zqlgBqv3AjWx+BgTUEs/dbdgGpZwmKYhhDDtmusapHPw==
X-Received: by 2002:a2e:7a15:0:b0:2c0:18b8:9656 with SMTP id v21-20020a2e7a15000000b002c018b89656mr5417379ljc.24.1695317051939;
        Thu, 21 Sep 2023 10:24:11 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id p26-20020a170906229a00b009ad8338aafasm1380250eja.13.2023.09.21.10.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 10:24:11 -0700 (PDT)
Date:   Thu, 21 Sep 2023 13:24:07 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
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
Message-ID: <20230921132206-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921104350.6bb003ff.alex.williamson@redhat.com>
 <20230921165224.GR13733@nvidia.com>
 <20230921125348-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54813216D57AD82FAC0C10A7DCF8A@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB54813216D57AD82FAC0C10A7DCF8A@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 05:09:04PM +0000, Parav Pandit wrote:
> 
> 
> > From: Michael S. Tsirkin <mst@redhat.com>
> > Sent: Thursday, September 21, 2023 10:31 PM
> 
> > Another question I'm interested in is whether there's actually a performance
> > benefit to using this as compared to just software vhost. I note there's a VM exit
> > on each IO access, so ... perhaps?
> > Would be nice to see some numbers.
> 
> Packet rate and bandwidth are close are only 10% lower than modern device due to the batching of driver notification.
> Bw tested with iperf with one and multiple queues. 
> Packet rate tested with testpmd.

Nice, good to know.  Could you compare this with vdpa with shadow vq
enabled?  That's probably the closest equivalent that needs
no kernel or hardware work.

-- 
MST

