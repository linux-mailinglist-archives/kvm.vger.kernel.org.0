Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335F1539F81
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 10:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242377AbiFAI3r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 04:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350764AbiFAI3g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 04:29:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EBC194BFE4
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 01:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654072174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eYHc8MFYSzdCoe/K1c8WWYjHXxoxdvsTfd+zWYaMPWE=;
        b=LtOhIhBARSk3wWJotrgvh8x4/oELkA0tsj2rjPA/rSwEIU3b6Jo6JA73vncTdfpUTekyoF
        cZ9aNGxoudPU05FH1huJXb2+1oM6/9qRAwZ7GEU01ifEb3U69y57kHPnCJZdCC5d0stG57
        IuPGJ58vNm9QpsvbH5JGoNcbpFAmiDo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-5J5bnSfuM0yIOUpu8VS_cw-1; Wed, 01 Jun 2022 04:29:32 -0400
X-MC-Unique: 5J5bnSfuM0yIOUpu8VS_cw-1
Received: by mail-ej1-f69.google.com with SMTP id au8-20020a170907092800b00707784fd7e0so444784ejc.22
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 01:29:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=eYHc8MFYSzdCoe/K1c8WWYjHXxoxdvsTfd+zWYaMPWE=;
        b=zsmPqBgPVCnmzlZNrWVPEErEJZtFXtySDH6FtuhhuGA8UyxsDAaVhOSpo45VcqtAta
         iBgickX5fB0/UnHdTH4ugGFXlP+ajP4yQEux8VIuMyRjPWJORWSTDcXfwEjN8GL8zrTs
         vVi3RFh2DMqdRI+ZZgTS9giQRwdASp8TSq09wt6HKAQQ4PhFGhVd6OZMFw5QqyQL39WW
         J+e/DlGborMzZwV76XVALbC5UneHJInEh2OdUCoJZtDKZqlb1XQKxKBAx1/37cQmNLDD
         H8W5BDjhCSlV2VVI+z/pV9NVpzaktiHT4ieJ0frWoqhZfmJ2My9WfkAxc34YaXmPsKJu
         oaSg==
X-Gm-Message-State: AOAM5322WAohgNt9AS9lZiP27uxxrXJy/EJZCt3il6BVAO0lV5/qH+mM
        Z31pErepCUCofrT2A/Et2PduzZDqpopN7RCmhNRqbUgwYU6Zd5WqoO5ejZVw8YNI/5XQP23CWmV
        C+N7jb/DaTjb3
X-Received: by 2002:a05:6402:500a:b0:42d:d109:b7da with SMTP id p10-20020a056402500a00b0042dd109b7damr16226314eda.289.1654072171794;
        Wed, 01 Jun 2022 01:29:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyD6nPqYLx+Nc693yDBowHp2HcbQByU14BxAf1JV4Xeqyk+5VgxXIcx8URHxJNllz9jSMIj8g==
X-Received: by 2002:a05:6402:500a:b0:42d:d109:b7da with SMTP id p10-20020a056402500a00b0042dd109b7damr16226300eda.289.1654072171560;
        Wed, 01 Jun 2022 01:29:31 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j22-20020a1709066dd600b006fea2705d18sm403105ejt.210.2022.06.01.01.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 01:29:31 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Robert Dinse <nanook@eskimo.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 6/8] KVM: x86: Bug the VM if the emulator accesses a
 non-existent GPR
In-Reply-To: <20220526210817.3428868-7-seanjc@google.com>
References: <20220526210817.3428868-1-seanjc@google.com>
 <20220526210817.3428868-7-seanjc@google.com>
