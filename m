Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF72F6444F8
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 14:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbiLFNxC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 08:53:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbiLFNw6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 08:52:58 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2892AC4E
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 05:52:56 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id jl24so13952033plb.8
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 05:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t87VCeTJakslqAl3f0yNOxHf0LTh2ZN124YXucQTICI=;
        b=oZGCxyk5W3TMdU2o6vRqmJnJcYsYsbgQZVSOM118UHdICsH3wPjWdG68J6fsdeUwJJ
         LZjdlixk2hY+1rJAdlL5ClWxqqWJXOGkHw3uofhd5LW64YmHG0gTJHdph0anX+bb/9My
         jiDJujt3G7mvNF1/Fx9hDpNb6NDreKAF66YocfaiFEXNsIGJlveHzNomXypy1L28wwa2
         vgrb7StUm5lVgdw01n/1Sd3qqNYmdgviT+hKhkTj38U16G3HVYESw6VZgHmfCwwdeoXU
         BYxTR7YpicHMjA5z7L+fboO2DZA51Ze4QnenI7roy3++oRxN1gnjVynwB/LUaBTpYfEu
         /gpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t87VCeTJakslqAl3f0yNOxHf0LTh2ZN124YXucQTICI=;
        b=niVg/oO4h+Bul00HKjycYDPVYgl6kjG0wL/e0+amfupGXYH/qJJWxVDoEApwOGWlxu
         NBzeH6LehIiVLsnxxEr1RDi7dkxwLNgx6h6Qp+dHdVt8ZRGDz1DyzT2v5hrfLjKn+23n
         tM90UXHhZlaXtIXR1vHjHlGzhrd4hm+wxT9mPP2P/he6xihtjUNiHOkZ2aMCEk9UcWAe
         /FeQRRl6zUexhwvSJSTO13JLdYm7Ks6MXgd2+pe1/o80V7UQ7uiZIJcONbloE+FpUnFE
         +5nFhqJxvYbI8mVRWMalZs1s+VEiTyTzwUzqEOh6QuPKmlTBdhn2LhetXSHFTPdyRx58
         AFMg==
X-Gm-Message-State: ANoB5pkjYKVo0ZCFYhs7uQtcBAyDD9HCNYMzmXkX3WPF+K6XzL3vHzIZ
        mJ56CU8GQ2RAHihpj38WMy0jFg==
X-Google-Smtp-Source: AA0mqf482EjTSHDI4493LMS4boQvscR6VQMN38fEM7NnhASxT/N8ZFwDvLrAcycEwor9hfBksmUO8Q==
X-Received: by 2002:a17:90a:5998:b0:219:d33d:4689 with SMTP id l24-20020a17090a599800b00219d33d4689mr10666134pji.233.1670334775910;
        Tue, 06 Dec 2022 05:52:55 -0800 (PST)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id b16-20020aa79510000000b00574f83c5d51sm11772416pfp.198.2022.12.06.05.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 05:52:55 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p2YNS-004bct-0n;
        Tue, 06 Dec 2022 09:52:54 -0400
Date:   Tue, 6 Dec 2022 09:52:54 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Lei Rao <lei.rao@intel.com>, kbusch@kernel.org, axboe@fb.com,
        kch@nvidia.com, sagi@grimberg.me, alex.williamson@redhat.com,
        cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH 5/5] nvme-vfio: Add a document for the NVMe device
Message-ID: <Y49JNvdmRPNWw26q@ziepe.ca>
References: <20221206055816.292304-1-lei.rao@intel.com>
 <20221206055816.292304-6-lei.rao@intel.com>
 <20221206062604.GB6595@lst.de>
 <Y48+AaG5rSCviIhl@ziepe.ca>
 <20221206130901.GB24358@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206130901.GB24358@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 02:09:01PM +0100, Christoph Hellwig wrote:
> On Tue, Dec 06, 2022 at 09:05:05AM -0400, Jason Gunthorpe wrote:
> > In this case Intel has a real PCI SRIOV VF to expose to the guest,
> > with a full VF RID.
> 
> RID?

"Requester ID" - PCI SIG term that in Linux basically means you get to
assign an iommu_domain to the vfio device.

Compared to a mdev where many vfio devices will share the same RID and
cannot have iommu_domain's without using PASID.

> > The proper VFIO abstraction is the variant PCI
> > driver as this series does. We want to use the variant PCI drivers
> > because they properly encapsulate all the PCI behaviors (MSI, config
> > space, regions, reset, etc) without requiring re-implementation of this
> > in mdev drivers.
> 
> I don't think the code in this series has any chance of actually
> working.  There is a lot of state associated with a NVMe subsystem,
> controller and namespace, such as the serial number, subsystem NQN,
> namespace uniqueue identifiers, Get/Set features state, pending AENs,
> log page content.  Just migrating from one device to another without
> capturing all this has no chance of actually working.

From what I understood this series basically allows two Intel devices
to pass a big opaque blob of data. Intel didn't document what is in
that blob, so I assume it captures everything you mention above.

At least, that is the approach we have taken with mlx5. Every single
bit of device state is serialized into the blob and when the device
resumes it is indistinguishable from the original. Otherwise it is a
bug.

Jason
