Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976B3466457
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 14:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358189AbhLBNPk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 08:15:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55697 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358266AbhLBNOz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 08:14:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638450691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ORZwySvXsS7bVMV6iSSKGBVEj6KTyOWMLSUM7WG+EM=;
        b=CtM7bNFm1bMCYK6mSnvMSdQj6h9KG8gqZG5c9BMdf6lTS9jBnzGCavUlZPUEk4Ao641gKJ
        v4vuYacmLhhhvoPbQThKen1R5kopNmieAyNl+V6ooCGqqa7ATrtoigzNMAS0ev4gxoouam
        vlMbIlTf2LXxAcH9bzIlvni1kGiob2I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-n_lAM_xhOkWDnRIGUb7T5A-1; Thu, 02 Dec 2021 08:11:30 -0500
X-MC-Unique: n_lAM_xhOkWDnRIGUb7T5A-1
Received: by mail-wm1-f71.google.com with SMTP id a64-20020a1c7f43000000b003335e5dc26bso13963041wmd.8
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 05:11:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+ORZwySvXsS7bVMV6iSSKGBVEj6KTyOWMLSUM7WG+EM=;
        b=feszcswNIiQ0GYI72JTvMImgI/s47yBVlNes7i5khgIZJCexX7MPWh8N+iPTczO3f6
         fEPhffyVH+wUs/RhqPybRsQiyEIQKPv/wH69yD73pyEaKOyKcl49fYxG8sXCkMWQ+pjd
         n0gkh1JzeDb1fa0EpcYQPyvkRY4p7iyc5szJyjx8vttmu7Cwj0x/ya8jK4YMpDD/IL9e
         XzXp+3ilFM3l5Ocbo8/gjp/yQ3s8ooiWQdVeU9nzPoqNzD70JL9hZ2kcBKk6CCielGwJ
         s0YwBJounUcnmdRXPSLMSghX5JS113LcUks62ahCIVVK6oFUbAuBqUIp1ofniR7s7M1S
         04ow==
X-Gm-Message-State: AOAM531o9QdZd40O9+ySZJtKusYb83keBLkoQSkseFlR639l+Uskjvji
        +SAcMZi7iXxPI/iUQiL68OuU2z7lavPd8kPPUAUyHLAGL05jR/WzqSTRlMdCzFi/nykCT3MpreJ
        n3I8IPawm+78k
X-Received: by 2002:adf:dc47:: with SMTP id m7mr14456746wrj.576.1638450689186;
        Thu, 02 Dec 2021 05:11:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzRywFER8Vz2gbwjUzZSItMbLcPLhaPUjX8ZwPMMxFDRKOO8TYuB0M5JAWiIxd6BSWzMOBhjg==
X-Received: by 2002:adf:dc47:: with SMTP id m7mr14456719wrj.576.1638450689005;
        Thu, 02 Dec 2021 05:11:29 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id h22sm2174819wmq.14.2021.12.02.05.11.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 05:11:28 -0800 (PST)
Subject: Re: [RFC PATCH v3 12/29] KVM: arm64: Make ID_DFR1_EL1 writable
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-13-reijiw@google.com>
 <44073484-639e-3d23-2068-ae5c2cac3276@redhat.com>
 <CAAeT=FyBaKvof6BpPB021MN6k797BcMP+sPMDeiZ9SR6nvXdCA@mail.gmail.com>
From:   Eric Auger <eauger@redhat.com>
Message-ID: <7a2ef550-eadb-7fa3-8aa4-f666a14d6efa@redhat.com>
Date:   Thu, 2 Dec 2021 14:11:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAeT=FyBaKvof6BpPB021MN6k797BcMP+sPMDeiZ9SR6nvXdCA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/30/21 6:39 AM, Reiji Watanabe wrote:
> Hi Eric,
> 
> On Thu, Nov 25, 2021 at 12:30 PM Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Reiji,
>>
>> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
>>> This patch adds id_reg_info for ID_DFR1_EL1 to make it writable
>>> by userspace.
>>>
>>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
>>> ---
>>>  arch/arm64/kvm/sys_regs.c | 6 ++++++
>>>  1 file changed, 6 insertions(+)
>>>
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index fbd335ac5e6b..dda7001959f6 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -859,6 +859,11 @@ static struct id_reg_info id_dfr0_el1_info = {
>>>       .get_reset_val = get_reset_id_dfr0_el1,
>>>  };
>>>
>>> +static struct id_reg_info id_dfr1_el1_info = {
>>> +     .sys_reg = SYS_ID_DFR1_EL1,
>>> +     .ftr_check_types = S_FCT(ID_DFR1_MTPMU_SHIFT, FCT_LOWER_SAFE),
>> what about the 0xF value which indicates the MTPMU is not implemented?
> 
> The field is treated as a signed field.
> So, 0xf(== -1) is handled correctly.
> (Does it answer your question?)

yes thanks

Eric
> 
> Thanks,
> Reiji
> 
>>
>> Eric
>>> +};
>>> +
>>>  /*
>>>   * An ID register that needs special handling to control the value for the
>>>   * guest must have its own id_reg_info in id_reg_info_table.
>>> @@ -869,6 +874,7 @@ static struct id_reg_info id_dfr0_el1_info = {
>>>  #define      GET_ID_REG_INFO(id)     (id_reg_info_table[IDREG_IDX(id)])
>>>  static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
>>>       [IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
>>> +     [IDREG_IDX(SYS_ID_DFR1_EL1)] = &id_dfr1_el1_info,
>>>       [IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
>>>       [IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
>>>       [IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
>>>
>>
> 

