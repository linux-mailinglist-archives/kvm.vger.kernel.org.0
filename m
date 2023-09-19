Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47FF27A598B
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 07:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbjISFqj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 01:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjISFqg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 01:46:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFB5186
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 22:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695102350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HiVEPo5eeRXHXivfzlf4pcDpdl4skr74vqWMfN6Le04=;
        b=QjFMctCMTih3hJhzVi1Te3He754jLHbNGUQMTw5DQjGRyJhZeib5pJeJiZoKtqUwQZ2Wv8
        mqQYHT/AENZxjqfCcHL3lZ/KGDGRmCI+n83Q5O1L8bA5hitNKnq6jr0v4Th8GW0OcEEbha
        9efbmp+0rRrTHvtbI3Bv1vI97kIOPsg=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-ljR33sqRMf-RRsGyxomWRA-1; Tue, 19 Sep 2023 01:45:48 -0400
X-MC-Unique: ljR33sqRMf-RRsGyxomWRA-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-1d6cf10016cso3605321fac.1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 22:45:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695102348; x=1695707148;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HiVEPo5eeRXHXivfzlf4pcDpdl4skr74vqWMfN6Le04=;
        b=au5z3KJTnv+eQPrFVOYO2pKnF/5zs2Jcrjy9Nu9gZimSHdFKndmdRy1sTvgmDZcmcy
         A9F2kTShuLtyBXyQhYNe7v2TW1G0iXMu/3eLSOd4gfoA4XXxrlJOKIIpysheu3o2oX4w
         8EQAV+WQKdy4LBcpJB5Tz+YNsqbkXTAxJ7XwASxeFCxS/w7M6P6dkJQqRNuqoQZPwm1z
         HG8PO6mBk5dSoAUApBjg9yk7wXjRss+6jxbul3io43Gl1HlNFBhUfeyGMhZDlOactRAx
         0meJV7tCHtggkDFGGdv+l0FOnI+fMBrmJ2e/UlqP7K/rin2rr61jHZFDLmzDxt0RmeYK
         duAA==
X-Gm-Message-State: AOJu0YzFNrHlegNxQ/QnmHShBf6wJTKtxephtOIyWy77B6qaHEyFQQxL
        aqPwuXZHHYnSGdvGOxbDPBxBTEiml6thq/c3LRB5j4BC+aoDAp0H/9Zz0crqzSuSXOawBu69HeG
        FYG2WE/YekDHA
X-Received: by 2002:a05:6870:5690:b0:1bb:83e9:6277 with SMTP id p16-20020a056870569000b001bb83e96277mr13486629oao.33.1695102348006;
        Mon, 18 Sep 2023 22:45:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHA7fVjpU09v/Q+0JN+fs3b+WtouB3O3IFXrPr3jgLPWef/tjcxoKLI0bNZO/4778Pfmzj0VA==
X-Received: by 2002:a05:6870:5690:b0:1bb:83e9:6277 with SMTP id p16-20020a056870569000b001bb83e96277mr13486603oao.33.1695102347774;
        Mon, 18 Sep 2023 22:45:47 -0700 (PDT)
Received: from redhat.com ([2804:1b3:a803:677d:42e9:f426:9422:f020])
        by smtp.gmail.com with ESMTPSA id cc6-20020a056871e18600b001b3d67934e9sm5733332oac.26.2023.09.18.22.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 22:45:47 -0700 (PDT)
Date:   Tue, 19 Sep 2023 02:45:37 -0300
From:   Leonardo Bras <leobras@redhat.com>
To:     Guo Ren <guoren@kernel.org>
Cc:     paul.walmsley@sifive.com, anup@brainfault.org,
        peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        palmer@rivosinc.com, longman@redhat.com, boqun.feng@gmail.com,
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
Subject: Re: [PATCH V11 13/17] RISC-V: paravirt: pvqspinlock: Add SBI
 implementation
Message-ID: <ZQk1gTtXayK9BDfB@redhat.com>
References: <20230910082911.3378782-1-guoren@kernel.org>
 <20230910082911.3378782-14-guoren@kernel.org>
 <ZQP4SXLf00IntVWd@redhat.com>
 <CAJF2gTTBwFKjVOovMHB171s+nymL88OANpS3O-uwKBLxto43mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJF2gTTBwFKjVOovMHB171s+nymL88OANpS3O-uwKBLxto43mA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 17, 2023 at 11:06:48PM +0800, Guo Ren wrote:
> On Fri, Sep 15, 2023 at 2:23 PM Leonardo Bras <leobras@redhat.com> wrote:
> >
> > On Sun, Sep 10, 2023 at 04:29:07AM -0400, guoren@kernel.org wrote:
> > > From: Guo Ren <guoren@linux.alibaba.com>
> > >
> > > Implement pv_kick with SBI implementation, and add SBI_EXT_PVLOCK
> > > extension detection.
> > >
> > > Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> > > Signed-off-by: Guo Ren <guoren@kernel.org>
> > > ---
> > >  arch/riscv/include/asm/sbi.h           | 6 ++++++
> > >  arch/riscv/kernel/qspinlock_paravirt.c | 7 ++++++-
> > >  2 files changed, 12 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> > > index e0233b3d7a5f..3533f8d4f3e2 100644
> > > --- a/arch/riscv/include/asm/sbi.h
> > > +++ b/arch/riscv/include/asm/sbi.h
> > > @@ -30,6 +30,7 @@ enum sbi_ext_id {
> > >       SBI_EXT_HSM = 0x48534D,
> > >       SBI_EXT_SRST = 0x53525354,
> > >       SBI_EXT_PMU = 0x504D55,
> > > +     SBI_EXT_PVLOCK = 0xAB0401,
> > >
> > >       /* Experimentals extensions must lie within this range */
> > >       SBI_EXT_EXPERIMENTAL_START = 0x08000000,
> > > @@ -243,6 +244,11 @@ enum sbi_pmu_ctr_type {
> > >  /* Flags defined for counter stop function */
> > >  #define SBI_PMU_STOP_FLAG_RESET (1 << 0)
> > >
> > > +/* SBI PVLOCK (kick cpu out of wfi) */
> > > +enum sbi_ext_pvlock_fid {
> > > +     SBI_EXT_PVLOCK_KICK_CPU = 0,
> > > +};
> > > +
> > >  #define SBI_SPEC_VERSION_DEFAULT     0x1
> > >  #define SBI_SPEC_VERSION_MAJOR_SHIFT 24
> > >  #define SBI_SPEC_VERSION_MAJOR_MASK  0x7f
> > > diff --git a/arch/riscv/kernel/qspinlock_paravirt.c b/arch/riscv/kernel/qspinlock_paravirt.c
> > > index a0ad4657f437..571626f350be 100644
> > > --- a/arch/riscv/kernel/qspinlock_paravirt.c
> > > +++ b/arch/riscv/kernel/qspinlock_paravirt.c
> > > @@ -11,6 +11,8 @@
> > >
> > >  void pv_kick(int cpu)
> > >  {
> > > +     sbi_ecall(SBI_EXT_PVLOCK, SBI_EXT_PVLOCK_KICK_CPU,
> > > +               cpuid_to_hartid_map(cpu), 0, 0, 0, 0, 0);
> > >       return;
> > >  }
> > >
> > > @@ -25,7 +27,7 @@ void pv_wait(u8 *ptr, u8 val)
> > >       if (READ_ONCE(*ptr) != val)
> > >               goto out;
> > >
> > > -     /* wait_for_interrupt(); */
> > > +     wait_for_interrupt();
> > >  out:
> > >       local_irq_restore(flags);
> > >  }
> > > @@ -62,6 +64,9 @@ void __init pv_qspinlock_init(void)
> > >       if(sbi_get_firmware_id() != SBI_EXT_BASE_IMPL_ID_KVM)
> > >               return;
> > >
> > > +     if (!sbi_probe_extension(SBI_EXT_PVLOCK))
> > > +             return;
> > > +
> > >       pr_info("PV qspinlocks enabled\n");
> > >       __pv_init_lock_hash();
> > >
> > > --
> > > 2.36.1
> > >
> >
> > IIUC this PVLOCK extension is now a requirement to use pv_qspinlock(), and
> > it allows a cpu to use an instruction to wait for interrupt in pv_wait(),
> > and kicks it out of this wait using a new sbi_ecall() on pv_kick().
> Yes.
> 
> >
> > Overall it LGTM, but would be nice to have the reference doc in the commit
> > msg. I end up inferring some of the inner workings by your implementation,
> > which is not ideal for reviewing.
> I would improve the commit msg in the next version of patch.

Thx!
Leo

> 
> >
> > If understanding above is right,
> > Reviewed-by: Leonardo Bras <leobras@redhat.com>
> >
> > Thanks!
> > Leo
> >
> 
> 
> -- 
> Best Regards
>  Guo Ren
> 

