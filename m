Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9BA77FDEC
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 20:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354448AbjHQSev (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 14:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354442AbjHQSea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 14:34:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FF12136
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 11:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692297224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gexPipbqUfcFFvNx/MvK38HTJI+O56duX55+MbeHy94=;
        b=Ik6likBEE1lEcypUY5A2U3283t18qz1wuQsSi4Y0ftrhFt4oxIAeFhlFBxx6VzXQqa6lJz
        ucKcMjYts3nrKXhCwtpfKdGUVCEHd4unYU3KEeQSgHNppTaG+ghg31wTb62a8spfTiBtWM
        DRtGsld5+jSQ3eWrxr3t4HlfqviGmzg=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-wzVBVnGfO8O5FXDQOWKTiQ-1; Thu, 17 Aug 2023 14:33:41 -0400
X-MC-Unique: wzVBVnGfO8O5FXDQOWKTiQ-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-34a94a4ebeeso1089125ab.1
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 11:33:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692297221; x=1692902021;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gexPipbqUfcFFvNx/MvK38HTJI+O56duX55+MbeHy94=;
        b=NNq9pXf4OE+SN1DUFLO2z2R+jLv7lUcQsy9Yx/dPA5lRJnTgOSgDka89QkzFyLfWDf
         58xlH9gApSvDhwSwiB6t7VcmZxCWUZKjqueWvpihKcQRmLND10la1hpYtuSEk4Ad+QfE
         ii3T+yyZxuvcnz/J2f8ytXnC+rJrl6M1Ph7pNhfwHGAEd1Bh3iFEl01CmhvjUc8SJH7z
         kXHsbI72ufs9fQBOkYQEuNXarr4Fu4IPAzFk/vHacp+204uyqFuOeLI+QSkePg42vznn
         AtzIj9qhChXcY5jtmnby+y9OkD2AiIHs2s48L80j2rNvm8fHgl4OYE5TUUvkdu0lezB4
         U9lA==
X-Gm-Message-State: AOJu0Yw1yFyGrdBoghqezY24GoFT1BQN+pMq+vRzAgIoH2UHdk797ELC
        UUgJf3Ubi0pHLrBuxzjlVQFnL6RKUSrB4m8v4OJIXJ6lL2ZAzNEzznwr+M+ws+f2JFV1MmBr4qs
        10flh/wIBMFkh
X-Received: by 2002:a05:6e02:927:b0:34a:9120:d7e with SMTP id o7-20020a056e02092700b0034a91200d7emr428420ilt.9.1692297220856;
        Thu, 17 Aug 2023 11:33:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHa6I/Sfuog1vyDS9pXGoSuKyZqpdybT3hs/6ik00fZZgmWFHMcUgu93VYiI0dKSWu8SQIAvw==
X-Received: by 2002:a05:6e02:927:b0:34a:9120:d7e with SMTP id o7-20020a056e02092700b0034a91200d7emr428407ilt.9.1692297220597;
        Thu, 17 Aug 2023 11:33:40 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id y3-20020a92c743000000b003491422ca27sm27524ilp.45.2023.08.17.11.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 11:33:39 -0700 (PDT)
Date:   Thu, 17 Aug 2023 12:33:38 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vfio: align capability structures
Message-ID: <20230817123338.764e8c83.alex.williamson@redhat.com>
In-Reply-To: <ZN5getPSq1stluMt@nvidia.com>
References: <20230809203144.2880050-1-stefanha@redhat.com>
        <ZN5getPSq1stluMt@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Aug 2023 15:01:30 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Aug 09, 2023 at 04:31:44PM -0400, Stefan Hajnoczi wrote:
> > The VFIO_DEVICE_GET_INFO, VFIO_DEVICE_GET_REGION_INFO, and
> > VFIO_IOMMU_GET_INFO ioctls fill in an info struct followed by capability
> > structs:
> > 
> >   +------+---------+---------+-----+
> >   | info | caps[0] | caps[1] | ... |
> >   +------+---------+---------+-----+
> > 
> > Both the info and capability struct sizes are not always multiples of
> > sizeof(u64), leaving u64 fields in later capability structs misaligned.
> > 
> > Userspace applications currently need to handle misalignment manually in
> > order to support CPU architectures and programming languages with strict
> > alignment requirements.
> > 
> > Make life easier for userspace by ensuring alignment in the kernel. This
> > is done by padding info struct definitions and by copying out zeroes
> > after capability structs that are not aligned.
> > 
> > The new layout is as follows:
> > 
> >   +------+---------+---+---------+-----+
> >   | info | caps[0] | 0 | caps[1] | ... |
> >   +------+---------+---+---------+-----+
> > 
> > In this example caps[0] has a size that is not multiples of sizeof(u64),
> > so zero padding is added to align the subsequent structure.
> > 
> > Adding zero padding between structs does not break the uapi. The memory
> > layout is specified by the info.cap_offset and caps[i].next fields
> > filled in by the kernel. Applications use these field values to locate
> > structs and are therefore unaffected by the addition of zero padding.
> > 
> > Note that code that copies out info structs with padding is updated to
> > always zero the struct and copy out as many bytes as userspace
> > requested. This makes the code shorter and avoids potential information
> > leaks by ensuring padding is initialized.
> > 
> > Originally-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> > v3:
> > - Also align capability structs in drivers/iommu/iommufd/vfio_compat.c
> >   [Jason]
> > 
> >  include/uapi/linux/vfio.h           |  2 ++
> >  drivers/iommu/iommufd/vfio_compat.c |  2 ++
> >  drivers/vfio/pci/vfio_pci_core.c    | 11 ++---------
> >  drivers/vfio/vfio_iommu_type1.c     | 11 ++---------
> >  drivers/vfio/vfio_main.c            |  6 ++++++
> >  5 files changed, 14 insertions(+), 18 deletions(-)  
> 
> Acked-by: Jason Gunthorpe <jgg@nvidia.com>

Thanks!

Applied to vfio next branch for v6.6.  Thanks,

Alex

