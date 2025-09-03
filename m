Return-Path: <kvm+bounces-56651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6292EB41154
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 02:30:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DD7C5E7C82
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 00:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A27E845948;
	Wed,  3 Sep 2025 00:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kmLSNv31"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4261E4AB
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 00:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756859420; cv=none; b=DAnWZxOuv389Cbx6i91MC9Ogt+YBn44HpYVwE5pEir8ZzNZkspe7i/dSw09lJECZibFmDXCqqn7PEoQ9ygVefa4O48RA4kwc7p1x09Zq9JxhZ1i8mdit+xZ4R0gbxSGwwI4+QgcbcDB2sQpvD7Ir3iRXmdqzQCmA+a9AltMpJm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756859420; c=relaxed/simple;
	bh=avxoggIy7iNMq1V9YTUJVFJ2AwIXBC8XWfTRiq0XybI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KMZ/wfinL0Bp+nWQHBdnIRpIEV6wnZ+JNwhC7zbbpL1bNrgm175GjxLqrUwioEtsDjEYmRQ61QcpXFwePUlvYmG66A+yaw+dwDwWQM3re58/CAtswzxArkV5vIOYbBxOBQ/9OT7oi2V4sFhVXi/B1fjcRKJj0gK/GXlU1vgTy4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kmLSNv31; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756859414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oATve04/PpCSXjt9BZQOkk2Qc8tlxwWxSK5sGt1qgbY=;
	b=kmLSNv31AHeFXz4x//T4DbkgO+0bwAqi0uieRQ4eRXYRhIjH53r/biqthzW7KuMQeSDntt
	xusOfsKlLb8wrFH5dftIh+JA+8imUMGm6VysmuXVdG+gyUlTeX1L6VaWNuyC52Z+MHmAq9
	UzRbUuMnhFQ9hdnvD+Yv9J7Cg/SEdhk=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: SVM: Replace kzalloc() + copy_from_user() with memdup_user()
Date: Wed,  3 Sep 2025 02:29:50 +0200
Message-ID: <20250903002951.118912-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace kzalloc() followed by copy_from_user() with memdup_user() to
improve and simplify svm_set_nested_state().

Return early if an error occurs instead of trying to allocate memory for
'save' when memory allocation for 'ctl' already failed.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b7fd2e869998..826473f2d7c7 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1798,17 +1798,15 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (kvm_state->size < sizeof(*kvm_state) + KVM_STATE_NESTED_SVM_VMCB_SIZE)
 		return -EINVAL;
 
-	ret  = -ENOMEM;
-	ctl  = kzalloc(sizeof(*ctl),  GFP_KERNEL);
-	save = kzalloc(sizeof(*save), GFP_KERNEL);
-	if (!ctl || !save)
-		goto out_free;
-
-	ret = -EFAULT;
-	if (copy_from_user(ctl, &user_vmcb->control, sizeof(*ctl)))
-		goto out_free;
-	if (copy_from_user(save, &user_vmcb->save, sizeof(*save)))
-		goto out_free;
+	ctl = memdup_user(&user_vmcb->control, sizeof(*ctl));
+	if (IS_ERR(ctl))
+		return PTR_ERR(ctl);
+
+	save = memdup_user(&user_vmcb->save, sizeof(*save));
+	if (IS_ERR(save)) {
+		kfree(ctl);
+		return PTR_ERR(save);
+	}
 
 	ret = -EINVAL;
 	__nested_copy_vmcb_control_to_cache(vcpu, &ctl_cached, ctl);
-- 
2.51.0


