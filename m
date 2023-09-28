Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05567B257C
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 20:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbjI1Sru (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 14:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjI1Srt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 14:47:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B93E180
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 11:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695926827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NL8NH5KFOG6AR2dhbKY2ONg0DzxDeKi1RS0T60WcG4c=;
        b=gN20N1yDpPiF565P/y/pvBHErcAqWDQztL6fcSeG6MkxcZER83EUTndSQtFroU2ibk0ENY
        5j+GZGokCV+rde0KDEgXA7CD0ULt4IHrC+62U6EVWbWKlyR1QNT4j1XMBZpYqwiZMMH8Ms
        V2FZ/fvkKMyMfF3Fi5SeroiJndaRp/Q=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-6i5qiI54MGSw6yxtV8DiJw-1; Thu, 28 Sep 2023 14:47:05 -0400
X-MC-Unique: 6i5qiI54MGSw6yxtV8DiJw-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-35129e6494aso137189185ab.2
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 11:47:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695926825; x=1696531625;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NL8NH5KFOG6AR2dhbKY2ONg0DzxDeKi1RS0T60WcG4c=;
        b=wih9b7i0jm3FW4keC/T2J/cFNhIjdRkAQpF76W7I7HiSS8JzDRpFZs+MmCfjQkLBoc
         rA5PQywm/kR7k+lK33U6n3djnWT4zLUvNmy/9iAa6yRrVqiRy9Dwj7Gxq+roz1V9BU2x
         90tJccMRJoVmvgey2nL0Zom0o/63CZxnZLWYU/Zbi4SN/v84tBoC4D46WZ4hsbxIjNo+
         M9lxLV8+MtEtSZPE1guSPpswVv+NIud6vFNVLEkYMT5eoAhQwH5eehv20ZEr7WKu4rx0
         uT2GN3rzUkBQnGmsjrNLEC2wfTa/Cjo/mbT1dVV5txp3wOSCoyHBK/JPtTaNZLMPAhe/
         89SQ==
X-Gm-Message-State: AOJu0YwYaEU3tY3kya4Lxg+gWzyb7DTG2u/uTmv5kStsRHGAUhw6Kk5P
        GpEyIypikAJThOZJg/Gc0S6PxODqnWg77bCSJpeGIwfixFY/zF4yn0zkJxZW+hY2rOycfpibhqt
        NM0Wd4TtFdyGQ
X-Received: by 2002:a05:6e02:1c07:b0:34f:6f44:aec4 with SMTP id l7-20020a056e021c0700b0034f6f44aec4mr2541155ilh.8.1695926825137;
        Thu, 28 Sep 2023 11:47:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHHyxrI5ZZAnSoNsCJl4qTYvVvX64mpsxjrp47c/NwHfHCRoltxepCsNVrreBOjzhlyfkuS1A==
X-Received: by 2002:a05:6e02:1c07:b0:34f:6f44:aec4 with SMTP id l7-20020a056e021c0700b0034f6f44aec4mr2541140ilh.8.1695926824865;
        Thu, 28 Sep 2023 11:47:04 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id v4-20020a92cd44000000b0035150cf93basm2029912ilq.16.2023.09.28.11.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 11:47:04 -0700 (PDT)
Date:   Thu, 28 Sep 2023 12:47:03 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 0/9] Add chunk mode support for mlx5 driver
Message-ID: <20230928124703.0a4d148c.alex.williamson@redhat.com>
In-Reply-To: <20230928184222.GV1642130@unreal>
References: <20230911093856.81910-1-yishaih@nvidia.com>
        <20230920183123.GJ13733@nvidia.com>
        <78298eea-b264-1739-9ded-7d8fa9c7208e@nvidia.com>
        <20230927161023.7e13c06f.alex.williamson@redhat.com>
        <20230928110808.GT1642130@unreal>
        <20230928122952.31af1d67.alex.williamson@redhat.com>
        <20230928184222.GV1642130@unreal>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Sep 2023 21:42:22 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> On Thu, Sep 28, 2023 at 12:29:52PM -0600, Alex Williamson wrote:
