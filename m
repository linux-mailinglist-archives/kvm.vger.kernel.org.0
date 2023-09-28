Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFAF7B2549
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 20:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbjI1Sas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 14:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjI1Sar (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 14:30:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4499D99
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 11:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695925797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xZI9ZT6Cbnc7xrkRt0IgkVcVchJHCYrvkVkiCeePokw=;
        b=KXKNd99eBdV/BxI1+IlKSEFqeEE4Ue2SKLtf2X//ZNcxJYHOh7zFJwKKws4XWqwZ6G9d9M
        F+q6FdbtPx9xJ2Ag8ubQeor/VNVVtB5R62sqgSs3w29eDydQHiTtbR5Djt1KyP6ODhIjwJ
        nu/i/9K9rP2XyZ/4hjDuhDXVj1/K9cU=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-eRStTIGrP5KbHhfqEGBI7A-1; Thu, 28 Sep 2023 14:29:55 -0400
X-MC-Unique: eRStTIGrP5KbHhfqEGBI7A-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3512b13777bso134273315ab.0
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 11:29:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695925795; x=1696530595;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xZI9ZT6Cbnc7xrkRt0IgkVcVchJHCYrvkVkiCeePokw=;
        b=u0aIP6tVHActvACfW9gVF+Dlm4Adq1/V0IRQwiAmlETP3mgnTgukef6tC1ocLwVeHY
         F6BWLmlSDa7r9i+NDxzjIkLTdtxwaynC7uILy28UWO2bmPQSk3YzLROU5+mFZ2aDS02D
         mxpxEf4EFAmpGBoLfGaudvmMf4Yvk2JfBfMK48829rorGfY+xVp53fbksPgSiGV0SXSu
         rrRGA2nDUE8u1bQHJaSIJH9QCruljws73zlF6K344YWkKB5O6nitquVnli6K3nuxQOwc
         o4qwFoGq+q+8f/fuCQS7iJzPulktCMoLzd/embvDWLr88iD2OyouSDLn2L85ij2K02RE
         EQBA==
X-Gm-Message-State: AOJu0YwARR+VtpGWVZZZwCs6auLGj0Z4LYRUvvVGP1xcftmWwz9RgqCu
        2gTSCw/EpdmRIHt+5YagJB5NfQUGEnCTxfw0jSZ7WmVQJi9mDVfEpCSiDFtlbLNUsRFdBgZqOd4
        MLN2QG8spgvXj
X-Received: by 2002:a05:6e02:168e:b0:348:8b42:47d with SMTP id f14-20020a056e02168e00b003488b42047dmr2350281ila.28.1695925794854;
        Thu, 28 Sep 2023 11:29:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHN3T8Hh+6CnoN9AwaH0bpiT8kFrvIAP88ZJnt2pTnQ9GoZFF9h0fDYarbjJZ3VMM6+3wN4Kg==
X-Received: by 2002:a05:6e02:168e:b0:348:8b42:47d with SMTP id f14-20020a056e02168e00b003488b42047dmr2350262ila.28.1695925794477;
        Thu, 28 Sep 2023 11:29:54 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id f15-20020a92cb4f000000b0034e28740e35sm5175503ilq.78.2023.09.28.11.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 11:29:54 -0700 (PDT)
Date:   Thu, 28 Sep 2023 12:29:52 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 0/9] Add chunk mode support for mlx5 driver
Message-ID: <20230928122952.31af1d67.alex.williamson@redhat.com>
In-Reply-To: <20230928110808.GT1642130@unreal>
References: <20230911093856.81910-1-yishaih@nvidia.com>
        <20230920183123.GJ13733@nvidia.com>
        <78298eea-b264-1739-9ded-7d8fa9c7208e@nvidia.com>
        <20230927161023.7e13c06f.alex.williamson@redhat.com>
        <20230928110808.GT1642130@unreal>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Sep 2023 14:08:08 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> On Wed, Sep 27, 2023 at 04:10:23PM -0600, Alex Williamson wrote:
