Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F487490E6
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 00:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbjGEWRF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 18:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbjGEWRA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 18:17:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4ADA1725
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 15:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688595370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qq75uyGRzRzxyidqOBQLr4YFitm/TvY3P4mlozJkGcg=;
        b=R5Rx0cewJ/CkPbGKxh/ESYQ8Cpeu2phsOGECIko7XmaSzwLMfJVq106ltLRPwdloJLcc5O
        5SVwsXwzIDkKnP/oDQuAxyNU6eL0BqJMU5QCeAy1GoHNYheEhmIhdbQHrcKbjLFaE3aswa
        1tCqLydqDMJbmDXYGKjDdbE7BCHIFqI=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-V7iyJO8tNjKR9AlI7Qy3oA-1; Wed, 05 Jul 2023 18:16:07 -0400
X-MC-Unique: V7iyJO8tNjKR9AlI7Qy3oA-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7834a155749so291749839f.0
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 15:16:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688595367; x=1691187367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qq75uyGRzRzxyidqOBQLr4YFitm/TvY3P4mlozJkGcg=;
        b=AekiSsEhna2XDg6CIcaBib+Uu6hsHc2v/SS3Xrsg7MeYzt+x63XDnXedGzhCLt1DAE
         /j6tkyM5BehtL44iOIHaNvdzq60/Li9OMP23XtqvKQde/aX4nAeeSu+crock6QP3ESAI
         XDRYWtdzZW63Z9dz6TdGuZ6xjCstVHfCCw/6iD5PfPP1aVK4QvNM9Vx8UgXBXPKGDhYh
         9YxU1AM5AHQeb0LQO+8Jk8qqxaTAKt53UYPU/hdukY2cz7H6DTS9sEAOGN7GEBR95aE7
         5bpTv2MOLi2u61NdxzPmGrGTBtERd5oaR/1zw/Wnzbl07GltRDdXVAp3C297uFQdU5AB
         I0gg==
X-Gm-Message-State: ABy/qLbJSuSVqOy+gNTd9DT5i97eHDsI48J31Rs31x7ky+FvwO1BPzpZ
        TAqWexXoYw5qZQDNz3jE5ib/lgEMe5a/IpvRSg5M++BJDEezs7PVF8RKkTGerKiwiNDAuB/zNgx
        P/JS9njbSGicf
X-Received: by 2002:a6b:5103:0:b0:783:63f9:55b9 with SMTP id f3-20020a6b5103000000b0078363f955b9mr360512iob.16.1688595366949;
        Wed, 05 Jul 2023 15:16:06 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHvBl5USbrebLLdZ8uwPu3OUbZfIQ6ET4jnMvwPtqkvtM5q2kQZTFSAxylVDn8Jr4ISrEl71g==
X-Received: by 2002:a6b:5103:0:b0:783:63f9:55b9 with SMTP id f3-20020a6b5103000000b0078363f955b9mr360498iob.16.1688595366644;
        Wed, 05 Jul 2023 15:16:06 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id k10-20020a02cb4a000000b0041643b78cbesm46093jap.120.2023.07.05.15.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jul 2023 15:16:06 -0700 (PDT)
Date:   Wed, 5 Jul 2023 16:16:04 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Ankit Agrawal <ankita@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        Andy Currid <ACurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20230705161604.53d854f9.alex.williamson@redhat.com>
In-Reply-To: <BY5PR12MB3763A67B9AEFC48BAAFA9C5AB02FA@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20230622030720.19652-1-ankita@nvidia.com>
        <20230626100106.2e3ddb14.alex.williamson@redhat.com>
        <BY5PR12MB3763A67B9AEFC48BAAFA9C5AB02FA@BY5PR12MB3763.namprd12.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Jul 2023 18:37:42 +0000
Ankit Agrawal <ankita@nvidia.com> wrote:

> > I had also asked in the previous review whether "nvgpu" is already overused.  I
> > see a python tool named nvgpu, an OpenXLA tool, various nvgpu things related
> > to Tegra, an nvgpu dialect for MLIR, etc.  There are over 5,000 hits on google for
> > "nvgpu", only a few of which reference development of this module.  Is there a
> > more unique name we can use?  Thanks,  
> 
> Sorry, had missed this comment. Are you suggesting changing the module name
> or just reduce the number of times we use the nvgpu keyword in all the functions
> of the module? I don't see any in-tree or vfio-pci module with a similar *nvgpu*
> name, and the clash appears to be with items outside of the kernel tree. Given
> that, should we still change the module name as nvgpu-vfio-pci sounds a relevant
> name here? Thanks.

I'm referring to the module name, which in turn would be reflected in
various function names.  The fact that there's no in-tree *nvgpu*
driver seems irrelevant when a web search for the term shows a variety
of tools and drivers, I believe there's even an out-of-tree NVIDIA
sponsored nvgpu driver for Android, correct?  How does this relate to
that?  I don't think it does, so why generate confusion?

I don't know your future plans for this driver, but it's currently
limited to exposing essentially a single feature on a very, very small
product subset, while "nvgpu" seems to project something much more
generic.

If we're going to see more of devices exposing coherent memory with
CXL, does that mean this driver might be short lived and perhaps won't
see further expansion in functionality?  If so maybe it should be named
more specifically for the product it supports.  I see some NVIDIA pages
referring to the GH200 superchip, maybe "GH", ex. "nvgh", "nvgh-gpu"?

Reading through the datasheet, I'm also reminded of issues we had with
the POWER implementation relative to isolation, since this coherent
memory is enabled via NVLink-C2C, which is opaque to Linux.  The
datasheet claims "[f]ourth-generation NVLink allows accessing peer
memory with direct loads, sotres, and atomic operations...", are those
direct accesses reflected in the PCI topology, ie. the PCIe ACS exposed
isolation, or is the peer here limited to the CPU?  Thanks,

Alex

