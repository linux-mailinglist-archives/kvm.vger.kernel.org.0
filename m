Return-Path: <kvm+bounces-19113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6097D900EC4
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 02:11:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C91682811F7
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 00:11:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 658EA28E7;
	Sat,  8 Jun 2024 00:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TILMNDrX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE7A17C8
	for <kvm@vger.kernel.org>; Sat,  8 Jun 2024 00:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717805472; cv=none; b=YCYWJdBv8IGdRx6wSHd8mBBSOzjfsNZZn1/F+ZLBUORnG0BWsQnwXFxuKbS+7JHSaeULbPIP5yIJxwmYhZ4ZwWmngvRsnzIMMzrN2pNL/3PEGOpofmLmw8+kk3C93dnr9nWZThjlrVkx0vMJ2z1DjR7XuHtsmbRiNnWS6LPBErE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717805472; c=relaxed/simple;
	bh=vWPGDr0VAOnNNuqxYO9KemOUnDeq1bzz8spYQseOLoQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=csB1+dOGBC+9FpFOeCwlqULdY6/iGbm4zwjqg1CqX3s2USI3/4SOLTKRtKJWfsvJA92N5+5qVyKANUapY9goDgORztwooMBBGXxI5bHCjfHGgCEjnFcbutu7HKoMaIYk73s1m3jvlf6zzlNSpN9rGT3uSxOKg1MbVq13V+pujIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TILMNDrX; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6fc395e8808so2542877b3a.0
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 17:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717805471; x=1718410271; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z1D7CxmQOWEB+afJq8q/LjLb1nA3G9jvJYdupVYkAuw=;
        b=TILMNDrXFVEhm9Rf/NiMcpZDXlaxqwagc4Dy3EtW0YecdSVAJxCtfkLMScMHs6Z8Da
         +5X19Y0Af64RxgVLOcxT9Ajq8z2j2oJD85YvL0WPYWqsFjBfUqHjdA6Sg6dJI2MsaA94
         /0wlQ9HS+c6uh5nz/vUiHMQYBz6P/A4KDdwyxhPYHpu8c4VlVREEWV66i7Tj9NvgyeoD
         MDg3Sv56PiNuHtg4SPlzvqKqa+wUCLYb75Ux4ZA3rzUGRJdhnqSuZepwnljAw7/Ws5A3
         n1KfiiJDIgTb4ChRfiNf9QYONZilLYwLh0MMsIuG9G+RF6b/HeC+tWqOdf3WWsB6Ebh2
         sZmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717805471; x=1718410271;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z1D7CxmQOWEB+afJq8q/LjLb1nA3G9jvJYdupVYkAuw=;
        b=i+VF/CWZtVb5sBCPXCGDTFpNE9tNS9CX46ry3tjKv9hd/acRwCEIWAFzEXRwoFsbcL
         FpQQm/joJmIJVWA5JBq3YePNiQv+kvfXy4BlL6xQXU/vb0bfxK1Y80A+6Rev8rgEJa3c
         75nNL2sq9bcp9hVsq/MVBseTo8H5A6EzOZ+f6zuFGVpGL722KJcZgu3Xz3uLQQGYLbRm
         1Hgue/evthuEyfI8Zdwyf098RqvMMZIbFAPy5TXBGb1j70VyoTX0KUVmDEHl8teIvFOg
         n7EJGkmgICUt2K963fh8IJVafvIHcmArPgPLBF4RyB3G+GjOq2NSp9umf45XU9S0U2iU
         UtQw==
X-Gm-Message-State: AOJu0YxXotfUa6OV5gIzBbXuQRtXRTGIWy+b9ozjQV3HZggaKihixh7Y
	bo0vqosaHMw+W5rMglQvJe4bgYOa0mOtwWlINn0Z1hx8uf2lsn3zySyvnLvRpcxfQ0tv4pAljf+
	RQQ==
X-Google-Smtp-Source: AGHT+IG9PBzMAAZoiZyf0Ifd3jc9ODlYrgfiGByUvwS7iZ7SJgKLrOSsaQR9jZWzB7+o1o0N9vRC0QHSiDE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2e9c:b0:702:2ab4:b12f with SMTP id
 d2e1a72fcca58-7040c708fa2mr16072b3a.2.1717805470628; Fri, 07 Jun 2024
 17:11:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  7 Jun 2024 17:11:08 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240608001108.3296879-1-seanjc@google.com>
Subject: [PATCH] KVM: x86/mmu: Rephrase comment about synthetic PFERR flags in
 #PF handler
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

Reword the BUILD_BUG_ON() comment in the legacy #PF handler to explicitly
describe how asserting that synthetic PFERR flags are limited to bits 31:0
protects KVM against inadvertently passing a synthetic flag to the common
page fault handler.

No functional change intended.

Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8d7115230739..2421d971ce1b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4599,7 +4599,10 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 	if (WARN_ON_ONCE(error_code >> 32))
 		error_code = lower_32_bits(error_code);
 
-	/* Ensure the above sanity check also covers KVM-defined flags. */
+	/*
+	 * Restrict KVM-defined flags to bits 63:32 so that it's impossible for
+	 * them to conflict with #PF error codes, which are limited to 32 bits.
+	 */
 	BUILD_BUG_ON(lower_32_bits(PFERR_SYNTHETIC_MASK));
 
 	vcpu->arch.l1tf_flush_l1d = true;

base-commit: b9adc10edd4e14e66db4f7289a88fdbfa45ae7a8
-- 
2.45.2.505.gda0bf45e8d-goog


