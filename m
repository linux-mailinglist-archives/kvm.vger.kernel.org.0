Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1CD2209B0
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 12:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730566AbgGOKRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 06:17:34 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39665 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730312AbgGOKRe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jul 2020 06:17:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594808252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3T8WpNGiWZXmVvmLpbm2dg48+ovI54Ol7G/vR/Fw97Q=;
        b=Lv4EDgPU4NL6a8PUsS+zLF56bnTmLvB/8v2a5g3kpOzzFpjFPBwQpVa8ja78ChK0KYEgtx
        4UMPCJZauj2LLUIgGJl8OkHnpdeWgObQ1ClGRyyLTp2BvBLBDJFgF0anhPfOsRLTu7E2bX
        Bxn9s1eSjHMFny2OpsInlydhfroEev0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-sGQ40kMOPsOkyM4UynS6Ng-1; Wed, 15 Jul 2020 06:17:28 -0400
X-MC-Unique: sGQ40kMOPsOkyM4UynS6Ng-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D508D1005260;
        Wed, 15 Jul 2020 10:17:26 +0000 (UTC)
Received: from [10.72.13.230] (ovpn-13-230.pek2.redhat.com [10.72.13.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C6061059583;
        Wed, 15 Jul 2020 10:17:00 +0000 (UTC)
Subject: Re: [PATCH v7 2/2] s390: virtio: PV needs VIRTIO I/O device
 protection
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <1594801869-13365-1-git-send-email-pmorel@linux.ibm.com>
 <1594801869-13365-3-git-send-email-pmorel@linux.ibm.com>
 <20200715054807-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bc5e09ad-faaf-8b38-83e0-5f4a4b1daeb0@redhat.com>
Date:   Wed, 15 Jul 2020 18:16:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200715054807-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/7/15 下午5:50, Michael S. Tsirkin wrote:
> On Wed, Jul 15, 2020 at 10:31:09AM +0200, Pierre Morel wrote:
>> If protected virtualization is active on s390, the virtio queues are
>> not accessible to the host, unless VIRTIO_F_IOMMU_PLATFORM has been
>> negotiated. Use the new arch_validate_virtio_features() interface to
>> fail probe if that's not the case, preventing a host error on access
>> attempt.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> Acked-by: Halil Pasic <pasic@linux.ibm.com>
>> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>   arch/s390/mm/init.c | 28 ++++++++++++++++++++++++++++
>>   1 file changed, 28 insertions(+)
>>
>> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
>> index 6dc7c3b60ef6..d39af6554d4f 100644
>> --- a/arch/s390/mm/init.c
>> +++ b/arch/s390/mm/init.c
>> @@ -45,6 +45,7 @@
>>   #include <asm/kasan.h>
>>   #include <asm/dma-mapping.h>
>>   #include <asm/uv.h>
>> +#include <linux/virtio_config.h>
>>   
>>   pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(.bss..swapper_pg_dir);
>>   
>> @@ -161,6 +162,33 @@ bool force_dma_unencrypted(struct device *dev)
>>   	return is_prot_virt_guest();
>>   }
>>   
>> +/*
>> + * arch_validate_virtio_features
>> + * @dev: the VIRTIO device being added
>> + *
>> + * Return an error if required features are missing on a guest running
>> + * with protected virtualization.
>> + */
>> +int arch_validate_virtio_features(struct virtio_device *dev)
>> +{
>> +	if (!is_prot_virt_guest())
>> +		return 0;
>> +
>> +	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
>> +		dev_warn(&dev->dev,
>> +			 "legacy virtio not supported with protected virtualization\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	if (!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
>> +		dev_warn(&dev->dev,
>> +			 "support for limited memory access required for protected virtualization\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   /* protected virtualization */
>>   static void pv_init(void)
>>   {
> What bothers me here is that arch code depends on virtio now.
> It works even with a modular virtio when functions are inline,
> but it seems fragile: e.g. it breaks virtio as an out of tree module,
> since layout of struct virtio_device can change.


The code was only called from virtio.c so it should be fine.

And my understanding is that we don't need to care about the kABI issue 
during upstream development?

Thanks


>
> I'm not sure what to do with this yet, will try to think about it
> over the weekend. Thanks!
>
>
>> -- 
>> 2.25.1

