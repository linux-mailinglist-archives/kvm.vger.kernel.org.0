Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00CDA3B873C
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 18:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhF3QvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 12:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhF3QvQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Jun 2021 12:51:16 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602D5C061756
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 09:48:47 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id g24-20020a17090ace98b029017225d0c013so3441160pju.1
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 09:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hx4sHPmpea1ssyo//7YojpBEY/8Dcb5c5IPS9PMJhIk=;
        b=jw4C41UcaJLjRGuy4z9pSqd4r5Z5SnfuXfelNN0qNxjZCfFm4y61lAm2gS/JbmuC+y
         pTkSg/zoQc+ojr+tDHflc4aTT33Y3V7sq0sGWNZTKokoJ5v9gKSllQJKRrC7xN3lh6JU
         W+8sx3juiAIraD3gqInA/NklMtZezqx8B2Y/IiLA1wZ2Wu5YMQHLJMAcfhxBs+3QMpw1
         sb3S1UBBzyXkKo1gMYg/bcAJh1hVJKrfeejbIcSMcoroznlfrf0slh32djIVKpx6b2ed
         Sz05nHV6NSS90mMWwNUWAaU4hS9LCxycbbmGB9JqSw/SbSOnVgcO5L9mQEFyxDwjecHT
         4c+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hx4sHPmpea1ssyo//7YojpBEY/8Dcb5c5IPS9PMJhIk=;
        b=fp+PQgoq5T1bIsIwY+yfOmKshwiuV3f9zU6ljxTzK1Iv5tITL6WyROb73lBGuja21p
         p6fUclYX8hsAVmul8HTW9JvaYR7mTnsNBC+kwKTR9Tx2Fw4CObB5SdZui0fXgtzeH/1J
         4GaOs0lJyf99Q+OXi5uLZ/EQoKjokRz7Ibe6i8sFDV+bz4B++qoVKulNLoI9UePrBava
         6yL9diJZmKrj7nksFhf/UPvE3AmsO2ujO9vFbdQ+1oTCxvl/QrrdvrgK3jGevTzQKX7J
         394SJ0yeCrIzfLQmGTB6+8VUpBEaeX3F3ekhbSuRzFcuSc8PKBVCkCViUArYqyXkpmq6
         oi4w==
X-Gm-Message-State: AOAM5330qFXqppHrUrCv9bSjH8kXEabIwJ/vOeKboqaVPXj4cLJZ8p+K
        W4SG8p+lvdJSeMQBETco0eTNDFfxYUmaBw==
X-Google-Smtp-Source: ABdhPJxs1KpcsKXdwFRVLG2nyYxkQ7sqFlLA6mfloOo099zl9iV5Yv046zB363+6JA1C8jrzLqW9Zg==
X-Received: by 2002:a17:902:fe10:b029:127:6549:fe98 with SMTP id g16-20020a170902fe10b02901276549fe98mr32880513plj.25.1625071726557;
        Wed, 30 Jun 2021 09:48:46 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id v3sm22917472pfb.126.2021.06.30.09.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 09:48:45 -0700 (PDT)
Date:   Wed, 30 Jun 2021 16:48:42 +0000
From:   David Matlack <dmatlack@google.com>
To:     David Edmondson <david.edmondson@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH 2/2] KVM: x86: On emulation failure, convey the exit
 reason to userspace
Message-ID: <YNygagjfTIuptxL8@google.com>
References: <20210628173152.2062988-1-david.edmondson@oracle.com>
 <20210628173152.2062988-3-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628173152.2062988-3-david.edmondson@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 28, 2021 at 06:31:52PM +0100, David Edmondson wrote:
> To aid in debugging.

Please add more context to the commit message.

> 
> Suggested-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
> ---
>  arch/x86/kvm/x86.c       | 23 +++++++++++++++++------
>  include/uapi/linux/kvm.h |  2 ++
>  2 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8166ad113fb2..48ef0dc68faf 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7455,7 +7455,7 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
>  }
>  EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
>  
> -static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
> +static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, uint64_t flags)
>  {
>  	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>  	u32 insn_size = ctxt->fetch.end - ctxt->fetch.data;
> @@ -7466,7 +7466,8 @@ static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
>  	run->emulation_failure.ndata = 0;
>  	run->emulation_failure.flags = 0;
>  
> -	if (insn_size) {
> +	if (insn_size &&
> +	    (flags & KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES)) {
>  		run->emulation_failure.ndata = 3;
>  		run->emulation_failure.flags |=
>  			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
> @@ -7476,6 +7477,14 @@ static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
>  		memcpy(run->emulation_failure.insn_bytes,
>  		       ctxt->fetch.data, insn_size);
>  	}
> +
> +	if (flags & KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_REASON) {

This flag is always passed so this check if superfluous. Perhaps change
`int flags` to `bool instruction_bytes` and have it control only whether
the instruction bytes are populated.

> +		run->emulation_failure.ndata = 4;
> +		run->emulation_failure.flags |=
> +			KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_REASON;
> +		run->emulation_failure.exit_reason =
> +			static_call(kvm_x86_get_exit_reason)(vcpu);
> +	}
>  }
>  
>  static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
> @@ -7492,16 +7501,18 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>  
>  	if (kvm->arch.exit_on_emulation_error ||
>  	    (emulation_type & EMULTYPE_SKIP)) {
> -		prepare_emulation_failure_exit(vcpu);
> +		prepare_emulation_failure_exit(
> +			vcpu,
> +			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES |
> +			KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_REASON);
>  		return 0;
>  	}
>  
>  	kvm_queue_exception(vcpu, UD_VECTOR);
>  
>  	if (!is_guest_mode(vcpu) && static_call(kvm_x86_get_cpl)(vcpu) == 0) {
> -		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
> -		vcpu->run->internal.ndata = 0;
> +		prepare_emulation_failure_exit(
> +			vcpu, KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_REASON);

Should kvm_task_switch and kvm_handle_memory_failure also be updated
like this?

>  		return 0;
>  	}
>  
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 68c9e6d8bbda..3e4126652a67 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -282,6 +282,7 @@ struct kvm_xen_exit {
>  
>  /* Flags that describe what fields in emulation_failure hold valid data. */
>  #define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
> +#define KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_REASON       (1ULL << 1)
>  
>  /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
>  struct kvm_run {
> @@ -404,6 +405,7 @@ struct kvm_run {
>  			__u64 flags;
>  			__u8  insn_size;
>  			__u8  insn_bytes[15];
> +			__u64 exit_reason;

Please document what this field contains, especially since its contents
depend on AMD versus Intel.

>  		} emulation_failure;
>  		/* KVM_EXIT_OSI */
>  		struct {
> -- 
> 2.30.2
> 
