Return-Path: <kvm+bounces-50523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7FA0AE6D09
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 18:55:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E45673AAE14
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 16:54:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1F462E6128;
	Tue, 24 Jun 2025 16:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f963h6Ls"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B2D1FDE33
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 16:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750784056; cv=none; b=Olaw3S/8xiVHtAggaebrguNjKm/aR0YQiL06MtASCMJilNq9o/OanKuKNiKqAnDxdyYtMYm4G4PvNYnYmGtFrjJgQRqPzX+2+8X+zI/g8hs8jXlHCmgTdh9Mvc6fxXPy+bi6VDCOInHf3BqgTSdhptaSGlA1nknk5HA/LNiFqT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750784056; c=relaxed/simple;
	bh=HzTXMQK0Sk+89eCcGCRpe2fDVECOwc6M6+7TFRwpUsc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RFbv6B4axsJS4nFp3L6L6CnCUZM5g5tXxrJQ6JcHr8K8F88a3XtyoLjWDf1tqQfleHrITc5lbQKylJ6thIQtKvUkN8QMYoGMnX6jinMv5zQl+zX9x+/PMiaZrejNMwEN+ktlhdodiml8XGEnMmPhHvo0AzcgVpsssXLu8MyWKPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f963h6Ls; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b31c8104e84so3814681a12.0
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 09:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750784053; x=1751388853; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PtWwPcbALvYkeiY4pVsinxdvdY8YE60we2liZ/hv4Jc=;
        b=f963h6Lswl2en5I0suVNTbeEe+9hcZ/NlRkjz5XE98QLCud3N90hc4sPUsX0ZkAE46
         ZysBQ52V3wNheF99+9D7C9ldcsC+6Li79Qdy/IcCnCKUdFxHVtKviwroLQYv5mYcCIIN
         M2XIjRlArMfGv64EUJsv6HDw5YFZShx7ohugD1OVZ1PfFah9RS3aKoLrurH0VzHJ0ruf
         ibjpF6QflHlsGBNE8RCnyZ0MR65lww4rM0lEipubeiDpZAuCH/EAnrlRYM2E6f8y+bpa
         Yw/VRAw/oO9xzUlm+ZjldTNf7Rm7hkRCuiMw3RnkJ76r5++hwNtKmd9Vn/c+AlMwxGUh
         vnQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750784053; x=1751388853;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PtWwPcbALvYkeiY4pVsinxdvdY8YE60we2liZ/hv4Jc=;
        b=TNbngSpsKEqaAEtt5mtJjTt6yfptRSw1XFoEN4IBxgLHZ6BcuJm/xtzZU4s6Uej7Vt
         XsjYdnsdycTV/IEJVMvRafJRuyGENfpOJxp4q6vqFydzCM0zjw2oaFPq583hw4aiHpNw
         bDND09lsz/0QL9v4EQSqS+RE0u5NPZd12tNtvGyq/e0AhyscyUnNr78sh+9RF0xXfYUV
         4P31rfAs3UofhGFcD2vefoy8Kh1/U5GxyiiZs5U+JnMvIXYdkZwjHQ8XnZekCaBftdKv
         xqhFSpHYloWZ0hTev76MR+YWv3rFduoVOwqKKkbvMBqbfl4sj4bk+2Vz5rABJOU7AiTY
         BdKw==
X-Forwarded-Encrypted: i=1; AJvYcCUl2zSTcTIVvG9IKfuuERR0AtElczb9Y0v8O37LJIHSfWu+RnnQLnPc/rYzVjYJVpRMCg0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyCYVwLNfFMjI1+1t8KRlB4QWi+gIbpuLhuTdd5+e6lLgShbG+
	Rk8479YmrjsjCVrRzItoHDZVnXJ1zqXBb7vNI6Z/biuFCiZOYPAoRCamEJ3FywBuxWAdh7ybwrV
	igEbjAA==
X-Google-Smtp-Source: AGHT+IH+8dH4wyPpmgAFC48DsVTB8bgti3rxgqoIRLFuvBNppEpHbI1xoF+oj+TP+ZbSUrJsVS2UPRM9h+M=
X-Received: from pfbfi22.prod.google.com ([2002:a05:6a00:3996:b0:749:1e51:d39a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:17a6:b0:748:68dd:ecc8
 with SMTP id d2e1a72fcca58-7490d9e7228mr23007806b3a.22.1750784052939; Tue, 24
 Jun 2025 09:54:12 -0700 (PDT)
Date: Tue, 24 Jun 2025 09:54:11 -0700
In-Reply-To: <20250328171205.2029296-17-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250328171205.2029296-1-xin@zytor.com> <20250328171205.2029296-17-xin@zytor.com>
Message-ID: <aFrYM2urBeoFDVAV@google.com>
Subject: Re: [PATCH v4 16/19] KVM: nVMX: Add support for the secondary VM exit controls
From: Sean Christopherson <seanjc@google.com>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, andrew.cooper3@citrix.com, luto@kernel.org, 
	peterz@infradead.org, chao.gao@intel.com, xin3.li@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Mar 28, 2025, Xin Li (Intel) wrote:
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index b4f49a4690ca..d29be4e4124e 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -38,6 +38,7 @@ struct nested_vmx_msrs {
>  	u32 pinbased_ctls_high;
>  	u32 exit_ctls_low;
>  	u32 exit_ctls_high;
> +	u64 secondary_exit_ctls;
>  	u32 entry_ctls_low;
>  	u32 entry_ctls_high;
>  	u32 misc_low;
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 5504d9e9fd32..8b0c5e5f1e98 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1457,6 +1457,7 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
>  	case MSR_IA32_VMX_PINBASED_CTLS:
>  	case MSR_IA32_VMX_PROCBASED_CTLS:
>  	case MSR_IA32_VMX_EXIT_CTLS:
> +	case MSR_IA32_VMX_EXIT_CTLS2:

This is wrong.  KVM allows userspace to configure control MSRs, it's just the
non-true MSRs that have a true version that KVM rejects.  I.e. KVM needs to
actually handle writing MSR_IA32_VMX_EXIT_CTLS2.

>  	case MSR_IA32_VMX_ENTRY_CTLS:
>  		/*
>  		 * The "non-true" VMX capability MSRs are generated from the

