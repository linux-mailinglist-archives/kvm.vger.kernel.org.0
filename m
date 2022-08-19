Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1795A5998ED
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 11:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347300AbiHSJoV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 05:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347149AbiHSJoS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 05:44:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635EA4AD63
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 02:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660902256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c1EVd0DFqKV0OYu8jHYuazH3XovyEoXq9DF8Sjm/ItA=;
        b=MbUSIC3sOtsNvlYWZ8hOCfpH0I8VyFBj+0JqC23SiVA0GIyuofq2JZVXLP6qB7sR/fT6Wc
        DQuZSRVHoIW/fd1Vmk6lHEZPX9rVQO0XHQI+urQqtnx+2QxE1xlPcrX07pJBK53jAwoeJE
        YB4gFdv5bV/kaRTHRo8gLaucbL3ffbs=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-620-RhHruhFHPeW9XxDOetmLnQ-1; Fri, 19 Aug 2022 05:44:13 -0400
X-MC-Unique: RhHruhFHPeW9XxDOetmLnQ-1
Received: by mail-lf1-f72.google.com with SMTP id p36-20020a05651213a400b004779d806c13so1257595lfa.10
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 02:44:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=c1EVd0DFqKV0OYu8jHYuazH3XovyEoXq9DF8Sjm/ItA=;
        b=q61/6eSvlA96lyZKyRfeVFDjN0qBxVpGUAV9DudSON/deBw5JXHe8bHeEJ5d/MTlCF
         1eVmy/75EcAVkIKNWozSy01c27d+0A+2iCfZWGYTw4nozoG1Nz+9xPA39D367B1l/nw/
         r8MBU1jUFLFmcZc8tAV3vMQli392AKfPZfbvDY8IJxNgOQZkqg+wCg+pmzCf6/itiLYG
         RH+zetJw7EGFy43hYSItUO+uFCmhK1rzSCrK8xw1cArjz+F6v20HY9Bg9zo7mIK2oX/Y
         D8Xn9hY/dmk72KYIMk0dZ0umtgxA9eqLFaT5dxO16cAg4jahu1MDKqkmqmNzxvbvD5WA
         H2Lw==
X-Gm-Message-State: ACgBeo09LHHaILRc+x6F4OLEDQl/xT1VjbNuemTNp6aGYCUi/hBfK+og
        uXEtxxFqskD+h3W66Copdy6hqThUXVd9nlVfvo6nYFa5x1gKr6wIKhu2Bj6BAmo64n5xJl5M3Gt
        qQeyhy5vpLbjNvzgKtA97Sk2x1zWw
X-Received: by 2002:a2e:a98b:0:b0:25f:d9e9:588d with SMTP id x11-20020a2ea98b000000b0025fd9e9588dmr1993606ljq.205.1660902251901;
        Fri, 19 Aug 2022 02:44:11 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5OG8h2APd6wlol2n03VyKpahOJJDriZrSFHpdhhHl4YapoZP5eP/Gj/YrjIbyqXVoog9BENLVnLWqv7Zaqqb8=
X-Received: by 2002:a2e:a98b:0:b0:25f:d9e9:588d with SMTP id
 x11-20020a2ea98b000000b0025fd9e9588dmr1993594ljq.205.1660902251667; Fri, 19
 Aug 2022 02:44:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220818140844.2312534-1-maz@kernel.org>
In-Reply-To: <20220818140844.2312534-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 19 Aug 2022 11:44:00 +0200
Message-ID: <CABgObfY-sJug_UG8rp4nDOuDEpLvjEQFU1EROT72oO=0GZR67Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.0, take #1
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Yang Yingliang <yangyingliang@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pulled, thanks.

Paolo

On Thu, Aug 18, 2022 at 4:09 PM Marc Zyngier <maz@kernel.org> wrote:
>
> Paolo,
>
> Here's a small set of KVM/arm64 fixes for 6.0, the most visible thing
> being a better handling of systems with asymmetric AArch32 support.
>
> Please pull,
>
>         M.
>
> The following changes since commit 0982c8d859f8f7022b9fd44d421c7ec721bb41f9:
>
>   Merge branch kvm-arm64/nvhe-stacktrace into kvmarm-master/next (2022-07-27 18:33:27 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.0-1
>
> for you to fetch changes up to b10d86fb8e46cc812171728bcd326df2f34e9ed5:
>
>   KVM: arm64: Reject 32bit user PSTATE on asymmetric systems (2022-08-17 10:29:07 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.0, take #1
>
> - Fix unexpected sign extension of KVM_ARM_DEVICE_ID_MASK
>
> - Tidy-up handling of AArch32 on asymmetric systems
>
> ----------------------------------------------------------------
> Oliver Upton (2):
>       KVM: arm64: Treat PMCR_EL1.LC as RES1 on asymmetric systems
>       KVM: arm64: Reject 32bit user PSTATE on asymmetric systems
>
> Yang Yingliang (1):
>       KVM: arm64: Fix compile error due to sign extension
>
>  arch/arm64/include/asm/kvm_host.h | 4 ++++
>  arch/arm64/include/uapi/asm/kvm.h | 6 ++++--
>  arch/arm64/kvm/arm.c              | 3 +--
>  arch/arm64/kvm/guest.c            | 2 +-
>  arch/arm64/kvm/sys_regs.c         | 4 ++--
>  5 files changed, 12 insertions(+), 7 deletions(-)
>

