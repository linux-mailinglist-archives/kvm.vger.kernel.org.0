Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FEA63CA2E
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 22:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237041AbiK2VML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 16:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237054AbiK2VL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 16:11:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497206CA3D
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 13:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669756236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k698xTv8b1qqm1dRRZgevYpv3znOLNXUsBrj1mzERPk=;
        b=Ye6yI4mEPBEOfA7lLww9Iqqv9RZaFZAslJdbmvQOVMfz8s81ah/1lD1SHngRbkmJ29XGCj
        QFJb1xdrxi5sMJQoDtBOoTq1B6tURf3LJQxC6LDjl2NheQ+Zk7WV6zOFBI/7GG7D6TOMNy
        qC8BBSaRmkF3slyiQkc6iHRRP9N+yKw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-454-7UdCrHpgMlKuIBOrlfKDXQ-1; Tue, 29 Nov 2022 16:10:32 -0500
X-MC-Unique: 7UdCrHpgMlKuIBOrlfKDXQ-1
Received: by mail-wm1-f70.google.com with SMTP id m34-20020a05600c3b2200b003cf549cb32bso10803847wms.1
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 13:10:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k698xTv8b1qqm1dRRZgevYpv3znOLNXUsBrj1mzERPk=;
        b=0rjMXvHsBmak73N8sqQb7sncmQPxbTQM+IFc2zx5r8ZpTpo9j5ooRB4zwPx53b9CEU
         EBIwTpUDgaZcrvlxIkf/gkxtRYwRdigGXKvXhla3tuCkTfPQvrSng1ESaXqvesyBaOVu
         GYwzoJ45FBx/ArdTnrngi3u+1AcOfJsJ6Ohy7haWAB5qPwYk7daxsr32x+iN6qkqxcs4
         rxDa86HfXIL5m27Xy1WehbxEX5IbShgO36E9WUkEjf5mvDKw2e1b6nZ8AHwBX/DiZ0QP
         UOdJDfkdVZ6oXtCQEvpVAXUC/LAtMRr0PBZX7/h/nY2wt1iypvdFLuwH/vMWv/UyELhA
         b9MA==
X-Gm-Message-State: ANoB5pn5T3uytOjmu41/y/Br4zktZv69dAypSShoKUtA4QxYQm7rlAU0
        wQKHUs09L3gol0XMYoGeWfsQw/08ek433r956cBOm/x+hUTolkNzMm31ijbACfUBxn5tx+/Cb6L
        fTU6Q0DVRMlbu
X-Received: by 2002:a5d:46d0:0:b0:242:91c:a12f with SMTP id g16-20020a5d46d0000000b00242091ca12fmr12901688wrs.524.1669756231199;
        Tue, 29 Nov 2022 13:10:31 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6+iPW2bfSUBCiA/vEABdm4r2E99sY8GFRM5gUzIgdbDggVKb5d5xIs/N7xro3zHpnqh3uj+Q==
X-Received: by 2002:a5d:46d0:0:b0:242:91c:a12f with SMTP id g16-20020a5d46d0000000b00242091ca12fmr12901684wrs.524.1669756230981;
        Tue, 29 Nov 2022 13:10:30 -0800 (PST)
Received: from redhat.com ([2.52.149.178])
        by smtp.gmail.com with ESMTPSA id i28-20020a05600c4b1c00b003cfd4e6400csm3259683wmp.19.2022.11.29.13.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 13:10:30 -0800 (PST)
Date:   Tue, 29 Nov 2022 16:10:25 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH v6 07/19] kernel/user: Allow user::locked_vm to be usable
 for iommufd
Message-ID: <20221129160444-mutt-send-email-mst@kernel.org>
References: <0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
 <7-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
 <20221129154048-mutt-send-email-mst@kernel.org>
 <Y4ZwEJotH0U0Qzt7@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4ZwEJotH0U0Qzt7@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 29, 2022 at 04:48:16PM -0400, Jason Gunthorpe wrote:
> On Tue, Nov 29, 2022 at 03:42:23PM -0500, Michael S. Tsirkin wrote:
> > On Tue, Nov 29, 2022 at 04:29:30PM -0400, Jason Gunthorpe wrote:
> > > Following the pattern of io_uring, perf, skb, and bpf, iommfd will use
> > > user->locked_vm for accounting pinned pages. Ensure the value is included
> > > in the struct and export free_uid() as iommufd is modular.
> > > 
> > > user->locked_vm is the good accounting to use for ulimit because it is
> > > per-user, and the security sandboxing of locked pages is not supposed to
> > > be per-process. Other places (vfio, vdpa and infiniband) have used
> > > mm->pinned_vm and/or mm->locked_vm for accounting pinned pages, but this
> > > is only per-process and inconsistent with the new FOLL_LONGTERM users in
> > > the kernel.
> > > 
> > > Concurrent work is underway to try to put this in a cgroup, so everything
> > > can be consistent and the kernel can provide a FOLL_LONGTERM limit that
> > > actually provides security.
> > > 
> > > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > > Tested-by: Yi Liu <yi.l.liu@intel.com>
> > > Tested-by: Lixiao Yang <lixiao.yang@intel.com>
> > > Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > > Reviewed-by: Eric Auger <eric.auger@redhat.com>
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > Just curious: why does the subject say "user::locked_vm"? As opposed to
> > user->locked_vm? Made me think it's somehow related to rust in kernel or
> > whatever.
> 
> :: is the C++ way to say "member of a type", I suppose it is a typo
> and should be user_struct::locked_vm
> 
> The use of -> otherwise was to have some clarity about mm vs user
> structs.
> 
> Jason

I note that commit log says user->locked_vm and that's clear enough
IMHO, I'd leave C++ alone - IIRC yes you can write ptr->type::field but
no one does so it's not idiomatic, :: is more commonly used with static
members there. So this confuses more than it clarifies. But whatever,
hardly a blocker. Feel free to ignore.

-- 
MST

