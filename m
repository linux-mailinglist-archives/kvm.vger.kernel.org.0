Return-Path: <kvm+bounces-28265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B82599970C0
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:12:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3CB82B267C9
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3698202F93;
	Wed,  9 Oct 2024 15:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I/AY7GT1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786B4202F67
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 15:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728489009; cv=none; b=EnGstcivQhhzSyxSbkDTr1KBaBCC0QEywFpJ7hcwSDGIiAynwVsAGohCQoTr/wRaF7GEK7QippYXsJwnS127v6oth4HQ4Rmmy2jybXzoYJNX/u3pZq4ICW8CnqtkwaC2wpq7zeZ2MhavQ9Eh0iqNJmdhx4Brpb77QKCGi/HJuK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728489009; c=relaxed/simple;
	bh=rzKl++CWaUW8jRUGQiR8avz8+vDBd2uSvVkufkDoQug=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=skufGYgiVXndsIMV3An0rsnN91E5SRrQzYByeeXa7xlph7t3iqab8B80wl9ozhDPFQY7ruc6ZeG7gJWpzlpsisfU/lKSnp0BD3rOvzSFWs5nWsnZjlv/dr/TTxTL99ZSd+doZeIX/IVed6R/ojcDhvVLWBueJxHjqNd6LnlJlCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I/AY7GT1; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e0082c1dd0so146325547b3.3
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 08:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728489007; x=1729093807; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9+y7oelTnk6r5KXO5BIzd9TWGjZrwMN3AFTrylQnTmc=;
        b=I/AY7GT1bgD9i8lobvu05GIV2nOjbI9GCdlGiaHQK3NhazjbvpUDZ31rMp5fFeW4B7
         6TtkLxvwLRU5ZSjIiRQ/hidvAY3HMTbKSa5+ITsLd2mcU3rCOjQUg/WkGCCugrR4RGja
         1nagJRpsWiJmEACvdZss6FPxtXY/sv6jtOoy1C3HqDAsdxRBmg3WrKEIoRPdjObsdV9K
         Fil3n56TnJtj+HIZyMsm9j0qbv99StAFFqHDoXhiqwD6JXcUQ79/5bU4O6V60ZG3s3Zs
         1GQuCC2iVaLrY/ltHaR5HgtSKRRdYDL4BfZF6Nv2fdhQTR8um+k38A3AdN0NoYli2qM2
         QBNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728489007; x=1729093807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9+y7oelTnk6r5KXO5BIzd9TWGjZrwMN3AFTrylQnTmc=;
        b=ZtCBEiZLSSt+RhyoCB+em2sMXDdCnd0k7GdqnD2JA9m86CfxsbNGTRJJO/e5LoVOyg
         47pH8j6s2ScnWL/auxONvaqq/SiiCOLyXnv1Zpuv+PglXeyfO6aOABJ8vGKkuqZn/heo
         9st/pEat5wJAZ84E6yTpZZwk1mN6HM1gMEU1l9Yne+51Fpq6SuF9Y7nXPGrFleN874TO
         ON1lUGq9hPUt3rfI73Unn3CnfmFWLNEPaSaLmZsvkVJxyehMxLd75SY2o6IT10cOccOu
         FXR5iLVJDQ5iieeishkxXZVPNxlBC3qIQOkS4YTMz1WpWkevfVbd1vUHxfGLkVuDgNyO
         5LXA==
X-Forwarded-Encrypted: i=1; AJvYcCXbcnLNFbetudgpzCTwCHYtz+oVg2Gl8RTqTjM5ovGRaaRF31ZeL7UXniKC/iAAXakIms0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVbt6w5fN9vQyw3ucklPylLToMdLyviarp5fRLbBXaVLT+n7+R
	XfvYgpPsitlqjZS8FfhMuihdMEykyKxbOUE3KzWsWLPbin79V2Vrvq+aKXItPIZ6sSxmwzydGMx
	Ygg==
X-Google-Smtp-Source: AGHT+IEnOiEr/7ufmCoIIHo0RYjnE1E6sJgU5IKNyLPqmQLuHnTee5V8zvUGQ36LhzFM/1nmzHnRUzKqVBw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4b08:b0:6e3:b93:3ae2 with SMTP id
 00721157ae682-6e3220deef6mr671277b3.1.1728489007658; Wed, 09 Oct 2024
 08:50:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:49:45 -0700
In-Reply-To: <20241009154953.1073471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009154953.1073471-7-seanjc@google.com>
Subject: [PATCH v3 06/14] KVM: selftests: Rename max_guest_memory_test to mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Rename max_guest_memory_test to mmu_stress_test so that the name isn't
horribly misleading when future changes extend the test to verify things
like mprotect() interactions, and because the test is useful even when its
configured to populate far less than the maximum amount of guest memory.

Reviewed-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile                            | 2 +-
 .../kvm/{max_guest_memory_test.c => mmu_stress_test.c}          | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename tools/testing/selftests/kvm/{max_guest_memory_test.c => mmu_stress_test.c} (100%)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 6246d69d82d7..8c69a14dc93d 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -139,7 +139,7 @@ TEST_GEN_PROGS_x86_64 += guest_print_test
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
2.47.0.rc0.187.ge670bccf7e-goog


