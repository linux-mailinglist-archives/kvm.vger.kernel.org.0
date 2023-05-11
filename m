Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 470376FFCAF
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 00:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239096AbjEKWhB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 18:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbjEKWg7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 18:36:59 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2A64ED5
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 15:36:57 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-64ac461af60so40474b3a.3
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 15:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1683844617; x=1686436617;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qmWwc7QUgu9NwZwJ11g/n+7hDdAcXK6mCH8jzITSa+U=;
        b=MSnGXe0qVlt+1QqvhtkQkX6GeAO90qB5sNfEWBfp0SGrlHQsIG7EZ0u0Sx1tirYUyE
         3PIUjTyrTERIte7GLW/YdaHnMGGRN7jYk0Yn+mEVwIkfLixb5qvM9wI2ZaRkFY7qtD1G
         0QgMDzym2GzFZcuRcmKyqHBRLBwaTD8IgdtRwDukUhCzkV9ksE6lX/wtjkNmN/oDq3ms
         4KoLHbSMiEI3SbO+8lkIlztGq1q4dtym3LliushBbn9v+i9X54FQfGYeTsQPfIVULZ+T
         reWZlZ5WG63ItDLL7yGFwu+qXnvFvUlhxAOFEfGp5djdQOFc2A5kE1d5TFQoRGNAxXkl
         axFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683844617; x=1686436617;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qmWwc7QUgu9NwZwJ11g/n+7hDdAcXK6mCH8jzITSa+U=;
        b=bSXzCsdNCEm6KhNgJ8D9X03O2yGBnLFSUL2CW0sOC0t3PRJOaqR7RW0zRf3VxSXzI5
         xAn/sKJXIAE33Z+89nVgwHYRnVkmcvllnzDUpgtg4k3da6dpoTzLy+cq9+MxDeGNYMb8
         ZmlzNkZ8OI2AqzOjwBgQCX+krItUB5+z31rKS8dbc1fG/8lI1DHQDE4R4V2LGIesAZVF
         os8vjwBMidD8ciw9l4l7IYnoMvAexHRH1ebJ/oVgXwI+HLaNSEoVwXKqT4BTAF5LmNen
         vl9AXvvkJFZBJYPDCDu5tw1vq4plK8apc2omRSGnT/0Dtsh2vGLPLo10z95SLfjiMySx
         LE+Q==
X-Gm-Message-State: AC+VfDycoQbOUJOh4BKC/qX/kmAQxOS/ha56z5E31By3Hf3V8eiap75D
        3BOY5d2hKuyKJ9Ptp3fZ2o/dEA==
X-Google-Smtp-Source: ACHHUZ6euXSEFfQsJJHWFvc0KEfHJk2pDpyRjEDRU51GbDCmVTw57xPHdefrpwyUAVHA9et9eIQtPQ==
X-Received: by 2002:a05:6a00:1882:b0:643:b8c2:b577 with SMTP id x2-20020a056a00188200b00643b8c2b577mr29458740pfh.22.1683844616975;
        Thu, 11 May 2023 15:36:56 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id c4-20020aa781c4000000b006413bf90e72sm5822096pfn.62.2023.05.11.15.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 15:36:56 -0700 (PDT)
Date:   Thu, 11 May 2023 15:36:56 -0700 (PDT)
X-Google-Original-Date: Thu, 11 May 2023 15:36:36 PDT (-0700)
Subject:     Re: [PATCH -next v19 03/24] riscv: hwprobe: Add support for RISCV_HWPROBE_BASE_BEHAVIOR_V
In-Reply-To: <CALs-HssafUZwXbxptGN3N-+2jD+6tvU=YbAZir9LsYwsEM8gBQ@mail.gmail.com>
CC:     andy.chiu@sifive.com, heiko@sntech.de,
        linux-riscv@lists.infradead.org, anup@brainfault.org,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Vineet Gupta <vineetg@rivosinc.com>,
        greentime.hu@sifive.com, guoren@linux.alibaba.com, corbet@lwn.net,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, Conor Dooley <conor.dooley@microchip.com>,
        ajones@ventanamicro.com, coelacanthus@outlook.com,
        abrestic@rivosinc.com
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     Evan Green <evan@rivosinc.com>
Message-ID: <mhng-89e278d0-874b-4deb-b1c0-fde89cbeb06a@palmer-ri-x1c9a>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 09 May 2023 11:29:28 PDT (-0700), Evan Green wrote:
> On Tue, May 9, 2023 at 10:59 AM Palmer Dabbelt <palmer@dabbelt.com> wrote:
>>
>> On Tue, 09 May 2023 10:32:03 PDT (-0700), Evan Green wrote:
>> > On Tue, May 9, 2023 at 9:41 AM Andy Chiu <andy.chiu@sifive.com> wrote:
>> >>
>> >> On Tue, May 9, 2023 at 7:05 PM Heiko Stübner <heiko@sntech.de> wrote:
>> >> >
>> >> > Am Dienstag, 9. Mai 2023, 12:30:12 CEST schrieb Andy Chiu:
>> >> > > Probing kernel support for Vector extension is available now.
>> >> > >
>> >> > > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
>> >> > > ---
>> >> > >  Documentation/riscv/hwprobe.rst       | 10 ++++++++++
>> >> > >  arch/riscv/include/asm/hwprobe.h      |  2 +-
>> >> > >  arch/riscv/include/uapi/asm/hwprobe.h |  3 +++
>> >> > >  arch/riscv/kernel/sys_riscv.c         |  9 +++++++++
>> >> > >  4 files changed, 23 insertions(+), 1 deletion(-)
>> >> > >
>> >> > > diff --git a/Documentation/riscv/hwprobe.rst b/Documentation/riscv/hwprobe.rst
>> >> > > index 9f0dd62dcb5d..b8755e180fbf 100644
>> >> > > --- a/Documentation/riscv/hwprobe.rst
>> >> > > +++ b/Documentation/riscv/hwprobe.rst
>> >> > > @@ -53,6 +53,9 @@ The following keys are defined:
>> >> > >        programs (it may still be executed in userspace via a
>> >> > >        kernel-controlled mechanism such as the vDSO).
>> >> > >
>> >> > > +  * :c:macro:`RISCV_HWPROBE_BASE_BEHAVIOR_V`: Support for Vector extension, as
>> >> > > +    defined by verion 1.0 of the RISC-V Vector extension.
>> >> >
>> >> >         ^^ version [missing the S]
>> >> >
>> >> > > +
>> >> > >  * :c:macro:`RISCV_HWPROBE_KEY_IMA_EXT_0`: A bitmask containing the extensions
>> >> > >    that are compatible with the :c:macro:`RISCV_HWPROBE_BASE_BEHAVIOR_IMA`:
>> >> > >    base system behavior.
>> >> > > @@ -64,6 +67,13 @@ The following keys are defined:
>> >> > >    * :c:macro:`RISCV_HWPROBE_IMA_C`: The C extension is supported, as defined
>> >> > >      by version 2.2 of the RISC-V ISA manual.
>> >> > >
>> >> > > +* :c:macro:`RISCV_HWPROBE_KEY_V_EXT_0`: A bitmask containing the extensions
>> >> > > +   that are compatible with the :c:macro:`RISCV_HWPROBE_BASE_BEHAVIOR_V`: base
>> >> > > +   system behavior.
>> >> > > +
>> >> > > +  * :c:macro:`RISCV_HWPROBE_V`: The V extension is supported, as defined by
>> >> > > +    version 1.0 of the RISC-V Vector extension manual.
>> >> > > +
>> >> >
>> >> > this seems to be doubling the RISCV_HWPROBE_BASE_BEHAVIOR_V state without
>> >> > adding additional information? Both essentially tell the system that
>> >> > V extension "defined by verion 1.0 of the RISC-V Vector extension" is supported.
>> >>
>> >> I was thinking that RISCV_HWPROBE_BASE_BEHAVIOR_V indicates the kernel
>> >> has a probe for vector (just like RISCV_HWPROBE_BASE_BEHAVIOR_IMA) and
>> >> RISCV_HWPROBE_KEY_V_EXT_0 is where the kernel reports what exactly the
>> >> extension is. This maps to the condition matching of F,D, and C in
>> >> IMA. If that is not the case then I think there is no need for this
>> >> entry.
>> >>
>> >> >
>> >> > I don't question that we'll probably need a key for deeper vector-
>> >> > specifics but I guess I'd the commit message should definitly explain
>> >> > why there is a duplication here.
>> >>
>> >> I suppose something like Zvfh should fall into the category of
>> >> RISCV_HWPROBE_KEY_V_EXT_0. I will add this example into the commit
>> >> message if you agree that is a good example.
>> >>
>> >> >
>> >> >
>> >> > >  * :c:macro:`RISCV_HWPROBE_KEY_CPUPERF_0`: A bitmask that contains performance
>> >> > >    information about the selected set of processors.
>> >> > >
>> >> > > diff --git a/arch/riscv/include/asm/hwprobe.h b/arch/riscv/include/asm/hwprobe.h
>> >> > > index 78936f4ff513..39df8604fea1 100644
>> >> > > --- a/arch/riscv/include/asm/hwprobe.h
>> >> > > +++ b/arch/riscv/include/asm/hwprobe.h
>> >> > > @@ -8,6 +8,6 @@
>> >> > >
>> >> > >  #include <uapi/asm/hwprobe.h>
>> >> > >
>> >> > > -#define RISCV_HWPROBE_MAX_KEY 5
>> >> > > +#define RISCV_HWPROBE_MAX_KEY 6
>> >> > >
>> >> > >  #endif
>> >> > > diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/uapi/asm/hwprobe.h
>> >> > > index 8d745a4ad8a2..93a7fd3fd341 100644
>> >> > > --- a/arch/riscv/include/uapi/asm/hwprobe.h
>> >> > > +++ b/arch/riscv/include/uapi/asm/hwprobe.h
>> >> > > @@ -22,6 +22,7 @@ struct riscv_hwprobe {
>> >> > >  #define RISCV_HWPROBE_KEY_MIMPID     2
>> >> > >  #define RISCV_HWPROBE_KEY_BASE_BEHAVIOR      3
>> >> > >  #define              RISCV_HWPROBE_BASE_BEHAVIOR_IMA (1 << 0)
>> >> > > +#define              RISCV_HWPROBE_BASE_BEHAVIOR_V   (1 << 1)

V isn't a new base, it's just an addon to IMA like FD and C are.  So 
this should just be another bit in the RISCV_HWPROBE_KEY_IMA_EXT_0 
bitset.  That'll also clear up the above about V being indicated twice.

>> >> > >  #define RISCV_HWPROBE_KEY_IMA_EXT_0  4
>> >> > >  #define              RISCV_HWPROBE_IMA_FD            (1 << 0)
>> >> > >  #define              RISCV_HWPROBE_IMA_C             (1 << 1)
>> >> > > @@ -32,6 +33,8 @@ struct riscv_hwprobe {
>> >> > >  #define              RISCV_HWPROBE_MISALIGNED_FAST           (3 << 0)
>> >> > >  #define              RISCV_HWPROBE_MISALIGNED_UNSUPPORTED    (4 << 0)
>> >> > >  #define              RISCV_HWPROBE_MISALIGNED_MASK           (7 << 0)
>> >> > > +#define RISCV_HWPROBE_KEY_V_EXT_0    6
>> >> > > +#define              RISCV_HWPROBE_V                 (1 << 0)
>> >> > >  /* Increase RISCV_HWPROBE_MAX_KEY when adding items. */
>> >> > >
>> >> > >  #endif
>> >> > > diff --git a/arch/riscv/kernel/sys_riscv.c b/arch/riscv/kernel/sys_riscv.c
>> >> > > index 5db29683ebee..6280a7f778b3 100644
>> >> > > --- a/arch/riscv/kernel/sys_riscv.c
>> >> > > +++ b/arch/riscv/kernel/sys_riscv.c
>> >> > > @@ -10,6 +10,7 @@
>> >> > >  #include <asm/cpufeature.h>
>> >> > >  #include <asm/hwprobe.h>
>> >> > >  #include <asm/sbi.h>
>> >> > > +#include <asm/vector.h>
>> >> > >  #include <asm/switch_to.h>
>> >> > >  #include <asm/uaccess.h>
>> >> > >  #include <asm/unistd.h>
>> >> > > @@ -161,6 +162,7 @@ static void hwprobe_one_pair(struct riscv_hwprobe *pair,
>> >> > >        */
>> >> > >       case RISCV_HWPROBE_KEY_BASE_BEHAVIOR:
>> >> > >               pair->value = RISCV_HWPROBE_BASE_BEHAVIOR_IMA;
>> >> > > +             pair->value |= RISCV_HWPROBE_BASE_BEHAVIOR_V;
>> >> >
>> >> > Doesn't this also need a
>> >> >         if (has_vector())
>> >> >
>> >>
>> >> If the RISCV_HWPROBE_KEY_BASE_BEHAVIOR part just tells whether hwprobe
>> >> supports probing of a set of extensions then I think we should not add
>> >> the if statement here, but maybe I misunderstood something..
>> >
>> > The intention was to show that the I, M, and A extensions are actually
>> > present on this machine, not that the other probe keys exist. Usermode
>> > is allowed to query any hwprobe key, they just get back the key set to
>> > -1 and value set to 0 on unknown keys. We "cheated" a bit for
>> > determining I, M, and A exist since they're already prerequisites of
>> > Linux, which is why there's no conditional there.
>>
>> We should probably add a comment so it doesn't trip someone up again.
>
> There is one there, it just got clipped in the context diff. It looks
> like this (after gmail mangles it):
>
> /*
> * The kernel already assumes that the base single-letter ISA
> * extensions are supported on all harts, and only supports the
> * IMA base, so just cheat a bit here and tell that to
> * userspace.
> */
> case RISCV_HWPROBE_KEY_BASE_BEHAVIOR:
> pair->value = RISCV_HWPROBE_BASE_BEHAVIOR_IMA;
> break;

OK, not sure how to make that much clearer.
