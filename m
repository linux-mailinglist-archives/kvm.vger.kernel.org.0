Return-Path: <kvm+bounces-35899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EBDBA15A59
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:36:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5B22168550
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:36:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C4BC139CF2;
	Sat, 18 Jan 2025 00:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LHOvN3C4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83A82746C
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 00:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737160504; cv=none; b=Tqwoj8KUoTgdqVnQNPqzf9W7zqqErxg6V4uW0nFjntSILAkwxMWk1IbHhnoChNo9UU1oBSjCJ+y4/ubMVrscEQiQcqLUPnrGCUI03lccfXk75XDTJg6mnwN7+MhGfV4/6QnHTF/vQAzu4UqWt6soOX3IPZuDHHtcLfYY1clm9Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737160504; c=relaxed/simple;
	bh=SHTq2kDtgw9gkfy++/oIpJp+B4zXh2grXfh3cPHx9b8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VdT8CqKBsAU9unX0IecPyoe/lE4e7tZYbf1K5kKo3iJ4yAs8LpMWNpLM6uNfnVRXBAFu3ERcfhBiVqRZFKmTqmsJN+AV9W2Kue24jZ/EXmjozLzkL+yFjR7v7Xu2AZo09Dd/yFAjWzizu+y+VqInNi5h45qgCyA3MFE7XEHqffo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LHOvN3C4; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2164861e1feso48516645ad.1
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737160501; x=1737765301; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HRXEZ2l2lIq+cPb1+bgcVVd/Y4QYpoxYvkHlcCCt+hc=;
        b=LHOvN3C4PjjZboGOavajjL05VF2RbaiDtiG70r5PJKFfeaSXEXiIFG+Werh0tSBAIC
         RQ4Ahpc4wMImD1lQaC7WrEHJlALYAVJ5xFh/nuNRrDeIQAH9YGqjQHR95PKKB0HZyBdF
         Neb64b3jrEtpOcedkmjas9g+ezgXCHaYyhNlOFVn83Jnxqj/obxTN75/xYRkoXZ19JQG
         p/3/dMhVvFs7d0UhWo/87vgAEV95elmgcWULlbxVq7PPyTwjqWD8BsvvEu2pTUCLcPGQ
         ScvImRliofxNo5Hc1xwEyikUy/382qQQSXx0LMq9p9+mfW/g1DcxeWbjmhYaS+lOzCHf
         VZMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737160501; x=1737765301;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HRXEZ2l2lIq+cPb1+bgcVVd/Y4QYpoxYvkHlcCCt+hc=;
        b=Z5LHgs8MVcohdefUMhPd3S4ISbB05K8ZA7bXc7sqeYcV6ohe7MbUnZqyS4IMM8r1YT
         jJ8cRgsEYKUWK9NYdymyo7e5cFn5rHdBD8ho58AjrT8Ed/75DRmSdmlOkeaDl2wsfbhV
         0gFME3jWXjcHpHgV4KTkYiUtu+mC0rqEgdt7kc+O2tEjkKfv74ffjxTmq8uBQhuHnZxW
         rx6gUoSJlp9VJnqttYk2pEl8sq0mv878xYMmdT166E+XptUmQcJKeW/5Q3JrzXfkhK91
         29Bat2ozgXf+COxTfttuCD4dSYranJf7aRJyqJj4tsUJLKYVXy/Cvnh2x3tdq0EQPkWG
         7jTw==
X-Gm-Message-State: AOJu0Yxgb+goIiOZOy88MDokshdcYSGOdITpHLbfQTCPT16j5iNXVDct
	HFq2+hETj13T+QEIR+cD+9S2/Y7cYtF5rVnQwtEIMEY+gdRj278OwRsvDfOwunl+vUuVshJHipc
	piw==
