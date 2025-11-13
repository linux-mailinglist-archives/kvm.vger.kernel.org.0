Return-Path: <kvm+bounces-63059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AF708C5A4C5
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:17:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 24B434E42E4
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 22:17:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED03932694E;
	Thu, 13 Nov 2025 22:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fzkyU5kv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A816C326933
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 22:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763072211; cv=none; b=ddyZCYpvUh5qtMLauRjkz03OI72NfuDkvb7BdfPSrh8+04iOC2jlSPHTSOt64VsRjC7y6/eDOoK/1zdPcKKQ7jYKwvoXHvFzX1lwDmBQOidbYE8KLj+mEX4LEgF7iPHt0zzQA36Ne0/KMeSclSn+OaJuA+/YZpg7DD4klIyUtek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763072211; c=relaxed/simple;
	bh=YrPvvC78DcVV+WD3Lxn16NH8QR1mrcpNHdW/kFJpgoI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ckmg8mbbz28yMvdof1q1UNYYHx6nrBlgreGt1dJ0q/fTt7XhG4cF4iHpGu4FVycX2TTVSH/S3173x5U6d9jF8Brb1fKhoet+jxYBwNn1giAEYOFmNBlmXrjGg3g7MzlS9mpHaXrDkfqCtggIuMGiGAMgDh6yRYlRLeilUoId9+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fzkyU5kv; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34378c914b4so2062257a91.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 14:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763072209; x=1763677009; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XJ0so1Dc/Tcjqx77iXrmBHBcGNpRLjI2rEqnI8s+KfE=;
        b=fzkyU5kvA4f8WPMHFJMKMSs0fAnk0biLDhdNmBhWELR5jNzqy6TW+39DPuGHlevh1r
         xKxicCcZZlmazKI0hNLxNO58cL6l0KOcDNToEJXCz3f6OFm+1bmgE30Gal9kZyNcluhY
         RcQsLDNSYrosJg5DXDC0kt6sLVrDgd+1grDsyfJg/5fenUmwoGsPUiYJCxPBz8aTElji
         I/VQoZyRX/X9BcxDWjqQutp5MF7iizHdt7/udxrbDjVsxX9P1dDgDm4k7ukAvWb54PkE
         e0t/ggG/pSf2NsbqLeCUDlWh+eoy99LkON2D/OyVmBThq8Y6pqbdgtTdQ+RgUsH913Jp
         ZEYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763072209; x=1763677009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XJ0so1Dc/Tcjqx77iXrmBHBcGNpRLjI2rEqnI8s+KfE=;
        b=NQ32ucDM+f4sCI1lltwYaEiBS+4+on47Sktk/IibqeGTZxgOUvluHb5PFT35kRxiJ1
         uCvZi7OHdFfs0NkpEZ0PaoehqWj8dF8mVNZJfRpViHh5mDHcuKjXXjYif8F36w8wxcv0
         +CnEIaqVwOSaHtlTvJE8ke0ysjGobFLqaDbMe6QHmI9jw9HrAGuIsC96C5BSdO8nLiS8
         8D62dAk0KQvbk7kX/OJbnyqMxXICUjoveu3R8P/Z6LcikcOx2kqturqu0VN17RjL08UL
         K0sG1hAHT/ZtFXNjfigdvs/UB9BZq1vBr4THF8mEntJrR8scPd0F/W0C3SjtbEXJra8S
         A5og==
X-Gm-Message-State: AOJu0YyN1+HtJX699yw9BA50nG8W3WJUwYBx0hSusKNodnqr23H/pPnG
	K5r1TCrTEd/AsHtBQXePehJ6M66nUiWJqIa/8gzBoE5aU//Fj4BNyWT/jetDQcpJjKz+WGieD2Q
	Hd1sKmg==
X-Google-Smtp-Source: AGHT+IFTcvFDNI+4BP0QllZu5ahML/elMMLsl7V/HGS9DicfOfSCUPbFdET+/m0IHyoe01XmI2jprwp8b0s=
X-Received: from pjbdj6.prod.google.com ([2002:a17:90a:d2c6:b0:33e:2d15:8e39])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2685:b0:33b:b078:d6d3
 with SMTP id 98e67ed59e1d1-343fa62bf74mr752300a91.23.1763072209003; Thu, 13
 Nov 2025 14:16:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 14:16:42 -0800
In-Reply-To: <20251113221642.1673023-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113221642.1673023-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113221642.1673023-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: SVM: Add support for expedited writes to the fast
 MMIO bus
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Wire up SVM's #NPF handler to fast MMIO.  While SVM doesn't provide a
dedicated exit reason, it's trivial to key off PFERR_RSVD_MASK.  Like VMX,
restrict the fast path to L1 to avoid having to deal with nGPA=>GPA
translations.

For simplicity, use the fast path if and only if the next RIP is known.
While KVM could utilize EMULTYPE_SKIP, doing so would require additional
logic to deal with SEV guests, e.g. to go down the slow path if the
instruction buffer is empty.  All modern CPUs support next RIP, and in
practice the next RIP will be available for any guest fast path.

Copy+paste the kvm_io_bus_write() + trace_kvm_fast_mmio() logic even
though KVM would ideally provide a small helper, as such a helper would
need to either be a macro or non-inline to avoid including trace.h in a
header (trace.h must not be included by x86.c prior to CREATE_TRACE_POINTS
being defined).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1fd097e8240e..9fce0f46f79e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1852,6 +1852,9 @@ static int pf_interception(struct kvm_vcpu *vcpu)
 			svm->vmcb->control.insn_len);
 }
 
+static int svm_check_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
+					 void *insn, int insn_len);
+
 static int npf_interception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1869,6 +1872,24 @@ static int npf_interception(struct kvm_vcpu *vcpu)
 	if (WARN_ON_ONCE(error_code & PFERR_SYNTHETIC_MASK))
 		error_code &= ~PFERR_SYNTHETIC_MASK;
 
+	/*
+	 * Expedite fast MMIO kicks if the next RIP is known and KVM is allowed
+	 * emulate a page fault, e.g. skipping the current instruction is wrong
+	 * if the #NPF occurred while vectoring an event.
+	 */
+	if ((error_code & PFERR_RSVD_MASK) && !is_guest_mode(vcpu)) {
+		const int emul_type = EMULTYPE_PF | EMULTYPE_NO_DECODE;
+
+		if (svm_check_emulate_instruction(vcpu, emul_type, NULL, 0))
+			return 1;
+
+		if (nrips && svm->vmcb->control.next_rip &&
+		    !kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
+			trace_kvm_fast_mmio(gpa);
+			return kvm_skip_emulated_instruction(vcpu);
+		}
+	}
+
 	if (sev_snp_guest(vcpu->kvm) && (error_code & PFERR_GUEST_ENC_MASK))
 		error_code |= PFERR_PRIVATE_ACCESS;
 
-- 
2.52.0.rc1.455.g30608eb744-goog


