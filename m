Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C979569A8E8
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 11:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjBQKMf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 05:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjBQKMc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 05:12:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB66604E5
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 02:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676628706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dvpK31b66LZjOlbG0RKceUyJP6Xe2y/6MQclDivAbW8=;
        b=a162mr4qXZaVlzcIKbKIwdArdg9ZR32w3iHdjSPwfZDn5WRO2s4I3ANQEQHfncjmTX6rSR
        I1WJviZxOYssxqU1zGAE91d0rdPxwnQm6FKap1pUM/cCaNV+3xVK5A/JbDXae5HrRA4Li7
        Kg4lcWA77wlBotkB9hXxBpWQnV+lvI0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-79-GJlo0kLbPlucM8EZIYy_JA-1; Fri, 17 Feb 2023 05:11:44 -0500
X-MC-Unique: GJlo0kLbPlucM8EZIYy_JA-1
Received: by mail-wr1-f70.google.com with SMTP id b13-20020adfde0d000000b002c559840c76so14380wrm.3
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 02:11:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dvpK31b66LZjOlbG0RKceUyJP6Xe2y/6MQclDivAbW8=;
        b=6Tum0EgSoi+M6AvVWUOl36bLPx3uGyZwAqRvpp3AxzJFxdAhlzRjCJsCRarddm35k2
         M06IyuX42fY4k8OaOz4P5ayZ3oHmJKa/FY/7KXqzn8u2RUQBVjDNscikwPtcMXbrM/34
         1/ONAWVQQcp3/MiFZg1Sa1XrDl3y5eOnSkUxyfZkvu8CIR86B1tslKAIIOJGExamTUcl
         M6U7y9Y4fDdXtYeMvPjx0ztvXt0F8TOdhBXkBA84K41LCT/RU/W+LhaDOv2R8yfgw5kq
         h5+f5/iFmx1XL25BDkopGUXp57xixFPYlhYAlfHFh0UYH7GS9nBwAWkGveYAM1Bd7StJ
         obfA==
X-Gm-Message-State: AO0yUKWAql5ieakxcg1EUAP2aflYW+IQFL+oK52yP92L+o5F/oZIYsOR
        R93hfj8sTuXZTUn+xgloijl2Nh1dPhjX8yHhjiR0jSA8LeVCstlwuajNZgYpzbzDYivVD05gROW
        VsqENxVynVtWW
X-Received: by 2002:a05:600c:4d21:b0:3d9:f769:2115 with SMTP id u33-20020a05600c4d2100b003d9f7692115mr188607wmp.26.1676628703386;
        Fri, 17 Feb 2023 02:11:43 -0800 (PST)
X-Google-Smtp-Source: AK7set+Kcg4izxtCX4bYTTRixMiAEVt9Z6ixnz/KbWXmJ3fdzzSg3LAlSGK6fov0vMkMCzQhoGEOjA==
X-Received: by 2002:a05:600c:4d21:b0:3d9:f769:2115 with SMTP id u33-20020a05600c4d2100b003d9f7692115mr188590wmp.26.1676628703126;
        Fri, 17 Feb 2023 02:11:43 -0800 (PST)
Received: from redhat.com ([2.52.5.34])
        by smtp.gmail.com with ESMTPSA id az5-20020a05600c600500b003e20a6fd604sm4644634wmb.4.2023.02.17.02.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 02:11:42 -0800 (PST)
Date:   Fri, 17 Feb 2023 05:11:38 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Nanyong Sun <sunnanyong@huawei.com>, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        wangrong68@huawei.com
Subject: Re: [PATCH v2] vhost/vdpa: Add MSI translation tables to iommu for
 software-managed MSI
Message-ID: <20230217051038-mutt-send-email-mst@kernel.org>
References: <20230207120843.1580403-1-sunnanyong@huawei.com>
 <Y+7G+tiBCjKYnxcZ@nvidia.com>
 <CACGkMEtehykvqNUnfCi0VmHR1xpmhj4sSWdYW1-0oATY=0YhXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEtehykvqNUnfCi0VmHR1xpmhj4sSWdYW1-0oATY=0YhXw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 17, 2023 at 01:35:59PM +0800, Jason Wang wrote:
> On Fri, Feb 17, 2023 at 8:15 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Tue, Feb 07, 2023 at 08:08:43PM +0800, Nanyong Sun wrote:
> > > From: Rong Wang <wangrong68@huawei.com>
> > >
> > > Once enable iommu domain for one device, the MSI
> > > translation tables have to be there for software-managed MSI.
> > > Otherwise, platform with software-managed MSI without an
> > > irq bypass function, can not get a correct memory write event
> > > from pcie, will not get irqs.
> > > The solution is to obtain the MSI phy base address from
> > > iommu reserved region, and set it to iommu MSI cookie,
> > > then translation tables will be created while request irq.
> >
> > Probably not what anyone wants to hear, but I would prefer we not add
> > more uses of this stuff. It looks like we have to get rid of
> > iommu_get_msi_cookie() :\
> >
> > I'd like it if vdpa could move to iommufd not keep copying stuff from
> > it..
> 
> Yes, but we probably need a patch for -stable.

Hmm do we? this looks like it's enabling new platforms is not a bugfix...

> >
> > Also the iommu_group_has_isolated_msi() check is missing on the vdpa
> > path, and it is missing the iommu ownership mechanism.
> 
> Ok.
> 
> >
> > Also which in-tree VDPA driver that uses the iommu runs on ARM? Please
> 
> ifcvf and vp_vpda are two drivers that use platform IOMMU.
> 
> Thanks
> 
> > don't propose core changes for unmerged drivers. :(
> >
> > Jason
> >

