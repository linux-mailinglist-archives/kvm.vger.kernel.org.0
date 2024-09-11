Return-Path: <kvm+bounces-26582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 918CE975BF3
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 22:44:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55B4628494C
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 20:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C2614F13E;
	Wed, 11 Sep 2024 20:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k9NKtBUP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869CB1BC9FE
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 20:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087359; cv=none; b=dj7mFu4FRUQ3pEYyodjmwbqqXrxq169BnfzYnTZb0kYWLImBZJy6Dveio+s4RoOui6jhz+x0T/VLZ8kLzimA49mpOR+dvwiNLp6+4LAm5LC+omlzEEaUdd+cB2FSu7Je8jP3dIsALmzkh/sALEbYuRENytAdBpJXBO0oqvhANak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087359; c=relaxed/simple;
	bh=fr34CVsgL2g82sb+1gvS8yCzrvuGG/23h2+dDn8u8kM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KgM5+Q+1E4osE83St/DuHgZbCCglBXWoXborWltcl/EeEmqAy/n2ZJ7NMIFkgBR7n/8HFrVI6qrG4LCmIOjlL902jAKQzqAyO+PxgpVbisJp8PiVuTPJT2W0YcLPSBYG7quyuDiWNWkv2J9UEp/Dp5J+J6m+Q4EVzRo6f7MdpX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k9NKtBUP; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e1ab008280aso720391276.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 13:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726087357; x=1726692157; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=47BQJJiikboIPrV2PD33si1kPUmickrZ0k1m7wYEIK0=;
        b=k9NKtBUPxU7T6Vzao2Y0Rzz1GfVvTRbDy9KYF0mNoqxXmc1F9m36H4awV4f89ATXIL
         OGEn1MVfBm4BwBaa8hLy55TYwIieof/ic/SflSnfLGNrB0oLMiISrlrVRLpyDZZ38uby
         LvXC5F/+JUA850KTW90Wp9YCaRDq9TmLw5hFvEkyDkczRbTz5YPQiTlCqNA86JZ9iOxo
         M+Z55TTJx579DFYe1r8gamUmcx/ub5WT/ueDHeg0meLfXrqnaZWT9B01DOgHVFf6B3j7
         Ws+AB80cmFssM+uc0rbbQGFigm+ofAXQZ9mX5oX2OUACXya2N0Q2vOvBv0eJwRaK81p0
         D8YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726087357; x=1726692157;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=47BQJJiikboIPrV2PD33si1kPUmickrZ0k1m7wYEIK0=;
        b=BpYtfy2yQCqqlCCSuKbinqdfd/KFLOb7j+IeuCp01R7XwIiZNj60VBzbG8gdhm6ZqW
         odrE3KjpzISm7HUPozOx9cQo7gNI/RAt2Ppw6AE0ITpNqV64zh/Vlei7jWWmf4KkfLGq
         80gaptIQCePrQoW9tfmfAQ0S4I/ddmncTDfQwocTOH6bcqol+edEoDrzUQAwd6t3tQFt
         zURGXJMoiLLU5CLm4EUUXReVZ87b3zyw9U4c4x6RFO1ORahTE81OKTNbzgpySVmPV7X3
         /MC9iqMNC4OInNuEMtjcnEC0W50feCkCpfScEinwUqx7FKXBARSuj/R6YQ6Jwn+QnEpS
         j15w==
X-Forwarded-Encrypted: i=1; AJvYcCUlIYW/bHcL+NCzl6e2qfgj5PODUV02hHRjfxGRaH0Th5vyjT3bN6UQ9hcKcehzm6Rn12U=@vger.kernel.org
X-Gm-Message-State: AOJu0YycRkFEP1B86T9xkB3uy9ZDka2U1JttF/zR1EVFc0HmKg4vAg/Z
	+s2igLum3LqnHYOUYdAiHWx1e2x1uBzrD5EZ/9cU5cZ+hd2nJpmFGWcktmxP2qwvWyy3EkokFrm
	AzQ==
X-Google-Smtp-Source: AGHT+IGKCOrdvuPh1JFZJTD4VhxgbmNdEtpijYplyDxOyPTYxT/JV5RegfErX1F5y84KkH5DsNf+hpV7TUg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c206:0:b0:e11:7039:ff92 with SMTP id
 3f1490d57ef6-e1d9dc6f379mr708276.11.1726087357418; Wed, 11 Sep 2024 13:42:37
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Sep 2024 13:41:53 -0700
In-Reply-To: <20240911204158.2034295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911204158.2034295-9-seanjc@google.com>
Subject: [PATCH v2 08/13] KVM: selftests: Compute number of extra pages needed
 in mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Create mmu_stress_tests's VM with the correct number of extra pages needed
to map all of memory in the guest.  The bug hasn't been noticed before as
the test currently runs only on x86, which maps guest memory with 1GiB
pages, i.e. doesn't need much memory in the guest for page tables.

Reviewed-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 847da23ec1b1..5467b12f5903 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -209,7 +209,13 @@ int main(int argc, char *argv[])
 	vcpus = malloc(nr_vcpus * sizeof(*vcpus));
 	TEST_ASSERT(vcpus, "Failed to allocate vCPU array");
 
-	vm = vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
+	vm = __vm_create_with_vcpus(VM_SHAPE_DEFAULT, nr_vcpus,
+#ifdef __x86_64__
+				    max_mem / SZ_1G,
+#else
+				    max_mem / vm_guest_mode_params[VM_MODE_DEFAULT].page_size,
+#endif
+				    guest_code, vcpus);
 
 	max_gpa = vm->max_gfn << vm->page_shift;
 	TEST_ASSERT(max_gpa > (4 * slot_size), "MAXPHYADDR <4gb ");
-- 
2.46.0.598.g6f2099f65c-goog


