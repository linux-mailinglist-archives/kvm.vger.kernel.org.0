Return-Path: <kvm+bounces-55407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DCC6B30881
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 23:39:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 022016237A7
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 21:38:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE2962D7DCA;
	Thu, 21 Aug 2025 21:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZVWFsfya"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712B4393DC7
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 21:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755812325; cv=none; b=i4BAac+5sotz7T93IrXO9HLUfrrbDOFCE8sKZJXl7XyviQJ9xkEFYttVw9fy85OnuER2E8TkUXBLIim6Nrhf1nb1Y/kLFlerKVxSK4rxuedzI9LjerU3CyrC1LlvazOPlyNbcbdcXv6ReV8dNaefleRFfCVSGtE4YOdPMa8+zN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755812325; c=relaxed/simple;
	bh=9IigR4Wlagg6xhLm9hN1vALyc5QXNqvJf+sepyZxpOU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=c/Bj/uVRh+FdYH9gFYsiV9tDKM6b+7mexfyvR0USHQALgkYV07iiluyu/n2g4fDyyp1L5+HgLHH37CSTLNXq0X8nPEATbsAjHu3hYmwNc8YTQnyYKWhgrQcY+hRoLCGlp6yXJhIHd1DkssvdAuoEYJRCQz5i+2jqzc2+/E7y2CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZVWFsfya; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b474d5ff588so1119928a12.2
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 14:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755812324; x=1756417124; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vHVEfAKtxAdzAcGw4A2fKIX4sGvGDOZHuTt9dFxqKbs=;
        b=ZVWFsfyap49n437Lwfl51JA0FjQlKlC7qi5cHbds5Anq6kcHmvlRP27Yki/ix2upuJ
         20WYGXhRQi1UrpAyVFQqv/SeV06+wR1aMT+9YRz+/5P9Y3fQrO0M2+8R+VxL5lAs+typ
         6bqZJg8vKtS94WO/d7rrNlDc0VRLjCE4nktOUOhF/WvC7KJUqpGP9BzuXOR95h7UEXpw
         kWkbr4wTRC71IhZZp7glR9+nSiML8h1c8aA4gIm4JaE5licjU0ywdwvb2CymAFJEKCo4
         aIZ4smPlBSF7IJdiV/t1nKUKqFYfsVAXlMXyBDh1A61p+hlrUVEVK70OxtRlwKqReaQg
         12bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755812324; x=1756417124;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vHVEfAKtxAdzAcGw4A2fKIX4sGvGDOZHuTt9dFxqKbs=;
        b=Zohph9AjGygAQa7tkXw479YG04kqfJK8wfs7VQU4n7vXVhgtkIvlXL02LGS9g+PUH0
         70gZo9qmSJl91X0fzst6PiKGCC9Mx8fzrLr8ft8aM3nBX6M2NayKHzH9VKbHiwUzu0+3
         Oe9AT3r2QIwQg/hRb2StexuTuqyN8juDT3GnvxfVHZuBX8jV1DE3fEjny4uvFU27sRPc
         20HTwAKVRkQpc6rCbVi/5HV/1jjVHA872268x7zt4slvHDqZB+nivnbKfLxg20YdC/x1
         o8tk38mFc9vjfMPlujJ9FXD3mAFok4jhV1wLCH01zDpPb6QUaBpiMtJRF4AJQrqUrrTZ
         pJXw==
X-Gm-Message-State: AOJu0Yztq9wl8xACoMP185Z3eCNHtev8iFMa7/W5fupSF3WrSYMTipdH
	FMf9LhMu686o3dOFBJM4tgnoHLmTcO8Zqe6YoUIVgMB4ypyLKyYgFdQSvJk+2kSq9EJ4qm6HXmM
	+xRzmAA==
X-Google-Smtp-Source: AGHT+IHFQiSefcTlno7Uq/XGi8nI9plpgfoEU78HL5FBciMulA4rlZ4sbQS82vcym6ASk7rbb+I7gPlrtRg=
X-Received: from pggr14.prod.google.com ([2002:a63:d90e:0:b0:b42:373b:8dfc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d87:b0:243:78a:82be
 with SMTP id adf61e73a8af0-24340da7cefmr889872637.56.1755812323689; Thu, 21
 Aug 2025 14:38:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Aug 2025 14:38:41 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250821213841.3462339-1-seanjc@google.com>
Subject: [PATCH] KVM: SEV: Save the SEV policy if and only if LAUNCH_START succeeds
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Kim Phillips <kim.phillips@amd.com>
Content-Type: text/plain; charset="UTF-8"

Wait until LAUNCH_START fully succeeds to set a VM's SEV/SNP policy so
that KVM doesn't keep a potentially stale policy.  In practice, the issue
is benign as the policy is only used to detect if the VMSA can be
decrypted, and the VMSA only needs to be decrypted if LAUNCH_UPDATE and
thus LAUNCH_START succeeded.

Fixes: 962e2b6152ef ("KVM: SVM: Decrypt SEV VMSA in dump_vmcb() if debugging is enabled")
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f4381878a9e5..65b59939754c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -583,8 +583,6 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
 		return -EFAULT;
 
-	sev->policy = params.policy;
-
 	memset(&start, 0, sizeof(start));
 
 	dh_blob = NULL;
@@ -632,6 +630,7 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		goto e_free_session;
 	}
 
+	sev->policy = params.policy;
 	sev->handle = start.handle;
 	sev->fd = argp->sev_fd;
 
@@ -2201,8 +2200,6 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		start.desired_tsc_khz = kvm->arch.default_tsc_khz;
 	}
 
-	sev->policy = params.policy;
-
 	sev->snp_context = snp_context_create(kvm, argp);
 	if (!sev->snp_context)
 		return -ENOTTY;
@@ -2218,6 +2215,7 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		goto e_free_context;
 	}
 
+	sev->policy = params.policy;
 	sev->fd = argp->sev_fd;
 	rc = snp_bind_asid(kvm, &argp->error);
 	if (rc) {

base-commit: ecbcc2461839e848970468b44db32282e5059925
-- 
2.51.0.261.g7ce5a0a67e-goog


