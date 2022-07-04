Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BECA9565107
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 11:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiGDJgu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 05:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbiGDJgo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 05:36:44 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA57136
        for <kvm@vger.kernel.org>; Mon,  4 Jul 2022 02:36:42 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id d16so6282485wrv.10
        for <kvm@vger.kernel.org>; Mon, 04 Jul 2022 02:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q0TyLnReruI9Wm2732Ut83Y4mOFAKXfOkqxOXkTD/V8=;
        b=G1fWW/mpQ2bdGFNaIsSiqulbH86dbUIEM5HWmUU6f/ZgCaOYpV7OCKHesOvaS9YNmj
         AdoUT51LYOQeWxO1vgRknFPkdXOIRzDq9asQ6ILdueOBVe9dWBnLnmBn7PT0ilhPkr4W
         P1Qzki/cxPelPhc7+oB/wvESNGlC2E44VlUHGd/T0p2S93V/7425dJclQ78s+iuJRzac
         hRkYG82SWkWehe9nCNcbagVvjAOcOsMQb+U7fTN3GTJ+43Qg/OfpSY0lptPVgp2liJU7
         CpSfGwAJkXHzzvOA06buA/Ljk7zlp+vV1Rfqoj6monK5miuZwezvA2bqHNPEp9aGRkXi
         HVAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q0TyLnReruI9Wm2732Ut83Y4mOFAKXfOkqxOXkTD/V8=;
        b=Zp+jTwQWEYf03Dq90P73O+ALXBF3qaZUf/RFsJIPG1Ae+PcL4FyX9PWs3GKTy0H/ax
         DQpxhAwYSh4YMQTOLRUBtfU2pctue+9ncX2Flp4/+bVyPEYSxjrI8eFmPW1acDJE/yRE
         PaiQMef5A7NULKm3NaqyQ65XDxLo7EoxugbkyTPdxUwQyQOlnssa1lnUvIJb/QmYMMkc
         hED41UjZEdX0b5fhVPF/eP7z7WTrvDDzicdtYIEyTzVaR0AYSxtn4NbXA4kK0h+7cz23
         xrjqX5BFLJ1FUkVwKTCTyIop4oPmlzb7vsr3cZQbEML6f3jvFPTKwqg+56enSidGpg+Y
         xEuA==
X-Gm-Message-State: AJIora9azE7sSzkXfI8dE1poWLNABRxol7Jy39j6oLTWkd0/Yc0YxkvP
        0jKA2LJVxuRxoZPyDPXOoJi6bfbZ1oL0z/HOek/kGw==
X-Google-Smtp-Source: AGRyM1txqFZ6XRw/gt33s19FIVnrJxgWXkN0MbkEtqzXTHsDz8SglQyeVKVBcetRPdHeC3qf3WE112AyqnLV4QHet+M=
X-Received: by 2002:a5d:6b09:0:b0:21d:554f:b466 with SMTP id
 v9-20020a5d6b09000000b0021d554fb466mr11247084wrw.86.1656927400543; Mon, 04
 Jul 2022 02:36:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220615104025.941382-1-apatel@ventanamicro.com>
In-Reply-To: <20220615104025.941382-1-apatel@ventanamicro.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 4 Jul 2022 15:06:28 +0530
Message-ID: <CAAhSdy3gmnqB6La125i2hdVh6eNiwqG6saqz4RTTYF=2Gqo6cA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Improve instruction and CSR emulation in KVM RISC-V
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 15, 2022 at 4:10 PM Anup Patel <apatel@ventanamicro.com> wrote:
>
> Currently, the instruction emulation for MMIO traps and Virtual instruction
> traps co-exist with general VCPU exit handling. The instruction and CSR
> emulation will grow with upcoming SBI PMU, AIA, and Nested virtualization
> in KVM RISC-V. In addition, we also need a mechanism to allow user-space
> emulate certain CSRs under certain situation (example, host has AIA support
> but user-space does not wants to use in-kernel AIA IMSIC and APLIC support).
>
> This series improves instruction and CSR emulation in KVM RISC-V to make
> it extensible based on above.
>
> These patches can also be found in riscv_kvm_csr_v2 branch at:
> https://github.com/avpatel/linux.git
>
> Changes since v1:
>  - Added a switch-case in PATCH3 to process MMIO, CSR, and SBI returned
>    from user-space
>  - Removed hard-coding in PATCH3 for determining type of CSR instruction
>
> Anup Patel (3):
>   RISC-V: KVM: Factor-out instruction emulation into separate sources
>   RISC-V: KVM: Add extensible system instruction emulation framework
>   RISC-V: KVM: Add extensible CSR emulation framework

I have queued this series for 5.20

Thanks,
Anup

>
>  arch/riscv/include/asm/kvm_host.h           |  16 +-
>  arch/riscv/include/asm/kvm_vcpu_insn.h      |  48 ++
>  arch/riscv/kvm/Makefile                     |   1 +
>  arch/riscv/kvm/vcpu.c                       |  34 +-
>  arch/riscv/kvm/vcpu_exit.c                  | 490 +----------------
>  arch/riscv/kvm/{vcpu_exit.c => vcpu_insn.c} | 563 +++++++++++---------
>  include/uapi/linux/kvm.h                    |   8 +
>  7 files changed, 392 insertions(+), 768 deletions(-)
>  create mode 100644 arch/riscv/include/asm/kvm_vcpu_insn.h
>  copy arch/riscv/kvm/{vcpu_exit.c => vcpu_insn.c} (63%)
>
> --
> 2.34.1
>
