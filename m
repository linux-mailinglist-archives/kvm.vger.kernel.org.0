Return-Path: <kvm+bounces-57211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4836EB51EBA
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 19:18:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02D99A005B6
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 17:18:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EB2230C61A;
	Wed, 10 Sep 2025 17:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MvIWxGb6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CFC23BCEF
	for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 17:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757524679; cv=none; b=R/3FoB7MtfXrLaWBsokhlGHn9UYfYuuMmITuvJrS7pX5PUMctzffQVxjbmBa3iqoA+4n15Zj0daKHxljIVarBUMOsrDyNRT755FB/2AG0AE+D5qBlAHGhe0unXcmAFsYIFhZPT5eWR5y927j+s2mMCFo+Yvdco5TVxV7OXAHUzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757524679; c=relaxed/simple;
	bh=PgIxU6HxGjxJFnhHkkcIM4U0CRWvbE3Zo8jghpXps1g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QFNeZ7rFu3u6K0b6XVDpyU3hjBcybphKuFhMV3pPi2XPwc4mr/cy1C70R/1D816MTpn3T2XwB158Mo5XQ2gnu1/9QjOpHWzNlidgjoZVE+cuelzKMfenMqSRqOcXuR8/cpiJsN/et6t781JA9b5G3qKYU7f7P2qStN6ySA3kGYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MvIWxGb6; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24b0e137484so60220305ad.0
        for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 10:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757524677; x=1758129477; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ewK5ux8kVgVo01EbJepvYu9t1k7WNG6QakFU4KXSnBc=;
        b=MvIWxGb6NbNF5KBgSCSbdzL6t7i6MouDCEfj5FLy1bQABkTGXAlkvm3Zki2JsZ/SNO
         ysgzXGYE9VJDMzc7i+0oz5tgXbQzVPCU0xxTS/TTcgH+1329JUbmrsLAZt7IGn1LGo+D
         h6OgT6uluKYkEQNUjDf0vQef+FcmB28QHcscrDqGFZlBwsN0iIn9YR1RPFxv7WftzWaO
         21Y9W/OLX9ZbtEEpxp6+c5px7l8hcpLltCH2uyLBmeuOYQBSww8LspX9xkjbGRxM5com
         SzbfA/zvOg3LqFbVYh53kGNeViuBnaLaUW0k5dXJ3QKyIHThtlIadIkvqciGk62iVLrT
         nJ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757524677; x=1758129477;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ewK5ux8kVgVo01EbJepvYu9t1k7WNG6QakFU4KXSnBc=;
        b=jFrjg/QOuL+KK9+TSVDV9GXXakPrMwTHPbV0oJ1Kf+DVihZhZ5L1SqtEiGFnHRWawe
         reKg65i54OMC5/eMfLDEE1TfoZ9oF2CZFjoVLueDWjfGXqLlu+v2E19vmD2V/NwJ5lAF
         iCXGn1VusKsTwmUZgnaesKIsIS7uACkAnHxZFWvo+ncUsEEiTx4rcaWwZttShITX9pS3
         ichY0z5BeorDJRJSNPs/KBCDknWOH1ev10kt42j10MiOxK1qjfcRj96F9ALq5AwuQ2x3
         uuz3MYBPO9k1PkGmQyUhfoq4Jw2pflvWVQuuNvcIERy34A5qAV5+fM8H1X2fxqlAhTaZ
         sjZQ==
X-Gm-Message-State: AOJu0YxHCUh/EgNc+GsOgvB68xXPvk41hrZJA8uEBVJ+fB0XrnBriupm
	YCQp1j9pg4UrQrIyAcN6o+ZFOsQwtb8VAJAf8P+dT9R18qYh87SN7dx0jnFV272hWmCXB502Z+0
	XjAFJzw==
X-Google-Smtp-Source: AGHT+IFZtQBBzexcP4QMpOCpPZPy4urzKXIL+qxHVIb84NJY5TDb2iChlS1MuK3DF8izCt7K8atw/7uy7V4=
X-Received: from plbkr3.prod.google.com ([2002:a17:903:803:b0:240:33b6:5880])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d48e:b0:24e:e5c9:ed0c
 with SMTP id d9443c01a7336-25173308a06mr218680595ad.43.1757524676973; Wed, 10
 Sep 2025 10:17:56 -0700 (PDT)
Date: Wed, 10 Sep 2025 10:17:55 -0700
In-Reply-To: <20250909093953.202028-2-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250909093953.202028-1-chao.gao@intel.com> <20250909093953.202028-2-chao.gao@intel.com>
Message-ID: <aMGyw1B7Cw_xHjh3@google.com>
Subject: Re: [PATCH v14 01/22] KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs support
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, john.allen@amd.com, 
	mingo@kernel.org, mingo@redhat.com, minipli@grsecurity.net, 
	mlevitsk@redhat.com, namhyung@kernel.org, pbonzini@redhat.com, 
	prsampat@amd.com, rick.p.edgecombe@intel.com, shuah@kernel.org, 
	tglx@linutronix.de, weijiang.yang@intel.com, x86@kernel.org, xin@zytor.com, 
	xiaoyao.li@intel.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 09, 2025, Chao Gao wrote:
> +static int kvm_set_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *value)
> +{
> +	u64 val;
> +
> +	if (get_user(val, value))
> +		return -EFAULT;
> +
> +	return do_set_msr(vcpu, msr, &val);

This needs to explicitly return -EINVAL on failure, otherwise KVM will return
semi-arbitrary positive values to userspace.

> +}
> +
>  #ifdef CONFIG_X86_64
>  struct pvclock_clock {
>  	int vclock_mode;
> @@ -4737,6 +4762,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_IRQFD_RESAMPLE:
>  	case KVM_CAP_MEMORY_FAULT_INFO:
>  	case KVM_CAP_X86_GUEST_MODE:
> +	case KVM_CAP_ONE_REG:

We should add (partial) support for KVM_GET_REG_LIST, otherwise the ABI for
handling GUEST_SSP is effectively undefined.  And because the ioctl is per-vCPU,
utilizing KVM_GET_REG_LIST gives us the opportunity to avoid the horrors we
created with KVM_GET_MSR_INDEX_LIST, where KVM enumerates MSRs that aren't fully
supported by the vCPU.

If we don't enumerate GUEST_SSP via KVM_GET_REG_LIST, then trying to do
KVM_{G,S}ET_ONE_REG will "unexpectedly" fail if the vCPU doesn't have SHSTK.
By enumerating GUEST_SSP in KVM_GET_REG_LIST _if and only if_ it's fully supported,
we'll have a much more explicit ABI than we do for MSRs.  And if we don't do that,
we'd have to special case MSR_KVM_INTERNAL_GUEST_SSP in kvm_is_advertised_msr().

As for MSRs, that's where "partial" support comes in.  For MSRs, I think the least
awful option is to keep using KVM_GET_MSR_INDEX_LIST for enumerating MSRs, and
document that any MSRs that can be accessed via KVM_{G,S}ET_MSRS can be accessed
via KVM_{G,S}ET_ONE_REG.  That avoids having to bake in different behavior for
MSR vs. ONE_REG accesses (and avoids having to add a pile of code to precisely
enumerate support for per-vCPU MSRs).

>  		r = 1;
>  		break;
>  	case KVM_CAP_PRE_FAULT_MEMORY:
> @@ -5915,6 +5941,20 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> +struct kvm_x86_reg_id {
> +	__u32 index;
> +	__u8  type;
> +	__u8  rsvd1;
> +	__u8  rsvd2:4;
> +	__u8  size:4;
> +	__u8  x86;
> +};
> +
> +static int kvm_translate_kvm_reg(struct kvm_x86_reg_id *reg)
> +{
> +	return -EINVAL;
> +}
> +
>  long kvm_arch_vcpu_ioctl(struct file *filp,
>  			 unsigned int ioctl, unsigned long arg)
>  {
> @@ -6031,6 +6071,44 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  		srcu_read_unlock(&vcpu->kvm->srcu, idx);
>  		break;
>  	}
> +	case KVM_GET_ONE_REG:
> +	case KVM_SET_ONE_REG: {
> +		struct kvm_x86_reg_id *id;
> +		struct kvm_one_reg reg;
> +		u64 __user *value;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&reg, argp, sizeof(reg)))
> +			break;
> +
> +		r = -EINVAL;
> +		if ((reg.id & KVM_REG_ARCH_MASK) != KVM_REG_X86)
> +			break;
> +
> +		id = (struct kvm_x86_reg_id *)&reg.id;
> +		if (id->rsvd1 || id->rsvd2)
> +			break;
> +
> +		if (id->type == KVM_X86_REG_TYPE_KVM) {
> +			r = kvm_translate_kvm_reg(id);
> +			if (r)
> +				break;
> +		}
> +
> +		r = -EINVAL;
> +		if (id->type != KVM_X86_REG_TYPE_MSR)
> +			break;
> +
> +		if ((reg.id & KVM_REG_SIZE_MASK) != KVM_REG_SIZE_U64)
> +			break;
> +
> +		value = u64_to_user_ptr(reg.addr);
> +		if (ioctl == KVM_GET_ONE_REG)
> +			r = kvm_get_one_msr(vcpu, id->index, value);
> +		else
> +			r = kvm_set_one_msr(vcpu, id->index, value);
> +		break;
> +	}

I think it makes sense to put this in a separate helper, if only so that the
error returns are more obvious.


>  	case KVM_TPR_ACCESS_REPORTING: {
>  		struct kvm_tpr_access_ctl tac;
>  
> -- 
> 2.47.3
> 

