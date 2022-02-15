Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8CE4B7549
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 21:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242545AbiBOR31 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 12:29:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241010AbiBOR3Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 12:29:25 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A4D237E1
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 09:29:14 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id i6so34125646pfc.9
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 09:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LD4Ti0KcI0wwpDbP7a3Bw9j3YjUZkmA5OGrac5sTet4=;
        b=EUmyAq1WdDarRMyF/Z+zojJwktFK6mFyL2Dsxwj0fwYE8pODdL4f0tQ9y1pO1V8Ep/
         uuMUo8prjiFWmkNvFR8Yu8xY5NmgpatV0uKVSLRH/uR0mlePE6sI2s+YI0q5bKy8YCGS
         jMRAs6RUOkBNCcS+9PbmLDuLeayS2Oal0F1t1h8kYLqMmSUoeuREMMijl+RIyBzZbwBg
         l9e9b67GTCsFi2p6jPCKYEudsIM3vrqLIW+l84LU9dx1rdGlbuEokHEhFJPBUo8XIu4I
         68qfm1yLGboQ8k98B21pqJ0Z8JmO7wB7ZSd+6iie+e1a+g/QL4zQfSGkiQmnUmUq27Is
         IYuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LD4Ti0KcI0wwpDbP7a3Bw9j3YjUZkmA5OGrac5sTet4=;
        b=fO2AzLYgb1z8XYVqCmRtBTXF8coKrWy3cdMTkGHTEy3WZjgeuBvZMEY0Dcz5sA5Lp9
         X3mfW38hhUfEhQb3Sm15FcvYK/HtjwdE+anoF2BVJfObgflCMBVZrTQRb0ognEUlIIyw
         gqVEB53w8YvAEp4wyh6a2M0ZRM0J9R5Cu1qn+hLp2f5QHFC3D0WsF0i7MO7VYn1G3g+e
         O33/E/icktwhS/7Vbe7R3abC1uy+wjbw61qap5m63aeiz+W4mM6eHvpa3lQIAxy0zHRM
         yZ8wfeEi+beaa89iwWqbEaY7Czrggwt9FN4+dT/juKsXvG8Fh/ICCNc4S+82+q5T2wA9
         qNPg==
X-Gm-Message-State: AOAM5321plJonkrHJKGzUKUHE5kksndccxQRlT7vAs3H2sTFRjWVljnW
        UZK5mz+k6iObrPyeiMSKnghQZg==
X-Google-Smtp-Source: ABdhPJyQLMJpy78D/uXgyKx88FDyuAlOwbMe4oENO7qfMoXcmEbS3VbXaS+SctSh03YRotEsGA+zbg==
X-Received: by 2002:a65:4286:: with SMTP id j6mr4304847pgp.619.1644946154212;
        Tue, 15 Feb 2022 09:29:14 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p16sm2531629pfh.89.2022.02.15.09.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 09:29:13 -0800 (PST)
Date:   Tue, 15 Feb 2022 17:29:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 5/5] KVM: x86: allow defining return-0 static calls
Message-ID: <Ygvi5jr4V8S/bKSe@google.com>
References: <20220214131614.3050333-1-pbonzini@redhat.com>
 <20220214131614.3050333-6-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214131614.3050333-6-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022, Paolo Bonzini wrote:
> A few vendor callbacks are only used by VMX, but they return an integer
> or bool value.  Introduce KVM_X86_OP_RET0 for them: a NULL value in

s/KVM_X86_OP_RET0/KVM_X86_OP_OPTIONAL_RET0

And maybe "NULL func" instead of "NULL value", since some members of kvm_x86_ops
hold a value, not a func.

> struct kvm_x86_ops will be changed to __static_call_return0.

This implies kvm_x86_ops itself is changed, which is incorrect.  "will be patched
to __static_call_return0() when updating static calls" or so.

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h | 20 +++++++++++++-------
>  arch/x86/include/asm/kvm_host.h    |  4 ++++
>  arch/x86/kvm/svm/avic.c            |  5 -----
>  arch/x86/kvm/svm/svm.c             | 26 --------------------------
>  arch/x86/kvm/x86.c                 |  2 +-
>  kernel/static_call.c               |  1 +
>  6 files changed, 19 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 0a074354aaf7..ad75ff5ac220 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -6,14 +6,19 @@ BUILD_BUG_ON(1)
>  /*
>   * KVM_X86_OP() and KVM_X86_OP_OPTIONAL() are used to help generate
>   * "static_call()"s. They are also intended for use when defining
> - * the vmx/svm kvm_x86_ops. KVM_X86_OP_OPTIONAL() can be used for those
> + * the vmx/svm kvm_x86_ops.
> + *
> + * KVM_X86_OP_OPTIONAL() can be used for those
>   * functions that can have a NULL definition, for example if
>   * "static_call_cond()" will be used at the call sites.
> + * KVM_X86_OP_OPTIONAL_RET0() can be used likewise to make
> + * a definition optional, but in this case the default will 

ERROR: trailing whitespace
#35: FILE: arch/x86/include/asm/kvm-x86-ops.h:15:
+ * a definition optional, but in this case the default will $

> + * be __static_call_return0.

Uber nit, __static_call_return0() to make it clear that that's a function, not a
magic return value (though arguably it's that too).

>   */
>  KVM_X86_OP(hardware_enable)
>  KVM_X86_OP(hardware_disable)
>  KVM_X86_OP(hardware_unsetup)
> -KVM_X86_OP(cpu_has_accelerated_tpr)
> +KVM_X86_OP_OPTIONAL_RET0(cpu_has_accelerated_tpr)

Can we instead just remove this helper entirely and return '1' unconditionally
from KVM_CAP_VAPIC?

The usage appears to be wrong, this will return '0' for VMX, '1' for SVM.

	case KVM_CAP_VAPIC:
		r = !static_call(kvm_x86_cpu_has_accelerated_tpr)();
		break;

Further more, our uapi says:

  /* Available with KVM_CAP_VAPIC */
  #define KVM_TPR_ACCESS_REPORTING  _IOWR(KVMIO, 0x92, struct kvm_tpr_access_ctl)
  /* Available with KVM_CAP_VAPIC */
  #define KVM_SET_VAPIC_ADDR        _IOW(KVMIO,  0x93, struct kvm_vapic_addr)

But neither of those check cpu_has_accelerated_tpr().  QEMU doesn't check the
cap, and AFAICT neither does our VMM.
