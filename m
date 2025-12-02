Return-Path: <kvm+bounces-65054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99AA1C99CC9
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 02:51:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C2E93A5653
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 01:51:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56740238C0F;
	Tue,  2 Dec 2025 01:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KkS54MvY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39A621C9E5
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 01:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764640256; cv=none; b=RZask1uOhVrRHjpC37e6mUw/aKt9UN9qLJ4fQiOinBYJnLArvFSvJmo9E3F6Efv1jEkCOe+wib0pmycNa09kO8ltWqROm/WnQXrr3zF+xbE6rkRZ6T1pW/ZkYU5DbvY2yJUr2ed2Wo0U1ch2Z/6CcTeweZcVlc45BEykaSfpanw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764640256; c=relaxed/simple;
	bh=nB6qRv6nAIGx2I8ypCB+W8F7LU9VAqRkvzD0NBGBR0U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L95dZQYKsjVg8HKQ5OH/e3L3IDXsaDZtSY6qfPtHWtznp6AULqkTwVSShY4/1agbImlgssHYdnXZUJY4fRiyG6gx0AXyVBXtoUw5E+/Erk3v/xdvvTBkvHKiwnMlffPXrZqf8SfPORJwYQYbwHHk/gYbX5RQOUO7tX1SYPo4tf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KkS54MvY; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-343fb64cea6so8732899a91.3
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 17:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764640254; x=1765245054; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FO4vRyGU++itdzOMqRcpFPcZPVrVm84b8pvhquYMPm8=;
        b=KkS54MvYyp5miFwuN0blvXy5SqvTBivylX7OCfgDXoZl4rSwYCikvwGEmbLY8do0uy
         OJPDgJWSF9+a1455L+znBJhhhbQ26sn1yomIvTXw7N9MiYXPJmzP/VGVxE39eFIsb+3q
         +K52AlcwmkVAhCNCdyD1QmZ/IYJmSVdJS+zDgJO7N9NkqImGhh6MM6cJIdDm2Koetgk2
         Y4GRzWSKJdPS4IdRIfeQvl2SLuMe2WQbF5w+R5cmTqeK9KjRj3b5jpCgOq1Zj1PlOVwg
         by5+LDCS0KS+b2RhJ/y8kyJe7zDMCXhzIhfkLfJIS3cLlOEmCRZ/DXwPhb9FuFxmhNxE
         6Kpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764640254; x=1765245054;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FO4vRyGU++itdzOMqRcpFPcZPVrVm84b8pvhquYMPm8=;
        b=ueL1HRxmqhvKDB4PHPzlUtUV46jq41kJjg5e3y0bUxikmvKq0IwQqna7EdYn2oHAUL
         S86knEt0PtUt+pAzOtX8xHTgFihI5kY5Jcv4IqsHDbppNqUxiRNYLB0U2C/uXwyXNOQ/
         ABQJImi4FL59GuzMcPyUc/6eaAORFJgPy+0gNpDQKmjzdEx2U8/XFEAaBimOsTa8KDxR
         u9hjgrcA8vlCRJuY8IzTG1bQHgFyGGRsJTyKfzU86YVglKsRi2JemCs018GsD8mUatnD
         IavCRxm5CbCxWmxX5GaY/KlUkskq94T/onZv37/S9e3/WLCMXQS/4pU34ilyGwvrD2Ff
         SVEw==
X-Gm-Message-State: AOJu0YxKh4hFZ1fjdi9Duq0qJYXgGdbIcbE43kUntiOWXcDUvxfLyXbN
	WXZj7wcBhjH9ooFff7MP27WTjAB9VFNJAAVorExuXKD26ODQq2EiJp111M2MnD0Ouf0pyrdSMBu
	8RdsYLA==
X-Google-Smtp-Source: AGHT+IE2/W3sNluDSkGrqgUz3oVXnrs20y/UOm3aK4v9tbCV1gDR9+HLpQdBfEtiOh41EzOqmFwN/g6DKDg=
X-Received: from pjup8.prod.google.com ([2002:a17:90a:d308:b0:329:d461:9889])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38c5:b0:343:6611:f21
 with SMTP id 98e67ed59e1d1-34733e2ccf1mr38021119a91.1.1764640254278; Mon, 01
 Dec 2025 17:50:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  1 Dec 2025 17:50:48 -0800
In-Reply-To: <20251202015049.1167490-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251202015049.1167490-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
Message-ID: <20251202015049.1167490-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: x86: Apply runtime updates to current CPUID during KVM_SET_CPUID{,2}
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Mammedov <imammedo@redhat.com>
Content-Type: text/plain; charset="UTF-8"

When handling KVM_SET_CPUID{,2}, do runtime CPUID updates on the vCPU's
current CPUID (and caps) prior to swapping in the incoming CPUID state so
that KVM doesn't lose pending updates if the incoming CPUID is rejected,
and to prevent a false failure on the equality check.

Note, runtime updates are unconditionally performed on the incoming/new
CPUID (and associated caps), i.e. clearing the dirty flag won't negatively
affect the new CPUID.

Fixes: 93da6af3ae56 ("KVM: x86: Defer runtime updates of dynamic CPUID bits until CPUID emulation")
Reported-by: Igor Mammedov <imammedo@redhat.com>
Closes: https://lore.kernel.org/all/20251128123202.68424a95@imammedo
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index d563a948318b..88a5426674a1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -509,11 +509,18 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	u32 vcpu_caps[NR_KVM_CPU_CAPS];
 	int r;
 
+	/*
+	 * Apply pending runtime CPUID updates to the current CPUID entries to
+	 * avoid false positives due to mismatches on KVM-owned feature flags.
+	 */
+	if (vcpu->arch.cpuid_dynamic_bits_dirty)
+		kvm_update_cpuid_runtime(vcpu);
+
 	/*
 	 * Swap the existing (old) entries with the incoming (new) entries in
 	 * order to massage the new entries, e.g. to account for dynamic bits
-	 * that KVM controls, without clobbering the current guest CPUID, which
-	 * KVM needs to preserve in order to unwind on failure.
+	 * that KVM controls, without losing the current guest CPUID, which KVM
+	 * needs to preserve in order to unwind on failure.
 	 *
 	 * Similarly, save the vCPU's current cpu_caps so that the capabilities
 	 * can be updated alongside the CPUID entries when performing runtime
-- 
2.52.0.107.ga0afd4fd5b-goog


