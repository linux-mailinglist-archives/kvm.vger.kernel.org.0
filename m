Return-Path: <kvm+bounces-72705-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WJW8AA1pqGl3uQAAu9opvQ
	(envelope-from <kvm+bounces-72705-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 18:17:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4358E205026
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 18:16:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CA2B931314DF
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 17:12:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A91AA37AA7F;
	Wed,  4 Mar 2026 17:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MlvDXOBM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE12637A498
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 17:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772644316; cv=none; b=UqKmXmmFfwKcmYCKmTqIrioXUTYpol4zlMiPToDynA2wjKqylsCbsIrJcDnjr5Fv3PGMVfJ1Bxu7NrbPoIrbJscZ6T4+hj3V+oTlbavzEEExbJAWclS18eOS7u150Y5EGu83m1xbQuvCm0oodYfUS9lIQZZ40KrdBNXshS5CeUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772644316; c=relaxed/simple;
	bh=/cr+TZvz4nMQXK3VhxoBpQPSuiKI1gHj3FHUS+VETN8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kRfyfjCt4pVMI8j+4GHyBBTO4T8zyPGE8x7iWQOdDyVzJMC9sSTvNiCA4m8dbmpy1xLejwi2iW2gp+wjJn4recx0pKWviNYsP63cRb2jTBuXFVpB5hAHkl22yUHQOSvU8jwKiep0LBAIn8dmxRzb9yOIEEH4veF6w0Dei6lunrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MlvDXOBM; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae65d5cc57so77974395ad.2
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 09:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772644315; x=1773249115; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EHQlqz3/R8SNWRfWXbHO7qOOJnbiFSL7FXZONNoHgbA=;
        b=MlvDXOBML3wAsjevd8OsLJqwuODYbdI6QPKdaYVV53gy9lrpfZH5xjr0PkL3TUIeW4
         1W1EohqJtWh+Pg6Z1LVQiyxdOZvOWENZrKbQhAdfiz8hKSyAWAMn6pjaBvCuS/PGCAK4
         fWSY/bGoz/VxbKHvd/WU1J6ZI2iaDnSDCl+Nm16Slan4or8Fu9Nmjc2uFn1TN6WLT+D7
         XxuyDBhMugQtv/irKKGHJC8lxj2OhYg3RpkM0FeVyNSikShaEimhL+J1G63ngTsIrWuD
         mjnUcjdKlKRsPIbX56oGs2iICGHrbU16dgx6IE2btNp6XSHcPomqRXYhEP6R6+QP6ajb
         ru3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772644315; x=1773249115;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EHQlqz3/R8SNWRfWXbHO7qOOJnbiFSL7FXZONNoHgbA=;
        b=upoySHMFUe8hockmmYPpp/xNvJRwbXGAdQuDSiEzBq9oDH6gi+6dzwZWmuFbA2lsOF
         kt0b/y/9QE0pJUMYdEjmuV5rMYe/NVuWlMxnC4pNtiw4S2RqRwSIi+9+F1NKe5dlt3zO
         SLJ0jpz73fiC6/LJnx6l6irf3WOr8NeIGKO7PkjAUX4hF3zcEJdz6NzdiEyyt5rf1VXc
         ASZK6aSmOakHd/BKng8o99fPmVH7JR4ZGdKaBzYthVYJ2szl80WDd19Qz333Um23c6S4
         qQ9yQv7JkpF1/UJ8dNvChsE2SgoJLkqvTVTd/Ys+idrvgqSm+fBQ+0BY6PRd4nGNL2zr
         rLOg==
X-Forwarded-Encrypted: i=1; AJvYcCVsNvZOOBtQULhY6bRMic+0Cr4qOFCpGOocGoKF+XaAQURVm5cd1EbE32lGRuSK8LoTBFc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVimqHlL1RopQhHojpnqhSspbSA/pWv7JxYRj3jgyDuEH9fe27
	qg6WrMZ0HGTZf4wnWd1N55eU7UMD68btx7aFK4MLTTcHAraP3dbTVxpM6c6JScn7fYiKnR97rFO
	uyNtDAg==
X-Received: from plov20.prod.google.com ([2002:a17:902:8d94:b0:2ab:3ae7:5481])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cecf:b0:2ae:5a76:e26c
 with SMTP id d9443c01a7336-2ae6ab67292mr24664785ad.55.1772644314855; Wed, 04
 Mar 2026 09:11:54 -0800 (PST)
Date: Wed, 4 Mar 2026 09:11:53 -0800
In-Reply-To: <20260224005500.1471972-9-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224005500.1471972-1-jmattson@google.com> <20260224005500.1471972-9-jmattson@google.com>
Message-ID: <aahn2ZfDAJTj-Afn@google.com>
Subject: Re: [PATCH v5 08/10] KVM: x86: nSVM: Save/restore gPAT with KVM_{GET,SET}_NESTED_STATE
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 4358E205026
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72705-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Feb 23, 2026, Jim Mattson wrote:
> Add a 'flags' field to the SVM nested state header, and use bit 0 of the
> flags to indicate that gPAT is stored in the nested state.
> 
> If in guest mode with NPT enabled, store the current vmcb->save.g_pat value
> into the header of the nested state, and set the flag.
> 
> Note that struct kvm_svm_nested_state_hdr is included in a union padded to
> 120 bytes, so there is room to add the flags field and the gpat field
> without changing any offsets.
> 
> Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/include/uapi/asm/kvm.h |  5 +++++
>  arch/x86/kvm/svm/nested.c       | 17 +++++++++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 846a63215ce1..664d04d1db3f 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -495,6 +495,8 @@ struct kvm_sync_regs {
>  
>  #define KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE	0x00000001
>  
> +#define KVM_STATE_SVM_VALID_GPAT	0x00000001
> +
>  /* vendor-independent attributes for system fd (group 0) */
>  #define KVM_X86_GRP_SYSTEM		0
>  #  define KVM_X86_XCOMP_GUEST_SUPP	0
> @@ -531,6 +533,9 @@ struct kvm_svm_nested_state_data {
>  
>  struct kvm_svm_nested_state_hdr {
>  	__u64 vmcb_pa;
> +	__u32 flags;
> +	__u32 reserved;
> +	__u64 gpat;
>  };
>  
>  /* for KVM_CAP_NESTED_STATE */
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 26f758e294ab..5a35277f2364 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1893,6 +1893,10 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
>  	/* First fill in the header and copy it out.  */
>  	if (is_guest_mode(vcpu)) {
>  		kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb12_gpa;
> +		if (nested_npt_enabled(svm)) {
> +			kvm_state.hdr.svm.flags |= KVM_STATE_SVM_VALID_GPAT;

Bugger.  This isn't going to work.  KVM doesn't reserve any bytes in the header
for SVM, so there's no guarantee/requirement that old userspace won't provide
garbage.  The flag needs to go in kvm_nested_state.flags.  We only reserved space
for 16 flags between VMX and SVM, but that's a future problem as we can always
add e.g. KVM_STATE_NESTED_EXT_FLAGS when we've exausted the current space.

Ugh.  And vmx_set_nested_state() doesn't check for unsupported flags, at all.
But that too is largely a future problem though, i.e. is a non-issue until nVMX
wants to add a new flag.  *sigh*

Anyways, for gPAT, unless I'm missing something, I'm going to squash this:

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 664d04d1db3f..0c1f97c9a2d8 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -485,6 +485,7 @@ struct kvm_sync_regs {
 #define KVM_STATE_NESTED_EVMCS         0x00000004
 #define KVM_STATE_NESTED_MTF_PENDING   0x00000008
 #define KVM_STATE_NESTED_GIF_SET       0x00000100
+#define KVM_STATE_NESTED_GPAT_VALID    0x00000200
 
 #define KVM_STATE_NESTED_SMM_GUEST_MODE        0x00000001
 #define KVM_STATE_NESTED_SMM_VMXON     0x00000002
@@ -495,8 +496,6 @@ struct kvm_sync_regs {
 
 #define KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE        0x00000001
 
-#define KVM_STATE_SVM_VALID_GPAT       0x00000001
-
 /* vendor-independent attributes for system fd (group 0) */
 #define KVM_X86_GRP_SYSTEM             0
 #  define KVM_X86_XCOMP_GUEST_SUPP     0
@@ -533,8 +532,6 @@ struct kvm_svm_nested_state_data {
 
 struct kvm_svm_nested_state_hdr {
        __u64 vmcb_pa;
-       __u32 flags;
-       __u32 reserved;
        __u64 gpat;
 };
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 991ee4c03363..099bf8ac10ee 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1848,7 +1848,7 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
        if (is_guest_mode(vcpu)) {
                kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb12_gpa;
                if (nested_npt_enabled(svm)) {
-                       kvm_state.hdr.svm.flags |= KVM_STATE_SVM_VALID_GPAT;
+                       kvm_state->flags |= KVM_STATE_NESTED_GPAT_VALID;
                        kvm_state.hdr.svm.gpat = svm->vmcb->save.g_pat;
                }
                kvm_state.size += KVM_STATE_NESTED_SVM_VMCB_SIZE;
@@ -1914,7 +1914,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
        if (kvm_state->flags & ~(KVM_STATE_NESTED_GUEST_MODE |
                                 KVM_STATE_NESTED_RUN_PENDING |
-                                KVM_STATE_NESTED_GIF_SET))
+                                KVM_STATE_NESTED_GIF_SET |
+                                KVM_STATE_NESTED_GPAT_VALID))
                return -EINVAL;
 
        /*
@@ -1984,7 +1985,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
         * vmcb_save_area_cached validation above, because gPAT is L2
         * state, but the vmcb_save_area_cached is populated with L1 state.
         */
-       if ((kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT) &&
+       if ((kvm_state->flags & KVM_STATE_NESTED_GPAT_VALID) &&
            !kvm_pat_valid(kvm_state->hdr.svm.gpat))
                goto out_free;
 
@@ -2013,7 +2014,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
        svm_switch_vmcb(svm, &svm->nested.vmcb02);
 
        if (nested_npt_enabled(svm)) {
-               if (kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT)
+               if (kvm_state->flags & KVM_STATE_NESTED_GPAT_VALID)
                        vmcb_set_gpat(svm->vmcb, kvm_state->hdr.svm.gpat);
        }
--

One could argue we should even be more paranoid and do this as well:

	if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)) {
		if (kvm_state->flags & KVM_STATE_NESTED_GPAT_VALID)
			return -EINVAL:

		svm_leave_nested(vcpu);
		svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
		return 0;
	}

but KVM doesn't enforce GUEST_MODE for KVM_STATE_NESTED_RUN_PENDING, and it's
easy to just ignore gPAT, so I'm inclined to not bother.

