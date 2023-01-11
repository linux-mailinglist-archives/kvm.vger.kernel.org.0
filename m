Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF26E666673
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 23:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbjAKWxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 17:53:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjAKWxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 17:53:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D07DF5F
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 14:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673477541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1vvFOlgZcmbBXel/bkUj30X9nLvjQk+79xN6sEwmowg=;
        b=M6MsGaLXDlN3TAw/54Ty0pXcH3OTl/JC5j4VpFNEe5+mBF62CKa9dB6lHbRn2x7p2h+6JR
        lkglF/ZZRnNN4Ze3P5Ri2YusoCTWSED4uz/Ya02ouomE2VRIhkXGAdu3bjZsbpgUwI/JbN
        RYBlaFQhey1oQnCXEZHFF/ZV3on4P5A=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-144-2l8j3MLhOea2ONayYKX_oA-1; Wed, 11 Jan 2023 17:52:20 -0500
X-MC-Unique: 2l8j3MLhOea2ONayYKX_oA-1
Received: by mail-wm1-f69.google.com with SMTP id q21-20020a7bce95000000b003d236c91639so3812126wmj.8
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 14:52:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1vvFOlgZcmbBXel/bkUj30X9nLvjQk+79xN6sEwmowg=;
        b=4DA2yvbut0lB0enL0uKxqpn9jE9HVyTStZQZwKWQ3mJbGWpP05esGn2yBGm7o2tHDS
         fEj/DKKoGZHMdBaaIl54cEIk1gN5PJW2/vU04GMxqr1DgNOsbxpJEd1GVDb/n1IWJkwd
         VEMuimshG3ES16qNjnJU4e5BZGrC3dXk+yycSzFOAVLTyLDotgK2DiKO1BrmjR2Xw3eA
         VijFdhrt08WSjKLImTr98/bD4bm07wa2R2pYxxM6CbanDOn38PWMsYJIIEzmyFGRzeCB
         MpiLzwssxaY70D/hfYyAhDt4H5ozqfuUSmh3oKjOV7Q1deFN7biPYKjZj0XuB/afwrqW
         xMwA==
X-Gm-Message-State: AFqh2kqAOjQBwD6QV/d0y0EJJzexq3EqgWtQiQ6qQZud4NwzJYGQvnZA
        rY6uwOY80bU19BqRPCiCRLh3n2ihnU6s+3efHpAbjdBggh7HrG3gzI0neSRi0xRfOMCRUYwZb1k
        rjbE9LYYzLEPl
X-Received: by 2002:a05:600c:a51:b0:3d3:513c:240b with SMTP id c17-20020a05600c0a5100b003d3513c240bmr53612353wmq.7.1673477539346;
        Wed, 11 Jan 2023 14:52:19 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtmGyt8JKlWBfzQGmhaL765SxJvgXCn4igxgfJhH5h0b9S1PIkRIsbexrIgfCr7o9RQxEZJ1g==
X-Received: by 2002:a05:600c:a51:b0:3d3:513c:240b with SMTP id c17-20020a05600c0a5100b003d3513c240bmr53612337wmq.7.1673477539106;
        Wed, 11 Jan 2023 14:52:19 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:4783:a68:c1ee:15c5? ([2001:b07:6468:f312:4783:a68:c1ee:15c5])
        by smtp.googlemail.com with ESMTPSA id m17-20020a05600c3b1100b003cfbbd54178sm7547260wms.2.2023.01.11.14.52.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 14:52:18 -0800 (PST)
Message-ID: <24954c55-84c0-2d06-22b7-5345fd4e0731@redhat.com>
Date:   Wed, 11 Jan 2023 23:52:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.2, take #1
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        James Clark <james.clark@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20230105154250.660145-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230105154250.660145-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/5/23 16:42, Marc Zyngier wrote:
> Hi Paolo,
> 
> Happy new year!
> 
> Here's the first batch of fixes for KVM/arm64 for 6.2. We have two
> important fixes this time around, one for the PMU emulation, and the
> other for guest page table walks in read-only memslots, something that
> EFI has started doing...
> 
> The rest is mostly documentation updates, cleanups, and an update to
> the list of reviewers (Alexandru stepping down, and Zenghui joining
> the fun).
> 
> Please pull,

Pulled (though not pushed yet because I still have some x86 tests 
running), thanks.

Paolo

> 	M.
> 
> 
> The following changes since commit 88603b6dc419445847923fcb7fe5080067a30f98:
> 
>    Linux 6.2-rc2 (2023-01-01 13:53:16 -0800)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.2-1
> 
> for you to fetch changes up to de535c0234dd2dbd9c790790f2ca1c4ec8a52d2b:
> 
>    Merge branch kvm-arm64/MAINTAINERS into kvmarm-master/fixes (2023-01-05 15:26:53 +0000)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.2, take #1
> 
> - Fix the PMCR_EL0 reset value after the PMU rework
> 
> - Correctly handle S2 fault triggered by a S1 page table walk
>    by not always classifying it as a write, as this breaks on
>    R/O memslots
> 
> - Document why we cannot exit with KVM_EXIT_MMIO when taking
>    a write fault from a S1 PTW on a R/O memslot
> 
> - Put the Apple M2 on the naughty step for not being able to
>    correctly implement the vgic SEIS feature, just liek the M1
>    before it
> 
> - Reviewer updates: Alex is stepping down, replaced by Zenghui
> 
> ----------------------------------------------------------------
> Alexandru Elisei (1):
>        MAINTAINERS: Remove myself as a KVM/arm64 reviewer
> 
> James Clark (1):
>        KVM: arm64: PMU: Fix PMCR_EL0 reset value
> 
> Marc Zyngier (8):
>        KVM: arm64: Fix S1PTW handling on RO memslots
>        KVM: arm64: Document the behaviour of S1PTW faults on RO memslots
>        KVM: arm64: Convert FSC_* over to ESR_ELx_FSC_*
>        KVM: arm64: vgic: Add Apple M2 cpus to the list of broken SEIS implementations
>        Merge branch kvm-arm64/pmu-fixes-6.2 into kvmarm-master/fixes
>        Merge branch kvm-arm64/s1ptw-write-fault into kvmarm-master/fixes
>        MAINTAINERS: Add Zenghui Yu as a KVM/arm64 reviewer
>        Merge branch kvm-arm64/MAINTAINERS into kvmarm-master/fixes
> 
>   Documentation/virt/kvm/api.rst          |  8 +++++++
>   MAINTAINERS                             |  2 +-
>   arch/arm64/include/asm/cputype.h        |  4 ++++
>   arch/arm64/include/asm/esr.h            |  9 +++++++
>   arch/arm64/include/asm/kvm_arm.h        | 15 ------------
>   arch/arm64/include/asm/kvm_emulate.h    | 42 +++++++++++++++++++++++----------
>   arch/arm64/kvm/hyp/include/hyp/fault.h  |  2 +-
>   arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
>   arch/arm64/kvm/mmu.c                    | 21 ++++++++++-------
>   arch/arm64/kvm/sys_regs.c               |  2 +-
>   arch/arm64/kvm/vgic/vgic-v3.c           |  2 ++
>   11 files changed, 69 insertions(+), 40 deletions(-)
	````````

