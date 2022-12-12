Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0283B649E19
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 12:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbiLLLmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 06:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbiLLLl4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 06:41:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12109EE3A
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 03:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670844984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h3nGaS/BzxpoZBgzJ/A6+CxjyYDCWWuPh4Q+FvFOKgE=;
        b=dPQscaic1ZyenPsAjzIpk5tc5c2BY2SAqj8eQogHx15iD31pyCKtPKmooBijzShYxI0tMF
        9QUpdpfYULO14RmIdgoVU4Bx4GHXbKSWdjcMGj7kw8Rpp/W2t6O6Rje8M21a2CN02Mq7Ax
        qqhRQ0+TKp2ZQiQOO87Tl+ju2du1a0Q=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-620-fLltApAVMRaM1I15YqE32w-1; Mon, 12 Dec 2022 06:36:23 -0500
X-MC-Unique: fLltApAVMRaM1I15YqE32w-1
Received: by mail-vk1-f199.google.com with SMTP id f190-20020a1f1fc7000000b003b88bc02472so4304884vkf.13
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 03:36:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h3nGaS/BzxpoZBgzJ/A6+CxjyYDCWWuPh4Q+FvFOKgE=;
        b=0OXid2N/skG5sVR2tXTjaoa2nEgfNvHS8oRezspsm6qMIxd3JhXd7KDMd1k6D9rL06
         Yf2GYLxxpr6WJUsmWhM257zl4oU/ochPVGg4bvemLHbYmKSmBuc3I+a6hJPmS+Z8q6mS
         mdQAc4BaeSgUma1kyi4WcsQkfZ1sxpZjwZJuujeTOf977ZUkis5y06GHvXe9dcZXNtou
         attOKI1YEtpU0Kp8kS0cFtlTqqh43g/nXkDjZFzBn0RUkCotfve64fUoU+dUJgf/MQYU
         39egXXZV1AYnxvfBeQ4Q9kCzjW0Ed6ikvZOKfUoi/9DJmw9SLGJO4GHU0Pqras6uLl9C
         aSrw==
X-Gm-Message-State: ANoB5pmqNvQBj2nUloqhbM/TgejWX+hZGQcN3iNLhoYgWI9xtTauC6NI
        StscglNWfNdzjDklfDNVUFmzMtOihR/fTEy5GeSgONYIcu1IWIkw6Gx5pwxjVb5d/Lpwhaot7ic
        SPoZMExtCDGixvKzV8IZB6ytzbzsp
X-Received: by 2002:a67:ee95:0:b0:3aa:2354:b5d2 with SMTP id n21-20020a67ee95000000b003aa2354b5d2mr46725193vsp.16.1670844982491;
        Mon, 12 Dec 2022 03:36:22 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6L0suCBdpdKZTeXJrqwx+cD9dUWlWKYgmOdFJG5Nxuva9VVcEzWcg9/sxtke4bVoRcGFHv6zO88PrSQMOiXvU=
X-Received: by 2002:a67:ee95:0:b0:3aa:2354:b5d2 with SMTP id
 n21-20020a67ee95000000b003aa2354b5d2mr46725186vsp.16.1670844982153; Mon, 12
 Dec 2022 03:36:22 -0800 (PST)
MIME-Version: 1.0
References: <CAAhSdy0qihfFCXTV-QUjP-5XiQQqBC4_sP-swx77k6PC3uTmmw@mail.gmail.com>
In-Reply-To: <CAAhSdy0qihfFCXTV-QUjP-5XiQQqBC4_sP-swx77k6PC3uTmmw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 12 Dec 2022 12:36:11 +0100
Message-ID: <CABgObfZ7Ar-t5m0+p=H1h0_bk-dJ5rYSVRCo6ZP5Wa0Qva2sLQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.2
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 7, 2022 at 11:33 AM Anup Patel <anup@brainfault.org> wrote:
>
> Hi Paolo,
>
> We have the following KVM RISC-V changes for 6.2:
> 1) Allow unloading KVM module
> 2) Allow KVM user-space to set mvendorid, marchid, and mimpid
> 3) Several fixes and cleanups
>
> Please pull.
>
> Regards,
> Anup

Hmm, I looked at them more closely and I noticed something weird in
the author date:

