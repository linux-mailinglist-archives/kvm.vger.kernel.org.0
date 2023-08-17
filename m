Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3935B77FC4A
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 18:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343821AbjHQQn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 12:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353722AbjHQQnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 12:43:25 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A12F7
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 09:43:23 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1bdaeb0f29aso47736065ad.2
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 09:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1692290603; x=1692895403;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PB2Z3ZbGV4CX3loEYdldkKXA/GdXJ2Xk4SFBen/iuYc=;
        b=UkPo1ev2iFCUnViPY9CAmyGbARWlLPdYjzEHciwuGnWv+TERXIi7p0QeiMQy/DyubO
         /swhCSiHiMi8s1QoBNd0FmHYh6SxLxZcH+hR2rrkjzNmXLvuEPtrk42T1z9H/Zlf3RBp
         8E3zZ3HyUDJhozM+itzEaWxM8ccPGucc78DlRvNKf32VlR0lWSX0C+PZVJCGvJMra+nw
         019ad5Xd6cA4y5y47ViHm+4NEXkiFnbKaMQI3bB2EEnS6QMg/4Q9zqDXFaVf+R6vNQeO
         5cazeXhgiGGniVDEzESnpxYCExIJahfNEIZp/bWcMm1P/01MSYVA83JSMdLj2/MCwaLh
         CrRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692290603; x=1692895403;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PB2Z3ZbGV4CX3loEYdldkKXA/GdXJ2Xk4SFBen/iuYc=;
        b=VYGwcO1smN5Zt4AdM+5F0U8DOvRFCy5lbpuGkofp3wDQ/sYomKU4kP2Q5Ihqs70IIg
         d8HyCIttAm6Pk3BGahLM5w9er8PW5ZpQODskebeu8MfxLKi/ZfRfpOPR0SY6qxgpFYb1
         9hnDzwBwfe3WvWkrUNN7Ie9+hHm7JLFyCp82lxk4GZCGz+mSUnOmnmKdelbh+HWuwMTo
         jK235vfYGWxPkvvxXn+hFGEivVtm/+VW278xWjGlg66ke9jR807+n1mcTEPld/9HWAUu
         UktuMafihp4Tc8w1q3uzlN3/XOZb6EStlg3/ZnuDS+WAo/FVN0JUB/H6iJ2kQyUVZZTZ
         ZHFA==
X-Gm-Message-State: AOJu0YyKa/72EC2TQPpfC7JvQEnekGf6ceOhFHcFnJj+rPSBf2Qia+Og
        2iFENj8XaOtvVJibhA2HsY6AyA==
X-Google-Smtp-Source: AGHT+IEFcMgadb/7XKpYQOh6C/SwkWpgiE3QottPAATvfPQw1OPO0Y7EvudzdN/WWJ1s3h5LB3UqFA==
X-Received: by 2002:a17:902:654e:b0:1bc:15ea:ced8 with SMTP id d14-20020a170902654e00b001bc15eaced8mr5488035pln.54.1692290602969;
        Thu, 17 Aug 2023 09:43:22 -0700 (PDT)
Received: from ghost ([2601:647:5700:6860:4c48:92d8:2b81:b1ae])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902c10c00b001b7cbc5871csm15411677pli.53.2023.08.17.09.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 09:43:22 -0700 (PDT)
Date:   Thu, 17 Aug 2023 09:43:16 -0700
From:   Charlie Jenkins <charlie@rivosinc.com>
To:     Jessica Clarke <jrtc27@jrtc27.com>
Cc:     Andrew Jones <ajones@ventanamicro.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, bpf@vger.kernel.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Nam Cao <namcaov@gmail.com>
Subject: Re: [PATCH 00/10] RISC-V: Refactor instructions
Message-ID: <ZN5OJO/xOWUjLK2w@ghost>
References: <20230803-master-refactor-instructions-v4-v1-0-2128e61fa4ff@rivosinc.com>
 <20230804-2c57bddd6e87fdebc20ff9d5@orel>
 <ZM00UYDzEAz/JT3n@ghost>
 <ZN1qXlLp6qfpBeGF@ghost>
 <12FAB5A9-5723-4A5B-8729-75D8A38921B9@jrtc27.com>
 <46884D2C-F3AA-4A83-8295-AE5C0F58FE13@jrtc27.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46884D2C-F3AA-4A83-8295-AE5C0F58FE13@jrtc27.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 17, 2023 at 05:05:45AM +0100, Jessica Clarke wrote:
> On 17 Aug 2023, at 04:57, Jessica Clarke <jrtc27@jrtc27.com> wrote:
> > 
> > On 17 Aug 2023, at 01:31, Charlie Jenkins <charlie@rivosinc.com> wrote:
> >> 
> >> On Fri, Aug 04, 2023 at 10:24:33AM -0700, Charlie Jenkins wrote:
> >>> On Fri, Aug 04, 2023 at 12:28:28PM +0300, Andrew Jones wrote:
> >>>> On Thu, Aug 03, 2023 at 07:10:25PM -0700, Charlie Jenkins wrote:
> >>>>> There are numerous systems in the kernel that rely on directly
> >>>>> modifying, creating, and reading instructions. Many of these systems
> >>>>> have rewritten code to do this. This patch will delegate all instruction
> >>>>> handling into insn.h and reg.h. All of the compressed instructions, RVI,
> >>>>> Zicsr, M, A instructions are included, as well as a subset of the F,D,Q
> >>>>> extensions.
> >>>>> 
> >>>>> ---
> >>>>> This is modifying code that https://lore.kernel.org/lkml/20230731183925.152145-1-namcaov@gmail.com/
> >>>>> is also touching.
> >>>>> 
> >>>>> ---
> >>>>> Testing:
> >>>>> 
> >>>>> There are a lot of subsystems touched and I have not tested every
> >>>>> individual instruction. I did a lot of copy-pasting from the RISC-V spec
> >>>>> so opcodes and such should be correct
> >>>> 
> >>>> How about we create macros which generate each of the functions an
> >>>> instruction needs, e.g. riscv_insn_is_*(), etc. based on the output of
> >>>> [1]. I know basically nothing about that project, but it looks like it
> >>>> creates most the defines this series is creating from what we [hope] to
> >>>> be an authoritative source. I also assume that if we don't like the
> >>>> current output format, then we could probably post patches to the project
> >>>> to get the format we want. For example, we could maybe propose an "lc"
> >>>> format for "Linux C".
> >>> That's a great idea, I didn't realize that existed!
> >> I have discovered that the riscv-opcodes repository is not in a state
> >> that makes it helpful. If it were workable, it would make it easy to
> >> include a "Linux C" format. I have had a pull request open on the repo
> >> for two weeks now and the person who maintains the repo has not
> >> interacted.
> > 
> > Huh? Andrew has replied to you twice on your PR, and was the last one to
> > comment. That’s hardly “has not interacted”.
> > 
I should have been more clear because Andrew was very responsive.
However, Neel Gala appears to be the "maintainer" in the sense that
Andrew defers what gets merged into the repo to him. Neel has not
provided any feedback, and he needs to comment before Andrew will merge
anything in.
> >> At minimum, in order for it to be useful it would need an ability to
> >> describe the bit order of immediates in an instruction and include script
> >> arguments to select which instructions should be included. There is a
> >> "C" format, but it is actually just a Spike format.
> > 
> > So extend it? Or do something with QEMU’s equivalent that expresses it.
Yes, that is a possibility. To my knowledge GCC and the spec generator
have moved away from using this repo. Is it still used by QEMU?
> 
> Note that every field already identifies the bit order (or, for the
> case of compressed instructions, register restrictions) since that’s
> needed to produce the old LaTeX instruction set listings; that’s why
> there’s jimm20 vs imm20, for example. One could surely encode that in
> Python and generate the LaTeX strings from the Python, making the
> details of the encodings available elsewhere. Or just have your own
> mapping from name to whatever you need. But, either way, the
> information should all be there today in the input files, it’s just a
> matter of extending the script to produce whatever you want from them.
All of the LaTeX bit orders were hardcoded in strings. As such, the bit
order is described for the LaTeX format but not in general. It would not
make sense to hardcode them a second time for the output of the Linux
generation. You can see the strings by searching for 'latex_mapping' in
the constants.py file.

It seems to me that it will be significantly more challenging to use
riscv-opcodes than it would for people to just hand create the macros
that they need.

