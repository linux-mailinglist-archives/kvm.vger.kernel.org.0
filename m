Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A14568273D
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 09:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbjAaIqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 03:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbjAaIp6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 03:45:58 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339C04B494
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 00:42:00 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id f3so9549248pgc.2
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 00:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6BBDoy6ggwb6qGNiyOkTSoxV/P1y2lqshZx72I60wlo=;
        b=uIaXYVGWKnxZc25C7CLiMyGFtVeByyD1QJsgjdJXwB9VvmoQaFybtvyRapC8CYSQGK
         PtbfFjN/JBOlpYrmNdzMsZY+oNnTPWdkJNyjZthniC2L8ym/4AjIMlfVE71P00O6DloV
         82i2+z839gMZd41eyaCTC2aJYQyicnCHKnAYs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6BBDoy6ggwb6qGNiyOkTSoxV/P1y2lqshZx72I60wlo=;
        b=QU1IUCbVNRU0W9SUEOQCjEyaN6I+CVpCLzLWZrFvcapXESM8xnyaFzo8MSbySXxu0a
         +8EOoSNfLFnVYQFbsH2V3BPrmCEUklWkPNV/B4ASMCdKrXQAfvq13qVBd3TgOrxIdiAN
         /6pZNO4fplNfcJoJ3G5Vox/grlRP4en46FVgEp6FM2sMGn0zO7mkLpnMqohvEc0ATcmO
         2tEkFmCpci+n63B64+9iIX3JgVLE5TmKG+QB2fJISVnWDSDG5tvZbuHtha37objVIVWJ
         U6eQVl3uiLcWc2404neE19fXBdXT40Ge6wIh3nsJVOtOTesx6mS/jJC3g2EArtL+s1XI
         xxQA==
X-Gm-Message-State: AFqh2ko9mktRB4b8i9QivPqkQhNyoZ4Qd24v/EIpVLWMX6ktzltIlfWp
        xOYovQj6NYl2VgUyICkbGrSA/0neDcxPFeEGFU+OJuAkFBUN
X-Google-Smtp-Source: AMrXdXtZxYxyLa7B2DvS3Eia4Iejwao+ygD4HHLiTQho/V+PX7kCCCat31riNZKHj49IR33cbI1qEhMhFE8AQHL+KTY=
X-Received: by 2002:a63:105c:0:b0:483:f80c:cdf3 with SMTP id
 28-20020a63105c000000b00483f80ccdf3mr5731341pgq.70.1675154507255; Tue, 31 Jan
 2023 00:41:47 -0800 (PST)
MIME-Version: 1.0
References: <20230128082847.3055316-1-apatel@ventanamicro.com> <20230128082847.3055316-2-apatel@ventanamicro.com>
In-Reply-To: <20230128082847.3055316-2-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 31 Jan 2023 00:41:35 -0800
Message-ID: <CAOnJCU+77AG55TTpekDKYVeeXjpR5QPw-CJ1zQq0ogB_rtP8dg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] RISC-V: KVM: Redirect illegal instruction traps to guest
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Andy Chiu <andy.chiu@sifive.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 28, 2023 at 12:29 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> From: Andy Chiu <andy.chiu@sifive.com>
>
> The M-mode redirects an unhandled illegal instruction trap back
> to S-mode. However, KVM running in HS-mode terminates the VS-mode
> software when it receives illegal instruction trap. Instead, KVM
> should redirect the illegal instruction trap back to VS-mode, and
> let VS-mode trap handler decide the next step. This futher allows
> guest kernel to implement on-demand enabling of vector extension
> for a guest user space process upon first-use.
>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu_exit.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index af7c4bc07929..4ea101a73d8b 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -182,6 +182,12 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>         ret = -EFAULT;
>         run->exit_reason = KVM_EXIT_UNKNOWN;
>         switch (trap->scause) {
> +       case EXC_INST_ILLEGAL:
> +               if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV) {
> +                       kvm_riscv_vcpu_trap_redirect(vcpu, trap);
> +                       ret = 1;
> +               }
> +               break;
>         case EXC_VIRTUAL_INST_FAULT:
>                 if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
>                         ret = kvm_riscv_vcpu_virtual_insn(vcpu, run, trap);
> --
> 2.34.1
>

Reviewed-by: Atish Patra <atishp@rivosinc.com>

-- 
Regards,
Atish
