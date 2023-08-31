Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3B378F1EB
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 19:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346938AbjHaR3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 13:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240965AbjHaR3p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 13:29:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7621BCF3
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 10:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693502934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vfsQm+G3Enn5fgXR19EACJ3eKvpvvy2mdlpWv8WijKU=;
        b=fDjFl3F6K93SH7GmirF/jw0f+JlAKoHz7ABFUdFB0/7MNU5CkPWnx9dj28B22/duqFEwD5
        Se0u6Js4Eu+cTad4KIZEkreRWOmGtrOlzTZTj5mHl3R2T2yIcEr69c6eRaOyCwHUot0HLB
        e67h/7ksfxQWpbgVjA46XOpk4WxB1bo=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-bWebUab4N_W-Znk-pHDYgg-1; Thu, 31 Aug 2023 13:28:53 -0400
X-MC-Unique: bWebUab4N_W-Znk-pHDYgg-1
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-7a52a61fecbso451153241.2
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 10:28:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693502933; x=1694107733;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vfsQm+G3Enn5fgXR19EACJ3eKvpvvy2mdlpWv8WijKU=;
        b=ilc03Iug18+mpsEGQjD9ps2VyKpZuA0RXIAAigrA+7i3P7qTO/r/NxKOZgsWRCNWQB
         4P+OUgEjZjx268qoC3rY4ZlNX8eY7pNfMt57TsUKpqySerkw0dTOmk6M/UTxDT4SIxT7
         1MhMhiVd4ch5+rdsJIMS36Z1iWDK1i6e42yU/SwPvfeR8zgjA+5nfouxNTdT2lqQqfxO
         amJNrBY4t9WeGk6MItrupRTcs9CgSYfnIn9ar+AeC2j2a/EOwvqeetAEx7q145Dn/6Ox
         3vV2tCSE4E1GXzbQRD8eZLXP8LyFoIG/Fdt5ab7tbGb7YAsL4Ki2CVa9K1NVG02jcrDJ
         nMgQ==
X-Gm-Message-State: AOJu0YxUXTfL0DVDf6+Ozd+2us+SHuHH1mSQNCgFiE7isg5mxANVZpvk
        S6abhBBCJbXwP3xHrW63H5hPrwUpPIa3qwZntCbmGsgIaxaIqtQa7g5aAJ3277Mfs/7M6UEUie/
        XWqzZ8tb5KyTCB385s6pvLEfgZ8AN
X-Received: by 2002:a67:ec44:0:b0:44e:9614:39bf with SMTP id z4-20020a67ec44000000b0044e961439bfmr293101vso.6.1693502932777;
        Thu, 31 Aug 2023 10:28:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHipeW3lIgNcSTdWetBcjopqTTEHmLXiLOy2n1+8qaMIBfRzWUt+YgG4yzmubx2qtJ9GCPV0ZoYBRSD1sdgwW8=
X-Received: by 2002:a67:ec44:0:b0:44e:9614:39bf with SMTP id
 z4-20020a67ec44000000b0044e961439bfmr293075vso.6.1693502932535; Thu, 31 Aug
 2023 10:28:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAAhSdy2XiFD1QC+v_UZ5G0TAhmT8uH48=UQdu6=bL=EPWy+2Kg@mail.gmail.com>
In-Reply-To: <CAAhSdy2XiFD1QC+v_UZ5G0TAhmT8uH48=UQdu6=bL=EPWy+2Kg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 31 Aug 2023 19:28:41 +0200
Message-ID: <CABgObfbHSkoavDYqKhhotn0cOFr+x2QRYD4NN9v_55tK4nxQoQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.6
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 23, 2023 at 7:25=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> We have the following KVM RISC-V changes for 6.6:
> 1) Zba, Zbs, Zicntr, Zicsr, Zifencei, and Zihpm support for Guest/VM
> 2) Added ONE_REG interface for SATP mode
> 3) Added ONE_REG interface to enable/disable multiple ISA extensions
> 4) Improved error codes returned by ONE_REG interfaces
> 5) Added KVM_GET_REG_LIST ioctl() implementation for KVM RISC-V
> 6) Added get-reg-list selftest for KVM RISC-V
>
> Please pull.
>
> Regards,
> Anup
>
> The following changes since commit 52a93d39b17dc7eb98b6aa3edb93943248e03b=
2f:
>
>   Linux 6.5-rc5 (2023-08-06 15:07:51 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.6-1
>
> for you to fetch changes up to 477069398ed6e0498ee243e799cb6c68baf6ccb8:
>
>   KVM: riscv: selftests: Add get-reg-list test (2023-08-09 12:15:27 +0530=
)
>
> ----------------------------------------------------------------
> KVM/riscv changes for 6.6
>
> - Zba, Zbs, Zicntr, Zicsr, Zifencei, and Zihpm support for Guest/VM
> - Added ONE_REG interface for SATP mode
> - Added ONE_REG interface to enable/disable multiple ISA extensions
> - Improved error codes returned by ONE_REG interfaces
> - Added KVM_GET_REG_LIST ioctl() implementation for KVM RISC-V
> - Added get-reg-list selftest for KVM RISC-V
>
> ----------------------------------------------------------------
> Andrew Jones (9):
>       RISC-V: KVM: Improve vector save/restore errors
>       RISC-V: KVM: Improve vector save/restore functions
>       KVM: arm64: selftests: Replace str_with_index with strdup_printf
>       KVM: arm64: selftests: Drop SVE cap check in print_reg
>       KVM: arm64: selftests: Remove print_reg's dependency on vcpu_config
>       KVM: arm64: selftests: Rename vcpu_config and add to kvm_util.h
>       KVM: arm64: selftests: Delete core_reg_fixup
>       KVM: arm64: selftests: Split get-reg-list test code
>       KVM: arm64: selftests: Finish generalizing get-reg-list

Pulled, thanks, but I'll give a closer look to these patches after
kicking the long-running tests. It would have been nicer to get an
Acked-by from either me or Marc or Oliver, but no huge deal.

Paolo

