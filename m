Return-Path: <kvm+bounces-48063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 26DABAC8544
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:47:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 152A41BA6ADB
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:47:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAC3B26C39C;
	Thu, 29 May 2025 23:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3SPZQgR2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8E12522B5
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562065; cv=none; b=ocTkKbUZe7Hsv9wnchRxZPIckfPG/MdO/jwYhRpemlvD01GYVWvxIkaW4uy6/IoA66205NtseLUN18ysnsmafFnWCuj8DU1edhWKWpxsS2ickfYRg3VFiHFTprYBmGLDz2BRndEewUHYK0+W93h+jSbwJTrGIWjyZNEiVVLm8ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562065; c=relaxed/simple;
	bh=tsblVO85XoDjTNiWEa3udBEZ0r8PDQUQXfsZoNEoi1Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B+njcRkn6ajX4emEp6lbd9ckwSyQIN0aDr38jobPWrk90MYvTWNjyzjznteGlEAaodf6LMSylnlzS9NLTr0P7wQQRWdoqr1iKsnVKC8WkUvhiS4TWrNMJYjun3j/+uVb/6gLcMffCZlvmvnIS+O0wmmi7VL0LcgRJ+NnR4BpF7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3SPZQgR2; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311f4f2e761so1462360a91.2
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562063; x=1749166863; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NTiX6sorGYCjVyu6VPciOEYdAyiyqpHL947Q3I6wQJk=;
        b=3SPZQgR2QGDWg15uTnqK2CpT1panVF/DXcylZjY6FVfhvHJnQM1t7i47prvBOgR84w
         B2RDRur1/MO5YvdLmtxtUPONtfucr8lTWcgLJoveKBDItYKdYlC+FR+vfJEQP/sM/DZ9
         8VSqc91IOXGeJdmnnqdUai6xB6gAdTGNIsjjcOwH1mkp/1rLrE4CgBx5yZ/kGefiSvzz
         KTpGqfl5vUlc1WmCmy04gSl0FMjxcexK4HH/wTXHeBiv+54wKnAOfZkkLA0Qve3kAKuY
         BmyWUR5eaC2E0cdKCknR8S/W3nTtNpv07F+ysf0Q7hO2PNl73peGzT+LTNKoHQKIIqm9
         yWgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562063; x=1749166863;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NTiX6sorGYCjVyu6VPciOEYdAyiyqpHL947Q3I6wQJk=;
        b=Yt9dyWEFEmN61l1O93pR4Q2zeweISL7Q7adKfNKFVUP/RZrxbXMWmGh/8xKVQSCQ0n
         BH/eLq9E9JUR5dfczjWnNfwDVh4588E/f7f3G3K8bOr+W0p3MlWNRjEBcByFcBylAT68
         wfSZT+dz3MuCvo/DBiIM2b1eI26muDHlPIxWPnoRtbqZuL1MwXhHBpnS0mrpQvtMi39L
         SY1HfFxXjioxQs1kIxhlyWOykIx91qNaXkmRUMOtRiVETIw4VvAHG2DVFUs5Z6BBI/6z
         FMC4EcGdl3ZiuI4CEt8kRysoBIEjTc2k90X3otX5JYWffg5AaNYaJB2YLy45te0xZeC4
         Mdkg==
X-Gm-Message-State: AOJu0Yzhr0Ttc55J/vU/6eFJQ329M8k6QBLqtqh/LSRlnU+IKZk/JI7h
	vlWrNOU/6htUJRjititPpcyk1TglHtbSCZA4zwhyiYX99sqTh9XjrJ1Kh5GuRTcMYVwTSwCfj4U
	Vy58JNw==
X-Google-Smtp-Source: AGHT+IHFPNRf85vhQW/Vp+4EXHWKl7Nvisj67P5EudGcWW95ABwEWKiz/7SumHmo1hjKp55lMs20QG9HBlw=
X-Received: from pjk14.prod.google.com ([2002:a17:90b:558e:b0:30e:6bb2:6855])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:55cb:b0:312:26d9:d59c
 with SMTP id 98e67ed59e1d1-31241e8e674mr1667162a91.22.1748562062955; Thu, 29
 May 2025 16:41:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:40:12 -0700
In-Reply-To: <20250529234013.3826933-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-28-seanjc@google.com>
Subject: [PATCH 27/28] KVM: nSVM: Merge MSRPM in 64-bit chunks on 64-bit kernels
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

When merging L0 and L1 MSRPMs as part of nested VMRUN emulation, access
the bitmaps using "unsigned long" chunks, i.e. use 8-byte access for
64-bit kernels instead of arbitrarily working on 4-byte chunks.

Opportunistically rename local variables in nested_svm_merge_msrpm() to
more precisely/accurately reflect their purpose ("offset" in particular is
extremely ambiguous).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 60f62cddd291..fb4808cf4711 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -184,6 +184,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	}
 }
 
+typedef unsigned long nsvm_msrpm_merge_t;
 static int nested_svm_msrpm_merge_offsets[6] __ro_after_init;
 static int nested_svm_nr_msrpm_merge_offsets __ro_after_init;
 
@@ -234,10 +235,10 @@ int __init nested_svm_init_msrpm_merge_offsets(void)
 			return -EIO;
 
 		/*
-		 * Merging is done in 32-bit chunks to reduce the number of
-		 * accesses to L1's bitmap.
+		 * Merging is done in chunks to reduce the number of accesses
+		 * to L1's bitmap.
 		 */
-		offset /= sizeof(u32);
+		offset /= sizeof(nsvm_msrpm_merge_t);
 
 		for (j = 0; j < nested_svm_nr_msrpm_merge_offsets; j++) {
 			if (nested_svm_msrpm_merge_offsets[j] == offset)
@@ -265,8 +266,8 @@ int __init nested_svm_init_msrpm_merge_offsets(void)
 static bool nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	u32 *msrpm02 = svm->nested.msrpm;
-	u32 *msrpm01 = svm->msrpm;
+	nsvm_msrpm_merge_t *msrpm02 = svm->nested.msrpm;
+	nsvm_msrpm_merge_t *msrpm01 = svm->msrpm;
 	int i;
 
 	/*
@@ -293,15 +294,15 @@ static bool nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < nested_svm_nr_msrpm_merge_offsets; i++) {
 		const int p = nested_svm_msrpm_merge_offsets[i];
-		u32 value;
-		u64 offset;
+		nsvm_msrpm_merge_t l1_val;
+		gpa_t gpa;
 
-		offset = svm->nested.ctl.msrpm_base_pa + (p * 4);
+		gpa = svm->nested.ctl.msrpm_base_pa + (p * sizeof(l1_val));
 
-		if (kvm_vcpu_read_guest(vcpu, offset, &value, 4))
+		if (kvm_vcpu_read_guest(vcpu, gpa, &l1_val, sizeof(l1_val)))
 			return false;
 
-		msrpm02[p] = msrpm01[p] | value;
+		msrpm02[p] = msrpm01[p] | l1_val;
 	}
 
 	svm->nested.force_msr_bitmap_recalc = false;
-- 
2.49.0.1204.g71687c7c1d-goog


