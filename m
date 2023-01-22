Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0DA676BB0
	for <lists+kvm@lfdr.de>; Sun, 22 Jan 2023 09:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjAVIwu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Jan 2023 03:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjAVIws (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Jan 2023 03:52:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7F91E1D1
        for <kvm@vger.kernel.org>; Sun, 22 Jan 2023 00:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674377521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fzh657eBEm//fFuVntHGMr/T1VXg/fCXtLpm1U/4LeE=;
        b=hZX8sxAGfAA2HrXtaBTFWA7UPbQZQkiNeMv+SfqIs5zsOqps3iaVHU03nRU+Dzzlv6B6OF
        yt3fXsxGfxHBGNK74V7gaeqVr7sbORjRWotxIQekPMCGehlGrnU7PggvkGCjs6YfEt+vIz
        aOBb5LZxBVoEvgRpJ+Z3rAcW9YdH8EQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-400-9u6yVxROMuWXZgTenz-mQw-1; Sun, 22 Jan 2023 03:51:59 -0500
X-MC-Unique: 9u6yVxROMuWXZgTenz-mQw-1
Received: by mail-ed1-f71.google.com with SMTP id m7-20020a056402510700b00488d1fcdaebso6473074edd.9
        for <kvm@vger.kernel.org>; Sun, 22 Jan 2023 00:51:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fzh657eBEm//fFuVntHGMr/T1VXg/fCXtLpm1U/4LeE=;
        b=CTqAfUY11KYjgs0fsVKD7rtJiTFiZEYPm1IdL8yXxXd0sTMPYRqGuxr3QjDc7nugwx
         D0KijqAVXrhUrLs8fOhhpJNva0Jduze9GaJNm9Afk+C3jJTRIpDSoNXJ8iTGU1d1Buz5
         x/coiSGDUYug341LwRr9Wlb0x5lFZ0Vqs2vXzzLLr0EbpfvJji3Eum4u3PAoD5Sm9diW
         s/GxnIsczgIzBmFKn2KyRo5qb2dZn7P8YBhiIoDPnRZF0LPYm2gS6CwVv22XqbPqYov5
         5z+s2G7fjVfGgv1FrpvvE45cPsjwyTRXWmGyt3Wfp+/MBUaFTQxsJsadFWe+fSowE+5E
         7opQ==
X-Gm-Message-State: AFqh2krJOvLpMtS/7XmbD26wfsv9nRDHYqSIJY+tKPIJp6LGiHIKgJdh
        LDAUSmzgFi1HHIbIJTHgFGsri5/e52Ax4UYeeyd6Grg3jg+pxPJqQFLu8je5FNPHgLx1tg5RwHQ
        mLhE2n1lujBKE
X-Received: by 2002:a17:906:eb8e:b0:871:6b9d:dbc with SMTP id mh14-20020a170906eb8e00b008716b9d0dbcmr21834815ejb.21.1674377518405;
        Sun, 22 Jan 2023 00:51:58 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv6j1z/NsGELcDclZ9c0tzI8/Ywun4iDihWjYbScOETod/jzDf15vN9UEqbc3cuVk8YHfOYPQ==
X-Received: by 2002:a17:906:eb8e:b0:871:6b9d:dbc with SMTP id mh14-20020a170906eb8e00b008716b9d0dbcmr21834801ejb.21.1674377518112;
        Sun, 22 Jan 2023 00:51:58 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id c23-20020a170906155700b0084c7f96d023sm20826541ejd.147.2023.01.22.00.51.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Jan 2023 00:51:57 -0800 (PST)
Message-ID: <a292c1db-2592-ed4f-ed98-f5998746925a@redhat.com>
Date:   Sun, 22 Jan 2023 09:51:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.2, take #2
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     Anshuman Khandual <anshuman.khandual@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Shanker Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20230121110837.3216901-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230121110837.3216901-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/21/23 12:08, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's a small set of important 6.2 fixes for KVM/arm64. We have a MTE
> fix after the recent changes that went into -rc1, as well as a GICv4.1
> fix for a pretty bad race that results in a dead host (a stable
> candidate).
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit de535c0234dd2dbd9c790790f2ca1c4ec8a52d2b:
> 
>    Merge branch kvm-arm64/MAINTAINERS into kvmarm-master/fixes (2023-01-05 15:26:53 +0000)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.2-2

Pulled, thanks.

Paolo

> 
> for you to fetch changes up to ef3691683d7bfd0a2acf48812e4ffe894f10bfa8:
> 
>    KVM: arm64: GICv4.1: Fix race with doorbell on VPE activation/deactivation (2023-01-21 11:02:19 +0000)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.2, take #2
> 
> - Pass the correct address to mte_clear_page_tags() on initialising
>    a tagged page
> 
> - Plug a race against a GICv4.1 doorbell interrupt while saving
>    the vgic-v3 pending state.
> 
> ----------------------------------------------------------------
> Catalin Marinas (1):
>        KVM: arm64: Pass the actual page address to mte_clear_page_tags()
> 
> Marc Zyngier (1):
>        KVM: arm64: GICv4.1: Fix race with doorbell on VPE activation/deactivation
> 
>   arch/arm64/kvm/guest.c        |  2 +-
>   arch/arm64/kvm/vgic/vgic-v3.c | 25 +++++++++++--------------
>   arch/arm64/kvm/vgic/vgic-v4.c |  8 ++++++--
>   arch/arm64/kvm/vgic/vgic.h    |  1 +
>   4 files changed, 19 insertions(+), 17 deletions(-)

