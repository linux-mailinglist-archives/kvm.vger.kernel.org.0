Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35131319B8D
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 09:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhBLI4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 03:56:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56532 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229497AbhBLI4t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 03:56:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613120122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nma5RrDL02zgQCnQAmwMQggmlffp24gdJp2OtX7ZPuI=;
        b=GrhwezraI6jnv9CqC41BRlV+ikJ2kjxywJ0d1ottoP3WOPhMT58IiMWFsPgBvmjDCGXm2D
        1L40DaJWJiw1M0qsNl7InN87vWMiDOiGb9MDWFRVzvZ5OirAT5MBy3wgv/UCQF6GrWAnX1
        dlLKILG0b9a7CJGfEjmM91aLfuu9cIc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-1LGCv3TxNmmITacLXAFtsw-1; Fri, 12 Feb 2021 03:55:20 -0500
X-MC-Unique: 1LGCv3TxNmmITacLXAFtsw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 176EB6D4E0;
        Fri, 12 Feb 2021 08:55:18 +0000 (UTC)
Received: from [10.36.114.34] (ovpn-114-34.ams2.redhat.com [10.36.114.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B842F62AF8;
        Fri, 12 Feb 2021 08:55:10 +0000 (UTC)
Subject: Re: [PATCH v13 02/15] iommu: Introduce bind/unbind_guest_msi
To:     Keqian Zhu <zhukeqian1@huawei.com>, eric.auger.pro@gmail.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com,
        alex.williamson@redhat.com
Cc:     jean-philippe@linaro.org, jacob.jun.pan@linux.intel.com,
        nicoleotsuka@gmail.com, vivek.gautam@arm.com, yi.l.liu@intel.com,
        zhangfei.gao@linaro.org
References: <20201118112151.25412-1-eric.auger@redhat.com>
 <20201118112151.25412-3-eric.auger@redhat.com>
 <6a70d93d-329f-4129-bd90-03f8589c5de4@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <1ef4f5ae-9ca6-7c6d-f8a9-31240e5688c2@redhat.com>
Date:   Fri, 12 Feb 2021 09:55:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <6a70d93d-329f-4129-bd90-03f8589c5de4@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Keqian,

On 2/1/21 12:52 PM, Keqian Zhu wrote:
> Hi Eric,
> 
> On 2020/11/18 19:21, Eric Auger wrote:
>> On ARM, MSI are translated by the SMMU. An IOVA is allocated
>> for each MSI doorbell. If both the host and the guest are exposed
>> with SMMUs, we end up with 2 different IOVAs allocated by each.
>> guest allocates an IOVA (gIOVA) to map onto the guest MSI
>> doorbell (gDB). The Host allocates another IOVA (hIOVA) to map
>> onto the physical doorbell (hDB).
>>
>> So we end up with 2 untied mappings:
>>          S1            S2
>> gIOVA    ->    gDB
>>               hIOVA    ->    hDB
>>
>> Currently the PCI device is programmed by the host with hIOVA
>> as MSI doorbell. So this does not work.
>>
>> This patch introduces an API to pass gIOVA/gDB to the host so
>> that gIOVA can be reused by the host instead of re-allocating
>> a new IOVA. So the goal is to create the following nested mapping:
> Does the gDB can be reused under non-nested mode?

Under non nested mode the hIOVA is allocated within the MSI reserved
region exposed by the SMMU driver, [0x8000000, 80fffff]. see
iommu_dma_prepare_msi/iommu_dma_get_msi_page in dma_iommu.c. this hIOVA
is programmed in the physical device so that the physical SMMU
translates it into the physical doorbell (hDB = host physical ITS
doorbell). The gDB is not used at pIOMMU programming level. It is only
used when setting up the KVM irq route.

Hope this answers your question.

> 
>>
>>          S1            S2
>> gIOVA    ->    gDB     ->    hDB
>>
>> and program the PCI device with gIOVA MSI doorbell.
>>
>> In case we have several devices attached to this nested domain
>> (devices belonging to the same group), they cannot be isolated
>> on guest side either. So they should also end up in the same domain
>> on guest side. We will enforce that all the devices attached to
>> the host iommu domain use the same physical doorbell and similarly
>> a single virtual doorbell mapping gets registered (1 single
>> virtual doorbell is used on guest as well).
>>
> [...]
> 
>> + *
>> + * The associated IOVA can be reused by the host to create a nested
>> + * stage2 binding mapping translating into the physical doorbell used
>> + * by the devices attached to the domain.
>> + *
>> + * All devices within the domain must share the same physical doorbell.
>> + * A single MSI GIOVA/GPA mapping can be attached to an iommu_domain.
>> + */
>> +
>> +int iommu_bind_guest_msi(struct iommu_domain *domain,
>> +			 dma_addr_t giova, phys_addr_t gpa, size_t size)
>> +{
>> +	if (unlikely(!domain->ops->bind_guest_msi))
>> +		return -ENODEV;
>> +
>> +	return domain->ops->bind_guest_msi(domain, giova, gpa, size);
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_bind_guest_msi);
>> +
>> +void iommu_unbind_guest_msi(struct iommu_domain *domain,
>> +			    dma_addr_t iova)
> nit: s/iova/giova
sure
> 
>> +{
>> +	if (unlikely(!domain->ops->unbind_guest_msi))
>> +		return;
>> +
>> +	domain->ops->unbind_guest_msi(domain, iova);
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_unbind_guest_msi);
>> +
> [...]
> 
> Thanks,
> Keqian
> 

Thanks

Eric

