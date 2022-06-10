Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A948546FB6
	for <lists+kvm@lfdr.de>; Sat, 11 Jun 2022 00:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348592AbiFJWoQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 18:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348418AbiFJWoO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 18:44:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8293D3BFBF
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 15:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654901052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pblZd+Kqp7f2K+2rxNpvXUuiOLaopPh9IaEYk0kwYKE=;
        b=NTjYhRsx6ctDVsjQjsegWvbKCxKclOsEO07UrXSk8ypDynoqmphEPoXwlWosTDmIHU9jKu
        NKAwmxOJK34qSCSYKb+G7QwCrJl47j/kbQpKWg4P/UnmlckC+uUe3niKVZInsbxS/dMuzs
        suM1nz9eAMOXglsw91/x6M5dOdPLk4g=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-Qd_niQHQPTCCw14LJshG-g-1; Fri, 10 Jun 2022 18:44:11 -0400
X-MC-Unique: Qd_niQHQPTCCw14LJshG-g-1
Received: by mail-io1-f72.google.com with SMTP id k4-20020a6b4004000000b006697f6074e6so244399ioa.11
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 15:44:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=pblZd+Kqp7f2K+2rxNpvXUuiOLaopPh9IaEYk0kwYKE=;
        b=DQ1XmZ6Q/0K6kv7VF68QABOH55EU3MD9MWQowi9zx8fu6F6u9ZjOIs0D4NhluHQ85Z
         b964F1OzLMmCtC1Vijw95b7nvzdEUNkOhv8DbsHERlahuduAxBRDI4MkgbD6UqgcZ9sl
         ityIQaXRC832+DCtai61dJH0N81Y3yHkpCeqOsyyq9u/WFLVgegyldyOHsuyWlJ1qMxn
         YHK0862b3bMZEyqO1/H2CzWeLDY7OGTymRlpmlJ2I7m0+oagMSX/zrZsz3iPcwhs5vBC
         uGTcthZ7Y+W9MEJ+vWIuASgH6S31p9uwx/OJXWNkRvbRsQC20ZpnJ/J1YcoWP7sXhTsZ
         cIDA==
X-Gm-Message-State: AOAM530tqnreRsOHaQCGiqCwN7W1uniaeP5nGl7x3cNWWOpmXooX5LRR
        0x+KU4wNSESLXMlWE3Jj74P/dygeqTHzXeqcGtv0danxt+mMMXMXYfOr8X9WHu3OnF2GvPbcuLX
        NswGEFCvtLc8Y
X-Received: by 2002:a02:c811:0:b0:332:2c2e:88e0 with SMTP id p17-20020a02c811000000b003322c2e88e0mr343353jao.132.1654901050840;
        Fri, 10 Jun 2022 15:44:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgEFjSHs9TXHG3p6x60NRKxwsOGKtJ1mMFIodXcBQ3lbM9zLgveeGgcd98DfNgAuz2vKQAXQ==
X-Received: by 2002:a02:c811:0:b0:332:2c2e:88e0 with SMTP id p17-20020a02c811000000b003322c2e88e0mr343346jao.132.1654901050600;
        Fri, 10 Jun 2022 15:44:10 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id y2-20020a926402000000b002d3a3a089b3sm130533ilb.1.2022.06.10.15.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 15:44:09 -0700 (PDT)
Date:   Fri, 10 Jun 2022 16:44:07 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kwankhede@nvidia.com, farman@linux.ibm.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, diana.craciun@oss.nxp.com, cohuck@redhat.com,
        eric.auger@redhat.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, yishaih@nvidia.com, hch@lst.de
Subject: Re: [PATCH] vfio: de-extern-ify function prototypes
Message-ID: <20220610164407.25feeb23.alex.williamson@redhat.com>
In-Reply-To: <20220610000434.GE1343366@nvidia.com>
References: <165471414407.203056.474032786990662279.stgit@omen>
        <20220610000434.GE1343366@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Jun 2022 21:04:34 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Jun 08, 2022 at 12:55:13PM -0600, Alex Williamson wrote:
> > The use of 'extern' in function prototypes has been disrecommended in
> > the kernel coding style for several years now, remove them from all vfio
> > related files so contributors no longer need to decide between style and
> > consistency.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> > 
> > A patch in the same vein was proposed about a year ago, but tied to an ill
> > fated series and forgotten.  Now that we're at the beginning of a new
> > development cycle, I'd like to propose kicking off the v5.20 vfio next
> > branch with this patch and would kindly ask anyone with pending respins or
> > significant conflicts to rebase on top of this patch.  Thanks!  
> 
> Can you stick it in your branch please?

Thanks for the R-b, it was my plan today to put it in my next branch,
but I can't currently test vfio on mainline due to:

https://lore.kernel.org/all/165490039431.944052.12458624139225785964.stgit@omen/

I'll get this in once there's a mainline base where vfio still works.  Thanks,

Alex

