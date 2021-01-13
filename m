Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93402F50F9
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 18:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbhAMRT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 12:19:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58883 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728267AbhAMRT5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 12:19:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610558311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RtqK698Gz2UPmkSrQZ+1pqM9fJn9xrCeQ0Ydv7oehh8=;
        b=iIKHIaaz1gbya8B3lnbR6afcNY6/GsKsxYtxumDZACzeiD+W73yqzaWs4yK8dLhHOliTQG
        MGxy7mvHNCSZoTyFY93JSPXX61lwKh2+QRkMA/0Bn1gWBBYrRjyEuDlX2qlIvtWQ6DiZWA
        3dbWfjSpS3xXAbwssPFG9Uconwp6gsw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-wnXSPicHN36julsnJPTxOA-1; Wed, 13 Jan 2021 12:18:26 -0500
X-MC-Unique: wnXSPicHN36julsnJPTxOA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3243F1081B2F;
        Wed, 13 Jan 2021 17:18:25 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7812660BF1;
        Wed, 13 Jan 2021 17:18:22 +0000 (UTC)
Subject: Re: [PATCH 2/9] KVM: arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
 read
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        drjones@redhat.com
Cc:     james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-3-eric.auger@redhat.com>
 <888cf519-8c0e-f781-98a1-86594bdfacb1@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <ccc874c3-75a9-a2b8-1e9d-b762c0f8d6ad@redhat.com>
Date:   Wed, 13 Jan 2021 18:18:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <888cf519-8c0e-f781-98a1-86594bdfacb1@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 1/6/21 6:12 PM, Alexandru Elisei wrote:
> Hi Eric,
> 
> The patch looks correct to me. kvm_vgic_addr() masks out all the bits except index
> from addr, so we don't need to do it in vgic_get_common_attr():
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> One nitpick below.
> 
> On 12/12/20 6:50 PM, Eric Auger wrote:
>> The doc says:
>> "The characteristics of a specific redistributor region can
>>  be read by presetting the index field in the attr data.
>>  Only valid for KVM_DEV_TYPE_ARM_VGIC_V3"
>>
>> Unfortunately the existing code fails to read the input attr data
>> and thus the index always is 0.
> 
> addr is allocated on the stack, I don't think it will always be 0.
I removed this statement in the commit message. Thanks!

Eric
> 
> Thanks,
> Alex
>>
>> Fixes: 04c110932225 ("KVM: arm/arm64: Implement KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION")
>> Cc: stable@vger.kernel.org#v4.17+
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
>> index 44419679f91a..2f66cf247282 100644
>> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
>> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
>> @@ -226,6 +226,9 @@ static int vgic_get_common_attr(struct kvm_device *dev,
>>  		u64 addr;
>>  		unsigned long type = (unsigned long)attr->attr;
>>  
>> +		if (copy_from_user(&addr, uaddr, sizeof(addr)))
>> +			return -EFAULT;
>> +
>>  		r = kvm_vgic_addr(dev->kvm, type, &addr, false);
>>  		if (r)
>>  			return (r == -ENODEV) ? -ENXIO : r;
> 

