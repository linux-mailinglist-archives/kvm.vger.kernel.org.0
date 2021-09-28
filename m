Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190FF41A8ED
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 08:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238981AbhI1G1T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 02:27:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47917 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234207AbhI1G1S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 02:27:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632810338;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9wq1dVPtAXDMCZC9S+u92KoCxHpT0A4H8ulsqFHsRII=;
        b=XmJ1SjrVORrpurxHKPpspezhDSLg9Zih1bNjRiCjiZJt2l9BQmS/fMrITqEJVZE7Fn/FrK
        YMwTk4+5lSBsmBMJ3gCHEN3m1qqeOuxh5LVuaISufkIKOoJSzOzqHsJtvahs/+GUmJPyc/
        5BYaVglFnsj5VqQ8V3T4xMc0TkZL4jM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-Kaf0pxWYPG2lBg4KcGlElg-1; Tue, 28 Sep 2021 02:25:37 -0400
X-MC-Unique: Kaf0pxWYPG2lBg4KcGlElg-1
Received: by mail-wm1-f72.google.com with SMTP id 200-20020a1c00d1000000b0030b3dce20e1so702423wma.0
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 23:25:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=9wq1dVPtAXDMCZC9S+u92KoCxHpT0A4H8ulsqFHsRII=;
        b=16GLSgPaERUajbqJe18Woax0BMrtmQR8Cp3n+w+7sRcFcV3OlBShq6kgQ8P+9fKQKg
         EdPivDsQoERj9JuuZM8wVJeTBqEVdgXQkLA53oUgBW0urikSscIcIIqVr/3JyJnn6+SM
         k+DokXsC70cbEPfY19r8l62ikH9S8JxXx2ctAKl6K/gj9TkzY//aAVvl/2/wbYVHIORM
         QGPoTwT/REeixSNJnxAuqR4DJKxwCIOIxIlQEyssx1Wpu6ougiWyGFX0Jat0mI9xNP4a
         I3Qjc6rS/tmpeFfzkVPAvkvkQMegpkvBl3xVhDEH15x+Ea40SCcRf/FYjNdNpA4F9e/t
         khZw==
X-Gm-Message-State: AOAM530c97v9n+6JQromEmUErEMgg2it+9bBapLRb5rDSCe5wy71+DeQ
        QXxsg9nVhP4E8LqyP/phJUHsatMNCClhIu+fUYwT2uzLQNUwRpC+7PPysnv4cYcMSKh/Fh3sGIx
        d5Z52lYtl3Cdg
X-Received: by 2002:a5d:64cf:: with SMTP id f15mr4278535wri.284.1632810336271;
        Mon, 27 Sep 2021 23:25:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqSUu50iJ95OWE4UOFTINQsxuRK/ueiYpb9FlWfdG9FdcSiC/DUJ4GzrvCnuOU9QL4gLjBUA==
X-Received: by 2002:a5d:64cf:: with SMTP id f15mr4278495wri.284.1632810336011;
        Mon, 27 Sep 2021 23:25:36 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l10sm1663709wmq.42.2021.09.27.23.25.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 23:25:35 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v15 00/12] SMMUv3 Nested Stage Setup (IOMMU part)
To:     Krishna Reddy <vdumpa@nvidia.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "will@kernel.org" <will@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "tn@semihalf.com" <tn@semihalf.com>,
        "zhukeqian1@huawei.com" <zhukeqian1@huawei.com>
Cc:     "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        "wangxingang5@huawei.com" <wangxingang5@huawei.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "zhangfei.gao@gmail.com" <zhangfei.gao@gmail.com>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        "chenxiang66@hisilicon.com" <chenxiang66@hisilicon.com>,
        "jiangkunkun@huawei.com" <jiangkunkun@huawei.com>
References: <20210411111228.14386-1-eric.auger@redhat.com>
 <BY5PR12MB37640C26FEBC8AC6E3EDF40BB3A79@BY5PR12MB3764.namprd12.prod.outlook.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <c3fcc2fb-3173-af83-2b30-423c2c1ab83d@redhat.com>
Date:   Tue, 28 Sep 2021 08:25:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB37640C26FEBC8AC6E3EDF40BB3A79@BY5PR12MB3764.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Krishna,

On 9/27/21 11:17 PM, Krishna Reddy wrote:
> Hi Eric,
>> This is based on Jean-Philippe's
>> [PATCH v14 00/10] iommu: I/O page faults for SMMUv3
>> https://www.spinics.net/lists/arm-kernel/msg886518.html
>> (including the patches that were not pulled for 5.13)
>>
> Jean's patches have been merged to v5.14.
> Do you anticipate IOMMU/VFIO part patches getting into upstream kernel soon?

I am going to respin the smmu part rebased on v5.15. As for the VFIO
part, this needs to be totally redesigned based on /dev/iommu (see
[RFC 00/20] Introduce /dev/iommu for userspace I/O address space
management).

I will provide some updated kernel and qemu branches for testing purpose
only.

Thanks

Eric
>
> -KR
>

