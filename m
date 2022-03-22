Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6584E42FD
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 16:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235811AbiCVPbD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 11:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234254AbiCVPbB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 11:31:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50A0A82D1B
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 08:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647962968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MScNzTeLACv/blJ5opJ1hO/EvqNLQgxKvQznIBl9/rI=;
        b=E9jrwPNR20M6JkOv9ABcg+lZCrjTlItJm6UKTeIAl8sBuuj72I6Ee0+dZ4CVQrFhc65b8d
        XcpTATY0KAv6VMr1mjPqwUl/YDVv8TjggU90xKuO8fTY7ezqLL0sKaKvPUMIS0WRQ3OMRQ
        4oDhbcMoYPezNzU2O0z4U6ZaW+dOtZA=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-iqq8GRH5OP2EzXTXoqjqeQ-1; Tue, 22 Mar 2022 11:29:27 -0400
X-MC-Unique: iqq8GRH5OP2EzXTXoqjqeQ-1
Received: by mail-io1-f69.google.com with SMTP id b15-20020a05660214cf00b00648a910b964so12651004iow.19
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 08:29:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=MScNzTeLACv/blJ5opJ1hO/EvqNLQgxKvQznIBl9/rI=;
        b=eelwsuPhW61F7aJG+cTGvL3Ot1BJbcMYloeUGxy4+jOCEc7QbaoGUqrGVdr7iP2Jch
         g9V6OIm7UAmwKCO2OA+rfcgK1w4wJncECQ0BXHsaczsiU/iSXwEYsykLsPeIGXN/dHx+
         9Ka2vNCeRs9m0QUHKJ+STT5fK2t75a8AB1IfLExcZ3Op3FLxHSp36d7LGOLUgUEPK6rI
         WwGDgU3r+UPLyxFzYX6vmaD2Ks7OVl5jmA4tSwSEi6vF+vD8thsfARxD6YtWY6Sopu2X
         SV9z8TxIioGmuqYyjpj8ADbaWpZsoTQKcddUBFTtb5RGQAl6BoLCi1v+07FT/Sta+7Xb
         F3nw==
X-Gm-Message-State: AOAM532KI2HIg3R9CKT77IUjbQP4m0YJeinr3UvgQnRbjoW6ybQk5Fcp
        adfdi/sn14/hBZdY7yj9K6qEhK1udjD+ZVppdxEwUP5QZa4LiNScg/IEmRgur891yoVgynrJ18U
        NzpylRM0BzaM+
X-Received: by 2002:a05:6e02:154f:b0:2c7:d5da:f12f with SMTP id j15-20020a056e02154f00b002c7d5daf12fmr12617535ilu.66.1647962966470;
        Tue, 22 Mar 2022 08:29:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbHmZV3ynK+/wJmFgzfxYFXrwfco3PQ0Ay6mx5+mA3xyESZZvxvI4GkxLR+NiZ77fhbkDDvQ==
X-Received: by 2002:a05:6e02:154f:b0:2c7:d5da:f12f with SMTP id j15-20020a056e02154f00b002c7d5daf12fmr12617512ilu.66.1647962966167;
        Tue, 22 Mar 2022 08:29:26 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i11-20020a056e021b0b00b002c83d5df5a2sm1727094ilv.81.2022.03.22.08.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 08:29:25 -0700 (PDT)
Date:   Tue, 22 Mar 2022 09:29:23 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be
 usable for iommufd
Message-ID: <20220322092923.5bc79861.alex.williamson@redhat.com>
In-Reply-To: <20220322145741.GH11336@nvidia.com>
References: <4-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
        <808a871b3918dc067031085de3e8af6b49c6ef89.camel@linux.ibm.com>
        <20220322145741.GH11336@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Mar 2022 11:57:41 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Mar 22, 2022 at 03:28:22PM +0100, Niklas Schnelle wrote:
> > On Fri, 2022-03-18 at 14:27 -0300, Jason Gunthorpe wrote:  
> > > 
> > > user->locked_vm is the correct accounting to use for ulimit because it is
> > > per-user, and the ulimit is not supposed to be per-process. Other
> > > places (vfio, vdpa and infiniband) have used mm->pinned_vm and/or
> > > mm->locked_vm for accounting pinned pages, but this is only per-process
> > > and inconsistent with the majority of the kernel.  
> > 
> > Since this will replace parts of vfio this difference seems
> > significant. Can you explain this a bit more?  
> 
> I'm not sure what to say more, this is the correct way to account for
> this. It is natural to see it is right because the ulimit is supposted
> to be global to the user, not effectively reset every time the user
> creates a new process.
> 
> So checking the ulimit against a per-process variable in the mm_struct
> doesn't make too much sense.

I'm still picking my way through the series, but the later compat
interface doesn't mention this difference as an outstanding issue.
Doesn't this difference need to be accounted in how libvirt manages VM
resource limits?  AIUI libvirt uses some form of prlimit(2) to set
process locked memory limits.  A compat interface might be an
interesting feature, but does it only provide ioctl compatibility and
not resource ulimit compatibility?  Thanks,

Alex

