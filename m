Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F96785A70
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 16:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236368AbjHWO1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 10:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbjHWO07 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 10:26:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C158EE6D
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 07:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692800775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xnEXzn2y3iDWlgY1h5P4oZRrvMRBGOGB2OSW0swrWlM=;
        b=N9BGCDxFMF+zXc7mo+c/RZ+kCB9A/LszRyRfRql12yzBAoZ7iPa3GnphNM3sF4wqsMfaFy
        IcbIjqUvqFmy1uwLfk2NtgbI9HTSJxHs4wTW7FLFvovJhZ/11bTF1LXCF+YNuBOJNcNkOw
        cACVMdfoPvjTkijAb9snDMywknnI3t4=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-p7fzlxCNPyCQdHTdYbA9Vg-1; Wed, 23 Aug 2023 10:26:11 -0400
X-MC-Unique: p7fzlxCNPyCQdHTdYbA9Vg-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7907f181babso520106039f.2
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 07:26:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692800771; x=1693405571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xnEXzn2y3iDWlgY1h5P4oZRrvMRBGOGB2OSW0swrWlM=;
        b=VhxYJkxIZfscHFFANzxN8pf6T5lBSa5pNjVvzVrECQYXytPFyBdIiFiRqkSymV5R7C
         ib0sMEcQsoAJ6kxNpxNrMEYIXVsr4JZ99o+DCiArQdWUFkZUzZhGe6v46NWRLFNhwZtn
         gSjy8lwmPUAzxX6tkKP67HCYUHrqmWAydHHBP2p7mKWqQ/ax6IwfSQ8OCKtUhyO1uO6v
         Ah81Nca4f+joxl+GX9tXvXC+WYQIh05cvUeO1h2DzB4ZVkw0f2Qp1PjVTcYJsxQ9roKV
         6EPDSNK61kyxurt5nn8bWs+Rpi3CM0k4h8Ts6lyU3kDG5hE2aZhU2LqUDzLkaHSdg4n1
         cz+Q==
X-Gm-Message-State: AOJu0Yw5JB12JuPwuwG2ysyTRPhqRw7hfh3u9Hkk8weHFVEsYgVzs98q
        a5JdnYAhuzA3zinHmxvRidvikPtB9qAf2r//jr2kd4Brb1YZrRkbdp5cPnH6EHz/OpNgEUVCujP
        NWkqkk6uqNmE+
X-Received: by 2002:a6b:720b:0:b0:787:8d2:e0c with SMTP id n11-20020a6b720b000000b0078708d20e0cmr3146129ioc.12.1692800770863;
        Wed, 23 Aug 2023 07:26:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF01ICWqFHwLoVEr+m4RVo7T8U8PPG+t9CKdbKB3dT5STz1Cr0meVQgpxup5diHeDwWcJElIw==
X-Received: by 2002:a6b:720b:0:b0:787:8d2:e0c with SMTP id n11-20020a6b720b000000b0078708d20e0cmr3146112ioc.12.1692800770642;
        Wed, 23 Aug 2023 07:26:10 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id eq8-20020a0566384e2800b0042b4437d857sm3872718jab.106.2023.08.23.07.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Aug 2023 07:26:10 -0700 (PDT)
Date:   Wed, 23 Aug 2023 08:26:08 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Ankit Agrawal <ankita@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        Andy Currid <acurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20230823082608.2867b73e.alex.williamson@redhat.com>
In-Reply-To: <BY5PR12MB37635FB280AECC6A4CF59431B01CA@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20230822202303.19661-1-ankita@nvidia.com>
        <ZOYP92q1mDQgwnc9@nvidia.com>
        <BY5PR12MB37635FB280AECC6A4CF59431B01CA@BY5PR12MB3763.namprd12.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
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

On Wed, 23 Aug 2023 14:18:52 +0000
Ankit Agrawal <ankita@nvidia.com> wrote:

> >> +
> >> +     /*
> >> +      * Handle read on the BAR2 region. Map to the target device memory
> >> +      * physical address and copy to the request read buffer.
> >> +      */
> >> +     if (copy_to_user(buf, (u8 *)addr + offset, read_count))
> >> +             return -EFAULT;  
> >
> > Just to verify, does this memory allow access of arbitrary alignment
> > and size?  
> 
> Please correct me if I'm wrong, but based on following gdb dump data on
> the corresponding MemoryRegion->ops, unaligned access isn't supported, and
> a read of size upto 8 may be done. 
> 
> (gdb) p/x *(mr->ops)
> $7 = {read = 0xaaab5e0b1c50, write = 0xaaab5e0b1a50, read_with_attrs = 0x0, write_with_attrs = 0x0,
>   endianness = 0x2, valid = {min_access_size = 0x1, max_access_size = 0x8, unaligned = 0x0, accepts = 0x0},
>   impl = {min_access_size = 0x1, max_access_size = 0x8, unaligned = 0x0}}

This is QEMU policy relative to this region, the kernel interface is
not exclusive to QEMU usage.  Thanks,

Alex

