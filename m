Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8588A7AB50C
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 17:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbjIVPq1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 11:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjIVPqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 11:46:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D2B100
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 08:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695397531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=24e0MTM9Ea72ehbm0l01A6havDY/UYoKOi3aCHWehJU=;
        b=U6iHQhI+IDaEi9b1+pt0MJB7ud3ncpZR7k+rFyBdjYH/UPHJWS33pcOUkwIrzFgnbmNq5i
        uvm6RssvAIY+Yxi4x9omA0WiigCnAzKP68pPlPsiFn63r1falI41dF8ZlDtanMEeIy1B+G
        sezDDBQx61I7XzFK9WoeULrF2DE3Pi4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-y38dCESBOdKa1TKCfw9PRg-1; Fri, 22 Sep 2023 11:45:28 -0400
X-MC-Unique: y38dCESBOdKa1TKCfw9PRg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3172a94b274so1435832f8f.0
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 08:45:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695397527; x=1696002327;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=24e0MTM9Ea72ehbm0l01A6havDY/UYoKOi3aCHWehJU=;
        b=ovEq9KCEHk4PCQE4xCIu4C6pKWxXvNQ6M9VWtRr2GCaGhC/BpRTbcsNyzrW9pcvP/t
         uSZhGi78+s5w6ZHyPLrGO2VTgNZbNaSV5OVChG6Iy4+/hURa5KRVmEx4XpzB5qYp8z0U
         QScHpJfkq62SN83agB9w1TcxU8bayoAW8maGreQ3m4ACmGpNdu8qNBgcTwL5QPMe09cF
         WgY2nyYxtu59/vNFzcx7sRfOh/12tw215MAOaoVP5f5+CtHDcY6T6Ni0r98ybNf2JT6C
         dZMPNL+xeBjq/8mkio/xvCG8JRk2U590CERFNHtxZcSQcJrWmRM8DwwxGzyOG+58tieV
         2/GQ==
X-Gm-Message-State: AOJu0YyXWNHCspdDyMXBQVV+gRnfi11rz2zdCwkfWAZoNMVlnHlHul4c
        McbXR/Q1ABCT70IhRwfPoPM29kTPyLe3pycjEPIqbFccTp3BNBDfPpEqGs1GJ1IFW06bek1ZZab
        UZPmxLxX+j6K2
X-Received: by 2002:a5d:404d:0:b0:31f:e534:2d6f with SMTP id w13-20020a5d404d000000b0031fe5342d6fmr58815wrp.11.1695397527121;
        Fri, 22 Sep 2023 08:45:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHeBusEZRXoLGIDhzmsM8uH+6ZQqUREFrCewPrkgBuuX5Vrg5rtomLqzp/AHoeDKj4EWQLrgA==
X-Received: by 2002:a5d:404d:0:b0:31f:e534:2d6f with SMTP id w13-20020a5d404d000000b0031fe5342d6fmr58789wrp.11.1695397526760;
        Fri, 22 Sep 2023 08:45:26 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id bl19-20020a170906c25300b0099bc8db97bcsm2854718ejb.131.2023.09.22.08.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Sep 2023 08:45:25 -0700 (PDT)
Date:   Fri, 22 Sep 2023 11:45:21 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230922114122-mutt-send-email-mst@kernel.org>
References: <20230921131035-mutt-send-email-mst@kernel.org>
 <20230921174450.GT13733@nvidia.com>
 <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <20230921155834-mutt-send-email-mst@kernel.org>
 <20230921224836.GD13733@nvidia.com>
 <20230922011918-mutt-send-email-mst@kernel.org>
 <20230922122328.GO13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230922122328.GO13733@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 09:23:28AM -0300, Jason Gunthorpe wrote:
> On Fri, Sep 22, 2023 at 05:47:23AM -0400, Michael S. Tsirkin wrote:
> 
> > it will require maintainance effort when virtio changes are made.  For
> > example it pokes at the device state - I don't see specific races right
> > now but in the past we did e.g. reset the device to recover from errors
> > and we might start doing it again.
> > 
> > If more of the logic is under virtio directory where we'll remember
> > to keep it in loop, and will be able to reuse it from vdpa
> > down the road, I would be more sympathetic.
> 
> This is inevitable, the VFIO live migration driver will need all this
> infrastructure too.
> 
> Jason
>  

I am not sure what you are saying and what is inevitable.
VDPA for sure will want live migration support.  I am not at all
sympathetic to efforts that want to duplicate that support for virtio
under VFIO. Put it in a library under the virtio directory,
with a sane will documented interface.
I don't maintain VFIO and Alex can merge what he wants,
but I won't merge patches that export virtio internals in a way
that will make virtio maintainance harder.

-- 
MST

