Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C744F405963
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 16:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbhIIOoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 10:44:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34734 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348641AbhIIOo0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 10:44:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631198596;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NXI4TwfF9ATuisncE0UeLZfKMl4lBSArTcS01RD5hDM=;
        b=cCv+VNtiYnDZQkVD2aGi6kpHThmqW2G3UH6t5eMd6Xi8DxHS7rvNwxxy2HfxOln4rdGvNL
        SmtGe+OfFp0vh9RKXPcq4ZG17V62LcpjbnlwbgOF/LgI9wf1tbVEgYmmUpOnVTucrOoVlA
        xQSidOFKBZawHnPrmhPHofkFTNvjKSg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-vmi6b5aeO9-S1xjQSZPduA-1; Thu, 09 Sep 2021 10:43:14 -0400
X-MC-Unique: vmi6b5aeO9-S1xjQSZPduA-1
Received: by mail-wr1-f69.google.com with SMTP id i16-20020adfded0000000b001572ebd528eso581087wrn.19
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 07:43:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=NXI4TwfF9ATuisncE0UeLZfKMl4lBSArTcS01RD5hDM=;
        b=R+VE47etRrs5IKCRTytn82idLOpEFk24pyctlt6D/ayRqleuX1JlEH7G4HxhCFr6oh
         Mrm7P+GS+0OULj1Ng58cKerVLG3SluGyocj7Q1iFYNKzcWqNlq/bSFd6FxHlNgh5yAPy
         Zdr0Q24/jkvxhLYIgOvZyRLFmMnVstYuR28pDeLh/tpdyOew8i2j/W00pxfo+Y2iOQnZ
         6SwcrUW+V6LzWUk40CG7xIu6rFK+NceNzStRALOCo4eSh6VHEwMT6PLCa/r02ocQPscm
         83Ccv+zf0wCxVeH2Hn943ueFpDJCAUbFertdSArfVAklB9o3dcBPmWE89U8VDZU2zKYf
         TrKg==
X-Gm-Message-State: AOAM530aZfY/WWyId9eatSZdACy+EcINW0CJ03uAMRQE5iG4Dvurfo5E
        o+x/5sEUT1Mr11EtTzMkLe8UwvFyOU/4M71/um/xBX3Nfbv2Kx35CBXVv3+n4EewH6GLWT1JA8A
        42dG0GOAzYYi2
X-Received: by 2002:adf:ea4d:: with SMTP id j13mr4019750wrn.86.1631198593659;
        Thu, 09 Sep 2021 07:43:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1LuTiwsjnrgw/0AGWEEOKwqU3QmylhI8y8zAc70bSBImbu5FbUVlcZZAs/ShC2AxuK5Z4Jw==
X-Received: by 2002:adf:ea4d:: with SMTP id j13mr4019708wrn.86.1631198593387;
        Thu, 09 Sep 2021 07:43:13 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id a5sm1748509wmm.44.2021.09.09.07.43.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 07:43:12 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: check redist region is not above
 the VM IPA size
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
References: <20210908210320.1182303-1-ricarkol@google.com>
 <20210908210320.1182303-2-ricarkol@google.com>
 <b368e9cf-ec28-1768-edf9-dfdc7fa108f8@arm.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <bd905ebe-f786-9d5b-d19d-03ff5fa1ba14@redhat.com>
Date:   Thu, 9 Sep 2021 16:43:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <b368e9cf-ec28-1768-edf9-dfdc7fa108f8@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 9/9/21 12:20 PM, Alexandru Elisei wrote:
> Hi Ricardo,
>
> On 9/8/21 10:03 PM, Ricardo Koller wrote:
>> Extend vgic_v3_check_base() to verify that the redistributor regions
>> don't go above the VM-specified IPA size (phys_size). This can happen
>> when using the legacy KVM_VGIC_V3_ADDR_TYPE_REDIST attribute with:
>>
>>   base + size > phys_size AND base < phys_size
>>
>> vgic_v3_check_base() is used to check the redist regions bases when
>> setting them (with the vcpus added so far) and when attempting the first
>> vcpu-run.
>>
>> Signed-off-by: Ricardo Koller <ricarkol@google.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-v3.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
>> index 66004f61cd83..5afd9f6f68f6 100644
>> --- a/arch/arm64/kvm/vgic/vgic-v3.c
>> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
>> @@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
>>  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
>>  			rdreg->base)
>>  			return false;
>> +
>> +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
>> +			kvm_phys_size(kvm))
>> +			return false;
> Looks to me like this same check (and the overflow one before it) is done when
> adding a new Redistributor region in kvm_vgic_addr() -> vgic_v3_set_redist_base()
> -> vgic_v3_alloc_redist_region() -> vgic_check_ioaddr(). As far as I can tell,
> kvm_vgic_addr() handles both ways of setting the Redistributor address.
To me vgic_check_ioaddr() does check the base addr but not the end addr.
So looks this fix is needed.
As I commented on the selftest patch, I think you should double check
your fix also handles the KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION case.

In vgic_v3_alloc_redist_region(), in this later case, we know the number
of redistributors in the region (count), so it would be easy to check
the end addr. But I think this would be a duplicate of your new check as
vgic_v3_check_base() also gets called in vgic_register_redist_iodev().
But better to check it ;-)

Thanks

Eric
>
> Without this patch, did you manage to set a base address such that base + size >
> kvm_phys_size()?
>
> Thanks,
>
> Alex
>
>>  	}
>>  
>>  	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))

