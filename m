Return-Path: <kvm+bounces-10192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FAE686A6BD
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:43:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D13BF1C2325D
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 02:43:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9C7D2375B;
	Wed, 28 Feb 2024 02:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l0dW/RoA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6604222318
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 02:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709088124; cv=none; b=atFH9PS3h58qUrbTXAxqdzLTfaLNcUI8eI0XV0Iwa8dNiEn2FC9S98SaNUsn60yyUAvVVwQR7poRZiHIpWzp7W+xsm7zWIhGzUEVr21ksW51tdQyHa5c+Xz3fF3LE6iyUIcCmAo0WRiB3YNvhO2k+wDy/MV7dSSxv1lh+tCu6fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709088124; c=relaxed/simple;
	bh=CoPJqaD56CaWccUD0GKW7vdTTZaLbgYVBxvvvw5siQg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L50Dzw0+x2G9c2pVZHsqTilzwpiyU1S13jvZ+klFBm9t3RfqENzAPWmSb7N0OKGxt/PttQWRvC0Zflq3PDOFcEvadqucdTmw2yH+FI/Ls6zdBEtMjmlwoPd3oRD0va2cSLREq2LjBTJ8naptQu1BWDOjLUzcIOIESmViGs7t7Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l0dW/RoA; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcc58cddb50so8338134276.0
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 18:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709088121; x=1709692921; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gfpkuG+ZVx2am4Y182O6tFhDfs/R2qPCe9zqwBMHRpo=;
        b=l0dW/RoAOtJbVNHxcxiV8U7Q1j379bGF3UnqtuIE8ngJoiF0UYzhU7nBY1PnwKdQXI
         dVUVYATYFzvhZlU0Tj0tuXClA+WyRU9sYlOK1y5TVjRCiGA7SAIQkT/QIaK2NsjdjDio
         Bz38DKgmuFyG/Hfxrw2S8NbkjU45xUXl+x/oQKao4VOcogwzBHbb0N0Wtn1L65p/70U6
         l0m0J+6qPWgNd8WsDl2xi4ww9cUJaUDG4vh6YhwVn9dlu0ilcgY76QCfPFE1r3eeGfuO
         qNW9eZ51fOr2wbUsRyed2daDotzep+yjVbRD6Ef4uMQSm60y6i3pczVgzjqLLabcoBMx
         zucg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709088121; x=1709692921;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gfpkuG+ZVx2am4Y182O6tFhDfs/R2qPCe9zqwBMHRpo=;
        b=Knlby9pf4v1fmsKi+kYJC1t+yJM3MtTr2Ze2TFlhXU7jKBQl1lskY4dQS9zMZ1Rrpq
         Xl4/LhnUTYyC5+HamyrWAe/P0N1n6ne5RevRWIUfP9lprk1vyEi37QquwFABkwg8+kjL
         fIOw6cfW/3vKIaYqZoic+ne8WpmEuUuj4BBJUOlSGR334CUJ+llHKtwNzAHxlKK+BLha
         uYjQkRai6PUV5Mt49INFRxwigDQ8hO/hIEz+csnUIYlmV86F0p15sFXSDetjMHR+UB8Y
         76R0bFUqM3UBZD8yxyQs3SUpwZhLWffRZqAjWKrwryNhXr1/4NHD/Cj0m94jk+ay1So4
         GZBA==
X-Gm-Message-State: AOJu0YxMmeKJwpBxZxe1NfvWxLOKTXjsgakw1FChqaoxYNBDJ73TnZUm
	ltfpS54K/pgUVYDw8aUIavsPNsqpa3ke0GWd1xFPrjp/li1XJCsp4gafkbarjD4XYNLlioFIkAm
	Cmw==
X-Google-Smtp-Source: AGHT+IF3KIx/8tFZn/wJwVNrNg1+yoGtgwdvNURhlI554RnWArO0MDtvM2JKBrSbo24e866hb0I37y5xSB0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100a:b0:dc7:53a0:83ad with SMTP id
 w10-20020a056902100a00b00dc753a083admr385599ybt.5.1709088121589; Tue, 27 Feb
 2024 18:42:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Feb 2024 18:41:37 -0800
In-Reply-To: <20240228024147.41573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240228024147.41573-7-seanjc@google.com>
Subject: [PATCH 06/16] KVM: x86/mmu: WARN if upper 32 bits of legacy #PF error
 code are non-zero
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

WARN if bits 63:32 are non-zero when handling an intercepted legacy #PF,
as the error code for #PF is limited to 32 bits (and in practice, 16 bits
on Intel CPUS).  This behavior is architectural, is part of KVM's ABI
(see kvm_vcpu_events.error_code), and is explicitly documented as being
preserved for intecerpted #PF in both the APM:

  The error code saved in EXITINFO1 is the same as would be pushed onto
  the stack by a non-intercepted #PF exception in protected mode.

and even more explicitly in the SDM as VMCS.VM_EXIT_INTR_ERROR_CODE is a
32-bit field.

Simply drop the upper bits of hardware provides garbage, as spurious
information should do no harm (though in all likelihood hardware is buggy
and the kernel is doomed).

Handling all upper 32 bits in the #PF path will allow moving the sanity
check on synthetic checks from kvm_mmu_page_fault() to npf_interception(),
which in turn will allow deriving PFERR_PRIVATE_ACCESS from AMD's
PFERR_GUEST_ENC_MASK without running afoul of the sanity check.

Note, this also why Intel uses bit 15 for SGX (highest bit on Intel CPUs)
and AMD uses bit 31 for RMP (highest bit on AMD CPUs); using the highest
bit minimizes the probability of a collision with the "other" vendor,
without needing to plumb more bits through microcode.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7807bdcd87e8..5d892bd59c97 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4553,6 +4553,13 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 	if (WARN_ON_ONCE(fault_address >> 32))
 		return -EFAULT;
 #endif
+	/*
+	 * Legacy #PF exception only have a 32-bit error code.  Simply drop the
+	 * upper bits as KVM doesn't use them for #PF (because they are never
+	 * set), and to ensure there are no collisions with KVM-defined bits.
+	 */
+	if (WARN_ON_ONCE(error_code >> 32))
+		error_code = lower_32_bits(error_code);
 
 	vcpu->arch.l1tf_flush_l1d = true;
 	if (!flags) {
-- 
2.44.0.278.ge034bb2e1d-goog


