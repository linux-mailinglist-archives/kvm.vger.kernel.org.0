Return-Path: <kvm+bounces-58278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 790BCB8B8C3
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:46:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 575734E30F0
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:46:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8242B32898F;
	Fri, 19 Sep 2025 22:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="doX8oIKK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9D72D9EFF
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321275; cv=none; b=t3RrUG0jLMJ3+wZsbIj3yiUxiqGt+FI2ADw/H6uUfdMKXYnGzCoON+1y1RLN4vO0p77r7upOeIDRzgbFsPLpKDGPtlWSNZgGcqz+kpV453/GhH0q7bNt+vHdhaR0tqyguwcfy84KKkSkckYwvZSh/4zqusFyAqtIGHJZX/1BcV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321275; c=relaxed/simple;
	bh=BYRT6ZOJgxVoRTyU9dJltefO+Nu0RiMFOROWzouBG/o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k9B7K5eYFBs6j9C03oE5WPOOWlFdFrqOlX4RXXNVLDxhf8N6oD8YPwMMfaScmwZlYFu9/K5rvY12BqlS5fTj1M/IHrAgWvsZF61uywfO/Xqf/wC8O7817H9VtE3bj2GkxHyVdU1Qelz42oJqPgOmBJjt3kwrVl1bUzY26mDiGd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=doX8oIKK; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32d4e8fe166so3333229a91.2
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321273; x=1758926073; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WRthGNaMlgYVSEMFE28oT2jZ0xOGZ+MRICHgk9Q9l8Q=;
        b=doX8oIKKl/lvpG52WAwnlezr+N5Q9DBWUP+hlRPDhOXUl/HKq10EnichzpscHYqQyo
         06EYdQx6p8SeAwUoA3oW3BgzJsFCFPdI6WiCeDv1q00EeZz6OIoxUyNwGdreiB2uVoDS
         ivd1p4I6pj8x1F/1KZvB5CT5re4aRkyr2w1zj5iE//8YrQMOd8M4fqSlSGzGZcN13U+a
         B5k/S8v33kfk6I0jGZSsoOB1CWz5SIkh/WA/eq1lDJPMwHfuZvC+JmEBXcLu+R30ABUu
         zFp8NSxRQQdtQZtjrrhQcXKfKuWVoGiqiJIRgJdoN1TsPUDxBZ9E43NPQZutoaYeenhl
         70gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321273; x=1758926073;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WRthGNaMlgYVSEMFE28oT2jZ0xOGZ+MRICHgk9Q9l8Q=;
        b=nWSYroXuCv60XA1u2ypHnI9TEoa9Fsr9HeBnvEnTn7wZ6IAehFekTi3p9u0JvxsfF0
         dz3o4dTFAVe9TlbHs1rqba37lj5KK2cffzCuUsXpRLMEDCiwlpHNWbMD9kASt6zo3rId
         t1r3l1qKdfd2NldgwpvfiovB3QQ3c7a1ubm4PhQm7XiWlx6Y2IWPjxbY3IuMt0wgQE0z
         hHPK9KiBO3nM3MTdLTserZHfZ4qr/lhM947pMD/M4hWixJ5P4NJenHfbPJzRVPli5qiJ
         vau6hO3ZYvkd1A+/aeyaoN+477byzffmegSin6MgVJ/atjioK6vC943YzqtlQpAqznUj
         Gbcg==
X-Gm-Message-State: AOJu0YwlVT3sI+oiRNxjHVswjo3iQd3k7/NqFGMEJHbnWwVf8fO+heTH
	MahBT5TyIYuah3cko/iaSzpAX5d6RbAkVbybN3mKKXJhDGUnXHBy6Xn7HXyjjwVBVzi3C4zB8PW
	VXXGBfw==
X-Google-Smtp-Source: AGHT+IE7WzB+APSm9EHWokWDmwal9l0HANadXjRbGIgyuws7oyp+YYlkQWafkY7rMhgPfMi2ql9eNVL/ya0=
X-Received: from pjbee4.prod.google.com ([2002:a17:90a:fc44:b0:32f:3fab:c9e7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d8f:b0:32e:d600:4fe9
 with SMTP id 98e67ed59e1d1-33097fd4f7dmr6238048a91.4.1758321273512; Fri, 19
 Sep 2025 15:34:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:57 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-51-seanjc@google.com>
Subject: [PATCH v16 50/51] KVM: selftests: Verify MSRs are (not) in
 save/restore list when (un)supported
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Add a check in the MSRs test to verify that KVM's reported support for
MSRs with feature bits is consistent between KVM's MSR save/restore lists
and KVM's supported CPUID.

To deal with Intel's wonderful decision to bundle IBT and SHSTK under CET,
track the "second" feature to avoid false failures when running on a CPU
with only one of IBT or SHSTK.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/msrs_test.c | 22 ++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testing/selftests/kvm/x86/msrs_test.c
index 7c6d846e42dd..91dc66bfdac2 100644
--- a/tools/testing/selftests/kvm/x86/msrs_test.c
+++ b/tools/testing/selftests/kvm/x86/msrs_test.c
@@ -437,12 +437,32 @@ static void test_msrs(void)
 	}
 
 	for (idx = 0; idx < ARRAY_SIZE(__msrs); idx++) {
-		if (msrs[idx].is_kvm_defined) {
+		struct kvm_msr *msr = &msrs[idx];
+
+		if (msr->is_kvm_defined) {
 			for (i = 0; i < NR_VCPUS; i++)
 				host_test_kvm_reg(vcpus[i]);
 			continue;
 		}
 
+		/*
+		 * Verify KVM_GET_SUPPORTED_CPUID and KVM_GET_MSR_INDEX_LIST
+		 * are consistent with respect to MSRs whose existence is
+		 * enumerated via CPUID.  Note, using LM as a dummy feature
+		 * is a-ok here as well, as all MSRs that abuse LM should be
+		 * unconditionally reported in the save/restore list (and
+		 * selftests are 64-bit only).  Note #2, skip the check for
+		 * FS/GS.base MSRs, as they aren't reported in the save/restore
+		 * list since their state is managed via SREGS.
+		 */
+		TEST_ASSERT(msr->index == MSR_FS_BASE || msr->index == MSR_GS_BASE ||
+			    kvm_msr_is_in_save_restore_list(msr->index) ==
+			    (kvm_cpu_has(msr->feature) || kvm_cpu_has(msr->feature2)),
+			    "%s %s save/restore list, but %s according to CPUID", msr->name,
+			    kvm_msr_is_in_save_restore_list(msr->index) ? "is" : "isn't",
+			    (kvm_cpu_has(msr->feature) || kvm_cpu_has(msr->feature2)) ?
+			    "supported" : "unsupported");
+
 		sync_global_to_guest(vm, idx);
 
 		vcpus_run(vcpus, NR_VCPUS);
-- 
2.51.0.470.ga7dc726c21-goog


