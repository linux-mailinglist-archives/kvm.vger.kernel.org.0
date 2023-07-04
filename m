Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1702747A91
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 01:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjGDXzg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 19:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjGDXze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 19:55:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363CBE5B
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 16:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688514888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mna+dhhTYjAdqDBDtMfl56DYIGVzwso+E96k6VKVls0=;
        b=Wa7BrcOmPI0f7tqlo51bYXjgXNXvlWrpR9Yn8RyK5lQkryG8TZAvLg5aTNJq7F5DxXQqyU
        3H5SqjMo4qtmXoPGzv3Tcjy+OdlTQyfpzDtdxcf3cJ1kXqy9GGc9rAN13pr6tJoCM0i3vm
        6PcoiigxNosn48nd48SCpoXqYBepIKs=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-ffMqRe-kP0OGWEdb1Y2QJA-1; Tue, 04 Jul 2023 19:54:47 -0400
X-MC-Unique: ffMqRe-kP0OGWEdb1Y2QJA-1
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-565c44558b0so4455429eaf.0
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 16:54:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688514886; x=1691106886;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mna+dhhTYjAdqDBDtMfl56DYIGVzwso+E96k6VKVls0=;
        b=fRv4LWZYEOUbai42KigAkULEYgX2Zl0dwCrBPCAR+gOjPnOHj0y7wm+J6zu1dt/BMD
         p0P0ri1PJtk3u3WsEpbnIUAzbY+skJ393+HILLu/SwSv/ZroUIe7miPYaqd+C4gJfWBl
         KRS7WcidSwK2OCja29S1fy2MYZL5kxDUpJCFelDDwmtCyxXEjriM0M46ngtfIQ/NF4y1
         jt5O6RyhWwjG861SoNejHNjZg+3qq4iMUaEIRFodiJvBYAiGjW7rqC3YTYim0jgLMqt6
         D3nsWnWjqDquW2wD3JvHCnU3eBKY2gGXg1ILm5YXLQmr9QXph4qvVVsXW4jm+eY90NcE
         N3fg==
X-Gm-Message-State: ABy/qLav+9d5iG4wmiGpWG3iWYq3jW6FQSDdyNGqv5aE9LHn4qxZq79O
        TuzxKAbUG8xT2he1dW/oq5oLjTnB5zUAN6ySvznaYcQTMpaRsm8/CodZWAFwr5ngXJXdmr82q/p
        5zfJLC+JOgGcw
X-Received: by 2002:a05:6808:1a17:b0:3a3:a8ce:c659 with SMTP id bk23-20020a0568081a1700b003a3a8cec659mr9277927oib.1.1688514886549;
        Tue, 04 Jul 2023 16:54:46 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEnYXHnAZgQaIRTnEPMZWgHY6PvyvdCKGOrf+hZuU/jzXUZFjXk6Vz5A95OweIIvkeHyw48vA==
X-Received: by 2002:a05:6808:1a17:b0:3a3:a8ce:c659 with SMTP id bk23-20020a0568081a1700b003a3a8cec659mr9277900oib.1.1688514886348;
        Tue, 04 Jul 2023 16:54:46 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id 2-20020a170902c20200b001b03a7a40e7sm12047419pll.19.2023.07.04.16.54.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 16:54:45 -0700 (PDT)
Message-ID: <a0e4b07c-dea8-e45e-7bc8-588f8cbcb537@redhat.com>
Date:   Wed, 5 Jul 2023 09:54:36 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RESEND PATCH v5 03/11] KVM: Allow range-based TLB invalidation
 from common code
Content-Language: en-US
To:     Raghavendra Rao Ananta <rananta@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20230621175002.2832640-1-rananta@google.com>
 <20230621175002.2832640-4-rananta@google.com>
From:   Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230621175002.2832640-4-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/22/23 03:49, Raghavendra Rao Ananta wrote:
> From: David Matlack <dmatlack@google.com>
> 
> Make kvm_flush_remote_tlbs_range() visible in common code and create a
> default implementation that just invalidates the whole TLB.
> 
> This paves the way for several future features/cleanups:
> 
>   - Introduction of range-based TLBI on ARM.
>   - Eliminating kvm_arch_flush_remote_tlbs_memslot()
>   - Moving the KVM/x86 TDP MMU to common code.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  3 +++
>   arch/x86/kvm/mmu/mmu.c          |  9 ++++-----
>   arch/x86/kvm/mmu/mmu_internal.h |  3 ---
>   include/linux/kvm_host.h        |  9 +++++++++
>   virt/kvm/kvm_main.c             | 13 +++++++++++++
>   5 files changed, 29 insertions(+), 8 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

Thanks,
Gavin

