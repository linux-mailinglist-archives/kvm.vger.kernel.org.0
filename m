Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEA841D3E2
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 09:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348492AbhI3HHf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 03:07:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26011 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233661AbhI3HHe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Sep 2021 03:07:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632985552;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NPxgFLmqZWu1Kx8EeiiAue/eLiILneW6MYMbx6p9Jvo=;
        b=Lnyp1Ucfrz3eBFaW48b+u0VpD6802BoF356HM5zDOSzVd2+wlIVHfj708Rm0iHWBwWOyN4
        IzYPZEmzcWdBLdnzH3ygVJ0SebS5al2TDJsYy1hvX0I46WxSyejSShQ2a5mTtHr4bcTy7p
        ImfEKk/0ESk1fThs0J6RTMwfejYG3+g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-vGEafEW9NlaQ22nlfU8_BQ-1; Thu, 30 Sep 2021 03:05:50 -0400
X-MC-Unique: vGEafEW9NlaQ22nlfU8_BQ-1
Received: by mail-wr1-f70.google.com with SMTP id j16-20020adfa550000000b0016012acc443so1322131wrb.14
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 00:05:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=NPxgFLmqZWu1Kx8EeiiAue/eLiILneW6MYMbx6p9Jvo=;
        b=KqZmB6U5GqjBkbpB+V8hrzH9EdAuekk90mA0jI+XMTD+A/vtL3TMliLWZAlhabZULb
         8JZlVbEmjVrvKqQaMUjApYiEWageq4ieDEAPcnT3EVFg7uTAhYsYDiqXOVzRVwtwfhjU
         /1Ng5c5a4j1HM7cbdDgHEX/NmOafqmBSmIv1jxfJXmxdKkDgfWhgikbRCbArjG7YVrfq
         14CijGipO2HG/VNzZFCRTA7OAGGOLEOXfN4SnHBsA+TGzOOiQzjTpCSuoHYxxoQQ7Eme
         RfN+j7KPiWh+ilYzuxemBrYMyu3OhoUtmdnu3FyBhtCq2L08WGd8l7BD3b0pWatng7a1
         JSlw==
X-Gm-Message-State: AOAM533vg5lFrjB5RHuu2uJ9YGnojm/2jLj7vDxkOOIO7F64o9ZHtoJM
        ksD06rgU1hOOpD/60jfjdJ732I1EMGcRFWIsnbh5lwF9hvHcLmPMdm7B3TwtlPFZU36FG7TAmrR
        icgX65OthU2ca
X-Received: by 2002:adf:fe11:: with SMTP id n17mr4301767wrr.134.1632985549724;
        Thu, 30 Sep 2021 00:05:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPFzm1+CNYCOyn9mGIKj/RMEWH6HvJ5lcr4FpM7YtYjgUAbjlCnpqy/qSj/9ubMkgG9Yyp/A==
X-Received: by 2002:adf:fe11:: with SMTP id n17mr4301747wrr.134.1632985549481;
        Thu, 30 Sep 2021 00:05:49 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id g21sm1934742wmk.10.2021.09.30.00.05.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 00:05:49 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 02/10] KVM: arm64: vgic-v3: Check redist region is not
 above the VM IPA size
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, alexandru.elisei@arm.com,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-3-ricarkol@google.com>
 <01a03d81-e98b-a504-f4b7-e4a56ffa78d5@redhat.com>
 <YVTWVf26yYNUUx2L@google.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <dac39cc1-16d7-caed-833f-03943b0e6211@redhat.com>
Date:   Thu, 30 Sep 2021 09:05:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YVTWVf26yYNUUx2L@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 9/29/21 11:10 PM, Ricardo Koller wrote:
> Hi Eric,
>
> On Wed, Sep 29, 2021 at 06:23:04PM +0200, Eric Auger wrote:
>> Hi Ricardo,
>>
>> On 9/28/21 8:47 PM, Ricardo Koller wrote:
>>> Verify that the redistributor regions do not extend beyond the
>>> VM-specified IPA range (phys_size). This can happen when using
>>> KVM_VGIC_V3_ADDR_TYPE_REDIST or KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS
>>> with:
>>>
>>>   base + size > phys_size AND base < phys_size
>>>
>>> Add the missing check into vgic_v3_alloc_redist_region() which is called
>>> when setting the regions, and into vgic_v3_check_base() which is called
>>> when attempting the first vcpu-run. The vcpu-run check does not apply to
>>> KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS because the regions size is known
>>> before the first vcpu-run. Note that using the REDIST_REGIONS API
>>> results in a different check, which already exists, at first vcpu run:
>>> that the number of redist regions is enough for all vcpus.
>>>
>>> Finally, this patch also enables some extra tests in
>>> vgic_v3_alloc_redist_region() by calculating "size" early for the legacy
>>> redist api: like checking that the REDIST region can fit all the already
>>> created vcpus.
>>>
>>> Signed-off-by: Ricardo Koller <ricarkol@google.com>
>>> ---
>>>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 6 ++++--
>>>  arch/arm64/kvm/vgic/vgic-v3.c      | 4 ++++
>>>  2 files changed, 8 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>>> index a09cdc0b953c..9be02bf7865e 100644
>>> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>>> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>>> @@ -796,7 +796,9 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
>>>  	struct vgic_dist *d = &kvm->arch.vgic;
>>>  	struct vgic_redist_region *rdreg;
>>>  	struct list_head *rd_regions = &d->rd_regions;
>>> -	size_t size = count * KVM_VGIC_V3_REDIST_SIZE;
>>> +	int nr_vcpus = atomic_read(&kvm->online_vcpus);
>>> +	size_t size = count ? count * KVM_VGIC_V3_REDIST_SIZE
>>> +			    : nr_vcpus * KVM_VGIC_V3_REDIST_SIZE;
>> This actually fixes the  vgic_dist_overlap(kvm, base, size=0)
>>
>> in case the number of online-vcpus at that time is less than the final
>> one (1st run), if count=0 (legacy API) do we ever check that the RDIST
>> (with accumulated vcpu rdists) does not overlap with dist.
>> in other words shouldn't we call vgic_dist_overlap(kvm, base, size)
>> again in vgic_v3_check_base().
>>
> I think we're good; that's checked by vgic_v3_rdist_overlap(dist_base)
> in vgic_v3_check_base(). This function uses the only region (legacy
> case) using a size based on the online_vcpus (in
> vgic_v3_rd_region_size()).  This exact situation is tested by
> test_vgic_then_vcpus() in the vgic_init selftest.
Ah OK so that's fine then.

So looks good to me
Reviewed-by: Eric Auger <eric.auger@redhat.com>


Eric


>
> Thanks,
> Ricardo
>
>> Thanks
>>
>> Eric
>>
>>>  	int ret;
>>>  
>>>  	/* cross the end of memory ? */
>>> @@ -840,7 +842,7 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
>>>  
>>>  	rdreg->base = VGIC_ADDR_UNDEF;
>>>  
>>> -	ret = vgic_check_ioaddr(kvm, &rdreg->base, base, SZ_64K);
>>> +	ret = vgic_check_iorange(kvm, &rdreg->base, base, SZ_64K, size);
>>>  	if (ret)
>>>  		goto free;
>>>  
>>> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
>>> index 21a6207fb2ee..27ee674631b3 100644
>>> --- a/arch/arm64/kvm/vgic/vgic-v3.c
>>> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
>>> @@ -486,6 +486,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
>>>  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
>>>  			rdreg->base)
>>>  			return false;
>>> +
>>> +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
>>> +			kvm_phys_size(kvm))
>>> +			return false;
>>>  	}
>>>  
>>>  	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))

