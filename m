Return-Path: <kvm+bounces-67814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E6B91D147AC
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:47:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D10ED3072EAE
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:45:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA39D37F0EC;
	Mon, 12 Jan 2026 17:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T086ZGJv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AF1222582
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239944; cv=none; b=W7l1n5kZnXKjrtCMq7UvBQ26WgSSWAq2bQLRNuIgUu4HCENy2FVW/DqMlIbrtPLUpsrgawBNp+mZOBjWKv8uxhF1eVbCpYUBJ3Kf8evnRDRW+yrL0Bh/Xy0lkIGzOi2Y+qypMx/8OX92U7ch4L633qbq/88YAvXwnv4dte382zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239944; c=relaxed/simple;
	bh=xOfnG1aBwlhT5ExIDBvUxP1adasmDNOg8TXmPnKqN3M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XT6hrHJ8c+JmrenPfY7zuoxiNTNuDV5TjUd8lq1v66wQBeWLBBjRSiUoTmRUJJ32IeJDqzOLay5+V7TN1ZCopte/QvXvvjkW5+JcCWkTyWvnQyR4HEAzt2YQvHyG2QjK0Lf892MXLnH36OalI9VW9GR8JzNLR8zh6EfckVc6tHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T086ZGJv; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a13cd9a784so59250545ad.2
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768239943; x=1768844743; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rLF7+g6UyQ0gURmpyXTkkRtZXO4GkddyPwktknZG6Vc=;
        b=T086ZGJvJz5Y57E7Z18iAZDvsE4vDiEJRJ2MqCu2dwGJSTIPzuu+5cIOZUp+6TCCvj
         ypgYa4nnhGvBf7Rm2N1fx9uWOnZI7XGgPxdMXVGKMiJAhMHoNammOUPNY/G9OLFOXFhE
         Su7cz0NMImPmoq2pR3x0GAvde26D3eHvdDOh2ah4QOuPRMGoI+FmoZEyoFMwdG6yzic1
         2XhA2vHAHWULKvtdKNh3l5uKVhD1hnYTY9difJzUckigSuVi/vaVjQd1JnR+lZDkHumJ
         U0Ptsiq8BJhx72Y5s5PckfPyNbtieUM72oAtiMaLzTJsii4QejD69xxPiVlnTeW6qGgn
         P79w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239943; x=1768844743;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rLF7+g6UyQ0gURmpyXTkkRtZXO4GkddyPwktknZG6Vc=;
        b=OQzDV1w93DLW07S1PTMhh3PfF2kzKf3H8+wO3QcBILEqcAK4DJIhBs9RsW6vXf1DSG
         O09Rs9VWIpLC9K/ARksTvlF2oHn1P80kKfLsfAaaEbyCtgulcAb2kN+qrIJ6dOJJQvI0
         n6ZpScf/qVp3JRncUeBPhbXKYaC2yJHOcjiIUvVaJt/m2NtZM+ag7WU0xJGxqL1/Atpt
         iDsFD6JjINkHpbWGc4uRcMTDaURDr+LcXUivFMoBYG2u9zuDTGk0yxUxeIUf6wHXkchk
         z3/kAg5OeBSsISQ5O1TZ3cgME69ITzDJtY1AJMLyqn1725R00aSYXYuZrnLfqVIrf6rp
         YdSA==
X-Gm-Message-State: AOJu0YxuhGDh3E7mXR3cd59oiSERSM4UYSrcVFbe8MEZu5u08g9dKKr1
	fMp/OzUwGVR0EifnFCVZp0C+CXKSzbVQ2Q9L4iJYOIK0T0gszfxGzD9mzzg81MxKKR92DPCSGmh
	mW3OvvxhT4375/w==
X-Google-Smtp-Source: AGHT+IECpF2HOzw9JzJsl2F3AC//WA83P5kTDpeU+O0IZ03XbMpGylx8rPOwlMtlxdgLjmySu9Ft3ZRHV1wpEg==
X-Received: from plch11.prod.google.com ([2002:a17:902:f2cb:b0:29f:1c3a:7fed])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1108:b0:29e:e925:1aa0 with SMTP id d9443c01a7336-2a3ee4a8758mr152795175ad.45.1768239942693;
 Mon, 12 Jan 2026 09:45:42 -0800 (PST)
Date: Mon, 12 Jan 2026 17:45:32 +0000
In-Reply-To: <20260112174535.3132800-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260112174535.3132800-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260112174535.3132800-3-chengkev@google.com>
Subject: [PATCH V2 2/5] KVM: SVM: Inject #UD for STGI if EFER.SVME=0 and SVM
 Lock and DEV are not available
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

The AMD APM states that STGI causes a #UD if SVM is not enabled and
neither SVM Lock nor the device exclusion vector (DEV) are supported.
Fix the STGI exit handler by injecting #UD when these conditions are
met.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 arch/x86/kvm/svm/svm.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6373a25d85479..557c84a060fc6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2271,8 +2271,18 @@ static int stgi_interception(struct kvm_vcpu *vcpu)
 {
 	int ret;
 
-	if (nested_svm_check_permissions(vcpu))
+	if ((!(vcpu->arch.efer & EFER_SVME) &&
+	     !guest_cpu_cap_has(vcpu, X86_FEATURE_SVML) &&
+	     !guest_cpu_cap_has(vcpu, X86_FEATURE_SKINIT)) ||
+	    !is_paging(vcpu)) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return 1;
+	}
+
+	if (to_svm(vcpu)->vmcb->save.cpl) {
+		kvm_inject_gp(vcpu, 0);
 		return 1;
+	}
 
 	ret = kvm_skip_emulated_instruction(vcpu);
 	svm_set_gif(to_svm(vcpu), true);
-- 
2.52.0.457.g6b5491de43-goog


