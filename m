Return-Path: <kvm+bounces-10810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82AE7870526
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 16:17:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3F8E1C22CAB
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 15:17:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B9424D58E;
	Mon,  4 Mar 2024 15:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kd4b+qkS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134972C18D
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 15:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709565348; cv=none; b=erbgsoFnwQ3Rm18C90gP+mcD7J+P2Op61FxFEYrObDhwqDGvDPKyoZCI0P6Yh5p6ZZ9pzAKWnYkhf7p8Y3igHEmzMhq/hOAKk2sAZRQyyGDEXyxVPQS8uNkzONcMw5srcU2aiOrYhLVeIZAkBRaYCjFVIs4ZWWmLxkli/CW0PyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709565348; c=relaxed/simple;
	bh=PHagvGZN49C8CopjtNuDmKmGFqr3kmXN7R8kWRH/HsA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nOVje8SJyfIG32kILBznAgsLyRXcDeHHLCJxSx5abAUKGRJdBjNt4J/mFuWwO+1tpQBkjKJ2JDh9p//xAL76jVBOAcEQ+bIMqqY4OcWkvsRIIvIQcdHRpuVmD7+02CHf7y+w8fB/Ch/b6xCxNZgAinYAwxtDM/mK1WAdCW9liV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kd4b+qkS; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1dcabe5b779so59249205ad.0
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 07:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709565346; x=1710170146; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pFO6+UywViZZyvnPAa9tMMRLlhb9803+MwFU94Wmgk4=;
        b=Kd4b+qkSPT44csNE/JIMN3qr5t0cBmih5H7hsQQpfsihY4rIBv+OLNhz/2uD9gcMa2
         +5+0nBMfAxzZLlhm9SyuHLmXO1ifG1CT57cSFaV/lJXkMWeZH1VWVFH+ciC/0vk7VgtK
         vizuUJr0u2eA76d1aqYy8tI1MSxWxGfVM4el+ydURYfImxTE1seRKetCyevUToXbD3a7
         abIjNEY/yXF8Y8etFIb5Kx/Myrk/t2NQBgWmvYzeFTPaGHIuOAUCiPjrtM0CiLQrpad+
         BOYKWG2BtAj+iX1znxEwm3n54lLSpbhIE+1HDXwpq0pdDV68rjCKUx3nhvaC9hGZ2lRC
         H9Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709565346; x=1710170146;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pFO6+UywViZZyvnPAa9tMMRLlhb9803+MwFU94Wmgk4=;
        b=MPEsZvOpkD96Z/TqCY77G4z1uxTk9G8XSCfmprGxkXomYrkBRd7sE0yfn3FiDkB076
         wJI9NTf7MYqj5bTYXOmgCM18vDvc11B3pz6d+wSET/ff5N63jzOFak4ivqotzpmiPbC6
         YZKqu1GIJK5rdEYKfOkjQNvQO/KQ1hPnGUb6PLUd3aoYPJLv+9TcD8FJwwzxGEM7DZzv
         oJVL8IHYLQXnbaYMwriB1y4kK5B18JlceuLHDoJbK2V3M42XDuYncZHC2zzrMlU+PFsX
         csQ3woSkKMK01W85uJ89A2XMPN234gvbFYBceNTr07Ayx2U8hAjhftATnrgc9hEIJWdj
         2LPA==
X-Gm-Message-State: AOJu0YzVITVg858JPkfeY4paarbmK7rA0jvoOmyNZnOdwwfYU0RI6nsM
	Q5IN8hhLgg7R08V/ieBRNi7XKhfcQGNe8K4MgtVrDIf69G882AUiy9VRUqDjfxtzAEIedxDWvE8
	DmQ==
X-Google-Smtp-Source: AGHT+IHGAA0Lrr6D8JJnCJuBRYdJyqZCbHSa/69Uam1kLs9A6DxL38nQx5C9WFnOxNa+i/UXz2cKgvYsNBM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e5c8:b0:1dc:e9e:374e with SMTP id
 u8-20020a170902e5c800b001dc0e9e374emr91930plf.12.1709565346183; Mon, 04 Mar
 2024 07:15:46 -0800 (PST)
Date: Mon, 4 Mar 2024 07:15:44 -0800
In-Reply-To: <20240301101410.356007-2-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240301101410.356007-1-kraxel@redhat.com> <20240301101410.356007-2-kraxel@redhat.com>
Message-ID: <ZeXloHPV1dkOwBTe@google.com>
Subject: Re: [PATCH 1/3] kvm: wire up KVM_CAP_VM_GPA_BITS for x86
From: Sean Christopherson <seanjc@google.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Mar 01, 2024, Gerd Hoffmann wrote:
> Add new guest_phys_bits field to kvm_caps, return the value to
> userspace when asked for KVM_CAP_VM_GPA_BITS capability.
> 
> Initialize guest_phys_bits with boot_cpu_data.x86_phys_bits.
> Vendor modules (i.e. vmx and svm) can adjust this field in case
> additional restrictions apply, for example in case EPT has no
> support for 5-level paging.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  arch/x86/kvm/x86.h | 2 ++
>  arch/x86/kvm/x86.c | 5 +++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 2f7e19166658..e03aec3527f8 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -24,6 +24,8 @@ struct kvm_caps {
>  	bool has_bus_lock_exit;
>  	/* notify VM exit supported? */
>  	bool has_notify_vmexit;
> +	/* usable guest phys bits */
> +	u32  guest_phys_bits;
>  
>  	u64 supported_mce_cap;
>  	u64 supported_xcr0;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 48a61d283406..e270b9b708d1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4784,6 +4784,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		if (kvm_is_vm_type_supported(KVM_X86_SW_PROTECTED_VM))
>  			r |= BIT(KVM_X86_SW_PROTECTED_VM);
>  		break;
> +	case KVM_CAP_VM_GPA_BITS:
> +		r = kvm_caps.guest_phys_bits;

This is not a fast path, just compute the effective guest.MAXPHYADDR on the fly
using tdp_root_level and max_tdp_level.  But as pointed out and discussed in the
previous thread, adverising a guest.MAXPHYADDR that is smaller than host.MAXPHYADDR
simply doesn't work[*].

I thought the plan was to add a way for KVM to advertise the maximum *addressable*
GPA, and figure out a way to communicate that to the guest, e.g. so that firmware
doesn't try to use legal GPAs that the host cannot address.

Paolo, any update on this?

[*] https://lore.kernel.org/all/CALMp9eTutnTxCjQjs-nxP=XC345vTmJJODr+PcSOeaQpBW0Skw@mail.gmail.com

