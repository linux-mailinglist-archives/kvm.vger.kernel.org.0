Return-Path: <kvm+bounces-57215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9124DB51F0A
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 19:36:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C9B787B6363
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 17:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8DC4327A3C;
	Wed, 10 Sep 2025 17:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X4PAFdCY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708CB25B1C7
	for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 17:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757525748; cv=none; b=EIYt9py2FM2QohcBIq8FBIMsnNg2uYSi/yceIwf3LxzfsI9yOaDWNcg1SAnEelKf4tSx/Ti92nLU7Mi21tVFplC9FeNAMQZ4PHZjTWqVDwxwNKjRrhcU/BzST5fyUREwmZyz8NI2WJvhDnbJ213tjOctWi5YPGSWU4G/6LdTWIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757525748; c=relaxed/simple;
	bh=loP8HPZivD7ACH7V0w4NocLfwXke5eDWmuUP7xIp2Z8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PLjbU/L324VdjjAjI9kCWtHlyk0EJQsHQJt5ZpVZhXEXGr5dGpOsk55jst3o7cxbOywy7pLkQYsij/QUPkqBjow9rV7QDoyu8u5kt7d15vspXfY38v9q5b7aYWb18EzswoEGBQuVM+KXxit4pFnur+pATdVhfxw0Eg7UwyLG17g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X4PAFdCY; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4d7b23ad44so4388115a12.0
        for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 10:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757525747; x=1758130547; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iO/ZsYGSbIMx/Phc3/cDa0lxkPb1F9j/LU0uE5Fnnto=;
        b=X4PAFdCYSl1/pZxIDqzNV6WvD4AB03G2FCsW5G1WONJaEBhA2KivgPiNCBn+1TKcma
         Qaqg1Y+l7jNeNuvrAricI6/io4os7NJyndt2uYzrd2BUwHidg7pWm10VfVgAgh9Rej7w
         6KVLxUBBoAZrs9y7GAm34p9UNNvTQqK2ra8P2Nh2WO0DHhOqRChtEN7dGQtDIQALP5Eq
         gZ/JwGB0uKNpdIrvaMj5pEyAmQxu9Uumj0eCmqci8Aqu13uoXTVL9F2r33vYuZOPx+fK
         h38bMAf2PJgg+d2J3TcVrlTDK2k+T24wr7k8oDAjkVfbU6ciw3J363mufGUS8fUbboJL
         HMSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757525747; x=1758130547;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iO/ZsYGSbIMx/Phc3/cDa0lxkPb1F9j/LU0uE5Fnnto=;
        b=Rp2KBsinrtlwGkdT+SozUecHYhNEtEusjRNr19BHMUcMRaEMAwrEXhEBG/5hp0R4k4
         U8cjIST+6Mj63nE/4wlAiE1HDzeD4W8eeqQepF3rHVx3P4Hpi+DH/Hmc7NB6l2rcr31U
         fE6YAzy0JFLRJDzXIj19C9DG7lII0J5F/6O6E3Re4uD1SYdfMHjJQeRrDRQwoum5pwD7
         3IjKmmRz/5TY3HG9nKDb/UC1lRxZbrpp6a7vf+vLwqxl/uPKYMHxnDYnEGxP8K39jBtM
         lFVt/hVBgEKV3dpo9Rnwxdtg05PP2LbIRXA0y1P7i3uQe+3QfQYeRDPSeRyTF+WZD8OX
         2krg==
X-Gm-Message-State: AOJu0Ywv8LJNvuDsoPlqJ+m42ua4DiLjCvUVCXvX2sAkKnBMwua4FAu3
	Y/sETYYgMGqXBfpSHjZL1TH6EF/srYgxehVEf94YFMZAdfgy1EIvJGFq+xFkTVlriWEWm37zuOf
	eqjy7SQ==
X-Google-Smtp-Source: AGHT+IEBzSQdUHmA3TyEKJQlmkFhZJqc6bnksPf3qYWhh2BEicugNPiKD9TbhOOHbK5k4iJSThyP/B45Vzw=
X-Received: from plxb5.prod.google.com ([2002:a17:902:bd45:b0:248:6b51:1364])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b8b:b0:249:17d1:f1d5
 with SMTP id d9443c01a7336-25176729912mr186178225ad.60.1757525746596; Wed, 10
 Sep 2025 10:35:46 -0700 (PDT)
Date: Wed, 10 Sep 2025 10:35:45 -0700
In-Reply-To: <20250909093953.202028-2-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250909093953.202028-1-chao.gao@intel.com> <20250909093953.202028-2-chao.gao@intel.com>
Message-ID: <aMG28ahWdS-2gHk6@google.com>
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

Almost forgot.  I think it makes sense to grab kvm->srcu here.  I'm not entirely
positive that's necessary these days, e.g. after commit 3617c0ee7dec ("KVM: x86/xen:
Only write Xen hypercall page for guest writes to MSR")but there are path, but
_proving_ that there are no memory or MSR/PMU filter accesses is practically
impossible given how much code is reachable via MSR emulation.

If someone wants to put in the effort to prove SRCU isn't needed, then we should
also drop SRCU protection from KVM_{G,S}ET_MSRS.

> +		value = u64_to_user_ptr(reg.addr);
> +		if (ioctl == KVM_GET_ONE_REG)
> +			r = kvm_get_one_msr(vcpu, id->index, value);
> +		else
> +			r = kvm_set_one_msr(vcpu, id->index, value);
> +		break;
> +	}
>  	case KVM_TPR_ACCESS_REPORTING: {
>  		struct kvm_tpr_access_ctl tac;
>  
> -- 
> 2.47.3
> 

