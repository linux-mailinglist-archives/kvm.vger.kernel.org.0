Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154554C059C
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 00:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236427AbiBVXzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 18:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236396AbiBVXzg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 18:55:36 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120DC37024
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 15:55:06 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id u12so30588495ybd.7
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 15:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y1Ih26MrSKGdWJCNbpIUtuX1M042QCw2P53iJFNC+sE=;
        b=H6cezHFOFMFRwhzFTu/eU/s08XZwwwOv1ttTWJy9ZJ0fwuhHjou0ABho7Cbc+55Cuq
         fqQybw7pZ5TkFfNHGqHttY4R/ycLZZKjQrVHnQVSW8ue7Z+AosMf5ZpqVpzsNXlxk1JO
         kkvNXbDj1+4do+IXR6IJWMlOyXf5DcoJKaK8I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y1Ih26MrSKGdWJCNbpIUtuX1M042QCw2P53iJFNC+sE=;
        b=CTUxZ1bzzjBqX0UzTq0hheF9ZL8Pp4T59WCbs6fZzjpdWkpXYFTFpUxosmkfZk8uHV
         NULoN6JnNfEEIDjOQAExnC1zLXEhtN1DsE26wmoP1cYxCrUCh/gLv4n26774hu4LPA/A
         oMCdTfMCox9QG9WaN22Y+64W6t7XgV7YrcrR68cKlSJDpTj4Y8qD4OCVj01uMwGzJ19Q
         mX0d/IWEXkhJt7ibYoOXYtdmLX/2Ht+taFnf5SGJjLKr9Kq0yKXV1y1fmZ1kdtYRBWn2
         WilzWTIv8X6AQekMY0rCyu4QYmYcDBjstnkHeSECmr4y2Dn5MqaRxP/h2faJOj9+dhY6
         0dVA==
X-Gm-Message-State: AOAM5315WnN6dBkaiDecH6ovH2Q28tbmXmd77QQs3yt0h6W5OUOTRpGu
        qp9t/Hnv1BIDEeJO2R5PbLg0DF8zyCRuFUWT+IIx
X-Google-Smtp-Source: ABdhPJwgrI6MqS59aplM8JIHvAmvlhliVYcWtR0CH17DvQg+mTEY1nGjjpGFUb5uiZSh5/I9MtRVKipnqgr5x9WJh1Y=
X-Received: by 2002:a25:908f:0:b0:624:a2d8:9f81 with SMTP id
 t15-20020a25908f000000b00624a2d89f81mr9785594ybl.417.1645574105992; Tue, 22
 Feb 2022 15:55:05 -0800 (PST)
MIME-Version: 1.0
References: <20220201082227.361967-1-apatel@ventanamicro.com> <20220201082227.361967-3-apatel@ventanamicro.com>
In-Reply-To: <20220201082227.361967-3-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 22 Feb 2022 15:54:55 -0800
Message-ID: <CAOnJCU+3U=qBiU-t2c7Y=kPtkKBS3izcxsFssZYsPTnd_0CMAw@mail.gmail.com>
Subject: Re: [PATCH 2/6] RISC-V: KVM: Add common kvm_riscv_vcpu_sbi_system_reset()
 function
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
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

On Tue, Feb 1, 2022 at 12:23 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> We rename kvm_sbi_system_shutdown() to kvm_riscv_vcpu_sbi_system_reset()
> and move it to vcpu_sbi.c so that it can be shared by SBI v0.1 shutdown
> and SBI v0.3 SRST extension.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  3 +++
>  arch/riscv/kvm/vcpu_sbi.c             | 17 +++++++++++++++++
>  arch/riscv/kvm/vcpu_sbi_v01.c         | 18 ++----------------
>  3 files changed, 22 insertions(+), 16 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index 04cd81f2ab5b..83d6d4d2b1df 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -28,6 +28,9 @@ struct kvm_vcpu_sbi_extension {
>  };
>
>  void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
> +void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
> +                                    struct kvm_run *run,
> +                                    u32 type, u64 flags);
>  const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid);
>
>  #endif /* __RISCV_KVM_VCPU_SBI_H__ */
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index 78aa3db76225..11ae4f621f0d 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -79,6 +79,23 @@ void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run)
>         run->riscv_sbi.ret[1] = cp->a1;
>  }
>
> +void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
> +                                    struct kvm_run *run,
> +                                    u32 type, u64 flags)
> +{
> +       unsigned long i;
> +       struct kvm_vcpu *tmp;
> +
> +       kvm_for_each_vcpu(i, tmp, vcpu->kvm)
> +               tmp->arch.power_off = true;
> +       kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
> +
> +       memset(&run->system_event, 0, sizeof(run->system_event));
> +       run->system_event.type = type;
> +       run->system_event.flags = flags;
> +       run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> +}
> +
>  int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
>         struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
> index 2ab52b6d9ed3..da4d6c99c2cf 100644
> --- a/arch/riscv/kvm/vcpu_sbi_v01.c
> +++ b/arch/riscv/kvm/vcpu_sbi_v01.c
> @@ -14,21 +14,6 @@
>  #include <asm/kvm_vcpu_timer.h>
>  #include <asm/kvm_vcpu_sbi.h>
>
> -static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
> -                                   struct kvm_run *run, u32 type)
> -{
> -       unsigned long i;
> -       struct kvm_vcpu *tmp;
> -
> -       kvm_for_each_vcpu(i, tmp, vcpu->kvm)
> -               tmp->arch.power_off = true;
> -       kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
> -
> -       memset(&run->system_event, 0, sizeof(run->system_event));
> -       run->system_event.type = type;
> -       run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> -}
> -
>  static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                                       unsigned long *out_val,
>                                       struct kvm_cpu_trap *utrap,
> @@ -80,7 +65,8 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                 }
>                 break;
>         case SBI_EXT_0_1_SHUTDOWN:
> -               kvm_sbi_system_shutdown(vcpu, run, KVM_SYSTEM_EVENT_SHUTDOWN);
> +               kvm_riscv_vcpu_sbi_system_reset(vcpu, run,
> +                                               KVM_SYSTEM_EVENT_SHUTDOWN, 0);
>                 *exit = true;
>                 break;
>         case SBI_EXT_0_1_REMOTE_FENCE_I:
> --
> 2.25.1
>

Reviewed-by: Atish Patra <atishp@rivosinc.com>
-- 
Regards,
Atish
