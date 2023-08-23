Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F510785BB4
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 17:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236903AbjHWPPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 11:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236859AbjHWPPH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 11:15:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F237BE79
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 08:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692803651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nmWOJ3PgLNwb6XXHu+pQh+YNRDsU+vDPGbdwEescA6k=;
        b=bYx3ixCNWZGCONUrDDYABMa62gIYOzJBc9DHnISg78YLHUq8uWdVrGlGYCT+p1YOHhCxG9
        nvZt3Ry/mPlSWXtcvCNW8kaxHx/2m6h6H35QktX2ZbsN3SAmDmpN0xfP6E35X/79Hl6ccc
        FFZ2VEXIep3aq+45JpEAVwaXSX9nNE8=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-unq1TDD1Nb23o1c2ZA_VQg-1; Wed, 23 Aug 2023 11:14:10 -0400
X-MC-Unique: unq1TDD1Nb23o1c2ZA_VQg-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-786d9d4d9a6so539221439f.2
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 08:14:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692803649; x=1693408449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nmWOJ3PgLNwb6XXHu+pQh+YNRDsU+vDPGbdwEescA6k=;
        b=Z9p7zT/nzOVzh0G6cRvbVN3WY1h1Ucw/F6IwqrGHjiPr0eLKwaaKbg9P+4YDJwE++i
         KoU6GzQZAGz72yJaYV2rFZcFOdFnRnEBYVdOrgsI/543o74QGbUCOtt33DDUwCpFc42i
         SnlGt7gdRehyYf4lNbGRM3yp+M0/hakW50SheI6PnSxW9ml8dOgrdewLaGrI0zCaG3K3
         zAwQoC7yhPWBbNFVU6rnPfQ9pabMNh1QKhbUlGK/Ch0gRxmwTasNBJo8s4Z8VH7ZlZBj
         dA+EXzB0sO85+PtA8nyXqp1Xaxr6dQ7StVc7gNyrpF337bgv/Pe6bL210OZdE3xrrh55
         JihQ==
X-Gm-Message-State: AOJu0YzL3vm6B2ECypWTOSjvg57mJmUv9hbywn/Yqny1mgtvUEyh+ADm
        U++NyMvDiSTYuu0RYgCDzxh/QF3A+N+5oVyKaBcpRMEs5ECBfWlhmr4XQWuRrGcPUkEfThUeSuc
        cZ8en2+L6mfug
X-Received: by 2002:a5e:8b04:0:b0:790:a23b:1dfc with SMTP id g4-20020a5e8b04000000b00790a23b1dfcmr3307543iok.9.1692803649368;
        Wed, 23 Aug 2023 08:14:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1ejXlq1DobE4s847LmD8hNlB4ek7rEulj4rPQgyLGwQUjlN1C1W1HdguCPBUX33+sS3zvSg==
X-Received: by 2002:a5e:8b04:0:b0:790:a23b:1dfc with SMTP id g4-20020a5e8b04000000b00790a23b1dfcmr3307519iok.9.1692803649184;
        Wed, 23 Aug 2023 08:14:09 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id s24-20020a02ad18000000b00430a69ea278sm3821226jan.167.2023.08.23.08.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Aug 2023 08:14:08 -0700 (PDT)
Date:   Wed, 23 Aug 2023 09:14:07 -0600
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
Message-ID: <20230823091407.0964bd3b.alex.williamson@redhat.com>
In-Reply-To: <BY5PR12MB37639528FCF1CDB7D595B6FFB01CA@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20230822202303.19661-1-ankita@nvidia.com>
        <ZOYP92q1mDQgwnc9@nvidia.com>
        <BY5PR12MB37639528FCF1CDB7D595B6FFB01CA@BY5PR12MB3763.namprd12.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
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

On Wed, 23 Aug 2023 14:50:31 +0000
Ankit Agrawal <ankita@nvidia.com> wrote:

> >> +     if (index == VFIO_PCI_BAR2_REGION_INDEX) {
> >> +             if (!nvdev->opregion) {
> >> +                     nvdev->opregion = memremap(nvdev->hpa, nvdev->mem_length, MEMREMAP_WB);
> >> +                     if (!nvdev->opregion)
> >> +                             return -ENOMEM;
> >> +             }  
> >
> > [AW] Seems like this would be susceptible to concurrent accesses causing
> > duplicate mappings.
> >
> > [JG] Needs some kind of locking on opregion  
> 
> Right, will add a new lock item in nvdev to control the access to opregion/memmap.
> Please let me know if it is preferable to do memremap in open_device instead of
> read/write.

That's a valid option also, certainly avoids the locking and
serialization per access.  Thanks,

Alex

