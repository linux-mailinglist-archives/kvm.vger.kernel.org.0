Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B2A35B403
	for <lists+kvm@lfdr.de>; Sun, 11 Apr 2021 14:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235377AbhDKMNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Apr 2021 08:13:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49910 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235281AbhDKMND (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 11 Apr 2021 08:13:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618143166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cd5a7MnBxaCycfDTV6DQTS58oQm03SFk+/qhnkSwHlw=;
        b=CIPfQv4udf2X1b7yCJPTtHGea6TEjO3MF//RveBRyXOaru4hvmf5WjU4VAnB8mAtqDbFNQ
        zx6aBQkb0HPGvlFMdzGuKwZpUwmV3jneD2H5wXTQBdsGXyo52vm/d4vWzTZFbN86X5C19T
        WNfES4J4VLAyDC7hNDB/YQ2oYj6RabU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-r9GIkX2eOQKuVWu8pninBQ-1; Sun, 11 Apr 2021 08:12:42 -0400
X-MC-Unique: r9GIkX2eOQKuVWu8pninBQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 141AD10053E6;
        Sun, 11 Apr 2021 12:12:40 +0000 (UTC)
Received: from [10.36.112.22] (ovpn-112-22.ams2.redhat.com [10.36.112.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 362465D6D3;
        Sun, 11 Apr 2021 12:12:29 +0000 (UTC)
Subject: Re: [PATCH v12 01/13] vfio: VFIO_IOMMU_SET_PASID_TABLE
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, will@kernel.org, maz@kernel.org,
        robin.murphy@arm.com, joro@8bytes.org, alex.williamson@redhat.com,
        tn@semihalf.com, zhukeqian1@huawei.com,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        wangxingang5@huawei.com, jiangkunkun@huawei.com,
        jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        zhangfei.gao@gmail.com, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com, nicoleotsuka@gmail.com,
        lushenming@huawei.com, vsethi@nvidia.com,
        wanghaibin.wang@huawei.com
References: <20210223210625.604517-1-eric.auger@redhat.com>
 <20210223210625.604517-2-eric.auger@redhat.com>
 <d0f254c3-0b63-e4d3-1f58-8940adc7c0bf@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <513f8129-7ddc-f19f-e25a-e2a4b6cbe593@redhat.com>
Date:   Sun, 11 Apr 2021 14:12:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <d0f254c3-0b63-e4d3-1f58-8940adc7c0bf@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 4/7/21 11:33 AM, Zenghui Yu wrote:
> Hi Eric,
> 
> On 2021/2/24 5:06, Eric Auger wrote:
>> +/*
>> + * VFIO_IOMMU_SET_PASID_TABLE - _IOWR(VFIO_TYPE, VFIO_BASE + 18,
>> + *            struct vfio_iommu_type1_set_pasid_table)
>> + *
>> + * The SET operation passes a PASID table to the host while the
>> + * UNSET operation detaches the one currently programmed. Setting
>> + * a table while another is already programmed replaces the old table.
> 
> It looks to me that this description doesn't match the IOMMU part.

Yep that's misleanding.

I replaced it by:

 It is allowed to "SET" the table several times without un-setting as
 long as the table config does not stay IOMMU_PASID_CONFIG_TRANSLATE.

> 
> [v14,05/13] iommu/smmuv3: Implement attach/detach_pasid_table
> 
> |    case IOMMU_PASID_CONFIG_TRANSLATE:
> |        /* we do not support S1 <-> S1 transitions */
> |        if (smmu_domain->s1_cfg.set)
> |            goto out;
> 
> Maybe I've misread something?
> 
> 
> Thanks,
> Zenghui
> 

Thanks

Eric

