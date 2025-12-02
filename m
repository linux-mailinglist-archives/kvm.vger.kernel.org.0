Return-Path: <kvm+bounces-65055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D335C99CCF
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 02:51:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7436C3A54AB
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 01:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDD7523EA8B;
	Tue,  2 Dec 2025 01:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0BTVy0oO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8169E22D792
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 01:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764640258; cv=none; b=uuo5oW0ZGgERhp77IDMqlr6wW6noOpGNVZh1W2Jm8edlmXRytH5hAPO/76inDlWcienHe0KFihJapCN4xNyIST6uyEh2/i3r5llXVN+njdWPVZe1V6IWHFlxMwc84IgxX1qfug0w5wLIWfThe6gm/yEYHufjVKS9HMTPJezSKWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764640258; c=relaxed/simple;
	bh=jBXbHavDpDLpLPqBNVJ2cBWjxS/+bm7uBS2cd0hUgPw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EmyAGX+fYBRpBfRl6kZaiYNoxtzuJX024LU/AhL3EqgQw4ZIgEIRrVpeNoF9D0G6pHGgT7YpmmgCM85T0mz+cd1GI5jCTkai+CEiI27D7WSzkxZYANF9wC+QeeHZAk/m4xZrdVFSjURrB4qs02oDv88/kqCgKWEIRdq/qUyXaEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0BTVy0oO; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-343d73e159aso9251366a91.3
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 17:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764640256; x=1765245056; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BME1Px9Ut3vwq2N3RnZsXuHYStBK6PJBefpjDa5dUPY=;
        b=0BTVy0oOA/S5Pja5gIuzOT0KPYOOOvWZ9BdaNe9Sn9DQ8cco62h3iLM3S/3hpEEUmN
         bwGT0+tDRpk2IRRYjNWbDMHtwJr/flR2s8ZJWjPdp+WcEbqtyevGcReeKxMGHNG8rpQJ
         cDr2ekN/RWpxNDF303eXs6rBS3TWKY8mCWOYhB+7u1+pMtcLhqP1ZIDQchl77eJV0W6U
         YmJwtyvDCBJS3Pnu/ySHiTYvf9lFGwCyDDfFgs5y6f/YuGOiAcpYsX5yM+266qKtkqe+
         mUnvVboK+/3Rq0r5urfHf2ePultEsaVSJdarb0XA2zs2oS+nGIFNYtRFiAiDwFuet35+
         sHpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764640256; x=1765245056;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BME1Px9Ut3vwq2N3RnZsXuHYStBK6PJBefpjDa5dUPY=;
        b=fR3CqwYmRvus9XwQHxEmO3C88vfu2T5K2sFiorg1Ms26ndM+4u4f65TRt9cbP07Zv5
         /NOzPT0KB3gIjUQk1MxentziqbUxM3OC/AIRdlEF6dhZe5DyvZwgdG55p//OWeZcA2pO
         T0xQoKfqEMNUcN0nPN8YiNlhU/UFX7bSHGB0rObKZUm9rKV4vppe4Si8G+8m5DzLeg7h
         LJ2gCO2gWUk/mhjMVXBtJneWtL/bStVtGkWq4FP085wf6a9LRlDqQa0TrvhG4yQebP41
         Du12X2LFh37MKyEWDAgOQMfuDO2lNnmgwAAagktLKN9VS5Wwe00wj67RANu3KIKpUTMQ
         zKPQ==
X-Gm-Message-State: AOJu0YyEQgkT5PHsK3W8XvYkkS8r6nwaFlIWvDLAYvnr5zrq5UhaF5qn
	bFPDlyNQWGA4R8f3FNZge/r0xThRCJIY01m9XZRZ01Kxq9UI5mzI3wuWRAEWL4e+AvTqip7X6fx
	76bIBEQ==
X-Google-Smtp-Source: AGHT+IFKFuOp+r0/Pu49++qFYtw3VBHQqFGBH7H8HP+yBMMYAoDkn/VFtsauLpUVPrkTqCece+6Ih12FiOc=
X-Received: from pjbsx11.prod.google.com ([2002:a17:90b:2ccb:b0:345:b42b:cf16])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:558c:b0:343:5f43:933e
 with SMTP id 98e67ed59e1d1-3475ed44762mr26573686a91.19.1764640255791; Mon, 01
 Dec 2025 17:50:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  1 Dec 2025 17:50:49 -0800
In-Reply-To: <20251202015049.1167490-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251202015049.1167490-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
Message-ID: <20251202015049.1167490-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: selftests: Add a CPUID testcase for KVM_SET_CPUID2
 with runtime updates
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Mammedov <imammedo@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Add a CPUID testcase to verify that KVM allows KVM_SET_CPUID2 after (or in
conjunction with) runtime updates.  This is a regression test for the bug
introduced by commit 93da6af3ae56 ("KVM: x86: Defer runtime updates of
dynamic CPUID bits until CPUID emulation"), where KVM would incorrectly
reject KVM_SET_CPUID due to a not handling a pending runtime update on the
current CPUID, resulting in a false mismatch between the "old" and "new"
CPUID entries.

Link: https://lore.kernel.org/all/20251128123202.68424a95@imammedo
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/cpuid_test.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/cpuid_test.c b/tools/testing/selftests/kvm/x86/cpuid_test.c
index 7b3fda6842bc..f9ed14996977 100644
--- a/tools/testing/selftests/kvm/x86/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86/cpuid_test.c
@@ -155,6 +155,7 @@ struct kvm_cpuid2 *vcpu_alloc_cpuid(struct kvm_vm *vm, vm_vaddr_t *p_gva, struct
 static void set_cpuid_after_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *ent;
+	struct kvm_sregs sregs;
 	int rc;
 	u32 eax, ebx, x;
 
@@ -162,6 +163,20 @@ static void set_cpuid_after_run(struct kvm_vcpu *vcpu)
 	rc = __vcpu_set_cpuid(vcpu);
 	TEST_ASSERT(!rc, "Setting unmodified CPUID after KVM_RUN failed: %d", rc);
 
+	/*
+	 * Toggle CR4 bits that affect dynamic CPUID feature flags to verify
+	 * setting unmodified CPUID succeeds with runtime CPUID updates.
+	 */
+	vcpu_sregs_get(vcpu, &sregs);
+	if (kvm_cpu_has(X86_FEATURE_XSAVE))
+		sregs.cr4 ^= X86_CR4_OSXSAVE;
+	if (kvm_cpu_has(X86_FEATURE_PKU))
+		sregs.cr4 ^= X86_CR4_PKE;
+	vcpu_sregs_set(vcpu, &sregs);
+
+	rc = __vcpu_set_cpuid(vcpu);
+	TEST_ASSERT(!rc, "Setting unmodified CPUID after KVM_RUN failed: %d", rc);
+
 	/* Changing CPU features is forbidden */
 	ent = vcpu_get_cpuid_entry(vcpu, 0x7);
 	ebx = ent->ebx;
-- 
2.52.0.107.ga0afd4fd5b-goog


