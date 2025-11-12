Return-Path: <kvm+bounces-62901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A58FC53A32
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 18:20:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id F01F2346F70
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 17:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3506346A16;
	Wed, 12 Nov 2025 17:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VrPWNinj"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DF4346787
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 17:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762967812; cv=none; b=CeulOq3JLv2ceP1Wv9PfqTTrQzSHaQfgiowJ+MlbrnRNJ7FGP420BaHl0uw1msOZZDIEmwekoSRWHCk4+/kTicZCA297A4kvY3T9fGGG8y0DrHe+3yPvkDSD1r2iWaB2SI9DRMDJHv/JshCCyjAjnP7X3/BfBILonPJ+b89IcQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762967812; c=relaxed/simple;
	bh=+7m4xZA64frkoZpYTIp4oVaRqCNkEaWjXxWByElWYhk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nkz7Aierl7x5tm6YBJvqTbHa+MP4PN8Ti1WbhtbFzhwzcrqYBrh93o+hMccrqOK8bZaXpVuOdUoFRDyvhplm6aJMefjXfncnBkuUcrB2JrqGjbbRrj/+7rR/5b95HHZ+1l4a4NpmDUmcWb1oMlEJqpIlMEePfsRPS+aS7rFuvyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VrPWNinj; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762967798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dOR6g1F2BDK3nYzApHZ5sQ5z1U7yn9CBpAv3iTkq2zc=;
	b=VrPWNinjH0kJgpbSuCbQykwCl0PcRSIrwWRSUiRsk9v2mBmkx4eWHGAa5uj4Q1zToFsr34
	Qx8FAbjfp8w+JT4cXhjOVc5Enk5UziGJThJu7qLtFIG7+Ijnzlqv0UbplCOM8csGWOnENh
	qID5GHm3W5N0YDSy0vPrbvJsU/DLbwE=
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
Subject: [PATCH RESEND] KVM: TDX: Use struct_size and simplify tdx_get_capabilities
Date: Wed, 12 Nov 2025 18:16:30 +0100
Message-ID: <20251112171630.3375-1-thorsten.blum@linux.dev>
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
2.51.1


