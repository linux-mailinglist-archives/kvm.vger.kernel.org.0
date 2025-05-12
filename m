Return-Path: <kvm+bounces-46257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91AA2AB441C
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:54:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8AE23ADDD0
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:53:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C829296FC4;
	Mon, 12 May 2025 18:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RsHtlFP3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8FD258CC1
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747076049; cv=none; b=ki7vVsDqEmoeOkmlU1GlOSYAM7sN04TiJgd0hIXfrRd3Os5hAVm1yRhAFTP1FVAiBZWVmYBAkHTj5Mt62OJ7BrnvO21XlqfcLWe5udR3sriiR0sBl96oJC3xMg/c3kpg9xxEWybKUM6SiJpjPSh+33shlYLiFeD6vDRa5Q2AzWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747076049; c=relaxed/simple;
	bh=JSxc2uQS1+66+Lh74XqOtLZP07YRS6mgEmayJMCk6/E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=msLdqCzJ672Td28DwxiU95pKQfdMdOdYMCQ0piCuYDlf43j8q/wBq0jUruZRxZ4bl3Dz1C5Jy8mEkWrW4WakbydtKPlSbpyYAxrOXArFOP1clLp4h/WgQ2iviHEXl7QSILjLNfgYpbRFG4vpXDMv+v2y2Jb5N9HjifYHooLijW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RsHtlFP3; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30ab4d56096so4902556a91.0
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747076047; x=1747680847; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W4uoDzbBLJd7QAkF/AkM6h4dCLCMBNmAnD0UD06xFNI=;
        b=RsHtlFP3tBUZ7UZDM5Uyqpzn/pQGsSSqhvEjl4pTZgB6+xXGIKo4uPD6fY3MFTF/P7
         U8RAxHA9CD6yx6TJWANiSkxiS55712CLYzZOyV/sqwKtBPewyu9+08E6pbdnQIBLTqGS
         O1MwIREpZmf+oJmuYno6L15e+HkdLuH4IvtrNRjSq4CSTkK0Z6opi2MUmnoLTsrZjj9A
         jEKFftzn6IM49ttvYVqkkZDXsc5sIfemyzqqsZ65R+n73LYIPv1eb7oMhrnastSg/Vkx
         4ZE1DK6LwqcYCwEEfZ0xzw7WVSXMGOv+IufL2k1sc04RbYx7w1wVO7UU46bIa2DCAx10
         5krA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747076047; x=1747680847;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=W4uoDzbBLJd7QAkF/AkM6h4dCLCMBNmAnD0UD06xFNI=;
        b=rPLp2jReRcdAuxYf7lNsN0hq88Q+qMGsKibqd+lBk4DiCmOUAB1RVVCfFGz4yxfSQ5
         1kAh+6tG6jeJECk8JoQJrVdcxqp1KRRNrsAm2hLif0hcXOaV4qsHNjKTs2WOJxPGbIgd
         apqY7UJla1wBZ/k8qWEZIDYnCNXNfPnhE3b2pLbptb3SUD9Cm1wU8BZWdQgoS3t6yJpa
         e138gAxu6ur1NGmBx81iyyqwKr3QJrM0bMgBMEQLyWQIZWEBnlAK6eM9T0qOlz0x45ty
         lz85bDtAUcve0eeK0ZtOErCFgY36ZpPgDVvkYfNdLtYX5+KChBegrEyuz9dB4dPp4XGR
         EYQw==
X-Forwarded-Encrypted: i=1; AJvYcCXZDu9Xn4/5y5T6kiXzDvbE60GrSbaUOEIIFiJsHpkYBnA/m9mL/DdYSOyf+0aho4WTfds=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTKI4z3OP673YZHmXzMBoi2IjfS26VxEXfkRQH6xiveifBVhSQ
	rnvLsCLAxjBoNa/+mctibKI2A/JsjYdLnxiVZPJaU9weRxgAkLCtaWig+m8+G6mgY9C+IMLR9DG
	fHg==
X-Google-Smtp-Source: AGHT+IGCZJ/eZ/AOlCQQiuh9XV3QntmEBRUnqMYmiI9dWW0R+dssCHX15mrFy7PORzGDdl8a6riNBWQpzqc=
X-Received: from pjbso5.prod.google.com ([2002:a17:90b:1f85:b0:2ff:6e58:8a03])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a0b:b0:305:5f25:fcf8
 with SMTP id 98e67ed59e1d1-30c3cafea7amr20801632a91.5.1747076047504; Mon, 12
 May 2025 11:54:07 -0700 (PDT)
Date: Mon, 12 May 2025 11:54:05 -0700
In-Reply-To: <20250313203702.575156-12-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250313203702.575156-1-jon@nutanix.com> <20250313203702.575156-12-jon@nutanix.com>
Message-ID: <aCJDzU1p_SFNRIJd@google.com>
Subject: Re: [RFC PATCH 11/18] KVM: VMX: Enhance EPT violation handler for PROT_USER_EXEC
From: Sean Christopherson <seanjc@google.com>
To: Jon Kohler <jon@nutanix.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2025, Jon Kohler wrote:
> From: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
>=20
> Add EPT_VIOLATION_PROT_USER_EXEC (6) to reflect the user executable
> permissions of a given address when Intel MBEC is enabled.
>=20
> Refactor usage of EPT_VIOLATION_RWX_TO_PROT to understand all of the
> specific bits that are now possible with MBEC.
>=20
> Intel SDM 'Exit Qualification for EPT Violations' states the following
> for Bit 6.
>   If the =E2=80=9Cmode-based execute control=E2=80=9D VM-execution contro=
l is 0, the
>   value of this bit is undefined. If that control is 1, this bit is
>   the logical-AND of bit 10 in the EPT paging-structure entries used
>   to translate the guest-physical address of the access causing the
>   EPT violation. In this case, it indicates whether the guest-physical
>   address was executable for user-mode linear addresses.
>=20
>   Bit 6 is cleared to 0 if (1) the =E2=80=9Cmode-based execute control=E2=
=80=9D
>   VM-execution control is 1; and (2) either (a) any of EPT
>   paging-structure entries used to translate the guest-physical address
>   of the access causing the EPT violation is not present; or
>   (b) 4-level EPT is in use and the guest-physical address sets any
>   bits in the range 51:48.
>=20
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> Co-developed-by: Jon Kohler <jon@nutanix.com>
> Signed-off-by: Jon Kohler <jon@nutanix.com>
>=20
> ---
>  arch/x86/include/asm/vmx.h     |  7 ++++---
>  arch/x86/kvm/mmu/paging_tmpl.h | 15 ++++++++++++---
>  arch/x86/kvm/vmx/vmx.c         |  7 +++++--
>  3 files changed, 21 insertions(+), 8 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index ffc90d672b5d..84c5be416f5c 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -587,6 +587,7 @@ enum vm_entry_failure_code {
>  #define EPT_VIOLATION_PROT_READ		BIT(3)
>  #define EPT_VIOLATION_PROT_WRITE	BIT(4)
>  #define EPT_VIOLATION_PROT_EXEC		BIT(5)
> +#define EPT_VIOLATION_PROT_USER_EXEC	BIT(6)

Ugh, TDX added this as EPT_VIOLATION_EXEC_FOR_RING3_LIN (apparently the TDX=
 module
enables MBEC?).  I like your name a lot better.

>  #define EPT_VIOLATION_PROT_MASK		(EPT_VIOLATION_PROT_READ  | \
>  					 EPT_VIOLATION_PROT_WRITE | \
>  					 EPT_VIOLATION_PROT_EXEC)

Hmm, so I think EPT_VIOLATION_PROT_MASK should include EPT_VIOLATION_PROT_U=
SER_EXEC.
The existing TDX change does not, because unfortunately the bit is undefine=
d if
MBEC is unsupported, but that's easy to solve by unconditionally clearing t=
he bit
in handle_ept_violation().  And then when nested-EPT MBEC support comes alo=
ng,
handle_ept_violation() can be modified to conditionally clear the bit based=
 on
whether or not the current MMU supports MBEC.

I'll post a patch to include the bit in EPT_VIOLATION_PROT_MASK, and opport=
unistically
change the name.

> @@ -596,7 +597,7 @@ enum vm_entry_failure_code {
>  #define EPT_VIOLATION_READ_TO_PROT(__epte) (((__epte) & VMX_EPT_READABLE=
_MASK) << 3)
>  #define EPT_VIOLATION_WRITE_TO_PROT(__epte) (((__epte) & VMX_EPT_WRITABL=
E_MASK) << 3)
>  #define EPT_VIOLATION_EXEC_TO_PROT(__epte) (((__epte) & VMX_EPT_EXECUTAB=
LE_MASK) << 3)
> -#define EPT_VIOLATION_RWX_TO_PROT(__epte) (((__epte) & VMX_EPT_RWX_MASK)=
 << 3)

Why?  There's no escaping the fact that EXEC, a.k.a. X, is doing double dut=
y as
"exec for all" and "kernel exec".  And KVM has nearly two decades of histor=
y
using EXEC/X to refer to "exec for all".  I see no reason to throw all of t=
hat
away and discard the intuitive and pervasive RWX logic.

> @@ -510,7 +511,15 @@ static int FNAME(walk_addr_generic)(struct guest_wal=
ker *walker,
>  		 * Note, pte_access holds the raw RWX bits from the EPTE, not
>  		 * ACC_*_MASK flags!
>  		 */
> -		walker->fault.exit_qualification |=3D EPT_VIOLATION_RWX_TO_PROT(pte_ac=
cess);
> +		walker->fault.exit_qualification |=3D
> +			EPT_VIOLATION_READ_TO_PROT(pte_access);
> +		walker->fault.exit_qualification |=3D
> +			EPT_VIOLATION_WRITE_TO_PROT(pte_access);
> +		walker->fault.exit_qualification |=3D
> +			EPT_VIOLATION_EXEC_TO_PROT(pte_access);

IMO, this is a big net negative.  I much prefer the existing code, as it hi=
ghlights
that USER_EXEC is the oddball.

> +		if (vcpu->arch.pt_guest_exec_control)

This is wrong on multiple fronts.  As mentioned earlier in the series, this=
 is a
property of the MMU (more specifically, the root role), not of the vCPU.

And consulting MBEC support *only* when synthesizing the exit qualifcation =
is
wrong, because it means pte_access contains bogus data when consumed by
FNAME(gpte_access).  At a glance, FNAME(gpte_access) probably needs to be m=
odified
to take in the page role, e.g. like FNAME(sync_spte) and FNAME(prefetch_gpt=
e)
already adjust the access based on the owning shadow page's access mask.

> +			walker->fault.exit_qualification |=3D
> +				EPT_VIOLATION_USER_EXEC_TO_PROT(pte_access);
>  	}
>  #endif
>  	walker->fault.address =3D addr;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 116910159a3f..0aadfa924045 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5809,7 +5809,7 @@ static int handle_task_switch(struct kvm_vcpu *vcpu=
)
> =20
>  static int handle_ept_violation(struct kvm_vcpu *vcpu)
>  {
> -	unsigned long exit_qualification;
> +	unsigned long exit_qualification, rwx_mask;
>  	gpa_t gpa;
>  	u64 error_code;
> =20
> @@ -5839,7 +5839,10 @@ static int handle_ept_violation(struct kvm_vcpu *v=
cpu)
>  	error_code |=3D (exit_qualification & EPT_VIOLATION_ACC_INSTR)
>  		      ? PFERR_FETCH_MASK : 0;
>  	/* ept page table entry is present? */
> -	error_code |=3D (exit_qualification & EPT_VIOLATION_PROT_MASK)
> +	rwx_mask =3D EPT_VIOLATION_PROT_MASK;
> +	if (vcpu->arch.pt_guest_exec_control)
> +		rwx_mask |=3D EPT_VIOLATION_PROT_USER_EXEC;
> +	error_code |=3D (exit_qualification & rwx_mask)
>  		      ? PFERR_PRESENT_MASK : 0;

As mentioned above, if KVM clears EPT_VIOLATION_PROT_USER_EXEC when it's
undefined, then this can simply use EPT_VIOLATION_PROT_MASK unchanged.

> =20
>  	if (error_code & EPT_VIOLATION_GVA_IS_VALID)
> --=20
> 2.43.0
>=20

