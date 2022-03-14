Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF0F4D8D7A
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244763AbiCNTy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243086AbiCNTyr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:54:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1FE97B6A
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 12:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647287540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GBOGyth8SUjOhbMl4iXnJi0rODftuyM/OOyrFjsN+/8=;
        b=YDi9++S7ansLS1XXVkMeV3KK2bR5HXzt7v4NlkzidBfh5qkYT7yNOaKwgT+F1X30DLZb3U
        O3r6RETn5h00jQuW6C5xEGFiFjmoEdp8RHItFrP0XziNiJUJ4ooZ5X69mUBl1nz9CbHKKz
        8EICQpdQetMLvUVV3QQdEY8gskt6qQE=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-387-m_-_8S9wNDmQGhomt_2Esw-1; Mon, 14 Mar 2022 15:52:18 -0400
X-MC-Unique: m_-_8S9wNDmQGhomt_2Esw-1
Received: by mail-io1-f72.google.com with SMTP id k10-20020a5d91ca000000b006414a00b160so12962543ior.18
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 12:52:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GBOGyth8SUjOhbMl4iXnJi0rODftuyM/OOyrFjsN+/8=;
        b=p6yiMPJzjNxd6Ov/Y7J4YMLgtmxj7xfWLUMLtwTZdlamtDfPgUZS20u0Ljzp7zbvKp
         cerY18ODqosMxXV9GIVGbjz66cdWwVxiUgY3z9hJvR0xgNIlyqpQfXdMuKwnhLpyM9dQ
         wgu3O4k1v3p8RkOYe93qAa9JGUfEzcFYOw7h+Y//FNjhx6+cWAYrVGpKxeAql3Io+nrn
         Fv3ZFjUQr8HG8FS1H9US67xM7mfy98J+7q5Egu4Afxm1v0AqzSFi1YgsqUGcM4sDuCj4
         8aQqHk5DSwLz8cOcGiss+KmFShCNrmbai80jjdQA+4eO7OcyvqwoMOY00VMYEgj06DYD
         2g0Q==
X-Gm-Message-State: AOAM5328D4mzEQO/w6vNosa3C5jV6MhDPQDV5sYTpULXUYbRIpx+cpcM
        rpxChw6PS4d6DdP1lsBW8M6xz9ME/gZIL4VM6vLC1MntfKxYn5AEtJnxgFdr9eucUEpt47BlR0J
        U+RoYARwmKitl
X-Received: by 2002:a02:1d45:0:b0:317:c1ed:882f with SMTP id 66-20020a021d45000000b00317c1ed882fmr22366747jaj.33.1647287538238;
        Mon, 14 Mar 2022 12:52:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzL70MDAi9m5dOEzNFXAK2hOJ4q3gZT3CFGBlHf6tZ4stiRQUgD9xY/OIi31lTSnRRajnBrsQ==
X-Received: by 2002:a02:1d45:0:b0:317:c1ed:882f with SMTP id 66-20020a021d45000000b00317c1ed882fmr22366737jaj.33.1647287538003;
        Mon, 14 Mar 2022 12:52:18 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w6-20020a056e021c8600b002c602537ab9sm9693969ill.54.2022.03.14.12.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 12:52:17 -0700 (PDT)
Date:   Mon, 14 Mar 2022 13:52:16 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jgg@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        yishaih@nvidia.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] vfio-pci: Provide reviewers and acceptance criteria
 for vendor drivers
Message-ID: <20220314135216.0cd5e16a.alex.williamson@redhat.com>
In-Reply-To: <87pmmoxqv8.fsf@meer.lwn.net>
References: <164728518026.40450.7442813673746870904.stgit@omen>
        <87pmmoxqv8.fsf@meer.lwn.net>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jon,

On Mon, 14 Mar 2022 13:42:51 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> Alex Williamson <alex.williamson@redhat.com> writes:
> 
> > Vendor or device specific extensions for devices exposed to userspace
> > through the vfio-pci-core library open both new functionality and new
> > risks.  Here we attempt to provided formalized requirements and
> > expectations to ensure that future drivers both collaborate in their
> > interaction with existing host drivers, as well as receive additional
> > reviews from community members with experience in this area.
> >
> > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: Yishai Hadas <yishaih@nvidia.com>
> > Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---  
> 
> One thing...
> 
> >  .../vfio/vfio-pci-vendor-driver-acceptance.rst     |   35 ++++++++++++++++++++
> >  MAINTAINERS                                        |   10 ++++++
> >  2 files changed, 45 insertions(+)  
> 
> If you add a new RST file, you need to add it to an index.rst somewhere
> so that it becomes part of the kernel docs build.

Whoops

> Also, though: can we avoid creating a new top-level documentation
> directory for just this file?  It seems like it would logically be a
> part of the maintainers guide (Documentation/maintainer) ... ?

I'm not sure it's appropriate for Documentation/maintainer/ but it
would make sense to link it from maintainer-entry-profile.rst there.
What if I move it to Documentation/driver-api where there are a couple
other vfio docs?  Thanks,

Alex

