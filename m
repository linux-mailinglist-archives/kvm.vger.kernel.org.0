Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6CD77EE56
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 02:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347456AbjHQAcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 20:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347355AbjHQAbc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 20:31:32 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277702D50
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 17:31:31 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1bdcb800594so29522435ad.1
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 17:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1692232290; x=1692837090;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bgC1JR3GltIDSf4x3tRknvWq/71clnqR/lvG3W7lMIY=;
        b=Wk7ZcI2cSkKCmpwAOwQEWMxrL0tl/66pfHLM07y/kUfYtekvi/9AI3fVG2F8cet9z7
         HaNmXcsLFe/opiDrpqTUwTwp2xAGG4VppLrGtJ817cSohKNEmlr38uTFl2Sz3N/BKGh8
         URPT4Pgv2IShCvFGZg6os9YjX98OSOzdKTEzsWFGAay4H3HVGpaS/GVv2QchNq8KafvK
         IkyqfPF8xyh33b6/CuFgitvJDNid8GWpU+t4AG4nrLS2uSTJcWTF+Ba4KnzXdwinN19W
         fAdrVc/FNL6bAuRBVyr3h8XYuAfq3Ea1xvc1SKwFPIR4gZhmU+xURpjxgFC4H/ctLxds
         ZEyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692232290; x=1692837090;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bgC1JR3GltIDSf4x3tRknvWq/71clnqR/lvG3W7lMIY=;
        b=CcPKzvGQ7iaiYz4Sete9HYjX8TpRh4rSNgE0tJTSHDaQAIhS3FVDyxK/Ef5fIzlJiv
         xN/yEUBZWUYM3mKmpgy3/F7l7gcEnX40G/dhKM3JFsx7w4RZo2ocu+h6CsXvY8vGrvoV
         Hfg5GPcXW+H0r0Zbi1mtE1M0EeTlYAfv1z6Q6kSL4dnVAsnf7eQqSe1RmrUBnXEY+0UP
         dI3uPyfPvgKB6kXoOJj8C990gP7gNZzjwHhhj+3Tf/fq3znKEdX9zGYz9fM8Yp6dxbij
         EotnTTgFBV0HHz6zsZEouYLvEV32pBYnMlIgsTd4nS5yfEXQj5zCO2AHy9/gFzHOhUX0
         C4ZQ==
X-Gm-Message-State: AOJu0YyeyF8F5v28KU/y+Ua4qYcKjJ+Et0LJg17J8ROnfX1f3l8Mf9qF
        /5ml9I5eMjx6sZquo1HiA21jXw==
X-Google-Smtp-Source: AGHT+IGx864ksrcElUkMdcjLIA8ZzATRBTzPfs5VJbwgXjA+rTZAtM/bmlMaN8VpB9uJmBPGLXp17Q==
X-Received: by 2002:a17:902:e80d:b0:1bd:a0cd:1860 with SMTP id u13-20020a170902e80d00b001bda0cd1860mr4137638plg.64.1692232290547;
        Wed, 16 Aug 2023 17:31:30 -0700 (PDT)
Received: from ghost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id d12-20020a170902728c00b001ac5896e96esm13666450pll.207.2023.08.16.17.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 17:31:30 -0700 (PDT)
Date:   Wed, 16 Aug 2023 17:31:26 -0700
From:   Charlie Jenkins <charlie@rivosinc.com>
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        bpf@vger.kernel.org, Paul Walmsley <paul.walmsley@sifive.com>,
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
Message-ID: <ZN1qXlLp6qfpBeGF@ghost>
References: <20230803-master-refactor-instructions-v4-v1-0-2128e61fa4ff@rivosinc.com>
 <20230804-2c57bddd6e87fdebc20ff9d5@orel>
 <ZM00UYDzEAz/JT3n@ghost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZM00UYDzEAz/JT3n@ghost>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 04, 2023 at 10:24:33AM -0700, Charlie Jenkins wrote:
> On Fri, Aug 04, 2023 at 12:28:28PM +0300, Andrew Jones wrote:
> > On Thu, Aug 03, 2023 at 07:10:25PM -0700, Charlie Jenkins wrote:
> > > There are numerous systems in the kernel that rely on directly
> > > modifying, creating, and reading instructions. Many of these systems
> > > have rewritten code to do this. This patch will delegate all instruction
> > > handling into insn.h and reg.h. All of the compressed instructions, RVI,
> > > Zicsr, M, A instructions are included, as well as a subset of the F,D,Q
> > > extensions.
> > > 
> > > ---
> > > This is modifying code that https://lore.kernel.org/lkml/20230731183925.152145-1-namcaov@gmail.com/
> > > is also touching.
> > > 
> > > ---
> > > Testing:
> > > 
> > > There are a lot of subsystems touched and I have not tested every
> > > individual instruction. I did a lot of copy-pasting from the RISC-V spec
> > > so opcodes and such should be correct
> > 
> > How about we create macros which generate each of the functions an
> > instruction needs, e.g. riscv_insn_is_*(), etc. based on the output of
> > [1]. I know basically nothing about that project, but it looks like it
> > creates most the defines this series is creating from what we [hope] to
> > be an authoritative source. I also assume that if we don't like the
> > current output format, then we could probably post patches to the project
> > to get the format we want. For example, we could maybe propose an "lc"
> > format for "Linux C".
> That's a great idea, I didn't realize that existed!
I have discovered that the riscv-opcodes repository is not in a state
that makes it helpful. If it were workable, it would make it easy to
include a "Linux C" format. I have had a pull request open on the repo
for two weeks now and the person who maintains the repo has not
interacted. At minimum, in order for it to be useful it would need an ability to
describe the bit order of immediates in an instruction and include script
arguments to select which instructions should be included. There is a
"C" format, but it is actually just a Spike format. Nonetheless, it
seems like it is prohibitive to use it.
> > 
> > I'd also recommend only importing the generated defines and generating
> > the functions that will actually have immediate consumers or are part of
> > a set of defines that have immediate consumers. Each consumer of new
> > instructions will be responsible for generating and importing the defines
> > and adding the respective macro invocations to generate the functions.
> > This series can also take that approach, i.e. convert one set of
> > instructions at a time, each in a separate patch.
> Since I was hand-writing everything and copying it wasn't too much
> effort to just copy all of the instructions from a group. However, from
> a testing standpoint it makes sense to exclude instructions not yet in
> use.
> > 
> > [1] https://github.com/riscv/riscv-opcodes
> > 
> > Thanks,
> > drew
> > 
> > 
> > > , but the construction of every
> > > instruction is not fully tested.
> > > 
> > > vector: Compiled and booted
> > > 
> > > jump_label: Ensured static keys function as expected.
> > > 
> > > kgdb: Attempted to run the provided tests but they failed even without
> > > my changes
> > > 
> > > module: Loaded and unloaded modules
> > > 
> > > patch.c: Ensured kernel booted
> > > 
> > > kprobes: Used a kprobing module to probe jalr, auipc, and branch
> > > instructions
> > > 
> > > nommu misaligned addresses: Kernel boots
> > > 
> > > kvm: Ran KVM selftests
> > > 
> > > bpf: Kernel boots. Most of the instructions are exclusively used by BPF
> > > but I am unsure of the best way of testing BPF.
> > > 
> > > Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
> > > 
> > > ---
> > > Charlie Jenkins (10):
> > >       RISC-V: Expand instruction definitions
> > >       RISC-V: vector: Refactor instructions
> > >       RISC-V: Refactor jump label instructions
> > >       RISC-V: KGDB: Refactor instructions
> > >       RISC-V: module: Refactor instructions
> > >       RISC-V: Refactor patch instructions
> > >       RISC-V: nommu: Refactor instructions
> > >       RISC-V: kvm: Refactor instructions
> > >       RISC-V: bpf: Refactor instructions
> > >       RISC-V: Refactor bug and traps instructions
> > > 
> > >  arch/riscv/include/asm/bug.h             |   18 +-
> > >  arch/riscv/include/asm/insn.h            | 2744 +++++++++++++++++++++++++++---
> > >  arch/riscv/include/asm/reg.h             |   88 +
> > >  arch/riscv/kernel/jump_label.c           |   13 +-
> > >  arch/riscv/kernel/kgdb.c                 |   13 +-
> > >  arch/riscv/kernel/module.c               |   80 +-
> > >  arch/riscv/kernel/patch.c                |    3 +-
> > >  arch/riscv/kernel/probes/kprobes.c       |   13 +-
> > >  arch/riscv/kernel/probes/simulate-insn.c |  100 +-
> > >  arch/riscv/kernel/probes/uprobes.c       |    5 +-
> > >  arch/riscv/kernel/traps.c                |    9 +-
> > >  arch/riscv/kernel/traps_misaligned.c     |  218 +--
> > >  arch/riscv/kernel/vector.c               |    5 +-
> > >  arch/riscv/kvm/vcpu_insn.c               |  281 +--
> > >  arch/riscv/net/bpf_jit.h                 |  707 +-------
> > >  15 files changed, 2825 insertions(+), 1472 deletions(-)
> > > ---
> > > base-commit: 5d0c230f1de8c7515b6567d9afba1f196fb4e2f4
> > > change-id: 20230801-master-refactor-instructions-v4-433aa040da03
> > > -- 
> > > - Charlie
> > > 
> > > 
> > > -- 
> > > kvm-riscv mailing list
> > > kvm-riscv@lists.infradead.org
> > > http://lists.infradead.org/mailman/listinfo/kvm-riscv
