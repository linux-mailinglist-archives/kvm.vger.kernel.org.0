Return-Path: <kvm+bounces-35900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53403A15A58
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:36:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FB393A970F
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:35:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C2E6137923;
	Sat, 18 Jan 2025 00:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I9T1dKEG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F93B5789D
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 00:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737160504; cv=none; b=Eitqk/sftnNyoctTSfsz+uVVCce9mWJbDFue68XyfgoxXCqS/Lu9Qm7bWfMuqjJK1L9tIykNnQco+Zgld8tGDWSNrvE5zWM8WlxZ4DKBCsfz+9nwF4/QhNyTveiOlAar+m3pg9DBZbMASL2eNknSTj/IIv3EhTkLr0BJDC2+lQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737160504; c=relaxed/simple;
	bh=M+FM8JkgaYrZl57UPJEKqk4HTQ5og7YrE3nrBQALWz8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I8IytaQkrVpRtbQF1kCJKq2K9IbbJbKe6sbBftGSs+iBCpBsWCHVi8PlayWi7uN7OBD1/4OaaylMiqa3DU0pqIaP3/JIQZ1UCGv3Sd2ZW5eplsyTbUB1+bgYsHVj6ot6gklmwR1+zPKc2QuStosnS4BdZwK0lX3bKh2vTZn3ZMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I9T1dKEG; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2eebfd6d065so7648661a91.3
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737160502; x=1737765302; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cl05ZUliPLXN59ib2RJa1JltTQzfK7DQwuddn7WHN1A=;
        b=I9T1dKEGMa++wPsxcRnwtvsYyBoG/yXsyeVtwKpDs29aNfFixTKXqZrtfGh3uvDD3q
         +H2/wgDt0NHizMIfL0QSP/hfd040aRpupB04U8GBUthKOqfe7giPWx5IJRlCUTCp8iXB
         UEswX6vDmgqFYTUE+uNqF5YqSZq0BI206jIUbLaClSAbXo03Yov7Cw9aeRTGr1SgUhkd
         Ms4x6Yvwbpd232kKykO15iuggFuXqYPv1DT81W5xiq1mDrHUm9bGI6CtZu2yxdmbhNOR
         oZhp4YtqPAzmRzW6fsky/G33J1XkN0IGXnLDlKLKlsB/Lz7djSUDiOgsHl+2rp8snzU/
         OyCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737160502; x=1737765302;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cl05ZUliPLXN59ib2RJa1JltTQzfK7DQwuddn7WHN1A=;
        b=kZus3rPhK28JiM6kn4zEzLOfYiupjEeOjUVqETNSJHRScGZgDgMVkVZeZgmrlbm1dN
         96rjQjsB7NtGiaYViU8zuK7OLtKyOJwCKg05fGOZvhoUDgZvZZnZK5VkqejPFkQ6hB7a
         sFkWusKRPEYF4Ea/T8+hT86W81IQtxO8mOmOZ+kaqaf0jWnjzJffGsU0TyVE25VM9kob
         FSKCl/pCGyq30+SxvRWDA4sRpBZ337EBBaV8FWeLEYU0J4lsG5dwBRGuOa2IC5TSPCTs
         Wp2R6+joscbskWFdiXRltrY7R9XmbSZgCLhCUSj+hYI/XdgVBWqh2M2NEJG/BM8G9ibL
         EEWw==
X-Gm-Message-State: AOJu0YziBcMF5J2YXBECuD9vefcK3adknueYkmSuacnj3EHWoFo+L1pP
	vxYgW247DNh4VZK+1mn1HxfXcTdf8tyEGBqN4SwnhiD6xRGY6JPlbqDYmLBT+j/TSpGv1Ql7MX7
	10Q==
X-Google-Smtp-Source: AGHT+IHQoMle06kwl/jYSacrkQ0Aw9hacjyWr7GuGkDpttr40/QHVTT717DSO+tCgrdOhmz1HhwpSzAHs+o=
X-Received: from pfbkp16.prod.google.com ([2002:a05:6a00:4650:b0:728:ec44:ed90])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:b96:b0:72a:bc6a:3a85
 with SMTP id d2e1a72fcca58-72dafbb6205mr6756642b3a.22.1737160502655; Fri, 17
 Jan 2025 16:35:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Jan 2025 16:34:54 -0800
In-Reply-To: <20250118003454.2619573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250118003454.2619573-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250118003454.2619573-5-seanjc@google.com>
Subject: [PATCH v2 4/4] KVM: selftests: Add CPUID tests for Hyper-V features
 that need in-kernel APIC
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongjie Zou <zoudongjie@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Add testcases to x86's Hyper-V CPUID test to verify that KVM advertises
support for features that require an in-kernel local APIC appropriately,
i.e. that KVM hides support from the vCPU-scoped ioctl if the VM doesn't
have an in-kernel local APIC.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index 3188749ec6e1..8f26130dc30d 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -43,6 +43,7 @@ static bool smt_possible(void)
 
 static void test_hv_cpuid(struct kvm_vcpu *vcpu, bool evmcs_expected)
 {
+	const bool has_irqchip = !vcpu || vcpu->vm->has_irqchip;
 	const struct kvm_cpuid2 *hv_cpuid_entries;
 	int i;
 	int nent_expected = 10;
@@ -85,12 +86,19 @@ static void test_hv_cpuid(struct kvm_vcpu *vcpu, bool evmcs_expected)
 				    entry->eax, evmcs_expected
 				);
 			break;
+		case 0x40000003:
+			TEST_ASSERT(has_irqchip || !(entry->edx & BIT(19)),
+				    "Synthetic Timers should require in-kernel APIC");
+			break;
 		case 0x40000004:
 			test_val = entry->eax & (1UL << 18);
 
 			TEST_ASSERT(!!test_val == !smt_possible(),
 				    "NoNonArchitecturalCoreSharing bit"
 				    " doesn't reflect SMT setting");
+
+			TEST_ASSERT(has_irqchip || !(entry->eax & BIT(10)),
+				    "Cluster IPI (i.e. SEND_IPI) should require in-kernel APIC");
 			break;
 		case 0x4000000A:
 			TEST_ASSERT(entry->eax & (1UL << 19),
@@ -145,9 +153,14 @@ int main(int argc, char *argv[])
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_CPUID));
 
-	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	/* Test the vCPU ioctl without an in-kernel local APIC. */
+	vm = vm_create_barebones();
+	vcpu = __vm_vcpu_add(vm, 0);
+	test_hv_cpuid(vcpu, false);
+	kvm_vm_free(vm);
 
 	/* Test vCPU ioctl version */
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	test_hv_cpuid_e2big(vm, vcpu);
 	test_hv_cpuid(vcpu, false);
 
-- 
2.48.0.rc2.279.g1de40edade-goog


