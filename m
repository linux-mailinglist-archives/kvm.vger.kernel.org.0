Return-Path: <kvm+bounces-30332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52AF79B9598
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 17:39:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7033A1C20F65
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 16:39:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E61BA1C75E2;
	Fri,  1 Nov 2024 16:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kJFIDUCy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB241381BA
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 16:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730479157; cv=none; b=pj8iNbL73mjEbBQU846mTN2GKkrUpI8ERg5vt4vxW8Q5FY8XC6wP+HdO2J56A0CfrLL0yDmp3XlPfcIVoKNvbdUiyClCyFpqeNktYPsoGiCz5v/uzMTkoVnved7Vs2lfJQCXH/EA8wh+E+9WyphWFFrXafoCWjiNcsxR+o1fORE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730479157; c=relaxed/simple;
	bh=uQ8uo+vABx8f5nA+/74ndXUQovEhFjcPT/qHC7gnL8E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eJ/thQXkVtONPQLN0U2XH8ngIB6NXbvod/VANqbWImIIXu368dXcvjVCSXe0XQuhYzaCzzmuTzFRIEXOil/Ut6gFgszp8fy5g6DVkD74knjJFAHSKG0Kp/eaSLj8G89M/rlNKoDSaT4Lt6s6P9IKUEyc/cciumUzEJooPyyJkIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kJFIDUCy; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e35a643200so46726297b3.0
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 09:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730479154; x=1731083954; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HbKJeki4dzd2XPRMM44KMwAEciOK8zIOcm2qr7s1wcQ=;
        b=kJFIDUCyJ7E1KXCs6goijwzhXxTdE7p5z/03sTDrZfOB/qxt4ifZlA88lmEhVQeUYS
         M8+ACEiFKNcaiOn+4NIFHcBjApNytfa7mAYOO+ZEaLivnoNBCniealGtC5VCEPQ9G470
         qKZjOOdpzEI7d1My9V9r7Jvf7YgHxxRYg6ctK3RbqqdVscSBPAufG4L/zOrN13C4cvTS
         EDIgyKkBa/vA3xeUVnW15he5zoWLrOGJ4tms5N7Pvn14f3FC1LCmqpz3YDOvkevigU09
         5oYrJtigHVF+3NTGZY3JhFykuJc/OJNP1837mRr0dGPjY9xQ5kOOyaF+7wauwjzJPMKM
         3PjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730479154; x=1731083954;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HbKJeki4dzd2XPRMM44KMwAEciOK8zIOcm2qr7s1wcQ=;
        b=Imxz7obDGxBRL/YQgls+r3GhvZTzOWKSnCpRUpH4P/bDubcWgQX9qm/zPzHCtyHKRM
         A5uvB8KivcSfmpWi1dxXZRNFJtSY59t9M1n5OZBBof0T5lec8rPx5RJOsuVM3uVLKmAf
         EPrC6yJjkHwpIpXB83Nnq4mW7RUR0SCPXeDCpK9WbbsPGKaenV91Anqjlbr+v3xx6VfF
         YxTLddptN2dNCHp4UsXf/ZOYGezxNJA4saQbsap6dCAeqM56XAhnTSkdd5IDPNrUw/2h
         66UFkog/Hog2Sdw3bThRYLx3PjUsHp9qdDuPamgpJvsaODAa06/IfKyVb+V3c4gQozXa
         spVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIdQI3RI1OBkX/QmZKRtHIQLPPMR+6tP5y+dO53E/xtaB9gYoMV8shLpjGYzQp1VPMez4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgRstQm0iN9ei9xt/Ui4TIOY/c9RZyzKdwMdccqrJ2jcKisl02
	LglHtF3CJ3WHPSxoC3dxZKyPf19zaAuygVDYf2t6ZnMZvsj2vvSxJaZlxERtXnaCn7UAYjvtimP
	0pQ==
X-Google-Smtp-Source: AGHT+IEZ/As1CqiUNvhsvRDX72pDJbWbYUewG6GHPtYMfGfRk/DC8Z0VB7WVVgFtrlwKk4B3jrTtoBP5VLU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:67ca:b0:6e3:d670:f62a with SMTP id
 00721157ae682-6ea52518e31mr269617b3.3.1730479153876; Fri, 01 Nov 2024
 09:39:13 -0700 (PDT)
Date: Fri, 1 Nov 2024 09:39:12 -0700
In-Reply-To: <1cace497215b025ed8b5f7815bdeb23382ecad32.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
 <20240826022255.361406-2-binbin.wu@linux.intel.com> <ZyKbxTWBZUdqRvca@google.com>
 <3f158732a66829faaeb527a94b8df78d6173befa.camel@intel.com>
 <ZyLWMGcgj76YizSw@google.com> <1cace497215b025ed8b5f7815bdeb23382ecad32.camel@intel.com>
Message-ID: <ZyUEMLoy6U3L4E8v@google.com>
Subject: Re: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace generically
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 01, 2024, Kai Huang wrote:
> On Thu, 2024-10-31 at 07:54 -0700, Sean Christopherson wrote:
> > On Thu, Oct 31, 2024, Kai Huang wrote:
> > -	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
> > -	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
> > -		/* MAP_GPA tosses the request to the user space. */
> > -		return 0;
> > +	r = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl, &ret);
> > +	if (r <= r)
> > +		return r;
> 
> ... should be:
> 
> 	if (r <= 0)
> 		return r;
> 
> ?
> 
> Another option might be we move "set hypercall return value" code inside
> __kvm_emulate_hypercall().  So IIUC the reason to split
> __kvm_emulate_hypercall() out is for TDX, and while non-TDX uses RAX to carry
> the hypercall return value, TDX uses R10.
> 
> We can additionally pass a "kvm_hypercall_set_ret_func" function pointer to
> __kvm_emulate_hypercall(), and invoke it inside.  Then we can change
> __kvm_emulate_hypercall() to return: 
>     < 0 error, 
>     ==0 return to userspace, 
>     > 0 go back to guest.

Hmm, and the caller can still handle kvm_skip_emulated_instruction(), because the
return value is KVM's normal pattern.

I like it!

But, there's no need to pass a function pointer, KVM can write (and read) arbitrary
GPRs, it's just avoided in most cases so that the sanity checks and available/dirty
updates are elided.  For this code though, it's easy enough to keep kvm_rxx_read()
for getting values, and eating the overhead of a single GPR write is a perfectly
fine tradeoff for eliminating the return multiplexing.

Lightly tested.  Assuming this works for TDX and passes testing, I'll post a
mini-series next week.

--
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 1 Nov 2024 09:04:00 -0700
Subject: [PATCH] KVM: x86: Refactor __kvm_emulate_hypercall() to accept reg
 names, not values

Rework __kvm_emulate_hypercall() to take the names of input and output
(guest return value) registers, as opposed to taking the input values and
returning the output value.  As part of the refactor, change the actual
return value from __kvm_emulate_hypercall() to be KVM's de facto standard
of '0' == exit to userspace, '1' == resume guest, and -errno == failure.

Using the return value for KVM's control flow eliminates the multiplexed
return value, where '0' for KVM_HC_MAP_GPA_RANGE (and only that hypercall)
means "exit to userspace".

Use the direct GPR accessors to read values to avoid the pointless marking
of the registers as available, but use kvm_register_write_raw() for the
guest return value so that the innermost helper doesn't need to multiplex
its return value.  Using the generic kvm_register_write_raw() adds very
minimal overhead, so as a one-off in a relatively slow path it's well
worth the code simplification.

Suggested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 15 +++++++++----
 arch/x86/kvm/x86.c              | 40 +++++++++++++--------------------
 2 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6d9f763a7bb9..9e66fde1c4e4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2179,10 +2179,17 @@ static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
 	kvm_set_or_clear_apicv_inhibit(kvm, reason, false);
 }
 
-unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
-				      unsigned long a0, unsigned long a1,
-				      unsigned long a2, unsigned long a3,
-				      int op_64_bit, int cpl);
+int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
+			      unsigned long a0, unsigned long a1,
+			      unsigned long a2, unsigned long a3,
+			      int op_64_bit, int cpl, int ret_reg);
+
+#define __kvm_emulate_hypercall(_vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl, ret)	\
+	____kvm_emulate_hypercall(vcpu,						\
+				  kvm_##nr##_read(vcpu), kvm_##a0##_read(vcpu),	\
+				  kvm_##a1##_read(vcpu), kvm_##a2##_read(vcpu),	\
+				  kvm_##a3##_read(vcpu), op_64_bit, cpl, VCPU_REGS_##ret)
+
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e09daa3b157c..425a301911a6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9998,10 +9998,10 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
 	return kvm_skip_emulated_instruction(vcpu);
 }
 
-unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
-				      unsigned long a0, unsigned long a1,
-				      unsigned long a2, unsigned long a3,
-				      int op_64_bit, int cpl)
+int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
+			      unsigned long a0, unsigned long a1,
+			      unsigned long a2, unsigned long a3,
+			      int op_64_bit, int cpl, int ret_reg)
 {
 	unsigned long ret;
 
@@ -10086,15 +10086,18 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
 
 out:
 	++vcpu->stat.hypercalls;
-	return ret;
+
+	if (!op_64_bit)
+		ret = (u32)ret;
+
+	kvm_register_write_raw(vcpu, ret_reg, ret);
+	return 1;
 }
-EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);
+EXPORT_SYMBOL_GPL(____kvm_emulate_hypercall);
 
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
-	unsigned long nr, a0, a1, a2, a3, ret;
-	int op_64_bit;
-	int cpl;
+	int r;
 
 	if (kvm_xen_hypercall_enabled(vcpu->kvm))
 		return kvm_xen_hypercall(vcpu);
@@ -10102,23 +10105,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	if (kvm_hv_hypercall_enabled(vcpu))
 		return kvm_hv_hypercall(vcpu);
 
-	nr = kvm_rax_read(vcpu);
-	a0 = kvm_rbx_read(vcpu);
-	a1 = kvm_rcx_read(vcpu);
-	a2 = kvm_rdx_read(vcpu);
-	a3 = kvm_rsi_read(vcpu);
-	op_64_bit = is_64_bit_hypercall(vcpu);
-	cpl = kvm_x86_call(get_cpl)(vcpu);
-
-	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
-	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
-		/* MAP_GPA tosses the request to the user space. */
+	r = __kvm_emulate_hypercall(vcpu, rax, rbx, rcx, rdx, rsi,
+				    is_64_bit_hypercall(vcpu),
+				    kvm_x86_call(get_cpl)(vcpu), RAX);
+	if (r <= 0)
 		return 0;
 
-	if (!op_64_bit)
-		ret = (u32)ret;
-	kvm_rax_write(vcpu, ret);
-
 	return kvm_skip_emulated_instruction(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);

base-commit: 911785b796e325dec83b32050f294e278a306211
-- 

