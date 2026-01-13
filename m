Return-Path: <kvm+bounces-67930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 30BDFD189DE
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 13:02:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3061C3008C48
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 12:02:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8EB738F223;
	Tue, 13 Jan 2026 12:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="ABd7W1HJ"
X-Original-To: kvm@vger.kernel.org
Received: from out28-123.mail.aliyun.com (out28-123.mail.aliyun.com [115.124.28.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7EC2FC876;
	Tue, 13 Jan 2026 12:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768305759; cv=none; b=iggLbpFfxybhi188XLHYPudjCo+kf4Trh+ezTRkSIgrJzHj1+saSGFlITjjnmQacjgtNWmy/g1RxlDgheEYgciB25gJJpeCfaggMJ+VPqNfdpWq0vs/YUKvkxAN9HLqUC/2UXEjNwOnjdv1OUYt/Q/S6BBh37zobaohN59fbGdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768305759; c=relaxed/simple;
	bh=liGCF5XL/Z+gRTRIuzDIGEE2qfzpzjujRT5RyoBpgzY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=J68QNkVrSceQ6YX48ZnxGM4K2uoGYl4BaNDz4MK0xP4ic0X2rYm60kW3XbtywbtZ1d6Fd7AQlVNM6tUdbfrAjDgQCSGDuYPFImkDGNDaVi3QJ5vwp8mt/oWIjrgTl0obRhNfhtZzxASRGLeXlO1tK07Y441mcYrZ8JHrR0lyb8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=ABd7W1HJ; arc=none smtp.client-ip=115.124.28.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1768305748; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=ZhUvNgEHaZP6ZDzht3OPJleePfuESKAnVaa2eCNHGaI=;
	b=ABd7W1HJnLW/upLtZ4UlLrSYDuL7mD8U9BhdZFJFrHl2zGh6zN6rNUKDfNKiyQ9cgatOx5y0IXuVUeBityQPZHkK+0FGkIqrtWqjaet890fpzmTHW7vbPwxGaOgbiErXshkKm5yw0iaf2Q5FErtCeejbKgDcfrthKCSXpIby2Ig=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.g5Y-hDa_1768305426 cluster:ay29)
          by smtp.aliyun-inc.com;
          Tue, 13 Jan 2026 19:57:07 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: VMX: Don't register posted interrupt wakeup handler if alloc_kvm_area() fails
Date: Tue, 13 Jan 2026 19:56:50 +0800
Message-Id: <0ac6908b608cf80eab7437004334fedd0f5f5317.1768304590.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Unregistering the posted interrupt wakeup handler only happens during
hardware unsetup. Therefore, if alloc_kvm_area() fails and continue to
register the posted interrupt wakeup handler, this will leave the global
posted interrupt wakeup handler pointer in an incorrect state. Although
it should not be an issue, it's still better to change it.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9b92f672ccfe..676f32aa72bb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8829,8 +8829,11 @@ __init int vmx_hardware_setup(void)
 	}
 
 	r = alloc_kvm_area();
-	if (r && nested)
-		nested_vmx_hardware_unsetup();
+	if (r) {
+		if (nested)
+			nested_vmx_hardware_unsetup();
+		return r;
+	}
 
 	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
 

base-commit: f62b64b970570c92fe22503b0cdc65be7ce7fc7c
-- 
2.31.1


