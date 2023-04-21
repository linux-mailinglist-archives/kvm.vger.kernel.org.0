Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6BC26EB5C3
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 01:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbjDUXj4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 19:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjDUXjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 19:39:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02041BD2
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 16:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682120347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q/afhnI1x+eYKjA0I6qC7en+J2iSi5vz0PAxjsQejjY=;
        b=jC1XooJ25pR0hWFxkAbKeoKgGXF2+WVkrlE3Y++E/cNzfIqspNoT9N5nztj2OgWlIHzE74
        jpG/EHP9N/7znb4TGH1e8FpTZA/V753Mn4ghS34L7D4u4af6rrJs4qzc4Qia+s/RrOLOCI
        hJH4AfD77nHftfylK70aoHzzdyoHY4A=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-EL5JSLf1Ok2yRBUPdAXkVg-1; Fri, 21 Apr 2023 19:39:06 -0400
X-MC-Unique: EL5JSLf1Ok2yRBUPdAXkVg-1
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-4404c17ddc6so650988e0c.2
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 16:39:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682120346; x=1684712346;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q/afhnI1x+eYKjA0I6qC7en+J2iSi5vz0PAxjsQejjY=;
        b=YCEEdqp7WW4lGGGoHluf+N4Bjo/rcYs5CFCcKEh8dJJc+XOQTGad24+49nlzhVudY/
         lMrjq22A5uUc8kozxtZ+xtxTu/Q3PlaBA8tA8h9KQ3+kFXJ/LAgckR2guu1dLyoE3y7c
         KPTDYJyhEFb5nv6OXMrEi+WDWPCNwFjvYgGpUe4UXwnTmeZjBffAQr8G5O972A+kbzha
         oKUhOEcWGsd9eFttG+47ycm8A21UbouWbTysf+1+B2OuYaH7YCGC8JNa2GFXvHIPesG3
         1lcvgcj3L3nvpm5uE5EfKObSAji3XKq7w3EBaq0ZTNzYdxZuJ/ga0paG/GfVX34IZW48
         TI/A==
X-Gm-Message-State: AAQBX9cxFnsdEiPZeSgC3jsB9+L7fLj5ox6F1NBfpuY++tTN1OhY9yU/
        Z5D5fvrImxfKTVmGYryli2c305Dtm8HNwplYLENkSAPR8Om6wVua+982KS3xePf6yGCMDnn3S9P
        N9ZWAE1OPU9Br2X2RVq5qIdCdzZjH
X-Received: by 2002:a67:ee8d:0:b0:42f:e8fd:da7 with SMTP id n13-20020a67ee8d000000b0042fe8fd0da7mr3477656vsp.1.1682120346104;
        Fri, 21 Apr 2023 16:39:06 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y3BDEx0wdQjgGro7XLB/++nMWdvI+uCPhoipYb8afB40vTgna5qtCqU2CB+HQhaZ8CuxDk4E5to7hNNWxQ3hQ=
X-Received: by 2002:a67:ee8d:0:b0:42f:e8fd:da7 with SMTP id
 n13-20020a67ee8d000000b0042fe8fd0da7mr3477647vsp.1.1682120345813; Fri, 21 Apr
 2023 16:39:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAAhSdy2RLinG5Gx-sfOqrYDAT=xDa3WAk8r1jTu8ReO5Jo0LVA@mail.gmail.com>
In-Reply-To: <CAAhSdy2RLinG5Gx-sfOqrYDAT=xDa3WAk8r1jTu8ReO5Jo0LVA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Sat, 22 Apr 2023 01:38:54 +0200
Message-ID: <CABgObfbPB2NYwDLHnQSW0gtw0AX96KbeNOQsszw0NqytObyfaQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.4
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Atish Patra <atishp@atishpatra.org>,
        Atish Patra <atishp@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Anup,

while you did fix the bug that caused the mailing list date to
disappear, I noticed that these patches have been _applied_ (not just
rebased) earlier today, just a few hours before sending the pull
request.

The pull request was sent around midnight, Indian time, while the
patches were applied around 5-6pm. I  recognized that this is not a
rebase because the commit dates are grouped according to the topicsL

17:38:40 +0530 KVM: RISC-V: Retry fault if vma_lookup() results become inva=
lid
17:38:42 +0530 RISC-V: KVM: Alphabetize selects
17:38:44 +0530 RISC-V: KVM: Add ONE_REG interface to enable/disable
SBI extensions
17:38:46 +0530 RISC-V: KVM: Allow Zbb extension for Guest/VM

