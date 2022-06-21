Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5BF55381A
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 18:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350436AbiFUQlw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 12:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbiFUQlv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 12:41:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 159F420199
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 09:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655829710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0weVDdARkMHQItVNjN/m3+YbiiXoPZO+JTau5QeB1Ls=;
        b=OF/optmieS/wCN2Tx09ur6Zvgy9oCYf9PISoLmU/FDJ4uc/vwKMEnZQixlQ1P2gWbyU158
        q1CWxubH5X2Qj2bIP5Sg/8Kc3kBKAyzzdQHRAuTGYmJ6BaZszQXhHzcaaDjZgF9Dy3ndQ2
        G4LJVCi+VD22E2yKSKiPxM1V8QQG5dQ=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509--Zs8Pnu_MUqp-SPUgbXbag-1; Tue, 21 Jun 2022 12:41:48 -0400
X-MC-Unique: -Zs8Pnu_MUqp-SPUgbXbag-1
Received: by mail-il1-f197.google.com with SMTP id s15-20020a056e02216f00b002d3d5e41565so9500924ilv.10
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 09:41:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0weVDdARkMHQItVNjN/m3+YbiiXoPZO+JTau5QeB1Ls=;
        b=H5+bSbwfEv5rEIyOLsPOTxYyCO0YkHg6/lHlUb1V5tzx390JXTcepHWhdByJOFe8dG
         K+Y22eSvzjH2Xku7Bhb187NaTVePRHR5NHs8NKWWhPeRDJZ/rmOGxypnySS9HCAMsMhF
         Sh56VfQ98/WajFlY9VWSfGmn6ujKJO85gJF80awd34MG6P/nIJ/aZ1dNVy9ypSdNSApJ
         nJijiswHHhT53nhEoTgMvCz2GJDiKHlK/Rre+WB5l7k2NL+j/SDKAI/LUU/g1Rk+Gtg+
         RbtsT1j0LYKRm/xqAwDf0sdNpZBWtFq6PvLhNLTCIN9vQbp3WZoDmldLSkuDVfLwCl/g
         9xXQ==
X-Gm-Message-State: AJIora+GfKAY+aoOwYNnFUH9LfNa71bSHZCWSTd9DdyTjReGThwiiBaY
        TQP7nWCWYTaTu1Jjy2CRn4NPskLwWVRamBWG95kUCzr/dWekT0+Mq5Hia+XQANX9Xyn/3y4I4Ep
        pK1PZGAKHDtfq
X-Received: by 2002:a05:6638:35a3:b0:331:e055:cf6e with SMTP id v35-20020a05663835a300b00331e055cf6emr17694173jal.250.1655829708318;
        Tue, 21 Jun 2022 09:41:48 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tMl2lMqLwkVb1MYAeKQCs3mj7W8IOsRoMY/9K4B0VYzGr+qnNSAR4kbThOFxmaM43CMLuqUA==
X-Received: by 2002:a05:6638:35a3:b0:331:e055:cf6e with SMTP id v35-20020a05663835a300b00331e055cf6emr17694155jal.250.1655829708135;
        Tue, 21 Jun 2022 09:41:48 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id d14-20020a92d5ce000000b002d53be43069sm7687648ilq.64.2022.06.21.09.41.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 09:41:47 -0700 (PDT)
Date:   Tue, 21 Jun 2022 10:41:46 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        liulongfang <liulongfang@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH vfio 2/2] vfio: Split migration ops from main device ops
Message-ID: <20220621104146.368b429a.alex.williamson@redhat.com>
In-Reply-To: <20220620034909.GC5219@nvidia.com>
References: <20220606085619.7757-1-yishaih@nvidia.com>
        <20220606085619.7757-3-yishaih@nvidia.com>
        <BN9PR11MB5276F5548A4448B506A8F66A8CA69@BN9PR11MB5276.namprd11.prod.outlook.com>
        <2c917ec1-6d4f-50a4-a391-8029c3a3228b@nvidia.com>
        <5d54c7dc-0c80-5125-9336-c672e0f29cd1@nvidia.com>
        <20220616170118.497620ba.alex.williamson@redhat.com>
        <6f6b36765fe9408f902d1d644b149df3@huawei.com>
        <20220617084723.00298d67.alex.williamson@redhat.com>
        <4f14e015-e4f7-7632-3cd7-0e644ed05c99@nvidia.com>
        <20220620034909.GC5219@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Jun 2022 00:49:09 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Sun, Jun 19, 2022 at 12:25:50PM +0300, Yishai Hadas wrote:
> 
> > Means, staying with a single device_ops but just inline a check whether
> > migration is really supported inside the migration get/set state callbacks
> > and let the core call it unconditionally.  
> 
> I find it much cleaner to have op == NULL means unsupported.
> 
> As soon as you start linking supported/unsupported to other flags it
> can get very complicated fairly fast. I have this experiance from RDMA
> where we've spent a long time now ripping out hundreds of flag tests
> and replacing them with NULL op checks. Many bugs were fixed doing
> this as drivers never fully understood what the flags mean and ended
> up with flags set that their driver doesn't properly implement.
> 
> The mistake we made in RDMA was not splitting the ops, instead the ops
> were left mutable so the driver could load the right combination based
> on HW ability.

I don't really have an issue with splitting the ops, but what
techniques have you learned from RDMA to make drivers setting ops less
ad-hoc than proposed here?  Are drivers expected to set ops before a
formally defined registration point?  Can ops be dynamically modified?
Is there an API for setting ops or is it open coded per driver?

We probably don't need this series to propose a solution to the
hisi-acc name field usage vs vfio-pci-core SR-IOV driver_override
usage, but let's put it on a to-do list somewhere.  Thanks,

Alex

