Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2E8C1DCA
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 11:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730227AbfI3JTR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 05:19:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42986 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729482AbfI3JTR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 05:19:17 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 504E590C99
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 09:19:16 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id i15so4225325wrx.12
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 02:19:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=IwAZzqjplrQ6Ca998AwdgObdBgvHGy0zwQC8Muha8lg=;
        b=LUFs+6aHjl4PAkvqtgwo9ONJj6JDdLW5tj0u7yCb8vcBnD462AKb4PfwX0QnvFY76U
         R3NNmbjNsDNWX+alemrK/7QRhg50XvOaS6JzgwXVP77wbPhYIqCr3HpbmDZM9f9QoO3U
         d51/3azBIhskYPOv8Km4yHbw+xiqtKWOpQ0qOMKz1zmdPU/NjnTfhFv8hxNEknc3f+I5
         Kzd4Ucr+V00QJ3lWFgsRhoIiNZ5kkL84C3FSdknHNLCwbfHJt6kEqd+sN+II6aOrS5uA
         f4aqZLQyDnykgA4me15eHZ8oJbXADrpkXLbCCpEijcO7rrA18Esq9bIVkC2qsS4g5TFO
         Almg==
X-Gm-Message-State: APjAAAVbYcS3+An88AdhLJShSBmxIB7nQoeAvQgGzMFE4m3DrJpTu1oH
        DL4/uKjk48hrPqHkALXpTp2NhnScR/cbkIHW1mWel02CM2PMk6OwOqJa9oZSCHiHeOsCG0olK9k
        +rI3DnCpaR6Fs
X-Received: by 2002:a5d:5048:: with SMTP id h8mr12170702wrt.280.1569835154770;
        Mon, 30 Sep 2019 02:19:14 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyHJx+hIB8v5jBbj8uoE2rcw1RmibEiBfeG04RCZ0NdKqommBABnNfyhKw3sg99rKkfpbkMiA==
X-Received: by 2002:a5d:5048:: with SMTP id h8mr12170677wrt.280.1569835154514;
        Mon, 30 Sep 2019 02:19:14 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id s10sm33119847wmf.48.2019.09.30.02.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 02:19:13 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v2 5/8] KVM: x86: Add WARNs to detect out-of-bounds register indices
In-Reply-To: <20190927214523.3376-6-sean.j.christopherson@intel.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com> <20190927214523.3376-6-sean.j.christopherson@intel.com>
Date:   Mon, 30 Sep 2019 11:19:12 +0200
Message-ID: <87k19q3zvz.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Add WARN_ON_ONCE() checks in kvm_register_{read,write}() to detect reg
> values that would cause KVM to overflow vcpu->arch.regs.  Change the reg
> param to an 'int' to make it clear that the reg index is unverified.
>

Hm, on multiple occasions I was thinking "an enum would do better here
but whatever" but maybe 'int' was there on purpose? Interesting... :-)

