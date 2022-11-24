Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13946376D1
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 11:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiKXKvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 05:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiKXKu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 05:50:57 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973C5179A8D
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 02:50:54 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id vp12so1985348ejc.8
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 02:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7EpHqZSb89Ze6YQ2yo72O8+0pB4IQzPJGKW2B32FbcY=;
        b=Pk8qWjYgThmkUH55ahwT7r++QkroUX2mKPPGCB42y6xGyBk7NGPZEyJyTGUbo2V93l
         JTvGPrRRG29bpeUV8227yH/wQ++vwqMTyYmcg0atcAcfp9+0aaC4W9a3uV9b1FAMan1c
         PNG72cPrt8etKQ8upv4zZu9f+apnL3mx1jbIiK6Dy0yVm4HQaz2jY8vfWzgmJWF+OvNu
         5lbhAP6N0mcfXspdTYpvMrdcCNe5Sk6ka7+E9lW+0Q8Uh9xpYOoBEemceeDJEPasWqpg
         eApbOaHuKFvcXXqFCC1lCuwGuKcMa4MZ/6fYlycda8Nh7S0gpX1LP6TkCsxAfzl/4497
         GMWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7EpHqZSb89Ze6YQ2yo72O8+0pB4IQzPJGKW2B32FbcY=;
        b=K3TF8b5j3FEPTeNEvu58GU/DTTbm06BJ6roFO/iwffwMUDne9xrxAToNPo4+m3xoON
         KnW7fZ+98iOqNG4kBRZ2JhhNyInjW45feJkjVGMnn4pKIE9n9HkG40AOa4F3PwYFQfJR
         UbW4FGKajsWybDo3WHVJ/B5iSZZO8v4Cphgx1DIkrqyIxboHebmJRUSSZwyqMzng78Nx
         4wbrISKlmuYkJ6YWRKmL9DCyy1p/ziahk2bWPItpK4DY/Ep+rTikb9EKZVsQXh0xRn9T
         N8J23RJMOukbFJL6yOumySl4L3DsYsj3q9fgLaP3CMMrZZXTcM0S1ogd9p+4fUn01ibF
         Sjzg==
X-Gm-Message-State: ANoB5pmse8UJvY6uRcfih9uGSPteWNroPmxrJCCHdZKYswuzrMjGSr7K
        2+90R3SzS74N+oj5DRabSdDQ8w==
X-Google-Smtp-Source: AA0mqf4C7a8msWcEL+e4aUXZWxwRSJFXJSxQmq0StXpEkqceLuWKrbz0d7MQc7OQXqOX4aChnNPp6w==
X-Received: by 2002:a17:907:c20d:b0:7b8:882d:43fc with SMTP id ti13-20020a170907c20d00b007b8882d43fcmr10034499ejc.0.1669287053134;
        Thu, 24 Nov 2022 02:50:53 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id f15-20020a50fc8f000000b00462e1d8e914sm365978edq.68.2022.11.24.02.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 02:50:52 -0800 (PST)
Date:   Thu, 24 Nov 2022 11:50:51 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@atishpatra.org>
Cc:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>, Guo Ren <guoren@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [RFC 6/9] RISC-V: KVM: Add SBI PMU extension support
Message-ID: <20221124105051.hbsavj3bgf4mvlzb@kamzik>
References: <20220718170205.2972215-1-atishp@rivosinc.com>
 <20220718170205.2972215-7-atishp@rivosinc.com>
 <20221101142631.du54p4kyhlgf54cr@kamzik>
 <CAOnJCUJfakcoiWh4vFk5_BcTKfoSDbx+wtmh7MW4cPYog7q4BQ@mail.gmail.com>
 <20221123135842.uyw46kbybgb7unm2@kamzik>
 <CAOnJCUKZV+0Xts6C4QY7X+Wak0ZR_f8wPtEAtH4PEmh2-_AcWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOnJCUKZV+0Xts6C4QY7X+Wak0ZR_f8wPtEAtH4PEmh2-_AcWw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 24, 2022 at 02:18:26AM -0800, Atish Patra wrote:
> On Wed, Nov 23, 2022 at 5:58 AM Andrew Jones <ajones@ventanamicro.com> wrote:
> >
> > On Tue, Nov 22, 2022 at 03:08:34PM -0800, Atish Patra wrote:
...
> > > Currently, ARM64 enables pmu from user space using device control APIs
> > > on vcpu fd.
> > > Are you suggesting we should do something like that ?
> >
> > Yes. Although choosing which KVM API should be used could probably be
> > thought-out again. x86 uses VM ioctls.
> >
> 
> How does it handle hetergenous systems in per VM ioctls ?

I don't think it does, but neither does arm64. Afaik, the only way to run
KVM VMs on heterogeneous systems is to pin the VM to one set of the CPUs,
i.e. make sure the system it runs on is homogeneous.

I agree we shouldn't paint ourselves into a homogeneous-only corner for
riscv, though, so if it's possible to use VCPU APIs, then I guess we
should. Although, one thing to keep in mind is that if the same ioctl
needs to be run on each VCPU, then, when we start building VMs with
hundreds of VCPUs, we'll see slow VM starts.

> 
> > >
> > > If PMU needs to have device control APIs (either via vcpu fd or its
> > > own), we can retrieve
> > > the hpmcounter width and count from there as well.
> >
> > Right. We need to decide how the VM/VCPU + PMU user interface should look.
> > A separate PMU device, like arm64 has, sounds good, but the ioctl
> > sequences for initialization may get more tricky.
> >
> 
> Do we really need a per VM interface ? I was thinking we can just
> continue to use
> one reg interface for PMU as well. We probably need two of them.
> 
> 1. To enable/disable SBI extension
>     -- The probe function will depend on this
> 2. PMU specific get/set
>     -- Number of hpmcounters
>     -- hpmcounter width
>     -- enable PMU

ONE_REG is good for registers and virtual registers, which means the
number of hpmcounters and the hpmcounter width are probably good
candidates, but I'm not sure we should use it for enable/init types of
purposes.

Thanks,
drew
