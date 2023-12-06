Return-Path: <kvm+bounces-3713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36A618074D4
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 17:21:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5464281DF4
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 16:21:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF3947769;
	Wed,  6 Dec 2023 16:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SF5Uhg/L"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD65137
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 08:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701879689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yBHnmpTdUAAABbA8Mh1bA1BUO5b6J3rmpt1I3QMnK5Y=;
	b=SF5Uhg/L0M4i+0SOd7MFeWFoIrj1PWmqEjVL4S02pTpwIw5+QZGBoHqjfp64sKFRkQPzD6
	HiOC5W9uQKJ4+xoCdi0PFatl0Xbv9YRNMr0RVBe5HWzjlNTX/yXyefzjEHPPuIk3sYNrdv
	z8qwKuA/4nIPLTAJtq98/TRFSbldky0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-6ofILOh5MCOXibpZbvRPyw-1; Wed, 06 Dec 2023 11:21:26 -0500
X-MC-Unique: 6ofILOh5MCOXibpZbvRPyw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40c23b73badso3531005e9.2
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 08:21:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701879685; x=1702484485;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yBHnmpTdUAAABbA8Mh1bA1BUO5b6J3rmpt1I3QMnK5Y=;
        b=uOhhuEmx7ISjjYuuaj63YIDOoVwImirxc8Lc6jPYZ8TTN7uNHEZXHdNtSFQex06XDt
         qmJ2C+Ho9zdAs5pwknz3lHQycElz1Xlm7ZB3Ry/DZJeNk2VxqHraZdXVq7B3OiXZ1eZK
         lBRvIZPCZYLP3VPiy3IBhMNJCCosayNzma7Ceu2a3Ht7ac+nAYJ2U8WT2rX7+h7icJNC
         FNK1lBnE6/tjQOIVUr19TP5akTr9Ct2uZMR5z/x5xC3zA4gMmWcoX4etZA4ruumPhmWM
         Jsv38gqu1KlrqnJn5Ob/ssrDHaBNybW14Iv/vk0FNSh9d63s5omEMZEHlXZfvXQaczrZ
         T6Wg==
X-Gm-Message-State: AOJu0YwRFcz9EgJ1SVfYXn/788anO7PVgjDQVCwMhXx60U7z9lqbnxGO
	mfbDWn5Jr3HUMneqXOhv0OoA63JsYdAZ6KUBc4tHcfsDrXa6xFzTqkgsFdnsD7WEl5RfFpyjxPG
	BkrIVm/g0TQaf
X-Received: by 2002:a05:600c:354f:b0:401:bd2e:49fc with SMTP id i15-20020a05600c354f00b00401bd2e49fcmr754487wmq.24.1701879685197;
        Wed, 06 Dec 2023 08:21:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHHWRueBGFjuqH7LTjLrUPFBWtdG2OWtYQEqZHufXz0GKcVxX4ZdL32r3Rlza5w9bs0UKjXVA==
X-Received: by 2002:a05:600c:354f:b0:401:bd2e:49fc with SMTP id i15-20020a05600c354f00b00401bd2e49fcmr754477wmq.24.1701879684841;
        Wed, 06 Dec 2023 08:21:24 -0800 (PST)
Received: from starship ([89.237.98.20])
        by smtp.gmail.com with ESMTPSA id fj5-20020a05600c0c8500b0040b2b38a1fasm101981wmb.4.2023.12.06.08.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 08:21:24 -0800 (PST)
Message-ID: <3e5a23c106ae5e86eba05391d1cba3f0b9c3854d.camel@redhat.com>
Subject: Re: [PATCH] KVM: SEV: Fix handling of EFER_LMA bit when SEV-ES is
 enabled
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
 <hpa@zytor.com>, x86@kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 06 Dec 2023 18:21:22 +0200
In-Reply-To: <20231205234956.1156210-1-michael.roth@amd.com>
References: <20231205234956.1156210-1-michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2023-12-05 at 17:49 -0600, Michael Roth wrote:
> In general, activating long mode involves setting the EFER_LME bit in
> the EFER register and then enabling the X86_CR0_PG bit in the CR0
> register. At this point, the EFER_LMA bit will be set automatically by
> hardware.
> 
> In the case of SVM/SEV guests where writes to CR0 are intercepted, it's
> necessary for the host to set EFER_LMA on behalf of the guest since
> hardware does not see the actual CR0 write.

Could you explain in which case the writes to CR0 will be still intercepted?
It's for CPUs that only support SEV-ES and nothing beyond it?


> 
> In the case of SEV-ES guests where writes to CR0 are trapped instead of
> intercepted, the hardware *does* see/record the write to CR0 before
> exiting and passing the value on to the host, so as part of enabling
> SEV-ES support commit f1c6366e3043 ("KVM: SVM: Add required changes to
> support intercepts under SEV-ES") dropped special handling of the
> EFER_LMA bit with the understanding that it would be set automatically.
> 
> However, since the guest never explicitly sets the EFER_LMA bit, the
> host never becomes aware that it has been set. This becomes problematic
> when userspace tries to get/set the EFER values via
> KVM_GET_SREGS/KVM_SET_SREGS, since the EFER contents tracked by the host
> will be missing the EFER_LMA bit, and when userspace attempts to pass
> the EFER value back via KVM_SET_SREGS it will fail a sanity check that
> asserts that EFER_LMA should always be set when X86_CR0_PG and EFER_LME
> are set.
> 
> Fix this by always inferring the value of EFER_LMA based on X86_CR0_PG
> and EFER_LME, regardless of whether or not SEV-ES is enabled.
> 
> Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 5d75a1732da4..b31d4f2deb66 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1869,7 +1869,7 @@ void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  	bool old_paging = is_paging(vcpu);
>  
>  #ifdef CONFIG_X86_64
> -	if (vcpu->arch.efer & EFER_LME && !vcpu->arch.guest_state_protected) {
> +	if (vcpu->arch.efer & EFER_LME) {
>  		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
>  			vcpu->arch.efer |= EFER_LMA;
>  			svm->vmcb->save.efer |= EFER_LMA | EFER_LME;

Purely from the point of view of not confusing future readers of this code:
Due to encrypted guest state, if I understand correctly, the 'svm->vmcb->save.efer'
is only given for the hypervisor to see but not to modify.

While the modification of save.efer is a nop, can we still guard it with
'vcpu->arch.guest_state_protected'?

Besides these nitpicks:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky


