Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA7E322AFE
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 14:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhBWM7j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 07:59:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40345 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232753AbhBWM7P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 07:59:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614085069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ejww2KN9lm9jdMXwKJXUxNSbDO+xho00yxBfGY60kHQ=;
        b=R1uPay+pJnqRhQzGQkUTktqHsBHLDCLZSXurKWg7zjOnt2lK9+HOwRv4XZkrJNi4QN6JTO
        ptUypPS8DPOkCVtZMW2B5kd2TCqzqVp1/UpiwkjaEA8RIgBTQv31pbBRJNiJmOQzqaosti
        ZbXk1QeQFngN0jKKWbboQJmWljrngXc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-StTCqMhkNUqtugcRrQksTQ-1; Tue, 23 Feb 2021 07:57:47 -0500
X-MC-Unique: StTCqMhkNUqtugcRrQksTQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B85A1005501;
        Tue, 23 Feb 2021 12:57:44 +0000 (UTC)
Received: from [10.36.114.34] (ovpn-114-34.ams2.redhat.com [10.36.114.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 507585D9D0;
        Tue, 23 Feb 2021 12:57:34 +0000 (UTC)
Subject: Re: [PATCH v11 04/13] vfio/pci: Add VFIO_REGION_TYPE_NESTED region
 type
To:     Shenming Lu <lushenming@huawei.com>, eric.auger.pro@gmail.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     jean-philippe@linaro.org, jacob.jun.pan@linux.intel.com,
        nicoleotsuka@gmail.com, vivek.gautam@arm.com, yi.l.liu@intel.com,
        zhangfei.gao@linaro.org, wanghaibin.wang@huawei.com,
        Keqian Zhu <zhukeqian1@huawei.com>, yuzenghui@huawei.com,
        Kunkun Jiang <jiangkunkun@huawei.com>
References: <20201116110030.32335-1-eric.auger@redhat.com>
 <20201116110030.32335-5-eric.auger@redhat.com>
 <2b5031d4-fa1a-c893-e7e4-56c68da600e4@huawei.com>
 <081265c6-a579-6041-5a74-99bf74cc3d5f@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <022eec8e-ae33-720a-b882-d00cc95a2a27@redhat.com>
Date:   Tue, 23 Feb 2021 13:57:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <081265c6-a579-6041-5a74-99bf74cc3d5f@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shenming,

On 2/23/21 1:45 PM, Shenming Lu wrote:
>> +static int vfio_pci_dma_fault_init(struct vfio_pci_device *vdev)
>> +{
>> +	struct vfio_region_dma_fault *header;
>> +	struct iommu_domain *domain;
>> +	size_t size;
>> +	bool nested;
>> +	int ret;
>> +
>> +	domain = iommu_get_domain_for_dev(&vdev->pdev->dev);
>> +	ret = iommu_domain_get_attr(domain, DOMAIN_ATTR_NESTING, &nested);
>> +	if (ret || !nested)
>> +		return ret;
> 
> Hi Eric,
> 
> It seems that the type of nested should be int, the use of bool might trigger
> a panic in arm_smmu_domain_get_attr().

Thank you. That's fixed now.

Best Regards

Eric
> 
> Thanks,
> Shenming
> 

