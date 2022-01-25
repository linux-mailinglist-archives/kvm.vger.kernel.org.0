Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6F049ADAD
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 08:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353975AbiAYHem (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 02:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445850AbiAYHcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 02:32:00 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A20DC0424EB
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 22:31:20 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id p125so17513668pga.2
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 22:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YG1wib0jWKpTEv/nofuJq/GxyHAOLnxfqxgZPfSyV44=;
        b=qk4o3TTXTv+cpSH/i+RQveYIp99fA4DsTRghVk2Ob/WiY5w8IxPAtvr/Vb5mn5vULW
         h1q4t6ma/beOHTtY8MiRELHR2U+7K2eIP+2TApkr+W8cR4vdjNlrxtuxmBfO403eswJu
         DWqZCkc8lInsa/dptVMjA0mDfU/wkiaKGoHzo3vXIUDyJRq7Yk3dr0VnwlBNQfUEpqvA
         YR/LdZUqIvWlUsJ1FTO1PoH8K9zAn64eYg16OYnAAmhvMUr1JF/KpkJNT02kmv0A5150
         Wq0ehR49xD9hwnCZ+nwuxeYWGpit1+x7FxJlMOIL0d6fKF7TiJue2+I5yzywawUEG0Um
         AJ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YG1wib0jWKpTEv/nofuJq/GxyHAOLnxfqxgZPfSyV44=;
        b=mv6c5niOcxrFfsqeqWS8dZ9/1iUmaOHCTjYF8xm8e1Q+UX6fAD3W2Hdpi2pSxvOfn3
         /mLitInvajrsn5+JJr4sFN8xnmiWRiEehKeUhrlV5NtQgc/LPR5thY3MLhu0rg/HdGoZ
         /kOOa9HO8qE8YvPc7nNih8oQl8caQrE0AuhzW+HnMZpA1TLA8QpBOFA84Lso6IHA5WoV
         aG20xO6Tl06BZMs+b0LYhQtqHlDyG6jxia5VZcUbf3S5hiJa17H6zWgb5uyO+MINyzR9
         PJkNVWtA1x02rL77oD5UlapfNIBLIbmRPPyJAegwePBDX14U9mB2q6lI+zQ43UbZP95K
         KPLQ==
X-Gm-Message-State: AOAM531z6muf8g5LD6PycNywvDs/ytsA+TYUmcaioBO2nLDDUKc+DrCu
        djw2vakjwujtantOOliMkoWjf+oxLoKG99KPF8JNcQ==
X-Google-Smtp-Source: ABdhPJzKPY5+AosojAOsMf5//CbEsDG7qRW3/e0s545y2t9TU7KMtsojg5imxCq5qHPLc+yrFU5vqzypZk2T/AWwJ94=
X-Received: by 2002:a63:7c03:: with SMTP id x3mr14146005pgc.433.1643092279490;
 Mon, 24 Jan 2022 22:31:19 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <CA+EHjTz1=Nwd97GzagkAqZ08m-yGUHeujmtX45mLDD1beF8Ykg@mail.gmail.com>
In-Reply-To: <CA+EHjTz1=Nwd97GzagkAqZ08m-yGUHeujmtX45mLDD1beF8Ykg@mail.gmail.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 24 Jan 2022 22:31:03 -0800
Message-ID: <CAAeT=FzC4U380ZhhxFgZ0xa5xae2ZUf5uFOOfjT2RA6K2btX_w@mail.gmail.com>
Subject: Re: [RFC PATCH v4 00/26] KVM: arm64: Make CPU ID registers writable
 by userspace
To:     Fuad Tabba <tabba@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Fuad,

On Mon, Jan 24, 2022 at 8:19 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Reiji,
>
> On Thu, Jan 6, 2022 at 4:27 AM Reiji Watanabe <reijiw@google.com> wrote:
>
> > The patch series is for both VHE and non-VHE, except for protected VMs,
> > which have a different way of configuring ID registers based on its
> > different requirements [1].
>
> I am reviewing this patch series and I really like your approach. I
> think that once it's through we might be able to generalize it for
> protected VMs as well (I did some of the work for the ID registers for
> those).

Thank you for the review and comments for the series.
I will be looking at your comments.

> > The series is based on v5.16-rc8 with the patch [3] applied.
>
> I tried to apply this series on v5.16-rc8 after applying
> 20220104194918.373612-2-rananta@google.com, and it didn't apply
> cleanly. If you could point me to a working branch that I could
> checkout I would like to test it and experiment with it a bit more.

I'm sorry for the inconvenience.  I'm not sure why though...
I tried that again (applied the series on v5.16-rc8 after applying
20220104194918.373612-2-rananta@google.com), and it worked fine.

Anyway, you can find the branch at:
 https://github.com/reijiw-kvm/kvmarm-idreg/tree/id-regs-v4-5.16-rc8

Thanks,
Reiji


>
>
>
>
> > v4:
> >   - Make ID registers storage per VM instead of per vCPU. [Marc]
> >   - Implement arm64_check_features() in arch/arm64/kernel/cpufeature.c
> >     by using existing codes in the file. [Marc]
> >   - Use a configuration function to enable traps for disabled
> >     features. [Marc]
> >   - Document ID registers become immutable after the first KVM_RUN [Eric]
> >   - Update ID_AA64PFR0.GIC at the point where a GICv3 is created. [Marc]
> >   - Get TGranX's bit position by substracting 12 from TGranX_2's bit
> >     position. [Eric]
> >   - Don't validate AArch32 ID registers when the system doesn't support
> >     32bit EL0. [Eric]
> >   - Add/fixes comments for patches. [Eric]
> >   - Made bug fixes/improvements of the selftest. [Eric]
> >   - Added .kunitconfig for arm64 KUnit tests
> >
> > v3: https://lore.kernel.org/all/20211117064359.2362060-1-reijiw@google.com/
> >   - Remove ID register consistency checking across vCPUs. [Oliver]
> >   - Change KVM_CAP_ARM_ID_REG_WRITABLE to
> >     KVM_CAP_ARM_ID_REG_CONFIGURABLE. [Oliver]
> >   - Add KUnit testing for ID register validation and trap initialization.
> >   - Change read_id_reg() to take care of ID_AA64PFR0_EL1.GIC.
> >   - Add a helper of read_id_reg() (__read_id_reg()) and use the helper
> >     instead of directly using __vcpu_sys_reg().
> >   - Change not to run kvm_id_regs_consistency_check() and
> >     kvm_vcpu_init_traps() for protected VMs.
> >   - Update selftest to remove test cases for ID register consistency.
> >     checking across vCPUs and to add test cases for ID_AA64PFR0_EL1.GIC.
> >
> > v2: https://lore.kernel.org/all/20211103062520.1445832-1-reijiw@google.com/
> >   - Remove unnecessary line breaks. [Andrew]
> >   - Use @params for comments. [Andrew]
> >   - Move arm64_check_features to arch/arm64/kvm/sys_regs.c and
> >     change that KVM specific feature check function.  [Andrew]
> >   - Remove unnecessary raz handling from __set_id_reg. [Andrew]
> >   - Remove sys_val field from the initial id_reg_info and add it
> >     in the later patch. [Andrew]
> >   - Call id_reg->init() from id_reg_info_init(). [Andrew]
> >   - Fix cpuid_feature_cap_perfmon_field() to convert 0xf to 0x0
> >     (and use it in the following patches).
> >   - Change kvm_vcpu_first_run_init to set has_run_once to false
> >     when kvm_id_regs_consistency_check() fails.
> >   - Add a patch to introduce id_reg_info for ID_AA64MMFR0_EL1,
> >     which requires special validity checking for TGran*_2 fields.
> >   - Add patches to introduce id_reg_info for ID_DFR1_EL1 and
> >     ID_MMFR0_EL1, which are required due to arm64_check_features
> >     implementation change.
> >   - Add a new argument, which is a pointer to id_reg_info, for
> >     id_reg_info's validate().
> >
> > v1: https://lore.kernel.org/all/20211012043535.500493-1-reijiw@google.com/
> >
> > [1] https://lore.kernel.org/kvmarm/20211010145636.1950948-1-tabba@google.com/
> > [2] https://lore.kernel.org/kvm/20201102033422.657391-1-liangpeng10@huawei.com/
> > [3] https://lore.kernel.org/all/20220104194918.373612-2-rananta@google.com/
> >
> > Reiji Watanabe (26):
> >   KVM: arm64: Introduce a validation function for an ID register
> >   KVM: arm64: Save ID registers' sanitized value per guest
> >   KVM: arm64: Introduce struct id_reg_info
> >   KVM: arm64: Make ID_AA64PFR0_EL1 writable
> >   KVM: arm64: Make ID_AA64PFR1_EL1 writable
> >   KVM: arm64: Make ID_AA64ISAR0_EL1 writable
> >   KVM: arm64: Make ID_AA64ISAR1_EL1 writable
> >   KVM: arm64: Make ID_AA64MMFR0_EL1 writable
> >   KVM: arm64: Hide IMPLEMENTATION DEFINED PMU support for the guest
> >   KVM: arm64: Make ID_AA64DFR0_EL1 writable
> >   KVM: arm64: Make ID_DFR0_EL1 writable
> >   KVM: arm64: Make MVFR1_EL1 writable
> >   KVM: arm64: Make ID registers without id_reg_info writable
> >   KVM: arm64: Add consistency checking for frac fields of ID registers
> >   KVM: arm64: Introduce KVM_CAP_ARM_ID_REG_CONFIGURABLE capability
> >   KVM: arm64: Add kunit test for ID register validation
> >   KVM: arm64: Use vcpu->arch cptr_el2 to track value of cptr_el2 for VHE
> >   KVM: arm64: Use vcpu->arch.mdcr_el2 to track value of mdcr_el2
> >   KVM: arm64: Introduce framework to trap disabled features
> >   KVM: arm64: Trap disabled features of ID_AA64PFR0_EL1
> >   KVM: arm64: Trap disabled features of ID_AA64PFR1_EL1
> >   KVM: arm64: Trap disabled features of ID_AA64DFR0_EL1
> >   KVM: arm64: Trap disabled features of ID_AA64MMFR1_EL1
> >   KVM: arm64: Trap disabled features of ID_AA64ISAR1_EL1
> >   KVM: arm64: Add kunit test for trap initialization
> >   KVM: arm64: selftests: Introduce id_reg_test
> >
> >  Documentation/virt/kvm/api.rst                |   12 +
> >  arch/arm64/include/asm/cpufeature.h           |    3 +-
> >  arch/arm64/include/asm/kvm_arm.h              |   32 +
> >  arch/arm64/include/asm/kvm_host.h             |   19 +
> >  arch/arm64/include/asm/sysreg.h               |    3 +
> >  arch/arm64/kernel/cpufeature.c                |  228 +++
> >  arch/arm64/kvm/.kunitconfig                   |    4 +
> >  arch/arm64/kvm/Kconfig                        |   11 +
> >  arch/arm64/kvm/arm.c                          |   24 +-
> >  arch/arm64/kvm/debug.c                        |   13 +-
> >  arch/arm64/kvm/hyp/vhe/switch.c               |   14 +-
> >  arch/arm64/kvm/sys_regs.c                     | 1329 +++++++++++++++--
> >  arch/arm64/kvm/sys_regs_test.c                | 1247 ++++++++++++++++
> >  arch/arm64/kvm/vgic/vgic-init.c               |    5 +
> >  include/uapi/linux/kvm.h                      |    1 +
> >  tools/arch/arm64/include/asm/sysreg.h         |    1 +
> >  tools/testing/selftests/kvm/.gitignore        |    1 +
> >  tools/testing/selftests/kvm/Makefile          |    1 +
> >  .../selftests/kvm/aarch64/id_reg_test.c       | 1239 +++++++++++++++
> >  19 files changed, 4041 insertions(+), 146 deletions(-)
> >  create mode 100644 arch/arm64/kvm/.kunitconfig
> >  create mode 100644 arch/arm64/kvm/sys_regs_test.c
> >  create mode 100644 tools/testing/selftests/kvm/aarch64/id_reg_test.c
> >
> >
> > base-commit: d399b107ee49bf5ea0391bd7614d512809e927b0
> > --
> > 2.34.1.448.ga2b2bfdf31-goog
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
