Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD93E7B0EC9
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 00:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjI0WLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 18:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjI0WLW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 18:11:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2434FB
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 15:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695852629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R9iI6aitaK8wnBwec9NLhgPYuNdDj2OC/qEBurzsj6w=;
        b=bFmJt3Yy6c0YudPUt1XTrPRLAkbvnvpU4cCA1nwbK/X00sabOYyGvcZeT3djg3Wjb5W7nz
        Ifly9PkfqDFNMIYqgu+n4TOMJlKkv/K41y47Fbsuj+HK/T1Ebzl+mRu2c2wRwUIzmq3eee
        uk9TQnY+F8nDngG+u9NrExoLCr7tWX0=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-112-rrkXZ0AWOVCDkcdVaWQLJg-1; Wed, 27 Sep 2023 18:10:27 -0400
X-MC-Unique: rrkXZ0AWOVCDkcdVaWQLJg-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-79fb8c243adso1258935239f.3
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 15:10:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695852626; x=1696457426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R9iI6aitaK8wnBwec9NLhgPYuNdDj2OC/qEBurzsj6w=;
        b=EcCSXbmRne3lLKlYFJeyyOPVwQCsZItlDeRs8P6p+Y+aPqb2TyGhidG9/XD5Tz3tnV
         uNN5YmaJRuBdYtCJsq1LwSRLlLdk77Uq0DaPo8JBWCwSdbcxUmXPfumhxuzWHsZmrQyF
         f1fXEcS3NkOTyvtxTsAQgBxMtR/xGdmFDjDSG9cuZEXDA9srxePgVINdW2iCaftOSqGk
         dKhzslAnDiyHNTangGo91GaKQFsJgIR60kt9z/m+2LUdkFkIfU6yM5p/l6ddghMseRkL
         xDjQPhpowPezwqI7oaAG2fsSd67T0RdabEk8ronJUDyfhBGbiTdZJVP6BIF5fTRpbiPf
         vgDg==
X-Gm-Message-State: AOJu0YwGzX/h0aNVlLoaRJ2xTl4UQPMiMrftKfHc7btz5foz7+xD5cBH
        SsOY2LyusHc0VnPb8sqAVC+FAyb28c9Ip/4uZTm4caTcmLGjqPF56Q1r6QMUoRC+Ob3d799mKlB
        qTi7Wj77JM/+8GfirZ5jW
X-Received: by 2002:a6b:d002:0:b0:792:9ace:f7ba with SMTP id x2-20020a6bd002000000b007929acef7bamr2980329ioa.11.1695852626074;
        Wed, 27 Sep 2023 15:10:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpnr6YUXldGOLp6Xuco2aiCp6CDkPaeC613WVlNhKuMjB6qyecrW6rljhtDAG4m2s53cg58Q==
X-Received: by 2002:a6b:d002:0:b0:792:9ace:f7ba with SMTP id x2-20020a6bd002000000b007929acef7bamr2980317ioa.11.1695852625812;
        Wed, 27 Sep 2023 15:10:25 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id f13-20020a056638022d00b0042b2959e6dcsm4263427jaq.87.2023.09.27.15.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 15:10:24 -0700 (PDT)
Date:   Wed, 27 Sep 2023 16:10:23 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, <kvm@vger.kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH vfio 0/9] Add chunk mode support for mlx5 driver
Message-ID: <20230927161023.7e13c06f.alex.williamson@redhat.com>
In-Reply-To: <78298eea-b264-1739-9ded-7d8fa9c7208e@nvidia.com>
References: <20230911093856.81910-1-yishaih@nvidia.com>
        <20230920183123.GJ13733@nvidia.com>
        <78298eea-b264-1739-9ded-7d8fa9c7208e@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 Sep 2023 13:59:06 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 20/09/2023 21:31, Jason Gunthorpe wrote:
> > On Mon, Sep 11, 2023 at 12:38:47PM +0300, Yishai Hadas wrote:  
> >> This series adds 'chunk mode' support for mlx5 driver upon the migration
> >> flow.
> >>
> >> Before this series, we were limited to 4GB state size, as of the 4 bytes
> >> max value based on the device specification for the query/save/load
> >> commands.
> >>
> >> Once the device supports 'chunk mode' the driver can support state size
> >> which is larger than 4GB.
> >>
> >> In that case, the device has the capability to split a single image to
> >> multiple chunks as long as the software provides a buffer in the minimum
> >> size reported by the device.
> >>
> >> The driver should query for the minimum buffer size required using
> >> QUERY_VHCA_MIGRATION_STATE command with the 'chunk' bit set in its
> >> input, in that case, the output will include both the minimum buffer
> >> size and also the remaining total size to be reported/used where it will
> >> be applicable.
> >>
> >> Upon chunk mode, there may be multiple images that will be read from the
> >> device upon STOP_COPY. The driver will read ahead from the firmware the
> >> full state in small/optimized chunks while letting QEMU/user space read
> >> in parallel the available data.
> >>
> >> The chunk buffer size is picked up based on the minimum size that
> >> firmware requires, the total full size and some max value in the driver
> >> code which was set to 8MB to achieve some optimized downtime in the
> >> general case.
> >>
> >> With that series in place, we could migrate successfully a device state
> >> with a larger size than 4GB, while even improving the downtime in some
> >> scenarios.
> >>
> >> Note:
> >> As the first patch should go to net/mlx5 we may need to send it as a
> >> pull request format to VFIO to avoid conflicts before acceptance.
> >>
> >> Yishai
> >>
> >> Yishai Hadas (9):
> >>    net/mlx5: Introduce ifc bits for migration in a chunk mode
> >>    vfio/mlx5: Wake up the reader post of disabling the SAVING migration
> >>      file
> >>    vfio/mlx5: Refactor the SAVE callback to activate a work only upon an
> >>      error
> >>    vfio/mlx5: Enable querying state size which is > 4GB
> >>    vfio/mlx5: Rename some stuff to match chunk mode
> >>    vfio/mlx5: Pre-allocate chunks for the STOP_COPY phase
> >>    vfio/mlx5: Add support for SAVING in chunk mode
> >>    vfio/mlx5: Add support for READING in chunk mode
> >>    vfio/mlx5: Activate the chunk mode functionality  
> > I didn't check in great depth but this looks OK to me
> >
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>  
> 
> Thanks Jason
> 
> >
> > I think this is a good design to start motivating more qmeu
> > improvements, eg using io_uring as we could go further in the driver
> > to optimize with that kind of support.
> >
> > Jason  
> 
> Alex,
> 
> Can we move forward with the series and send a PR for the first patch 
> that needs to go also to net/mlx5 ?

Yeah, I don't spot any issues with it either.  Thanks,

Alex

