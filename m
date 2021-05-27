Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96A7393475
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 19:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236744AbhE0RFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 13:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235159AbhE0RFU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 13:05:20 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A43C061574
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 10:03:45 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id kr9so838705pjb.5
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 10:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=5leouNBqSbncovF7/pi4FMUbolKvi+txVAGYn4HmqBE=;
        b=BblAxfZBMeo5LIBtMtaaTYt+eJ5Vyt9mWFBzkFknqPigDuOlbGxi1hJPv/Rjw7bY1+
         L2RtMWfNYv8xSCUGmvNgzVAMKde/kZL0YBrUYT8jWIgTBrF6vaaFOxY3KvdWgkt0OnD2
         rMfcXaqMgp9ddcDhemSY4nBnMM2kjFfmLCotjRSEMmcw7TvtRoIBJ7YclgoTr/Mh0uzp
         U0oDXSsojhcTjWwl5fUfumBBK4msEC3vbgAhZt5hDJ+ZU4wnZM1y+h1vxObWdyuKJVkg
         XIWpRpREPV5+IhGaWvUPueVl6cW1ArHCy3Hd0LEUgnWKhKJQjWmblLmLEVW5uFtZ7q8j
         SFIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5leouNBqSbncovF7/pi4FMUbolKvi+txVAGYn4HmqBE=;
        b=fwWU79tam2jVFb0pqWKiRmjGpBxeTdHEDqg90c0wm1Dd8Z45KtzXt4pJBTffEy6BKP
         fhDHP5JExFDlkho//u8ekNdW4YVgoXtNWlAYArESZc4pcTOGuMW+DMSccDoO/sEhDZOy
         zAeeAXp552a/bSBLmLEbGBKQbUr/Mrya4Ou3Yq9nXIcZmJ4qfngRPxZX+GA/Hah6SCVG
         c9Cm2af/aeYJZ7MTPCY/AGGa9Kmyh8hw645GTh394N7Ymc4hFOpIOZLFM7BDCYANfdDR
         G3Tn4p8zM70kzICQ769onV7b/1z375r1wRh4HI+JqLd4J/yTmDQ99oROLludyFaRP7a1
         jEvA==
X-Gm-Message-State: AOAM533LP5yua4Tzptiqf6w9x8UM2t6YgKqeHVKsyv/9E0WiBm/KWM62
        9EfzyKhhxWX+Z2h3z8sN6fE6kQ==
X-Google-Smtp-Source: ABdhPJwsntW6+MqBRSSV2P33Vx7GZgUNsyoEXFn5STwQRtlwac4QG1usUBodKlGM3hfCkjZQNORMvQ==
X-Received: by 2002:a17:90a:ab8c:: with SMTP id n12mr10157011pjq.201.1622135024547;
        Thu, 27 May 2021 10:03:44 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id y190sm2318551pgd.24.2021.05.27.10.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 10:03:43 -0700 (PDT)
Date:   Thu, 27 May 2021 17:03:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v3 1/2] KVM: X86: Fix warning caused by stale emulation
 context
Message-ID: <YK/Q7ESa44lcqlMM@google.com>
References: <1622091679-31683-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1622091679-31683-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Reported by syzkaller:
> 
>   WARNING: CPU: 7 PID: 10526 at /home/kernel/ssd/linux/arch/x86/kvm//x86.c:7621 x86_emulate_instruction+0x41b/0x510 [kvm]

"/home/kernel/ssd/linux/" can be omitted to make the line length a bit shorter.
checkpatch also complains about using absolute path instead of relative path.

>   RIP: 0010:x86_emulate_instruction+0x41b/0x510 [kvm]
>   Call Trace:
>    kvm_mmu_page_fault+0x126/0x8f0 [kvm]
>    vmx_handle_exit+0x11e/0x680 [kvm_intel]
>    vcpu_enter_guest+0xd95/0x1b40 [kvm]
>    kvm_arch_vcpu_ioctl_run+0x377/0x6a0 [kvm]
>    kvm_vcpu_ioctl+0x389/0x630 [kvm]
>    __x64_sys_ioctl+0x8e/0xd0
>    do_syscall_64+0x3c/0xb0
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Commit 4a1e10d5b5d8c (KVM: x86: handle hardware breakpoints during emulation())
> adds hardware breakpoints check before emulation the instruction and parts of 
> emulation context initialization, actually we don't have the EMULTYPE_NO_DECODE flag 
> here and the emulation context will not be reused. Commit c8848cee74ff (KVM: x86: 
> set ctxt->have_exception in x86_decode_insn()) triggers the warning because it 
> catches the stale emulation context has #UD, however, it is not during instruction 
> decoding which should result in EMULATION_FAILED. This patch fixes it by moving 
> the second part emulation context initialization into init_emulate_ctxt() and 
> before hardware breakpoints check.  
> 
> syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=134683fdd00000
> 
> Reported-by: syzbot+71271244f206d17f6441@syzkaller.appspotmail.com
> Fixes: 4a1e10d5b5d8 (KVM: x86: handle hardware breakpoints during emulation)
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v2 -> v3:
>  * squash ctxt->ud
> v1 -> v2:
>  * move the second part emulation context initialization into init_emulate_ctxt()
> 
>  arch/x86/kvm/x86.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bbc4e04..ae47b19 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7226,6 +7226,13 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
>  	BUILD_BUG_ON(HF_SMM_MASK != X86EMUL_SMM_MASK);
>  	BUILD_BUG_ON(HF_SMM_INSIDE_NMI_MASK != X86EMUL_SMM_INSIDE_NMI_MASK);
>  
> +	ctxt->interruptibility = 0;
> +	ctxt->have_exception = false;
> +	ctxt->exception.vector = -1;
> +	ctxt->perm_ok = false;
> +
> +	ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;

"ctxt->ud" should be left where it is in patch 01.  "emulation_type" isn't passed
to init_emulate_ctxt(), and I don't see any reason to add it to the params since
ctxt->ud is only consumed by x86_decode_insn(), i.e. moving ctxt->ud isn't
necessary to fix the bug.

arch/x86/kvm/x86.c: In function ‘init_emulate_ctxt’:
arch/x86/kvm/x86.c:7236:13: error: ‘emulation_type’ undeclared (first use in this function); did you mean ‘exception_type’?
 7236 |  ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
      |             ^~~~~~~~~~~~~~
      |             exception_type
arch/x86/kvm/x86.c:7236:13: note: each undeclared identifier is reported only once for each function it appears in

> +
>  	init_decode_cache(ctxt);
>  	vcpu->arch.emulate_regs_need_sync_from_vcpu = false;
>  }
> @@ -7561,13 +7568,6 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
>  	    kvm_vcpu_check_breakpoint(vcpu, &r))
>  		return r;
>  
> -	ctxt->interruptibility = 0;
> -	ctxt->have_exception = false;
> -	ctxt->exception.vector = -1;
> -	ctxt->perm_ok = false;
> -
> -	ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
> -
>  	r = x86_decode_insn(ctxt, insn, insn_len);
>  
>  	trace_kvm_emulate_insn_start(vcpu);
> -- 
> 2.7.4
> 
