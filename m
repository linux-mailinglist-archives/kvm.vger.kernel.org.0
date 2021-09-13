Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B6440878A
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 10:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238170AbhIMIxS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 04:53:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37412 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238043AbhIMIxR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Sep 2021 04:53:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631523121;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yQ6qcVkwWXcAQwHWsCF6TpizTZVzjcq4Fc7qFv2w/0c=;
        b=g+XQaChiGiTuBeBEom7nyS1Cs8COAQrHYvai/DQ06TCZKoaZIHjiFecJ/OGtsX3rWEx8H5
        EOT0Xn3pnfWNEYvwUknXVPhmHGwLp8LL357N3HdgU/BAMEON5lNvsE+nNkMj/JDihIhmUZ
        S8z2Kt1BKoU6HAzLEbj4UuBUmv5dNJA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-XUYCDEX9M-WFoQvY7Z8BRg-1; Mon, 13 Sep 2021 04:51:19 -0400
X-MC-Unique: XUYCDEX9M-WFoQvY7Z8BRg-1
Received: by mail-wm1-f70.google.com with SMTP id j193-20020a1c23ca000000b00306cd53b671so1117884wmj.1
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 01:51:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=yQ6qcVkwWXcAQwHWsCF6TpizTZVzjcq4Fc7qFv2w/0c=;
        b=LKg9TM41Cr8qcN0anjSAIlu/zVkXF04827/JpYpMLoP8jKiETm4YiYeWAG6oG+NJZy
         DrPdOsuiWjFdcsQRlIfOEYiFvQ2GtNFxo43y9GX4Pwu6t2ccoBso7+fehDK1dKQc4wmd
         Vshqm9tQ2j2966VPSEPwUukXsIZ+xSbFF4FA5UkggACIQIQX8/jubxfceglwdSYevKeG
         rgQvl5zseEIfkpG9b5WJCt86T8mBdiVNhZDiMXAh1ey6r7JwgYy9GR1UY7uJag5RhJ8R
         ygae8OH5/xgifbMmPpRQlPwI6gFumCWRxv9XgFjWXRFWb/SXLQmXnLBpDpFWe7N2Vnpd
         QrYg==
X-Gm-Message-State: AOAM533zpKfWG+InymDl/DLzmpzPz8fLvgegALEqYJolu+Mx+y3gaFMa
        MFtwJOf8hDdRYt3rR+g1yq9EO1vhPdVw5Jm4xlKzLNHXLPCbGEkQAlwJ2F7FvdjDJ5rxYZkomv6
        HVNMydMxPNxu9
X-Received: by 2002:a05:600c:3641:: with SMTP id y1mr9799880wmq.43.1631523078431;
        Mon, 13 Sep 2021 01:51:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyL8rcy7Bc5EXWvq4UYnrHr2+E+WLzjm5heQr57n1Cg85esV3EtrwYMhhnX3kqL0QnTk+pyKg==
X-Received: by 2002:a05:600c:3641:: with SMTP id y1mr9799859wmq.43.1631523078195;
        Mon, 13 Sep 2021 01:51:18 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id z13sm7752107wrs.90.2021.09.13.01.51.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 01:51:17 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: check redist region is not above
 the VM IPA size
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
References: <20210908210320.1182303-1-ricarkol@google.com>
 <20210908210320.1182303-2-ricarkol@google.com>
 <b368e9cf-ec28-1768-edf9-dfdc7fa108f8@arm.com> <YTo6kX7jGeR3XvPg@google.com>
 <5eb41efd-2ff2-d25b-5801-f4a56457a09f@arm.com>
 <80bdbdb3-1bff-aa99-c49b-76d6bd960aa9@redhat.com>
 <YTuytfGTDlaoz0yH@google.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <3c521ac9-f18e-e8de-432d-0c0b4a57b737@redhat.com>
