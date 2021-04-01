Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBEB351C1A
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236840AbhDASNK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:13:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60877 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238817AbhDASKM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 14:10:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617300611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cc3k8MO13oibHy+9e3XEGxkpJb9ZoYiN6eARau7Wqk8=;
        b=hvFDMM8ADLPRBWUVVE1dWk9MDHiOZVMe/ruPLYDia/S22msT57XSGrESVaf94VnSNlXWwK
        trFX5B84CxEikEFtpxuh8Z0C/MgdKE6h2xZLP46nmZipkT5071v+txLdqBpwgNMBSx0Wyc
        sLADgfNLSsEAa3iSiTtUG6YS/YJEGOQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-7sofkHCGOwurHwhGCrWEYQ-1; Thu, 01 Apr 2021 07:43:52 -0400
X-MC-Unique: 7sofkHCGOwurHwhGCrWEYQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93E7B801814;
        Thu,  1 Apr 2021 11:43:50 +0000 (UTC)
Received: from [10.36.112.13] (ovpn-112-13.ams2.redhat.com [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E04B716917;
        Thu,  1 Apr 2021 11:43:47 +0000 (UTC)
Subject: Re: [PATCH v4 1/8] KVM: arm64: vgic-v3: Fix some error codes when
 setting RDIST base
To:     Marc Zyngier <maz@kernel.org>
Cc:     eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, alexandru.elisei@arm.com, james.morse@arm.com,
        suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
References: <20210401085238.477270-1-eric.auger@redhat.com>
 <20210401085238.477270-2-eric.auger@redhat.com>
 <87wntmp99c.wl-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <419be8ac-6fbb-a712-a398-311ca68d52f9@redhat.com>
Date:   Thu, 1 Apr 2021 13:43:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <87wntmp99c.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 4/1/21 12:52 PM, Marc Zyngier wrote:
> Hi Eric,
> 
> On Thu, 01 Apr 2021 09:52:31 +0100,
> Eric Auger <eric.auger@redhat.com> wrote:
>>
>> KVM_DEV_ARM_VGIC_GRP_ADDR group doc says we should return
>> -EEXIST in case the base address of the redist is already set.
>> We currently return -EINVAL.
>>
>> However we need to return -EINVAL in case a legacy REDIST address
>> is attempted to be set while REDIST_REGIONS were set. This case
>> is discriminated by looking at the count field.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v1 -> v2:
>> - simplify the check sequence
>> ---
>>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 15 +++++++--------
>>  1 file changed, 7 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> index 15a6c98ee92f0..013b737b658f8 100644
>> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> @@ -791,10 +791,6 @@ static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
>>  	size_t size = count * KVM_VGIC_V3_REDIST_SIZE;
>>  	int ret;
>>  
>> -	/* single rdist region already set ?*/
>> -	if (!count && !list_empty(rd_regions))
>> -		return -EINVAL;
>> -
>>  	/* cross the end of memory ? */
>>  	if (base + size < base)
>>  		return -EINVAL;
>> @@ -805,11 +801,14 @@ static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
>>  	} else {
>>  		rdreg = list_last_entry(rd_regions,
>>  					struct vgic_redist_region, list);
>> -		if (index != rdreg->index + 1)
>> -			return -EINVAL;
>>  
>> -		/* Cannot add an explicitly sized regions after legacy region */
>> -		if (!rdreg->count)
>> +		if ((!count) != (!rdreg->count))
>> +			return -EINVAL; /* Mix REDIST and REDIST_REGION */
> 
> Urgh... The triple negation killed me. Can we come up with a more
> intuitive expression? Something like:

Yes sometimes I can be "different" ;-)
> 
> 		/* Don't mix single region and discrete redist regions */
> 		if (!count && rdreg->count)
> 			return -EINVAL;>
> Does it capture what you want to express?

yes it does!

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 

