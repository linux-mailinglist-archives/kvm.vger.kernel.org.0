Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A007667E4CA
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 13:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbjA0MMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 07:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbjA0MMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 07:12:16 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F2791FB5
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 04:06:38 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id f19-20020a1c6a13000000b003db0ef4dedcso5258470wmc.4
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 04:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=49P4rU1OzCSfjhkjXu4Djle+ur0lA/pLRqdrOGEuDgQ=;
        b=RpNA9MFp0CVU4HeiQyETkfPOMTkObZr4wIbIXq7wmA6CTp03Z8EAd2089ySge5EERH
         ZjZ9fN0BmIlhq0yDS6k/3Mm5XMV7qOsZ2EMRJSauB5sMxm96GgMjMYN+v4tLHl1E8Zvh
         AmjTYt6adeiFzgPF4HnIH0BnzbEaLjScnhM8mtCqKSru6M0DdXIJsoc77IL+VpgMRyX0
         mf0TpKlnmi4l8EHyv1ltaU5Dn8DNprra0RhdTMm5KcgGUuesLhhDPj7OBapsAbxBKEij
         5+sO6qHjE5iY/nqcJRr2q14Ye3qc2t/nP2LnXHfMf0V+jeRAMbdzEn8rN78D8z+kvn3t
         4kGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=49P4rU1OzCSfjhkjXu4Djle+ur0lA/pLRqdrOGEuDgQ=;
        b=3kXhlmdHu0bNuy1VpF/a3W2Qs4rzE0VsiMgfpM10yAd9gVGKKC3B+2sMDGSwB1a8Ws
         0z3c00xgnmtJCGmewxpiNUt0cWmKXMr/Bu9jwHmJ8QL4LHz5ubfcEBBpUOu3WET0FUse
         YOvIV0K/5StK6eCa1RHAdkm4xl4zJgVdihTBCxZZr1iXdbjP64YQ+Z2eiOJkg3s5Zkaf
         ZKnkapQ8TeHjBzLm1V4BW31g58jeMMM9k6WJFiM86KDIaJhZBKY4jX8u+iomHNEpHzFA
         vMsiOJg47qRXlcMVAhHs1jBxCs+WQuWq8LGMaXQNIW4+q8GJsjbkNfFrm7owkc0UL12s
         ovhA==
X-Gm-Message-State: AFqh2koYC6UXtIMSdBCDfnPKLsU7YeJqWgzzS0gAYQcuqUYFTM1u7FaS
        mVW4SjlK5nQp5DSvYOWC3o8pXA==
X-Google-Smtp-Source: AMrXdXs5aFUhbmFjfKKDdPy0q2p6XQ4Qc5rB9l6xXkdXza417yI4JKDkS8vG3qPezgNlK6cM1LBxIw==
X-Received: by 2002:a05:600c:3488:b0:3d2:370b:97f4 with SMTP id a8-20020a05600c348800b003d2370b97f4mr47051577wmq.16.1674821140277;
        Fri, 27 Jan 2023 04:05:40 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c05c800b003c65c9a36dfsm4010664wmd.48.2023.01.27.04.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 04:05:39 -0800 (PST)
Date:   Fri, 27 Jan 2023 13:05:39 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Andy Chiu <andy.chiu@sifive.com>
Subject: Re: [PATCH v2] RISC-V: KVM: Redirect illegal instruction traps to
 guest
Message-ID: <20230127120539.nzbdoli7ahmenjmx@orel>
References: <20230127112934.2749592-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127112934.2749592-1-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 04:59:34PM +0530, Anup Patel wrote:
> From: Andy Chiu <andy.chiu@sifive.com>
> 
> The M-mode redirects an unhandled illegal instruction trap back
> to S-mode. However, KVM running in HS-mode terminates the VS-mode
> software when it receives illegal instruction trap. Instead, KVM
> should redirect the illegal instruction trap back to VS-mode, and
> let VS-mode trap handler decide the next step. This futher allows
> guest kernel to implement on-demand enabling of vector extension
> for a guest user space process upon first-use.
> 
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu_exit.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index c9f741ab26f5..4ea101a73d8b 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -160,6 +160,9 @@ void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
>  
>  	/* Set Guest PC to Guest exception vector */
>  	vcpu->arch.guest_context.sepc = csr_read(CSR_VSTVEC);
> +
> +	/* Set Guest privilege mode to supervisor */
> +	vcpu->arch.guest_context.sstatus |= SR_SPP;

This could/should be a separate fix patch, right?

>  }
>  
>  /*
> @@ -179,6 +182,12 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  	ret = -EFAULT;
>  	run->exit_reason = KVM_EXIT_UNKNOWN;
>  	switch (trap->scause) {
> +	case EXC_INST_ILLEGAL:
> +		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV) {
> +			kvm_riscv_vcpu_trap_redirect(vcpu, trap);
> +			ret = 1;
> +		}
> +		break;
>  	case EXC_VIRTUAL_INST_FAULT:
>  		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
>  			ret = kvm_riscv_vcpu_virtual_insn(vcpu, run, trap);
> -- 
> 2.34.1
>

Otherwise,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew
