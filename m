Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C190608BC8
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 12:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiJVKl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Oct 2022 06:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiJVKlp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Oct 2022 06:41:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C93E31A90D
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 02:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666432683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ZpbY5Z1kZrFHi8g1jxQJWEEPWxLnhzcOFeK0LBPOXA=;
        b=CJQKv9bmrrC2TP+7LaZWEHPP3ysT7/2GQSi8QMNouf0YNdfvwuq9WGL6ph/8Wch1N+m6oX
        nuKgt+PytevNGZJnKoe7lyqwrKk17MMXxDTBK5Pznrigyh/O/t8J50/b8vuaO14z6/wn+r
        qulOHayZZdGORHgDiIRQU5ctENANMYo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-82-Nz6Kx0pRNNKuzFV22X-H9g-1; Sat, 22 Oct 2022 05:15:50 -0400
X-MC-Unique: Nz6Kx0pRNNKuzFV22X-H9g-1
Received: by mail-ed1-f69.google.com with SMTP id z7-20020a05640235c700b0045d3841ccf2so4900183edc.9
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 02:15:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5ZpbY5Z1kZrFHi8g1jxQJWEEPWxLnhzcOFeK0LBPOXA=;
        b=DYPm+2gMFNruzFzGlZKpbHmPBhy+378Q32WV0VmGRo0kz8yZq7VbmHzqaESVN+G7wy
         YDr7FX+meS6yaXcmvNIP48vkiI2eeQDow3eK4RToQ4BEDCdlJeXOq726jh60UHgarcg1
         tPE0pi1/VW4LRWZ3a65+djaTTnLjU9jjfE4V/dpy/kQ8DyJGU0NJvWYoyI4wEOXdlDQK
         CIL2b4o1ioPPe69oHDlff61zBD4TsaYgjB8rikRvK42JMPjkBkeBtpwIlqzP3+vQfIR9
         W8SGJztwCfTn7EgclHncAq3zQl9uQNx8XdinJ9FOLJ+mcIqIZu+VqQ0dSNH3PveF5CGT
         0zhQ==
X-Gm-Message-State: ACrzQf0oVHJLWEo6kVeAAM59KSUJCWKrlyx6HBxGUUVjFALfiGt7Zg6s
        R8Dox9MubNgbCgoglXyrKiMIJaX8xQ2CjHfAm28mFAvP91hUJ1TvHZ7+VW6U3QqYTPHgedTK3Vu
        uX2AOzcablZmg
X-Received: by 2002:a17:907:96a6:b0:78d:b6f6:3886 with SMTP id hd38-20020a17090796a600b0078db6f63886mr19986811ejc.106.1666430148757;
        Sat, 22 Oct 2022 02:15:48 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6aFw8TKdb0qW0brrUGxzPkNiKHAEEnGBYfMNPi4mTnGj4VcVAX5ZHSTCqA5EX4AttXcnBfsQ==
X-Received: by 2002:a17:907:96a6:b0:78d:b6f6:3886 with SMTP id hd38-20020a17090796a600b0078db6f63886mr19986797ejc.106.1666430148543;
        Sat, 22 Oct 2022 02:15:48 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:2f4b:62da:3159:e077? ([2001:b07:6468:f312:2f4b:62da:3159:e077])
        by smtp.googlemail.com with ESMTPSA id fe7-20020a056402390700b004587c2b5048sm14782686edb.52.2022.10.22.02.15.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Oct 2022 02:15:48 -0700 (PDT)
Message-ID: <0851c9e1-c63d-fca5-7a9f-10c8f8bae289@redhat.com>
Date:   Sat, 22 Oct 2022 11:15:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [GIT PULL] KVM/riscv fixes for 6.1, take #1
Content-Language: en-US
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
References: <CAAhSdy30JYf3SjDaAm6LHTU-yD36Nb8=FYaPpECm68O8XFdBDg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAAhSdy30JYf3SjDaAm6LHTU-yD36Nb8=FYaPpECm68O8XFdBDg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/21/22 09:56, Anup Patel wrote:
> Hi Paolo,
> 
> We have two fixes for 6.1:
> 1) Fix for compile error seen when RISCV_ISA_ZICBOM
>      is disabled. This fix touches code outside KVM RISC-V
>      but I am including this here since it was affecting KVM
>      compilation.
> 2) Fix for checking pending timer interrupt when RISC-V
>      Sstc extension is available.
> 
> Please pull.
> 
> Regards,
> Anup
> 
> The following changes since commit 9abf2313adc1ca1b6180c508c25f22f9395cc780:
> 
>    Linux 6.1-rc1 (2022-10-16 15:36:24 -0700)
> 
> are available in the Git repository at:
> 
>    https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.1-1
> 
> for you to fetch changes up to cea8896bd936135559253e9b23340cfa1cdf0caf:
> 
>    RISC-V: KVM: Fix kvm_riscv_vcpu_timer_pending() for Sstc (2022-10-21
> 11:52:45 +0530)
> 
> ----------------------------------------------------------------
> KVM/riscv fixes for 6.1, take #1
> 
> - Fix compilation without RISCV_ISA_ZICBOM
> - Fix kvm_riscv_vcpu_timer_pending() for Sstc
> 
> ----------------------------------------------------------------
> Andrew Jones (1):
>        RISC-V: Fix compilation without RISCV_ISA_ZICBOM
> 
> Anup Patel (1):
>        RISC-V: KVM: Fix kvm_riscv_vcpu_timer_pending() for Sstc
> 
>   arch/riscv/include/asm/cacheflush.h     |  8 -------
>   arch/riscv/include/asm/kvm_vcpu_timer.h |  1 +
>   arch/riscv/kvm/vcpu.c                   |  3 +++
>   arch/riscv/kvm/vcpu_timer.c             | 17 ++++++++++++--
>   arch/riscv/mm/cacheflush.c              | 38 ++++++++++++++++++++++++++++++
>   arch/riscv/mm/dma-noncoherent.c         | 41 ---------------------------------
>   6 files changed, 57 insertions(+), 51 deletions(-)

Pulled, thanks.

Paolo

