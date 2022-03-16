Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455A34DB9FE
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 22:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358124AbiCPVNe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 17:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353707AbiCPVNd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 17:13:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9426548E77
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 14:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647465137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i7/+xJxJo5EtPXTa2Igw+/A1HJm8dgW21+h/vVG4wM4=;
        b=fuyEJ4u10kvX4M+xNSQbYtg7tVC3kILhdUQ/hX1DGCDmYv7NjsU51gImDAI1kXr7QluRjo
        HVRPLZV3Z5DW4lfrtqUYEn5iZI9zx3gZBZij5R6RfXPLpwpujRP/ZLPWBOzstwEM+kFSn2
        G9WyBulpVzbYfy5zjRQJhNEgViRz/bM=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-TFlJivkXMTm7tO4_5qUOxw-1; Wed, 16 Mar 2022 17:12:16 -0400
X-MC-Unique: TFlJivkXMTm7tO4_5qUOxw-1
Received: by mail-io1-f72.google.com with SMTP id f7-20020a056602088700b00645ebbe277cso2001561ioz.22
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 14:12:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=i7/+xJxJo5EtPXTa2Igw+/A1HJm8dgW21+h/vVG4wM4=;
        b=J4ErWNx9d1iO804rAAuBeNW7yuk5amqI22bMdF2xmlA86WmsNqfvr9HR29r6bPPQw2
         ktRIWCl9IQiqnqwhn2XM7xxv2p/YjCa83Z8D4En3ht5yWcCZTjcfnvdfIAWXIGuN4oli
         8wQ5VId+MWpInA9hsmpsS1s7F/1xbgXtAGp9/hw62SWlJHFUZ3f0qgK32ltnjX+mpjBK
         Pv+tvHA7qULFf4Ue0kbn9A7rAfarEJx2z1/hJRssgUN7vf2ajKyX6eRmpfH+qM+7FHn/
         pph2g2jc2ca6Gng/922pOZpSp05gLFMf+IFK9eAS8pU38AMeVFw4FMcessos+Qt1nvF6
         SOew==
X-Gm-Message-State: AOAM5302uqeKveBUok1E21pKn0B8sfY9LU33iHiApp3CJ6V9o8Xto2A6
        6Z/yN4P/TAXmyalsH/rSzv9K74UNa5dF+FlWhRy/oK1WH5J+7jMeM0LzmjI16kCX5jOIRmDMVQJ
        1K6kU3i8wPhTT
X-Received: by 2002:a5d:89d8:0:b0:645:d853:66f0 with SMTP id a24-20020a5d89d8000000b00645d85366f0mr843233iot.30.1647465135580;
        Wed, 16 Mar 2022 14:12:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJympsKSmFw7oQCxHWBDz7yJ2qwkRpX+Zxgw7rY0YM2XSCu1AysybpyZqRKvCwZ/gOtVUbVdUQ==
X-Received: by 2002:a5d:89d8:0:b0:645:d853:66f0 with SMTP id a24-20020a5d89d8000000b00645d85366f0mr843226iot.30.1647465135380;
        Wed, 16 Mar 2022 14:12:15 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id t17-20020a92ca91000000b002c7e2664bf7sm126377ilo.36.2022.03.16.14.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 14:12:15 -0700 (PDT)
Date:   Wed, 16 Mar 2022 15:12:14 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jgg@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        yishaih@nvidia.com, linux-doc@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH v4] vfio-pci: Provide reviewers and acceptance criteria
 for variant drivers
Message-ID: <20220316151214.552a16b3.alex.williamson@redhat.com>
In-Reply-To: <87wngtsiws.fsf@meer.lwn.net>
References: <164736509088.181560.2887686123582116702.stgit@omen>
        <87wngtsiws.fsf@meer.lwn.net>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Mar 2022 15:10:27 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> Alex Williamson <alex.williamson@redhat.com> writes:
> 
> > Device specific extensions for devices exposed to userspace through
> > the vfio-pci-core library open both new functionality and new risks.
> > Here we attempt to provided formalized requirements and expectations
> > to ensure that future drivers both collaborate in their interaction
> > with existing host drivers, as well as receive additional reviews
> > from community members with experience in this area.
> >
> > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > Acked-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> > Acked-by: Kevin Tian <kevin.tian@intel.com>
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>  
> 
> So this seems fine to me.  Did you want it to go through the docs tree,
> or did you have another path in mind for it?

Thanks, Jon.  I can bring it in through the vfio tree if that works for
you.  Thanks,

Alex

