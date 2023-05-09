Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33916FCD1E
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 19:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbjEIR7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 13:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjEIR7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 13:59:39 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301235590
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 10:59:31 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1a516fb6523so58367995ad.3
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 10:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1683655170; x=1686247170;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nqJoJvlP9zDxdQ0K0L+JgsbcfKm3u2dw31nfblNM+4c=;
        b=MtP+c5nf+zW079JTRYKqCd1DsuuP90EvsoF7JOxu4HlKWSniW0GYK/5AUCw3ntd3Js
         6/JQqJIKvri0P4KwuEnWNfS8JQKuKKmnEtXOTSUPVIHrNK1HjQ61E10HvsMsusyITD7s
         XvRO0f4u75V7FSoCZ3HcOcIu5jZ8aL1vZI0Q/tSYyrJTbMqbxaoUPOh64oGdiV3ZXvM8
         uKQCZQEF/jdh3v775aazF2n2QyMxQobpXrszDmHfzTyPGeyNRjv0GAYNd1oVt9BHzYy3
         9tCo0x9w703WQIm86dHfttPkPxoAALM34pnWh+eE80Hct9jGPn8Ny5tECK4BAi/JY2Ha
         U+eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683655170; x=1686247170;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nqJoJvlP9zDxdQ0K0L+JgsbcfKm3u2dw31nfblNM+4c=;
        b=EGGQqtanu8EbiK3cCMZYj7ZNYuQWaVkyUHs1Y5oTD82AtWVCnj9H0f/NRG9EeiSil8
         WPUxT33oEAk9qs0WdpMVhB99vPZV5MB5gbUfwj/l1gCtClLCOeHnILUhfSfg70elxbdC
         wcYeIYKsHCkDmHEfC8iiDxMKYnzWIecWTdlY66eov4XRkPfWXQh/wQb36lyEPkM5lkkJ
         /Ws78T6D7bn/MSmKMZkYWTSZCl0S+peZGgPRk6/C+I5dHVJGLBpvPscG87cWjDOqnzE+
         CHCr7qq7h1qktNEKI/f7Atg+KPKSrVswMiFOPNZj2w6A9teG7cPkHPN96KMeMYPJAhfK
         /Bmg==
X-Gm-Message-State: AC+VfDz+LDKL5QqR7kt+JXDAD0JFYXNDxVFlJ0kK6cpMs9sg/jKR3+a5
        LzpNLtDJfKRVUkJ/bO5tdUBvhA==
X-Google-Smtp-Source: ACHHUZ4Jjxw0nwWpMVUKcca85N2M3+SP9PcqbUtCSo5uSdDwHwxoLgwK3/A/PA9HRpdUJ01X8mDTfQ==
X-Received: by 2002:a17:903:41d0:b0:1ac:4412:bd9 with SMTP id u16-20020a17090341d000b001ac44120bd9mr18370891ple.3.1683655170146;
        Tue, 09 May 2023 10:59:30 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id b13-20020a17090a8c8d00b0024deb445265sm16979621pjo.47.2023.05.09.10.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 10:59:29 -0700 (PDT)
Date:   Tue, 09 May 2023 10:59:29 -0700 (PDT)
X-Google-Original-Date: Tue, 09 May 2023 10:59:09 PDT (-0700)
Subject:     Re: [PATCH -next v19 03/24] riscv: hwprobe: Add support for RISCV_HWPROBE_BASE_BEHAVIOR_V
In-Reply-To: <CALs-Hss8L478Pg7zdcVZkL-jGGqdXtQd+uy+JdNEey90+eBYiA@mail.gmail.com>
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
Message-ID: <mhng-abff9e50-4cda-4f22-b903-a3f7eb2c340a@palmer-ri-x1c9a>
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

