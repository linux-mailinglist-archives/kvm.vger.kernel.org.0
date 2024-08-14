Return-Path: <kvm+bounces-24144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 60628951CF3
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 16:21:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5F903B2A259
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 14:21:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4FBA1B3F16;
	Wed, 14 Aug 2024 14:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hOWQqIGY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEB21B32B8
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 14:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723645270; cv=none; b=ofAj7GRGmSLAMIEGi75EaIehaSt8PENU6JsWkE3N+NCG8L6KJhsEt5Ft0AWWbhVXkc0AzQr0KkKXlDAH/H/h2HArJmDrRvlcutmu33UOVmPIxp38/BreMJw1qZuIurNCfURaEbiK9FNd8t1MY3T6uiokbbEkWL9F26HhaTcg70o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723645270; c=relaxed/simple;
	bh=KWPbFBFD+/3kp0sYWkC5naq5efakh6J4XRAhvmtV6RM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TfycwB2lwrjcV2TKkMHXTXI7frVb4U9NmvD8jaslgf/YA/j9/7ijsLDy0L9iRUkB1BFgIDdNBhbeQzBPqyzGMhEpuEOhl4L9f1bI3UoxhdqaaL5ogMBTwJJuf5GS9GoE9A0+Q43Vv4+OsXF5/2XRDvL26BXMXhGOuyyf21mczcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hOWQqIGY; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7106fcb5543so4706862b3a.2
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 07:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723645268; x=1724250068; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ibz0ymMg54eZMZxtA7rzG0mhrc8rFdXmWziKMFauBIM=;
        b=hOWQqIGYxFmBS2GH4kByIPRyunkv72xgJf+WP0ZyYRIJ1Y73P2R9Okp70H6fNL+dUy
         tsN1h6RIeJB1offIGwa9ojFOH4gURcrMAluZJOPC3MpZntnMCgEws+51PzcWpVdGO4eZ
         /p1Ef7L87PKGYbrHI1UegcTwQrJFN1v+bFjcrdMQuXr4CNa6NOjNFH5aFnwOaYWhFvwe
         i2wQcu0kUP9ETRvxHEi5/ycI3c/nt1sMxHtbxgiDos6BUtVJ6I3DVgCnvbMWz1PwzlPu
         uQoALk8EcowrlIx28vxysCCPiqt0kJaLCC0s5yevv4Utm9JlGpQnWRrWC03caomNPExD
         tmyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723645268; x=1724250068;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ibz0ymMg54eZMZxtA7rzG0mhrc8rFdXmWziKMFauBIM=;
        b=cxOjOGZjh+/QJFzQqV6l73JtsA712K5VM7qhUhWi/qk0aHq4CrZo6eDu/NWs1QGcWA
         CshXaQcn1rcoeGelmQq2GYMIky6bF/hwvI6QlKnjPYA4hlNHc5c6ASbDdX8yy0FMOoN1
         zCPyB9+AjyfBbWHuPb8ILIniaOKWvixV1vvM4Nmf/uw7d+aywtPh1bi5CbLwx5cepW3f
         2OOCHDnhr/vmcz6WB2meEdLcdqiK+x8+gbcJST21kxfMeU+hZZO3r4nU2XT//e9aGiGn
         okFlQKfLTC5kQaWW89vp2tA1Rl05Mp+b6Y+GpF+RP+OP/ZMqxMa/m55U1JKte//OHXZt
         fhsg==
X-Forwarded-Encrypted: i=1; AJvYcCWa2ajviBAJ6e8FyNO12Fgk4YYl+E33/ou4O8n7ToUEEBh0Hu81R61Av/FTeFSY3iAMtY7LxQwDeL3NB+MspML+48UL
X-Gm-Message-State: AOJu0Yyo3yzMOUwQZDtLwbj3H7odDcRzWWukaT5PxYhfUpgYxOTR+rxK
	cY6IAS0mmGdVbSnNp5HaQ0w4t1HcCRYezaQmWYUFqCtCn2T/GAQAtpzR3eg+WYUI/ip/nuFvraT
	7Fw==
X-Google-Smtp-Source: AGHT+IGx/HmqKQeNIzUKcT8uD2EB3slFOeWrdLpsi2E/sozxcn2/2LhmumDcBwKTUVsRYQYXtEsJPAwJDek=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8807:b0:70d:30a8:abaa with SMTP id
 d2e1a72fcca58-7126744c0acmr6496b3a.5.1723645267560; Wed, 14 Aug 2024 07:21:07
 -0700 (PDT)
Date: Wed, 14 Aug 2024 07:21:06 -0700
In-Reply-To: <20240814114230.hgzrh3cal6k6x2dn@yy-desk-7060>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com> <20240809190319.1710470-4-seanjc@google.com>
 <20240814114230.hgzrh3cal6k6x2dn@yy-desk-7060>
Message-ID: <Zry9Us0HVEDmhCB4@google.com>
Subject: Re: [PATCH 03/22] KVM: x86/mmu: Trigger unprotect logic only on
 write-protection page faults
