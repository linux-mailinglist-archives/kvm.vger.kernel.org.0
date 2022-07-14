Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0D85740A7
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 02:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbiGNAwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 20:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiGNAw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 20:52:29 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA2913D49
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 17:52:28 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id r186so137405pgr.2
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 17:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H4muTwTgTj/3OhnwCnsvELB7YAIn9AMy7WICw3/QJ4w=;
        b=DZ0JsVJaoBMRYe7xi/4MtG11T2qpS+rcVen/o5oYAJBWsYnQe6mluRAmiel0TmHCNB
         GIWXyVWINduz3/4fpvL1o0Qyazayyj7YpCQ5KpNuI90jGAmjEXCXhGorB8viqm9zIsho
         u7gmktA3rbS6kCc8mTP+2WS7DexOgtfmu1lPTG25pNUysEFZpuYtkWnfwuPCoGhalbgX
         4MvXSMqV7cfMOTHqeWB9GLdJb/U0GQANzfvqDgIyVP18RJYBeYUzLhTLoCHcWd3rpDEH
         hkuPFgVStsZc/X2C/Wye3q0bjnW5mngZKBEHwHl4pO4q6nR5tu891xEL2AIDSBVDZ12L
         F1IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H4muTwTgTj/3OhnwCnsvELB7YAIn9AMy7WICw3/QJ4w=;
        b=jVYqi7A50Z65vJMtN3bGDMU/agRnEZnPVfXWrusQrRjh/glIsTBr+8SJ2tf2Dpf0Oj
         9JLZ06hJf18E+txFbbJGl0T1rB0FFKf1871oabMyxFSnkC/dhv/Cg2nmu/6Ops/lxboG
         HCI5ZsoaO1Hpw57QpAnhuWizw/ZDMNB4LuE4466Mri75vEqnWfD4XEiT+p062riwHLVW
         mSjm2TPqiKgo/dneEK/65fJqlR1cBogUjt121fWTqzehYaSS1Hqfp0PbPnI67h7t40Nq
         VIaPq7XJrz1xjj+YlDKxuUUaHbHLj6foOjLvr6ctnwaR1jgS1cxgH2dmpi0q1FjSIgEV
         JDjA==
X-Gm-Message-State: AJIora/s3Y09BIZDWjpDlLjJJjp3UOabQnl3l3hqzhRSpbve0lYZv1Ad
        1ITIeKYzUP8TylIAhRX1ftkiRQ==
X-Google-Smtp-Source: AGRyM1vfTV94aQO3q8/sedYOGeQM5m9Kb1aEJf1L6HYk2kAOq5ucZILxkJ41cMvtYV7fdO7dP8z9OA==
X-Received: by 2002:a05:6a00:2189:b0:52b:86c:26cc with SMTP id h9-20020a056a00218900b0052b086c26ccmr5735373pfi.44.1657759947798;
        Wed, 13 Jul 2022 17:52:27 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id l13-20020a170903120d00b0016bedecdd65sm42055plh.159.2022.07.13.17.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 17:52:27 -0700 (PDT)
Date:   Thu, 14 Jul 2022 00:52:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: selftests: Fix wrmsr_safe()
Message-ID: <Ys9ox+sMPdnGlEMP@google.com>
References: <20220713150532.1012466-1-vkuznets@redhat.com>
 <20220713150532.1012466-3-vkuznets@redhat.com>
 <Ys7nkBcfYlSuF7rt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys7nkBcfYlSuF7rt@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 13, 2022, Sean Christopherson wrote:
> On Wed, Jul 13, 2022, Vitaly Kuznetsov wrote:
> > It seems to be a misconception that "A" places an u64 operand to
> > EAX:EDX, at least with GCC11.
> 
> It's not a misconception, it's just that the "A" trick only works for 32-bit
> binaries.  For 64-bit, the 64-bit integer fits into "rax" without needing to spill
> into "rdx".
> 
> I swear I had fixed this, but apparently I had only done that locally and never
> pushed/posted the changes :-/

Ugh, I have a feeling I fixed RDMSR and then forgot about WRSMR.

> > While writing a new test, I've noticed that wrmsr_safe() tries putting
> > garbage to the upper bits of the MSR, e.g.:
> > 
> >   kvm_exit:             reason MSR_WRITE rip 0x402919 info 0 0
> >   kvm_msr:              msr_write 40000118 = 0x60000000001 (#GP)
> > ...
> > when it was supposed to write '1'. Apparently, "A" works the same as
> > "a" and not as EAX/EDX. Here's the relevant disassembled part:
> > 
> > With "A":
> > 
> > 	48 8b 43 08          	mov    0x8(%rbx),%rax
> > 	49 b9 ba da ca ba 0a 	movabs $0xabacadaba,%r9
> > 	00 00 00
> > 	4c 8d 15 07 00 00 00 	lea    0x7(%rip),%r10        # 402f44 <guest_msr+0x34>
> > 	4c 8d 1d 06 00 00 00 	lea    0x6(%rip),%r11        # 402f4a <guest_msr+0x3a>
> > 	0f 30                	wrmsr
> > 
> > With "a"/"d":
> > 
> > 	48 8b 43 08          	mov    0x8(%rbx),%rax
> > 	48 89 c2             	mov    %rax,%rdx
> > 	48 c1 ea 20          	shr    $0x20,%rdx

Huh.  This is wrong.  RAX is loaded with the full 64-bit value.  It doesn't matter
for WRMSR because WRMSR only consumes EAX, but it's wrong.  I can't for the life
of me figure out why casting to a u32 doesn't force the compiler to truncate the
value.  Truncation in other places most definitely works, and the compiler loads
only EAX and EDX when using a hardcoded value, e.g. -1ull, so the input isn't
messed up.  There's no 32-bit loads of EAX, so no implicit truncation of RAX[63:32].

gcc-{7,9,11} and clang-13 generate the same code, so either it's a really
longstanding bug, or maybe some funky undocumented behavior?

If I use

	return kvm_asm_safe("wrmsr", "a"(val & -1u), "d"(val >> 32), "c"(msr));

then the result is as expected:

  48 8b 53 08             mov    0x8(%rbx),%rdx
  89 d0                   mov    %edx,%eax
  48 c1 ea 20             shr    $0x20,%rdx

I'll post a v2 of just this patch on your behalf, I also reworded the changelog
to include the gcc documentation that talks about the behavior of "A".
