Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B4A2F5E48
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 11:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbhANKEb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 05:04:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22387 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727906AbhANKEa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 05:04:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610618584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xXjNcBX1zyUVY22wn0iABMXWOTnE52HCbnMakakpYNA=;
        b=euxPsAD0CbMAGaGMbF5URSRSbLx8ugkPuHuxqOg4ISaGhriDuqwWc3AIXlfUBJMIwMpcza
        F2A4hfvklSQAzQiE6o9KVHJVD95D8S3Z7PfTf09p1GaPXK+JfDFpDb1fYU95NHA5idfFaM
        6SZi7nwLGR4VJK5gApuolbioPVvPt8g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-p58qiEhWMVmNF5ryZwfFhw-1; Thu, 14 Jan 2021 05:03:01 -0500
X-MC-Unique: p58qiEhWMVmNF5ryZwfFhw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8338084A5E8;
        Thu, 14 Jan 2021 10:02:59 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B7CBF71D60;
        Thu, 14 Jan 2021 10:02:56 +0000 (UTC)
Subject: Re: [PATCH 1/9] KVM: arm64: vgic-v3: Fix some error codes when
 setting RDIST base
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        drjones@redhat.com
Cc:     james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-2-eric.auger@redhat.com>
 <fa73780d-b72b-6810-460e-5ed1057df093@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <e37f1942-dcb7-3579-0aba-e131e4bd9217@redhat.com>
Date:   Thu, 14 Jan 2021 11:02:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <fa73780d-b72b-6810-460e-5ed1057df093@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 1/6/21 5:32 PM, Alexandru Elisei wrote:
> Hi Eric,
> 
> On 12/12/20 6:50 PM, Eric Auger wrote:
>> KVM_DEV_ARM_VGIC_GRP_ADDR group doc says we should return
>> -EEXIST in case the base address of the redist is already set.
>> We currently return -EINVAL.
>>
>> However we need to return -EINVAL in case a legacy REDIST address
>> is attempted to be set while REDIST_REGIONS were set. This case
>> is discriminated by looking at the count field.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> index 15a6c98ee92f..8e8a862def76 100644
>> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> @@ -792,8 +792,13 @@ static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
>>  	int ret;
>>  
>>  	/* single rdist region already set ?*/
>> -	if (!count && !list_empty(rd_regions))
>> -		return -EINVAL;
>> +	if (!count && !list_empty(rd_regions)) {
>> +		rdreg = list_last_entry(rd_regions,
>> +				       struct vgic_redist_region, list);
>> +		if (rdreg->count)
>> +			return -EINVAL; /* Mixing REDIST and REDIST_REGION API */
>> +		return -EEXIST;
>> +	}
> 
> A few instructions below:
> 
>     if (list_empty(rd_regions)) {
>         [..]
>     } else {
>         rdreg = list_last_entry(rd_regions,
>                     struct vgic_redist_region, list);
>         [..]
> 
>         /* Cannot add an explicitly sized regions after legacy region */
>         if (!rdreg->count)
>             return -EINVAL;
>     }
> 
> Isn't this testing for the same thing, but using the opposite condition? Or am I
> misunderstanding the code (quite likely)?
the 1st test sequence handles the case where the legacy
KVM_VGIC_V3_ADDR_TYPE_REDIST is used (!count) while the second handles
the case where the REDIST_REGION is used. Nevertheless I think this can
be simplified into:

        if (list_empty(rd_regions)) {
                if (index != 0)
                        return -EINVAL;
        } else {
                rdreg = list_last_entry(rd_regions,
                                        struct vgic_redist_region, list);

                if ((!count) != (!rdreg->count))
                        return -EINVAL; /* Mix REDIST and REDIST_REGION */

                if (!count)
                        return -EEXIST;

                if (index != rdreg->index + 1)
                        return -EINVAL;
        }






> 
> Looks to me like KVM_DEV_ARM_VGIC_GRP_ADDR(KVM_VGIC_V3_ADDR_TYPE_REDIST{,_REGION})
> used to return -EEXIST (from vgic_check_ioaddr()) before commit ccc27bf5be7b7
> ("KVM: arm/arm64: Helper to register a new redistributor region") which added the
> vgic_v3_insert_redist_region() function, so bringing back the -EEXIST return code
> looks the right thing to me.

OK thank you for the detailed study.

Eric
> 
> Thanks,
> Alex
>>  
>>  	/* cross the end of memory ? */
>>  	if (base + size < base)
> 

