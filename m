Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71D435127C
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 11:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbhDAJij (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 05:38:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38789 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234029AbhDAJii (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 05:38:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617269918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Hn127n4+W9QT98rMhYkTztLXr0yp9CQW2nFtLHdNsg=;
        b=OiqhED6+Ute+hn6KSkhCxLpV3IF7vfylLmMNc5YRAIQAC+XuJEb3LH0GgcFPGIQkVCJX3y
        q0IuHn6tRRFOJazEgvoATAyhi7x+NGjHAjdXPmEMcBwdXHPdcLk8yQbpHBoBFd3SwJlIBi
        E98RO94NyedtTdLATEY+cf11r+LM8BU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-duJBAVOJMpCjeWyJ694eNA-1; Thu, 01 Apr 2021 05:38:34 -0400
X-MC-Unique: duJBAVOJMpCjeWyJ694eNA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBE96107B7C3;
        Thu,  1 Apr 2021 09:38:30 +0000 (UTC)
Received: from [10.36.112.13] (ovpn-112-13.ams2.redhat.com [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 189EB5C8AB;
        Thu,  1 Apr 2021 09:38:18 +0000 (UTC)
Subject: Re: [PATCH v14 06/13] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
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
 <20210223205634.604221-7-eric.auger@redhat.com>
 <7a270196-2a8d-1b23-ee5f-f977c53d2134@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <8350e4e2-4607-cfd7-b1a7-1470bf18da6d@redhat.com>
Date:   Thu, 1 Apr 2021 11:38:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <7a270196-2a8d-1b23-ee5f-f977c53d2134@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 3/30/21 11:17 AM, Zenghui Yu wrote:
> On 2021/2/24 4:56, Eric Auger wrote:
>> @@ -1936,7 +1950,12 @@ static void
>> arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
>>           },
>>       };
>>   -    if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
>> +    if (ext_asid >= 0) {  /* guest stage 1 invalidation */
>> +        cmd.opcode    = smmu_domain->smmu->features &
>> ARM_SMMU_FEAT_E2H ?
>> +                  CMDQ_OP_TLBI_EL2_VA : CMDQ_OP_TLBI_NH_VA;
> 
> If I understand it correctly, the true nested mode effectively gives us
> a *NS-EL1* StreamWorld. We should therefore use CMDQ_OP_TLBI_NH_VA to
> invalidate the stage-1 NS-EL1 entries, no matter E2H is selected or not.
> 

Yes at the moment you're right. Support for nested virt may induce some
changes here but we are not there. I will fix it and add a comment.
Thank you!

Best Regards

Eric

