Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1771705B7
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 18:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgBZRNC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 12:13:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21567 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726063AbgBZRNC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 12:13:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582737181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tnpfXdQjYrBFaS792nY8i0wuvTcJOpHnYH5FAirUsUY=;
        b=ceEmj1shrEC6AdZNtMLmii/otGOKTKvKbLpCZgLaaE3CNVGykFnhrFBknjViXyBtTY9Kqw
        uLJQbtO0KmY9OrFo/5/g4nSIRgZHxRYDiDz6R7qm2JlnQ/vtS49MNAGnXddY4fJ9/WYwZB
        YJ5qetv6eteVv/AB4QYY0qjIOIU3uv0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-CRV4tKkbP3GctwB2jSgLVw-1; Wed, 26 Feb 2020 12:11:28 -0500
X-MC-Unique: CRV4tKkbP3GctwB2jSgLVw-1
Received: by mail-wm1-f70.google.com with SMTP id f9so788584wmb.2
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 09:11:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=tnpfXdQjYrBFaS792nY8i0wuvTcJOpHnYH5FAirUsUY=;
        b=L/fLIEfzwzIiXVqc3678eIQ8K9dlW0YMu1VeNMh+fMqOtyRcs6ZR5rvWqKuQcKDjpB
         HyW5i9PJ8q5NQwim+v/jG2b8NsLYNmko/7ah5R18RUezRegLHe1sTUwloGLnIompAIfG
         VZP0n4llqqBT+s+HRgRB6jjILI5ldVxMUM2pYady61ajFT16D+SS15yv2U+wBEVpwZdk
         02Mhh7IsxW2tfFSvHEOH9Eu37BOQVqkMHl5RacVbRaZpT1ksmmrfx9Bk6z5+V5Q3mNgl
         m91JsZwFWbD+B2ymIdMnd28ONgOewl77Ff42ZX44ha73wTCBjUB1QUhz99vYQYicN8zL
         ZIMA==
X-Gm-Message-State: APjAAAXSdPfLfttaJZi/8T656jsv7GMawgrkDJR3PwvxrOcONXpV1M90
        KVpufWOEy/g4fZPmgG4flUoSSSmqmdRat+rL0MqVbJr6tZbX26Q1YRM5cOJ0yOGJ4JubmmEsnz9
        EAaNgd4UCAlOL
X-Received: by 2002:adf:fc85:: with SMTP id g5mr6506226wrr.52.1582737087346;
        Wed, 26 Feb 2020 09:11:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqw+99mQIMnTdmvz4jq3L9yXHiV5BgK+YifebeHL+ho8XsMql1sUyO5bD1gtgRpfoxojajGT4Q==
X-Received: by 2002:adf:fc85:: with SMTP id g5mr6506204wrr.52.1582737087099;
        Wed, 26 Feb 2020 09:11:27 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id j16sm4089259wru.68.2020.02.26.09.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 09:11:26 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/13] KVM: x86: Refactor emulate tracepoint to explicitly take context
