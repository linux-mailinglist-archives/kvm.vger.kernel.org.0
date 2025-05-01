Return-Path: <kvm+bounces-45150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D9914AA62D3
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 20:33:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D4E941B6558D
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 18:33:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6995D221292;
	Thu,  1 May 2025 18:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ScpkMcRy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9BA223DE3
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 18:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746124402; cv=none; b=k96BoVXOHYwvJcPSxaGbCjSLIsRhFem+v4SgXXWzBg/20C6j7YurTDW24REKDKWXOXIL0OZ/YZw3jRy9vqNxfjBI9TnRJUwkvRE+/TV1b1uXKq1/SYuDD/Y5pY/+c6Ss4ixOrrT6HDK5vR/XlkbxLh2cWJ8x34W/JQH+UvFeZYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746124402; c=relaxed/simple;
	bh=B5UaraPdxHpT8UjUOBrmqqlMDErnWldn9oIkLIIvGkg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ee3IU4fSp95FyP1pgkX5mG7a5Li/Ghqu1w83C7VZvcP46/F1InL/ILGohQ1z9Sv4w5Z7GSq88De4RdOhYhx1GYZhL6ETUfwy1K5eABFMMrcs9jmR7DIImZvRHQ/TVgmZED6u32c2WH2kJhWvtiGoux+UUmp0pf1NAD+HmFHXG28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ScpkMcRy; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30a29af28d1so985011a91.0
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 11:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746124399; x=1746729199; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6OIbU+P+6LX7gXLQRg/LGs6gF16rvs92LA9pz4G+MTw=;
        b=ScpkMcRyq6MLxPUQyxm3WoG8jlwbIdSy8N+GL64hJASQA27HmVxXY8Z/YLqCnEXt6l
         Q8j5OrQPkzIlmptAk0qhnDX4jmzsIj/iJ3zCkj7JXkkcXT6SOixsz2f8cAj2eXdmi9iX
         Mh2MfQfFPCTik9jmaVFA1EbOqlR7VIXk0Ip3RvjkHZ+YvmJ0A7JYhmblCZafj+/5vz0A
         17rlIeR9YYM9DKHu2ufO+rMaIdNTXef4//58C+F3rVI1b+pFVWfcVXdntZqBAO6yzXak
         C3AnfVaZynU93kJFjLRHm/SLTK2lUjsTUmEbrK6C8FVCUIOH6yrYh92zRatKEtlQXCry
         3e3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746124399; x=1746729199;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6OIbU+P+6LX7gXLQRg/LGs6gF16rvs92LA9pz4G+MTw=;
        b=ECfkU3BPNjpqaICQdl75Ay6zGYERfIbd29s1HDGBWoEAx5QmjZhZ0iCdAdmV4Vud9g
         w+ekYBk5zQOgvXGw0Bzy6O/qHedLxxRlOWUIUWDxDKU/8pyxwamBSnXlvAq0FQDKjdmK
         /WGpECW+SDA46VnjvHT3Hc0+2xZPdaZKwkL5AFqSU84mU4xd79WvJeSdgoGKlvR0OZCm
         sWIXUyDwOl2nCT6zmBhSkFWXcDBo5KilOwBtj1oIJVdD7uHok89uNnHkb0IBeuEifqgr
         bQkE8hj5iSyL1raaSxyuQrA72rJa0QdZSDGTAVnSfFcCkbKsuYYacJ4fdNEBLn2Urd2w
         XnjA==
X-Forwarded-Encrypted: i=1; AJvYcCXg9SJPEt92rPlQ2UMJzmvNAHwBk0rJJ/Cwprp7If3anaohMQrzA/RnN6ei/aS6chSwAz4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzV3wlMpvV6Z2k1x0bK1lFVBqjHqUmeQiSyvx6nHC8PHJJ1UrzJ
	4ewkjKeTMOTieWrFI9bMebiBhavuiSH4r2CEnDx7L3XHAxlZ56CWzMJDrfYRvO8oQ+1sXYGUBCz
	ipeBTH511Pg==
