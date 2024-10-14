Return-Path: <kvm+bounces-28741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 48C6599C81A
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 13:06:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 058EA28AADC
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 11:06:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1EAD1C8781;
	Mon, 14 Oct 2024 11:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YqjMVw9o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266CE1C7B6D;
	Mon, 14 Oct 2024 11:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728903671; cv=none; b=JoBfNFZgN2W0V9o6k2pH8s4rqS9lFup9JA4n/08CSCBZ14eD6bhcl0XCaaKdrcaNJahCI67pd77MsFXxACG9e5u3fRwyMwDxR7BIFKaqx43gXzzwFqDS2D0C82qgX//54AoC9DjaP/qQuJlaFgJJUTrpjfV+36THzmg8KScjTAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728903671; c=relaxed/simple;
	bh=VO+r6Ewx+LV17n6Lo5kWv7GJJjlV20TqvmwHBbTNPbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzrvQa7WRZJGDxub8/joYtw1+xCFRQMRjQnZxovIpNnu1xnj6l16BwMgfy6TZdA5wAJK9MFA0K8kKnbMxD3DY/JmpzxVHv1Ej3Dz2FF3uIuYjm+IE2i4ct9DBXe0dBYb+/gt5plAkfw88bRgrmZmvtCafb5N7o0VXxk+vr5V8YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YqjMVw9o; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2fb4fa17044so7153321fa.3;
        Mon, 14 Oct 2024 04:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728903667; x=1729508467; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UtoAcPD6znXOqXZZiBOktqWMfLo4k+8wAuK79+XZwH4=;
        b=YqjMVw9oD30znahudhMKO5J8e0FmhgYPjbMDLCTqvqJnN9e8mqBIe2s/N3p/HVqi8b
         01SSAGa38p6XG+jz3u50LquK/ZX2/5Sb6TF/J89v5nnAH9+C+L0Wd6HYvzZ5UDO10cRJ
         LsQ7DZaoRDfPaogzmtEu4wZmqecVTYp9bWtE6QGyY1kcl5SVBJREvdGyEpB8hsCFNgIN
         vsjA3YpbRBrAkUSmkpq9PNstFD6apbudjxOTKuBWDKmdEQkKnbbAg89mkJ08+ri7YGbx
         kTvf9edhqIpxuQzqIkb7OcZOi9fFF9+bOkPZRo6EdrycNx6DhcNaNSAfFRSrP5Amuld1
         5WIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728903667; x=1729508467;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UtoAcPD6znXOqXZZiBOktqWMfLo4k+8wAuK79+XZwH4=;
        b=mXyvAcJww8H9jOzNV1oSJ40rTTMJUQ/IbCgBIB0ObmQgw6I67ZMk2rhfmmhOpImZb9
         G/8nUWZ/tJnr+sWQMIXzNOAC/+xnEgiH894h9ehM/RCZeNTeN4AaGkOdnj/qD1flwjeq
         w/wJIHaqQN2mm1CuZCgUOZCxOfSrdEUoT4IoTpXtVKMN04P9MEK6TvX/NPWUHhpwiyhr
         mlizzlX4kDEF4guqg9KVqZZiUU8uMEkVmlCnC9yyZio5nPGvlE143SXeead2/4KfAz6n
         +wqxImLgs1IVKKVUcpi/xyIiY3beUI+IEE84ytLqFSFRB1qUwzIgxok9bi+uz3UAEu4Z
         JmjQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEDUTM7L6/G9WV2zbOnmiRZEkgPTG/F8Fpvaf5wGyflY7hR6NpOSJVHo6stJwLWg8Ge+Y=@vger.kernel.org, AJvYcCWGATesK0Bu7b7V11sj3AYFLjIhLDJfpbmN7rn3Huh3QqIbCbIOML9eT2s5yBfK7mSTd8ORXoN1CSgQ5wFt@vger.kernel.org
X-Gm-Message-State: AOJu0YybOnc8bk4obRl72WeBvfGxsj0W3O/vgjFcvV+eWeoIbEWG6wjE
	H6OJEgnqp0WKT/TEyo/8J8FF0LNwL9ilbaNyickNFd+dqKP+02HZ
X-Google-Smtp-Source: AGHT+IGjhaW4VOgw2iKWoCqeazcy0hFF2PcaRGrgw4olWB1agg3VY7CyxkPt2oPcBUpgoWtrvlfy6A==
X-Received: by 2002:a2e:b8c6:0:b0:2fb:565a:d918 with SMTP id 38308e7fff4ca-2fb565adc3bmr8860101fa.12.1728903666789;
        Mon, 14 Oct 2024 04:01:06 -0700 (PDT)