On Tue, 09 May 2023 10:32:03 PDT (-0700), Evan Green wrote:
> On Tue, May 9, 2023 at 9:41 AM Andy Chiu <andy.chiu@sifive.com> wrote:
>>
>> On Tue, May 9, 2023 at 7:05 PM Heiko Stübner <heiko@sntech.de> wrote:
>> >
>> > Am Dienstag, 9. Mai 2023, 12:30:12 CEST schrieb Andy Chiu:
>> > > Probing kernel support for Vector extension is available now.
>> > >
>> > > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
>> > > ---
>> > >  Documentation/riscv/hwprobe.rst       | 10 ++++++++++
>> > >  arch/riscv/include/asm/hwprobe.h      |  2 +-
>> > >  arch/riscv/include/uapi/asm/hwprobe.h |  3 +++
>> > >  arch/riscv/kernel/sys_riscv.c         |  9 +++++++++
>> > >  4 files changed, 23 insertions(+), 1 deletion(-)
>> > >
>> > > diff --git a/Documentation/riscv/hwprobe.rst b/Documentation/riscv/hwprobe.rst
>> > > index 9f0dd62dcb5d..b8755e180fbf 100644
>> > > --- a/Documentation/riscv/hwprobe.rst
>> > > +++ b/Documentation/riscv/hwprobe.rst
>> > > @@ -53,6 +53,9 @@ The following keys are defined:
>> > >        programs (it may still be executed in userspace via a
>> > >        kernel-controlled mechanism such as the vDSO).
>> > >
>> > > +  * :c:macro:`RISCV_HWPROBE_BASE_BEHAVIOR_V`: Support for Vector extension, as
>> > > +    defined by verion 1.0 of the RISC-V Vector extension.
>> >
>> >         ^^ version [missing the S]
>> >
>> > > +
>> > >  * :c:macro:`RISCV_HWPROBE_KEY_IMA_EXT_0`: A bitmask containing the extensions
>> > >    that are compatible with the :c:macro:`RISCV_HWPROBE_BASE_BEHAVIOR_IMA`:
>> > >    base system behavior.
>> > > @@ -64,6 +67,13 @@ The following keys are defined:
>> > >    * :c:macro:`RISCV_HWPROBE_IMA_C`: The C extension is supported, as defined
>> > >      by version 2.2 of the RISC-V ISA manual.
>> > >
>> > > +* :c:macro:`RISCV_HWPROBE_KEY_V_EXT_0`: A bitmask containing the extensions
>> > > +   that are compatible with the :c:macro:`RISCV_HWPROBE_BASE_BEHAVIOR_V`: base
>> > > +   system behavior.
>> > > +
>> > > +  * :c:macro:`RISCV_HWPROBE_V`: The V extension is supported, as defined by
>> > > +    version 1.0 of the RISC-V Vector extension manual.
>> > > +
>> >
>> > this seems to be doubling the RISCV_HWPROBE_BASE_BEHAVIOR_V state without
>> > adding additional information? Both essentially tell the system that
>> > V extension "defined by verion 1.0 of the RISC-V Vector extension" is supported.
>>
>> I was thinking that RISCV_HWPROBE_BASE_BEHAVIOR_V indicates the kernel
>> has a probe for vector (just like RISCV_HWPROBE_BASE_BEHAVIOR_IMA) and
>> RISCV_HWPROBE_KEY_V_EXT_0 is where the kernel reports what exactly the
>> extension is. This maps to the condition matching of F,D, and C in
>> IMA. If that is not the case then I think there is no need for this
>> entry.
>>
>> >
>> > I don't question that we'll probably need a key for deeper vector-
>> > specifics but I guess I'd the commit message should definitly explain
>> > why there is a duplication here.
>>
>> I suppose something like Zvfh should fall into the category of
>> RISCV_HWPROBE_KEY_V_EXT_0. I will add this example into the commit
>> message if you agree that is a good example.
>>
>> >
>> >
>> > >  * :c:macro:`RISCV_HWPROBE_KEY_CPUPERF_0`: A bitmask that contains performance
>> > >    information about the selected set of processors.
>> > >
>> > > diff --git a/arch/riscv/include/asm/hwprobe.h b/arch/riscv/include/asm/hwprobe.h
>> > > index 78936f4ff513..39df8604fea1 100644
>> > > --- a/arch/riscv/include/asm/hwprobe.h
>> > > +++ b/arch/riscv/include/asm/hwprobe.h
>> > > @@ -8,6 +8,6 @@
>> > >
>> > >  #include <uapi/asm/hwprobe.h>
>> > >
>> > > -#define RISCV_HWPROBE_MAX_KEY 5
>> > > +#define RISCV_HWPROBE_MAX_KEY 6
>> > >
>> > >  #endif
>> > > diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/uapi/asm/hwprobe.h
>> > > index 8d745a4ad8a2..93a7fd3fd341 100644
>> > > --- a/arch/riscv/include/uapi/asm/hwprobe.h
>> > > +++ b/arch/riscv/include/uapi/asm/hwprobe.h
>> > > @@ -22,6 +22,7 @@ struct riscv_hwprobe {
>> > >  #define RISCV_HWPROBE_KEY_MIMPID     2
>> > >  #define RISCV_HWPROBE_KEY_BASE_BEHAVIOR      3
>> > >  #define              RISCV_HWPROBE_BASE_BEHAVIOR_IMA (1 << 0)
>> > > +#define              RISCV_HWPROBE_BASE_BEHAVIOR_V   (1 << 1)
>> > >  #define RISCV_HWPROBE_KEY_IMA_EXT_0  4
>> > >  #define              RISCV_HWPROBE_IMA_FD            (1 << 0)
>> > >  #define              RISCV_HWPROBE_IMA_C             (1 << 1)
>> > > @@ -32,6 +33,8 @@ struct riscv_hwprobe {
>> > >  #define              RISCV_HWPROBE_MISALIGNED_FAST           (3 << 0)
>> > >  #define              RISCV_HWPROBE_MISALIGNED_UNSUPPORTED    (4 << 0)
>> > >  #define              RISCV_HWPROBE_MISALIGNED_MASK           (7 << 0)
>> > > +#define RISCV_HWPROBE_KEY_V_EXT_0    6
>> > > +#define              RISCV_HWPROBE_V                 (1 << 0)
>> > >  /* Increase RISCV_HWPROBE_MAX_KEY when adding items. */
>> > >
>> > >  #endif
>> > > diff --git a/arch/riscv/kernel/sys_riscv.c b/arch/riscv/kernel/sys_riscv.c
>> > > index 5db29683ebee..6280a7f778b3 100644
>> > > --- a/arch/riscv/kernel/sys_riscv.c
>> > > +++ b/arch/riscv/kernel/sys_riscv.c
>> > > @@ -10,6 +10,7 @@
>> > >  #include <asm/cpufeature.h>
>> > >  #include <asm/hwprobe.h>
>> > >  #include <asm/sbi.h>
>> > > +#include <asm/vector.h>
>> > >  #include <asm/switch_to.h>
>> > >  #include <asm/uaccess.h>
>> > >  #include <asm/unistd.h>
>> > > @@ -161,6 +162,7 @@ static void hwprobe_one_pair(struct riscv_hwprobe *pair,
>> > >        */
>> > >       case RISCV_HWPROBE_KEY_BASE_BEHAVIOR:
>> > >               pair->value = RISCV_HWPROBE_BASE_BEHAVIOR_IMA;
>> > > +             pair->value |= RISCV_HWPROBE_BASE_BEHAVIOR_V;
>> >
>> > Doesn't this also need a
>> >         if (has_vector())
>> >
>>
>> If the RISCV_HWPROBE_KEY_BASE_BEHAVIOR part just tells whether hwprobe
>> supports probing of a set of extensions then I think we should not add
>> the if statement here, but maybe I misunderstood something..
>
> The intention was to show that the I, M, and A extensions are actually
> present on this machine, not that the other probe keys exist. Usermode
> is allowed to query any hwprobe key, they just get back the key set to
> -1 and value set to 0 on unknown keys. We "cheated" a bit for
> determining I, M, and A exist since they're already prerequisites of
> Linux, which is why there's no conditional there.

We should probably add a comment so it doesn't trip someone up again.

> -Evan
