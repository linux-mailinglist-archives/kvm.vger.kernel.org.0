Return-Path: <kvm+bounces-51953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 96AC0AFEC11
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:35:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EC72188F921
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B6052E54A1;
	Wed,  9 Jul 2025 14:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3dJ8bDSj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0AC5383
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 14:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752071577; cv=none; b=renlay1vUXQAXZ2VMEqidxGiNYJMu+ZHyBcQnYqOFKvb5rkieP2cnWfukjHW3GjAc/cIKMU1Z00vnokEqH0I1WL6FHU+KuvChRZjw+RTVYe7+Vue959rIWj+GGK6iUQvSJOa/IAwqdomMBRPMpYj1EU/Yj3+2U1NMgBhMZlf/3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752071577; c=relaxed/simple;
	bh=ovqkVli+b/UQep+PHBkOGaOJ07QyXkcoNYybF+DsujA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e5wf011dSD0H6K9LXj+2r9gkp+lELVQ3y476OPVd97I/FWdHCJvUhjDiQAbPJV3Gec20tTKwcyc2hg8OAOEDIVFkU/NU/DHWKZOWRZVN/DqxDx0OOdT5QA7RFOaxv/hSRCdaLmn7QpXoPsShQv5Ny+JdySnw9awb+V8AwS5rsNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3dJ8bDSj; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b31df10dfadso7281a12.0
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 07:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752071575; x=1752676375; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C9/xhJmjy2rLIZxKKzW6ro2FkPNU0oPIzYtGesYW088=;
        b=3dJ8bDSjSWITbw6nyp6LfD4sHXsqCnZZ5xZCqN1KQiLSVnYBpkKGENxln1QrIOjU+p
         iaqju9ztqna7pCjMENE1F1yI/48C5r1G4LVeeLcUNXlpJ7agKsPS8I9An7qvWEcmpws1
         kJSt4sQSEOExjM2KjhkKM+MzTlZztD1mz6+kOG3B9MtmVIEuStjUgcNPxHWQWSvOmGDC
         I6Wo+k2aXZC0oymtxmHw9JoBtpKzK18QTH/co9u0pOfDBXvgoTGbU/UJ4ZjtPZH7Vvr1
         lL4Jko7wPZsjc93uD3HpHXlmI9dkeodM+dItd3ypEEb3S6WcDunKf/Ks2LC7AehPeyf3
         HYCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752071575; x=1752676375;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C9/xhJmjy2rLIZxKKzW6ro2FkPNU0oPIzYtGesYW088=;
        b=gFY4P04dwebj1RXo2qp9x82HiphfCZ8sDpMavRtCjNSkAgr4daqwN2dizTYgOvvRAy
         V5pClbpf4VM0FCrLuWBhqfFNhkEUnUuIAXsE5MLU3gqPL/J96Nf9bIKWLAvqAwXjAw8W
         8xsNeQAx2FlAnAXdlo97KXVCbTf8dPvmjQX8bMNRbCfJh0vAUCW6U8HPpZ7Ti5OJLOxT
         k2uRXEy1cVhUG6VuuJOv+xgVrbNRt9iRAWOLHv02PcdC8phl5YmjIEeK666YUs7jcLOo
         O3ZAIUzNyLoFdU1nZ3Qu9R73KJAmypooRd95RbJcZLnmEPWlboe42QwouILqGb7grz1c
         c7Uw==
X-Forwarded-Encrypted: i=1; AJvYcCWX8t9ECXRIL8B7oPwIDblpHt6RCBYrpTOluVqCsq8dRPV5nsUYfc3sn5HMrnHdch1UQto=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCTvq5ULbSqFJxVpyUWbk+buKMQquDxl5WVpj1Iuf6WJnyTTVl
	aZydQ/JXFw7lg6DTlpwdq2QiHqO/BHaIZz4zoM6Qb+uau2bJ0fbEi2LH3bo/FF/cUazFqulfLaq
	UiGjN+g==
X-Google-Smtp-Source: AGHT+IFKuOE5lgwdlGHNy1lCZ7TwQDn1+bdhSNR81ksxO40QnKs9T785BesYEgmtMl+0X/8qr3Jk0zEtI+w=
X-Received: from pjtd3.prod.google.com ([2002:a17:90b:43:b0:312:18d4:6d5e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1652:b0:312:e744:5b76
 with SMTP id 98e67ed59e1d1-31c3c30b03fmr191979a91.33.1752071574877; Wed, 09
 Jul 2025 07:32:54 -0700 (PDT)
Date: Wed, 9 Jul 2025 07:32:53 -0700
In-Reply-To: <20250709033242.267892-16-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-16-Neeraj.Upadhyay@amd.com>
Message-ID: <aG59lcEc3ZBq8aHZ@google.com>
Subject: Re: [RFC PATCH v8 15/35] x86/apic: Unionize apic regs for 32bit/64bit
 access w/o type casting
From: Sean Christopherson <seanjc@google.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com, 
	kai.huang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 09, 2025, Neeraj Upadhyay wrote:
> Define apic_page construct to unionize APIC register 32bit/64bit
> accesses and use it in apic_{get|set}*() to avoid using type
> casting.
> 
> As Secure AVIC APIC driver requires accessing APIC page at byte

No, it does not.  Literally all two callers of get_reg_bitmap(), the only user
of ->bytes, immediately cast the return to a "void *".

And you most definitely don't need a common, unionized struct to be able to reference
a byte offset, just define a "struct secure_apic_page".

> offsets (to get an APIC register's bitmap start address), support
> byte access granularity in apic_page (in addition to 32-bit and
> 64-bit accesses).
> 
> One caveat of this change is that the generated code is slighly
> larger. Below is the code generation for apic_get_reg() using
> gcc-14.2:
> 
> - Without change:
> 
> apic_get_reg:
> 
> 89 f6       mov    %esi,%esi
> 8b 04 37    mov    (%rdi,%rsi,1),%eax
> c3          ret
> 
> - With change:
> 
> apic_get_reg:
> 
> c1 ee 02    shr    $0x2,%esi
> 8b 04 b7    mov    (%rdi,%rsi,4),%eax
> c3          ret
> 
> lapic.o text size change is shown below:
> 
> Obj        Old-size      New-size
> 
> lapic.o    28800         28832
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v7:
>  - Commit log update.
> 
>  arch/x86/include/asm/apic.h | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index 07ba4935e873..b7cbe9ba363e 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -525,26 +525,43 @@ static inline int apic_find_highest_vector(void *bitmap)
>  	return -1;
>  }
>  
> +struct apic_page {
> +	union {
> +		u64     regs64[PAGE_SIZE / 8];
> +		u32     regs[PAGE_SIZE / 4];
> +		u8      bytes[PAGE_SIZE];
> +	};
> +} __aligned(PAGE_SIZE);
> +
>  static inline u32 apic_get_reg(void *regs, int reg)
>  {
> -	return *((u32 *) (regs + reg));
> +	struct apic_page *ap = regs;
> +
> +	return ap->regs[reg / 4];
>  }

NAK.

I really, *really* don't like this patch.  IMO, the casting code is more "obvious"
and thus easier to follow.  And there is still casting going on, i.e. to a
"struct apic_page".

_If_ we want to go this route, then all of the open coded literals need to be
replaced with sizeof().  But I'd still very strongly prefer we not do this in
the first place.

Jumping ahead a bit, I also recommend the secure AVIC stuff name its global
varaible "secure_apic_page", because just "apic_page" could result in avoidable
collisions.

There are also a number of extraneous local variables in x2apic_savic.c, some of
which are actively dangerous.  E.g. using a local "bitmap" in savic_eoi() makes
it possible to reuse a pointer and access the wrong bitmap.

E.g.

---
 arch/x86/include/asm/apic.h         | 40 ++++--------------
 arch/x86/kernel/apic/x2apic_savic.c | 65 +++++++++++------------------
 2 files changed, 32 insertions(+), 73 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index e8a32a3eea86..a26e66d66444 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -536,67 +536,41 @@ static inline int apic_find_highest_vector(void *bitmap)
 	return -1;
 }
 
-struct apic_page {
-	union {
-		u64     regs64[PAGE_SIZE / 8];
-		u32     regs[PAGE_SIZE / 4];
-		u8      bytes[PAGE_SIZE];
-	};
-} __aligned(PAGE_SIZE);
-
 static inline u32 apic_get_reg(void *regs, int reg)
 {
-	struct apic_page *ap = regs;
-
-	return ap->regs[reg / 4];
+	return *((u32 *) (regs + reg));
 }
 
 static inline void apic_set_reg(void *regs, int reg, u32 val)
 {
-	struct apic_page *ap = regs;
-
-	ap->regs[reg / 4] = val;
+	*((u32 *) (regs + reg)) = val;
 }
 
 static __always_inline u64 apic_get_reg64(void *regs, int reg)
 {
-	struct apic_page *ap = regs;
-
 	BUILD_BUG_ON(reg != APIC_ICR);
-
-	return ap->regs64[reg / 8];
+	return *((u64 *) (regs + reg));
 }
 
 static __always_inline void apic_set_reg64(void *regs, int reg, u64 val)
 {
-	struct apic_page *ap = regs;
-
 	BUILD_BUG_ON(reg != APIC_ICR);
-	ap->regs64[reg / 8] = val;
-}
-
-static inline unsigned int get_vec_bit(unsigned int vec)
-{
-	/*
-	 * The registers are 32-bit wide and 16-byte aligned.
-	 * Compensate for the resulting bit number spacing.
-	 */
-	return vec + 96 * (vec / 32);
+	*((u64 *) (regs + reg)) = val;
 }
 
 static inline void apic_clear_vector(int vec, void *bitmap)
 {
-	clear_bit(get_vec_bit(vec), bitmap);
+	clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
 }
 
 static inline void apic_set_vector(int vec, void *bitmap)
 {
-	set_bit(get_vec_bit(vec), bitmap);
+	set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
 }
 
 static inline int apic_test_vector(int vec, void *bitmap)
 {
-	return test_bit(get_vec_bit(vec), bitmap);
+	return test_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
 }
 
 /*
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 2849f2354bf9..99d5f6104bc2 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -17,7 +17,11 @@
 
 #include "local.h"
 
-static struct apic_page __percpu *apic_page __ro_after_init;
+struct secure_apic_page {
+	u8 *regs[PAGE_SIZE];
+} __aligned(PAGE_SIZE);
+
+static struct secure_apic_page __percpu *secure_apic_page __ro_after_init;
 
 static inline void savic_wr_control_msr(u64 val)
 {
@@ -31,9 +35,7 @@ static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 
 static inline void *get_reg_bitmap(unsigned int cpu, unsigned int offset)
 {
-	struct apic_page *ap = per_cpu_ptr(apic_page, cpu);
-
-	return &ap->bytes[offset];
+	return &per_cpu_ptr(secure_apic_page, cpu)->regs[offset];
 }
 
 static inline void update_vector(unsigned int cpu, unsigned int offset,
@@ -51,7 +53,7 @@ static inline void update_vector(unsigned int cpu, unsigned int offset,
 
 static u32 savic_read(u32 reg)
 {
-	struct apic_page *ap = this_cpu_ptr(apic_page);
+	void *ap = this_cpu_ptr(secure_apic_page);
 
 	/*
 	 * When Secure AVIC is enabled, rdmsr/wrmsr of APIC registers
@@ -129,14 +131,10 @@ static inline void self_ipi_reg_write(unsigned int vector)
 
 static void send_ipi_dest(unsigned int cpu, unsigned int vector, bool nmi)
 {
-	if (nmi) {
-		struct apic_page *ap = per_cpu_ptr(apic_page, cpu);
-
-		apic_set_reg(ap, SAVIC_NMI_REQ, 1);
-		return;
-	}
-
-	update_vector(cpu, APIC_IRR, vector, true);
+	if (nmi)
+		apic_set_reg(per_cpu_ptr(secure_apic_page, cpu), SAVIC_NMI_REQ, 1);
+	else
+		update_vector(cpu, APIC_IRR, vector, true);
 }
 
 static void send_ipi_allbut(unsigned int vector, bool nmi)
@@ -166,7 +164,6 @@ static inline void self_ipi(unsigned int vector, bool nmi)
 
 static void savic_icr_write(u32 icr_low, u32 icr_high)
 {
-	struct apic_page *ap = this_cpu_ptr(apic_page);
 	unsigned int dsh, vector;
 	u64 icr_data;
 	bool nmi;
@@ -193,12 +190,12 @@ static void savic_icr_write(u32 icr_low, u32 icr_high)
 	icr_data = ((u64)icr_high) << 32 | icr_low;
 	if (dsh != APIC_DEST_SELF)
 		savic_ghcb_msr_write(APIC_ICR, icr_data);
-	apic_set_reg64(ap, APIC_ICR, icr_data);
+	apic_set_reg64(this_cpu_ptr(secure_apic_page), APIC_ICR, icr_data);
 }
 
 static void savic_write(u32 reg, u32 data)
 {
-	struct apic_page *ap = this_cpu_ptr(apic_page);
+	struct secure_apic_page *ap = this_cpu_ptr(secure_apic_page);
 
 	switch (reg) {
 	case APIC_LVTT:
@@ -303,19 +300,15 @@ static void savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
 static void savic_eoi(void)
 {
 	unsigned int cpu;
-	void *bitmap;
 	int vec;
 
 	cpu = raw_smp_processor_id();
-	bitmap = get_reg_bitmap(cpu, APIC_ISR);
-	vec = apic_find_highest_vector(bitmap);
+	vec = apic_find_highest_vector(get_reg_bitmap(cpu, APIC_ISR));
 	if (WARN_ONCE(vec == -1, "EOI write while no active interrupt in APIC_ISR"))
 		return;
 
-	bitmap = get_reg_bitmap(cpu, APIC_TMR);
-
 	/* Is level-triggered interrupt? */
-	if (apic_test_vector(vec, bitmap)) {
+	if (apic_test_vector(vec, get_reg_bitmap(cpu, APIC_TMR))) {
 		update_vector(cpu, APIC_ISR, vec, false);
 		/*
 		 * Propagate the EOI write to hv for level-triggered interrupts.
@@ -333,18 +326,6 @@ static void savic_eoi(void)
 	}
 }
 
-static void init_apic_page(struct apic_page *ap)
-{
-	u32 apic_id;
-
-	/*
-	 * Before Secure AVIC is enabled, APIC msr reads are intercepted.
-	 * APIC_ID msr read returns the value from the Hypervisor.
-	 */
-	apic_id = native_apic_msr_read(APIC_ID);
-	apic_set_reg(ap, APIC_ID, apic_id);
-}
-
 static void savic_teardown(void)
 {
 	/* Disable Secure AVIC */
@@ -354,13 +335,17 @@ static void savic_teardown(void)
 
 static void savic_setup(void)
 {
-	void *backing_page;
+	struct secure_apic_page *ap = this_cpu_ptr(secure_apic_page);
 	enum es_result res;
 	unsigned long gpa;
 
-	backing_page = this_cpu_ptr(apic_page);
-	init_apic_page(backing_page);
-	gpa = __pa(backing_page);
+	/*
+	 * Before Secure AVIC is enabled, APIC msr reads are intercepted.
+	 * APIC_ID msr read returns the value from the Hypervisor.
+	 */
+	apic_set_reg(ap, APIC_ID, native_apic_msr_read(APIC_ID));
+
+	gpa = __pa(ap);
 
 	/*
 	 * The NPT entry for a vCPU's APIC backing page must always be
@@ -389,8 +374,8 @@ static int savic_probe(void)
 		/* unreachable */
 	}
 
-	apic_page = alloc_percpu(struct apic_page);
-	if (!apic_page)
+	secure_apic_page = alloc_percpu(struct secure_apic_page);
+	if (!secure_apic_page)
 		snp_abort();
 
 	return 1;

base-commit: 620bd94fb00da8482556057cea765656b8263b71
--