- Charlie
> 
> > Jess
> > 
> >> Nonetheless, it
> >> seems like it is prohibitive to use it.
> >>>> 
> >>>> I'd also recommend only importing the generated defines and generating
> >>>> the functions that will actually have immediate consumers or are part of
> >>>> a set of defines that have immediate consumers. Each consumer of new
> >>>> instructions will be responsible for generating and importing the defines
> >>>> and adding the respective macro invocations to generate the functions.
> >>>> This series can also take that approach, i.e. convert one set of
> >>>> instructions at a time, each in a separate patch.
> >>> Since I was hand-writing everything and copying it wasn't too much
> >>> effort to just copy all of the instructions from a group. However, from
> >>> a testing standpoint it makes sense to exclude instructions not yet in
> >>> use.
> >>>> 
> >>>> [1] https://github.com/riscv/riscv-opcodes
> >>>> 
> >>>> Thanks,
> >>>> drew
> >>>> 
> >>>> 
> >>>>> , but the construction of every
> >>>>> instruction is not fully tested.
> >>>>> 
> >>>>> vector: Compiled and booted
> >>>>> 
> >>>>> jump_label: Ensured static keys function as expected.
> >>>>> 
> >>>>> kgdb: Attempted to run the provided tests but they failed even without
> >>>>> my changes
> >>>>> 
> >>>>> module: Loaded and unloaded modules
> >>>>> 
> >>>>> patch.c: Ensured kernel booted
> >>>>> 
> >>>>> kprobes: Used a kprobing module to probe jalr, auipc, and branch
> >>>>> instructions
> >>>>> 
> >>>>> nommu misaligned addresses: Kernel boots
> >>>>> 
> >>>>> kvm: Ran KVM selftests
> >>>>> 
> >>>>> bpf: Kernel boots. Most of the instructions are exclusively used by BPF
> >>>>> but I am unsure of the best way of testing BPF.
> >>>>> 
> >>>>> Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
> >>>>> 
> >>>>> ---
> >>>>> Charlie Jenkins (10):
> >>>>>     RISC-V: Expand instruction definitions
> >>>>>     RISC-V: vector: Refactor instructions
> >>>>>     RISC-V: Refactor jump label instructions
> >>>>>     RISC-V: KGDB: Refactor instructions
> >>>>>     RISC-V: module: Refactor instructions
> >>>>>     RISC-V: Refactor patch instructions
> >>>>>     RISC-V: nommu: Refactor instructions
> >>>>>     RISC-V: kvm: Refactor instructions
> >>>>>     RISC-V: bpf: Refactor instructions
> >>>>>     RISC-V: Refactor bug and traps instructions
> >>>>> 
> >>>>> arch/riscv/include/asm/bug.h             |   18 +-
> >>>>> arch/riscv/include/asm/insn.h            | 2744 +++++++++++++++++++++++++++---
> >>>>> arch/riscv/include/asm/reg.h             |   88 +
> >>>>> arch/riscv/kernel/jump_label.c           |   13 +-
> >>>>> arch/riscv/kernel/kgdb.c                 |   13 +-
> >>>>> arch/riscv/kernel/module.c               |   80 +-
> >>>>> arch/riscv/kernel/patch.c                |    3 +-
> >>>>> arch/riscv/kernel/probes/kprobes.c       |   13 +-
> >>>>> arch/riscv/kernel/probes/simulate-insn.c |  100 +-
> >>>>> arch/riscv/kernel/probes/uprobes.c       |    5 +-
> >>>>> arch/riscv/kernel/traps.c                |    9 +-
> >>>>> arch/riscv/kernel/traps_misaligned.c     |  218 +--
> >>>>> arch/riscv/kernel/vector.c               |    5 +-
> >>>>> arch/riscv/kvm/vcpu_insn.c               |  281 +--
> >>>>> arch/riscv/net/bpf_jit.h                 |  707 +-------
> >>>>> 15 files changed, 2825 insertions(+), 1472 deletions(-)
> >>>>> ---
> >>>>> base-commit: 5d0c230f1de8c7515b6567d9afba1f196fb4e2f4
> >>>>> change-id: 20230801-master-refactor-instructions-v4-433aa040da03
> >>>>> -- 
> >>>>> - Charlie
> >>>>> 
> >>>>> 
> >>>>> -- 
> >>>>> kvm-riscv mailing list
> >>>>> kvm-riscv@lists.infradead.org
> >>>>> http://lists.infradead.org/mailman/listinfo/kvm-riscv
> >> 
> >> _______________________________________________
> >> linux-riscv mailing list
> >> linux-riscv@lists.infradead.org
> >> http://lists.infradead.org/mailman/listinfo/linux-riscv
> 
> 
