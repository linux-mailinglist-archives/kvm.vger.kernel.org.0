Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A990558515B
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 16:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236073AbiG2OOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 10:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiG2OOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 10:14:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D44F14AD5A
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 07:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659104076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MCjF1rJs7ryCEf4nZSDoKmS9akQnz5+AnRQrkGVZ82I=;
        b=RNhQ/COfUDmaHjRQBJBiW6KKaEKBO7YU7OIOBQDe1+tt8moPuo3i/Wb45XnyAfrD62yMyh
        B3Rz6ZkvLMKVEiNyr54eLS6wwip9CZhXCmNG8aCFI1N1fI6J+D4wb/lvjhnPEUAhvmwfBJ
        9ni643BEzjxsuepsIzJmzv7ky3prTfM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-pBQMD0knPUybZKwsDwyFKg-1; Fri, 29 Jul 2022 10:14:35 -0400
X-MC-Unique: pBQMD0knPUybZKwsDwyFKg-1
Received: by mail-ej1-f69.google.com with SMTP id ji2-20020a170907980200b0072b5b6d60c2so1895295ejc.22
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 07:14:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MCjF1rJs7ryCEf4nZSDoKmS9akQnz5+AnRQrkGVZ82I=;
        b=v83MTKHNI8Pz3ixHRDS2a81kBP8vOybJucZVYBSeRiu9bcXTwkhEYWBOMaCYe1tzLe
         W4nguP3OaKwZXpaDPsgw0z/wZtVT2lgKnOdqGn8BUldsSfpoz71qxsGRtyDXIml7481+
         ALJW5kvsl9171dF+1dW85DIPwIsUCUxPxkGcfNuE3wlVacB/ewc0QbqSSUNSsx01/hkZ
         PDuws0o5+vFVVbyeF3kMm1m63st6pB+s61cWipFUEQK4rWHz3f670/ANrjvcc3VSWMxk
         xIPZ45hIy82SbklaXOyVIMDNJ3GJgZyeDQMz9rC+bEhDS0Em0lD8IBJL/OfHdy4fRpa6
         gKZg==
X-Gm-Message-State: AJIora8OeW57Lg8Wyqn//foYBOiTgGMt2rcgVurNd/BGrA9lHL2S24CE
        jFI0fUJFNomuMDk2Oc1V8pMy+Qj5AdN1PctPn0WkFuCYfOuCppyyNlL0PqclT0jJXpcStGF/rV0
        ODyqxyhEfFwPR
X-Received: by 2002:a05:6402:34c5:b0:43a:8f90:e643 with SMTP id w5-20020a05640234c500b0043a8f90e643mr3752627edc.88.1659104074247;
        Fri, 29 Jul 2022 07:14:34 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vptcnztXT72sCa4wMYMFIHhe1C7CEEkh5xLKL/oJogGO4q1bTGJImMUoTBn5uZAqjWgDHT9A==
X-Received: by 2002:a05:6402:34c5:b0:43a:8f90:e643 with SMTP id w5-20020a05640234c500b0043a8f90e643mr3752613edc.88.1659104074026;
        Fri, 29 Jul 2022 07:14:34 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id f11-20020a170906560b00b0072b2eab813fsm1733207ejq.75.2022.07.29.07.14.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 07:14:33 -0700 (PDT)
