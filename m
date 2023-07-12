Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78019750C7C
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 17:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbjGLPaf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 11:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbjGLPac (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 11:30:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E99E1BE8
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 08:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689175777;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0wpptoa13iOAA2eHt3VMAIlTNSbRsG5Q+DUZsMk48HA=;
        b=SaHCmRKVkBhywnVD7symyC+KfrppXh2PS5UBiuCC2/K2UOhD/kZWSSIgv8XTPsQrIyZnH0
        3yJH+JZohARRTdTLuBov6YuCPUHStBfOwRPb/wmPu5iOo7hcS26GMHF6P74jhhuOjldnve
        5rAtqcyPFBxtKBhAuYZLczN6LV9Rjd0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-efGUxTx6P6mcKJn8FUepkQ-1; Wed, 12 Jul 2023 11:29:35 -0400
X-MC-Unique: efGUxTx6P6mcKJn8FUepkQ-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7659924cf20so693205485a.2
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 08:29:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689175769; x=1689780569;
        h=content-transfer-encoding:in-reply-to:references:reply-to:cc:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0wpptoa13iOAA2eHt3VMAIlTNSbRsG5Q+DUZsMk48HA=;
        b=AY6HwOR8GBFZYalecfo9vl+q9xgTbS4uuasDCCAQuw9yka9gkTUvo6ZIhcRuz/9lmF
         udJAvfUD4SvG28PIorjjcY2sBGhx9HxvoDzZP3q8i4sQASY6EKeifLTzLs4onC7n88Cz
         /OHeAKZC1k6GobPX+dkZ0m2WPMDZhm0HWKowp59GwOFhrDQwHGpPsuaa2zyI8QgLx8PF
         bXLx8oIYA1m5jst8Nrfr5tt5DfyP+jNQg7xSdeztWdPmr3rOxGB6N/U8kt5yLCQLPPqH
         ewY7LYxrwWeJq74Ohnlofd3yeoimzkLQSJVK/acPEUScStUoyA2RZ0bGi1lUz4k+KVtM
         ji3Q==
X-Gm-Message-State: ABy/qLa8TrjKNC/BYTzarhiSbH+k9D/vAd2ODhRPSWMZIGQH15EgHNmw
        xvgQ8UVmxp3hXT+tI/yC3iZxwepK4CmU0ntFZcTmjZoVLROPvczEDwJFOI9f5uRuPWB/sYnD+Dm
        H9C+v6Z8Ao3/I
X-Received: by 2002:a05:620a:24d3:b0:765:a828:7d02 with SMTP id m19-20020a05620a24d300b00765a8287d02mr21371766qkn.24.1689175769599;
        Wed, 12 Jul 2023 08:29:29 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFwqlGaun9VRfsJk+xBXYQQRWJBoUgTzbPMVWczaf/7qJOdeBt6gjx7mXtgfckw9FV3yiXQSA==
X-Received: by 2002:a05:620a:24d3:b0:765:a828:7d02 with SMTP id m19-20020a05620a24d300b00765a8287d02mr21371739qkn.24.1689175769353;
        Wed, 12 Jul 2023 08:29:29 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id w14-20020a05620a148e00b00767b4fa5d96sm2231565qkj.27.2023.07.12.08.29.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jul 2023 08:29:28 -0700 (PDT)
Message-ID: <3501eaf9-5b24-8c4c-939b-79cdc43cfc25@redhat.com>
Date:   Wed, 12 Jul 2023 17:29:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 00/27] KVM: arm64: NV trap forwarding infrastructure
Content-Language: en-US
From:   Eric Auger <eric.auger@redhat.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Reply-To: eric.auger@redhat.com, eric.auger@redhat.com
References: <20230712145810.3864793-1-maz@kernel.org>
 <f1e3b52d-bb6b-6d1d-5194-1a445a1d7cf1@redhat.com>
