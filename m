Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 624FC7B2741
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 23:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbjI1VNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 17:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbjI1VNp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 17:13:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9091A7
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 14:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695935577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GQawWGoDqBDIRNEerQPTTtIJGDVAPjRmkkKLWoeHhzM=;
        b=UwJm3E5gmp/+R7QsNzhPyUWSrum80E99+dJXklhDbm3+d2gUI7N8cT7A5aV7KlBNYNDsXj
        ov+9qQF0EHHDBNe7/ibBrVokT/27xXVPtUCgDaCMj4zccDm8rHTcFHQW3chyKvxQ9AGmk2
        1YIrVR4l5WqjXlqC57kY2YnlNT9JImY=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-152-clOJXmmvNTaWl3q7n1qZ-A-1; Thu, 28 Sep 2023 17:12:55 -0400
X-MC-Unique: clOJXmmvNTaWl3q7n1qZ-A-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-795386bd5d5so1613115439f.0
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 14:12:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695935575; x=1696540375;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GQawWGoDqBDIRNEerQPTTtIJGDVAPjRmkkKLWoeHhzM=;
        b=T97FL8a1HPHha+TLH746HD4FUgBPM579qPsYb7nQ/RihK2BdODuyjhg6Qd5dNFj1CE
         37fdmq/LTNmpleY28xBDicxvIkRBxcchqNXYrMajwUfJtyxrR8JHJAJNJYL8AdZzojt2
         tM+L9L7+hfjqkA546JY/j5P6v0CZYp8eoJCBvZOvcs3+sCVwHQIbIDsKfc3Rh0NtaWve
         j4Txk2KVm7Bk2ePbfuA6j9LGwziVcc6PfRhkbYr5qzB99VdI30itMNSUGaxWzVw6cXfj
         UA6ePJVT14zMYWMuL2PpebbDzq4xZmCnj3m9U/cPWc67g5h1DmXt5QdvUH0oureFq+v3
         2gUw==
X-Gm-Message-State: AOJu0YzMQZ7TPbvXAxZwmiJIWTgvoLQoSXscRum1czT4KVUVoRiyyroJ
        PEzi8xhD4rcmD0gSqYXwyu2LChur5J+BqpZOpcbS4+NaeChILnlD0/cwF3VhnbCl1cww7N6gQSM
        S5UUF/auwQqNo
X-Received: by 2002:a05:6e02:e0e:b0:34f:9f86:dd45 with SMTP id a14-20020a056e020e0e00b0034f9f86dd45mr1989578ilk.3.1695935574738;
        Thu, 28 Sep 2023 14:12:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFlCxrgj3JzbqbxCmlnd+ESLo6MvtaOCf9vvQwT9cQHMltrbyfqy3/+A3F9Uw7wvTwPj0bKVw==
X-Received: by 2002:a05:6e02:e0e:b0:34f:9f86:dd45 with SMTP id a14-20020a056e020e0e00b0034f9f86dd45mr1989565ilk.3.1695935574431;
        Thu, 28 Sep 2023 14:12:54 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id x3-20020a056e021bc300b003513b61b472sm3136463ilv.38.2023.09.28.14.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 14:12:53 -0700 (PDT)
Date:   Thu, 28 Sep 2023 15:12:52 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgg@ziepe.ca>,
        David Laight <David.Laight@ACULAB.COM>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH v3 0/3] vfio: use __aligned_u64 for ioctl structs
Message-ID: <20230928151252.020dc019.alex.williamson@redhat.com>
In-Reply-To: <20230918205617.1478722-1-stefanha@redhat.com>
References: <20230918205617.1478722-1-stefanha@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 Sep 2023 16:56:14 -0400
Stefan Hajnoczi <stefanha@redhat.com> wrote:

> v3:
> - Remove the output struct sizing code that copied out zeroed fields at the end
>   of the struct. Alex pointed out that new fields (or repurposing a field that
>   was previously reserved) must be guarded by a flag and this means userspace
>   won't access those fields when they are absent.
> v2:
> - Rebased onto https://github.com/awilliam/linux-vfio.git next to get the
>   vfio_iommu_type1_info pad field [Kevin]
> - Fixed min(minsz, sizeof(dmabuf)) -> min(dmabuf.argsz, sizeof(dmabuf)) [Jason, Kevin]
> - Squashed Patch 3 (vfio_iommu_type1_info) into Patch 1 since it is trivial now
>   that the padding field is already there.
> 
> Jason Gunthorpe <jgg@nvidia.com> pointed out that u64 VFIO ioctl struct fields
> have architecture-dependent alignment. iommufd already uses __aligned_u64 to
> avoid this problem.
> 
> See the __aligned_u64 typedef in <uapi/linux/types.h> for details on why it is
> a good idea for kernel<->user interfaces.
> 
> This series modifies the VFIO ioctl structs to use __aligned_u64. Some of the
> changes preserve the existing memory layout on all architectures, so I put them
> together into the first patch. The remaining patches are for structs where
> explanation is necessary about why changing the memory layout does not break
> the uapi.
> 
> Stefan Hajnoczi (3):
>   vfio: trivially use __aligned_u64 for ioctl structs
>   vfio: use __aligned_u64 in struct vfio_device_gfx_plane_info
>   vfio: use __aligned_u64 in struct vfio_device_ioeventfd
> 
>  include/uapi/linux/vfio.h        | 26 ++++++++++++++------------
>  drivers/gpu/drm/i915/gvt/kvmgt.c |  2 +-
>  samples/vfio-mdev/mbochs.c       |  2 +-
>  samples/vfio-mdev/mdpy.c         |  2 +-
>  4 files changed, 17 insertions(+), 15 deletions(-)
> 

Applied to vfio next branch for v6.7.  Thanks,

Alex

