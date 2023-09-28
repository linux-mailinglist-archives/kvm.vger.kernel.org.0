Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90E07B2740
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 23:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbjI1VNq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 17:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbjI1VNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 17:13:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868E7F3
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 14:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695935583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z2gCOlYgch2LXpfWPMKTf9UgRXa18dJRcNkDl7Suz+g=;
        b=gJt4Bh4jNJ/6RoTZq/qG+tVmjB1zDJ1CQMsUrlLAnu0Z1Z9BSWiIHwrP/NJk+sJXPz0vDk
        amtrQJzUq73F57W6YeFqDJdzpdQatuZDPrRcz1Cy80QKFchPfgy3R6cOdpPksOb5P5SdYs
        MnS6B3cnWuTzPSuG/A/y+j4Nh+q66Ok=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-339-YoX94ePHOjayAQBFSOTZYw-1; Thu, 28 Sep 2023 17:13:02 -0400
X-MC-Unique: YoX94ePHOjayAQBFSOTZYw-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-778d823038bso1630328139f.3
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 14:13:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695935581; x=1696540381;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z2gCOlYgch2LXpfWPMKTf9UgRXa18dJRcNkDl7Suz+g=;
        b=u+HRpMLkCK/okiQPgDR0TMj9ev6oj0w4XzztVhx3oAcVSopq3krm7FTahh43Zwa+nV
         Y1gZM5Io8sNKfhSHyM/G81skKMP6mHOo8hy/ahQAT5c6x74ymVQvAlM7gehRXQQRVpTu
         xWvM787xFXVlIcNDzkwJ6MVtKhOKibuuPwEo5tJPeVZCTRUIhlCgdyTC2a0tgXYZTmCU
         55Wc1QJ3JyyGaq9DU67vZhu/GtN3uq1SRF1XDfXHa/BCQeswSfijGv2MfbGVnBVQR9ur
         HkXy8ZLUdmmHHu9zzdWVpf0nM4gkMBXEDbB1Qpj3Gopm/UYhlpVfU0xurnyDuyOfVQ89
         HRIA==
X-Gm-Message-State: AOJu0YxYUkaVcCRx/S6JG1Cin4fJlpTyhwuvsAM5/HBwHJ8yrdjwiUZy
        PwWOrLHbxVd2C9ayrGShqL3fyhFTFcvUJeJjYwmlhRszUo8AiFQtYaNYL8Pus6zpzzQV1q60BjL
        7cow5Zj/wOzBm
X-Received: by 2002:a6b:fe18:0:b0:792:9a1a:228b with SMTP id x24-20020a6bfe18000000b007929a1a228bmr2407543ioh.2.1695935581263;
        Thu, 28 Sep 2023 14:13:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFdFEmIDaQzoh82bnRSnCqOyrvsvagG0v32EZA72T3wZ3J+vJ8M5q9a3RSBOQTuAa7zgy9pDg==
X-Received: by 2002:a6b:fe18:0:b0:792:9a1a:228b with SMTP id x24-20020a6bfe18000000b007929a1a228bmr2407522ioh.2.1695935580952;
        Thu, 28 Sep 2023 14:13:00 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id g2-20020a05663811c200b0042ff466c9bdsm4860789jas.127.2023.09.28.14.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 14:12:59 -0700 (PDT)
Date:   Thu, 28 Sep 2023 15:12:58 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 0/9] Add chunk mode support for mlx5 driver
Message-ID: <20230928151259.776dccfd.alex.williamson@redhat.com>
In-Reply-To: <20230928185102.GA1296942@unreal>
References: <20230911093856.81910-1-yishaih@nvidia.com>
        <20230920183123.GJ13733@nvidia.com>
        <78298eea-b264-1739-9ded-7d8fa9c7208e@nvidia.com>
        <20230927161023.7e13c06f.alex.williamson@redhat.com>
        <20230928110808.GT1642130@unreal>
        <20230928122952.31af1d67.alex.williamson@redhat.com>
        <20230928184222.GV1642130@unreal>
        <20230928124703.0a4d148c.alex.williamson@redhat.com>
        <20230928185102.GA1296942@unreal>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Sep 2023 21:51:02 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> On Thu, Sep 28, 2023 at 12:47:03PM -0600, Alex Williamson wrote:
