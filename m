Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8581A785C04
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 17:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237202AbjHWPZj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 11:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237195AbjHWPZi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 11:25:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787F71700
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 08:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692804274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1G4m8nBsyvTIp6TI5Hlz0aw09qGLJzWflBRxUecCBwg=;
        b=H+Vn+TUzndv+UHRdL4SipVZHfzhhCDSOF8wh2AN4SRO1JYsA8b0EqEVQMnILOZsielIz+9
        IPfFASTrtdkZtVMV7PxGJ3hSrl9PzxexGWcfnIr44sOMdbFD/GYq9stNPyFPFsPPVzwyCj
        uliqbZOFa3nOmhtRFt9PsPdQMRDiT/g=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-zGWTlgjHM1i9ncQ6-Sup3w-1; Wed, 23 Aug 2023 11:24:32 -0400
X-MC-Unique: zGWTlgjHM1i9ncQ6-Sup3w-1
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-6b9c82fe107so6197579a34.2
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 08:24:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692804272; x=1693409072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1G4m8nBsyvTIp6TI5Hlz0aw09qGLJzWflBRxUecCBwg=;
        b=J5ROiT+XlvBK0Nb/o+1wtkooUyUGGij3cZosGbh0XrIO7uACdvbBpP8FuIREhV8XEN
         zUPhW6MZim8CxZ5aLkCIR4TiIRJ2mjFtfzeuFesylkD/YFk/A3NIuwyeXE9ZNaqdOkDa
         j9xcHmUsmpVN0goFsJ5OrwGvJnRi1bo3ZX+b/CA76l5kithL4wkohRFA+42D9PjQG6kw
         u+O67laEZ+9P7+kqGk23yCjGEbbWwMm1W/9/e3rq04HeFZF7ndmpMory4Etl0/Pxdyuo
         uu56/7KBIfYbEdK+mp1y3GLE8dO7UcSDLY76dJ5m09Y4nbyF8fExH/yZMWxEqL/LA/mX
         9OlA==
X-Gm-Message-State: AOJu0YzC+oj07tfUKF5p0X3aEjkN2V4bdWs8MEsGUWfKowLlVxb6b9cZ
        kyAiNbzd5J8MmUggQ3cZW3458YCrZvlnN56Jmduq6m16YvHqGh0WtfpPGtjQypOspA9jerc8xxj
        akMsfdVgvWRfh
X-Received: by 2002:a05:6870:9122:b0:1c8:bf19:e1db with SMTP id o34-20020a056870912200b001c8bf19e1dbmr16834373oae.11.1692804272022;
        Wed, 23 Aug 2023 08:24:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPE5oTDv2BIKyAx5H2CS12AseN3vyzYSjgHXcPnazkhUeGsPnAz5qOppr3jXaHnBeKT7ElqQ==
X-Received: by 2002:a05:6870:9122:b0:1c8:bf19:e1db with SMTP id o34-20020a056870912200b001c8bf19e1dbmr16834350oae.11.1692804271725;
        Wed, 23 Aug 2023 08:24:31 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id t12-20020a0568301e2c00b006b8bf76174fsm5757731otr.21.2023.08.23.08.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Aug 2023 08:24:31 -0700 (PDT)
Date:   Wed, 23 Aug 2023 09:24:29 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Ankit Agrawal <ankita@nvidia.com>,
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
Message-ID: <20230823092429.643b4f7b.alex.williamson@redhat.com>
In-Reply-To: <ZOYix7kFDYcvZ/gp@nvidia.com>
References: <20230822202303.19661-1-ankita@nvidia.com>
        <ZOYP92q1mDQgwnc9@nvidia.com>
        <BY5PR12MB37639528FCF1CDB7D595B6FFB01CA@BY5PR12MB3763.namprd12.prod.outlook.com>
        <20230823091407.0964bd3b.alex.williamson@redhat.com>
        <ZOYix7kFDYcvZ/gp@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
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

On Wed, 23 Aug 2023 12:16:23 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Aug 23, 2023 at 09:14:07AM -0600, Alex Williamson wrote:
> > On Wed, 23 Aug 2023 14:50:31 +0000
> > Ankit Agrawal <ankita@nvidia.com> wrote:
> >   
> > > >> +     if (index == VFIO_PCI_BAR2_REGION_INDEX) {
> > > >> +             if (!nvdev->opregion) {
> > > >> +                     nvdev->opregion = memremap(nvdev->hpa, nvdev->mem_length, MEMREMAP_WB);
> > > >> +                     if (!nvdev->opregion)
> > > >> +                             return -ENOMEM;
> > > >> +             }    
> > > >
> > > > [AW] Seems like this would be susceptible to concurrent accesses causing
> > > > duplicate mappings.
> > > >
> > > > [JG] Needs some kind of locking on opregion    
> > > 
> > > Right, will add a new lock item in nvdev to control the access to opregion/memmap.
> > > Please let me know if it is preferable to do memremap in open_device instead of
> > > read/write.  
> > 
> > That's a valid option also, certainly avoids the locking and
> > serialization per access.  Thanks,  
> 
> open_device is no good, that would waste large amounts of kernel
> memory for page tables to support something we don't expect to be
> used.

A lock it is then, I guess this is a very large range of memory.  The
contention/serialization is also not a priority, we expect access
through the mmap for anything other than debug.  Thanks,

Alex

