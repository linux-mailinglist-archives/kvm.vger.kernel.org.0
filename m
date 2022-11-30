Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0379963DBCF
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 18:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiK3RTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 12:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiK3RTp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 12:19:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D199C
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 09:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669828723;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7yqed071pAVP6WInKQJMIjJsrRbR4/XvmYMWkwCqNRs=;
        b=MHEsJ+5J8wPuFvgZZTB4aM0TExELUAS6VScWprkZlrmiOqCFmTu5OauFcTaOXGXGY87rwT
        xj9eUALyjeFJfuUmtqvtVmRMxVp5hlCXZ32RGf2t80TcDDHw4LpO0pZEKxGHnT6zsqIdfO
        jV0y9w0Yvb+zltbOCl0RObxfN9UnIjU=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-569-FGXCYRFQM2mD3IzMMjnxlg-1; Wed, 30 Nov 2022 12:18:42 -0500
X-MC-Unique: FGXCYRFQM2mD3IzMMjnxlg-1
Received: by mail-qv1-f69.google.com with SMTP id mi12-20020a056214558c00b004bb63393567so27592036qvb.21
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 09:18:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7yqed071pAVP6WInKQJMIjJsrRbR4/XvmYMWkwCqNRs=;
        b=EE+Y6fE4OYp5ObSxh+2vSFwiJJ6rqgHJjVmwm5e3m25dJQ6aaubjb5Xp1dqyNkMmI2
         M7alQB2NHE5JTpqA/O3EZI2XIfvtT61ZRvwIV0rRVI8OHx6HE7rMeAHVTI8HizHHTTyC
         VLsh3USoR1pB9NlaQA0hI2pboIJTg92ZyEdAmU+yu/NUgOCdZhpJ02kElp36q6PT3Z7A
         /2GnYcrA0XhjBMFi3rVpWl7UwKcM3ycG1vPe9cjxm4EHrW1+dZCR37Mxwi2tcpuZwLgB
         3zNwIbQ77KjsrdGcOIVUEiUTPykx7cM4IfHaTLRdZmnhqntnFRBKD3HrQVuzAzhu7dQe
         TBMw==
X-Gm-Message-State: ANoB5pmrQ7xOKBDqikKI37sj45upgv+oPrkB8xfeUXqdBI3zjHb+NoL2
        26Dd9u8NRkQ1BxMe8Ve4tQeu4fcrncX9PbD/dTqgk9z977Tc97QUBGjYKeR5JTvglcr7IX+9TWx
        J/NBMpc0FewPQ
X-Received: by 2002:a05:6214:2b9e:b0:4c6:fadf:7b2c with SMTP id kr30-20020a0562142b9e00b004c6fadf7b2cmr17156929qvb.77.1669828721573;
        Wed, 30 Nov 2022 09:18:41 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4zt5mmMEfHFozNLW9g2zKcAVTsYZDjrkdfzXQDS+o3p5ygCELbVIfinTFrJDyhD/JRr82p3g==
X-Received: by 2002:a05:6214:2b9e:b0:4c6:fadf:7b2c with SMTP id kr30-20020a0562142b9e00b004c6fadf7b2cmr17156891qvb.77.1669828721349;
        Wed, 30 Nov 2022 09:18:41 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id bs42-20020a05620a472a00b006b61b2cb1d2sm1588557qkb.46.2022.11.30.09.18.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 09:18:40 -0800 (PST)
Message-ID: <00d43a82-3262-5248-a066-e71c608be0a9@redhat.com>
Date:   Wed, 30 Nov 2022 18:18:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v6 19/19] iommufd: Add a selftest
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Cc:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>, Yu He <yu.he@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
References: <19-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
 <48c89797-600b-48db-8df4-fc6674561417@intel.com>
 <Y4dfxp19/OVreNoU@nvidia.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <Y4dfxp19/OVreNoU@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 11/30/22 14:51, Jason Gunthorpe wrote:
> On Wed, Nov 30, 2022 at 03:14:32PM +0800, Yi Liu wrote:
>> On 2022/11/30 04:29, Jason Gunthorpe wrote:
>>> Cover the essential functionality of the iommufd with a directed test from
>>> userspace. This aims to achieve reasonable functional coverage using the
>>> in-kernel self test framework.
>>>
>>> A second test does a failure injection sweep of the success paths to study
>>> error unwind behaviors.
>>>
>>> This allows achieving high coverage of the corner cases in pages.c.
>>>
>>> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
>>> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com> # s390
>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
>>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> with sudo echo 4 > /proc/sys/vm/nr_hugepages
>>
>> Both "sudo ./iommufd" and "sudo ./iommufd_fail_nth" works on my
>> side.
> It is interesting that you need that, my VM doesn't, I wonder what the
> difference is

That's the same on my end, I need at least 2 hugepages to get all tests
passing.
Otherwise
# FAILED: 113 / 121 tests passed.
# Totals: pass:113 fail:8 xfail:0 xpass:0 skip:0 error:0

I think you should add this in the commit msg + also the fact that
CONFIG_IOMMUFD_TEST is required

Besides, tested on ARM with both 4kB page and 64kB page size
Feel free to add my Tested-by: Eric Auger <eric.auger@redhat.com> #aarch64

Thanks

Eric

>
> Thanks,
> Jason
>

