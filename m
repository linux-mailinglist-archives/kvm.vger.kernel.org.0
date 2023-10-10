Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C6D7C415E
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 22:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbjJJUkE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 16:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjJJUkD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 16:40:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E5391
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 13:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696970354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bu6+g3n9/dR1bkl/BLL4uvtKzuJH78kbq1CDUX/csIY=;
        b=emGcv7fSClMArtvuSwpP0iDlgE5SLwdW7w4rfjO8xjcyGA+JfBOd0PvrdoqzRG0ONjFQZ7
        24UlPmBLzY0J4/sqsrnHmq2cxUnMNjEZElIqSxQqwcLeTT4xEKalE1mnfdZnmUxVSAp+DX
        B5bXFUkzX2F/ZmeBqWjBb6lgKMb2RpE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-1-xkHccFlLPgKvlHfTYH1nyA-1; Tue, 10 Oct 2023 16:38:58 -0400
X-MC-Unique: xkHccFlLPgKvlHfTYH1nyA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-30932d15a30so4145767f8f.1
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 13:38:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970337; x=1697575137;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bu6+g3n9/dR1bkl/BLL4uvtKzuJH78kbq1CDUX/csIY=;
        b=Ky8GYWX2Q4OwJsnw5lbTc67g5V/QTFLVH2gCDF4A2IcnzXC2Q5/mBB/EVWXRFzUySR
         E1HZtXfUlwpas+axjmd7G/1Tjzo+ViocJJpaHIHO1XYGCFEXtnmR7bJBEYFaJVYMaPx4
         qqZUI1H3RsV+CzH8KieLCPwhLkWuiL3oe8COtrVAsIzD2I5d/pWastMiIrKVD6A3Ae37
         Ln+oaWfIK7fIpDZ/cc1NhIONrQ9l1XZq/+cEuk2lYv2TW/5D4U/sqGfhJ47dvOfdzGoO
         P1nvWaQFo6JAodWGO8Dhl/L0BvVfdqYvETW4nf6qhOLDgUUT1tYKa4/QKDPKOF4ZM5gV
         8xgQ==
X-Gm-Message-State: AOJu0YzAQzDt4Xk+tJvZpqew61Ptzqk2SP8YI96MSKHObjPF44oO+4C6
        EQbZHUpnJB7c+3wTBsFzMomQjRvcmpDWkVr7rG5C1RC6SIjfpE5Xbx+SY5LVLVG3hEBZQpr5boA
        GuDwpubARKdos
X-Received: by 2002:a5d:44c6:0:b0:321:6486:d008 with SMTP id z6-20020a5d44c6000000b003216486d008mr17597522wrr.25.1696970337176;
        Tue, 10 Oct 2023 13:38:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6TNYTU5dVHOcXiM2qQJk/9jz9aLNe0cQkVtwbjtE9hTrDS36LUD9fwll79vvg+2CTf4B2Xg==
X-Received: by 2002:a5d:44c6:0:b0:321:6486:d008 with SMTP id z6-20020a5d44c6000000b003216486d008mr17597511wrr.25.1696970336822;
        Tue, 10 Oct 2023 13:38:56 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73d2:bf00:e379:826:5137:6b23])
        by smtp.gmail.com with ESMTPSA id q15-20020a7bce8f000000b00405391f485fsm14946271wmj.41.2023.10.10.13.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:38:56 -0700 (PDT)
Date:   Tue, 10 Oct 2023 16:38:53 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231010163741-mutt-send-email-mst@kernel.org>
References: <20231010131031.GJ3952@nvidia.com>
 <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <20231010155937.GN3952@nvidia.com>
 <20231010120158-mutt-send-email-mst@kernel.org>
 <20231010160712.GO3952@nvidia.com>
 <PH0PR12MB548172E68035F25C47918D92DCCDA@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB548172E68035F25C47918D92DCCDA@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 04:21:15PM +0000, Parav Pandit wrote:
> 
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, October 10, 2023 9:37 PM
> > 
> > On Tue, Oct 10, 2023 at 12:03:29PM -0400, Michael S. Tsirkin wrote:
> > > On Tue, Oct 10, 2023 at 12:59:37PM -0300, Jason Gunthorpe wrote:
> > > > On Tue, Oct 10, 2023 at 11:14:56AM -0400, Michael S. Tsirkin wrote:
> > > >
> > > > > I suggest 3 but call it on the VF. commands will switch to PF
> > > > > internally as needed. For example, intel might be interested in
> > > > > exposing admin commands through a memory BAR of VF itself.
> 
> If in the future if one does admin command on the VF memory BAR, there is no need of cast either.
> vfio-virtio-pci driver can do on the pci vf device directly.

this is why I want the API to get the VF pci device as a parameter.
I don't get what is cyclic about it, yet.

> (though per VF memory registers would be anti-scale design for real hw; to discuss in other forum).

up to hardware vendor really.

