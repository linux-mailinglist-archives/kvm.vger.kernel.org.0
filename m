Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86D456D0EF
	for <lists+kvm@lfdr.de>; Sun, 10 Jul 2022 21:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiGJTFn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Jul 2022 15:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiGJTFl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Jul 2022 15:05:41 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECA813F07
        for <kvm@vger.kernel.org>; Sun, 10 Jul 2022 12:05:40 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-31c89653790so30313047b3.13
        for <kvm@vger.kernel.org>; Sun, 10 Jul 2022 12:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tkZ9euRFpN6RPFPNbwsacD82kKvLsZ80aQxI2epTktI=;
        b=L+RFTeLRQS0mezNdJHzI7btiFmANc6Tyji1uh+iIfM2RQA568qOWxJLcPkB/geHXey
         LYEiB/wcmktqV95Fmt2nxRwshkuSHKiY1rOB0rKj6dMVyVI5tWtGqq6uQKuZ/s3SbwDX
         vCEs8dEfgL3PtT+azgXyVO7NCPKhC5j2HYfzs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tkZ9euRFpN6RPFPNbwsacD82kKvLsZ80aQxI2epTktI=;
        b=cnMpvKtDONWNjjXApOXjuzX0EyshEo2C2kCC/xRnqU2R1AiI8FRKsdmKimJNCfWRvH
         T4GV6yLYXztzsIv04iYpLOG83KgVa9nBhJBnWMGsqXOu3YL5T/s4BmhJbkFSxJB2nYID
         OobcgNmztyElUert3wOzuOm+nsj6hVbmKQlNFovGRDHnYIimA3cOw2+AQJ8nGmMBCk4O
         hLB6/R0LFgZ6x6N1GiLnt5xiioXvrSVOkn+vCdCu76zu5J7fHz1ULzjt6VkBKMx+Q+CO
         +R9F6tXkMcdAZ4yWTog+wX+u2W8rt3o1gPp98bQNHhLVtvBbJ2YPPXM7rIfcg8CdjZkW
         dW/w==
X-Gm-Message-State: AJIora8kOdnmsORGoRNTQi/cdOMyAWDJXXvk49mGYYjHcHO2H4UbV8i3
        tI48zINgTLl8MaYKD061EEby7G713nFlyu4SIo3HU2tLbA==
X-Google-Smtp-Source: AGRyM1uVUA8FMVdx45iYEpWXOWp2xYWyipOGYnB/UnRRjpUjaOOkD/wxeAFO8Da722n+T98mGBQQPN/JACPirmWJRAk=
X-Received: by 2002:a81:1514:0:b0:31c:a84b:350a with SMTP id
 20-20020a811514000000b0031ca84b350amr16064656ywv.400.1657479939850; Sun, 10
 Jul 2022 12:05:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220710151105.687193-1-apatel@ventanamicro.com>
In-Reply-To: <20220710151105.687193-1-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Sun, 10 Jul 2022 12:05:29 -0700
Message-ID: <CAOnJCUJHDd7i1BN0KwzQzHNGkBFQBYje1RGKQt4Yuus8HZJPeg@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Fix SRCU deadlock caused by kvm_riscv_check_vcpu_requests()
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Bin Meng <bmeng.cn@gmail.com>,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Anup Patel <anup@brainfault.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jul 10, 2022 at 8:11 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> The kvm_riscv_check_vcpu_requests() is called with SRCU read lock held
> and for KVM_REQ_SLEEP request it will block the VCPU without releasing
> SRCU read lock. This causes KVM ioctls (such as KVM_IOEVENTFD) from
> other VCPUs of the same Guest/VM to hang/deadlock if there is any
> synchronize_srcu() or synchronize_srcu_expedited() in the path.
>
> To fix the above in kvm_riscv_check_vcpu_requests(), we should do SRCU
> read unlock before blocking the VCPU and do SRCU read lock after VCPU
> wakeup.
>
> Fixes: cce69aff689e ("RISC-V: KVM: Implement VCPU interrupts and
> requests handling")
> Reported-by: Bin Meng <bmeng.cn@gmail.com>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index b7a433c54d0f..5d271b597613 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -845,9 +845,11 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
>
>         if (kvm_request_pending(vcpu)) {
>                 if (kvm_check_request(KVM_REQ_SLEEP, vcpu)) {
> +                       kvm_vcpu_srcu_read_unlock(vcpu);
>                         rcuwait_wait_event(wait,
>                                 (!vcpu->arch.power_off) && (!vcpu->arch.pause),
>                                 TASK_INTERRUPTIBLE);
> +                       kvm_vcpu_srcu_read_lock(vcpu);
>
>                         if (vcpu->arch.power_off || vcpu->arch.pause) {
>                                 /*
> --
> 2.34.1
>

Reviewed-by: Atish Patra <atishp@rivosinc.com>

-- 
Regards,
Atish
