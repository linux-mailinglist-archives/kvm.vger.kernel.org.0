Return-Path: <kvm+bounces-26580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AE81975BEF
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 22:44:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B40E2856B5
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 20:44:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 295F61BD028;
	Wed, 11 Sep 2024 20:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nh8Fl5B1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7EA1BC9FF
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 20:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087355; cv=none; b=WyM1YEQ/+6b4R9XJDp6roGBDnPiv9NidedQ4tkqujiZIz/IyQeqcho8eotPD5i2n30q3y6Ca8p2JuviRk9yQ4ZPOkQ3fH348b5naL9hWQZKOB95Raq8i2q/Zg1MqHzP/o/hCJ4thSa2ZcESZ6Qq70H2qSYxDuZECmfS0366mSPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087355; c=relaxed/simple;
	bh=1saQ6Xhz3JzwSNCRR1yV2CCjz4AlXZeyzxAJr9SdD5E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y21lgUlQmVrfLWKVA0Kk9ydr5zF+PHKQgKxJEu+eGAyUX4QPB18C6mFthDm5MFPk07TFdAjzxlpfIvR5Flaq6/v4K16oGCP3uXc/8KnHtH7VDtEeoBSaaSsx60ngUD+bz6S+KMPMxCOYPMJhzSRO0li3jqWTNxlKzWRCzRmGU+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nh8Fl5B1; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7d235d55c41so415270a12.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 13:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726087353; x=1726692153; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/zCwfp6P0Cp/T+by076ZLxu5O+Esa9Wy3+GZFib04b0=;
        b=nh8Fl5B1uMJnzTK73PvfxxAQ4f6H5uAMcdZARFGessH0r0jaqoOot4GHUEfYvUh0jR
         djN9CTfewLrF7pFYcBLXh7X5Xb0bqyHBXl35Rt9xcH3Mpprq9AdtzFDiswpbPiaRuUDW
         qUtApXQHEeyWuomDoU+BEVXmv7AfUoPb1bBo1PRZAqU+m0QdPy/31kfFbDBhmjhzxlfb
         1H7lILbQm/AEpESny11TXjzVG9foGMd/DN7O29D9swNzfQQWQHMUlJAFhXZN9z5D6wcj
         t8PlWwaNFeHfNNroDRK85u2JgzVYk+8uiiWkJZm4t++mXMlk2DuN5M1mgDg1GsjHAhWa
         ApVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726087353; x=1726692153;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/zCwfp6P0Cp/T+by076ZLxu5O+Esa9Wy3+GZFib04b0=;
        b=ljhfVrtl3B9J9iBEAqk7+XKtlxUm/y6LtyL/nPpOjqXgqq/JNT8UtiHhvlIx+qZvrX
         bfwNMU6VUPGCZDTRKc/BFBeuT7fKnstgUSuOTF15os9INU2aef6jdhCr7/66ReRIrddX
         fJK2dO5fdMhgqOwUtYP1SmsEEIcIDCWCr/nWyLEro3tTf8dFU6fRkxLxcHW77C2avXRF
         LevkobfFrdMIX2BdfdT/6Bp4Gzb0BQa530ugbM0IUkNsOivDf5a+BYmSyufGYwFJcS+D
         AUWizjXBcJo183KEXMBjb7xolTn0yVSo9fjclAaN8cKHY7EbOPaIhH8IHeLJD9lPiAJE
         K2tw==
X-Forwarded-Encrypted: i=1; AJvYcCVHGtYUfOLfSS64uRDutLw6VmCSlDZk4wh1S3ozqMXZoUAZwnz/A9kAHuA4dO6XJEPDZv8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyL1Dk57QxIBNf3tLQNA5Q/HjBALGS/WrkKqKG9AI0+dqgH1+ij
	CiM6weKCj6mQ6btBcfWAxHQ42oVhoaLSkVMNIr6SQITZVrNj64wVBMvotprnYuGf+Pbb/2+Vj0L
	OYA==
X-Google-Smtp-Source: AGHT+IGUai264jNYdPregUs2lG6efJQ9mB9ec+8i+QUzJ8LDBnAP8lzvYrxYOQMf2YPIMJvqww0dvL1st/8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f68a:b0:206:c5ec:1445 with SMTP id
 d9443c01a7336-2076e44b9a6mr10485ad.8.1726087353017; Wed, 11 Sep 2024 13:42:33
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Sep 2024 13:41:51 -0700
In-Reply-To: <20240911204158.2034295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911204158.2034295-7-seanjc@google.com>
Subject: [PATCH v2 06/13] KVM: selftests: Rename max_guest_memory_test to mmu_stress_test
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

Rename max_guest_memory_test to mmu_stress_test so that the name isn't
horribly misleading when future changes extend the test to verify things
like mprotect() interactions, and because the test is useful even when its
configured to populate far less than the maximum amount of guest memory.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile                            | 2 +-
 .../kvm/{max_guest_memory_test.c => mmu_stress_test.c}          | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename tools/testing/selftests/kvm/{max_guest_memory_test.c => mmu_stress_test.c} (100%)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 48d32c5aa3eb..93d6e2596b3e 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -138,7 +138,7 @@ TEST_GEN_PROGS_x86_64 += guest_print_test
 TEST_GEN_PROGS_x86_64 += hardware_disable_test
 TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_x86_64 += kvm_page_table_test
-TEST_GEN_PROGS_x86_64 += max_guest_memory_test
+TEST_GEN_PROGS_x86_64 += mmu_stress_test
 TEST_GEN_PROGS_x86_64 += memslot_modification_stress_test
 TEST_GEN_PROGS_x86_64 += memslot_perf_test
 TEST_GEN_PROGS_x86_64 += rseq_test
diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/max_guest_memory_test.c
rename to tools/testing/selftests/kvm/mmu_stress_test.c
-- 
2.46.0.598.g6f2099f65c-goog