git log --format='%an %ad %s' origin/master..6ebbdecff6ae
Anup Patel Wed Dec 7 09:17:49 2022 +0530 RISC-V: KVM: Add ONE_REG
interface for mvendorid, marchid, and mimpid
Anup Patel Wed Dec 7 09:17:43 2022 +0530 RISC-V: KVM: Save mvendorid,
marchid, and mimpid when creating VCPU
Anup Patel Wed Dec 7 09:17:38 2022 +0530 RISC-V: Export
sbi_get_mvendorid() and friends
Anup Patel Wed Dec 7 09:17:27 2022 +0530 RISC-V: KVM: Move sbi related
struct and functions to kvm_vcpu_sbi.h
Anup Patel Wed Dec 7 09:17:19 2022 +0530 RISC-V: KVM: Use switch-case
in kvm_riscv_vcpu_set/get_reg()
Anup Patel Wed Dec 7 09:17:12 2022 +0530 RISC-V: KVM: Remove redundant
includes of asm/csr.h
Anup Patel Wed Dec 7 09:17:05 2022 +0530 RISC-V: KVM: Remove redundant
includes of asm/kvm_vcpu_timer.h
Anup Patel Wed Dec 7 09:16:51 2022 +0530 RISC-V: KVM: Fix reg_val
check in kvm_riscv_vcpu_set_reg_config()
Christophe JAILLET Wed Dec 7 09:16:39 2022 +0530 RISC-V: KVM: Simplify
kvm_arch_prepare_memory_region()
Anup Patel Wed Dec 7 09:16:21 2022 +0530 RISC-V: KVM: Exit run-loop
immediately if xfer_to_guest fails
Bo Liu Wed Dec 7 09:16:11 2022 +0530 RISC-V: KVM: use vma_lookup()
instead of find_vma_intersection()
XiakaiPan Wed Dec 7 09:16:02 2022 +0530 RISC-V: KVM: Add exit logic to main.c

Something in your workflow has eaten the actual date when these were
posted to the mailing list.

For example, https://lore.kernel.org/lkml/CAAhSdy0t1XGTENidgNQkQ5m5emZOes+-2RXTPLEJ0tEZXuX2hA@mail.gmail.com/t/
shows Bo Liu's patch as being sent on November 1st.

Please keep the author information from the mailing list messages, and
also please try to update the KVM/RISC-V tree as soon as patches are
ready and tested, i.e. earlier than the week before the merge window.
(Seeing '6.1-rc8' as the base for the pull request is often a sign of
something wrong with the workflow; see

It's a small set of changes, so I'm going to defer this pull request
to the second week of the merge window.

Paolo

> The following changes since commit 76dcd734eca23168cb008912c0f69ff408905235:
>
>   Linux 6.1-rc8 (2022-12-04 14:48:12 -0800)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.2-1
>
> for you to fetch changes up to 6ebbdecff6ae00557a52539287b681641f4f0d33:
>
>   RISC-V: KVM: Add ONE_REG interface for mvendorid, marchid, and
> mimpid (2022-12-07 09:17:49 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv changes for 6.2
>
> - Allow unloading KVM module
> - Allow KVM user-space to set mvendorid, marchid, and mimpid
> - Several fixes and cleanups
>
> ----------------------------------------------------------------
> Anup Patel (9):
>       RISC-V: KVM: Exit run-loop immediately if xfer_to_guest fails
>       RISC-V: KVM: Fix reg_val check in kvm_riscv_vcpu_set_reg_config()
>       RISC-V: KVM: Remove redundant includes of asm/kvm_vcpu_timer.h
>       RISC-V: KVM: Remove redundant includes of asm/csr.h
>       RISC-V: KVM: Use switch-case in kvm_riscv_vcpu_set/get_reg()
>       RISC-V: KVM: Move sbi related struct and functions to kvm_vcpu_sbi.h
>       RISC-V: Export sbi_get_mvendorid() and friends
>       RISC-V: KVM: Save mvendorid, marchid, and mimpid when creating VCPU
>       RISC-V: KVM: Add ONE_REG interface for mvendorid, marchid, and mimpid
>
> Bo Liu (1):
>       RISC-V: KVM: use vma_lookup() instead of find_vma_intersection()
>
> Christophe JAILLET (1):
>       RISC-V: KVM: Simplify kvm_arch_prepare_memory_region()
>
> XiakaiPan (1):
>       RISC-V: KVM: Add exit logic to main.c
>
>  arch/riscv/include/asm/kvm_host.h     | 16 +++----
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  6 +++
>  arch/riscv/include/uapi/asm/kvm.h     |  3 ++
>  arch/riscv/kernel/sbi.c               |  3 ++
>  arch/riscv/kvm/main.c                 |  6 +++
>  arch/riscv/kvm/mmu.c                  |  6 +--
>  arch/riscv/kvm/vcpu.c                 | 85 ++++++++++++++++++++++++++---------
>  arch/riscv/kvm/vcpu_sbi_base.c        | 13 +++---
>  arch/riscv/kvm/vcpu_sbi_hsm.c         |  1 -
>  arch/riscv/kvm/vcpu_sbi_replace.c     |  1 -
>  arch/riscv/kvm/vcpu_sbi_v01.c         |  1 -
>  11 files changed, 97 insertions(+), 44 deletions(-)
>

