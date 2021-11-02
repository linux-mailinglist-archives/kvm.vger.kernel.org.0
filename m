Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885D94430E4
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 15:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbhKBO4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 10:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbhKBO4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 10:56:45 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120C4C061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 07:54:10 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id i26so33459675ljg.7
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 07:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tnGWO6De14brnYGPNkilMKJ5C7ikF6fltBLGDbtm+4I=;
        b=n1oUGDjaHoDg098yqn+LHnoPMS4aHLuNVa5s6QfWlXEkLVxSnQXuM+v5Hyu0hZ3Ni5
         OcnkPtRyYM4yHdSOysGEgIXfIeLHDR+LcTU7igKkfQKB2/3ddfz7o71ca5LerXkT7mTl
         ahaRXfWLUm0LoGtiSGpyJZMISzzmHF2son9Ay7L/xHkSfZJ+cESQMXdcJ5rOVuR/G1TF
         kTlnyqkYXOn1G3XiBF8PZMbo02rXf1M91TH534by95sMcgrFUK7A0gYDNGb0EfuFWI5A
         1kRb1lv4E8O0nVPa1P5cyOVqJQ12+rk4bPsMcu6jNhrSZTfa9EXF2so/KNVyqKpAjAIA
         u+ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tnGWO6De14brnYGPNkilMKJ5C7ikF6fltBLGDbtm+4I=;
        b=EhinrBzvZf22SWSypJYGqRkcdyFPrFZGQmtpMx/oc+SU0ixevTyCDgnjp6PpuOpCIy
         hNdFKgGC1YAcGnFgGJNPfHFkRcr82P6PGLmjemY2oxA+Z63WIChBhyjdtkbVI4y3hvZ0
         suj47bjfIrvxSVDXs0RZMP55k510Xwx6T8Mh8Od516dz14gYFJGW3LSFL2uPNK28CxUV
         zysDx2eSoW1754981jG81Qd8xwcgyNmkkjr0eQ4HZfPQYJwiZ3VtaKP68uDC/ziiUYTW
         EYb5TGQ0gRcQb6hc5oTjbVr9HysgxwU1IoYcViV7TNXi8UtFivSIpvpqTjcJXTRw/SAy
         KsZQ==
X-Gm-Message-State: AOAM533JOyk8Bi3+vvCrQP5iGgMG9+oBpYdI5Y1OZaU6vZb86y4hoyqN
        B+dDffEoRwn5SUf8si7pKPED6i33TVLSRO6ObLbT/A==
X-Google-Smtp-Source: ABdhPJxe3szcKlyys/NryzWwNDy9H79VGLc5m1/8ywBPPJ4/fdMKnezEBfFJQkuhbNkEahaMF5HZcIhSnGRq+r5T80E=
X-Received: by 2002:a05:651c:2cf:: with SMTP id f15mr12460790ljo.170.1635864848055;
 Tue, 02 Nov 2021 07:54:08 -0700 (PDT)
MIME-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com> <20211102094651.2071532-7-oupton@google.com>
 <875ytaak5q.wl-maz@kernel.org>
In-Reply-To: <875ytaak5q.wl-maz@kernel.org>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 2 Nov 2021 07:53:57 -0700
Message-ID: <CAOQ_Qsgc7aA89OMBZTqYykbdKLypBhra0FNQZRPTEHpcaaqyhw@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] selftests: KVM: Test OS lock behavior
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Marc,

On Tue, Nov 2, 2021 at 4:09 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Oliver,
>
> On Tue, 02 Nov 2021 09:46:51 +0000,
> Oliver Upton <oupton@google.com> wrote:
> >
> > KVM now correctly handles the OS Lock for its guests. When set, KVM
> > blocks all debug exceptions originating from the guest. Add test cases
> > to the debug-exceptions test to assert that software breakpoint,
> > hardware breakpoint, watchpoint, and single-step exceptions are in fact
> > blocked.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  .../selftests/kvm/aarch64/debug-exceptions.c  | 58 ++++++++++++++++++-
> >  1 file changed, 56 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > index e5e6c92b60da..6b6ff81cdd23 100644
> > --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > @@ -23,7 +23,7 @@
> >  #define SPSR_D               (1 << 9)
> >  #define SPSR_SS              (1 << 21)
> >
> > -extern unsigned char sw_bp, hw_bp, bp_svc, bp_brk, hw_wp, ss_start;
> > +extern unsigned char sw_bp, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start;
> >  static volatile uint64_t sw_bp_addr, hw_bp_addr;
> >  static volatile uint64_t wp_addr, wp_data_addr;
> >  static volatile uint64_t svc_addr;
> > @@ -47,6 +47,14 @@ static void reset_debug_state(void)
> >       isb();
> >  }
> >
> > +static void enable_os_lock(void)
> > +{
> > +     write_sysreg(oslar_el1, 1);
> > +     isb();
> > +
> > +     GUEST_ASSERT(read_sysreg(oslsr_el1) & 2);
> > +}
> > +
> >  static void install_wp(uint64_t addr)
> >  {
> >       uint32_t wcr;
> > @@ -99,6 +107,7 @@ static void guest_code(void)
> >       GUEST_SYNC(0);
> >
> >       /* Software-breakpoint */
> > +     reset_debug_state();
> >       asm volatile("sw_bp: brk #0");
> >       GUEST_ASSERT_EQ(sw_bp_addr, PC(sw_bp));
> >
> > @@ -152,6 +161,51 @@ static void guest_code(void)
> >       GUEST_ASSERT_EQ(ss_addr[1], PC(ss_start) + 4);
> >       GUEST_ASSERT_EQ(ss_addr[2], PC(ss_start) + 8);
> >
> > +     GUEST_SYNC(6);
> > +
> > +     /* OS Lock blocking software-breakpoint */
> > +     reset_debug_state();
> > +     enable_os_lock();
> > +     sw_bp_addr = 0;
> > +     asm volatile("brk #0");
> > +     GUEST_ASSERT_EQ(sw_bp_addr, 0);
>
> I haven't had a change to properly review the series, but this one
> definitely caught my eye. My expectations are that BRK is *not*
> affected by the OS Lock. The ARMv8 ARM goes as far as saying:
>
> <quote>
> Breakpoint Instruction exceptions are enabled regardless of the state
> of the OS Lock and the OS Double Lock.
> </quote>
>
> as well as:
>
> <quote>
> There is no enable control for Breakpoint Instruction exceptions. They
> are always enabled, and cannot be masked.
> </quote>

/facepalm I had thought I read "Breakpoint Instruction exceptions" in
the list on D2.5 "The effect of powerdown on debug exceptions",
although on second read I most definitely did not. And if I had read
the bottom of the section, I'd of seen one of the quotes.

> I wonder how your test succeeds, though.

Probably because the expectations I wrote match the non-architected
behavior I implemented :-)

--
Thanks,
Oliver
