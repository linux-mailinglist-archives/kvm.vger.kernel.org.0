Return-Path: <kvm+bounces-32638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D3279DB075
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:57:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBA452818AC
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 00:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3E24130499;
	Thu, 28 Nov 2024 00:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IAY2caXQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D467404E
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 00:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755361; cv=none; b=r1CqXENrxdqc17unPeNIOn/z9KM8wdtb9JaWhYS4fRR23nM9mu0X6wqgvkdMz+ehX19RhCc5AhRTZDO+ge4yGtEk104MOCozSLMk/N6MkdKo8HRFfLzhehJUNkS2Q1u2jtSC3zdanzLMDRwkkkyq7Dwja7v9diwyy23sXlcdtw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755361; c=relaxed/simple;
	bh=6/wTQsGJs8irAo/psByDX9+eFhZ+LD4ILASalomr9Cw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RgQfaUDB1N4TJpYEQOMxRsSneLi+oo6Imkj+XxAkC28YTPSha57WfiOwjrpMgclpJqtgkbJaNlaZTRGnwoV8IbhJJjjZcocErgWh9u5jUW2sm0KTHbJ+0U1UPAmC2vqvE1C8Sfyqb7kNTRnOsYiRCYmzcdgs90O1UKU01ztPefw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IAY2caXQ; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-724f6189a4aso397672b3a.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732755359; x=1733360159; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Qp0x5jmf6wCt1OmSFixie+OQOct6OMtePnY0hHC3FqE=;
        b=IAY2caXQY2aOj41whTKMWqYPhfetl6lY7LeQQOWuJtul7PCFYaT6r2l9DRvZnDG1n0
         0oHEEatyuoK0VXCyyYDaMGTGohJsin6k3ZlvJqMi3DXxX7OXwMy+JPsdZYt+rsZVtSjV
         2fbLZm2l1RRAzvvrcJA+kFjGGQHW+D1iEziBMhGOCsQxfPUGkk5Lstip3A8IwL8MtZcS
         SeWOmeGYjpzq6po3Le20nXfaDMM6LcIwIClCQmIvC3N9u2TgCrKHf5P7JroYQY0nidYo
         lNbcqsWSLK3aQSVyJZ4UeuSDbfF6OHVhBCqW5WyaK+E1x9LX56Mlrf8qXhYHq8UDISbK
         2l2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732755359; x=1733360159;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qp0x5jmf6wCt1OmSFixie+OQOct6OMtePnY0hHC3FqE=;
        b=Sjondrx8MMp9Mxjp6FMFI3aEGeNCDLkyLmx23kEhCJmZqje1OGkBlVwM5PnwtTS4uj
         OChuERSTQQ0jjBscgam4a2iMMHbg/boewNK2gI382Zcn530pP9Rj5Cs9wso2vVjQBDt5
         Z8yt8m09ot56MaDu9Su9AgwSF1BXyhMGgVwpxO7cqVxKORp722SIO3JgNZQh9Cu4FKm6
         FLZWuCZd3jORnXjgI6S6bsUe2xt1Xa20+dvF4XrS0kYI91SuKKroLMvz8FShQTmX8vIv
         mbr+nhFrzKadW9A+LMhz6BD/L4m+Qs8772U5BpRvdB+CedXYG2qp8E2318Es60Jt0OAB
         nx3A==
X-Forwarded-Encrypted: i=1; AJvYcCXuy23FT/0mQ7OZpXAF/O9HRKDLWyBDURaWQWxz0aElUIKSqG5hVX1krP1LplXht1UJh0o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2j565gsWpD3rFmF6uhYYiqSoFJNQWXpd+TBhTmLXKIvgqz5dY
	7y5rj4g+G1d0PZwIFf7S59mESOeeKiaKr96eXqLlwpbuIMEetB9j6t4zGwLdTzB/cfqssmIA1nR
	f9w==
X-Google-Smtp-Source: AGHT+IHRct+tg9si6FXkj3XDfvATucfZZx/pmM1rsyJ2yuaIieXkck617uTZGF3kPo5jFFwMAZ2X8QIv/Kc=
X-Received: from pfbjo14.prod.google.com ([2002:a05:6a00:908e:b0:725:325e:59d5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1492:b0:724:f404:7101
 with SMTP id d2e1a72fcca58-7252ffcbf80mr6785726b3a.1.1732755358707; Wed, 27
 Nov 2024 16:55:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:55:36 -0800
In-Reply-To: <20241128005547.4077116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128005547.4077116-6-seanjc@google.com>
Subject: [PATCH v4 05/16] KVM: selftests: Rename max_guest_memory_test to mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="UTF-8"

Rename max_guest_memory_test to mmu_stress_test so that the name isn't
horribly misleading when future changes extend the test to verify things
like mprotect() interactions, and because the test is useful even when its
configured to populate far less than the maximum amount of guest memory.

Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile                            | 2 +-
 .../kvm/{max_guest_memory_test.c => mmu_stress_test.c}          | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename tools/testing/selftests/kvm/{max_guest_memory_test.c => mmu_stress_test.c} (100%)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 41593d2e7de9..4384e5f45c36 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -140,7 +140,7 @@ TEST_GEN_PROGS_x86_64 += guest_print_test
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
2.47.0.338.g60cca15819-goog


