Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0CEB7D195B
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 00:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbjJTWzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 18:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjJTWzM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 18:55:12 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0221D7C
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 15:55:09 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59f61a639b9so19584117b3.1
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 15:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697842509; x=1698447309; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+g38I1Y8PaKbaByFCxxvsTO4uB3YltKuRgG8s7U1tVw=;
        b=xk/nimL+eI0gDd5i/VB2O1JHRcQWK6obE8r3F546i3IHLFa47qMggw0YxFa+2Gmp/v
         GowzfJC9QQck1e+vtS/g1LdAAkuQU6a82T0P1oJaBJVgLUfPoV65Xk7Dps4keA27gFke
         a7A6IR8asHo63y/IIXR/R2PyN3S1cPAHNR1jEdFVc06FfnyXscUqMlykzLDYTkOF3n0U
         iS5Yi4lkvnsgF/ZU0UNR3u/a4sEb6IkQtOPSO/x0DVkmXjlNhN5OX2bzy6ols3i+ft68
         MbMzQDkC3Qn3dERfAsDAeqge7477AtsNr/30Z3LaKcHDa4XLk8Z/RD/XXfpwSkfCb/NU
         y8hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697842509; x=1698447309;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+g38I1Y8PaKbaByFCxxvsTO4uB3YltKuRgG8s7U1tVw=;
        b=uXU/+Zm94VgUYmdXWSMPL1VKPBOY9L3sBKHe1TwaQvpRJKS51gzeT81N4yNMibfwdk
         mxdYydK4vj5AtVY5Y8srFXJt6ygIllQxtFbEzy2Uf75QXoLoc5yYeJ5XSn+G4Bj12S3X
         dMh+pbcqd3I0xAa8kRQCoU5DS7aNb1xkKXuNeLchHL7ZZY7L7pHP+EFO8TI8s7vKGyrk
         qCbKc9FN+ckg8Ug0zqTG6ueKcPxvQ7O8HY4b6iWjpEXufYPeMGJ14FptFbw3LlVvheMz
         jb+h9Y+42xd3kbvOObc1PepxbvvS2e+CArV6y36AJ3fK7JqwJ62eFYE5H2dmVCgFwo5i
         NMLQ==
X-Gm-Message-State: AOJu0Yxv0z3bYYb3EVX40pCmG8PTxSEIhjtS+69k+g5pAhd5xynVIGgn
        hDLVC6TUxTGOSoIO5/UOnf6L+qbbgXo=
X-Google-Smtp-Source: AGHT+IENHoQiZ42m6eFADsLCJq2/clyckBRLfOaBWIr29kVDjxo24ynfoZVNeCXHANN6kij0abAlz7oMAhY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:297:0:b0:d9a:4c45:cfd0 with SMTP id
 145-20020a250297000000b00d9a4c45cfd0mr63479ybc.2.1697842508740; Fri, 20 Oct
 2023 15:55:08 -0700 (PDT)
Date:   Fri, 20 Oct 2023 15:55:07 -0700
In-Reply-To: <20231020-delay-verw-v1-6-cff54096326d@linux.intel.com>
Mime-Version: 1.0
References: <20231020-delay-verw-v1-0-cff54096326d@linux.intel.com> <20231020-delay-verw-v1-6-cff54096326d@linux.intel.com>
Message-ID: <ZTMFS8I2s8EroSNe@google.com>
Subject: Re: [PATCH  6/6] KVM: VMX: Move VERW closer to VMentry for MDS mitigation
From:   Sean Christopherson <seanjc@google.com>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023, Pawan Gupta wrote:
> During VMentry VERW is executed to mitigate MDS. After VERW, any memory
> access like register push onto stack may put host data in MDS affected
> CPU buffers. A guest can then use MDS to sample host data.
> 
> Although likelihood of secrets surviving in registers at current VERW
> callsite is less, but it can't be ruled out. Harden the MDS mitigation
> by moving the VERW mitigation late in VMentry path.
> 
> Note that VERW for MMIO Stale Data mitigation is unchanged because of
> the complexity of per-guest conditional VERW which is not easy to handle
> that late in asm with no GPRs available. If the CPU is also affected by
> MDS, VERW is unconditionally executed late in asm regardless of guest
> having MMIO access.
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/vmenter.S |  9 +++++++++
>  arch/x86/kvm/vmx/vmx.c     | 10 +++++++---
>  2 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index be275a0410a8..efa716cf4727 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -1,6 +1,7 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #include <linux/linkage.h>
>  #include <asm/asm.h>
> +#include <asm/segment.h>
>  #include <asm/bitsperlong.h>
>  #include <asm/kvm_vcpu_regs.h>
>  #include <asm/nospec-branch.h>
> @@ -31,6 +32,8 @@
>  #define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
>  #endif
>  
> +#define GUEST_CLEAR_CPU_BUFFERS		USER_CLEAR_CPU_BUFFERS
> +
>  .macro VMX_DO_EVENT_IRQOFF call_insn call_target
>  	/*
>  	 * Unconditionally create a stack frame, getting the correct RSP on the
> @@ -177,10 +180,16 @@ SYM_FUNC_START(__vmx_vcpu_run)
>   * the 'vmx_vmexit' label below.
>   */
>  .Lvmresume:
> +	/* Mitigate CPU data sampling attacks .e.g. MDS */
> +	GUEST_CLEAR_CPU_BUFFERS

I have a very hard time believing that it's worth duplicating the mitigation
for VMRESUME vs. VMLAUNCH just to land it after a Jcc.

 3b1:   48 8b 00                mov    (%rax),%rax
 3b4:   74 18                   je     3ce <__vmx_vcpu_run+0x9e>
 3b6:   eb 0e                   jmp    3c6 <__vmx_vcpu_run+0x96>
 3b8:   0f 00 2d 05 00 00 00    verw   0x5(%rip)        # 3c4 <__vmx_vcpu_run+0x94>
 3bf:   0f 1f 80 00 00 18 00    nopl   0x180000(%rax)
 3c6:   0f 01 c3                vmresume
 3c9:   e9 c9 00 00 00          jmp    497 <vmx_vmexit+0xa7>
 3ce:   eb 0e                   jmp    3de <__vmx_vcpu_run+0xae>
 3d0:   0f 00 2d 05 00 00 00    verw   0x5(%rip)        # 3dc <__vmx_vcpu_run+0xac>
 3d7:   0f 1f 80 00 00 18 00    nopl   0x180000(%rax)
 3de:   0f 01 c2                vmlaunch

Also, would it'd be better to put the NOP first?  Or even better, out of line?
It'd be quite hilarious if the CPU pulled a stupid and speculated on the operand
of the NOP, i.e. if the user/guest controlled RAX allowed for pulling in data
after the VERW.