Message-ID: <59b295a4-9a09-12a6-cf72-d5f0d4b20d7f@redhat.com>
Date:   Fri, 29 Jul 2022 16:14:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [GIT PULL] KVM/riscv changes for 5.20
Content-Language: en-US
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
References: <CAAhSdy2iH-WpitweQ_nCYm6p0S5S_fmQ3x37FdAe7tEmu_np0A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAAhSdy2iH-WpitweQ_nCYm6p0S5S_fmQ3x37FdAe7tEmu_np0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/29/22 14:31, Anup Patel wrote:
> Hi Paolo,
> 
> We have following KVM RISC-V changes for 5.20:
> 1) Track ISA extensions used by Guest using bitmap
> 2) Added system instruction emulation framework
> 3) Added CSR emulation framework
> 4) Added gfp_custom flag in struct kvm_mmu_memory_cache
> 5) Added G-stage ioremap() and iounmap() functions
> 6) Added support for Svpbmt inside Guest
> 
> Please pull.
> 
> Regards,
> Anup
> 
> The following changes since commit e0dccc3b76fb35bb257b4118367a883073d7390e:
> 
>    Linux 5.19-rc8 (2022-07-24 13:26:27 -0700)
> 
> are available in the Git repository at:
> 
>    https://github.com/kvm-riscv/linux.git tags/kvm-riscv-5.20-1
> 
> for you to fetch changes up to 6bb2e00ea304ffc0446f345c46fe22713ce43cbf:
> 
>    RISC-V: KVM: Add support for Svpbmt inside Guest/VM (2022-07-29
> 17:15:18 +0530)
> 
> ----------------------------------------------------------------
> KVM/riscv changes for 5.20
> 
> - Track ISA extensions used by Guest using bitmap
> - Added system instruction emulation framework
> - Added CSR emulation framework
> - Added gfp_custom flag in struct kvm_mmu_memory_cache
> - Added G-stage ioremap() and iounmap() functions
> - Added support for Svpbmt inside Guest
> 
> ----------------------------------------------------------------
> Anup Patel (7):
>        RISC-V: KVM: Factor-out instruction emulation into separate sources
>        RISC-V: KVM: Add extensible system instruction emulation framework
>        RISC-V: KVM: Add extensible CSR emulation framework
>        KVM: Add gfp_custom flag in struct kvm_mmu_memory_cache
>        RISC-V: KVM: Add G-stage ioremap() and iounmap() functions
>        RISC-V: KVM: Use PAGE_KERNEL_IO in kvm_riscv_gstage_ioremap()
>        RISC-V: KVM: Add support for Svpbmt inside Guest/VM
> 
> Atish Patra (1):
>        RISC-V: KVM: Improve ISA extension by using a bitmap
> 
> Nikolay Borisov (2):
>        RISC-V: KVM: Make kvm_riscv_guest_timer_init a void function
>        RISC-V: KVM: move preempt_disable() call in kvm_arch_vcpu_ioctl_run
> 
> Zhang Jiaming (1):
>        RISC-V: KVM: Fix variable spelling mistake
> 
>   arch/riscv/include/asm/csr.h            |  16 +
>   arch/riscv/include/asm/kvm_host.h       |  24 +-
>   arch/riscv/include/asm/kvm_vcpu_fp.h    |   8 +-
>   arch/riscv/include/asm/kvm_vcpu_insn.h  |  48 ++
>   arch/riscv/include/asm/kvm_vcpu_timer.h |   2 +-
>   arch/riscv/include/uapi/asm/kvm.h       |   1 +
>   arch/riscv/kvm/Makefile                 |   1 +
>   arch/riscv/kvm/mmu.c                    |  28 +-
>   arch/riscv/kvm/vcpu.c                   | 203 ++++++---
>   arch/riscv/kvm/vcpu_exit.c              | 496 +--------------------
>   arch/riscv/kvm/vcpu_fp.c                |  27 +-
>   arch/riscv/kvm/vcpu_insn.c              | 752 ++++++++++++++++++++++++++++++++
>   arch/riscv/kvm/vcpu_timer.c             |   4 +-
>   arch/riscv/kvm/vm.c                     |   4 +-
>   include/linux/kvm_types.h               |   1 +
>   include/uapi/linux/kvm.h                |   8 +
>   virt/kvm/kvm_main.c                     |   4 +-
>   17 files changed, 1028 insertions(+), 599 deletions(-)
>   create mode 100644 arch/riscv/include/asm/kvm_vcpu_insn.h
>   create mode 100644 arch/riscv/kvm/vcpu_insn.c
> 

Pulled, thanks.  Because it's Friday and the pull brought in all the new 
x86 RETbleed stuff, it may be a couple days before I finish retesting 
and do push it out to kvm.git.

Paolo

