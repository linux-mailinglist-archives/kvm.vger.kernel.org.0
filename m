Return-Path: <kvm+bounces-54300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D72BEB1DE2D
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 22:24:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C759517C0DB
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 20:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A1E4273D74;
	Thu,  7 Aug 2025 20:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FCepqIPc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2664283FD4
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 20:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754597846; cv=none; b=LVyQG7Qgw9TEoMC3KvEVctN/kUXr99LXJetByMZjhgpo3y+rLFVSg7AwAr8gF8v86EjlRpUEUN7CSngACCKMDv2niXKCr3+l3UyoOvg3bsX9Vrjkt4kXxURfYO+f85rcGmZhVpJ9nnnnZTYwmYKsNPiDwFINENFihGUUqZbKkY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754597846; c=relaxed/simple;
	bh=KtQGB5hdsruK0bKKPNTRCRaeujSBA7S7BYfY9UZQvic=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TXhJF2mIY2trC40/AayanwfzIIQLDmoQ8BGGdLrJzLHN5VLM7jX3jblG94wsdHEtwaqWGcqkpk5IQ9+wv5esdtBYVjx85/f8hYrPI7/hXSQRiRqIe1BgeWGHFGBdlDn73ndUDwbY16ZiamhC6FpXjkoETFlyYdoHjAxi2wBIqUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FCepqIPc; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32147620790so1481944a91.1
        for <kvm@vger.kernel.org>; Thu, 07 Aug 2025 13:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754597843; x=1755202643; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M0suFohlUZGBEGCM79JG64gwQy4zWTa1/ANBR7d4wLU=;
        b=FCepqIPcGNmF3uU3qppEbg4klpL8ohYpCI1WJO/JX2W5YiHg7CM96fsTWjUj0VfaKQ
         I9K2XLSIReZn3cvb/0EIFUewrAavZmZR3RYWJiKnUVtNoj8J6b+M36TLgy3VM5Wyqvn6
         WHdYfwOqh3GnIcHDrxhJNDW4N+J9kjPNzlN7dQV23lc0UuISzMsEFDrG2TjYiDxyfcMC
         MrJ/2T+WGxJ4xNdUjsTR5gr/05VFtUqHtMhXmnpK+I/GA/nAjFAk4tRtg3QZTjB/QbOI
         c8KseObeJjLsp+PmLOncrQ8q4n6T3n1lzbk+yfFTjnR/7QLjUQrhGpCX8yrkN4fhXOXV
         7Ggg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754597843; x=1755202643;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M0suFohlUZGBEGCM79JG64gwQy4zWTa1/ANBR7d4wLU=;
        b=qpkih7Gs9dLFKleVRnvUybiS4OuZfUkHQWTk99tYNL3vlwoTAap5kL7Cu9baHX1D5y
         /Eu/1KvLhcLtWdTbUr9RpsJ1vL8bISLZmsr+O0A4l9vdQu95MkkGfhMtbxy9Pg5pZwVH
         Z7phwZ8qvjFDvCtJ/KfdiuwxPLV1WktzWNaJi2pzskPqTEBC/kHmb4dNtb7AziiRFCMW
         gop+9DADuS3CchUi44u1Ui5UG29HTr8fuPGXngGsDj8JDIJDiiyh4OkooIPkYPPnsUHU
         coMe1Y50jsrXAYu2vaEya5Ac4XLVZ40Ng2sil6iD6wK6svHjZwvMDpiayBYXyY+oJqXR
         y34Q==
X-Forwarded-Encrypted: i=1; AJvYcCX5Gre8Hud7sByxANKomTP9qglmKXFKo/xkJSbg6OMFXIgnKApOdkgINQG7lAf9WCl3pKs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWtxmacLuS/bdlAq79X9cdZpPl21PXKxtXT/7VyGSxrnzZOzUL
	/nTZMWzG7AA7S2vdhaU1m1f7FeQAFMutnMYVn5LyARwz00S3LLxCv3ptnIZIpAo9VcOBJdEFKTY
	MJg==
X-Google-Smtp-Source: AGHT+IGuwnBgHT00Pa47b7PWARfkX6jqZRvjGaZTcLQlg02HegQiirvTj6AbnOkdTgp8ehpde97Ui17D4A==
X-Received: from pjv4.prod.google.com ([2002:a17:90b:5644:b0:313:245:8921])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:28c5:b0:31a:ab75:6e45
 with SMTP id 98e67ed59e1d1-32183c42d6dmr441878a91.28.1754597843391; Thu, 07
 Aug 2025 13:17:23 -0700 (PDT)
Date: Thu,  7 Aug 2025 13:16:26 -0700
In-Reply-To: <20250807201628.1185915-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250807201628.1185915-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250807201628.1185915-31-sagis@google.com>
Subject: [PATCH v8 30/30] KVM: selftests: TDX: Test LOG_DIRTY_PAGES flag to a
 non-GUEST_MEMFD memslot
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Yan Zhao <yan.y.zhao@intel.com>

Add a selftest to verify that adding flag KVM_MEM_LOG_DIRTY_PAGES to a
!KVM_MEM_GUEST_MEMFD memslot does not produce host errors in TDX.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/x86/tdx_vm_test.c | 45 ++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86/tdx_vm_test.c b/tools/testing/selftests/kvm/x86/tdx_vm_test.c
index 82acc17a66ab..410d814dd39a 100644
--- a/tools/testing/selftests/kvm/x86/tdx_vm_test.c
+++ b/tools/testing/selftests/kvm/x86/tdx_vm_test.c
@@ -1167,6 +1167,47 @@ void verify_tdcall_vp_info(void)
 	printf("\t ... PASSED\n");
 }
 
+#define TDX_LOG_DIRTY_PAGES_FLAG_TEST_GPA (0xc0000000)
+#define TDX_LOG_DIRTY_PAGES_FLAG_TEST_GVA_SHARED (0x90000000)
+#define TDX_LOG_DIRTY_PAGES_FLAG_REGION_SLOT 10
+#define TDX_LOG_DIRTY_PAGES_FLAG_REGION_NR_PAGES (0x1000 / getpagesize())
+
+void guest_code_log_dirty_flag(void)
+{
+	memset((void *)TDX_LOG_DIRTY_PAGES_FLAG_TEST_GVA_SHARED, 1, 8);
+	tdx_test_success();
+}
+
+/*
+ * Verify adding flag KVM_MEM_LOG_DIRTY_PAGES to a !KVM_MEM_GUEST_MEMFD memslot
+ * in a TD does not produce host errors.
+ */
+void verify_log_dirty_pages_flag_on_non_gmemfd_slot(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = td_create();
+	td_initialize(vm, VM_MEM_SRC_ANONYMOUS, 0);
+	vcpu = td_vcpu_add(vm, 0, guest_code_log_dirty_flag);
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    TDX_LOG_DIRTY_PAGES_FLAG_TEST_GPA,
+				    TDX_LOG_DIRTY_PAGES_FLAG_REGION_SLOT,
+				    TDX_LOG_DIRTY_PAGES_FLAG_REGION_NR_PAGES,
+				    KVM_MEM_LOG_DIRTY_PAGES);
+	virt_map_shared(vm, TDX_LOG_DIRTY_PAGES_FLAG_TEST_GVA_SHARED,
+			(uint64_t)TDX_LOG_DIRTY_PAGES_FLAG_TEST_GPA,
+			TDX_LOG_DIRTY_PAGES_FLAG_REGION_NR_PAGES);
+	td_finalize(vm);
+
+	printf("Verifying Log dirty flag:\n");
+	vcpu_run(vcpu);
+	tdx_test_assert_success(vcpu);
+	kvm_vm_free(vm);
+	printf("\t ... PASSED\n");
+}
+
 int main(int argc, char **argv)
 {
 	ksft_print_header();
@@ -1174,7 +1215,7 @@ int main(int argc, char **argv)
 	if (!is_tdx_enabled())
 		ksft_exit_skip("TDX is not supported by the KVM. Exiting.\n");
 
-	ksft_set_plan(15);
+	ksft_set_plan(16);
 	ksft_test_result(!run_in_new_process(&verify_td_lifecycle),
 			 "verify_td_lifecycle\n");
 	ksft_test_result(!run_in_new_process(&verify_report_fatal_error),
@@ -1205,6 +1246,8 @@ int main(int argc, char **argv)
 			 "verify_host_reading_private_mem\n");
 	ksft_test_result(!run_in_new_process(&verify_tdcall_vp_info),
 			 "verify_tdcall_vp_info\n");
+	ksft_test_result(!run_in_new_process(&verify_log_dirty_pages_flag_on_non_gmemfd_slot),
+			 "verify_log_dirty_pages_flag_on_non_gmemfd_slot\n");
 
 	ksft_finished();
 	return 0;
-- 
2.51.0.rc0.155.g4a0f42376b-goog