17:45:39 +0530 RISC-V: Add AIA related CSR defines
17:45:42 +0530 RISC-V: Detect AIA CSRs from ISA string
17:45:44 +0530 RISC-V: KVM: Drop the _MASK suffix from hgatp.VMID mask defi=
nes
17:45:48 +0530 RISC-V: KVM: Initial skeletal support for AIA
17:45:51 +0530 RISC-V: KVM: Implement subtype for CSR ONE_REG interface
17:45:54 +0530 RISC-V: KVM: Add ONE_REG interface for AIA CSRs
17:45:58 +0530 RISC-V: KVM: Use bitmap for irqs_pending and irqs_pending_ma=
sk

18:10:27 2023 +0530 RISC-V: KVM: Virtualize per-HART AIA CSRs

What this means, is that there is no way that these patches have been
tested by anyone except you. Please try to push to the kvm-riscv/next
branch as soon as patches are ready, since that makes it easier to
spot conflicts between architectures.

In fact, since RISC-V is still pretty small, feel free to send me pull
requests even early in the development period, as soon as some patches
are ready.

Paolo

On Fri, Apr 21, 2023 at 7:34=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> We have the following KVM RISC-V changes for 6.4:
> 1) ONE_REG interface to enable/disable SBI extensions
> 2) Zbb extension for Guest/VM
> 3) AIA CSR virtualization
> 4) Few minor cleanups and fixes
>
> Please pull.
>
> Please note that the Zicboz series has been taken by
> Palmer through the RISC-V tree which results in few
> minor conflicts in the following files:
> arch/riscv/include/asm/hwcap.h
> arch/riscv/include/uapi/asm/kvm.h
> arch/riscv/kernel/cpu.c
> arch/riscv/kernel/cpufeature.c
> arch/riscv/kvm/vcpu.c
>
> I am not sure if a shared tag can make things easy
> for you or Palmer.
>
> Regards,
> Anup
>
> The following changes since commit 6a8f57ae2eb07ab39a6f0ccad60c7607430510=
26:
>
>   Linux 6.3-rc7 (2023-04-16 15:23:53 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.4-1
>
> for you to fetch changes up to 2f4d58f7635aec014428e73ef6120c4d0377c430:
>
>   RISC-V: KVM: Virtualize per-HART AIA CSRs (2023-04-21 18:10:27 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv changes for 6.4
>
> - ONE_REG interface to enable/disable SBI extensions
> - Zbb extension for Guest/VM
> - AIA CSR virtualization
>
> ----------------------------------------------------------------
> Andrew Jones (1):
>       RISC-V: KVM: Alphabetize selects
>
> Anup Patel (10):
>       RISC-V: KVM: Add ONE_REG interface to enable/disable SBI extensions
>       RISC-V: KVM: Allow Zbb extension for Guest/VM
>       RISC-V: Add AIA related CSR defines
>       RISC-V: Detect AIA CSRs from ISA string
>       RISC-V: KVM: Drop the _MASK suffix from hgatp.VMID mask defines
>       RISC-V: KVM: Initial skeletal support for AIA
>       RISC-V: KVM: Implement subtype for CSR ONE_REG interface
>       RISC-V: KVM: Add ONE_REG interface for AIA CSRs
>       RISC-V: KVM: Use bitmap for irqs_pending and irqs_pending_mask
>       RISC-V: KVM: Virtualize per-HART AIA CSRs
>
> David Matlack (1):
>       KVM: RISC-V: Retry fault if vma_lookup() results become invalid
>
>  arch/riscv/include/asm/csr.h          | 107 +++++++++-
>  arch/riscv/include/asm/hwcap.h        |   8 +
>  arch/riscv/include/asm/kvm_aia.h      | 127 +++++++++++
>  arch/riscv/include/asm/kvm_host.h     |  14 +-
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |   8 +-
>  arch/riscv/include/uapi/asm/kvm.h     |  51 ++++-
>  arch/riscv/kernel/cpu.c               |   2 +
>  arch/riscv/kernel/cpufeature.c        |   2 +
>  arch/riscv/kvm/Kconfig                |  10 +-
>  arch/riscv/kvm/Makefile               |   1 +
>  arch/riscv/kvm/aia.c                  | 388 ++++++++++++++++++++++++++++=
++++++
>  arch/riscv/kvm/main.c                 |  22 +-
>  arch/riscv/kvm/mmu.c                  |  28 ++-
>  arch/riscv/kvm/vcpu.c                 | 194 +++++++++++++----
>  arch/riscv/kvm/vcpu_insn.c            |   1 +
>  arch/riscv/kvm/vcpu_sbi.c             | 247 ++++++++++++++++++++--
>  arch/riscv/kvm/vcpu_sbi_base.c        |   2 +-
>  arch/riscv/kvm/vm.c                   |   4 +
>  arch/riscv/kvm/vmid.c                 |   4 +-
>  19 files changed, 1129 insertions(+), 91 deletions(-)
>  create mode 100644 arch/riscv/include/asm/kvm_aia.h
>  create mode 100644 arch/riscv/kvm/aia.c
>

