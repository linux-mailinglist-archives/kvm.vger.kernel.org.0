Return-Path: <kvm+bounces-54901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 566F5B2B020
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 20:20:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27A935654EF
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 18:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 112E82D24AF;
	Mon, 18 Aug 2025 18:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JOrsX/+j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B326F32BF51
	for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 18:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755541230; cv=none; b=kQIED14c9yUVfkv8nkCuxOLniAbqJfVqqSTQAv34qjVR9Xtlgb6K1mhtv5VV3hR/E3n4geTdcscOvCZ+1ToP6EgysBL2xXM4v3AzZK7EqaOphp62whPNAMXEDWUPgpIy7LLFwl0DOkmhyRstdYMATVOX2N/+DV9dN3Oo7AmVpQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755541230; c=relaxed/simple;
	bh=38sZH6JuVgSMOyf4B27yV9I0wAobtIYP27/Wcj+eUOI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JUBuq/0qmmuvWKauXncdMj14K2H/vPoYRMpVW4FD7dqdddI4amRHwZD34LqwQhtWS7zSF/OjtVd8WlWC3e/IuDHF2PuwYL/Dd8rJJJQ4A+ncSqtI/u2XiIPBKDOm3EgNZLahlP1e9XvS3HaTRs/bHetqHfOhshNEMjXIGYWDQu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JOrsX/+j; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32326e6c74eso4437047a91.3
        for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 11:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755541228; x=1756146028; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c+Iq2txiStcKOuqn2xWSupDgERuUU7vo0HWget122Wg=;
        b=JOrsX/+jQNaoU4MBaOGyvA12GkFcFM52vtju6631noru5C8JEpHC407f2ogW808Lla
         iBhVV+R8p+u3QBlfMcUWZ/ICVlcc1tUtfl8p3+S5MLVcmVYrQ0GSybov+7jTdwRBdEeD
         Lf2W+sIXUXLLThO2Jydk4+mTtgmXzIY2iOeyfFaViaZJADhxfAgQNvna2ux7uu8ds4oD
         hh7cnjnYNwYH0z9mOJijhv9wygeDqAdzyTZKhFolpzFEixJUi8TxX9ECTZqwilApocBM
         v1yGLILiw9oOVAOd8eAhuvWNd7Vk9+yCj1z1q/nEd/8MoFinoN63QWnZ3DFYo5vFXwfJ
         F7ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755541228; x=1756146028;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c+Iq2txiStcKOuqn2xWSupDgERuUU7vo0HWget122Wg=;
        b=wzS8ILVL+o0SNv+6U5VSUaoWgWlOdCQLjj3IH+AZX8330zzqv2mY3U6oW2OSNkRPK+
         w/u4pqCsU4P66170AjN748+o0e5lKtBJAwBMZeokPmF4lYzVqG91RsLEEZJzu/qNafLu
         EGnwaXKj+oDzR0P++9iMStwGbqKVcc6IiuGM/FRIJOQ/rnoV5ZoBbelqblqBB6pjcRdy
         +/aO+MISAVhjyuSI/igrWtSVI9JBL1j5Ydbkf8MJjs92YPS5eERAE3zlFfESqDBsujpO
         EyqGVUd9iMVF/7IwgtgjftYgpXov0VsYJ9KQ4ZRZXkZuPR1MqMNX9nPniWEe9isClRfu
         +bRg==
X-Gm-Message-State: AOJu0YwXNbsFAZADgL+x2KZwm1XuWXYcAtHJK8jd4FuccKxmqc9JaBOk
	tla3X1NJntBY3kxd/TPJuclr8sHXz2/2aptMQthHhiR5K0JR6uyB1UGtKMVdo44FV0pPL755xMO
	f5TiV7Q==
X-Google-Smtp-Source: AGHT+IELTRFHW9KUb9D80Nbvrwyz0fNQE4bUdMf4smEIgxSpRcYtBKnsaEnIrAtTdAW2ja3MqRjx5g0/Rl8=
X-Received: from pjbpq4.prod.google.com ([2002:a17:90b:3d84:b0:30a:7da4:f075])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:224e:b0:321:b953:85ad
 with SMTP id 98e67ed59e1d1-3234dc61e08mr12748477a91.30.1755541227800; Mon, 18
 Aug 2025 11:20:27 -0700 (PDT)