From: Sean Christopherson <seanjc@google.com>
To: Yuan Yao <yuan.yao@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 14, 2024, Yuan Yao wrote:
> > @@ -5960,6 +5961,41 @@ void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> >  	write_unlock(&vcpu->kvm->mmu_lock);
> >  }
> >
> > +static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> > +				       u64 error_code, int *emulation_type)
> > +{
> > +	bool direct = vcpu->arch.mmu->root_role.direct;
> > +
> > +	/*
> > +	 * Before emulating the instruction, check if the error code
> > +	 * was due to a RO violation while translating the guest page.
> > +	 * This can occur when using nested virtualization with nested
> > +	 * paging in both guests. If true, we simply unprotect the page
> > +	 * and resume the guest.
> > +	 */
> > +	if (direct &&
> > +	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE) {
> > +		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa));
> > +		return RET_PF_FIXED;
> > +	}
> > +
> > +	/*
> > +	 * The gfn is write-protected, but if emulation fails we can still
> > +	 * optimistically try to just unprotect the page and let the processor
> > +	 * re-execute the instruction that caused the page fault.  Do not allow
> > +	 * retrying MMIO emulation, as it's not only pointless but could also
> > +	 * cause us to enter an infinite loop because the processor will keep
> > +	 * faulting on the non-existent MMIO address.  Retrying an instruction
> > +	 * from a nested guest is also pointless and dangerous as we are only
> > +	 * explicitly shadowing L1's page tables, i.e. unprotecting something
> > +	 * for L1 isn't going to magically fix whatever issue cause L2 to fail.
> > +	 */
> > +	if (!mmio_info_in_cache(vcpu, cr2_or_gpa, direct) && !is_guest_mode(vcpu))
> 
> Looks the mmio_info_in_cache() checking can be removed,
> emulation should not come here with RET_PF_WRITE_PROTECTED
> introduced, may WARN_ON_ONCE() it.

Yeah, that was my instinct as well.  I kept it mostly because I liked having the
comment, but also because I was thinking the cache could theoretically get a hit.
But that's not true.  KVM should return RET_PF_WRITE_PROTECTED if and only if
there is a memslot, and creating a memslot is supposed to invalidate the MMIO
cache by virtue of changing the memslot generation.

Unless someone feels strongly that the mmio_info_in_cache() call should be
deleted entirely, I'll tack on this patch.  The cache lookup is cheap, and IMO
it's helpful to explicitly document that it should be impossible to reach this
point with what appears to be MMIO.

---
 arch/x86/kvm/mmu/mmu.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 50695eb2ee22..7f3f57237f23 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5997,6 +5997,18 @@ static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	vcpu->arch.last_retry_eip = 0;
 	vcpu->arch.last_retry_addr = 0;
 
+	/*
+	 * It should be impossible to reach this point with an MMIO cache hit,
+	 * as RET_PF_WRITE_PROTECTED is returned if and only if there's a valid,
+	 * writable memslot, and creating a memslot should invalidate the MMIO
+	 * cache by way of changing the memslot generation.  WARN and disallow
+	 * retry if MMIO is detect, as retrying MMIO emulation is pointless and
+	 * could put the vCPU into an infinite loop because the processor will
+	 * keep faulting on the non-existent MMIO address.
+	 */
+	if (WARN_ON_ONCE(mmio_info_in_cache(vcpu, cr2_or_gpa, direct)))
+		return RET_PF_EMULATE;
+
 	/*
 	 * Before emulating the instruction, check to see if the access may be
 	 * due to L1 accessing nested NPT/EPT entries used for L2, i.e. if the
@@ -6029,17 +6041,15 @@ static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		return RET_PF_FIXED;
 
 	/*
-	 * The gfn is write-protected, but if emulation fails we can still
-	 * optimistically try to just unprotect the page and let the processor
+	 * The gfn is write-protected, but if KVM detects its emulating an
+	 * instruction that is unlikely to be used to modify page tables, or if
+	 * emulation fails, KVM can try to unprotect the gfn and let the CPU
 	 * re-execute the instruction that caused the page fault.  Do not allow
-	 * retrying MMIO emulation, as it's not only pointless but could also
-	 * cause us to enter an infinite loop because the processor will keep
-	 * faulting on the non-existent MMIO address.  Retrying an instruction
-	 * from a nested guest is also pointless and dangerous as we are only
-	 * explicitly shadowing L1's page tables, i.e. unprotecting something
-	 * for L1 isn't going to magically fix whatever issue cause L2 to fail.
+	 * retrying an instruction from a nested guest as KVM is only explicitly
+	 * shadowing L1's page tables, i.e. unprotecting something for L1 isn't
+	 * going to magically fix whatever issue cause L2 to fail.
 	 */
-	if (!mmio_info_in_cache(vcpu, cr2_or_gpa, direct) && !is_guest_mode(vcpu))
+	if (!is_guest_mode(vcpu))
 		*emulation_type |= EMULTYPE_ALLOW_RETRY_PF;
 
 	return RET_PF_EMULATE;

base-commit: 7d33880356496eb0640c6c825cc60898063c4902
--

