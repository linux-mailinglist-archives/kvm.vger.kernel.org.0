Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62194624674
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 17:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiKJQAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 11:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbiKJP7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 10:59:52 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB8023161
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 07:59:51 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id z26so2597089pff.1
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 07:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nqwSu+K2PybbSgpn8Y7QHJiQKJdAIFzkIZyW5su/t+4=;
        b=VVuz3qgMndo0A4mFwxpy/+Qaokax8DHr3XSLae5qcm9WqZ2QkIqg+r7g7KxXu+qhVj
         On14htmWAw3Fc+UQt1XDtSP+1h1zGtcKSPJptTd+B+2QeocS4ngfv8ElApYrS3v/k2k8
         Zfm2Ng/J0YDwZluG6KT/D9I//bhDu8cJRMa21Gzj/Q9kNjY7ZMACr5QnQsF7N2pLzI2H
         Fgdyyi3btEx4X+JEzCzrngaYPWC1H/2RP5AfF29SeVi8hK3Tm38B/cfZ+BTvlC1IcpJD
         yeYzq0sRmsAMDA8DMP5wfPxU43wZ40mpvSKJ6HhViaTIKR1botR9X1/V+JESGKOxqG6O
         tugA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nqwSu+K2PybbSgpn8Y7QHJiQKJdAIFzkIZyW5su/t+4=;
        b=Wt6sjfQnxamqeBRtUXYU+4CMi08Fa6JPCbVwxfaKyQCGvYjPJh9eoDHBtrKtSBq/qY
         1aO3z7Gu45pm6VBtDm7zXPrEs43D/BjdyYgnOACqSmzWY41ZBkvyInqFEiSWbaI3wGFW
         tDglXIbjArV5G9WXgk8sb9WSTzp8u3l1kGpZE4ll7DF0eR6HFNQCUlB2wy77pMBEZWqI
         cq4WDVtaAiYDJzQKF9zxZ/IhCksbVtRyOD5iJKLGLzyRjJjulIh/4Ia/Qri98gS2t0Lx
         PWy7PrPXfu267DjZ8BmB9BttCCZ5bmmQVJPxPhddxdhQLOfzT1VgP5uLDIS9b3yhCnKI
         QIwA==
X-Gm-Message-State: ACrzQf17psDsSKM5B5/LvUQHT/iGnAOBVyf0BpJi05eGbHExjrkByPtR
        nAfXYLmtIctlOH48cl7yqBHM6g==
X-Google-Smtp-Source: AMsMyM78RwPR7L7XREBj4BO7qcJJZvtKkqJGMTNnCkljSOaf6Ucf3FG0rQ1LKe/543GJuOwudLNAcg==
X-Received: by 2002:aa7:9e04:0:b0:56b:fe1d:5735 with SMTP id y4-20020aa79e04000000b0056bfe1d5735mr2825314pfq.24.1668095990640;
        Thu, 10 Nov 2022 07:59:50 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j12-20020a170902da8c00b0017eb2d62bbesm11503285plx.99.2022.11.10.07.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 07:59:50 -0800 (PST)
Date:   Thu, 10 Nov 2022 15:59:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernnel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, pbonzini@redhat.com,
        kevin.tian@intel.com
Subject: Re: [PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq() for
 NMI/IRQ reinjection
Message-ID: <Y20f8v9ObO+IPwU+@google.com>
References: <20221110055347.7463-1-xin3.li@intel.com>
 <20221110055347.7463-6-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110055347.7463-6-xin3.li@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022, Xin Li wrote:
> +#if IS_ENABLED(CONFIG_KVM_INTEL)
> +/*
> + * KVM VMX reinjects NMI/IRQ on its current stack, it's a sync

Please use a verb other than "reinject".  There is no event injection of any kind,
KVM is simply making a function call.  KVM already uses "inject" and "reinject"
for KVM where KVM is is literally injecting events into the guest.

The "kvm_vmx" part is also weird IMO.  The function is in x86's traps/exceptions
namespace, not the KVM VMX namespace.

Maybe exc_raise_nmi_or_irq()?

> + * call thus the values in the pt_regs structure are not used in
> + * executing NMI/IRQ handlers,

Won't this break stack traces to some extent?

> +static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu, u32 vector)
>  {
> -	bool is_nmi = entry == (unsigned long)asm_exc_nmi_noist;
> -
> -	kvm_before_interrupt(vcpu, is_nmi ? KVM_HANDLING_NMI : KVM_HANDLING_IRQ);
> -	vmx_do_interrupt_nmi_irqoff(entry);
> +	kvm_before_interrupt(vcpu, vector == NMI_VECTOR ?
> +				   KVM_HANDLING_NMI : KVM_HANDLING_IRQ);
> +	kvm_vmx_reinject_nmi_irq(vector);

This is where I strongly object to kvm_vmx_reinject_nmi_irq().  This looks like
KVM is reinjecting the event into the guest, which is all kinds of confusing.

>  	kvm_after_interrupt(vcpu);
>  }
