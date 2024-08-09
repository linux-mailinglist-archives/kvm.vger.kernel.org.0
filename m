Return-Path: <kvm+bounces-23780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E85194D78E
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:45:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C53361F24FDB
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF3AB16D9A2;
	Fri,  9 Aug 2024 19:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uho2lfO3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A607B16B398
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723232629; cv=none; b=LDax1hwd9k8mAK9tjX9IbK36pEgGn7vNPwo0NKoMIpSDe7PM1gfhFHZGy6DL8eLNIxPduVUMo0ypDDFolVVTH9ohRLI3iuj3YSsHfuiMda0ftx03M2r/GoTRQixMGT1VZzNlu+Q+Vqrnj8x8Y0RGRhM1rGZZsqeBCp+pjegPtEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723232629; c=relaxed/simple;
	bh=2ubMLB5DYODq+qnXHnLMuf0I7PP+FeHp7xjE64E2dt8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FcYj/fVs/P19pDBQAq/r8znKf+Fzp1ZuWuqNAB3M2+lHIg/hCwTS5B8wdH8LiNtqGVWB/a8sQS+TGVwG+OD9AUUv3zc7BmIkVQQP6MmLlQygqah0HoVO42yUTeF1YKXN5f9rTsNabudXjyWkM860iH/O1MosiUh3Eek8y4evhwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uho2lfO3; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-710ca162162so2146693b3a.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723232627; x=1723837427; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RH8NStSlBVyK9g+UsmyXuI40nq9wzYPRU0gcFL0VkzM=;
        b=uho2lfO3JEKa3BYwurP6bC28fXllFmtwsLtKqkYwXKuVhG9iGLmF2aaPR5Odju1Ebl
         Z9NS24VN5EgBnwC8jBTgeHCFw2AsVyYNmazjHtqug5NluFgb9zdsyV3lRidSK7IbdXzO
         SCBUzgu7UERbgaLMluS8YD20m2GpAIJeCkYKVxXWoViB3+m1ymd9pJ3TY9AQlWsLi3mG
         ukBmfSIkISSc7wZvKIuD2A98IXIKxXMdV0Wo3kFxs+Vue5h2yajrz24/2pvUgYvrWhhP
         qXu6rPM4PbVbmOA+Q0UCHXc5EYZRTr0eYAybkGBmS0e7gFq+rVkpau1v/mDziY9M4tpz
         B86g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723232627; x=1723837427;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RH8NStSlBVyK9g+UsmyXuI40nq9wzYPRU0gcFL0VkzM=;
        b=FRvFh97/FMwv2EzyHVflU8bMjeSPj+0+Qec047W1DeRP86sJmlYQu1Sd6qv0gWQSpR
         /hREmjJy+6obKbd6x2pVh1ACq64Fk3XZVSPXOQYQ1OryuKe8+vb/XinuEEG7D0jLNjZ1
         dUkYD/mvty4Z7kB8C5fsEnexU8aRZxnKbA6KyKMSfQbZ2sm+nSi74AKYKT136/29Eqb5
         vh0QrfE0bzwNoOUgT0FuUOLptjTkSIZD/A3vUhh108d96Utlerp2uaPtwP1qjTcJoGmx
         5ICh8jYNJuUqYU7LwaajsiawdF3uWgm1As0FZY6CttGs9OwGB7fZWYdRXMoOAvKNanLe
         bHHA==
X-Gm-Message-State: AOJu0YxPpXuws2yNaAX/KWkVkKDH41WhJ+zPZKYl9uWx/lEvf3/WD2sr
	TNyxJJXnyQG6KESYv7rI6mEzulZ0wMoevDiSPFs0QNwUa64wVzIeJaC9PWnGO11lopd8ZF/XfYq
	jnQ==
X-Google-Smtp-Source: AGHT+IFF/ikXFYmI7zWUXbZoAyAwoVgAHirCcT99AraR5wR32CSYiy6TQQF1iEJF/4Gcjt4kmzWk21e9a/Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6f12:b0:70d:30a8:abaa with SMTP id
 d2e1a72fcca58-710dcb31a13mr28290b3a.5.1723232626683; Fri, 09 Aug 2024
 12:43:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:43:16 -0700
In-Reply-To: <20240809194335.1726916-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809194335.1726916-5-seanjc@google.com>
Subject: [PATCH 04/22] KVM: selftests: Compute number of extra pages needed in mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Create mmu_stress_tests's VM with the correct number of extra pages needed
to map all of memory in the guest.  The bug hasn't been noticed before as
the test currently runs only on x86, which maps guest memory with 1GiB
pages, i.e. doesn't need much memory in the guest for page tables.

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
2.46.0.76.ge559c4bf1a-goog