X-Google-Smtp-Source: AGHT+IFt78ttcTKk2SPQ8BT1FrQ1uThUJelTODuNzJi0Vzk5E6Lu1cEhiJVjoBqjNinGr2mXNSf2Udc+HEafiQ==
X-Received: from pjuj6.prod.google.com ([2002:a17:90a:d006:b0:2fa:2661:76ac])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:520f:b0:308:637c:74f2 with SMTP id 98e67ed59e1d1-30a4e5bc6dbmr294105a91.17.1746124399047;
 Thu, 01 May 2025 11:33:19 -0700 (PDT)
Date: Thu,  1 May 2025 11:32:57 -0700
In-Reply-To: <20250501183304.2433192-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250501183304.2433192-1-dmatlack@google.com>
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <20250501183304.2433192-4-dmatlack@google.com>
Subject: [PATCH 03/10] KVM: selftests: Use gpa_t for GPAs in Hyper-V selftests
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	David Hildenbrand <david@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	David Matlack <dmatlack@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Eric Auger <eric.auger@redhat.com>, James Houghton <jthoughton@google.com>, 
	Colin Ian King <colin.i.king@gmail.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Fix various Hyper-V selftests to use gpa_t for variables that contain
guest physical addresses, rather than gva_t.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/x86/hyperv_evmcs.c    | 2 +-
 tools/testing/selftests/kvm/x86/hyperv_features.c | 2 +-
 tools/testing/selftests/kvm/x86/hyperv_ipi.c      | 6 +++---
 tools/testing/selftests/kvm/x86/hyperv_svm_test.c | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/hyperv_evmcs.c b/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
index 58f27dcc3d5f..9fa91b0f168a 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
@@ -76,7 +76,7 @@ void l2_guest_code(void)
 }
 
 void guest_code(struct vmx_pages *vmx_pages, struct hyperv_test_pages *hv_pages,
-		gva_t hv_hcall_page_gpa)
+		gpa_t hv_hcall_page_gpa)
 {
 #define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
diff --git a/tools/testing/selftests/kvm/x86/hyperv_features.c b/tools/testing/selftests/kvm/x86/hyperv_features.c
index 5cf19d96120d..b3847b5ea314 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_features.c
@@ -82,7 +82,7 @@ static void guest_msr(struct msr_data *msr)
 	GUEST_DONE();
 }
 
-static void guest_hcall(gva_t pgs_gpa, struct hcall_data *hcall)
+static void guest_hcall(gpa_t pgs_gpa, struct hcall_data *hcall)
 {
 	u64 res, input, output;
 	uint8_t vector;
diff --git a/tools/testing/selftests/kvm/x86/hyperv_ipi.c b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
index 865fdd8e4284..85c2948e5a79 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_ipi.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
@@ -45,13 +45,13 @@ struct hv_send_ipi_ex {
 	struct hv_vpset vp_set;
 };
 
-static inline void hv_init(gva_t pgs_gpa)
+static inline void hv_init(gpa_t pgs_gpa)
 {
 	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
 	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
 }
 
-static void receiver_code(void *hcall_page, gva_t pgs_gpa)
+static void receiver_code(void *hcall_page, gpa_t pgs_gpa)
 {
 	u32 vcpu_id;
 
@@ -85,7 +85,7 @@ static inline void nop_loop(void)
 		asm volatile("nop");
 }
 
-static void sender_guest_code(void *hcall_page, gva_t pgs_gpa)
+static void sender_guest_code(void *hcall_page, gpa_t pgs_gpa)
 {
 	struct hv_send_ipi *ipi = (struct hv_send_ipi *)hcall_page;
 	struct hv_send_ipi_ex *ipi_ex = (struct hv_send_ipi_ex *)hcall_page;
diff --git a/tools/testing/selftests/kvm/x86/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
index 436c16460fe0..b7f35424c838 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
@@ -67,7 +67,7 @@ void l2_guest_code(void)
 
 static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm,
 						    struct hyperv_test_pages *hv_pages,
-						    gva_t pgs_gpa)
+						    gpa_t pgs_gpa)
 {
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 	struct vmcb *vmcb = svm->vmcb;
-- 
2.49.0.906.g1f30a19c02-goog


