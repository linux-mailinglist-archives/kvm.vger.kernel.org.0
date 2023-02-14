Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC16695B65
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 08:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbjBNH4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 02:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbjBNH4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 02:56:31 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A22A21A17
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 23:56:10 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id oa11-20020a17090b1bcb00b002341a2656e5so3167847pjb.1
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 23:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qelBQClw7mXq80SVJvQ3JIsOiducFvvsAUEKszfdTWI=;
        b=Zjsnk3G1m3c2j2vBbWEw29s+tBSpeyW8l+mBJUemvwZ3ZIl3mAlMHMiMg5UmykQdgU
         QXQRxZ/gY57Pg7TekPEUcPMnvtA3Y338kmwhxKOKiNC7KsEZ9lgXJYWfRaMX+wIRFCe5
         xmv5uzQgyI0T25jmd4sjvlc52XI/mhrlH7U9Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qelBQClw7mXq80SVJvQ3JIsOiducFvvsAUEKszfdTWI=;
        b=s5zDJHP2XwBKu3qcid2Uji9zFEd6OoNA/9e2BAdg0MvniMzyU9KY09D8hYs/e2u6ff
         92oHSg3U2whqkX29QY6IjTK91AO8k7jkCVCT56Vi0/o2AC4Si9Dr3v+z0pLSZkmmdEtk
         inw+O+rqg/gLmLXpDp2dnZNVxKBAel+SsXh0bqyz1bJo+OdS6Im1iwXg11i1pcYWYnf8
         DoKqmYKlebDvrDClUS6HQXu3Z/R32mSlVjfIcjQJYzN3fDZNlwanYaK02XB49nMvzwNI
         2IoFYGCB5B3pIOkFVjhE5xnr5HRThxCZyveFt44QqH7I2jlIT6Rnb8lXWJ0Ij4AY1MNs
         Sd9g==
X-Gm-Message-State: AO0yUKVrYEgcTiHM44pyYpdEabzI1TuJPmojqHY06/9DkD9g/RH7l/nF
        mI+bpL+lkPEVB8d1qYswhDPJ2qjPchU6xV63xMv9zsPDnWaK
X-Google-Smtp-Source: AK7set83Sbzb8jCkDb4xrCrdqGGfaYuMy9wt+/YQodEHLIM55YAQJY9anSobjjDFMQ5cSu0tBC593mHUT8KAO6pp7Bk=
X-Received: by 2002:a17:90a:3b08:b0:230:88c4:a922 with SMTP id
 d8-20020a17090a3b0800b0023088c4a922mr193163pjc.103.1676361369599; Mon, 13 Feb
 2023 23:56:09 -0800 (PST)
MIME-Version: 1.0
References: <20230210142711.1177212-1-rkanwal@rivosinc.com>
In-Reply-To: <20230210142711.1177212-1-rkanwal@rivosinc.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Mon, 13 Feb 2023 23:55:58 -0800
Message-ID: <CAOnJCU+i63tk8kthtqWB09av7GQJcCrgYipqMJv+XPeLtOF90g@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] riscv/kvm: Fix VM hang in case of timer delta
 being zero.
To:     Rajnesh Kanwal <rkanwal@rivosinc.com>
Cc:     anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 10, 2023 at 6:27 AM Rajnesh Kanwal <rkanwal@rivosinc.com> wrote:
>
> In case when VCPU is blocked due to WFI, we schedule the timer
> from `kvm_riscv_vcpu_timer_blocking()` to keep timer interrupt
> ticking.
>
> But in case when delta_ns comes to be zero, we never schedule
> the timer and VCPU keeps sleeping indefinitely until any activity
> is done with VM console.
>
> This is easily reproduce-able using kvmtool.
> ./lkvm-static run -c1 --console virtio -p "earlycon root=/dev/vda" \
>          -k ./Image -d rootfs.ext4
>
> Also, just add a print in kvm_riscv_vcpu_vstimer_expired() to
> check the interrupt delivery and run `top` or similar auto-upating
> cmd from guest. Within sometime one can notice that print from
> timer expiry routine stops and the `top` cmd output will stop
> updating.
>
> This change fixes this by making sure we schedule the timer even
> with delta_ns being zero to bring the VCPU out of sleep immediately.
>
> Fixes: 8f5cb44b1bae ("RISC-V: KVM: Support sstc extension")
> Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
> ---
> v2: Added Fixes tag in commit message.
>
> v1: https://lore.kernel.org/all/20230210135136.1115213-1-rkanwal@rivosinc.com/
>
>  arch/riscv/kvm/vcpu_timer.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
> index ad34519c8a13..3ac2ff6a65da 100644
> --- a/arch/riscv/kvm/vcpu_timer.c
> +++ b/arch/riscv/kvm/vcpu_timer.c
> @@ -147,10 +147,8 @@ static void kvm_riscv_vcpu_timer_blocking(struct kvm_vcpu *vcpu)
>                 return;
>
>         delta_ns = kvm_riscv_delta_cycles2ns(t->next_cycles, gt, t);
> -       if (delta_ns) {
> -               hrtimer_start(&t->hrt, ktime_set(0, delta_ns), HRTIMER_MODE_REL);
> -               t->next_set = true;
> -       }
> +       hrtimer_start(&t->hrt, ktime_set(0, delta_ns), HRTIMER_MODE_REL);
> +       t->next_set = true;
>  }
>
>  static void kvm_riscv_vcpu_timer_unblocking(struct kvm_vcpu *vcpu)
> --
> 2.25.1
>


Reviewed-by: Atish Patra <atishp@rivosinc.com>
-- 
Regards,
Atish
