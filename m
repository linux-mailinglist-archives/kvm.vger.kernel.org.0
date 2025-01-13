Return-Path: <kvm+bounces-35334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DFC7AA0C4B3
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 23:29:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD2927A3642
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 22:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE0781FA8EA;
	Mon, 13 Jan 2025 22:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oHXtl8hc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664151FA174
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 22:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736807270; cv=none; b=Q1bn6SFKOX9Y1fXXD0cGiRi0mTzHXJ5mopyNFGBofCoow2t+dStF82TcKOhRPPvbmuuXFXLeiv5XIrUzNJ4xxzAN4u3Fx1thLpogdFMhQuTCa2dMF5NIxtO/0eypgJROGDvQYYnUv4wCN7MnM1j+79oJZNray9fMfV1j4KDl/Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736807270; c=relaxed/simple;
	bh=iZqIiGhqGkDp1l9h+Tl36RWsA0eh5huy0GX52g1XNG8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mFncItMwXcX7quVV4fjCu/1xq1tzLVFc1gL6ktzOHsTq6vEeVF07W7HOidCibs8LrjPU15mMwtTA2XEE3YvXRjP5NIB4yml0cy6Ons9bLl4p7fVLflxhesWWIS23wIkQ97WQUr0TaP3KUIPYSGUNzFwkhDZXU/xaViOqaXzqKww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oHXtl8hc; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee9f66cb12so8623970a91.1
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 14:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736807269; x=1737412069; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BUiKBnRthtYi8hLYA5ryBjgwDDiPDiUap44/jYe6tjY=;
        b=oHXtl8hcAHWHwnMUfqGvqC1qBQE50SXKse1A2tpppX+sNOnfWvZ7IcCT95aiDwC673
         EjWh4vrlNx0XtIrVaLWhvTFJnZhvi/PtEorRGFuP+NyV4oURKfRQ4X/5kExyhaEKRqJj
         56l8SWdr/wkJ33PxkqqkXa2sE+yzrn8rezkIJkx1eaZo3t9Vabqt0elMfJ1y3LDJwwsg
         XgFExDBsuy7MvOYd+LXtlAcxT2lqijyHldY4psBJ2w8teAESZT9PgoVEgwgDai/OmaAv
         hi7hJ0hyr/QDN7u9Po4UlNMxlcFvRZpFXEnMym/KaxSl0isLnc8C2xo4BmJR6yi7Jj4D
         lptQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736807269; x=1737412069;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BUiKBnRthtYi8hLYA5ryBjgwDDiPDiUap44/jYe6tjY=;
        b=HQnbd0HIe5jrvMAQ9a5bZ9Lsso+sxNBmDhPD0O7Jxo4y5N6GiJKnxsDXKnTvXFF0ms
         mD/agihWWMJ5eRSC2wOL8/z7wOpZHkp0gLwWN0ojXozJ0OIH4ZRNkOSLFV4a4Uo3ydWS
         RRrJ38Nkzy0XIXj0s0WryyWLBqNLuAkZCKnnj28SpBVGZgJ+EM0l/KtJnqg9sDX/VtLB
         6uu98im8cTrVQU4nQZJjeD3B4lzNhugtbakwrXzk6W7onrIlNbDJ7taUxXpj63g1zSYx
         9iN5gLlBDQwZ3+DjjkQ5MqeNl4vggjoLOfrVTv62jXCwW+3e4YKMd+FuNtoF0nnM3Q3S
         k4uw==
X-Gm-Message-State: AOJu0YzCqwQ1FI3jD0nNQbUk0OfQLacnddnRf2ntcpFsGSCoiGL5VkIM
	XIyQLG0TJPS8nLY9w3K5pG+wCj8YvpXrr85egLIJyzyWBWT+2VfYiu9mojmO4fr39mlLCCFVDHQ
	Y/g==
X-Google-Smtp-Source: AGHT+IHr3YxVY4T6srwZUwxI0ZW6g2YPlW69vv/o0vnwcKqZpomk75DDB0odCx5hUB1kSCPXFWYmf+EoR1o=
X-Received: from pjbsd14.prod.google.com ([2002:a17:90b:514e:b0:2ea:5613:4d5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2588:b0:2ee:c9b6:c26a
 with SMTP id 98e67ed59e1d1-2f548eae05amr33135273a91.11.1736807268726; Mon, 13
 Jan 2025 14:27:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 13 Jan 2025 14:27:39 -0800
In-Reply-To: <20250113222740.1481934-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250113222740.1481934-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.688.g23fc6f90ad-goog
Message-ID: <20250113222740.1481934-5-seanjc@google.com>
Subject: [PATCH 4/5] KVM: selftests: Manage CPUID array in Hyper-V CPUID
 test's core helper
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongjie Zou <zoudongjie@huawei.com>, stable@vger.kernel
Content-Type: text/plain; charset="UTF-8"

Allocate, get, and free the CPUID array in the Hyper-V CPUID test in the
test's core helper, instead of copy+pasting code at each call site.  In
addition to deduplicating a small amount of code, restricting visibility
of the array to a single invocation of the core test prevents "leaking" an
array across test cases.  Passing in @vcpu to the helper will also allow
pivoting on VM-scoped information without needing to pass more booleans,
e.g. to conditionally assert on features that require an in-kernel APIC.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/hyperv_cpuid.c       | 25 ++++++++-----------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index 09f9874d7705..90c44765d584 100644
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
@@ -109,6 +114,7 @@ static void test_hv_cpuid(const struct kvm_cpuid2 *hv_cpuid_entries,
 		 *	entry->edx);
 		 */
 	}
+	free((void *)hv_cpuid_entries);
 }
 
 static void test_hv_cpuid_e2big(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
@@ -129,7 +135,6 @@ static void test_hv_cpuid_e2big(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
-	const struct kvm_cpuid2 *hv_cpuid_entries;
 	struct kvm_vcpu *vcpu;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_CPUID));
@@ -138,10 +143,7 @@ int main(int argc, char *argv[])
 
 	/* Test vCPU ioctl version */
 	test_hv_cpuid_e2big(vm, vcpu);
-
-	hv_cpuid_entries = vcpu_get_supported_hv_cpuid(vcpu);
-	test_hv_cpuid(hv_cpuid_entries, false);
-	free((void *)hv_cpuid_entries);
+	test_hv_cpuid(vcpu, false);
 
 	if (!kvm_cpu_has(X86_FEATURE_VMX) ||
 	    !kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
@@ -149,9 +151,7 @@ int main(int argc, char *argv[])
 		goto do_sys;
 	}
 	vcpu_enable_evmcs(vcpu);
-	hv_cpuid_entries = vcpu_get_supported_hv_cpuid(vcpu);
-	test_hv_cpuid(hv_cpuid_entries, true);
-	free((void *)hv_cpuid_entries);
+	test_hv_cpuid(vcpu, true);
 
 do_sys:
 	/* Test system ioctl version */
@@ -161,10 +161,7 @@ int main(int argc, char *argv[])
 	}
 
 	test_hv_cpuid_e2big(vm, NULL);
-
-	hv_cpuid_entries = kvm_get_supported_hv_cpuid();
-	test_hv_cpuid(hv_cpuid_entries, kvm_cpu_has(X86_FEATURE_VMX));
-	free((void *)hv_cpuid_entries);
+	test_hv_cpuid(NULL, kvm_cpu_has(X86_FEATURE_VMX));
 
 out:
 	kvm_vm_free(vm);
-- 
2.47.1.688.g23fc6f90ad-goog


