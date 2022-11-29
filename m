Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B0363C97F
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235880AbiK2Unk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:43:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233673AbiK2Uni (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:43:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE63F39
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669754553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ORCjmiGb/K/55tEXTBQQi1bJm0eRrca3JaXl3fCWtkw=;
        b=DrxofvLCRjXirT/jJXnoCf8qzwNJnrIditNr9qA2wCf6JkeY6ciLhyB003qPyH7dZoWQeU
        lBQYpd/J8oCxFzncMn1i6mKTYVVZw9tPmvcb6PKtsbMVhYgdlfENC05l49kvfatvJ1cQdo
        IBM8qJyG/jzPFXeIvNNUtA16gkvlUn4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-425-APttIDruM4qKN8Ah7l23tA-1; Tue, 29 Nov 2022 15:42:31 -0500
X-MC-Unique: APttIDruM4qKN8Ah7l23tA-1
Received: by mail-wr1-f71.google.com with SMTP id l8-20020adfc788000000b00241ef50e89eso3087775wrg.0
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:42:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ORCjmiGb/K/55tEXTBQQi1bJm0eRrca3JaXl3fCWtkw=;
        b=TuH6um6L+znisWcIc6cNRHHtlONg67c5zXEk1WAMS/Ef++6gFhofXLuntH/CjNPToU
         AF/VNZiN7/RyZa0tppwghdJ4fajXJUCHn5U+CNB1OXiFRdmu6jFx7kPSbxA/kkrhjmpR
         /x9h+mdZpzCVO3vU/9Yf5C6ZI3JA2iEb2VCupEoRKtKQVlHvFJ36BhqQE8xDB6knIezV
         8hWxqw20sJUGEz2NwVzpnpUI6bXpKILslGPk/yO97GtU2m0d8Bm74CXjnB/FcjBn2DkL
         SnPXQmhM/0s9lOWY8Idg51CbUOVC5dgMOp0ksjH45WeLq7fjZt/w76XuIjWpteSWh8u3
         GvUg==
X-Gm-Message-State: ANoB5pk/dfWNoOKopsW5vmkBjqPMbyyNMelinzevkVqSGQ5pOGwxeFu0
        OPXvQH8iOhih4bQ+o9IEw0xjRF3ub/0N2WeIzNMOrqjCJaaSb4aF0fMhHzuT48uDsm0mmY5lRrR
        j9Z106uTE6F8y
X-Received: by 2002:a05:6000:691:b0:241:b92b:d086 with SMTP id bo17-20020a056000069100b00241b92bd086mr36364808wrb.259.1669754550274;
        Tue, 29 Nov 2022 12:42:30 -0800 (PST)
X-Google-Smtp-Source: AA0mqf63ZsyYy47GtAtEWEyrk5xpOClIukNmSA71TCq1WrQI5aN9Cx4NyxS/92+TDYLGEWXsJMj+0A==
X-Received: by 2002:a05:6000:691:b0:241:b92b:d086 with SMTP id bo17-20020a056000069100b00241b92bd086mr36364796wrb.259.1669754550033;
        Tue, 29 Nov 2022 12:42:30 -0800 (PST)
Received: from redhat.com ([2.52.149.178])
        by smtp.gmail.com with ESMTPSA id r4-20020a0560001b8400b00241bd7a7165sm14614156wru.82.2022.11.29.12.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 12:42:29 -0800 (PST)
Date:   Tue, 29 Nov 2022 15:42:23 -0500
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
Message-ID: <20221129154048-mutt-send-email-mst@kernel.org>
References: <0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
 <7-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 29, 2022 at 04:29:30PM -0400, Jason Gunthorpe wrote:
> Following the pattern of io_uring, perf, skb, and bpf, iommfd will use
> user->locked_vm for accounting pinned pages. Ensure the value is included
> in the struct and export free_uid() as iommufd is modular.
> 
> user->locked_vm is the good accounting to use for ulimit because it is
> per-user, and the security sandboxing of locked pages is not supposed to
> be per-process. Other places (vfio, vdpa and infiniband) have used
> mm->pinned_vm and/or mm->locked_vm for accounting pinned pages, but this
> is only per-process and inconsistent with the new FOLL_LONGTERM users in
> the kernel.
> 
> Concurrent work is underway to try to put this in a cgroup, so everything
> can be consistent and the kernel can provide a FOLL_LONGTERM limit that
> actually provides security.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Yi Liu <yi.l.liu@intel.com>
> Tested-by: Lixiao Yang <lixiao.yang@intel.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Just curious: why does the subject say "user::locked_vm"? As opposed to
user->locked_vm? Made me think it's somehow related to rust in kernel or
whatever.

> ---
>  include/linux/sched/user.h | 2 +-
>  kernel/user.c              | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/sched/user.h b/include/linux/sched/user.h
> index f054d0360a7533..4cc52698e214e2 100644
> --- a/include/linux/sched/user.h
> +++ b/include/linux/sched/user.h
> @@ -25,7 +25,7 @@ struct user_struct {
>  
>  #if defined(CONFIG_PERF_EVENTS) || defined(CONFIG_BPF_SYSCALL) || \
>  	defined(CONFIG_NET) || defined(CONFIG_IO_URING) || \
> -	defined(CONFIG_VFIO_PCI_ZDEV_KVM)
> +	defined(CONFIG_VFIO_PCI_ZDEV_KVM) || IS_ENABLED(CONFIG_IOMMUFD)
>  	atomic_long_t locked_vm;
>  #endif
>  #ifdef CONFIG_WATCH_QUEUE
> diff --git a/kernel/user.c b/kernel/user.c
> index e2cf8c22b539a7..d667debeafd609 100644
> --- a/kernel/user.c
> +++ b/kernel/user.c
> @@ -185,6 +185,7 @@ void free_uid(struct user_struct *up)
>  	if (refcount_dec_and_lock_irqsave(&up->__count, &uidhash_lock, &flags))
>  		free_user(up, flags);
>  }
> +EXPORT_SYMBOL_GPL(free_uid);
>  
>  struct user_struct *alloc_uid(kuid_t uid)
>  {
> -- 
> 2.38.1

