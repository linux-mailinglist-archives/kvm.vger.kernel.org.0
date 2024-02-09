Return-Path: <kvm+bounces-8509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 832F3850002
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 23:33:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF6F91F22192
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:33:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33E973D0CA;
	Fri,  9 Feb 2024 22:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="G4brQ5d7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0983D0C3
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 22:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707517830; cv=none; b=s7sk9a7lOQJ0gCdaXcYDynpHcxuXKhGAWPSgbrUIxpa9v7lS9mseOthTGk3kC3KVZvnf1+m3vf0L+lm1t0pZccXANgXzJZBPdX2J/v5D6jn9AG2DsKVgaTVbbF7POb3WCJ9SVcxWSH0AcIHFeYyUJ5AfsPifGPw4dHBVbeaasK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707517830; c=relaxed/simple;
	bh=Fy+DFfgl9iPfXE4Cc00lQVCWdaZmYtdMTKbSdOK6dr8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fOnQCH8hNIhAQuCm7VhAC+Qvmtt/i94iJiF5SNaSRF/3Ig73HjTbvNyd9aUpYnQN0EcmcvSQRYRhWOPRl4sYdGJ/bPgWojwM3/x9wK4m89vnTi1HlIWAklBLk4W/XkB7q8wplv/tGE6kCF0gIslHJSAVXNi081hWrpHAy/oOIfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=G4brQ5d7; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5605c7b0ca2so1702147a12.3
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 14:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1707517826; x=1708122626; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q334rdbHohWsxJ77bsjyPgsTUJYym92p9x/mltaYtVg=;
        b=G4brQ5d77cF1vSB81B3cApym8KcnqmQTkHY/ti4R52o80rTHXJQxFOOSSGsqhZDbM1
         /2LP7bUzmrcwhYRIbvrVzKBVrb185RMshNCy3M/Ymx1ON0rFl0ocZ1kRHvipokwFHO8T
         SxjSKYt6+XVx2uhhra6pCHDzBUfxKoN+vrDKyKqsPNdTLgGlEX0+AD09Mfayq3geGSR5
         6HZZLU5Luq7DLRxkLoZc1m1OSfi6DFYc5bnp6Vhwb+ZItd+r6OKdbuz5mPlX40Q02Qfd
         UYoXgxeWPIsUE3D7UMN9C8hi+hNQ0tNSmrJvItcKMsrPpy5uMkZLH68yaK4FDJnkN08D
         9bKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707517826; x=1708122626;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q334rdbHohWsxJ77bsjyPgsTUJYym92p9x/mltaYtVg=;
        b=oruPXE8WYTysZTZMZUf8ldVgwHiczKRVS8yO3RFg/TtGy23iKf0tu+S47bDXp/nfDg
         xOI/mLkZLAmM/7xR/ylE8MOLkpA9HLqSh4/9xmZ/o1Q2G6hsMHa71lPXYvWHlTV1KVIJ
         e5xVe8ShyXQYvh95jxVfD5JUI7Mv2X1epmWJxOYKC2NWC6VdlyGTRxSHUu0eiaidOO3s
         bAZQms7JVzJtPieGyiCySIJFbY9CwtBe4F2jZwfVrRqiJhm27Y938CCRsWRFI073nyqx
         Yp+pi62b4tv0HwCylGM6TsXTGYmUaBg/4dY3Z4pi1OsjNwrTKgocWVEPCcAXrfbRelDA
         DCzw==
X-Gm-Message-State: AOJu0YzWuMGdJDcN+ySHhF/n7M2TUjqyXeBm5KIon8TUf1AJ6EyyUaio
	wWPqpM1O6f0KZ5kWxGxuKvNzSnaZjGoWZODVZEiX/zyJ3XMOL6qbpR8oZXM8bdQ=
X-Google-Smtp-Source: AGHT+IE/3pC+fthtxR5cVJpZzV/OL1GamrSn10DOAVzpqvjahgRYZzWD7R97jCX60h8cwAfzW3AIcw==
X-Received: by 2002:a17:906:68d8:b0:a38:96ef:4199 with SMTP id y24-20020a17090668d800b00a3896ef4199mr221824ejr.75.1707517825779;
        Fri, 09 Feb 2024 14:30:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXmhADPjPQXFV6Z5GdiurBvyAgwNK0C3N9z8jawo/KNCwaAZNMD4Omlh3uuSxofmTcAOMTOPM/REeziKhZeuvQx6sG8n5NWEigzjfAgdeIRQv74hkcJtGgZQWWHikAQz3QF
