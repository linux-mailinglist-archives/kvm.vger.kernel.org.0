Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB4BC56D2A6
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 03:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiGKBiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Jul 2022 21:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiGKBiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Jul 2022 21:38:13 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C6713DCB;
        Sun, 10 Jul 2022 18:38:13 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id b25so2433340qkl.1;
        Sun, 10 Jul 2022 18:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xureSuw2V9E7tzVjUzBjylXpgFwjrDdPqi99TNgwo2k=;
        b=GlElJxs6r9uyx/SQSYXULuTbs82yeDXXiSIJtB2p4ltiJUAxG9ZiGA77JLrro7RlQX
         0kY2uWkVTgoPyTQhbejFres652JV82MmsmKKBoW3lGZVjXUzs+12F4Ds3sk8Hj8h2gqZ
         TKthuvDMbemYVTKyLKl9gtMEOcu1gE2GYBXWlJRP5kRRR08sHNwobRml2McKgUfTpkBm
         Stp0xir9M5UC+LyL8+nWyupiuK8UQalEUuKhWtpjANVl4t1qkAU7NxHjPigfxquc/ExS
         0GQE90k2A3wgZURr1hM9eBXsn12M8PbjuTXwMkeWaDVvYrXYJf/5PfX2OzzSpjuD7XA7
         BOQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xureSuw2V9E7tzVjUzBjylXpgFwjrDdPqi99TNgwo2k=;
        b=jBYoH+2/c4BcryNjmyukl9s4jQEIiKm47pTnbdO5v03FIg8Z6ygxq31T6Rm0WBH8iv
         Rt+0yyuIVDIUynnls6CjKgP79qFJB4HTGvLjlw+zHT36nMGnjow/AKJQlNC4PYFT09Ui
         ZkgeD/bglC0zm/UnyoBlKDLTYZK521WQvP6nj/aSfHXIFST7M7ybeowUBEehRhrlFZyx
         FazAtFvnBKwKCim82Rh1f4jkm0rnD9ekBLCjsplXniqA8nILiBOPFOLG/XrEKO789agH
         HNiOe31RdSebZMGMuffExZwpzmDTRJ6NplUE+fC31N0p5qX2/MBnWU+uFwgFVbnj4AK6
         AMeQ==
X-Gm-Message-State: AJIora+pWFUDiTlLMjbGN/goXtB9L+/OjGYBVISw9EL/XqXAe4qtsSn9
        aO6Lhn3QApmP+z26fQ7Ej9YT84o03D95VH1/TwU=
X-Google-Smtp-Source: AGRyM1s9CHhxiUJJJrpIWa/HhpPbtbrmDcWTIZPv8HTqxaBbr9Pt2wMHh5OR5W6Z1I4zv7JCvOyBTmsSuwGZMVkeZ9s=
X-Received: by 2002:a05:620a:430f:b0:6a7:9f9d:20cd with SMTP id
 u15-20020a05620a430f00b006a79f9d20cdmr9909341qko.389.1657503492197; Sun, 10
 Jul 2022 18:38:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220710151105.687193-1-apatel@ventanamicro.com>
In-Reply-To: <20220710151105.687193-1-apatel@ventanamicro.com>
From:   Bin Meng <bmeng.cn@gmail.com>
Date:   Mon, 11 Jul 2022 09:37:59 +0800
Message-ID: <CAEUhbmUzzoA4uUQ3tRk4V3jAA14AfPnD08KM0GT5Px6DMFwBRA@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Fix SRCU deadlock caused by kvm_riscv_check_vcpu_requests()
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Anup Patel <anup@brainfault.org>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jul 10, 2022 at 11:11 PM Anup Patel <apatel@ventanamicro.com> wrote:
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

nites: the "Fixes" tag should be put in a single line to avoid
breaking scripts that parse the "Fixes" tag

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

Tested-by: Bin Meng <bmeng.cn@gmail.com>
