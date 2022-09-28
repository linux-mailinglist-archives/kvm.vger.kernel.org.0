Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C615ED85C
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 11:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbiI1JAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 05:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232810AbiI1JAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 05:00:17 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662B952459
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 02:00:15 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id f20so16381746edf.6
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 02:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=NU8AnBmeIJ14DL2Qui9ejktTv9V8UArK0D6jisVgbJ4=;
        b=YZDHwjfe/nIfDR6Yl2r1y6lpAxRaXJ9wmvbPPqd9/uAd4qbYlOywgif1IG1UBkRGLe
         u+Y9D3+evXzlHdi6k0yLtS2+9uA/B8+c0WtUfIsyAz55/7kSPciFXnkmzPgGroz68EBG
         2mExn2cNnG4PtHbAWw0OHwX0jwUVmBkVzrrxUhtGGNiQcwCkpxHN5AHGLvNqTiY9PNRB
         JWmu37EQe5eXYu3fxnRsue3pikle50T9wh6le9ZQ3nGo6A/lZrX1y2MFvFk9Hs15O4Vc
         fMOP76OWeQKouO25jt6HyoqDeamKfAVVnB9JUNEEa8aJc0Xj+KFUKbHEjMGvpeP0TUto
         XiRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=NU8AnBmeIJ14DL2Qui9ejktTv9V8UArK0D6jisVgbJ4=;
        b=KPoJ32jcwn72ium1z1se4xOpGU1jVdf4EyWcpr5eLhsOVvhA5NacJ/cfwjBRPudx/3
         ezGBys/b4C+nlBrwyxy8axWDylT8Bcc7uk7A5IL7W4JDitWQnYdkVTofZp6PlISN5y2H
         6+vRxJ9R0FnU8r+D5GnA4Nz1bs0HUk/CED1Z1MFuJiaLfQVHt6MI3fiBwX/HvxZJ8gfi
         5iQelfzkrmuxTTjsnXSSd8bpaNouj3eJNf1hRVOa8pNVJtDqhuylxRaasKvS32SMNi2J
         QhaGjJEhJlotHEhE4NH9J18D84aGI2vpwBQv7pWlwT8+QHpwbe05X7u/qoeBH8iWeRJC
         2uFg==
X-Gm-Message-State: ACrzQf1cWbqbYcRrjEo+OrhKe3unVerEpqml+pQ5iSHAsVaP/0A2VoQQ
        W9rJSFjvlEOHCxS5iGDUq3GFsQ==
X-Google-Smtp-Source: AMsMyM4AM0H2JjuolWc3Vb/e4g+zQuzzdWHddwXH4HqsIucpwPrNhAY0yhcPuMmHqLBu5MQuGkd8Eg==
X-Received: by 2002:a05:6402:428c:b0:440:8259:7a2b with SMTP id g12-20020a056402428c00b0044082597a2bmr30988999edc.329.1664355613957;
        Wed, 28 Sep 2022 02:00:13 -0700 (PDT)
Received: from localhost (cst2-173-61.cust.vodafone.cz. [31.30.173.61])
        by smtp.gmail.com with ESMTPSA id a8-20020aa7cf08000000b00456ff7d4283sm2992126edy.5.2022.09.28.02.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 02:00:13 -0700 (PDT)
Date:   Wed, 28 Sep 2022 11:00:12 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v3 0/3] riscv: kvm: use generic entry for
 TIF_NOTIFY_RESUME and misc
Message-ID: <20220928090012.gjh3ftvkpus5df63@kamzik>
References: <20220925162400.1606-1-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220925162400.1606-1-jszhang@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 26, 2022 at 12:23:57AM +0800, Jisheng Zhang wrote:
> This series is a preparation series to add PREEMPT_RT support to riscv:
> patch1 adds the missing number of signal exits in vCPU stat
> patch2 switches to the generic guest entry infrastructure
> patch3 select HAVE_POSIX_CPU_TIMERS_TASK_WORK which is a requirement for
> RT
> 
> After these three patches merged, the left RT patches are similar as
> other arch.
> 
> Since v2:
>   - splict the series into two separate ones, one for next another for
>     RT.
> 
> Since v1:
>   - send to related maillist, I press ENTER too quickly when sending v1
>   - remove the signal_pending() handling because that's covered by
>     generic guest entry infrastructure
> 
> Jisheng Zhang (3):
>   RISC-V: KVM: Record number of signal exits as a vCPU stat
>   RISC-V: KVM: Use generic guest entry infrastructure
>   riscv: select HAVE_POSIX_CPU_TIMERS_TASK_WORK
> 
>  arch/riscv/Kconfig                |  1 +
>  arch/riscv/include/asm/kvm_host.h |  1 +
>  arch/riscv/kvm/Kconfig            |  1 +
>  arch/riscv/kvm/vcpu.c             | 18 +++++++-----------
>  4 files changed, 10 insertions(+), 11 deletions(-)
> 
> -- 
> 2.34.1
>

For the series

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
