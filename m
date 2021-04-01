Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2950D351E08
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237276AbhDASd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:33:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236621AbhDAS2F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 14:28:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617301684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7sDTaVgWT9Uk0Jsav/2bWha3xiyU83b/ipUGLZIGqss=;
        b=dB7XFyQbxoWn1SJt3Wqi09IKPrjXeulWVWzi/Yk1Wj9lewz7SkehTewiC+5fziN4OIe/Bf
        AHBDOfWRhIctiL0SCE7c9KFS8i41H4A6RFtIpIziMsVCrxnStgaF3LafLpd6PkLDcohxTj
        fcOkqZLUsLnk9wMgwie1tWgIFM8lXN8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-8xDbHPHKMEmK88BxDa-lVA-1; Thu, 01 Apr 2021 08:06:17 -0400
X-MC-Unique: 8xDbHPHKMEmK88BxDa-lVA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E82FA1007478;
        Thu,  1 Apr 2021 12:06:13 +0000 (UTC)
Received: from [10.36.112.13] (ovpn-112-13.ams2.redhat.com [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1577251DE2;
        Thu,  1 Apr 2021 12:06:07 +0000 (UTC)
Subject: Re: [PATCH v14 07/13] iommu/smmuv3: Implement cache_invalidate
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
References: <20210223205634.604221-1-eric.auger@redhat.com>
 <20210223205634.604221-8-eric.auger@redhat.com>
 <95a178f0-fc84-b9a2-d824-c09ea91c9d30@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <86d5f9e9-1c84-91c4-75a8-770dd4c591a7@redhat.com>
Date:   Thu, 1 Apr 2021 14:06:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <95a178f0-fc84-b9a2-d824-c09ea91c9d30@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 4/1/21 8:11 AM, Zenghui Yu wrote:
> Hi Eric,
> 
> On 2021/2/24 4:56, Eric Auger wrote:
>> +static int
>> +arm_smmu_cache_invalidate(struct iommu_domain *domain, struct device
>> *dev,
>> +              struct iommu_cache_invalidate_info *inv_info)
>> +{
>> +    struct arm_smmu_cmdq_ent cmd = {.opcode = CMDQ_OP_TLBI_NSNH_ALL};
>> +    struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>> +    struct arm_smmu_device *smmu = smmu_domain->smmu;
>> +
>> +    if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
>> +        return -EINVAL;
>> +
>> +    if (!smmu)
>> +        return -EINVAL;
>> +
>> +    if (inv_info->version != IOMMU_CACHE_INVALIDATE_INFO_VERSION_1)
>> +        return -EINVAL;
>> +
>> +    if (inv_info->cache & IOMMU_CACHE_INV_TYPE_PASID ||
> 
> I didn't find any code where we would emulate the CFGI_CD{_ALL} commands
> for guest and invalidate the stale CD entries on the physical side. Is
> PASID-cache type designed for that effect?
Yes it is. PASID-cache matches the CD table.
> 
>> +        inv_info->cache & IOMMU_CACHE_INV_TYPE_DEV_IOTLB) {
>> +        return -ENOENT;
>> +    }
>> +
>> +    if (!(inv_info->cache & IOMMU_CACHE_INV_TYPE_IOTLB))
>> +        return -EINVAL;
>> +
>> +    /* IOTLB invalidation */
>> +
>> +    switch (inv_info->granularity) {
>> +    case IOMMU_INV_GRANU_PASID:
>> +    {
>> +        struct iommu_inv_pasid_info *info =
>> +            &inv_info->granu.pasid_info;
>> +
>> +        if (info->flags & IOMMU_INV_ADDR_FLAGS_PASID)
>> +            return -ENOENT;
>> +        if (!(info->flags & IOMMU_INV_PASID_FLAGS_ARCHID))
>> +            return -EINVAL;
>> +
>> +        __arm_smmu_tlb_inv_context(smmu_domain, info->archid);
>> +        return 0;
>> +    }
>> +    case IOMMU_INV_GRANU_ADDR:
>> +    {
>> +        struct iommu_inv_addr_info *info = &inv_info->granu.addr_info;
>> +        size_t size = info->nb_granules * info->granule_size;
>> +        bool leaf = info->flags & IOMMU_INV_ADDR_FLAGS_LEAF;
>> +
>> +        if (info->flags & IOMMU_INV_ADDR_FLAGS_PASID)
>> +            return -ENOENT;
>> +
>> +        if (!(info->flags & IOMMU_INV_ADDR_FLAGS_ARCHID))
>> +            break;
>> +
>> +        arm_smmu_tlb_inv_range_domain(info->addr, size,
>> +                          info->granule_size, leaf,
>> +                          info->archid, smmu_domain);
>> +
>> +        arm_smmu_cmdq_issue_sync(smmu);
> 
> There is no need to issue one more SYNC.
Hum yes I did not notice it was made by the arm_smmu_cmdq_issue_cmdlist()

Thanks!

Eric
> 