X-Google-Smtp-Source: AGHT+IEdL1a3dtHM8hqnKo2mq4PnvT6aTyCFLyiYxbWZnYz41X4lQpTCsFqPdOa0DVupvRidoIK5scNjGvc=
X-Received: from pgbcl22.prod.google.com ([2002:a05:6a02:996:b0:7fc:fac3:7df6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7fa5:b0:1e1:c8f5:19ee
 with SMTP id adf61e73a8af0-1eb214dfdddmr7213773637.25.1737160501146; Fri, 17
 Jan 2025 16:35:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Jan 2025 16:34:53 -0800
In-Reply-To: <20250118003454.2619573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250118003454.2619573-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250118003454.2619573-4-seanjc@google.com>
Subject: [PATCH v2 3/4] KVM: selftests: Manage CPUID array in Hyper-V CPUID
 test's core helper
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongjie Zou <zoudongjie@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Allocate, get, and free the CPUID array in the Hyper-V CPUID test in the
test's core helper, instead of copy+pasting code at each call site.  In
addition to deduplicating a small amount of code, restricting visibility
of the array to a single invocation of the core test prevents "leaking" an
array across test cases.  Passing in @vcpu to the helper will also allow
pivoting on VM-scoped information without needing to pass more booleans,
e.g. to conditionally assert on features that require an in-kernel APIC.

To avoid use-after-free bugs due to overzealous and careless developers,
opportunstically add a comment to explain that the system-scoped helper
caches the Hyper-V CPUID entries, i.e. that the caller is not responsible
for freeing the memory.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/hyperv_cpuid.c       | 30 +++++++++++--------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index 9a0fcc713350..3188749ec6e1 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -41,13 +41,18 @@ static bool smt_possible(void)
 	return res;
 }
 
-static void test_hv_cpuid(const struct kvm_cpuid2 *hv_cpuid_entries,
-			  bool evmcs_expected)
+static void test_hv_cpuid(struct kvm_vcpu *vcpu, bool evmcs_expected)
 {
+	const struct kvm_cpuid2 *hv_cpuid_entries;
 	int i;
 	int nent_expected = 10;
 	u32 test_val;
 
+	if (vcpu)
+		hv_cpuid_entries = vcpu_get_supported_hv_cpuid(vcpu);
+	else
+		hv_cpuid_entries = kvm_get_supported_hv_cpuid();
+
 	TEST_ASSERT(hv_cpuid_entries->nent == nent_expected,
 		    "KVM_GET_SUPPORTED_HV_CPUID should return %d entries"
 		    " (returned %d)",
@@ -109,6 +114,13 @@ static void test_hv_cpuid(const struct kvm_cpuid2 *hv_cpuid_entries,
 		 *	entry->edx);
 		 */
 	}
+
+	/*
+	 * Note, the CPUID array returned by the system-scoped helper is a one-
+	 * time allocation, i.e. must not be freed.
+	 */
+	if (vcpu)
+		free((void *)hv_cpuid_entries);
 }
 
 static void test_hv_cpuid_e2big(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
@@ -129,7 +141,6 @@ static void test_hv_cpuid_e2big(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
-	const struct kvm_cpuid2 *hv_cpuid_entries;
 	struct kvm_vcpu *vcpu;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_CPUID));
@@ -138,10 +149,7 @@ int main(int argc, char *argv[])
 
 	/* Test vCPU ioctl version */
 	test_hv_cpuid_e2big(vm, vcpu);
-
-	hv_cpuid_entries = vcpu_get_supported_hv_cpuid(vcpu);
-	test_hv_cpuid(hv_cpuid_entries, false);
-	free((void *)hv_cpuid_entries);
+	test_hv_cpuid(vcpu, false);
 
 	if (!kvm_cpu_has(X86_FEATURE_VMX) ||
 	    !kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
@@ -149,9 +157,7 @@ int main(int argc, char *argv[])
 		goto do_sys;
 	}
 	vcpu_enable_evmcs(vcpu);
-	hv_cpuid_entries = vcpu_get_supported_hv_cpuid(vcpu);
-	test_hv_cpuid(hv_cpuid_entries, true);
-	free((void *)hv_cpuid_entries);
+	test_hv_cpuid(vcpu, true);
 
 do_sys:
 	/* Test system ioctl version */
@@ -161,9 +167,7 @@ int main(int argc, char *argv[])
 	}
 
 	test_hv_cpuid_e2big(vm, NULL);
-
-	hv_cpuid_entries = kvm_get_supported_hv_cpuid();
-	test_hv_cpuid(hv_cpuid_entries, kvm_cpu_has(X86_FEATURE_VMX));
+	test_hv_cpuid(NULL, kvm_cpu_has(X86_FEATURE_VMX));
 
 out:
 	kvm_vm_free(vm);
-- 
2.48.0.rc2.279.g1de40edade-goog


