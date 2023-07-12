Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62FD750C3C
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 17:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbjGLPSX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 11:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbjGLPSU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 11:18:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78342118
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 08:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689175036;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RC3T8Znu/c0MPGyPswrHLQgfCZgwNSw5LShJy5fxeDE=;
        b=QPupevcDCy0v5tnhGgIE+9OoNXYkHdQ13uS5lt6gIr2zlqLxxhFtSzzz1zH29lgrCbAz1H
        +mkpnc20gZcCN9TaJNQZuuUXPd+DQxUj7iqLI1lu5QtmNpI4zJQ6NJeGkJeUydAoyv3ec3
        A+wt3LBIqzwkhHcFpTWS/zyUeHVu668=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-GkIXdu9PMiqoqUaDpxFDIQ-1; Wed, 12 Jul 2023 11:17:08 -0400
X-MC-Unique: GkIXdu9PMiqoqUaDpxFDIQ-1
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-47e114de3b7so821591e0c.3
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 08:17:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689175028; x=1689779828;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RC3T8Znu/c0MPGyPswrHLQgfCZgwNSw5LShJy5fxeDE=;
        b=gsrAK7yq0z/zW0BqCmkxqaUbVyeLnLysXVlIeYgbjmzIsD6T9CXpc4Bnf7dQwd02+G
         QEQbcJopabMSsbwP6OtM3V2avot87jraGqEY5QvuDHAettc7Uk0FENRKUv7TIC6TIM2O
         OjQDFPWInHQoKY3ni/0MTNNwy7f1Zxsh/aeCwbV+GLGNAZTss8GmsiPo0eUtjB481Yn7
         iQpDfrZcBUt8RKtsLCgNTOnBpoILVyCPDOB94ikLUFcE+Bi2FU55sDNmNBfZp5lYzSeB
         u/B9My6V5kE5caB1mVFpq8ERop2Y0fLls8JyPWcmhCyv9lrcDm4dutypjJv0aBaECDHL
         l+iQ==
X-Gm-Message-State: ABy/qLZ9iETLRmb4sUIxg7ksyBgLFlaUgV+DezB6xLh+/zj2UsOmDBsI
        4gnbt4yyD/o0E0q7NBBLEs1s2sbpeur5Y7hLQ/zEa8PFjsuDCyqOu6dq9YDaTj5wtaNiAci27W5
        avKzobzffiRAd
X-Received: by 2002:a1f:5642:0:b0:471:348a:7b8d with SMTP id k63-20020a1f5642000000b00471348a7b8dmr6814920vkb.8.1689175027497;
        Wed, 12 Jul 2023 08:17:07 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEhrk4IListbPe/NH7kfUMjrsF5jIC1gblYrqR5h06skAA7EKXmTM/BJM6Iej+AsNFOHypoVQ==
X-Received: by 2002:a1f:5642:0:b0:471:348a:7b8d with SMTP id k63-20020a1f5642000000b00471348a7b8dmr6814868vkb.8.1689175025742;
        Wed, 12 Jul 2023 08:17:05 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id a20-20020a0cca94000000b00631f02c2279sm2248270qvk.90.2023.07.12.08.17.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jul 2023 08:17:05 -0700 (PDT)
Message-ID: <f1e3b52d-bb6b-6d1d-5194-1a445a1d7cf1@redhat.com>
Date:   Wed, 12 Jul 2023 17:16:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 00/27] KVM: arm64: NV trap forwarding infrastructure
Content-Language: en-US
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
References: <20230712145810.3864793-1-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230712145810.3864793-1-maz@kernel.org>
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

Hi Marc,