In-Reply-To: <20200218232953.5724-7-sean.j.christopherson@intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com> <20200218232953.5724-7-sean.j.christopherson@intel.com>
Date:   Wed, 26 Feb 2020 18:11:25 +0100
Message-ID: <8736axjmte.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Explicitly pass the emulation context to the emulate tracepoint in
> preparation of dynamically allocation the emulation context.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/trace.h | 22 +++++++++++-----------
>  arch/x86/kvm/x86.c   | 13 ++++++++-----
>  2 files changed, 19 insertions(+), 16 deletions(-)
>
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index f194dd058470..5605000ca5f6 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -731,8 +731,9 @@ TRACE_EVENT(kvm_skinit,
>  	})
>  
>  TRACE_EVENT(kvm_emulate_insn,
> -	TP_PROTO(struct kvm_vcpu *vcpu, __u8 failed),
> -	TP_ARGS(vcpu, failed),
> +	TP_PROTO(struct kvm_vcpu *vcpu, struct x86_emulate_ctxt *ctxt,
> +		 __u8 failed),
> +	TP_ARGS(vcpu, ctxt, failed),
>  
>  	TP_STRUCT__entry(
>  		__field(    __u64, rip                       )
> @@ -745,13 +746,10 @@ TRACE_EVENT(kvm_emulate_insn,
>  
>  	TP_fast_assign(
>  		__entry->csbase = kvm_x86_ops->get_segment_base(vcpu, VCPU_SREG_CS);

This seems the only usage of 'vcpu' parameter now; I checked and even
after switching to dynamic emulation context allocation we still set
ctxt->vcpu in alloc_emulate_ctxt(), can we get rid of 'vcpu' parameter
here then (and use ctxt->vcpu instead)?

> -		__entry->len = vcpu->arch.emulate_ctxt.fetch.ptr
> -			       - vcpu->arch.emulate_ctxt.fetch.data;
> -		__entry->rip = vcpu->arch.emulate_ctxt._eip - __entry->len;
> -		memcpy(__entry->insn,
> -		       vcpu->arch.emulate_ctxt.fetch.data,
> -		       15);
> -		__entry->flags = kei_decode_mode(vcpu->arch.emulate_ctxt.mode);
> +		__entry->len = ctxt->fetch.ptr - ctxt->fetch.data;
> +		__entry->rip = ctxt->_eip - __entry->len;
> +		memcpy(__entry->insn, ctxt->fetch.data, 15);
> +		__entry->flags = kei_decode_mode(ctxt->mode);
>  		__entry->failed = failed;
>  		),
>  
> @@ -764,8 +762,10 @@ TRACE_EVENT(kvm_emulate_insn,
>  		)
>  	);
>  
> -#define trace_kvm_emulate_insn_start(vcpu) trace_kvm_emulate_insn(vcpu, 0)
> -#define trace_kvm_emulate_insn_failed(vcpu) trace_kvm_emulate_insn(vcpu, 1)
> +#define trace_kvm_emulate_insn_start(vcpu, ctxt)	\
> +	trace_kvm_emulate_insn(vcpu, ctxt, 0)
> +#define trace_kvm_emulate_insn_failed(vcpu, ctxt)	\
> +	trace_kvm_emulate_insn(vcpu, ctxt, 1)
>  
>  TRACE_EVENT(
>  	vcpu_match_mmio,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 79d1113ad6e7..69d3dd64d90c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6460,10 +6460,13 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
>  }
>  EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
>  
> -static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
> +static int handle_emulation_failure(struct x86_emulate_ctxt *ctxt,
> +				    int emulation_type)
>  {
> +	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
> +
>  	++vcpu->stat.insn_emulation_fail;
> -	trace_kvm_emulate_insn_failed(vcpu);
> +	trace_kvm_emulate_insn_failed(vcpu, ctxt);
>  
>  	if (emulation_type & EMULTYPE_VMWARE_GP) {
>  		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> @@ -6788,7 +6791,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  
>  		r = x86_decode_insn(ctxt, insn, insn_len);
>  
> -		trace_kvm_emulate_insn_start(vcpu);
> +		trace_kvm_emulate_insn_start(vcpu, ctxt);
>  		++vcpu->stat.insn_emulation;
>  		if (r != EMULATION_OK)  {
>  			if ((emulation_type & EMULTYPE_TRAP_UD) ||
> @@ -6810,7 +6813,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  				inject_emulated_exception(ctxt);
>  				return 1;
>  			}
> -			return handle_emulation_failure(vcpu, emulation_type);
> +			return handle_emulation_failure(ctxt, emulation_type);
>  		}
>  	}
>  
> @@ -6856,7 +6859,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  					emulation_type))
>  			return 1;
>  
> -		return handle_emulation_failure(vcpu, emulation_type);
> +		return handle_emulation_failure(ctxt, emulation_type);
>  	}
>  
>  	if (ctxt->have_exception) {

-- 
Vitaly

