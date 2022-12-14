Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6C264C498
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 09:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237399AbiLNIGL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 03:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiLNIGI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 03:06:08 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF6E1DDF4;
        Wed, 14 Dec 2022 00:06:07 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id 124so3940113pfy.0;
        Wed, 14 Dec 2022 00:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=00263fAplAvONCnwITwPxudPU1CVcj7eiSkLTlLI7Fk=;
        b=LF1Edmtd2eN21kNuE5gUmccfLa3czY9OYPEAE9XxXacWrtvk/vaV/BIEmOlZidvMlW
         pGOOVUV/Oje9anH22oPtOJyrLxtQ+GZ5fO1UN5FV1hT/FJDyU73X9QVsduVilBCS8BhH
         TFW7c/PPnP+uPU6TZCQGOJrudcle2AuccA8xvWg0X9vnKvYDWMqLbmpAF/A9RsiQ/qep
         4UYfa2nQFE/mhQstf+bHUFhonTH8uSQDso2NoPuEU9NG+/7LBITmCDtOYVBil2BGyVyS
         TU2Ragm6bhaSct+h9QTHbsPYhAz89s9NjyU7dE4/6pK2Kp5TA9mgFooCNhmOlwopRuMZ
         /qRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=00263fAplAvONCnwITwPxudPU1CVcj7eiSkLTlLI7Fk=;
        b=mIBDL3ymqBiutl/x0Om5M7u0JbNDUuyb1f8JwvKLg+gtD4cQUKEtHyCdSnPjaf0vq8
         pmsh2rJ1lJ1jJMwS4SrB2WUTVktNWoTCRpIB0+zEzk/pb4A430h7w0nmedA4ZQJVb8zo
         t3/j/7LBl0SBo0+Q8VaMCQnZblysiZ3FoSuRCgsO3LU3qG+xYotWpTgpI+NO5WaYCyfY
         iXHxZ8z71Fi7L8bFEH+gh2kiID78U5qMmDD7LL8hcMxu+YJevK99jPbe7B4sZV7Fh9Z3
         7nxG3R6NemBZiiCtEyqnOpcP00CbetsCv5nAu4qHKO+paDJltjQjLQ/bkWHKLFq+xLTp
         ENaQ==
X-Gm-Message-State: ANoB5pkOuUn0Pc5KyzwHudfngxeWy29xgqWHp8DZGsg6gqv+cvo4dmft
        LfcbWvdRVOvOVQtZZF8MoSpN1UBUIqgwFI5bw3I=
X-Google-Smtp-Source: AA0mqf5/lelgMvxCc0V/D9A7RuvHgQ9oKJBkHFquAGkc4BvH7uyrswV4h+uxoBrZNVnJLFp28cT0iiRyZTJamCa1KiQ=
X-Received: by 2002:a63:e4a:0:b0:477:6cd0:9a04 with SMTP id
 10-20020a630e4a000000b004776cd09a04mr75767633pgo.433.1671005167478; Wed, 14
 Dec 2022 00:06:07 -0800 (PST)
MIME-Version: 1.0
References: <20221213060912.654668-1-seanjc@google.com> <20221213060912.654668-6-seanjc@google.com>
In-Reply-To: <20221213060912.654668-6-seanjc@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Wed, 14 Dec 2022 16:05:55 +0800
Message-ID: <CAJhGHyAJj6MGNMgu1i_zFt=0gEqCs1qT8c1ShE97qsZESTptXQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] x86/entry: KVM: Use dedicated VMX NMI entry for
 32-bit kernels too
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 13, 2022 at 2:11 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Use a dedicated entry for invoking the NMI handler from KVM VMX's VM-Exit
> path for 32-bit even though using a dedicated entry for 32-bit isn't
> strictly necessary.  Exposing a single symbol will allow KVM to reference
> the entry point in assembly code without having to resort to more #ifdefs
> (or #defines).  identry.h is intended to be included from asm files only
> once, and so simply including idtentry.h in KVM assembly isn't an option.
>
> Bypassing the ESP fixup and CR3 switching in the standard NMI entry code
> is safe as KVM always handles NMIs that occur in the guest on a kernel
> stack, with a kernel CR3.
>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/idtentry.h | 16 ++++++----------
>  arch/x86/kernel/nmi.c           |  8 ++++----
>  arch/x86/kvm/vmx/vmx.c          |  4 ++--
>  3 files changed, 12 insertions(+), 16 deletions(-)
>
> diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
> index 72184b0b2219..b241af4ce9b4 100644
> --- a/arch/x86/include/asm/idtentry.h
> +++ b/arch/x86/include/asm/idtentry.h
> @@ -582,18 +582,14 @@ DECLARE_IDTENTRY_RAW(X86_TRAP_MC, xenpv_exc_machine_check);
>
>  /* NMI */
>
> -#if defined(CONFIG_X86_64) && IS_ENABLED(CONFIG_KVM_INTEL)
> +#if IS_ENABLED(CONFIG_KVM_INTEL)
>  /*
> - * Special NOIST entry point for VMX which invokes this on the kernel
> - * stack. asm_exc_nmi() requires an IST to work correctly vs. the NMI
> - * 'executing' marker.
> - *
> - * On 32bit this just uses the regular NMI entry point because 32-bit does
> - * not have ISTs.
> + * Special entry point for VMX which invokes this on the kernel stack, even for
> + * 64-bit, i.e. without using an IST.  asm_exc_nmi() requires an IST to work
> + * correctly vs. the NMI 'executing' marker.  Used for 32-bit kernels as well
> + * to avoid more ifdeffery.
>   */
> -DECLARE_IDTENTRY(X86_TRAP_NMI,         exc_nmi_noist);
> -#else
> -#define asm_exc_nmi_noist              asm_exc_nmi
> +DECLARE_IDTENTRY(X86_TRAP_NMI,         exc_nmi_kvm_vmx);

Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>
