Return-Path: <kvm+bounces-41285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E610A65ACB
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:31:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 40DC618895D1
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:28:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AE421A2C27;
	Mon, 17 Mar 2025 17:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D7OMJy2i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319D21537CB
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 17:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742232518; cv=none; b=saJZWWkPwaL6sktZHC6BjKh8/rpuekcYCbkUuITF1NZA4PazZiU7B4rkoLFy6UW+pXD5i5wDgZdT9VK95J892+wbbfhSY3L6NJk805TmENTXpRLb+UBtuuLirilSVDuNdHjFM0iFmeLT6QoxUTS90nLGKuBME/x5V59PbGMik5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742232518; c=relaxed/simple;
	bh=n1HtH0CH+ItuYcREfDLanVJtBgzilNRkaXyx6UAvirM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h7zRB9EjAFjDKzM8Z6Ol8H0YMGLbUMMKnL3XjQCkrcyQGZcHefjhdEg+KUA4CJbRXE3Ti2Fz1j9xYgypRoIOce2PpOKNnQETJwE6fIfswk+TX5KALvjVn/dkPGnlYEG5gYxODuMynkDdlw6RQrEW6ncrySp5zM91IB8xaZ8OPRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D7OMJy2i; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff55176edcso3220369a91.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742232516; x=1742837316; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2BX7bVuSKahRyPKb9YA83comeFxklFZtwaF75tpX/Pg=;
        b=D7OMJy2iJMi4l35L2r7FIuG12nYLjmqPy8uT/oHG0iLBNNrDIGFugUdLMNV0GyGhRe
         DSLrn/tF7/sxdvbQXe8+GJZn89f8aIqMmgceawGNb7v+Mlk636HjVZ3MzSTJsaFBK/zl
         tPKKVYOeCftirv1PcC2GGrEjLGVCelhYg1uIois3GKgXETnuAuHU9LADThG60UnA6bOb
         xCDsNujaKrZT6lANVHbzAVDgoIGCmckDhzSv71q+vplG7nUvdWa0FQCI/9Aw8oph7EtP
         tIqIpgsUNACdvhj097qtKHWvb6mhZ/AaBW3xqtdWdFU0qH+6o1ae97dEWA77aLpri+cA
         l3Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742232516; x=1742837316;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2BX7bVuSKahRyPKb9YA83comeFxklFZtwaF75tpX/Pg=;
        b=aj87m3D0HJmncyBaqvYVHjipOTVB/oIqQ1JhrOvAo+U/GAcly07K1tP9eYTaQ4Po5P
         0FgbJo6IP6i2F2DpJ+UipJRQrr4rFLmBMPydVu6OQY+Of2x6kPg0SCsuQDkTCY3Bqf38
         E4LqSQuahIGFTduOoxQL7toXN6vdTRBUfqTEqLhdPdWP13I9XQjljvnNVC0t0v7yeIt9
         hPp2u/kGazc9CAoH6hJKi5n59ZXvihCTO55VN6HzWAKTKeVfDLxfKsEC1Mb0ci6DQK1g
         wLYVL8gAd2gZcvEKkkqFI/lvjVNFH5UwOmaH6VFwjaRdaTaCgp2q2a8CbpfOSBhMHitq
         4erw==
X-Gm-Message-State: AOJu0YzLzGALsLQhzJ/fZ8lDZja6auvaIvXd1fNLhsmym9jLqZD3cPGB
	eWaOFqelceKVqDCgVfM9iayRV90pGOqtd2akWB6wzDswOUIADp3CspG0x7qf47IeT0HtiofJrQX
	Eww==
X-Google-Smtp-Source: AGHT+IG8HqXW25R2SEcblihnltUxnDotlqWu3JGVurlbYqgtjNjgC2Oe+rqDw4Lug+IJBnWfx4OHQTfY+Zc=
X-Received: from pjbsy7.prod.google.com ([2002:a17:90b:2d07:b0:2ff:6945:bce8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b46:b0:2ea:3f34:f18f
 with SMTP id 98e67ed59e1d1-30151ca0bf3mr15217984a91.19.1742232516460; Mon, 17
 Mar 2025 10:28:36 -0700 (PDT)
Date: Mon, 17 Mar 2025 10:28:34 -0700
In-Reply-To: <48899db8-c506-b4d1-06cd-6ba9041437f7@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <6053e8eba1456e4c1bf667f38cc20a0ea05bc72c.1742232014.git.thomas.lendacky@amd.com>
 <48899db8-c506-b4d1-06cd-6ba9041437f7@amd.com>
Message-ID: <Z9hbwkqwDKlyPsqv@google.com>
Subject: Re: [PATCH] KVM: SVM: Fix SNP AP destroy race with VMRUN
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 17, 2025, Tom Lendacky wrote:
> On 3/17/25 12:20, Tom Lendacky wrote:
> > An AP destroy request for a target vCPU is typically followed by an
> > RMPADJUST to remove the VMSA attribute from the page currently being
> > used as the VMSA for the target vCPU. This can result in a vCPU that
> > is about to VMRUN to exit with #VMEXIT_INVALID.
> > 
> > This usually does not happen as APs are typically sitting in HLT when
> > being destroyed and therefore the vCPU thread is not running at the time.
> > However, if HLT is allowed inside the VM, then the vCPU could be about to
> > VMRUN when the VMSA attribute is removed from the VMSA page, resulting in
> > a #VMEXIT_INVALID when the vCPU actually issues the VMRUN and causing the
> > guest to crash. An RMPADJUST against an in-use (already running) VMSA
> > results in a #NPF for the vCPU issuing the RMPADJUST, so the VMSA
> > attribute cannot be changed until the VMRUN for target vCPU exits. The
> > Qemu command line option '-overcommit cpu-pm=on' is an example of allowing
> > HLT inside the guest.
> > 
> > Use kvm_test_request() to ensure that the target vCPU sees the AP destroy
> > request before returning to the initiating vCPU.
> > 
> > Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
> > Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Sean,
> 
> If you're ok with this approach for the fix, this patch may need to be
> adjusted given your series around AP creation fixes, unless you want to
> put this as an early patch in your series. Let me know what you'd like
> to do.

This is unsafe as it requires userspace to do KVM_RUN _and_ for the vCPU to get
far enough along to consume the request.

Very off-the-cuff, but I assume KVM_REQ_UPDATE_PROTECTED_GUEST_STATE just needs
to be annotated with KVM_REQUEST_WAIT.

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 04e6c5604bc3..67abfe97c600 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -124,7 +124,8 @@
        KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_HV_TLB_FLUSH \
        KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
-#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE   KVM_ARCH_REQ(34)
+#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE \
+       KVM_ARCH_REQ_FLAGS(34, KVM_REQUEST_WAIT)
 
 #define CR0_RESERVED_BITS                                               \
        (~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \



