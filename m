Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 075DD686A92
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 16:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbjBAPn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 10:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjBAPnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 10:43:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E4224484
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 07:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675266186;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ysVJeSWsRwtQ8lRG5KxX8zf/r8R7/oCvM/YlMO+VpRk=;
        b=VaOtteE6zTSbZBCWh+kBNKFOsiWrZ2jfGh8C4or4+SKefbd3RVgsiR3h3Np/0dDRyRILkP
        QaioEw0EjdlW979h9uWRtrZNibOxIsetARC61rzKZ6KiMW87mX04Md+jUkERYqMqujQ26a
        5OA3nMQLggp90IzUjvM05iGiu1+kSPQ=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-249-1qsk6igTOQebDKOonf7q8g-1; Wed, 01 Feb 2023 10:43:05 -0500
X-MC-Unique: 1qsk6igTOQebDKOonf7q8g-1
Received: by mail-qv1-f72.google.com with SMTP id mx2-20020a0562142e0200b0053807f3eb76so9494194qvb.15
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 07:43:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ysVJeSWsRwtQ8lRG5KxX8zf/r8R7/oCvM/YlMO+VpRk=;
        b=e/6t55NLEsVlVEpmDWcp0hDToXXnePFtoyaYMH6p1mEeML4L4W820OJFN2KxuKOr6W
         yT5XZnvN5VFEcGt/sNsYXg3L7YbAbDPUXVKxc7Pv6YbnhmTsydVhTvODV4KQw4sx8d+G
         KKDdSxgxMibK/jGsB3Y/Dg8z2GRBuWDo90bCJAihYl5LF44MxbaJIz8nCJyf70lKphQt
         y4FGrd0RpbRI2dIzAs/asT/l6169V12X5zPMiaY9xvjshACxsGD+SIjhvWA+KTSXZ+9Y
         ww8oriQ3gx5pACtdehCjUpfRUdaIlOd0xSnRdIlBw+P+xGB20havNfuFAxfRMEy3DF+S
         tabA==
X-Gm-Message-State: AO0yUKVYa86TQJf1Wr9lsxky5q9sxFoWuZ9IWqA/E8nETd9CXr/3SM6b
        KKU8RKgMJwguhZuarfYd31Ga7p3Bz5fmnaLe83qHldVYTHYL6VHIJeALG+TtDpL0zVoaYzHdj00
        L1s80q4/3k5Uf
X-Received: by 2002:a05:622a:2c1:b0:3b9:bb27:e11a with SMTP id a1-20020a05622a02c100b003b9bb27e11amr2446681qtx.0.1675266184261;
        Wed, 01 Feb 2023 07:43:04 -0800 (PST)
X-Google-Smtp-Source: AK7set/BneK1ulF3AJc6fhGlcRYjyTST3V8LcwkXDMZuxLLm1lgCUoACJ+u4zOgQY53DLcVGSPgidA==
X-Received: by 2002:a05:622a:2c1:b0:3b9:bb27:e11a with SMTP id a1-20020a05622a02c100b003b9bb27e11amr2446659qtx.0.1675266183996;
        Wed, 01 Feb 2023 07:43:03 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id a17-20020ac86111000000b003b0766cd169sm12070166qtm.2.2023.02.01.07.42.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Feb 2023 07:43:02 -0800 (PST)
Message-ID: <a430b451-2eaa-2dc2-4223-20d5275c3ca3@redhat.com>
Date:   Wed, 1 Feb 2023 16:42:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC v3 16/18] vfio/iommufd: Implement the iommufd backend
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     eric.auger.pro@gmail.com, yi.l.liu@intel.com, yi.y.sun@intel.com,
        alex.williamson@redhat.com, clg@redhat.com, qemu-devel@nongnu.org,
        david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, nicolinc@nvidia.com,
        kevin.tian@intel.com, chao.p.peng@intel.com, peterx@redhat.com,
        shameerali.kolothum.thodi@huawei.com, zhangfei.gao@linaro.org,
        berrange@redhat.com, apopple@nvidia.com,
        suravee.suthikulpanit@amd.com
References: <20230131205305.2726330-1-eric.auger@redhat.com>
 <20230131205305.2726330-17-eric.auger@redhat.com>
 <Y9mkriFLL43OGbHq@nvidia.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <Y9mkriFLL43OGbHq@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 2/1/23 00:30, Jason Gunthorpe wrote:
> On Tue, Jan 31, 2023 at 09:53:03PM +0100, Eric Auger wrote:
>> From: Yi Liu <yi.l.liu@intel.com>
>>
>> Add the iommufd backend. The IOMMUFD container class is implemented
>> based on the new /dev/iommu user API. This backend obviously depends
>> on CONFIG_IOMMUFD.
>>
>> So far, the iommufd backend doesn't support live migration and
>> cache coherency yet due to missing support in the host kernel meaning
>> that only a subset of the container class callbacks is implemented.
> What is missing for cache coherency? I spent lots of time on that
> already, I thought I got everything..
I don't think there is anything missing anymore. This was about
KVM_DEV_VFIO_GROUP_ADD/DEL. With the advent of KVM_DEV_VFIO_FILE_ADD/DEL
we should be able to bridge the gap. However This RFCv3 does not support
that yet in the IOMMUFD backend. We will add this support in the next
version.

Thanks

Eric
>
> Jason
>

