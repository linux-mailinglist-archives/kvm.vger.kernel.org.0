Return-Path: <kvm+bounces-35335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 062CEA0C4B6
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 23:30:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9109D1885013
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 22:29:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 564F91F9A93;
	Mon, 13 Jan 2025 22:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WJI5KfBS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1071F943C
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 22:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736807272; cv=none; b=jONdZiSxI4+Vd/xtDr218pM5FViIdiRQeOYesr3Xs0OQ/f7kZpEmaJBG+FvC0dNMR9h8WeCzFEoDeF0PuXYSXnHwhWyxuvxcY7eAAzpc7GPw85GkqB0oXflkyKfy4+ZhTaS109iT5aGbxWIafifpV4zwjCxXSnB7UMTftrJJP4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736807272; c=relaxed/simple;
	bh=rVO7MBo0ZRsY1HA2eYCKrFCp2627yEJRpTuMc9vzE00=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QabEs9HSoXc9bVYBeYWOcliF0rAiHS+yEC16/vRZTFVV/gHHJjZ0WN2VDSju2IX37lDjZyVwHYLxs018qWjIbd1fY+PjSshXNoykf9yBhgq/LrpgOxgQwIko7n+u2rO46GQ1becp0/bK07CPsrh38IM69L5UJYPbVzIpvpQE97k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WJI5KfBS; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2efc3292021so12542412a91.1
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 14:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736807270; x=1737412070; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jEclE4N/e4eNENlrwuP3qv7v6wm9foEArsL1tPTX0Ls=;
        b=WJI5KfBS5lcAQbkxHWvNHdz1qnITUV+sk5jbHKFTHW/xPQhdqsK/VtepuTQQjPHMkP
         cAodJnp83YHRKKOvBSG9iGGojEV/h0jeAXotGm8+wKYbt+n7o5sTgGXnJ0/84Ii3KV1O
         MYy4qLh2K339/MZaWBHuUUsfw/MAMLEhvu137howCi38fiNAzSdwi3AEu6JJevxLEDqO
         +OkJIeUpEQQ6O7s6yGQtQtljZk2mrfDbusq5YhNpnJ9aZntCrKd/acEj0sd/Q/YXaYMp
         2hLuomNrbBvUdZrpLE0xhcgfc5pFbhphOybTHwWOaVfMm42yBejqnR0aomlEzEp3breW
         NAmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736807270; x=1737412070;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jEclE4N/e4eNENlrwuP3qv7v6wm9foEArsL1tPTX0Ls=;
        b=sM7NHxW0yqsqD3zlsQ0IALMAC5vIvm5NGEOINWfj7BK9sIXQqHEbgc/rynkQlB3noB
         //zM3wQrPpCPl3UfZLSbBJEYk02mZNjGwzfhPoT/X3kfqTPedsdjiJm9rMl6/2V4xCxD
         lYHREL1C1e19QKZFTXKfne4mVUqZVJfoG1vNGdqiGRFV07NYDCOWEhTAjsE5PrgZ9FrT
         7+g20h323YJ5tylq/oTnViwdlTMcXTqfhaEQERqrmv7K8SyRLn8ptU8YyZ23Yql8GIC2
         EovoJGdle8HrN4y3Feuyx7cMlwY0wUFQHO+hp4FVeZ5KTD1Tlq/NMOlKQ37fGVboYEIc
         7FIQ==
X-Gm-Message-State: AOJu0Yyby/3AaNfDPf5syuH/DkmqC7b1x9eDbOpx07mn6tUf0nIwlUOo
	WzZKYnqqOoAoRfVK/KZUB48Vb6UUmKkN6JZu0xpgtl8kFsSUaTV7gDbMQ1ZAdpEtAqT5oJtUK/l
	BKg==
X-Google-Smtp-Source: AGHT+IFiLFKOYHUapcng1sIBy0z/SlnfN8YnWN43Y6s4+aq1QD/w0XiZiCqkv3J1FCAtlMyUn3VklWhmgG4=
X-Received: from pjbov7.prod.google.com ([2002:a17:90b:2587:b0:2f4:3e59:8bb1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:53c7:b0:2ee:9e06:7db0
 with SMTP id 98e67ed59e1d1-2f548f3400fmr33844299a91.11.1736807270414; Mon, 13
 Jan 2025 14:27:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 13 Jan 2025 14:27:40 -0800
In-Reply-To: <20250113222740.1481934-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250113222740.1481934-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.688.g23fc6f90ad-goog
Message-ID: <20250113222740.1481934-6-seanjc@google.com>
Subject: [PATCH 5/5] KVM: selftests: Add CPUID tests for Hyper-V features that
 need in-kernel APIC
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongjie Zou <zoudongjie@huawei.com>, stable@vger.kernel
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
index 90c44765d584..f76b6a95b530 100644
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
@@ -139,9 +147,14 @@ int main(int argc, char *argv[])
 
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
2.47.1.688.g23fc6f90ad-goog


