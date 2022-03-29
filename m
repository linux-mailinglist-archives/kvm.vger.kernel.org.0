Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686234EA6CC
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 07:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbiC2FB4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 01:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbiC2FBw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 01:01:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF1A52487BB
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 22:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648530008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K7gDC8bShBI9LHGd+WbA3yzlonPiUS4KeezNJU72OYg=;
        b=grjuVmqOEmBAhW/fn9RtvwkJ2NeomTQ9y85NU1x7db60r8cpjhQ6LV+1SFBn9c6SaxEiTw
        2UVccnNkjVoX8flKkLevlNwDAx6ob/TXZ+drHX+2v7qzbiEb9AtqM9p2FIct3HaP3FzFpn
        7GXutrIn8YvhcQff2SfGCHztbr8ElHg=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-SzwVtFv2P5mW37NsBEybSg-1; Tue, 29 Mar 2022 01:00:05 -0400
X-MC-Unique: SzwVtFv2P5mW37NsBEybSg-1
Received: by mail-lj1-f200.google.com with SMTP id v6-20020a2e9246000000b002497a227e15so6992360ljg.4
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 22:00:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K7gDC8bShBI9LHGd+WbA3yzlonPiUS4KeezNJU72OYg=;
        b=AMFF8QzkyJKEXfL3W3BA2VjZplPd5A79w7zZj/N88e1cpprcRSphWV6KeZroEwkXbH
         LtSDN0jwPTA3cQPSYysc9coJCGBQr2wa2fl7nMXtZ0FdjauPnZBoOf6c8mlHY1YcGmZU
         31xFvD3E/00CyHIfVYxJZEDr9L9xrumzHaSzmKATvKQPwCKHKJ5iAB4tRx63yEj1htgz
         15fYSFUb5frv4nh3oR1T1ML3+6IxoiPsO5UCuICWJEx1bfiwonOc3M/WTSsRayEVEFiM
         3JdzD7U0rHFuYp48Z/eJ3bCIqtXFSJ3eC1NQqo3pbMzO3sxMIwKAwuBaivPkahcQZmAh
         JtzA==
X-Gm-Message-State: AOAM532dAEL9e3UctkO08Vuct60EdB24i0uNghyE+32lrse6U+zqgmiw
        +wQocOID3ZWLz6Z2dBnQjzhxFmTbyFKS8rY0FJsN1dETEEYSpk4OWe10sjfdD4pSzzbX9JUZkxs
        BdNwGB1X8MyR6SB6eki+Tqx6y9Xlt
X-Received: by 2002:a05:6512:2203:b0:44a:12c9:8696 with SMTP id h3-20020a056512220300b0044a12c98696mr993986lfu.98.1648530003439;
        Mon, 28 Mar 2022 22:00:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfk6lHA5WhshEQEE6YBIv+08Bg/UEgteU+mmeSwvo4lkCbmpArIaObJ6kzGXap+UvxE8xNiz9kZzmdXgTc6hA=
X-Received: by 2002:a05:6512:2203:b0:44a:12c9:8696 with SMTP id
 h3-20020a056512220300b0044a12c98696mr993973lfu.98.1648530003271; Mon, 28 Mar
 2022 22:00:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220322092923.5bc79861.alex.williamson@redhat.com>
 <20220322161521.GJ11336@nvidia.com> <BN9PR11MB5276BED72D82280C0A4C6F0C8C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEutpbOc_+5n3SDuNDyHn19jSH4ukSM9i0SUgWmXDydxnA@mail.gmail.com>
 <BN9PR11MB5276E3566D633CEE245004D08C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEvTmCFqAsc4z=2OXOdr7X--0BSDpH06kCiAP5MHBjaZtg@mail.gmail.com>
 <BN9PR11MB5276ECF1F1C7D0A80DA086D18C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEtpWemw6tj=suxNjvSHuixyzhMJBYmqdbhQkinuWNADCQ@mail.gmail.com>
 <20220324114605.GX11336@nvidia.com> <CACGkMEtTVMuc-JebEbTrb3vRUVaNJ28FV_VyFRdRquVQN9VeQA@mail.gmail.com>
 <20220328122239.GL1342626@nvidia.com>
In-Reply-To: <20220328122239.GL1342626@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 29 Mar 2022 12:59:52 +0800
Message-ID: <CACGkMEu_Zc+xBR0G9qNR6XQKNY9MLfTvbpgzpL2kNC4ri3DRQg@mail.gmail.com>
Subject: Re: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be usable
 for iommufd
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Sean Mooney <smooney@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 28, 2022 at 8:23 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Mon, Mar 28, 2022 at 09:53:27AM +0800, Jason Wang wrote:
> > To me, it looks more easier to not answer this question by letting
> > userspace know about the change,
>
> That is not backwards compatbile, so I don't think it helps unless we
> say if you open /dev/vfio/vfio you get old behavior and if you open
> /dev/iommu you get new...

Actually, this is one way to go. Trying to behave exactly like typ1
might be not easy.

>
> Nor does it answer if I can fix RDMA or not :\
>

vDPA has a backend feature negotiation, then actually, userspace can
tell vDPA to go with the new accounting approach. Not sure RDMA can do
the same.

Thanks

> So we really do need to know what exactly is the situation here.
>
> Jason
>

