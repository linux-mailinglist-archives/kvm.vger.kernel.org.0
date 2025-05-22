Return-Path: <kvm+bounces-47415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1E0AAC15EA
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 23:31:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2D3C47B0D7E
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 21:30:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51204255F5D;
	Thu, 22 May 2025 21:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SjfoBUSb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1280E255F2A
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 21:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747949473; cv=none; b=sgvN5YyObGi1MDQFqaC5vhva4B2wwYrssyg9zMcMj/zpYHnHAFPzJNAi0p5yKPiMEU5hYXBFhCC4ppB0IklQFKCItfMesbefURCoCzVlQ0Vtaok4KSsme1rWIt9/JiPOtMyY6JU67dXP+31RhScX+1QR+eRWUQfYVw3LHRSVd9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747949473; c=relaxed/simple;
	bh=/kqT+wnIjTSmtfeVLivDIr1Zilt94rT7p55mB3Jo1yI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=izZbsSpmCOrVxM6ZszKMxvdTiH7t90Odher/8lKl39ODylDEJeXQoAdikqnl+M4ea7++izAQy1VzFPtLblHBOtLIUY5uqQyfCrps/ici6Dq/2YeKEJAB73HC7dnZTH0HaihXj7+S1yKZwfshtb7vW4xD001DTGOcjI0bZF1V6qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SjfoBUSb; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3108d5123c4so1964725a91.1
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 14:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747949471; x=1748554271; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zZz2IC80LnWW0Pnt6grYd6TUxDCxRHu+6E0LOPrC8VI=;
        b=SjfoBUSb/bmG5mXiPNmUF9G5cfPJQNPhl3uEX+SmAp/Qs0p1j2ItcXfxwlQmmRS6MC
         POrxTtTVaSHzM/f+AF6Fmq0SauqXQ1jM4kppY7YDYO53YAXVVEsAPEFPtlMnJUqUZzqO
         UkrUSfPPzNmEgwJ5uKogTQRka6eX/gx/zlqVG3JWRhOLdwwXLgHKK1Nu4WlgFl0o6wkJ
         MiP92dQPNtMTU1n3GMStW6vosew+5dG+63qF3mMZ0F4goRYtD3BlXPP7VdMqIKqz7ZR8
         +kNUFwLPkivigTASSowYClYg0gFjtoYqYVufHdfqC375Lva5MEhRNIHwqS0lQlVZXevE
         NnVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747949471; x=1748554271;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zZz2IC80LnWW0Pnt6grYd6TUxDCxRHu+6E0LOPrC8VI=;
        b=eNxVeg4smOyMj5scpNoQm0KBekmFiyaDwsJ0Xcbif146oXNzh4CZfCIMKoosIhkWhG
         0YJiaFXodwtzJy77FAgUR9aa1c8J7vFUInhLJjy1DwcS5+hEQFU3YExzf3sMm5Q8qV0/
         ro0maPBDfj00AUjuFMjHKayVhDiu9Fagfx1aqiX5YFVA/Gw2I07sURhrbkW5ItwfUEya
         G4su7jMPJ9b+birWamtDawpElvI8P/9h7oAM5bmaN3c9JabU1+NstKtbfSqDeSNAJfQq
         2QqRiJLXUD1I6LiHDLDoa65cpHsMcVKoQWwrX5L/joOF2bflr9UuOyjn8bH9QGKz6suQ
         82SQ==
X-Gm-Message-State: AOJu0YwuqhohsLxnsNJxiSpicFCx/dMCapXn+wNSrnXevNJEDXfFWRk6
	LzTbKGWebVVzBadYca0JCnUDdhUAeUgCyelnxUPcB0xtrXMLlgofWNHYuP6ZLciF0wWsZZa/e4W
	FFDpnDQ==
X-Google-Smtp-Source: AGHT+IHQqpO4nznm2/QlQSiUu6zlSTOZG3j+BAH3Ns7NM01fu3XYXkya4Jdcw9KPqUakTrpYxi7B6laWSfY=
X-Received: from pjbso5.prod.google.com ([2002:a17:90b:1f85:b0:2fa:1481:81f5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e85:b0:2ee:af31:a7bd
 with SMTP id 98e67ed59e1d1-30e830c4833mr35752841a91.5.1747949471392; Thu, 22
 May 2025 14:31:11 -0700 (PDT)
Date: Thu, 22 May 2025 14:31:04 -0700
In-Reply-To: <20250522005555.55705-4-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522005555.55705-1-mlevitsk@redhat.com> <20250522005555.55705-4-mlevitsk@redhat.com>
Message-ID: <aC-XmCl9SVX39Hgl@google.com>
Subject: Re: [PATCH v5 3/5] KVM: nVMX: check vmcs12->guest_ia32_debugctl value
 given by L2
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 21, 2025, Maxim Levitsky wrote:
> Check the vmcs12 guest_ia32_debugctl value before loading it, to avoid L2
> being able to load arbitrary values to hardware IA32_DEBUGCTL.
> 
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 3 ++-
>  arch/x86/kvm/vmx/vmx.c    | 2 +-
>  arch/x86/kvm/vmx/vmx.h    | 1 +
>  3 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index e073e3008b16..00f2b762710c 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3146,7 +3146,8 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>  		return -EINVAL;
>  
>  	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
> -	    CC(!kvm_dr7_valid(vmcs12->guest_dr7)))
> +	    (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
> +	     CC(vmcs12->guest_ia32_debugctl & ~vmx_get_supported_debugctl(vcpu, false))))

This is a breaking change.  For better or worse (read: worse), KVM's ABI is to
drop BTF and LBR if they're unsupported (the former is always unsupported).
Failure to honor that ABI means L1 can't excplitly load what it think is its
current value into L2.

I'll slot in a path to provide another helper for checking the validity of
DEBUGCTL.  I think I've managed to cobble together something that isn't too
horrific (options are a bit limited due to the existing ugliness).