> > On Thu, 28 Sep 2023 14:08:08 +0300
> > Leon Romanovsky <leon@kernel.org> wrote:
> >   
> > > On Wed, Sep 27, 2023 at 04:10:23PM -0600, Alex Williamson wrote:  
> > > > On Wed, 27 Sep 2023 13:59:06 +0300
> > > > Yishai Hadas <yishaih@nvidia.com> wrote:
> > > >     
> > > > > On 20/09/2023 21:31, Jason Gunthorpe wrote:    
> > > > > > On Mon, Sep 11, 2023 at 12:38:47PM +0300, Yishai Hadas wrote:      
> > > > > >> This series adds 'chunk mode' support for mlx5 driver upon the migration
> > > > > >> flow.
> > > > > >>
> > > > > >> Before this series, we were limited to 4GB state size, as of the 4 bytes
> > > > > >> max value based on the device specification for the query/save/load
> > > > > >> commands.
> > > > > >>
> > > > > >> Once the device supports 'chunk mode' the driver can support state size
> > > > > >> which is larger than 4GB.
> > > > > >>
> > > > > >> In that case, the device has the capability to split a single image to
> > > > > >> multiple chunks as long as the software provides a buffer in the minimum
> > > > > >> size reported by the device.
> > > > > >>
> > > > > >> The driver should query for the minimum buffer size required using
> > > > > >> QUERY_VHCA_MIGRATION_STATE command with the 'chunk' bit set in its
> > > > > >> input, in that case, the output will include both the minimum buffer
> > > > > >> size and also the remaining total size to be reported/used where it will
> > > > > >> be applicable.
> > > > > >>
> > > > > >> Upon chunk mode, there may be multiple images that will be read from the
> > > > > >> device upon STOP_COPY. The driver will read ahead from the firmware the
> > > > > >> full state in small/optimized chunks while letting QEMU/user space read
> > > > > >> in parallel the available data.
> > > > > >>
> > > > > >> The chunk buffer size is picked up based on the minimum size that
> > > > > >> firmware requires, the total full size and some max value in the driver
> > > > > >> code which was set to 8MB to achieve some optimized downtime in the
> > > > > >> general case.
> > > > > >>
> > > > > >> With that series in place, we could migrate successfully a device state
> > > > > >> with a larger size than 4GB, while even improving the downtime in some
> > > > > >> scenarios.
> > > > > >>
> > > > > >> Note:
> > > > > >> As the first patch should go to net/mlx5 we may need to send it as a
> > > > > >> pull request format to VFIO to avoid conflicts before acceptance.
> > > > > >>
> > > > > >> Yishai
> > > > > >>
> > > > > >> Yishai Hadas (9):
> > > > > >>    net/mlx5: Introduce ifc bits for migration in a chunk mode
> > > > > >>    vfio/mlx5: Wake up the reader post of disabling the SAVING migration
> > > > > >>      file
> > > > > >>    vfio/mlx5: Refactor the SAVE callback to activate a work only upon an
> > > > > >>      error
> > > > > >>    vfio/mlx5: Enable querying state size which is > 4GB
> > > > > >>    vfio/mlx5: Rename some stuff to match chunk mode
> > > > > >>    vfio/mlx5: Pre-allocate chunks for the STOP_COPY phase
> > > > > >>    vfio/mlx5: Add support for SAVING in chunk mode
> > > > > >>    vfio/mlx5: Add support for READING in chunk mode
> > > > > >>    vfio/mlx5: Activate the chunk mode functionality      
> > > > > > I didn't check in great depth but this looks OK to me
> > > > > >
> > > > > > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>      
> > > > > 
> > > > > Thanks Jason
> > > > >     
> > > > > >
> > > > > > I think this is a good design to start motivating more qmeu
> > > > > > improvements, eg using io_uring as we could go further in the driver
> > > > > > to optimize with that kind of support.
> > > > > >
> > > > > > Jason      
> > > > > 
> > > > > Alex,
> > > > > 
> > > > > Can we move forward with the series and send a PR for the first patch 
> > > > > that needs to go also to net/mlx5 ?    
> > > > 
> > > > Yeah, I don't spot any issues with it either.  Thanks,    
> > > 
> > > Hi Alex,
> > > 
> > > I uploaded the first patch to shared branch, can you please pull it?
> > > https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=mlx5-vfio  
> > 
> > Yep, got it.  Thanks.
> > 
> > Yishai, were you planning to resend the remainder or do you just want
> > me to pull 2-9 from this series?  Thanks,  
> 
> Just pull, like I did with b4 :)
> 
> ~/src/b4/b4.sh shazam -l -s https://lore.kernel.org/kvm/20230911093856.81910-1-yishaih@nvidia.com/ -P 2-9 -t

Yep, the mechanics were really not the question, I'm just double
checking to avoid any conflicts with a re-post.  Thanks,

Alex

