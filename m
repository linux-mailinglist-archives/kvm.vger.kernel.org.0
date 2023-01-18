Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18B667253C
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 18:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbjARRnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 12:43:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbjARRmY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 12:42:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1ABE5AA44
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674063650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OFz6FhuT9o8DqB1H+HaxFzzE6T3dZEv/qEAy6lvVPWw=;
        b=HluVSda8xyvijDu/uxWUPZUBxcn08N3fP2ekO9jgOtWgeNcDzLVPXgmvwim9pmZb9ioQkI
        LCowad2PrUDb6kdfnxZvwfoLgqdYi/JfwNBvyfKFYU5ODDdH6p/TgwIPUf2C2rYCwILrTg
        +SRB6X6cZfXZEMj1vCkfwXFABMBIIXA=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-584-edDDFyLAPkSiktr3GSV6Fg-1; Wed, 18 Jan 2023 12:40:48 -0500
X-MC-Unique: edDDFyLAPkSiktr3GSV6Fg-1
Received: by mail-io1-f70.google.com with SMTP id s17-20020a0566022bd100b00704c01f38abso4655623iov.0
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:40:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OFz6FhuT9o8DqB1H+HaxFzzE6T3dZEv/qEAy6lvVPWw=;
        b=Am0euT5IX98CUNgeBg6HBTAB+wfPzOeTcPNAoxznBE4ZqRafw0VjJfh/C5TkOQekIg
         67fLlYjQ/4LkIH9PbpeGOpqjtj8aAk/Gz2Ca9a8109l4p+Di89OSBaviKmI/DiBXdDOC
         Q9KJitu92oUmn4lEeHA4VCI4UI/agRlOugV55bMnqL73iY6X0HPWR2UQF/jiObciZ7CN
         YTTzIbAY8kPgQ11YKA2JIb/ukA013er4hS6OE2ckLpWd2GNeQNoRgZARCjWnqLsXhWo7
         GD83bb8sHQe5lAn/hvfTiBDKc4lLTxg7E6U4jAjgSSsGVPN4b+iXHrcmjsj3+jeAI1E6
         PLcw==
X-Gm-Message-State: AFqh2kptHaevxKptheRQeUm9ELGIA3dQllLo4AeLQ+m7Gop1xYXtEUbA
        MT2YItBVl78WmBTibvBcb+VjDdcH11zysG++2E64acaiiKAe27RIZXyW38/MVMwAf1OiSHxy8Go
        7Ht/NFMvpo5uQ
X-Received: by 2002:a92:cf50:0:b0:30d:b08b:259c with SMTP id c16-20020a92cf50000000b0030db08b259cmr6919858ilr.5.1674063647776;
        Wed, 18 Jan 2023 09:40:47 -0800 (PST)
X-Google-Smtp-Source: AMrXdXteuK5LqishWSUxXjJosygpDRsVMY0Aoa/N5Wb+T7nrch7I9lpZJHMhLJN+SXXq9+i3Wfe3Lg==
X-Received: by 2002:a92:cf50:0:b0:30d:b08b:259c with SMTP id c16-20020a92cf50000000b0030db08b259cmr6919837ilr.5.1674063647504;
        Wed, 18 Jan 2023 09:40:47 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l14-20020a92700e000000b0030c27c9eea4sm10003679ilc.33.2023.01.18.09.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 09:40:46 -0800 (PST)
Date:   Wed, 18 Jan 2023 10:40:44 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        diana.craciun@oss.nxp.com, eric.auger@redhat.com, maorg@nvidia.com,
        cohuck@redhat.com, shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V1 vfio 0/6] Move to use cgroups for userspace
 persistent allocations
Message-ID: <20230118104044.2811ab35.alex.williamson@redhat.com>
In-Reply-To: <Y8gM+9ptO2umgPQf@nvidia.com>
References: <20230108154427.32609-1-yishaih@nvidia.com>
        <20230117163811.591b4d6f.alex.williamson@redhat.com>
        <Y8gM+9ptO2umgPQf@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Jan 2023 11:15:07 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jan 17, 2023 at 04:38:11PM -0700, Alex Williamson wrote:
> 
> > The type1 IOMMU backend is notably absent here among the core files, any
> > reason?  
> 
> Mostly fear that charging alot of memory to the cgroup will become a
> compatibility problem. I'd be happier if we go along the iommufd path
> some more and get some field results from cgroup enablement before we
> think about tackling type 1.
> 
> With this series in normal non-abusive cases this is probably only a
> few pages of ram so it shouldn't be a problem. mlx5 needs huge amounts
> of memory but it is new so anyone deploying a new mlx5 configuration
> can set their cgroup accordingly.
> 
> If we fully do type 1 we are looking at alot of memory. eg a 1TB
> guest will charge 2GB just in IOPTE structures at 4k page size. Maybe
> that is enough to be a problem, I don't know.
> 
> > Potentially this removes the dma_avail issue as a means to
> > prevent userspace from creating an arbitrarily large number of DMA
> > mappings, right?  
> 
> Yes, it is what iommufd did
>  
> > Are there any compatibility issues we should expect with this change to
> > accounting otherwise?  
> 
> Other than things might start hitting the limit, I don't think so?

Ok, seems like enough FUD to limit the scope for now.  We'll need to
monitor this for native and compat mode iommufd use.  I'll fix the
commit log typo, assuming there are no further comments.  Thanks,

Alex

