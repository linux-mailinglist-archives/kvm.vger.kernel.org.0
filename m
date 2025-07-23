Return-Path: <kvm+bounces-53308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1677FB0FA24
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 20:19:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B22A91C840A8
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 18:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85D6922B8B5;
	Wed, 23 Jul 2025 18:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bs6mBIDH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4D7218584
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 18:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753294750; cv=none; b=FBXKVopfyCoVwQt9KhG2jNVBrkJA/P9ERhjj1d4CNiu+dCuSc5B71zvGE6t0+Xicd55QS+91maB3UaW5PvceW/ek2xXxDiD9ZJ5YWV/VaZZhwxS+c01X7TVjTEzNeAv2kam72SCIod8SgFrNqXrCZM2rNF+RvnuoQMfVEcYkBMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753294750; c=relaxed/simple;
	bh=zdSvmSkd0NmmjOsTjLY3Hz7lD1LJ6biSJtMpZav9cQ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c5O/40tvfcRcQ7994lfeVS3myNrHhocOv2kEwObXwmHDPtl8I8LqU8WLHMD71MStscqLyY8paKWkFJpTvz0sGdcIdoKyJl4nLW1P2jd3l2NzAcrulYJwPbqVt1rqFTZPW0EwHaLbLuOGys1wb0u7SnKIcSlQHJ9UFHOE5aTjeOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bs6mBIDH; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b38fc4d8dbaso222875a12.2
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 11:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753294748; x=1753899548; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+mgjRhl7QeLuKE3QQ3pMAhg0iltdJ7SjGRF1SJi7olo=;
        b=bs6mBIDH8E+2GKoq+1nehpbsfpj9Wm0TQ7RoOWCwVJltLkoWgW4eJaLtg9FoHWFtcZ
         Jn+QAIuVLpUMr9GmV2oRcLpjoKfUjQIqw5fgrgf7mDzGqOk0Y5B4WJA/c5R+oi6jRcmS
         8zvQRxhb5Ovupr+PNKyvJ3RWzYpIPWTibWimERx/supPFZRGliNrCGjVRWccjRii4jiQ
         Da6NmJolJlp+bxThc6COPjFf7ovwSFJofjIDHM42vx+Dxp/RMejxof0LW8UjE/9qG5Ig
         SvKs0KBgZQyXkj/6kEcB/+HAbraW1T4ntPFx3KCHHjrPO86PwsIbN1Xa6CbJ86DOUUcX
         3Cmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753294749; x=1753899549;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+mgjRhl7QeLuKE3QQ3pMAhg0iltdJ7SjGRF1SJi7olo=;
        b=RQIhPen8DKSaq/4awE3GmrB6S+IM3M36gDRPv9e/EXayxFoe4LMOC9xF3UjplVbN6Z
         oTPFBh9jouzcf60o+lErKG6Tjl/1EWAAoaJYFxKkCM7MQvnuPYfKkEJ4iDXXenfegFw7
         LreDMtEGU7U9UbCW4KYE+sZLFYGIjN9KbqkJZvacLtADnksyyEtsCSo81n+il61WAVRP
         P0u91F72Hj+hXWwOt/GhgEC09ziJDZIGdnsj7BShdVZr0r3qKQRTtfcDWJsm35a/t5/k
         1RK8Xes/AIFRozanow0mw2P1612IffN4LYK1Q6ZXOfkKz1nhA2ULQNYWlmgEi3N3j4RW
         5yWw==
X-Forwarded-Encrypted: i=1; AJvYcCWnBitYmjN4iDST+mlVL2eWMJrpE22CkgM4j2ePkpgwylvhreSeeeEEyqwu16nTHOIfLgw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHNDilhPN0Qc4mGqxDYMZnIo2FRNjur5ut6+9/wxlyZRniHeqk
	8xZI6HwvrOR6OoZvny964ad1Oqqi58Rq5tcCtCft3tOLBzR1mmjpMRL3cPqJeK1Sn3yCzAfdCZk
	f3+M/9g==
X-Google-Smtp-Source: AGHT+IF0icnWbWtzPJKSEKwjPNwYePDm/cMvEUI0qVfn/lywtl0EFsLb8tVoT1AeoKBbG2DyCjC/dY5y6V8=
X-Received: from pjx3.prod.google.com ([2002:a17:90b:5683:b0:311:7d77:229f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:47:b0:314:2840:8b21
 with SMTP id 98e67ed59e1d1-31e507fe4femr5047003a91.32.1753294748695; Wed, 23
 Jul 2025 11:19:08 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:19:07 -0700
In-Reply-To: <20250422161304.579394-5-zack.rusin@broadcom.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250422161304.579394-1-zack.rusin@broadcom.com> <20250422161304.579394-5-zack.rusin@broadcom.com>
Message-ID: <aIEnm7Y1VN-PCfF8@google.com>
Subject: Re: [PATCH v2 4/5] KVM: x86: Add support for legacy VMware backdoors
 in nested setups
From: Sean Christopherson <seanjc@google.com>
To: Zack Rusin <zack.rusin@broadcom.com>
Cc: linux-kernel@vger.kernel.org, Doug Covelli <doug.covelli@broadcom.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 22, 2025, Zack Rusin wrote:
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 04c375bf1ac2..74c472e51479 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -22,6 +22,7 @@
>  #include <asm/debugreg.h>
>  
>  #include "kvm_emulate.h"
> +#include "kvm_vmware.h"
>  #include "trace.h"
>  #include "mmu.h"
>  #include "x86.h"
> @@ -1517,6 +1518,11 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
>  			 svm->vcpu.arch.apf.host_apf_flags)
>  			/* Trap async PF even if not shadowing */
>  			return NESTED_EXIT_HOST;
> +#ifdef CONFIG_KVM_VMWARE
> +		else if ((exit_code == (SVM_EXIT_EXCP_BASE + GP_VECTOR)) &&
> +			 kvm_vmware_wants_backdoor_to_l0(vcpu, to_svm(vcpu)->vmcb->save.cpl))
> +			return NESTED_EXIT_HOST;
> +#endif

Either provide a stub or do

		else if (IS_ENABLED(CONFIG_KVM_VMWARE) && ...)

Don't do both.  And definitely don't add a stub and #ifdef (some) callers.  I'd
say just drop the #ifdef and rely on the kvm_vmware_wants_backdoor_to_l0() stub
to get the compiler to optimize out the entire elif.

> @@ -6386,6 +6387,11 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
>  			return true;
>  		else if (is_ve_fault(intr_info))
>  			return true;
> +#ifdef CONFIG_KVM_VMWARE
> +		else if (is_gp_fault(intr_info) &&
> +			 kvm_vmware_wants_backdoor_to_l0(vcpu, vmx_get_cpl(vcpu)))
> +			return true;
> +#endif

Same thing here.

