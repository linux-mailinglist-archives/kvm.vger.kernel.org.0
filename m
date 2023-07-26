Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77283763F05
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 20:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjGZSvw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 14:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbjGZSvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 14:51:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03EDA1FF2
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 11:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690397460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QcbDGFNGyrYMflmHGqX/IsfCv+zGpwF2/bsKWDKJIp8=;
        b=Oa8D3BiAw8pyz0pIdO1sE8AyyXDBB5Oo4+mDPQPHDEvXWTzrzZduC21tGmGSG9EUSeciA9
        96UM9srAaMK6C60OpvQ/hM7Fdt8VegehbZDQOHU0bByIKgushShBz2RKF9toTCMGVy3W9L
        Fe7T4E2igBC5e/2XkcGEuqrdt5yXelE=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-288-dUkkYoGTPXGAemPbhD42Fw-1; Wed, 26 Jul 2023 14:50:58 -0400
X-MC-Unique: dUkkYoGTPXGAemPbhD42Fw-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-348c5e4690cso337915ab.2
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 11:50:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690397458; x=1691002258;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QcbDGFNGyrYMflmHGqX/IsfCv+zGpwF2/bsKWDKJIp8=;
        b=TpHXl4EbFco91tu5kyxd0Ww5TL/aJuWCokb3NyeH0Y3u+JXMW8quVLiAKnysQEcHET
         wSTLzyP0jEZxezkNvkbgfyTkypDyyN6teky01DIrLo+RP5SDnvl2O9W5wCMmkJKSWLGC
         /J3zyiw8sXflX1Y0X0liC3kikm7j5Z20+SDxSD8vEk1o841/E4arYc0VO541l26SELef
         ki1kZuU0L7vo45im4VecAX3LHrxGo/UtGgL+LV198kDbeCYsb144G0KAxBZ47OZ8xDEm
         tmug8PMdh0Snpj4ZS5eDmIbjriq2VKx829L4uqdyWQpBBq65KSuCCJ3UtEHH6LqmaMLO
         maHg==
X-Gm-Message-State: ABy/qLbz8w4rVttkExITeYKPiQoX9Jt2A7ZwBt/dziB6z8KTODggsDB0
        J/aKrpeXtgzMBvycRoeJTvYycmabP4RwV2zpK0fHRQClVBV1LP3EaQNticNgRXIV/UrHYngjXno
        MYrPsaf2BuTFs
X-Received: by 2002:a05:6e02:1d9b:b0:348:f0a2:84e9 with SMTP id h27-20020a056e021d9b00b00348f0a284e9mr1629871ila.15.1690397458018;
        Wed, 26 Jul 2023 11:50:58 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGWr9KN/3gmDtc0e/YmU+TWLlciolPJwB74ehqdkPyMuqmq6grQvJuksTfuEqTpJIXP53zVJQ==
X-Received: by 2002:a05:6e02:1d9b:b0:348:f0a2:84e9 with SMTP id h27-20020a056e021d9b00b00348f0a284e9mr1629849ila.15.1690397457788;
        Wed, 26 Jul 2023 11:50:57 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id g10-20020a02c54a000000b0042b6ae47f0esm4454923jaj.108.2023.07.26.11.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 11:50:57 -0700 (PDT)
Date:   Wed, 26 Jul 2023 12:50:51 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        simon.horman@corigine.com, shannon.nelson@amd.com
Subject: Re: [PATCH v13 vfio 0/7] pds-vfio-pci driver
Message-ID: <20230726125051.424ed592.alex.williamson@redhat.com>
In-Reply-To: <ZMEhCrZDNLSrWP/5@nvidia.com>
References: <20230725214025.9288-1-brett.creeley@amd.com>
        <ZMEhCrZDNLSrWP/5@nvidia.com>
Organization: Red Hat
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

On Wed, 26 Jul 2023 10:35:06 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jul 25, 2023 at 02:40:18PM -0700, Brett Creeley wrote:
> 
> > Note: This series is based on the latest linux-next tree. I did not base
> > it on the Alex Williamson's vfio/next because it has not yet pulled in
> > the latest changes which include the pds_vdpa driver. The pds_vdpa
> > driver has conflicts with the pds-vfio-pci driver that needed to be
> > resolved, which is why this series is based on the latest linux-next
> > tree.  
> 
> This is not the right way to handle this, Alex cannot apply a series
> against linux-next.
> 
> If you can't make a shared branch and the conflicts are too
> significant to forward to Linus then you have to wait for the next
> cycle.

Brett, can you elaborate on what's missing from my next branch vs
linux-next?

AFAICT the pds_vdpa driver went into mainline via a8d70602b186 ("Merge
tag 'for_linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost") during the
v6.5 merge window and I'm not spotting anything in linux-next obviously
relevant to pds-vfio-pci since then.

There's a debugfs fix on the list, but that's sufficiently trivial to
fixup on merge if necessary.  This series also applies cleanly vs my
current next branch.  Was the issue simply that I hadn't updated my
next branch (done yesterday) since the v6.5 merge window?  You can
always send patches vs mainline.  Thanks,

Alex