Date: Mon, 18 Aug 2025 11:20:26 -0700
In-Reply-To: <20250813192313.132431-4-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250813192313.132431-1-mlevitsk@redhat.com> <20250813192313.132431-4-mlevitsk@redhat.com>
Message-ID: <aKNu6gYNO1j_Wpdj@google.com>
Subject: Re: [PATCH 3/3] KVM: x86: Fix the interaction between SMM and the
 asynchronous pagefault
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org, Borislav Petkov <bp@alien8.de>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 13, 2025, Maxim Levitsky wrote:
> Currently a #SMI can cause KVM to drop an #APF ready event and
> subsequently causes the guest to never resume the task that is waiting
> for it.
> This can result in tasks becoming permanently stuck within the guest.
> 
> This happens because KVM flushes the APF queue without notifying the guest
> of completed APF requests when the guest exits to real mode.
> 
> And the SMM exit code calls kvm_set_cr0 with CR.PE == 0, which triggers
> this code.
> 
> It must be noted that while this flush is reasonable to do for the actual
> real mode entry, it is actually achieves nothing because it is too late to
> flush this queue on SMM exit.
> 
> To fix this, avoid doing this flush altogether, and handle the real
> mode entry/exits in the same way KVM already handles the APIC
> enable/disable events:
> 
> APF completion events are not injected while APIC is disabled,
> and once APIC is re-enabled, KVM raises the KVM_REQ_APF_READY request
> which causes the first pending #APF ready event to be injected prior
> to entry to the guest mode.
> 
> This change also has the side benefit of preserving #APF events if the
> guest temporarily enters real mode - for example, to call firmware -
> although such usage should be extermery rare in modern operating systems.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 11 +++++++----
>  arch/x86/kvm/x86.h |  1 +
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3d45a4cd08a4..5dfe166025bf 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1118,15 +1118,18 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
>  	}
>  
>  	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
> -		kvm_clear_async_pf_completion_queue(vcpu);
> -		kvm_async_pf_hash_reset(vcpu);
> -
>  		/*
>  		 * Clearing CR0.PG is defined to flush the TLB from the guest's
>  		 * perspective.
>  		 */
>  		if (!(cr0 & X86_CR0_PG))
>  			kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
> +
> +		/*
> +		 * Re-check APF completion events, when the guest re-enables paging.
> +		 */
> +		if ((cr0 & X86_CR0_PG) && kvm_pv_async_pf_enabled(vcpu))

I'm tempted to make this an elif, i.e.

		if (!(cr0 & X86_CR0_PG))
			kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
		else if (kvm_pv_async_pf_enabled(vcpu))
			kvm_make_request(KVM_REQ_APF_READY, vcpu);

In theory, that could set us up to fail if another CR0.PG=1 case is added, but I
like to think future us will be smart enough to turn it into:

		if (!(cr0 & X86_CR0_PG)) {
			kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
		} else {
			if (kvm_pv_async_pf_enabled(vcpu))
				kvm_make_request(KVM_REQ_APF_READY, vcpu);

			if (<other thing>)
				...
		}


> +			kvm_make_request(KVM_REQ_APF_READY, vcpu);
>  	}
>  
>  	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS)
> @@ -3547,7 +3550,7 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	return 0;
>  }
>  
> -static inline bool kvm_pv_async_pf_enabled(struct kvm_vcpu *vcpu)
> +bool kvm_pv_async_pf_enabled(struct kvm_vcpu *vcpu)

This is in the same file, there's no reason/need to expose this via x86.h.  The
overall diff is small enough that I'm comfortable hoisting this "up" as part of
the fix, especially since this needs to go to stable@.

If we use an elif, this?

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6bdf7ef0b535..2bc41e562314 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1030,6 +1030,13 @@ bool kvm_require_dr(struct kvm_vcpu *vcpu, int dr)
 }
 EXPORT_SYMBOL_GPL(kvm_require_dr);
 
+static inline bool kvm_pv_async_pf_enabled(struct kvm_vcpu *vcpu)
+{
+       u64 mask = KVM_ASYNC_PF_ENABLED | KVM_ASYNC_PF_DELIVERY_AS_INT;
+
+       return (vcpu->arch.apf.msr_en_val & mask) == mask;
+}
+
 static inline u64 pdptr_rsvd_bits(struct kvm_vcpu *vcpu)
 {
        return vcpu->arch.reserved_gpa_bits | rsvd_bits(5, 8) | rsvd_bits(1, 2);
@@ -1122,15 +1129,15 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
        }
 
        if ((cr0 ^ old_cr0) & X86_CR0_PG) {
-               kvm_clear_async_pf_completion_queue(vcpu);
-               kvm_async_pf_hash_reset(vcpu);
-
                /*
                 * Clearing CR0.PG is defined to flush the TLB from the guest's
-                * perspective.
+                * perspective.  If the guest is (re)enabling, check for async
+                * #PFs that were completed while paging was disabled.
                 */
                if (!(cr0 & X86_CR0_PG))
                        kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+               else if (kvm_pv_async_pf_enabled(vcpu))
+                       kvm_make_request(KVM_REQ_APF_READY, vcpu);
        }
 
        if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS)
@@ -3524,13 +3531,6 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
        return 0;
 }
 
-static inline bool kvm_pv_async_pf_enabled(struct kvm_vcpu *vcpu)
-{
-       u64 mask = KVM_ASYNC_PF_ENABLED | KVM_ASYNC_PF_DELIVERY_AS_INT;
-
-       return (vcpu->arch.apf.msr_en_val & mask) == mask;
-}
-
 static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 {
        gpa_t gpa = data & ~0x3f;