In-Reply-To: <f1e3b52d-bb6b-6d1d-5194-1a445a1d7cf1@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 7/12/23 17:16, Eric Auger wrote:
> Hi Marc,
> 
> On 7/12/23 16:57, Marc Zyngier wrote:
>> As people are getting tired of seeing the full NV series, I've
>> extracted some of the easy stuff which I'm targeting for 6.6.
>>
>> This implements the so called "trap forwarding" infrastructure, which
>> gets used when we take a trap from an L2 guest and that the L1 guest
>> wants to see the trap for itself.
>>
>> Most of the series is pretty boring stuff, mostly a long list of
>> encodings which are mapped to a set of trap bits. I swear they are
>> correct. Sort of.
>>
>> The interesting bit is around how we compute the trap result, which is
>> pretty complex due to the layers of crap the architecture has piled
>> over the years (a single op can be trapped by multiple coarse grained
>> trap bits, or a fine grained trap bit, which may itself be conditioned
>> by another control bit -- madness).
>>
>> This also results in some rework of both the FGT stuff (for which I
>> carry a patch from Mark) and newly introduced the HCRX support.
>>
>> With that (and the rest of the NV series[1]), FGT gets exposed to guests
>> and the trapping seems to work as expected.
>>
>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-6.6-WIP
> 
> I have not received patches 10-27 and I do not see them on lore archive
> https://lore.kernel.org/all/20230712145810.3864793-1-maz@kernel.org/#r

Hum I was too eager to see them. Now I have received everything and they
are all visible on lore.

Sorry for the noise

Eric
> 
> Thanks
> 
> Eric
>>
>> Marc Zyngier (26):
>>   arm64: Add missing VA CMO encodings
>>   arm64: Add missing ERX*_EL1 encodings
>>   arm64: Add missing DC ZVA/GVA/GZVA encodings
>>   arm64: Add TLBI operation encodings
>>   arm64: Add AT operation encodings
>>   arm64: Add debug registers affected by HDFGxTR_EL2
>>   arm64: Add missing BRB/CFP/DVP/CPP instructions
>>   arm64: Fix HFGxTR_EL2 field naming
>>   arm64: Add HDFGRTR_EL2 and HDFGWTR_EL2 layouts
>>   KVM: arm64: Correctly handle ACCDATA_EL1 traps
>>   KVM: arm64: Add missing HCR_EL2 trap bits
>>   KVM: arm64: nv: Add FGT registers
>>   KVM: arm64: Restructure FGT register switching
>>   KVM: arm64: nv: Add trap forwarding infrastructure
>>   KVM: arm64: nv: Add trap forwarding for HCR_EL2
>>   KVM: arm64: nv: Expose FEAT_EVT to nested guests
>>   KVM: arm64: nv: Add trap forwarding for MDCR_EL2
>>   KVM: arm64: nv: Add trap forwarding for CNTHCTL_EL2
>>   KVM: arm64: nv: Add trap forwarding for HFGxTR_EL2
>>   KVM: arm64: nv: Add trap forwarding for HFGITR_EL2
>>   KVM: arm64: nv: Add trap forwarding for HDFGxTR_EL2
>>   KVM: arm64: nv: Add SVC trap forwarding
>>   KVM: arm64: nv: Add switching support for HFGxTR/HDFGxTR
>>   KVM: arm64: nv: Expose FGT to nested guests
>>   KVM: arm64: Move HCRX_EL2 switch to load/put on VHE systems
>>   KVM: arm64: nv: Add support for HCRX_EL2
>>
>> Mark Brown (1):
>>   arm64: Add feature detection for fine grained traps
>>
>>  arch/arm64/include/asm/kvm_arm.h        |   50 +
>>  arch/arm64/include/asm/kvm_host.h       |    7 +
>>  arch/arm64/include/asm/kvm_nested.h     |    2 +
>>  arch/arm64/include/asm/sysreg.h         |  270 +++-
>>  arch/arm64/kernel/cpufeature.c          |   11 +
>>  arch/arm64/kvm/arm.c                    |    4 +
>>  arch/arm64/kvm/emulate-nested.c         | 1703 +++++++++++++++++++++++
>>  arch/arm64/kvm/handle_exit.c            |   12 +
>>  arch/arm64/kvm/hyp/include/hyp/switch.h |  126 +-
>>  arch/arm64/kvm/nested.c                 |   11 +-
>>  arch/arm64/kvm/sys_regs.c               |   15 +
>>  arch/arm64/kvm/trace_arm.h              |   19 +
>>  arch/arm64/tools/cpucaps                |    1 +
>>  arch/arm64/tools/sysreg                 |  141 +-
>>  14 files changed, 2326 insertions(+), 46 deletions(-)
>>
> 

