Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98368758212
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 18:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjGRQ1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 12:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjGRQ1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 12:27:47 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5056EB5
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 09:27:46 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1b00b0ab0daso4904412fac.0
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 09:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689697664; x=1692289664;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oWlwv/U9S1uPk7gi1HJNQOKMPltkS5/fG+7ZDpzLoHs=;
        b=Ewi7b+ppPTIxEZSoUMpcT21kwifB5POXh/af+BMmaNa5vsF4Sg+sRwExq6/4GSjYjg
         aDS/SLA8Zph7Ath0h2dVzY/UUCM5UtrrIYvRzTh/dmt5lbqfMC844P3WuqB/9nLoNwnq
         yAg5kUreRPe9F/Fd7pJsDkCxlL2EXL8yDxRb3fQC/kLCayISQU8YJ89wA4kp0bSRprSX
         Ra6zTWVxiGUTDUWP/3ywDu8xt0aSS738IuWVJFAdtZgJ7IpkZ+o1Lp2rfOZeNASCiLm7
         4/570FKYyjQnSQoKeu0VVIxnCmFKPW72+08qJEavbns3gc+HHXlf49piUV1cv9YlRa/X
         +v8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689697664; x=1692289664;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oWlwv/U9S1uPk7gi1HJNQOKMPltkS5/fG+7ZDpzLoHs=;
        b=ELTm/xra/CL6/4jHxNaNSYRTh7R6ldwup6xSgkqJRNM98CKRmtlH0pWPLkpJ03AUV/
         yrBeUSB2X5P9yQC8h+75ZwUWwfcxan3h34mDgnLjkEnAJHx5jCzl/OIAmK0bsFX5gWgO
         nXSpTDf3d8vqnrvATjYUvfSCttGrfAWyEb0aupI8qvSXb7zGi/afFV96opg2JEOTJVHW
         5mdmVtnLHoQAXRH+2gWwGJFib8qt/68rWu6wxmn5LJbYtyyJqWV0ya8tHtUYlINpSGKK
         59qRAzG+7qhhXP4hRtn39FblYKG5zPJBGhElypIrtMxyk7hSysoTMB+e2nQbltfSRhgX
         toxQ==
X-Gm-Message-State: ABy/qLYP7n1scBYzUUXbpB43CBBPcP4DmBS0skGNMuPnklVYWeom3vZB
        AZ9U88YMlf61boQ9O8zhMWLQV6Ugv4o4vfFvEzkDGsjWrXJbfRkC3+g=
X-Google-Smtp-Source: APBJJlGGpAz9ramES8rNPXckQWwcrcqj9pkNcpQXqm8XkwxA609uSTSSLmlrB0vF4cPU7vEFeGUPOsqFTvo5aG395kw=
X-Received: by 2002:a05:6870:d20c:b0:19f:2c0e:f865 with SMTP id
 g12-20020a056870d20c00b0019f2c0ef865mr19458493oac.7.1689697664389; Tue, 18
 Jul 2023 09:27:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230717152722.1837864-1-jingzhangos@google.com>
In-Reply-To: <20230717152722.1837864-1-jingzhangos@google.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 18 Jul 2023 09:27:32 -0700
Message-ID: <CAAdAUtiap4sxFT3B7hzT4THbJTO9Hs66O9DFJHF+2cpmq06Czg@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] Enable writable for idregs DFR0,PFR0, MMFR{0,1,2, 3}
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please ignore this post of v6 which missed a commit. I'll send out the
correct v6 soon.

Thanks,
Jing

On Mon, Jul 17, 2023 at 8:27=E2=80=AFAM Jing Zhang <jingzhangos@google.com>=
 wrote:
>
> This patch series enable userspace writable for below idregs:
> ID_AA64DFR0_EL1, ID_DFR0_EL1, ID_AA64PFR0_EL1, ID_AA64MMFR{0, 1, 2, 3}_EL=
1.
>
> It is based on v6.5-rc1 which contains infrastructure for writable idregs=
.
>
> A selftest is added to verify that KVM handles the writings from user spa=
ce
> correctly.
>
> A relevant patch from Oliver is picked from [3].
>
> ---
>
> * v5 -> v6
>   - Override the type of field AA64DFR0_EL1_DebugVer to be FTR_LOWER_SAFE=
 by the
>     discussion of Oliver and Suraj.
>
> * v4 -> v5
>   - Rebase on v6.4-rc1 which contains infrastructure for writable idregs.
>   - Use guest ID registers values for the sake of emulation.
>   - Added a selftest to verify idreg userspace writing.
>
> * v3 -> v4
>   - Rebase on v11 of writable idregs series at [2].
>
> * v2 -> v3
>   - Rebase on v6 of writable idregs series.
>   - Enable writable for ID_AA64PFR0_EL1 and ID_AA64MMFR{0, 1, 2}_EL1.
>
> * v1 -> v2
>   - Rebase on latest patch series [1] of enabling writable ID register.
>
> [1] https://lore.kernel.org/all/20230402183735.3011540-1-jingzhangos@goog=
le.com
> [2] https://lore.kernel.org/all/20230602005118.2899664-1-jingzhangos@goog=
le.com
> [3] https://lore.kernel.org/kvmarm/20230623205232.2837077-1-oliver.upton@=
linux.dev
>
> [v1] https://lore.kernel.org/all/20230326011950.405749-1-jingzhangos@goog=
le.com
> [v2] https://lore.kernel.org/all/20230403003723.3199828-1-jingzhangos@goo=
gle.com
> [v3] https://lore.kernel.org/all/20230405172146.297208-1-jingzhangos@goog=
le.com
> [v4] https://lore.kernel.org/all/20230607194554.87359-1-jingzhangos@googl=
e.com
> [v5] https://lore.kernel.org/all/20230710192430.1992246-1-jingzhangos@goo=
gle.com
>
> ---
>
> Jing Zhang (4):
>   KVM: arm64: Use guest ID register values for the sake of emulation
>   KVM: arm64: Enable writable for ID_AA64PFR0_EL1
>   KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2, 3}_EL1
>   KVM: arm64: selftests: Test for setting ID register from usersapce
>
> Oliver Upton (1):
>   KVM: arm64: Reject attempts to set invalid debug arch version
>
>  arch/arm64/kvm/sys_regs.c                     |  80 +++++++--
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/aarch64/set_id_regs.c       | 163 ++++++++++++++++++
>  3 files changed, 230 insertions(+), 14 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c
>
>
> base-commit: 06c2afb862f9da8dc5efa4b6076a0e48c3fbaaa5
> --
> 2.41.0.255.g8b1d071c50-goog
>