> > On Thu, 28 Sep 2023 21:42:22 +0300
> > Leon Romanovsky <leon@kernel.org> wrote:
> >   
> > > On Thu, Sep 28, 2023 at 12:29:52PM -0600, Alex Williamson wrote:  
> > > > On Thu, 28 Sep 2023 14:08:08 +0300
> > > > Leon Romanovsky <leon@kernel.org> wrote:
> > > >     
> > > > > On Wed, Sep 27, 2023 at 04:10:23PM -0600, Alex Williamson wrote:    
> > > > > > On Wed, 27 Sep 2023 13:59:06 +0300
> > > > > > Yishai Hadas <yishaih@nvidia.com> wrote:
> > > > > >       
> > > > > > > On 20/09/2023 21:31, Jason Gunthorpe wrote:      
> > > > > > > > On Mon, Sep 11, 2023 at 12:38:47PM +0300, Yishai Hadas wrote:        
> > > > > > > >> This series adds 'chunk mode' support for mlx5 driver upon the migration
> > > > > > > >> flow.
> > > > > > > >>
> > > > > > > >> Before this series, we were limited to 4GB state size, as of the 4 bytes
> > > > > > > >> max value based on the device specification for the query/save/load
> > > > > > > >> commands.
> > > > > > > >>
> > > > > > > >> Once the device supports 'chunk mode' the driver can support state size
> > > > > > > >> which is larger than 4GB.
> > > > > > > >>
> > > > > > > >> In that case, the device has the capability to split a single image to
> > > > > > > >> multiple chunks as long as the software provides a buffer in the minimum
> > > > > > > >> size reported by the device.
> > > > > > > >>
> > > > > > > >> The driver should query for the minimum buffer size required using
> > > > > > > >> QUERY_VHCA_MIGRATION_STATE command with the 'chunk' bit set in its
> > > > > > > >> input, in that case, the output will include both the minimum buffer
> > > > > > > >> size and also the remaining total size to be reported/used where it will
> > > > > > > >> be applicable.
> > > > > > > >>
> > > > > > > >> Upon chunk mode, there may be multiple images that will be read from the
> > > > > > > >> device upon STOP_COPY. The driver will read ahead from the firmware the
> > > > > > > >> full state in small/optimized chunks while letting QEMU/user space read
> > > > > > > >> in parallel the available data.
> > > > > > > >>
> > > > > > > >> The chunk buffer size is picked up based on the minimum size that
> > > > > > > >> firmware requires, the total full size and some max value in the driver
> > > > > > > >> code which was set to 8MB to achieve some optimized downtime in the
> > > > > > > >> general case.
> > > > > > > >>
> > > > > > > >> With that series in place, we could migrate successfully a device state
> > > > > > > >> with a larger size than 4GB, while even improving the downtime in some
> > > > > > > >> scenarios.
> > > > > > > >>
> > > > > > > >> Note:
> > > > > > > >> As the first patch should go to net/mlx5 we may need to send it as a
> > > > > > > >> pull request format to VFIO to avoid conflicts before acceptance.
> > > > > > > >>
> > > > > > > >> Yishai
> > > > > > > >>
> > > > > > > >> Yishai Hadas (9):
> > > > > > > >>    net/mlx5: Introduce ifc bits for migration in a chunk mode
> > > > > > > >>    vfio/mlx5: Wake up the reader post of disabling the SAVING migration
> > > > > > > >>      file
> > > > > > > >>    vfio/mlx5: Refactor the SAVE callback to activate a work only upon an
> > > > > > > >>      error
> > > > > > > >>    vfio/mlx5: Enable querying state size which is > 4GB
> > > > > > > >>    vfio/mlx5: Rename some stuff to match chunk mode
> > > > > > > >>    vfio/mlx5: Pre-allocate chunks for the STOP_COPY phase
> > > > > > > >>    vfio/mlx5: Add support for SAVING in chunk mode
> > > > > > > >>    vfio/mlx5: Add support for READING in chunk mode
> > > > > > > >>    vfio/mlx5: Activate the chunk mode functionality        
> > > > > > > > I didn't check in great depth but this looks OK to me
> > > > > > > >
> > > > > > > > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>        
> > > > > > > 
> > > > > > > Thanks Jason
> > > > > > >       
> > > > > > > >
> > > > > > > > I think this is a good design to start motivating more qmeu
> > > > > > > > improvements, eg using io_uring as we could go further in the driver
> > > > > > > > to optimize with that kind of support.
> > > > > > > >
> > > > > > > > Jason        
> > > > > > > 
> > > > > > > Alex,
> > > > > > > 
> > > > > > > Can we move forward with the series and send a PR for the first patch 
> > > > > > > that needs to go also to net/mlx5 ?      
> > > > > > 
> > > > > > Yeah, I don't spot any issues with it either.  Thanks,      
> > > > > 
> > > > > Hi Alex,
> > > > > 
> > > > > I uploaded the first patch to shared branch, can you please pull it?
> > > > > https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=mlx5-vfio    
> > > > 
> > > > Yep, got it.  Thanks.
> > > > 
> > > > Yishai, were you planning to resend the remainder or do you just want
> > > > me to pull 2-9 from this series?  Thanks,    
> > > 
> > > Just pull, like I did with b4 :)
> > > 
> > > ~/src/b4/b4.sh shazam -l -s https://lore.kernel.org/kvm/20230911093856.81910-1-yishaih@nvidia.com/ -P 2-9 -t  
> > 
> > Yep, the mechanics were really not the question, I'm just double
> > checking to avoid any conflicts with a re-post.  Thanks,  
> 
> It is pretty safe to say that he won't re-post. 
> He had no plans to resend the series.

Ok, applied the remainder of the series to the vfio next branch for
v6.7.  Thanks,

Alex

