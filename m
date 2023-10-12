Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF797C6B92
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 12:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343795AbjJLKxi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 06:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235665AbjJLKxh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 06:53:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F5694
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 03:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697107969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WCc9mHbY2JlIHfp5VOa+l2dSwNloOuO6MCxzrGGXt3M=;
        b=hi9u5ioUIuLoP8YX55QHfILRGzOfcUDfWq+2WumE271KiXLiZYgA/GzTRD9o6Y+Vo+ojIx
        IDE+5jaRJMkHR6Eu0GIOvNXvP0GlvCtvQQ1Xlpbv8oS4dEwhw50yDz9z+/idVcrEEAFlxf
        Xo3zVqSBwJBENP32Iu4yh4sI8JQrhuw=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-mB2sN3A_OEiCNPxsOs2rXA-1; Thu, 12 Oct 2023 06:52:48 -0400
X-MC-Unique: mB2sN3A_OEiCNPxsOs2rXA-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5043c463bf9so878228e87.0
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 03:52:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697107966; x=1697712766;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WCc9mHbY2JlIHfp5VOa+l2dSwNloOuO6MCxzrGGXt3M=;
        b=Zm+dLDAgfyraFlx1OgreZ3Jk62rMQA/kC4d8hM1qzHrAvSymqHqwQ5zg/w8thJPcH/
         T3ykCmA5BA0/2Y65jKCPwDKMUV4suElvC3v77NmS6fg/ofsAW0q8r1kvT1oSQx/vfzN7
         rhMq9NM2580xGtd0bgJ0UNVKaZGE+b7AVZ6Us+enqVYsXgax5/eInaU2pQ72TEVZLtP7
         5+Jv2iFi+K5JJ3Y/gkJJnQO9qHOEe022A1KKt2eE/Wow2dORnXlnTpd7h21M4s5qkgto
         5YDPr2PR1C+2MyrjDgviP7StMVdC/2QMl2Qyr7v3j5/jfvaFk+OKr1MJqawVyi2Yk6MM
         laew==
X-Gm-Message-State: AOJu0YwIVukuaKwERKaqfKKS8GMynoPLZJz14VuMpFMQYlfKBe7yV8SX
        LOvwV2g99epcn0m2OT2n/k4Sd52PjjFcaoAMhC7IIPJNSMGUeD1uOYNf/skEStqLezz89doB6Wg
        EONfrx/ny0avXsVAf++oB
X-Received: by 2002:a05:6512:ba6:b0:503:2877:67d3 with SMTP id b38-20020a0565120ba600b00503287767d3mr23005974lfv.67.1697107966264;
        Thu, 12 Oct 2023 03:52:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzbTERUF8xEQetm4cgeqjsxy3FbcXouW9Y3QzwsFZi3a1d6dHvi0j5cXFUujnC5oFhbcHqgw==
X-Received: by 2002:a05:6512:ba6:b0:503:2877:67d3 with SMTP id b38-20020a0565120ba600b00503287767d3mr23005953lfv.67.1697107965850;
        Thu, 12 Oct 2023 03:52:45 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73d2:bf00:e379:826:5137:6b23])
        by smtp.gmail.com with ESMTPSA id c4-20020a5d4cc4000000b003247d3e5d99sm17990316wrt.55.2023.10.12.03.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 03:52:45 -0700 (PDT)
Date:   Thu, 12 Oct 2023 06:52:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
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
Message-ID: <20231012065008-mutt-send-email-mst@kernel.org>
References: <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <20230921155834-mutt-send-email-mst@kernel.org>
 <CACGkMEvD+cTyRtax7_7TBNECQcGPcsziK+jCBgZcLJuETbyjYw@mail.gmail.com>
 <20230922122246.GN13733@nvidia.com>
 <PH0PR12MB548127753F25C45B7EFF203DDCFFA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEuX5HJVBOw9E+skr=K=QzH3oyHK8gk-r0hAvi6Wm7OA7Q@mail.gmail.com>
 <PH0PR12MB5481ED78F7467EEB0740847EDCFCA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20230925141713-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481AF4B2F61E96794D7ABC7DCC3A@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB5481AF4B2F61E96794D7ABC7DCC3A@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023 at 03:45:36AM +0000, Parav Pandit wrote:
> 
> 
> > From: Michael S. Tsirkin <mst@redhat.com>
> > Sent: Tuesday, September 26, 2023 12:06 AM
> 
> > One can thinkably do that wait in hardware, though. Just defer completion until
> > read is done.
> >
> Once OASIS does such new interface and if some hw vendor _actually_ wants to do such complex hw, may be vfio driver can adopt to it.

The reset behaviour I describe is already in the spec. What else do you
want OASIS to standardize? Virtio currently is just a register map it
does not yet include suggestions on how exactly do pci express
transactions look. You feel we should add that?

-- 
MST

