Return-Path: <kvm+bounces-57793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16280B5A409
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 23:32:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA94858256E
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 21:32:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 750962882CE;
	Tue, 16 Sep 2025 21:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TZ0QM5V+"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE70B31BCA4
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 21:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758058357; cv=none; b=vCZvoJd8d9/Xyi3XGws674IZ7WS/wUIGw/egwf7pSMpT+CREOcDUsjyRklNDH4QP+41A6+/Hypt30VL+KwsS+zcaFg3IT7IEiZtkx1OZbjwbLKwjvdXH+nlvfdKorS6wtOEVNncFWf/it0BaC1yGuyu+oz+9+It7i4iiH7M0kZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758058357; c=relaxed/simple;
	bh=Kk49ApA/Sw1WrwYfa2bmO0HYL/FPSDP1t188CDIzXfI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=isd1p57+2BBXmhKirpTq6C5IFfYu5QInUWtMyzdBRRKZ/3minF+grXsrvhUHjKTenAsZ3lF5U4YVPFwsGo0ke9/7U7mCJS11FlHdvXNut8rt5Z9qYnfxUezzMXIS8E9kMls4q0zvKnA3sNTDNth+jLa+Qoqn16P0mrquHMP8GuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TZ0QM5V+; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758058344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XfJHrhxnXCwu8VguJr9watkzFIkd93AK9ZwsyplW0KI=;
	b=TZ0QM5V+YcLbuWR4DPMKbgYjsVzUWOmjdk1Q5Eu1ZwTDT4O6scttC8O7sZc0iD7iD9Ohff
	MgP3tS+g4HHdbHZDVC8tS+uyYBNYhk5qEf/dXOincXcGhidOYJ7VNJ6Dv9aQX1SzQ6HXzV
	L+LxKeK2MStRuJNzI9cQwOOanmPeIgs=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Kirill A. Shutemov" <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-coco@lists.linux.dev
Subject: [PATCH] KVM: TDX: Replace kmalloc + copy_from_user with memdup_user in tdx_td_init
Date: Tue, 16 Sep 2025 23:31:29 +0200
Message-ID: <20250916213129.2535597-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use get_user() to retrieve the number of entries instead of allocating
memory for 'init_vm' with the maximum size, copying 'cmd->data' to it,
only to then read the actual entry count 'cpuid.nent' from the copy.

Return -E2BIG early if 'nr_user_entries' exceeds KVM_MAX_CPUID_ENTRIES.

Use memdup_user() to allocate just enough memory to fit all entries and
to copy 'cmd->data' from userspace. Use struct_size() instead of
manually calculating the number of bytes to allocate and copy.

No functional changes intended.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Compile-tested only.
---
 arch/x86/kvm/vmx/tdx.c | 32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 66744f5768c8..87510541d2a2 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2742,8 +2742,10 @@ static int tdx_read_cpuid(struct kvm_vcpu *vcpu, u32 leaf, u32 sub_leaf,
 static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct kvm_tdx_init_vm __user *user_init_vm;
 	struct kvm_tdx_init_vm *init_vm;
 	struct td_params *td_params = NULL;
+	u32 nr_user_entries;
 	int ret;
 
 	BUILD_BUG_ON(sizeof(*init_vm) != 256 + sizeof_field(struct kvm_tdx_init_vm, cpuid));
@@ -2755,28 +2757,18 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	if (cmd->flags)
 		return -EINVAL;
 
-	init_vm = kmalloc(sizeof(*init_vm) +
-			  sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
-			  GFP_KERNEL);
-	if (!init_vm)
-		return -ENOMEM;
-
-	if (copy_from_user(init_vm, u64_to_user_ptr(cmd->data), sizeof(*init_vm))) {
-		ret = -EFAULT;
-		goto out;
-	}
+	user_init_vm = u64_to_user_ptr(cmd->data);
+	ret = get_user(nr_user_entries, &user_init_vm->cpuid.nent);
+	if (ret)
+		return ret;
 
-	if (init_vm->cpuid.nent > KVM_MAX_CPUID_ENTRIES) {
-		ret = -E2BIG;
-		goto out;
-	}
+	if (nr_user_entries > KVM_MAX_CPUID_ENTRIES)
+		return -E2BIG;
 
-	if (copy_from_user(init_vm->cpuid.entries,
-			   u64_to_user_ptr(cmd->data) + sizeof(*init_vm),
-			   flex_array_size(init_vm, cpuid.entries, init_vm->cpuid.nent))) {
-		ret = -EFAULT;
-		goto out;
-	}
+	init_vm = memdup_user(user_init_vm,
+			      struct_size(user_init_vm, cpuid.entries, nr_user_entries));
+	if (IS_ERR(init_vm))
+		return PTR_ERR(init_vm);
 
 	if (memchr_inv(init_vm->reserved, 0, sizeof(init_vm->reserved))) {
 		ret = -EINVAL;
-- 
2.51.0