Received: from localhost.localdomain (2001-14ba-7262-6300-c4b2-ca2a-c4e1-ab26.rev.dnainternet.fi. [2001:14ba:7262:6300:c4b2:ca2a:c4e1:ab26])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb2474c0c4sm14367201fa.101.2024.10.14.04.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 04:01:06 -0700 (PDT)
From: =?UTF-8?q?Markku=20Ahvenj=C3=A4rvi?= <mankku@gmail.com>
To: chao.gao@intel.com
Cc: bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	janne.karhunen@gmail.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mankku@gmail.com,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@linutronix.de,
	x86@kernel.org
Subject: Re: [PATCH 1/1] KVM: nVMX: update VPPR on vmlaunch/vmresume
Date: Mon, 14 Oct 2024 13:57:55 +0300
Message-ID: <20241014110039.11881-1-mankku@gmail.com>
X-Mailer: git-send-email 2.44.1
In-Reply-To: <ZwezvcaZJOg7A9el@intel.com>
References: <ZwezvcaZJOg7A9el@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Chao,

> The issue is that KVM does not properly update vmcs01's SVI. In this case, L1
> does not intercept EOI MSR writes from the deprivileged host (L2), so KVM
> emulates EOI writes by clearing the highest bit in vISR and updating vPPR.
> However, SVI in vmcs01 is not updated, causing it to retain the interrupt vector
> that was just EOI'd. On the next VM-entry to L1, the CPU performs PPR
> virtualization, setting vPPR to SVI & 0xf0, which results in an incorrect vPPR
> 
> Can you try this fix?

I tried, it also fixes the issue.

Thank you Chao, I really appreciate the explanation, it makes sense now.

> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4a93ac1b9be9..3d24194a648d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -122,6 +122,8 @@
>  #define KVM_REQ_HV_TLB_FLUSH \
>         KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE   KVM_ARCH_REQ(34)
> +#define KVM_REQ_UPDATE_HWAPIC_ISR \
> +       KVM_ARCH_REQ_FLAGS(35, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> 
>  #define CR0_RESERVED_BITS                                               \
>         (~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
> @@ -764,6 +766,7 @@ struct kvm_vcpu_arch {
>         u64 apic_base;
>         struct kvm_lapic *apic;    /* kernel irqchip context */
>         bool load_eoi_exitmap_pending;
> +       bool update_hwapic_isr;
>         DECLARE_BITMAP(ioapic_handled_vectors, 256);
>         unsigned long apic_attention;
>         int32_t apic_arb_prio;
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index b1eb46e26b2e..a8dad16161e4 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -220,6 +220,11 @@ static inline void leave_guest_mode(struct kvm_vcpu *vcpu)
>                 kvm_make_request(KVM_REQ_LOAD_EOI_EXITMAP, vcpu);
>         }
> 
> +       if (vcpu->arch.update_hwapic_isr) {
> +               vcpu->arch.update_hwapic_isr = false;
> +               kvm_make_request(KVM_REQ_UPDATE_HWAPIC_ISR, vcpu);
> +       }
> +
>         vcpu->stat.guest_mode = 0;
>  }
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 5bb481aefcbc..d6a03c30f085 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -800,6 +800,9 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
>         if (!__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
>                 return;
> 
> +       if (is_guest_mode(apic->vcpu))
> +               apic->vcpu->arch.update_hwapic_isr = true;
> +
>         /*
>          * We do get here for APIC virtualization enabled if the guest
>          * uses the Hyper-V APIC enlightenment.  In this case we may need
> @@ -3068,6 +3071,14 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>         return 0;
>  }
> 
> +void kvm_vcpu_update_hwapic_isr(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_lapic *apic = vcpu->arch.apic;
> +
> +       if (apic->apicv_active)
> +               kvm_x86_call(hwapic_isr_update)(apic_find_highest_isr(apic));
> +}
> +
>  void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
>  {
>         struct hrtimer *timer;
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 7ef8ae73e82d..ffa0c0e8bda9 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -266,6 +266,7 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu);
>  bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu);
>  void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu);
>  bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu);
> +void kvm_vcpu_update_hwapic_isr(struct kvm_vcpu *vcpu);
> 
>  static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
>  {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 34b52b49f5e6..d90add3fbe99 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10968,6 +10968,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  #endif
>                 if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
>                         kvm_vcpu_update_apicv(vcpu);
> +               if (kvm_check_request(KVM_REQ_UPDATE_HWAPIC_ISR, vcpu))
> +                       kvm_vcpu_update_hwapic_isr(vcpu);
>                 if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
>                         kvm_check_async_pf_completion(vcpu);
>                 if (kvm_check_request(KVM_REQ_MSR_FILTER_CHANGED, vcpu))

Kind regards,
Markku

