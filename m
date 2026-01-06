Return-Path: <kvm+bounces-67092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D693CCF6A57
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 05:13:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3D1D230533BA
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 04:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0167C27C84B;
	Tue,  6 Jan 2026 04:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aOZcHvYB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B136627A91D
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 04:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767672779; cv=none; b=YBihqzudIWJUxhMfTbARH1bEtuFGbpT5U/dMzieNvBgSQDf8UqqVVBJjjuM2KkRVk+7kjR6VA50oW5NjQEJAKf4TzAtXO51Kz09GHFn0UWf5dibIUiWGbxg5acaQZKaBdZis6v37o/K/2L7xax/76n2EuiKdnSAkTVKSTxRSvqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767672779; c=relaxed/simple;
	bh=eqO0Kv1lG1xRa9+VK2X+u56SGUxTKyJ5KAP+w6M5lfI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V2n0DLVtlWu1OvKjcsGPM3tHabCMygKnO2/2ZswbnIdK18Qp+ANG97DNQAkazCrBgt8BonZQ5yaTCRkQ5owmZy1kxFh2Ipzm6JqtG/uhNORLiAhVHcSYdhgvdWbdman2eOcGsaCQKe6g3VSW1B09+tkk9BV7qShA1M4ARh6vVds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aOZcHvYB; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b8a12f0cb4so729019b3a.3
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 20:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767672777; x=1768277577; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wKBhf00uvhMJ8An/gEVWZfQB7n6tOLhql0zNS2GTY5o=;
        b=aOZcHvYBIMG1GWF6ic67G0P6pQ5qIu0P+xKVM6GmQilRETZZSbmt+NqIZ5li0bsXyy
         xzENTsNim83sxkS+bqLfMJNdI8Bs0R32xm6Bh5xl3JiaYlZ7ZzjVA8IFlfKrYgLH5VGK
         Ua+1DvUdBO0QZe381hYMfxMO19WRxQQwdkvOBtxpMhZ/j6vvw2Ws6qzYRgLU5DVfrDMm
         UI8qyLtlybVdeHBs1SBB+U4SnOXXWq36P4cdQig78qa0UnRhG3hENQt9cq1cuxnG2tgH
         Gq+jBrsuCVfrkf+DOz/JvWdn7ZVqUT+vGvocEvRORtWPqK8HCPWBT5Ohd6xxyobJY/ty
         HAYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767672777; x=1768277577;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wKBhf00uvhMJ8An/gEVWZfQB7n6tOLhql0zNS2GTY5o=;
        b=mMrCiO2Bqhog9hAl7PW3DwHeUW5E2fAR2s6bEjhqZ+ZPF1opkMBcB8bubXFqZFqRWj
         gltFTO2QEPK4zIu9zA7ByCdNedk3PI0zy/bcs/Lw3yTdwIWBK5T2zvAEmAU7fnh0g/o4
         r0aU3TWLXVB8fZs7l+ut/kWnArAjc9qAOlNZhZFZ0NYqleg5QJdJjeks0lsxRmn/+Fc8
         iQtcVoHLa/dfQv2ujAaglQ9+f/a9Atf4Dt0UIxphmZY4g8wEOBI9BQt5MqABfzagEl+n
         7az9uBMHAfcLM2ILYbFQAiinCbGffY16GaQaPA7BS2wpMSTvwNmYaWPGJRLLkvepKdgw
         FWeg==
X-Gm-Message-State: AOJu0Yy2SN2Ti0YQSVvXJpSI7drRTgcofWYFUS/RuQgyiT4wdFsPKhMk
	0aBPz6eRtmJHA6gYxQ83fxIzIogVViQISh5aGY9qYdXXHmwvED3RWXGBrbPr28uqtoRKxPV/D8k
	22gD//tZxngp6ag==
X-Google-Smtp-Source: AGHT+IFe1v5OweSURGlODjjRkxwXogBauJupRDxtS61iYfJHSZPVQ2UqrIx7M5W8Kpfl3LbGkFjbDfPyphhSVQ==
X-Received: from pgg7.prod.google.com ([2002:a05:6a02:4d87:b0:c0d:def8:3a1b])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:394a:b0:35d:ce99:cc23 with SMTP id adf61e73a8af0-389823c75f4mr1306938637.49.1767672777086;
 Mon, 05 Jan 2026 20:12:57 -0800 (PST)
Date: Tue,  6 Jan 2026 04:12:49 +0000
In-Reply-To: <20260106041250.2125920-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106041250.2125920-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260106041250.2125920-2-chengkev@google.com>
Subject: [PATCH 1/2] KVM: SVM: Generate #UD for certain instructions when
 SVME.EFER is disabled
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

The AMD APM states that VMRUN, VMLOAD, VMSAVE, CLGI, VMMCALL, and
INVLPGA instructions should generate a #UD when EFER.SVME is cleared.
Currently, when VMLOAD, VMSAVE, or CLGI are executed in L1 with
EFER.SVME cleared, no #UD is generated in certain cases. This is because
the intercepts for these instructions are cleared based on whether or
not vls or vgif is enabled. The #UD fails to be generated when the
intercepts are absent.

INVLPGA is always intercepted, but there is no call to
nested_svm_check_permissions() which is responsible for checking
EFER.SVME and queuing the #UD exception.

Fix the missing #UD generation by ensuring that all relevant
instructions have intercepts set when SVME.EFER is disabled and that the
exit handlers contain the necessary checks.

VMMCALL is special because KVM's ABI is that VMCALL/VMMCALL are always
supported for L1 and never fault.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 arch/x86/kvm/svm/svm.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 24d59ccfa40d9..fc1b8707bb00c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -228,6 +228,14 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 			if (!is_smm(vcpu))
 				svm_free_nested(svm);
 
+			/*
+			 * If EFER.SVME is being cleared, we must intercept these
+			 * instructions to ensure #UD is generated.
+			 */
+			svm_set_intercept(svm, INTERCEPT_CLGI);
+			svm_set_intercept(svm, INTERCEPT_VMSAVE);
+			svm_set_intercept(svm, INTERCEPT_VMLOAD);
+			svm->vmcb->control.virt_ext &= ~VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 		} else {
 			int ret = svm_allocate_nested(svm);
 
@@ -242,6 +250,15 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 			 */
 			if (svm_gp_erratum_intercept && !sev_guest(vcpu->kvm))
 				set_exception_intercept(svm, GP_VECTOR);
+
+			if (vgif)
+				svm_clr_intercept(svm, INTERCEPT_CLGI);
+
+			if (vls) {
+				svm_clr_intercept(svm, INTERCEPT_VMSAVE);
+				svm_clr_intercept(svm, INTERCEPT_VMLOAD);
+				svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+			}
 		}
 	}
 
@@ -2291,8 +2308,14 @@ static int clgi_interception(struct kvm_vcpu *vcpu)
 
 static int invlpga_interception(struct kvm_vcpu *vcpu)
 {
-	gva_t gva = kvm_rax_read(vcpu);
-	u32 asid = kvm_rcx_read(vcpu);
+	gva_t gva;
+	u32 asid;
+
+	if (nested_svm_check_permissions(vcpu))
+		return 1;
+
+	gva = kvm_rax_read(vcpu);
+	asid = kvm_rcx_read(vcpu);
 
 	/* FIXME: Handle an address size prefix. */
 	if (!is_long_mode(vcpu))
-- 
2.52.0.351.gbe84eed79e-goog


