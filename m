Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC3879FD49
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 09:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjINHdR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 03:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235462AbjINHdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 03:33:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 081E7F3
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 00:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694676742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zeXUZmzA2R78d6Tnnb+ykDeaJ41fYcPMQRTIom5IJuI=;
        b=cFb6vDL+ApN7noAzsa7WIFLy2qbIRvBWUfrDzh1FmYQrfOVDDpjedAII5vV6Lm5w1gxgCP
        qVm1Lwv2/hr4rBW3lPSuxcARMgOaSgJGEsunwBClS+zkkjrOicWjfxHzTtkC+PShKHo9pq
        zCkTvHDuxfueKey00mnDfP9gU3Pfq+s=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-LiJcd-s8PlGvGMBTafvEVA-1; Thu, 14 Sep 2023 03:32:20 -0400
X-MC-Unique: LiJcd-s8PlGvGMBTafvEVA-1
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-6bc4dfb93cbso932166a34.1
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 00:32:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694676740; x=1695281540;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zeXUZmzA2R78d6Tnnb+ykDeaJ41fYcPMQRTIom5IJuI=;
        b=OkhcZUjxpJBRWzclsspg8/iCeaE09OB3tvu0k+THIsR7yZ3dVROFIEkvDwuj48R1o6
         NGGWEeK6Q05HYeXGSPHbMMWIq6XrvTaM1XNl15kqQjnoWvYMmcDEszOaoXxz1rAraBa6
         ZCRjjtFKcsTyD6gm/0lBsjM8wg4SC4RRWWcRFj0VZP2CM0/+2ZeezmT4qCGK1iAtXJNZ
         CkmzWDmKFvEJGaRuT5TnjsA4xbu5tlU/k7EcMrm1MJsTSeN+nVS5GEAYCMwzafQ5OREa
         3po4M2GMg/4Y9jGe6BLa8C/5+6NBIAW55a3EqqNObGDJP5xpQKM34AEsSdlTzgNY8Gl8
         PLZQ==
X-Gm-Message-State: AOJu0YynIbZ2v9Pg7LT26GTC93OpQWTLeThJi2LY19U4Fy8+Mj8xWlIV
        Imqzp9Gi2VfyOO5W99SalBOou/YsCNXDbpmz7IOoKWC3ZoLpQhNPRoGT/iu5ZC2N//kue+2UVFQ
        XHhbZx5muuUEP
X-Received: by 2002:a9d:7748:0:b0:6b7:6e07:4951 with SMTP id t8-20020a9d7748000000b006b76e074951mr5156985otl.25.1694676740039;
        Thu, 14 Sep 2023 00:32:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEr6lIrxX3lHcIWXsLn8H+SAhlSeGClLIiE+FDMDpEhnhKKTf67DlStq8kfOI9KIS1JIF/G5A==
X-Received: by 2002:a9d:7748:0:b0:6b7:6e07:4951 with SMTP id t8-20020a9d7748000000b006b76e074951mr5156960otl.25.1694676739790;
        Thu, 14 Sep 2023 00:32:19 -0700 (PDT)
Received: from redhat.com ([2804:1b3:a803:4ff9:7c29:fe41:6aa7:43df])
        by smtp.gmail.com with ESMTPSA id v25-20020a9d69d9000000b006b83a36c08bsm421777oto.53.2023.09.14.00.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 00:32:19 -0700 (PDT)
Date:   Thu, 14 Sep 2023 04:32:08 -0300
From:   Leonardo Bras <leobras@redhat.com>
To:     Guo Ren <guoren@kernel.org>
Cc:     Waiman Long <longman@redhat.com>, paul.walmsley@sifive.com,
        anup@brainfault.org, peterz@infradead.org, mingo@redhat.com,
        will@kernel.org, palmer@rivosinc.com, boqun.feng@gmail.com,
        tglx@linutronix.de, paulmck@kernel.org, rostedt@goodmis.org,
        rdunlap@infradead.org, catalin.marinas@arm.com,
        conor.dooley@microchip.com, xiaoguang.xing@sophgo.com,
        bjorn@rivosinc.com, alexghiti@rivosinc.com, keescook@chromium.org,
        greentime.hu@sifive.com, ajones@ventanamicro.com,
        jszhang@kernel.org, wefu@redhat.com, wuwei2016@iscas.ac.cn,
        linux-arch@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-csky@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>
Subject: Re: [PATCH V11 07/17] riscv: qspinlock: Introduce qspinlock param
 for command line
Message-ID: <ZQK2-CIL9U_QdMjh@redhat.com>
References: <20230910082911.3378782-1-guoren@kernel.org>
 <20230910082911.3378782-8-guoren@kernel.org>
 <5ba0b8f3-f8f5-3a25-e9b7-f29a1abe654a@redhat.com>
 <CAJF2gTT2hRxgnQt+WJ9P0YBWnUaZJ1-9g3ZE9tOz_MiLSsUjwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJF2gTT2hRxgnQt+WJ9P0YBWnUaZJ1-9g3ZE9tOz_MiLSsUjwQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 12, 2023 at 09:08:34AM +0800, Guo Ren wrote:
> On Mon, Sep 11, 2023 at 11:34 PM Waiman Long <longman@redhat.com> wrote:
> >
> > On 9/10/23 04:29, guoren@kernel.org wrote:
> > > From: Guo Ren <guoren@linux.alibaba.com>
> > >
> > > Allow cmdline to force the kernel to use queued_spinlock when
> > > CONFIG_RISCV_COMBO_SPINLOCKS=y.
> > >
> > > Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> > > Signed-off-by: Guo Ren <guoren@kernel.org>
> > > ---
> > >   Documentation/admin-guide/kernel-parameters.txt |  2 ++
> > >   arch/riscv/kernel/setup.c                       | 16 +++++++++++++++-
> > >   2 files changed, 17 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > > index 7dfb540c4f6c..61cacb8dfd0e 100644
> > > --- a/Documentation/admin-guide/kernel-parameters.txt
> > > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > > @@ -4693,6 +4693,8 @@
> > >                       [KNL] Number of legacy pty's. Overwrites compiled-in
> > >                       default number.
> > >
> > > +     qspinlock       [RISCV] Force to use qspinlock or auto-detect spinlock.
> > > +
> > >       qspinlock.numa_spinlock_threshold_ns=   [NUMA, PV_OPS]
> > >                       Set the time threshold in nanoseconds for the
> > >                       number of intra-node lock hand-offs before the
> > > diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
> > > index a447cf360a18..0f084f037651 100644
> > > --- a/arch/riscv/kernel/setup.c
> > > +++ b/arch/riscv/kernel/setup.c
> > > @@ -270,6 +270,15 @@ static void __init parse_dtb(void)
> > >   }
> > >
> > >   #ifdef CONFIG_RISCV_COMBO_SPINLOCKS
> > > +bool enable_qspinlock_key = false;
> >
> > You can use __ro_after_init qualifier for enable_qspinlock_key. BTW,
> > this is not a static key, just a simple flag. So what is the point of
> > the _key suffix?
> Okay, I would change it to:
> bool enable_qspinlock_flag __ro_after_init = false;

IIUC, this bool / flag is used in a single file, so it makes sense for it 
to be static. Being static means it does not need to be initialized to 
false, as it's standard to zero-fill this areas.

Also, since it's a bool, it does not need to be called _flag.

I would go with:

static bool enable_qspinlock __ro_after_init;


> 
> >
> > Cheers,
> > Longman
> >
> 
> 
> -- 
> Best Regards
>  Guo Ren
> 