> Open code the RIP and RSP accessors so as to avoid pointless overhead of
> WARN_ON_ONCE().  Alternatively, lower-level helpers could be provided,
> but that opens the door for improper use of said helpers, and the
> ugliness of the open-coding will be slightly improved in future patches.
>
> Regarding the overhead of WARN_ON_ONCE(), now that all fixed GPR reads
> and writes use dedicated accessors, e.g. kvm_rax_read(), the overhead
> is limited to flows where the reg index is generated at runtime.  And
> there is at least one historical bug where KVM has generated an out-of-
> bounds access to arch.regs (see commit b68f3cc7d9789, "KVM: x86: Always
> use 32-bit SMRAM save state for 32-bit kernels").
>
> Adding the WARN_ON_ONCE() protection paves the way for additional
> cleanup related to kvm_reg and kvm_reg_ex.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/kvm_cache_regs.h | 30 ++++++++++++++++++++++--------
>  arch/x86/kvm/x86.h            |  6 ++----
>  2 files changed, 24 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index 1cc6c47dc77e..3972e1b65635 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -37,19 +37,23 @@ BUILD_KVM_GPR_ACCESSORS(r14, R14)
>  BUILD_KVM_GPR_ACCESSORS(r15, R15)
>  #endif
>  
> -static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu,
> -					      enum kvm_reg reg)
> +static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu, int reg)
>  {
> +	if (WARN_ON_ONCE((unsigned int)reg >= NR_VCPU_REGS))
> +		return 0;
> +

(I'm just trying to think outside of the box) when this WARN fires it
means we have a bug in KVM but replacing this with BUG_ON() is probably
not justified (like other VMs on the host may be doing all
right). Propagating (and checking) errors from every such place is
probably too cumbersome so what if we introduce a flag "emit
KVM_INTERNAL_ERROR and kill the VM ASAP" and check it before launching
vCPU again? The goal is to not allow the VM to proceed because its state
is definitely invalid.

>  	if (!test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail))
>  		kvm_x86_ops->cache_reg(vcpu, reg);
>  
>  	return vcpu->arch.regs[reg];
>  }
>  
> -static inline void kvm_register_write(struct kvm_vcpu *vcpu,
> -				      enum kvm_reg reg,
> +static inline void kvm_register_write(struct kvm_vcpu *vcpu, int reg,
>  				      unsigned long val)
>  {
> +	if (WARN_ON_ONCE((unsigned int)reg >= NR_VCPU_REGS))
> +		return;
> +
>  	vcpu->arch.regs[reg] = val;
>  	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
>  	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
> @@ -57,22 +61,32 @@ static inline void kvm_register_write(struct kvm_vcpu *vcpu,
>  
>  static inline unsigned long kvm_rip_read(struct kvm_vcpu *vcpu)
>  {
> -	return kvm_register_read(vcpu, VCPU_REGS_RIP);
> +	if (!test_bit(VCPU_REGS_RIP, (unsigned long *)&vcpu->arch.regs_avail))
> +		kvm_x86_ops->cache_reg(vcpu, VCPU_REGS_RIP);
> +
> +	return vcpu->arch.regs[VCPU_REGS_RIP];
>  }
>  
>  static inline void kvm_rip_write(struct kvm_vcpu *vcpu, unsigned long val)
>  {
> -	kvm_register_write(vcpu, VCPU_REGS_RIP, val);
> +	vcpu->arch.regs[VCPU_REGS_RIP] = val;
> +	__set_bit(VCPU_REGS_RIP, (unsigned long *)&vcpu->arch.regs_dirty);
> +	__set_bit(VCPU_REGS_RIP, (unsigned long *)&vcpu->arch.regs_avail);
>  }
>  
>  static inline unsigned long kvm_rsp_read(struct kvm_vcpu *vcpu)
>  {
> -	return kvm_register_read(vcpu, VCPU_REGS_RSP);
> +	if (!test_bit(VCPU_REGS_RSP, (unsigned long *)&vcpu->arch.regs_avail))
> +		kvm_x86_ops->cache_reg(vcpu, VCPU_REGS_RSP);
> +
> +	return vcpu->arch.regs[VCPU_REGS_RSP];
>  }
>  
>  static inline void kvm_rsp_write(struct kvm_vcpu *vcpu, unsigned long val)
>  {
> -	kvm_register_write(vcpu, VCPU_REGS_RSP, val);
> +	vcpu->arch.regs[VCPU_REGS_RSP] = val;
> +	__set_bit(VCPU_REGS_RSP, (unsigned long *)&vcpu->arch.regs_dirty);
> +	__set_bit(VCPU_REGS_RSP, (unsigned long *)&vcpu->arch.regs_avail);
>  }
>  
>  static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index dbf7442a822b..45d82b8277e5 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -238,8 +238,7 @@ static inline bool vcpu_match_mmio_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
>  	return false;
>  }
>  
> -static inline unsigned long kvm_register_readl(struct kvm_vcpu *vcpu,
> -					       enum kvm_reg reg)
> +static inline unsigned long kvm_register_readl(struct kvm_vcpu *vcpu, int reg)
>  {
>  	unsigned long val = kvm_register_read(vcpu, reg);
>  
> @@ -247,8 +246,7 @@ static inline unsigned long kvm_register_readl(struct kvm_vcpu *vcpu,
>  }
>  
>  static inline void kvm_register_writel(struct kvm_vcpu *vcpu,
> -				       enum kvm_reg reg,
> -				       unsigned long val)
> +				       int reg, unsigned long val)
>  {
>  	if (!is_64_bit_mode(vcpu))
>  		val = (u32)val;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly
