Return-Path: <kvm+bounces-73085-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IAr5CQ71qmkjZAEAu9opvQ
	(envelope-from <kvm+bounces-73085-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 16:38:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 97705223F8F
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 16:38:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D8D69301C901
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 15:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 496333E5EC9;
	Fri,  6 Mar 2026 15:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FJ62VV4v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F9C36606C
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 15:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772811510; cv=none; b=jTIK2yTYt8G5jsvb4/0qzs3sNo5SvUq08bZ9aowW1rgNFo5YFfoXvJ7G4nNjqsug5gLb89ApwdG1MMYfFn/rK8tru5wvC9B6FfTCK7blivW/CvuDMbPFcT3KiseaE71ouurZ3d7iQ4I864C+Ck/NpZqfC/xbaXNTL/NaGYmtYvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772811510; c=relaxed/simple;
	bh=HNGPanmt7OEkw06ZGU9wiOrw5ybzwryX3OcQHOlMWnA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qRx4Pd3oKxOFlY0i961Y5VipTmYMuTKJH42esT+ymXkhQJ4FQRnRtsoDwnffhq3An9W8lIRTv4QZEIWAoKXdJK6RBnSKtC3mun7mgofbNLVqHItlrVWn6+4xe2M3RFpD5K6TV8TjtdTjv37nbm+AFIRzp87NX+vVkfdyMVdr5u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FJ62VV4v; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3598ab49242so4241648a91.3
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 07:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772811508; x=1773416308; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sx02o7a+4SJDNg17+NUERvJzkVHQXkD7fYhXTg4jZjw=;
        b=FJ62VV4vnNXa7UHptWD0tI402d+cehnJOHSZBcOkpjLBOulNWOvT9wmjOcF7vPt3x6
         1+xAJGDqZ6R3gNGfAAx5/YevOmHC/kLsGS8cn0pVBIK8XXC3r8SRWi+AnM1CNAqKA8ho
         Pi0Eq1uMI1cUjILsg/1YgOuBanxSC6M1SiVR7E3BB4W7qo6WGYNrFb1Id9XfnQYmKGZD
         VRYIUu/M2ww1CNQK0G+u2pcHFOiyIlaoO3uS0ICNd+WRglPeQrfFMoyQMq0gvMPVrJFy
         ziK9rnl8P9vrGS+s3493E/sNibaKzs2E3oRnHMCsIEFncn16hdp+SRooSz9NQ/zAFY6Z
         w/zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772811508; x=1773416308;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sx02o7a+4SJDNg17+NUERvJzkVHQXkD7fYhXTg4jZjw=;
        b=KA4F/AfMyb/gn/+tUUVTUoc5nBngQx4HRwV30RjaiLAY3/O+3fy3mIhyTdQSoJ3yBp
         4xjmLw4+QHvoM2wOTjkyxmkNPMNWmmg9DwSuxq4tau4PQyWrnTVhEfZ+Lk6hc/5p890n
         pt74K4jqKAPsy6h+jQ1TFVzPdJbjO7RgjVFjWUNyvT/Vq+7K2aRA+AWSkPHZUIEtuSma
         NUALS8os+xiBRllxZPRo7uJIp8qOVTdKZR3q/zLY4H/CjPfU8EqAzks+MaOrjc4o1xlT
         OuWRQILfA3JxDJZ0Ptfka2pw6rhdFvHtcNvZLOJ2UeAn+RIpYp0DncqCCzXhWiN3uU7Y
         cYDA==
X-Forwarded-Encrypted: i=1; AJvYcCVVMu7dg0WYdi5+kCv+A3AlR+a85ohyPe82GqDVqNwW7LsO16L7HNUsggyIsAPuInGD274=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywdo/Ow+lKAuwetABaATw6Vn87CkIayJkkKJDlBYPVy9MaZQRka
	Uy8aYi60zfxGYv5YEB1/c93aaEjtNXx9LDWuIxMDyWa9cvdAAWtox3cEhBU9NBlkvcYsQYSKFRU
	LJHaV6w==
X-Received: from pjvh2.prod.google.com ([2002:a17:90a:db82:b0:359:97db:ab44])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:52c7:b0:353:5c16:aa7
 with SMTP id 98e67ed59e1d1-359be30c444mr2162642a91.25.1772811508285; Fri, 06
 Mar 2026 07:38:28 -0800 (PST)
Date: Fri, 6 Mar 2026 07:38:27 -0800
In-Reply-To: <20260306102047.29760-1-sarunkod@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260306102047.29760-1-sarunkod@amd.com>
Message-ID: <aar082uQQhXKNiSQ@google.com>
Subject: Re: [PATCH] KVM: x86: Add support for cmpxchg16b emulation
From: Sean Christopherson <seanjc@google.com>
To: Sairaj Kodilkar <sarunkod@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org, suravee.suthikulpanit@amd.com, 
	vasant.hegde@amd.com, nikunj.dadhania@amd.com, Manali.Shukla@amd.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 97705223F8F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73085-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.937];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026, Sairaj Kodilkar wrote:
> AMD and Intel both provides support for 128 bit cmpxchg operands using
> cmpxchg8b/cmpxchg16b instructions (opcode 0FC7). However, kvm does not
> support emulating cmpxchg16b (i.e when destination memory is 128 bit and
> REX.W = 1) which causes emulation failure when QEMU guest performs a
> cmpxchg16b on a memory region setup as a IO.
> 
> Hence extend cmpxchg8b to perform cmpxchg16b when the destination memory
> is 128 bit.
> 
> Signed-off-by: Sairaj Kodilkar <sarunkod@amd.com>
> ---
> Background:
> 
> The AMD IOMMU driver writes 256-bit device table entries with two
> 128-bit cmpxchg operations. For guests using hardware-accelerated
> vIOMMU (still in progress), QEMU traps device table accesses to set up
> nested page tables. Without 128-bit cmpxchg emulation, KVM cannot
> handle these traps and DTE access emulation fails.

Please put this paragraph in the changelog proper, the "why" matters greatly here.

> QEMU implementation that traps DTE accesses:
> https://github.com/AMDESE/qemu-iommu/blob/wip/for_iommufd_hw_queue-v8_amd_viommu_20260106/hw/i386/amd_viommu.c#L517
> ---
>  arch/x86/kvm/emulate.c     | 48 +++++++++++++++++++++++++++++++-------
>  arch/x86/kvm/kvm_emulate.h |  1 +
>  2 files changed, 41 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index c8e292e9a24d..e1a08cd3274b 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -2188,17 +2188,18 @@ static int em_call_near_abs(struct x86_emulate_ctxt *ctxt)
>  	return rc;
>  }
>  
> -static int em_cmpxchg8b(struct x86_emulate_ctxt *ctxt)
> +static int __handle_cmpxchg8b(struct x86_emulate_ctxt *ctxt)
>  {
> -	u64 old = ctxt->dst.orig_val64;
> +	u64 old64 = ctxt->dst.orig_val64;
>  
> -	if (ctxt->dst.bytes == 16)
> +	/* Use of the REX.W prefix promotes operation to 128 bits */
> +	if (ctxt->rex_bits & REX_W)

Uh, yeah, and the caller specifically pivoted on this size.  I'm a-ok with a
sanity check, but it should be exactly that, e.g.

	if (WARN_ON_ONCE(8 + (ctxt->rex_bits & REX_W) * 8 != ctxt->dst.bytes))
		return X86EMUL_UNHANDLEABLE;

>  		return X86EMUL_UNHANDLEABLE;
>  
> -	if (((u32) (old >> 0) != (u32) reg_read(ctxt, VCPU_REGS_RAX)) ||
> -	    ((u32) (old >> 32) != (u32) reg_read(ctxt, VCPU_REGS_RDX))) {
> -		*reg_write(ctxt, VCPU_REGS_RAX) = (u32) (old >> 0);
> -		*reg_write(ctxt, VCPU_REGS_RDX) = (u32) (old >> 32);
> +	if (((u32) (old64 >> 0) != (u32) reg_read(ctxt, VCPU_REGS_RAX)) ||
> +	    ((u32) (old64 >> 32) != (u32) reg_read(ctxt, VCPU_REGS_RDX))) {
> +		*reg_write(ctxt, VCPU_REGS_RAX) = (u32) (old64 >> 0);
> +		*reg_write(ctxt, VCPU_REGS_RDX) = (u32) (old64 >> 32);
>  		ctxt->eflags &= ~X86_EFLAGS_ZF;
>  	} else {
>  		ctxt->dst.val64 = ((u64)reg_read(ctxt, VCPU_REGS_RCX) << 32) |
> @@ -2209,6 +2210,37 @@ static int em_cmpxchg8b(struct x86_emulate_ctxt *ctxt)
>  	return X86EMUL_CONTINUE;
>  }
>  
> +static int __handle_cmpxchg16b(struct x86_emulate_ctxt *ctxt)
> +{
> +	__uint128_t old128 = ctxt->dst.val128;

There is zero chance you properly tested this patch.  Please write comprehensive
testcases in KUT's emulator64.c before posting the next version.

In writeback(), the OP_MEM case quite clearly operates on "unsigned long" values
*and* consumes orig_val in the locked case.

	case OP_MEM:
		if (ctxt->lock_prefix)
			return segmented_cmpxchg(ctxt,
						 op->addr.mem,
						 &op->orig_val,
						 &op->val,
						 op->bytes);
		else
			return segmented_write(ctxt,
					       op->addr.mem,
					       &op->val,
					       op->bytes);

And then emulator_cmpxchg_emulated() should be taught to do cmpxchg16b itself:

	/* guests cmpxchg8b have to be emulated atomically */
	if (bytes > 8 || (bytes & (bytes - 1)))
		goto emul_write;

That might be a big lift, e.g. to get a 16-byte uaccess version.  If it's
unreasonably difficult, we should reject emulation of LOCK CMPXCHG16B.

And this code would also need to be updated to copy the full 128-bit value.

	/* Copy full 64-bit value for CMPXCHG8B.  */
	ctxt->dst.orig_val64 = ctxt->dst.val64;

Maybe something like this?  Or maybe just copy 128 bits unconditionally (I'm not
sure if that could read uninitiatlized data or not).

	/* Copy the full 64/128-bit value for CMPXCHG8B/16B.  */
	if (IS_ENABLED(CONFIG_X86_64) && ctxt->dst.bytes == 16)
		ctxt->dst.orig_val128 = ctxt->dst.val128;
	else
		ctxt->dst.orig_val64 = ctxt->dst.val64;

> +
> +	/* Use of the REX.W prefix promotes operation to 128 bits */
> +	if (!(ctxt->rex_bits & REX_W))
> +		return X86EMUL_UNHANDLEABLE;
> +
> +	if (((u64) (old128 >> 0) != (u64) reg_read(ctxt, VCPU_REGS_RAX)) ||
> +	    ((u64) (old128 >> 64) != (u64) reg_read(ctxt, VCPU_REGS_RDX))) {
> +		*reg_write(ctxt, VCPU_REGS_RAX) = (u64) (old128 >> 0);
> +		*reg_write(ctxt, VCPU_REGS_RDX) = (u64) (old128 >> 64);
> +		ctxt->eflags &= ~X86_EFLAGS_ZF;
> +	} else {
> +		ctxt->dst.val128 =
> +			((__uint128_t) reg_read(ctxt, VCPU_REGS_RCX) << 64) |
> +			(u64) reg_read(ctxt, VCPU_REGS_RBX);
> +
> +		ctxt->eflags |= X86_EFLAGS_ZF;

IMO we should use a macro to handle 8b vs. 16b.  The code is going to be heinous
no matter what, and so to me, duplicating everything makes it twice as ugly,
whereas a macro makes it like 10% more ugly.

> +	}
> +	return X86EMUL_CONTINUE;
> +}
> +
> +static int em_cmpxchgxb(struct x86_emulate_ctxt *ctxt)
> +{
> +	if (ctxt->dst.bytes == 16)
> +		return __handle_cmpxchg16b(ctxt);
> +
> +	return __handle_cmpxchg8b(ctxt);
> +}
> +
>  static int em_ret(struct x86_emulate_ctxt *ctxt)
>  {
>  	int rc;
> @@ -4097,7 +4129,7 @@ static const struct gprefix pfx_0f_c7_7 = {
>  
>  
>  static const struct group_dual group9 = { {
> -	N, I(DstMem64 | Lock | PageTable, em_cmpxchg8b), N, N, N, N, N, N,
> +	N, I(DstMem64 | Lock | PageTable, em_cmpxchgxb), N, N, N, N, N, N,

Eh, I vote to keep it em_cmpxchg8b.  _If_ we want to capture that its size is
variable, maybe em_cmpxchg8b_16b?  em_cmpxchgxb just looks like a typo.

Sans correct writeback() handling, something like so:

---
 arch/x86/kvm/emulate.c     | 44 ++++++++++++++++++++++++--------------
 arch/x86/kvm/kvm_emulate.h |  2 ++
 2 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 6145dac4a605..3ec4555571fa 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2201,24 +2201,33 @@ static int em_call_near_abs(struct x86_emulate_ctxt *ctxt)
 	return rc;
 }
 
+#define em_cmpxchg8b_16b(__c, rbits, mbits)						  \
+do {											  \
+	u##mbits old = __c->dst.orig_val##mbits;					  \
+											  \
+	BUILD_BUG_ON(rbits * 2 != mbits);						  \
+											  \
+	if (((u##rbits)(old >> 0)     != (u##rbits)reg_read(__c, VCPU_REGS_RAX)) ||	  \
+	    ((u##rbits)(old >> rbits) != (u##rbits)reg_read(__c, VCPU_REGS_RDX))) {	  \
+		*reg_write(__c, VCPU_REGS_RAX) = (u##rbits)(old >> 0);			  \
+		*reg_write(__c, VCPU_REGS_RDX) = (u##rbits)(old >> rbits);		  \
+		__c->eflags &= ~X86_EFLAGS_ZF;						  \
+	} else {									  \
+		__c->dst.val##mbits = ((u##mbits)reg_read(__c, VCPU_REGS_RCX) << rbits) | \
+				       (u##rbits)reg_read(__c, VCPU_REGS_RBX);		  \
+		__c->eflags |= X86_EFLAGS_ZF;						  \
+	}										  \
+} while (0)
+
 static int em_cmpxchg8b(struct x86_emulate_ctxt *ctxt)
 {
-	u64 old = ctxt->dst.orig_val64;
-
-	if (ctxt->dst.bytes == 16)
+	if (WARN_ON_ONCE(8 + (ctxt->rex_bits & REX_W) * 8 != ctxt->dst.bytes))
 		return X86EMUL_UNHANDLEABLE;
 
-	if (((u32) (old >> 0) != (u32) reg_read(ctxt, VCPU_REGS_RAX)) ||
-	    ((u32) (old >> 32) != (u32) reg_read(ctxt, VCPU_REGS_RDX))) {
-		*reg_write(ctxt, VCPU_REGS_RAX) = (u32) (old >> 0);
-		*reg_write(ctxt, VCPU_REGS_RDX) = (u32) (old >> 32);
-		ctxt->eflags &= ~X86_EFLAGS_ZF;
-	} else {
-		ctxt->dst.val64 = ((u64)reg_read(ctxt, VCPU_REGS_RCX) << 32) |
-			(u32) reg_read(ctxt, VCPU_REGS_RBX);
-
-		ctxt->eflags |= X86_EFLAGS_ZF;
-	}
+	if (!(ctxt->rex_bits & REX_W))
+		em_cmpxchg8b_16b(ctxt, 32, 64);
+	else
+		em_cmpxchg8b_16b(ctxt, 64, 128);
 	return X86EMUL_CONTINUE;
 }
 
@@ -5418,8 +5427,11 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt, bool check_intercepts)
 			goto done;
 		}
 	}
-	/* Copy full 64-bit value for CMPXCHG8B.  */
-	ctxt->dst.orig_val64 = ctxt->dst.val64;
+	/* Copy the full 64/128-bit value for CMPXCHG8B/16B.  */
+	if (IS_ENABLED(CONFIG_X86_64) && ctxt->dst.bytes == 16)
+		ctxt->dst.orig_val128 = ctxt->dst.val128;
+	else
+		ctxt->dst.orig_val64 = ctxt->dst.val64;
 
 special_insn:
 
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index fb3dab4b5a53..0e9968319343 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -255,6 +255,7 @@ struct operand {
 	union {
 		unsigned long orig_val;
 		u64 orig_val64;
+		u64 orig_val128;
 	};
 	union {
 		unsigned long *reg;
@@ -268,6 +269,7 @@ struct operand {
 	union {
 		unsigned long val;
 		u64 val64;
+		__uint128_t val128;
 		char valptr[sizeof(avx256_t)];
 		sse128_t vec_val;
 		avx256_t vec_val2;

base-commit: 5128b972fb2801ad9aca54d990a75611ab5283a9
--

