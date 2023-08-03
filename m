Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF3F76E7DA
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 14:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbjHCMHI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 08:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbjHCMHE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 08:07:04 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFEA3582
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 05:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=uB9ZimC/0RQhXiGwTFDRfcy98CEo+zz58pmAUofIlvo=; b=cGMr4b9L1bG5I10sJltjYTOI2F
        TMt/xzjyax5Uy568saRASYvMqjnktSDgIAW2hQeRUxuh6MUmlqgsCz6mnqfZdoRRhI/joVwXCEXKq
        AIJAc7kDWN8P5fyEAU/hP7FPZTYAcdN239fLlupmout7ozYqju5l7KdyBy63jGbNgKhlMb2pzEwQg
        WnZ2nJAN31sBymklDpThQjC5Vfj+DSgwX5aHaSO0Hc41LjpOJoIdKzUKwFshADLaZMMT7il9UzvoK
        EVCYgtyhjfIzSlFbPFarln/jMzEiwuCzL/zYtNdIKv0vLk0sQ0MZ5/uksZKAgLrSgoqDMgtwoQT/V
        Ix+6sG2A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qRX6E-00Gnwg-0J;
        Thu, 03 Aug 2023 12:06:38 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7033D30007E;
        Thu,  3 Aug 2023 14:06:37 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 54C62203C701D; Thu,  3 Aug 2023 14:06:37 +0200 (CEST)
Date:   Thu, 3 Aug 2023 14:06:37 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nikunj A Dadhania <nikunj@amd.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [PATCH] KVM: SVM: Add exception to disable objtool warning for
 kvm-amd.o
Message-ID: <20230803120637.GD214207@hirez.programming.kicks-ass.net>
References: <20230802091107.1160320-1-nikunj@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230802091107.1160320-1-nikunj@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 02, 2023 at 02:41:07PM +0530, Nikunj A Dadhania wrote:
> commit 7f4b5cde2409 ("kvm: Disable objtool frame pointer checking for
> vmenter.S") had added the vmenter.o file to the exception list.
> 
> objtool gives the following warnings in the newer kernel builds:
> 
>   arch/x86/kvm/kvm-amd.o: warning: objtool: __svm_vcpu_run+0x17d: BP used as a scratch register
>   arch/x86/kvm/kvm-amd.o: warning: objtool: __svm_sev_es_vcpu_run+0x72: BP used as a scratch register
> 
> As kvm-amd.o is a link time object, skipping the kvm-amd.o is not possible
> as per the objtool documentation, better to skip the offending functions.
> 
> Functions __svm_vcpu_run() and __svm_sev_es_vcpu_run() saves and restores
> RBP. Below is the snippet:
> 
>     SYM_FUNC_START(__svm_vcpu_run)
>         push %_ASM_BP
>     <…>
>         pop %_ASM_BP
>         RET
> 
> Add exceptions to skip both these functions. Remove the
> OBJECT_FILES_NON_STANDARD for vmenter.o
> 
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Reported-by: Ravi Bangoria <ravi.bangoria@amd.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/kvm/Makefile      | 4 ----
>  arch/x86/kvm/svm/vmenter.S | 2 ++
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index 80e3fe184d17..0c5c2f090e93 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -3,10 +3,6 @@
>  ccflags-y += -I $(srctree)/arch/x86/kvm
>  ccflags-$(CONFIG_KVM_WERROR) += -Werror
>  
> -ifeq ($(CONFIG_FRAME_POINTER),y)
> -OBJECT_FILES_NON_STANDARD_vmenter.o := y
> -endif
> -
>  include $(srctree)/virt/kvm/Makefile.kvm
>  
>  kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
> diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
> index 8e8295e774f0..8fd37d661c33 100644
> --- a/arch/x86/kvm/svm/vmenter.S
> +++ b/arch/x86/kvm/svm/vmenter.S
> @@ -289,6 +289,7 @@ SYM_FUNC_START(__svm_vcpu_run)
>  	_ASM_EXTABLE(7b, 70b)
>  
>  SYM_FUNC_END(__svm_vcpu_run)
> +STACK_FRAME_NON_STANDARD(__svm_vcpu_run)
>  
>  /**
>   * __svm_sev_es_vcpu_run - Run a SEV-ES vCPU via a transition to SVM guest mode
> @@ -388,3 +389,4 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
>  	_ASM_EXTABLE(1b, 3b)
>  
>  SYM_FUNC_END(__svm_sev_es_vcpu_run)
> +STACK_FRAME_NON_STANDARD_FP(__svm_sev_es_vcpu_run)

Urgh... no, no, this is all broken.

By marking them with STACK_FRAME_NON_STANDARD you will get no ORC data
at all, and then you also violate the normal framepointer calling
convention.

This means that if you need to unwind here you're up a creek without no
paddles on.

Objtool complains for a reason, your changelog does not provide a
counter argument for that reason.

Hardware/firmware interfaces that require one to violate basic
calling conventions are horrible crap.
