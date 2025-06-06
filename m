Return-Path: <kvm+bounces-48690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D7A2AD0A84
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 01:57:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25FEF170AEF
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 23:57:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCB17243371;
	Fri,  6 Jun 2025 23:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0lW/Jq3m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92F2242D6F
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 23:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254211; cv=none; b=ujWymgNL6ymiXfhEMLoyf7oTTa3wfZ/gqnlR+F3r2pemCqukuABa9yqCkDA46oR5bw65zP1ffhzlEbH2h7l4tOWKEo4Me7XGVRhA7U8rSgjONxMjHbULofmBNJJRiycjoFfJAOGi1SaEBguE6xrC920sMiFkAuZq1Z0DdgqGGqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254211; c=relaxed/simple;
	bh=5kWmyg0mzQCWaMvRR7AqG1JiSbOPIy1E7Aj/zN7WjQs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qJYXUM4DlxIupg6eOk71/Kvszi6C+/sjUQKg3ax6/85NfD2KFkLxASRXmKorZ3Jhb/F/pWFsbGPKRRS/+1PjOpQL3vlovGnydno/YA8kBOiVDYDjO0sELZrE6nqFvpxiyIhXq9vr8a81Cnky3oJapzdVxg2TNE7vY5xxlTf++3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0lW/Jq3m; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7480d44e6f9so2443209b3a.2
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 16:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254209; x=1749859009; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+L9DXCjLorTxOh1B5xNStH2dnZ/sReG4cpxDvwmWD0Y=;
        b=0lW/Jq3m12gPdrU0tBBuSvlbDoxphG4W63+gCcUbZgV7My1JxQDs3cMlBxgoErGpet
         hgXl/G2BUqKthDTu5OwCMe0RKkLjgMlDrtp60E5oZIxLv5y4zPTNtGgLova8umrnCrBh
         jDtRbaryWVHSQL5iIBF89XVCQbUdNVTNd80ig1FF6M8dSpC2HkN+0tAfVQDaW/Rmf1uB
         PgVhewvNUPO5i1tGjNKW6tiUYbArXt+FB7a1R7YcUgwRA7z/KqnkapGp5Nks2vNsLEzk
         /nj5voPfbx85HrTWyF0Ksgl7LptGaSYP3qtHm2n/Bol2UGlUJ/Cw+74JW0aEREpeW40M
         n9TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254209; x=1749859009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+L9DXCjLorTxOh1B5xNStH2dnZ/sReG4cpxDvwmWD0Y=;
        b=HPO/NCQtmAIBq1dKaNnR/AG9b2orS2Xb6LIDOElUKjYVW892UbO6HdO77C/O4JNRr8
         qDvKXgy4dXyYpmx+6GSsbWuYX0JGp8sUaacRXwmfcZ1lDcUOCN1tsodhZroqMgqZnwfA
         R8PFiX/A3FKz5RKrzNUqbNxXnPFQFY2CXNZQtu+qCsc2LVKR+qGO/phv2uZ2CHlF5+Ik
         YhtoFmIu2HAwLkOouHcTO0DuZ8mD0hhqyz5tc4qo73fwqZdEfu6JZZwhNrnBMhcpdlWL
         We5U8UxKz31EF26wPSwO/kRzNH/IHt2zvIKI+H11O5J37FDioWHbgA/200eVGueBzjku
         GILA==
X-Gm-Message-State: AOJu0YzZNsCXBBE0J3OXyG0+Gn8dqKGcEFAyiLzuywvp/G82s3ZyKG07
	rq72b1wXdbyPUCMXAVWRPAgVahntTXZGupAxos1ovZBWNqQBlMnQ8ubbei6uWydcilEZwECgjJl
	X4Sf9zZRmIoacTCuuSGp/xvVvSEguG+8X4ab+qi9UEUZJRGAa/FknlJWR0AuImoaN6OoBt6/CFv
	/6xgP/4DdgXKV0dKg1N+m76hch5ii2mTWMyMqiRg==
X-Google-Smtp-Source: AGHT+IG03XZnvqZOkOqBwMRzzNhIPgcN1ZsHQWgIs4EPRw8vsSrtSnCZF4xjJkBMv/LE7Ar4ODi53Kp40Xk2
X-Received: from pfbdw13.prod.google.com ([2002:a05:6a00:368d:b0:746:30f0:9b33])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3016:b0:742:a23e:2a67
 with SMTP id d2e1a72fcca58-74827f14a6dmr7102295b3a.16.1749254208946; Fri, 06
 Jun 2025 16:56:48 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:15 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-12-vipinsh@google.com>
Subject: [PATCH v2 11/15] KVM: selftests: Auto generate default tests for KVM
 Selftests Runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add logic in Makefile.kvm to auto generate default test files for KVM
Selftests Runner. Preserve the hierarchy of test executables for
autogenerated files.

Autogeneration of default test files guards against missing these files
for new tests cases or rename of existing ones. These autogenerated
files will be checked in so that during git-diff one can easily identify
if the existing test files for the same test binary also needs an
update. It also add new tests automatically in the default coverage.

These files will be auto generated with each make invocation but
overhead should be very small as these are very small files and won't
be shown in git-diff unless test name changes.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 307ef31d3557..a76502406123 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -201,6 +201,14 @@ TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH))
 TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(ARCH))
 LIBKVM += $(LIBKVM_$(ARCH))
 
+$(foreach tc, $(TEST_PROGS), $(shell mkdir -p tests/$(patsubst %.sh,%,$(tc))))
+$(foreach tc, $(TEST_PROGS), \
+	$(shell echo $(tc) > $(patsubst %.sh,tests/%/default.test,$(tc))))
+
+$(foreach tc, $(TEST_GEN_PROGS), $(shell mkdir -p tests/$(tc)))
+$(foreach tc, $(TEST_GEN_PROGS), \
+	$(shell echo $(tc) > $(patsubst %,tests/%/default.test,$(tc))))
+
 OVERRIDE_TARGETS = 1
 
 # lib.mak defines $(OUTPUT), prepends $(OUTPUT)/ to $(TEST_GEN_PROGS), and most
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