On 7/12/23 16:57, Marc Zyngier wrote:
> As people are getting tired of seeing the full NV series, I've
> extracted some of the easy stuff which I'm targeting for 6.6.
>
> This implements the so called "trap forwarding" infrastructure, which
> gets used when we take a trap from an L2 guest and that the L1 guest
> wants to see the trap for itself.
>
> Most of the series is pretty boring stuff, mostly a long list of
> encodings which are mapped to a set of trap bits. I swear they are
> correct. Sort of.
>
> The interesting bit is around how we compute the trap result, which is
> pretty complex due to the layers of crap the architecture has piled
> over the years (a single op can be trapped by multiple coarse grained
> trap bits, or a fine grained trap bit, which may itself be conditioned
> by another control bit -- madness).
>
> This also results in some rework of both the FGT stuff (for which I
> carry a patch from Mark) and newly introduced the HCRX support.
>
> With that (and the rest of the NV series[1]), FGT gets exposed to guests
> and the trapping seems to work as expected.
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-6.6-WIP

I have not received patches 10-27 and I do not see them on lore archive
https://lore.kernel.org/all/20230712145810.3864793-1-maz@kernel.org/#r

Thanks

Eric
>
> Marc Zyngier (26):
>   arm64: Add missing VA CMO encodings
>   arm64: Add missing ERX*_EL1 encodings
>   arm64: Add missing DC ZVA/GVA/GZVA encodings
>   arm64: Add TLBI operation encodings
>   arm64: Add AT operation encodings
>   arm64: Add debug registers affected by HDFGxTR_EL2
>   arm64: Add missing BRB/CFP/DVP/CPP instructions
>   arm64: Fix HFGxTR_EL2 field naming
>   arm64: Add HDFGRTR_EL2 and HDFGWTR_EL2 layouts
>   KVM: arm64: Correctly handle ACCDATA_EL1 traps
>   KVM: arm64: Add missing HCR_EL2 trap bits
>   KVM: arm64: nv: Add FGT registers
>   KVM: arm64: Restructure FGT register switching
>   KVM: arm64: nv: Add trap forwarding infrastructure
>   KVM: arm64: nv: Add trap forwarding for HCR_EL2
>   KVM: arm64: nv: Expose FEAT_EVT to nested guests
>   KVM: arm64: nv: Add trap forwarding for MDCR_EL2
>   KVM: arm64: nv: Add trap forwarding for CNTHCTL_EL2
>   KVM: arm64: nv: Add trap forwarding for HFGxTR_EL2
>   KVM: arm64: nv: Add trap forwarding for HFGITR_EL2
>   KVM: arm64: nv: Add trap forwarding for HDFGxTR_EL2
>   KVM: arm64: nv: Add SVC trap forwarding
>   KVM: arm64: nv: Add switching support for HFGxTR/HDFGxTR
>   KVM: arm64: nv: Expose FGT to nested guests
>   KVM: arm64: Move HCRX_EL2 switch to load/put on VHE systems
>   KVM: arm64: nv: Add support for HCRX_EL2
>
> Mark Brown (1):
>   arm64: Add feature detection for fine grained traps
>
>  arch/arm64/include/asm/kvm_arm.h        |   50 +
>  arch/arm64/include/asm/kvm_host.h       |    7 +
>  arch/arm64/include/asm/kvm_nested.h     |    2 +
>  arch/arm64/include/asm/sysreg.h         |  270 +++-
>  arch/arm64/kernel/cpufeature.c          |   11 +
>  arch/arm64/kvm/arm.c                    |    4 +
>  arch/arm64/kvm/emulate-nested.c         | 1703 +++++++++++++++++++++++
>  arch/arm64/kvm/handle_exit.c            |   12 +
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  126 +-
>  arch/arm64/kvm/nested.c                 |   11 +-
>  arch/arm64/kvm/sys_regs.c               |   15 +
>  arch/arm64/kvm/trace_arm.h              |   19 +
>  arch/arm64/tools/cpucaps                |    1 +
>  arch/arm64/tools/sysreg                 |  141 +-
>  14 files changed, 2326 insertions(+), 46 deletions(-)
>

