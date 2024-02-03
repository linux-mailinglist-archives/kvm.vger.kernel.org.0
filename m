Return-Path: <kvm+bounces-7885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AF96847D9C
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 01:13:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E44CB1C228D1
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 00:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA51417BCF;
	Sat,  3 Feb 2024 00:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bnt6gnw2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA9B13FF2
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 00:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706918983; cv=none; b=SlDvXKhZjRRNIaNfkGMLeM0cU401Dy9ccEPNpITQxK+w0BklEDy8pkCP5mKO5I1/AG/X8EK/II3kQN0RxQaKH6k98kPDSMMNGefT4iANnt/jMbP6r4myl46mbIENvDCz/VK/NwkKEWS4dvTJunXTs8icKUJAN8CwPkF3NXQ+L8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706918983; c=relaxed/simple;
	bh=dxFDbsAQMhSueKOp2cttxeSOtYuXNHRkrePZ7bjyZ1U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mxaN/tHkl3hRQO3jN2BT0uUwq8YE1c1gHWH6yRVIjxY1lQTftqP5lnpTLSR/Z22sJxALyo1/xBxPBFpJzYZoZ+7pAwBwpGBXyx4f0oTps0WZwf/Nk+ZQrg58gEyYgcohHQ8HSo8c8QhQpF/l3vtaw+tw/gQYnY9zxlSmV0yCBbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bnt6gnw2; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1d932f1c0fbso25441315ad.0
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 16:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706918981; x=1707523781; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VzhuhwHBOVTPe3ek7qdXtFf4wVMa0yBW9i03fvIkD6g=;
        b=bnt6gnw2arROnor157+UAWxYa02ZsadT4zbEncIYG1BpJmmwPx3eKR0fMf6BoTeaa+
         im0SIt34/wbwKyGJQFpoZ58msCstKa5ohg9dE2iFJYZjwWMIeJv9eVoyzIR5EFo1kPnq
         o1agCJhmWI1yDdbOnYZ7riV5WVHY3zelYYKBaBsPoaiV5vgfyv9qz0HRw19ETK+/Bcj7
         F07UAet363tPsJK0hPUeTy43teKgkl13TL5viArqNF91cD/oav62QkDvzr5VsJ7+Sq8F
         KcyHc7o59UmfWLJNQK3HOoa0tNgMhqifnBx6Z31ThKC2tzPm8d4XspGqgJt+OaCpsK4W
         6mUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706918981; x=1707523781;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VzhuhwHBOVTPe3ek7qdXtFf4wVMa0yBW9i03fvIkD6g=;
        b=P4mbs8f4YHva/vsVzClmm1/3PveilgrQ0cZ5kQEHqIpOoPyHS5hMifUJdtMIMQ9Q3K
         mvDLNj5GajHzy3kcxGWoHwsbTYHh992Ta0oAGGTN59KeILcT50eaMXuAzBbW47SVBBHP
         npVxyirPNS48JB9WBa9KU5zZOzgvKP3y8uJXP4tYcNFLnUl91z+XJsv6XdJcHe3G8sk+
         btwen2B5VcM7T4qnJ8Wxg1h6fISkIomvpAGSCdH5pGTIlMpJ53QsEVtDYACQ/p3mkgvD
         kQFPzXdDIivMtZbWv+p9rmRyYAi79udv25/Q9Btr26sZ1iByDopLbfb3uxoZoYy8eLLf
         +EKg==
X-Gm-Message-State: AOJu0YwwJWF+Oes6Gd7Ndn4NHauNeJx3Kn+O/pj8tWpqeSrrZ7dYjYJs
	LYF+mhYsfnV9Nee2wSj9dQXgUkvv55V8pBt6Zas1seNGIkchtCUFyIMSxNe0hIWUuEnkB5XGH2v
	+TA==
X-Google-Smtp-Source: AGHT+IFdVzXVjWcXSdnVu4txbSAxtL7z3o5BSMoU53EUfpfZ3637JRMu4aCEDmVPmG/jpu55q3noR5dZ8rg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e741:b0:1d9:1ca3:1883 with SMTP id
 p1-20020a170902e74100b001d91ca31883mr51751plf.5.1706918980700; Fri, 02 Feb
 2024 16:09:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 16:09:16 -0800
In-Reply-To: <20240203000917.376631-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240203000917.376631-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240203000917.376631-11-seanjc@google.com>
Subject: [PATCH v8 10/10] KVM: selftests: Add a basic SEV smoke test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Peter Gonda <pgonda@google.com>

Add a basic smoke test for SEV guests to verify that KVM can launch an
SEV guest and run a few instructions without exploding.  To verify that
SEV is indeed enabled, assert that SEV is reported as enabled in
MSR_AMD64_SEV, a.k.a. SEV_STATUS, which cannot be intercepted by KVM
(architecturally enforced).

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerly Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Suggested-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
[sean: rename to "sev_smoke_test"]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/x86_64/sev_smoke_test.c     | 58 +++++++++++++++++++
 2 files changed, 59 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_smoke_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 169b6ee8f733..da20e6bb43ed 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -120,6 +120,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_caps_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
 TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
+TEST_GEN_PROGS_x86_64 += x86_64/sev_smoke_test
 TEST_GEN_PROGS_x86_64 += x86_64/amx_test
 TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86_64 += x86_64/triple_fault_event_test
diff --git a/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c b/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
new file mode 100644
index 000000000000..c1534efab2be
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "svm_util.h"
+#include "linux/psp-sev.h"
+#include "sev.h"
+
+static void guest_sev_code(void)
+{
+	GUEST_ASSERT(this_cpu_has(X86_FEATURE_SEV));
+	GUEST_ASSERT(rdmsr(MSR_AMD64_SEV) & MSR_AMD64_SEV_ENABLED);
+
+	GUEST_DONE();
+}
+
+static void test_sev(void *guest_code, uint64_t policy)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	vm = vm_sev_create_with_one_vcpu(policy, guest_code, &vcpu);
+
+	for (;;) {
+		vcpu_run(vcpu);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			continue;
+		case UCALL_DONE:
+			return;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+		default:
+			TEST_FAIL("Unexpected exit: %s",
+				  exit_reason_str(vcpu->run->exit_reason));
+		}
+	}
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(is_kvm_sev_supported());
+
+	test_sev(guest_sev_code, SEV_POLICY_NO_DBG);
+	test_sev(guest_sev_code, 0);
+
+	return 0;
+}
-- 
2.43.0.594.gd9cf4e227d-goog


