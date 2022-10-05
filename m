Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96BAB5F5410
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 13:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJELy1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 07:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJELy0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 07:54:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007EC3881
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 04:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664970864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cNSB7u7S7DM2z4JeNI1ixVq5EHPj/CnyKegZaT3nBL4=;
        b=F3rwkI9XXGEgiXIyuq5y3VOxrFTiYNX/UF9/Reor66s56+ZLYqCBT1Wto5FeWLCqXIzMeL
        Jj0msx8PAiQMY9s7dTQwrOhodGLAjtzhs2Dc2U0HzpXKUFQtcsXrz2254h8P6dO84zvcex
        5NJXd/m60fNPF64+jG115saSNslnY1E=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-330-BlZyRONIP_iH7zvP6RJyCQ-1; Wed, 05 Oct 2022 07:54:23 -0400
X-MC-Unique: BlZyRONIP_iH7zvP6RJyCQ-1
Received: by mail-qk1-f200.google.com with SMTP id bl17-20020a05620a1a9100b006cdf19243acso13955649qkb.4
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 04:54:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=cNSB7u7S7DM2z4JeNI1ixVq5EHPj/CnyKegZaT3nBL4=;
        b=cf00AouBaKq2zK1mQSFeot5G8jMlF1obP0HqA0KQSxeZxzsS7iW7ocpRchqf9Y5u+8
         7XlBxCcL2LiaRGhVqls5CaMXg5wNJzlBuYrxFtBax0bGkPJussULsPGd001s7NJ9Knjc
         P+TgAY9/EUCMSEC5fB5six6vFgWXYEPezgdQRwo6U6aPhJKc+I+YUqJhEMZ+XOjDtqc5
         YjegAwI31AUbbpFq5v+N/lJbTDYS5BaPdhRRZTc7w+Ucc+EChAc2hDU2m1D7T+SME3Ai
         uqE/A3UjrVBh6n+VjlWkMh2c3LQlNAn2GGa1XFJ7qFq0cg4wrCrvf5BUmg4vo9MpYTDX
         Kbrw==
X-Gm-Message-State: ACrzQf1BMAYkADc7oemhmoVjpdA4Z2n0/o5NqBJgJ+Hh1MON6OmL+ZlI
        eXf/YXqueRutE2D0/aBGbwaroTlDep3vza6C+M16teKIUFdWSrpUriflK74+cmmHLUdB8v++CZj
        6u5l7WE9DbbWy
X-Received: by 2002:a05:620a:269a:b0:6cf:3f0b:8fb4 with SMTP id c26-20020a05620a269a00b006cf3f0b8fb4mr19950073qkp.100.1664970862651;
        Wed, 05 Oct 2022 04:54:22 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6gmYf7EgJVAT7DFz75r8qkT0l9l49m+D27vyJDK/u9si4nmnCVXUFrYUTihMu84p3VrP4YXA==
X-Received: by 2002:a05:620a:269a:b0:6cf:3f0b:8fb4 with SMTP id c26-20020a05620a269a00b006cf3f0b8fb4mr19950064qkp.100.1664970862427;
        Wed, 05 Oct 2022 04:54:22 -0700 (PDT)
Received: from [172.20.5.108] (rrcs-66-57-248-11.midsouth.biz.rr.com. [66.57.248.11])
        by smtp.googlemail.com with ESMTPSA id y20-20020ac87c94000000b0038cdc487886sm2511794qtv.80.2022.10.05.04.54.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Oct 2022 04:54:21 -0700 (PDT)
Message-ID: <432d57e3-7559-1fac-9397-2441358b131a@redhat.com>
Date:   Wed, 5 Oct 2022 13:54:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 0/3] Add TCG & KVM support for MSR_CORE_THREAD_COUNT
Content-Language: en-US
To:     Alexander Graf <agraf@csgraf.de>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Vladislav Yaroshchuk <yaroshchuk2000@gmail.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20221004225643.65036-1-agraf@csgraf.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221004225643.65036-1-agraf@csgraf.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/5/22 00:56, Alexander Graf wrote:
> Commit 027ac0cb516 ("target/i386/hvf: add rdmsr 35H
> MSR_CORE_THREAD_COUNT") added support for the MSR_CORE_THREAD_COUNT MSR
> to HVF. This MSR is mandatory to execute macOS when run with -cpu
> host,+hypervisor.
> 
> This patch set adds support for the very same MSR to TCG as well as
> KVM - as long as host KVM is recent enough to support MSR trapping.
> 
> With this support added, I can successfully execute macOS guests in
> KVM with an APFS enabled OVMF build, a valid applesmc plus OSK and
> 
>    -cpu Skylake-Client,+invtsc,+hypervisor
> 
> 
> Alex
> 
> Alexander Graf (3):
>    x86: Implement MSR_CORE_THREAD_COUNT MSR
>    i386: kvm: Add support for MSR filtering
>    KVM: x86: Implement MSR_CORE_THREAD_COUNT MSR
> 
>   target/i386/kvm/kvm.c                | 145 +++++++++++++++++++++++++++
>   target/i386/kvm/kvm_i386.h           |  11 ++
>   target/i386/tcg/sysemu/misc_helper.c |   5 +
>   3 files changed, 161 insertions(+)
> 

Queued, thanks!

Paolo