Received: from ?IPV6:2003:f6:af2c:a500:6e26:87f:cb2:6335? (p200300f6af2ca5006e26087f0cb26335.dip0.t-ipconnect.de. [2003:f6:af2c:a500:6e26:87f:cb2:6335])
        by smtp.gmail.com with ESMTPSA id go43-20020a1709070dab00b00a385535a02asm1171411ejc.171.2024.02.09.14.30.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 14:30:25 -0800 (PST)
Message-ID: <19824d6d-28f9-4aa0-8b10-bacefc49adfd@grsecurity.net>
Date: Fri, 9 Feb 2024 23:30:26 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: x86: Open code all direct reads to guest DR6 and
 DR7
Content-Language: en-US, de-DE
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240209220752.388160-1-seanjc@google.com>
 <20240209220752.388160-3-seanjc@google.com>
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20240209220752.388160-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 09.02.24 23:07, Sean Christopherson wrote:
> Bite the bullet, and open code all direct reads of DR6 and DR7.  KVM
> currently has a mix of open coded accesses and calls to kvm_get_dr(),
> which is confusing and ugly because there's no rhyme or reason as to why
> any particular chunk of code uses kvm_get_dr().
> 
> The obvious alternative is to force all accesses through kvm_get_dr(),
> but it's not at all clear that doing so would be a net positive, e.g. even
> if KVM ends up wanting/needing to force all reads through a common helper,
> e.g. to play caching games, the cost of reverting this change is likely
> lower than the ongoing cost of maintaining weird, arbitrary code.
> 
> No functional change intended.
> 
> Cc: Mathias Krause <minipli@grsecurity.net>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/smm.c        | 8 ++++----
>  arch/x86/kvm/vmx/nested.c | 2 +-
>  arch/x86/kvm/x86.c        | 2 +-
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
> index 19a7a0a31953..d06d43d8d2aa 100644
> --- a/arch/x86/kvm/smm.c
> +++ b/arch/x86/kvm/smm.c
> @@ -194,8 +194,8 @@ static void enter_smm_save_state_32(struct kvm_vcpu *vcpu,
>  	for (i = 0; i < 8; i++)
>  		smram->gprs[i] = kvm_register_read_raw(vcpu, i);
>  
> -	smram->dr6     = (u32)kvm_get_dr(vcpu, 6);
> -	smram->dr7     = (u32)kvm_get_dr(vcpu, 7);
> +	smram->dr6     = (u32)vcpu->arch.dr6;
> +	smram->dr7     = (u32)vcpu->arch.dr7;
>  
>  	enter_smm_save_seg_32(vcpu, &smram->tr, &smram->tr_sel, VCPU_SREG_TR);
>  	enter_smm_save_seg_32(vcpu, &smram->ldtr, &smram->ldtr_sel, VCPU_SREG_LDTR);
> @@ -236,8 +236,8 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
>  	smram->rip    = kvm_rip_read(vcpu);
>  	smram->rflags = kvm_get_rflags(vcpu);
>  
> -	smram->dr6 = kvm_get_dr(vcpu, 6);
> -	smram->dr7 = kvm_get_dr(vcpu, 7);
> +	smram->dr6 = vcpu->arch.dr6;
> +	smram->dr7 = vcpu->arch.dr7;
>  
>  	smram->cr0 = kvm_read_cr0(vcpu);
>  	smram->cr3 = kvm_read_cr3(vcpu);
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 28d1088a1770..d05ddf751491 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4433,7 +4433,7 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>  		(vm_entry_controls_get(to_vmx(vcpu)) & VM_ENTRY_IA32E_MODE);
>  
>  	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_DEBUG_CONTROLS)
> -		vmcs12->guest_dr7 = kvm_get_dr(vcpu, 7);
> +		vmcs12->guest_dr7 = vcpu->arch.dr7;
>  
>  	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_IA32_EFER)
>  		vmcs12->guest_ia32_efer = vcpu->arch.efer;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bfffc13f91e6..5a08d895bde6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5510,7 +5510,7 @@ static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
>  	for (i = 0; i < ARRAY_SIZE(vcpu->arch.db); i++)
>  		dbgregs->db[i] = vcpu->arch.db[i];
>  
> -	dbgregs->dr6 = kvm_get_dr(vcpu, 6);
> +	dbgregs->dr6 = vcpu->arch.dr6;
>  	dbgregs->dr7 = vcpu->arch.dr7;
>  }
>  

Reviewed-by: Mathias Krause <minipli@grsecurity.net>

Nice cleanup. Thanks a lot, Sean!

