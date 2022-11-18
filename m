Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3FDD62F09A
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 10:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241759AbiKRJK3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 04:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241755AbiKRJK2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 04:10:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313D8140DB
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 01:09:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668762572;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xeXTZcuI1CLep2o2KomhSyxmx0lROJCn0LGc6rXRQUg=;
        b=a9ggwPHCMc6NIaabB4Okt2j+I6+Wx6Mk1vrRQMELI6IjtLRYRdDj+yKKYKF9JbtFXDqhTt
        4vnEtnDv25Rp/8nG8h1C8ki3Q4Cd3d9hCSl2D8pPl95gqpGMnTxmIVY69HZHnsS/96D0Fn
        Nfnsq7oWK3lRo/5vpgoGCApqEF9HEPg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-550-b3BjAAmqMlaBskbH3quRrw-1; Fri, 18 Nov 2022 04:09:30 -0500
X-MC-Unique: b3BjAAmqMlaBskbH3quRrw-1
Received: by mail-wm1-f72.google.com with SMTP id m34-20020a05600c3b2200b003cf549cb32bso4185686wms.1
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 01:09:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xeXTZcuI1CLep2o2KomhSyxmx0lROJCn0LGc6rXRQUg=;
        b=H2McMzr89OVNP1C4s/GnLjsOP6I0UG3UBPi8wCdp63QIgDNmEHyoxYPDStPqef8gMA
         BWjaVsI5p1jW4bXqy4z+LayVaGiCEWGKM+px+hACljUij52Zu7BX7F6LGwg5SsJY4OBS
         AiQeWknwgaLhU8Ko6N3/Zq0/AWXvTy49H4QMU3nAdgt7rk2Pttscb8hkUWEA9aQ1afMs
         yJWLOcBRwNEJppHmAyDMAoiRx/KB8kbfQKjNwfq73xEK8E3rckd5XRHyHfZt9ncfgb3x
         xcETGcywMxUghMpkAqFzM184j0cd/bpvqtunfMyyTk2yMhEqtSX8Z0Gluj+gsR7UHmmC
         O/6g==
X-Gm-Message-State: ANoB5plVVWsXufNbgExUgdVW2NO5EkmPPJ6V8+QXCo5mKOLMjK3E9cg7
        48w/QAo/ng9rC93ii1czY82Wm90MF+PPk3E4uK8PlO9qrZ1vzdvLhtAVQqSjaZmxs+1/Uwl2c6j
        h6hTOeJAhDGSR
X-Received: by 2002:a05:600c:1e1a:b0:3cf:7959:d8be with SMTP id ay26-20020a05600c1e1a00b003cf7959d8bemr4452102wmb.85.1668762569745;
        Fri, 18 Nov 2022 01:09:29 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7jsIC1kyZP02uLsDpFgwzo/jh+9BTiREaq3zKB0f5w8O4mQu6CokrtkacAoWZxpUfLgP9J7g==
X-Received: by 2002:a05:600c:1e1a:b0:3cf:7959:d8be with SMTP id ay26-20020a05600c1e1a00b003cf7959d8bemr4452051wmb.85.1668762569479;
        Fri, 18 Nov 2022 01:09:29 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id p6-20020a5d48c6000000b00241a8a5bc11sm2955443wrs.80.2022.11.18.01.09.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 01:09:28 -0800 (PST)
Message-ID: <569b4eeb-792a-9ad6-d52e-555f987bc7f7@redhat.com>
Date:   Fri, 18 Nov 2022 10:09:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v5 07/19] kernel/user: Allow user::locked_vm to be usable
 for iommufd
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>, bpf@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Shuah Khan <shuah@kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Rix <trix@redhat.com>, Will Deacon <will@kernel.org>
Cc:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joao Martins <joao.m.martins@oracle.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
References: <7-v5-4001c2997bd0+30c-iommufd_jgg@nvidia.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <7-v5-4001c2997bd0+30c-iommufd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 11/16/22 22:00, Jason Gunthorpe wrote:
> Following the pattern of io_uring, perf, skb, and bpf iommfd will use
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
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
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