> > On Wed, 27 Sep 2023 13:59:06 +0300
> > Yishai Hadas <yishaih@nvidia.com> wrote:
> >   
> > > On 20/09/2023 21:31, Jason Gunthorpe wrote:  
> > > > On Mon, Sep 11, 2023 at 12:38:47PM +0300, Yishai Hadas wrote:    
> > > >> This series adds 'chunk mode' support for mlx5 driver upon the migration
> > > >> flow.
> > > >>
> > > >> Before this series, we were limited to 4GB state size, as of the 4 bytes
> > > >> max value based on the device specification for the query/save/load
> > > >> commands.
> > > >>
> > > >> Once the device supports 'chunk mode' the driver can support state size
> > > >> which is larger than 4GB.
> > > >>
> > > >> In that case, the device has the capability to split a single image to
> > > >> multiple chunks as long as the software provides a buffer in the minimum
> > > >> size reported by the device.
> > > >>
> > > >> The driver should query for the minimum buffer size required using
> > > >> QUERY_VHCA_MIGRATION_STATE command with the 'chunk' bit set in its
> > > >> input, in that case, the output will include both the minimum buffer
> > > >> size and also the remaining total size to be reported/used where it will
> > > >> be applicable.
> > > >>
> > > >> Upon chunk mode, there may be multiple images that will be read from the
> > > >> device upon STOP_COPY. The driver will read ahead from the firmware the
> > > >> full state in small/optimized chunks while letting QEMU/user space read
> > > >> in parallel the available data.
> > > >>
> > > >> The chunk buffer size is picked up based on the minimum size that
> > > >> firmware requires, the total full size and some max value in the driver
> > > >> code which was set to 8MB to achieve some optimized downtime in the
> > > >> general case.
> > > >>
> > > >> With that series in place, we could migrate successfully a device state
> > > >> with a larger size than 4GB, while even improving the downtime in some
> > > >> scenarios.
> > > >>
> > > >> Note:
> > > >> As the first patch should go to net/mlx5 we may need to send it as a
> > > >> pull request format to VFIO to avoid conflicts before acceptance.
> > > >>
> > > >> Yishai
> > > >>
> > > >> Yishai Hadas (9):
> > > >>    net/mlx5: Introduce ifc bits for migration in a chunk mode
> > > >>    vfio/mlx5: Wake up the reader post of disabling the SAVING migration
> > > >>      file
> > > >>    vfio/mlx5: Refactor the SAVE callback to activate a work only upon an
> > > >>      error
> > > >>    vfio/mlx5: Enable querying state size which is > 4GB
> > > >>    vfio/mlx5: Rename some stuff to match chunk mode
> > > >>    vfio/mlx5: Pre-allocate chunks for the STOP_COPY phase
> > > >>    vfio/mlx5: Add support for SAVING in chunk mode
> > > >>    vfio/mlx5: Add support for READING in chunk mode
> > > >>    vfio/mlx5: Activate the chunk mode functionality    
> > > > I didn't check in great depth but this looks OK to me
> > > >
> > > > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>    
> > > 
> > > Thanks Jason
> > >   
> > > >
> > > > I think this is a good design to start motivating more qmeu
> > > > improvements, eg using io_uring as we could go further in the driver
> > > > to optimize with that kind of support.
> > > >
> > > > Jason    
> > > 
> > > Alex,
> > > 
> > > Can we move forward with the series and send a PR for the first patch 
> > > that needs to go also to net/mlx5 ?  
> > 
> > Yeah, I don't spot any issues with it either.  Thanks,  
> 
> Hi Alex,
> 
> I uploaded the first patch to shared branch, can you please pull it?
> https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=mlx5-vfio

Yep, got it.  Thanks.

Yishai, were you planning to resend the remainder or do you just want
me to pull 2-9 from this series?  Thanks,

Alex