Date:   Mon, 13 Sep 2021 10:51:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YTuytfGTDlaoz0yH@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 9/10/21 9:32 PM, Ricardo Koller wrote:
> Hi Alexandru and Eric,
>
> On Fri, Sep 10, 2021 at 10:42:23AM +0200, Eric Auger wrote:
>> Hi Alexandru,
>>
>> On 9/10/21 10:28 AM, Alexandru Elisei wrote:
>>> Hi Ricardo,
>>>
>>> On 9/9/21 5:47 PM, Ricardo Koller wrote:
>>>> On Thu, Sep 09, 2021 at 11:20:15AM +0100, Alexandru Elisei wrote:
>>>>> Hi Ricardo,
>>>>>
>>>>> On 9/8/21 10:03 PM, Ricardo Koller wrote:
>>>>>> Extend vgic_v3_check_base() to verify that the redistributor regions
>>>>>> don't go above the VM-specified IPA size (phys_size). This can happen
>>>>>> when using the legacy KVM_VGIC_V3_ADDR_TYPE_REDIST attribute with:
>>>>>>
>>>>>>   base + size > phys_size AND base < phys_size
>>>>>>
>>>>>> vgic_v3_check_base() is used to check the redist regions bases when
>>>>>> setting them (with the vcpus added so far) and when attempting the first
>>>>>> vcpu-run.
>>>>>>
>>>>>> Signed-off-by: Ricardo Koller <ricarkol@google.com>
>>>>>> ---
>>>>>>  arch/arm64/kvm/vgic/vgic-v3.c | 4 ++++
>>>>>>  1 file changed, 4 insertions(+)
>>>>>>
>>>>>> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
>>>>>> index 66004f61cd83..5afd9f6f68f6 100644
>>>>>> --- a/arch/arm64/kvm/vgic/vgic-v3.c
>>>>>> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
>>>>>> @@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
>>>>>>  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
>>>>>>  			rdreg->base)
>>>>>>  			return false;
>>>>>> +
>>>>>> +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
>>>>>> +			kvm_phys_size(kvm))
>>>>>> +			return false;
>>>>> Looks to me like this same check (and the overflow one before it) is done when
>>>>> adding a new Redistributor region in kvm_vgic_addr() -> vgic_v3_set_redist_base()
>>>>> -> vgic_v3_alloc_redist_region() -> vgic_check_ioaddr(). As far as I can tell,
>>>>> kvm_vgic_addr() handles both ways of setting the Redistributor address.
>>>>>
>>>>> Without this patch, did you manage to set a base address such that base + size >
>>>>> kvm_phys_size()?
>>>>>
>>>> Yes, with the KVM_VGIC_V3_ADDR_TYPE_REDIST legacy API. The easiest way
>>>> to get to this situation is with the selftest in patch 2.  I then tried
>>>> an extra experiment: map the first redistributor, run the first vcpu,
>>>> and access the redist from inside the guest. KVM didn't complain in any
>>>> of these steps.
>>> Yes, Eric pointed out that I was mistaken and there is no check being done for
>>> base + size > kvm_phys_size().
>>>
>>> What I was trying to say is that this check is better done when the user creates a
>>> Redistributor region, not when a VCPU is first run. We have everything we need to
>>> make the check when a region is created, why wait until the VCPU is run?
>>>
>>> For example, vgic_v3_insert_redist_region() is called each time the adds a new
>>> Redistributor region (via either of the two APIs), and already has a check for the
>>> upper limit overflowing (identical to the check in vgic_v3_check_base()). I would
>>> add the check against the maximum IPA size there.
>> you seem to refer to an old kernel as vgic_v3_insert_redist_region was
>> renamed into  vgic_v3_alloc_redist_region in
>> e5a35635464b kvm: arm64: vgic-v3: Introduce vgic_v3_free_redist_region()
>>
>> I think in case you use the old rdist API you do not know yet the size
>> of the redist region at this point (count=0), hence Ricardo's choice to
>> do the check latter.
> Just wanted to add one more detail. vgic_v3_check_base() is also called
> when creating the redistributor region (via vgic_v3_set_redist_base ->
> vgic_register_redist_iodev). This patch reuses that check for the old
> redist API to also check for "base + size > kvm_phys_size()" with a size
> calculated using the vcpus added so far.
>
>>> Also, because vgic_v3_insert_redist_region() already checks for overflow, I
>>> believe the overflow check in vgic_v3_check_base() is redundant.
>>>
> It's redundant for the new redist API, but still needed for the old
> redist API.
>
>>> As far as I can tell, vgic_v3_check_base() is there to make sure that the
>>> Distributor doesn't overlap with any of the Redistributors, and because the
>>> Redistributors and the Distributor can be created in any order, we defer the check
>>> until the first VCPU is run. I might be wrong about this, someone please correct
>>> me if I'm wrong.
>>>
>>> Also, did you verify that KVM is also doing this check for GICv2? KVM does
>>> something similar and calls vgic_v2_check_base() when mapping the GIC resources,
>>> and I don't see a check for the maximum IPA size in that function either.
>> I think vgic_check_ioaddr() called in kvm_vgic_addr() does the job (it
>> checks the base @)
>>
> It seems that GICv2 suffers from the same problem. The cpu interface
> base is checked but the end can extend above IPA size. Note that the cpu
> interface is 8KBs and vgic_check_ioaddr() is only checking that its base
I missed this 8kB thingy.
> is 4KB aligned and below IPA size. The distributor region is 4KB so
> vgic_check_ioaddr() is enough in that case.
>
> What about the following?
>
> I can work on the next version of this patch (v2 has the GICv2 issue)
> which adds vgic_check_range(), which is like vgic_check_ioaddr() but
> with a size arg.  kvm_vgic_addr() can then call vgic_check_range() and
> do all the checks for GICv2 and GICv3. Note that for GICv2, there's no
> need to wait until first vcpu run to do the check. Also note that I will
> have to keep the change in vgic_v3_check_base() to check for the old v3
> redist API at first vcpu run.
Looking forward to reviewing it.

Thanks

Eric
>
> Thanks,
> Ricardo
>
>> Thanks
>>
>> Eric
>>> Thanks,
>>>
>>> Alex
>>>
>>>> Thanks,
>>>> Ricardo
>>>>
>>>>> Thanks,
>>>>>
>>>>> Alex
>>>>>
>>>>>>  	}
>>>>>>  
>>>>>>  	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))

