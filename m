Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15CFB5ED42D
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 07:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbiI1FST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 01:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbiI1FSS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 01:18:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E105125DA4;
        Tue, 27 Sep 2022 22:18:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B0A9B81F0A;
        Wed, 28 Sep 2022 05:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD1DC433C1;
        Wed, 28 Sep 2022 05:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664342294;
        bh=5DT/64IMZuLUf3bLjAXjRk8ANx+zPNw/RU/6k9PgsEI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=UnWv777f/Prr6ArHM7X0s8ysdAf6JtcyvjzTNeP6WF4/SeZgT0YqsZ2w3l/P305md
         +9AYasjjE/nfGEunG1CZrHcDpWQ7Gn/bjD7entT4vflpqOC5Z+bwJpnIasI7WMPk2/
         wrdBTjTiwF0KJSsoy0pGXtFY35n5jNJEj+XByytq2Frwxtbb7mo3DrgnBXAY+lJedx
         Uzji/auSIaq2AIM96/Ayyaj5Zorx3k6ZdcWObG/XBZt8+1gtZn5QiaLu+DTSaGlkbx
         1DbUzqASq0kxpSCmXs1QH43SiRMU8jAmfXV/P7Twydg0AG9jnrKlNqETRkAEadmDCe
         l97ZflVsF7HEQ==
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-1280590722dso16006031fac.1;
        Tue, 27 Sep 2022 22:18:14 -0700 (PDT)
X-Gm-Message-State: ACrzQf3t2niMTHZv4BuLf1UKbobu6tLiGRI0j7tQXbRkxUwVcz1V0LTf
        cZv7125iZGH230cwO5oxCfOwnEokF932r1cb7eg=
X-Google-Smtp-Source: AMsMyM5GSVNd2f83vHIh/hPg2DnFINuapn47E77DPLXPMrUPF4ddplCTXJHsTyIzOXryyZpiPMMe1L6pEq8/FDU8J9I=
X-Received: by 2002:a05:6870:5803:b0:12c:c3e0:99dc with SMTP id
 r3-20020a056870580300b0012cc3e099dcmr4211405oap.19.1664342294051; Tue, 27 Sep
 2022 22:18:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220925162400.1606-1-jszhang@kernel.org> <20220925162400.1606-2-jszhang@kernel.org>
In-Reply-To: <20220925162400.1606-2-jszhang@kernel.org>
From:   Guo Ren <guoren@kernel.org>
Date:   Wed, 28 Sep 2022 13:18:01 +0800
X-Gmail-Original-Message-ID: <CAJF2gTRSb4f9rF_sTZ2hr9iOnvLYcQYu3CN7q8PCZQg4HvC_Gg@mail.gmail.com>
Message-ID: <CAJF2gTRSb4f9rF_sTZ2hr9iOnvLYcQYu3CN7q8PCZQg4HvC_Gg@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] RISC-V: KVM: Record number of signal exits as a
 vCPU stat
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Guo Ren <guoren@kernel.org>

=E2=9E=9C  linux git:(master) grep signal_exits arch/arm64 -r
arch/arm64/kvm/guest.c: STATS_DESC_COUNTER(VCPU, signal_exits),
arch/arm64/include/asm/kvm_host.h:      u64 signal_exits;

By the way, do you know why arm64 is defined, but not used?


On Mon, Sep 26, 2022 at 12:33 AM Jisheng Zhang <jszhang@kernel.org> wrote:
>
> Record a statistic indicating the number of times a vCPU has exited
> due to a pending signal.
>
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> ---
>  arch/riscv/include/asm/kvm_host.h | 1 +
>  arch/riscv/kvm/vcpu.c             | 2 ++
>  2 files changed, 3 insertions(+)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/k=
vm_host.h
> index 60c517e4d576..dbbf43d52623 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -67,6 +67,7 @@ struct kvm_vcpu_stat {
>         u64 mmio_exit_kernel;
>         u64 csr_exit_user;
>         u64 csr_exit_kernel;
> +       u64 signal_exits;
>         u64 exits;
>  };
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index d0f08d5b4282..3da459fedc28 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -28,6 +28,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] =3D =
{
>         STATS_DESC_COUNTER(VCPU, mmio_exit_kernel),
>         STATS_DESC_COUNTER(VCPU, csr_exit_user),
>         STATS_DESC_COUNTER(VCPU, csr_exit_kernel),
> +       STATS_DESC_COUNTER(VCPU, signal_exits),
>         STATS_DESC_COUNTER(VCPU, exits)
>  };
>
> @@ -973,6 +974,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>                 if (signal_pending(current)) {
>                         ret =3D -EINTR;
>                         run->exit_reason =3D KVM_EXIT_INTR;
> +                       ++vcpu->stat.signal_exits;
>                 }
>
>                 /*
> --
> 2.34.1
>


--
Best Regards
 Guo Ren
