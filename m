Return-Path: <kvm+bounces-60400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ABD4CBEBD42
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 23:40:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51B2F1AE16A4
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 21:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 049F32C029E;
	Fri, 17 Oct 2025 21:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fzLZ7AIS"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B6D2036E9
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 21:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760737224; cv=none; b=rk9bJw86calAWtXKEiicZhX7F9KhmyS8vLXMPaw6i7PCK1IIhj+7cJ60L7fAD8bjy1WU3j+qbNYaP0zwLnx9VXWEqWnC+T+hmVQePfh4+A4UHh2Hnl15/6zd/hdwBJSLvwStdpX2hImjSGCpI4vTEQIFK6WyXRMCP0P0ttk6Fgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760737224; c=relaxed/simple;
	bh=xec44dz02vCzqSvijFwW8T2pHLkXyzKFGftXYWemhVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rr9OKRsbTfDEcEKlhc8Qm6NheoUkvt1agW86GOgDnlxvKyIboP5EkuzOcHi20AW+OhHDncUGz4VYw6ATdqY/2V2uyFuMILJliP/ZDVhTR7DUCxM0EvbX6cLU6aJL+PMvlKLX425+BFeiPYrAaZxGHjK8OSWTu1bSvrTJ0bSCYME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fzLZ7AIS; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760737209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hqHjkEGF/llF28r0KVHF88JX9zjukAmNil/u6FvmQxs=;
	b=fzLZ7AISgoCCLOzUnu8Ze+zJBMVwV4g50CzFM0nk2VGdJYWih62y9aeUZInyTEYO+WKK28
	lgsks1RFgkRvY7BkniSUbQkpo/JwXM/49dNmuJiABrl511+ZL/Pje5qSVYC5motBTNpCAy
	dbq0I46MOCfHUeGpCj0mNJx/pHGWm5k=
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
Subject: [PATCH] KVM: TDX: Use struct_size and simplify tdx_get_capabilities
Date: Fri, 17 Oct 2025 23:39:14 +0200
Message-ID: <20251017213914.167301-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Retrieve the number of user entries with get_user() first and return
-E2BIG early if 'user_caps' is too small to fit 'caps'.

Allocate memory for 'caps' only after checking the user buffer's number
of entries, thus removing two gotos and the need for premature freeing.

Use struct_size() instead of manually calculating the number of bytes to
allocate for 'caps', including the nested flexible array.

Finally, copy 'caps' to user space with a single copy_to_user() call.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Compile-tested only.
---
 arch/x86/kvm/vmx/tdx.c | 32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0a49c863c811..23d638b4a003 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2282,37 +2282,29 @@ static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 	if (cmd->flags)
 		return -EINVAL;
 
-	caps = kzalloc(sizeof(*caps) +
-		       sizeof(struct kvm_cpuid_entry2) * td_conf->num_cpuid_config,
-		       GFP_KERNEL);
-	if (!caps)
-		return -ENOMEM;
-
 	user_caps = u64_to_user_ptr(cmd->data);
-	if (get_user(nr_user_entries, &user_caps->cpuid.nent)) {
-		ret = -EFAULT;
-		goto out;
-	}
+	ret = get_user(nr_user_entries, &user_caps->cpuid.nent);
+	if (ret)
+		return ret;
 
-	if (nr_user_entries < td_conf->num_cpuid_config) {
-		ret = -E2BIG;
-		goto out;
-	}
+	if (nr_user_entries < td_conf->num_cpuid_config)
+		return -E2BIG;
+
+	caps = kzalloc(struct_size(caps, cpuid.entries,
+				   td_conf->num_cpuid_config), GFP_KERNEL);
+	if (!caps)
+		return -ENOMEM;
 
 	ret = init_kvm_tdx_caps(td_conf, caps);
 	if (ret)
 		goto out;
 
-	if (copy_to_user(user_caps, caps, sizeof(*caps))) {
+	if (copy_to_user(user_caps, caps, struct_size(caps, cpuid.entries,
+						      caps->cpuid.nent))) {
 		ret = -EFAULT;
 		goto out;
 	}
 
-	if (copy_to_user(user_caps->cpuid.entries, caps->cpuid.entries,
-			 caps->cpuid.nent *
-			 sizeof(caps->cpuid.entries[0])))
-		ret = -EFAULT;
-
 out:
 	/* kfree() accepts NULL. */
 	kfree(caps);
-- 
2.51.0