Date:   Wed, 01 Jun 2022 10:29:30 +0200
Message-ID: <87o7zcokgl.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Bug the VM, i.e. kill it, if the emulator accesses a non-existent GPR,
> i.e. generates an out-of-bounds GPR index.  Continuing on all but
> gaurantees some form of data corruption in the guest, e.g. even if KVM
> were to redirect to a dummy register, KVM would be incorrectly read zeros
> and drop writes.
>
> Note, bugging the VM doesn't completely prevent data corruption, e.g. the
> current round of emulation will complete before the vCPU bails out to
> userspace.  But, the very act of killing the guest can also cause data
> corruption, e.g. due to lack of file writeback before termination, so
> taking on additional complexity to cleanly bail out of the emulator isn't
> justified, the goal is purely to stem the bleeding and alert userspace
> that something has gone horribly wrong, i.e. to avoid _silent_ data
> corruption.

Thanks, I agree wholeheartedly :-)

>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/emulate.c     |  4 ++--
>  arch/x86/kvm/kvm_emulate.h | 10 ++++++++++
>  arch/x86/kvm/x86.c         |  9 +++++++++
>  3 files changed, 21 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 77161f57c8d3..70a8e0cd9fdc 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -247,7 +247,7 @@ enum x86_transfer_type {
>  
>  static ulong reg_read(struct x86_emulate_ctxt *ctxt, unsigned nr)
>  {
> -	if (WARN_ON_ONCE(nr >= NR_EMULATOR_GPRS))
> +	if (KVM_EMULATOR_BUG_ON(nr >= NR_EMULATOR_GPRS, ctxt))
>  		nr &= NR_EMULATOR_GPRS - 1;
>  
>  	if (!(ctxt->regs_valid & (1 << nr))) {
> @@ -259,7 +259,7 @@ static ulong reg_read(struct x86_emulate_ctxt *ctxt, unsigned nr)
>  
>  static ulong *reg_write(struct x86_emulate_ctxt *ctxt, unsigned nr)
>  {
> -	if (WARN_ON_ONCE(nr >= NR_EMULATOR_GPRS))
> +	if (KVM_EMULATOR_BUG_ON(nr >= NR_EMULATOR_GPRS, ctxt))
>  		nr &= NR_EMULATOR_GPRS - 1;
>  
>  	BUILD_BUG_ON(sizeof(ctxt->regs_dirty) * BITS_PER_BYTE < NR_EMULATOR_GPRS);
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index 034c845b3c63..89246446d6aa 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -89,6 +89,7 @@ struct x86_instruction_info {
>  #define X86EMUL_INTERCEPTED     6 /* Intercepted by nested VMCB/VMCS */
>  
>  struct x86_emulate_ops {
> +	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
>  	/*
>  	 * read_gpr: read a general purpose register (rax - r15)
>  	 *
> @@ -383,6 +384,15 @@ struct x86_emulate_ctxt {
>  	bool is_branch;
>  };
>  
> +#define KVM_EMULATOR_BUG_ON(cond, ctxt)		\
> +({						\
> +	int __ret = (cond);			\
> +						\
> +	if (WARN_ON_ONCE(__ret))		\
> +		ctxt->ops->vm_bugged(ctxt);	\
> +	unlikely(__ret);			\
> +})
> +
>  /* Repeat String Operation Prefix */
>  #define REPE_PREFIX	0xf3
>  #define REPNE_PREFIX	0xf2
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7460b9a77d9a..e60badfbbc42 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7887,7 +7887,16 @@ static int emulator_set_xcr(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr)
>  	return __kvm_set_xcr(emul_to_vcpu(ctxt), index, xcr);
>  }
>  
> +static void emulator_vm_bugged(struct x86_emulate_ctxt *ctxt)
> +{
> +	struct kvm *kvm = emul_to_vcpu(ctxt)->kvm;
> +
> +	if (!kvm->vm_bugged)
> +		kvm_vm_bugged(kvm);
> +}
> +
>  static const struct x86_emulate_ops emulate_ops = {
> +	.vm_bugged           = emulator_vm_bugged,
>  	.read_gpr            = emulator_read_gpr,
>  	.write_gpr           = emulator_write_gpr,
>  	.read_std            = emulator_read_std,

Is it actually "vm_bugged" or "kvm_bugged"? :-)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

