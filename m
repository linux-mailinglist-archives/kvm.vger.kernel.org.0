Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2256877DE
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 09:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbjBBIuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 03:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbjBBIuA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 03:50:00 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F517D6D5
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 00:49:57 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id ud5so3931597ejc.4
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 00:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YEMr8jwJtqEBvUW6IeEvoy6PFpQWvVltt0F9wihv4bc=;
        b=E4VeslbplWo822JEUy/TVhNC3AjWEJtICAApZgk4VjnANKU98n3UtBxM9Lx27SUzZb
         VCTl8nQfoW4L71CcnsAiYB4LB5F6+lGOeBiXou97b7WRakNcb1iB8m2OjwMHHMBm1TgB
         iueYKPTQQh/tNy7xaOgo7bssfHdq68ITQRKsRX4KWF8TTXyK1Nw9+yTzkuIG5W22lNUB
         NOWPKIysHGKjVu5FxtI3n5oqyd1doi3+rwy52r5uRu86hTtJ+McGGjd4FbURprZYu8SB
         fYyakX2igykkWwkEMcYDqWnm+tZ1bvInFqQLOhkrbUHZBktlmPmp9Zr9frSkCFv5TIft
         1m0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YEMr8jwJtqEBvUW6IeEvoy6PFpQWvVltt0F9wihv4bc=;
        b=aujeo+/dzB+DMlwCLdZQi0tYQDBgerSDAoU4Y+Vt79FQkmYsggB9xl+cHga/O/sHR7
         /1VrderqcDltwy+XG/1/jMePstblixXiFp/FFuNXfpU2AEKyJZk6XjAWMW49oBp5drcU
         n9T2kqDzf92ptD52845sIF4UOSU84LZTvEbREBdrb8yFgipDrYQ5UrPSi/Ik/dRwKSkS
         SSMgr8ldk3JsIgMSWlCJ90vMKrxS8KaFb05jZjCoEY8DaPVZfeV2BCr8znu3+Zkzsvmo
         4ktzEWEQ23ZOaA2pjawSPxr5TlgdrhnSf6XiyThtyVm0lvuFQK2l4uKp/D9yC4sCmvq5
         mRIQ==
X-Gm-Message-State: AO0yUKXqNc3TWYMp+B+9ve6grTOdoQlDCIR/7tHK47dB3E7swO3hYUv6
        gzFVGu1V17JTEnAcrL3oB7Vb0wWKzQgxv/6urEofVg==
X-Google-Smtp-Source: AK7set+38N6ru0VcJjhFUKCNehas73Jp8D6FAynbNoh9W4N5K+8dinXtsQKRFrjqrQ5QEKfdEvUkNXxWQWnqjKO2VgI=
X-Received: by 2002:a17:906:7e42:b0:86d:fa64:2941 with SMTP id
 z2-20020a1709067e4200b0086dfa642941mr1889020ejr.72.1675327795914; Thu, 02 Feb
 2023 00:49:55 -0800 (PST)
MIME-Version: 1.0
References: <20230128082847.3055316-1-apatel@ventanamicro.com> <20230128082847.3055316-2-apatel@ventanamicro.com>
In-Reply-To: <20230128082847.3055316-2-apatel@ventanamicro.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 2 Feb 2023 14:19:44 +0530
Message-ID: <CAAhSdy0GAwpUCTAXn_Gg==MMigFpkRSNHZMFvDQtZQ08zW_a9A@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] RISC-V: KVM: Redirect illegal instruction traps to guest
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Andy Chiu <andy.chiu@sifive.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 28, 2023 at 1:59 PM Anup Patel <apatel@ventanamicro.com> wrote:
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

Queued this patch for Linux-6.3

Thanks,
Anup

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
