Return-Path: <kvm+bounces-63072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8E4BC5A708
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:00:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E6363BC074
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 22:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 355D032BF38;
	Thu, 13 Nov 2025 22:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XLF/H1se"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA36332AACD
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 22:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074605; cv=none; b=rZexfBbga0r72isfIZlfkCjoDvUKcCBp4vqq/CxlCtFYJjT4oxVIkRCdKSWYt3VqQjf38iMiFTJLeFsqqgAvO+TsK3jpqWh7J/c+yWZvqSYHUdqw+gjkqiBMgerKEP2tv0/MZf/QBfIv3RQ8ZMQLbc8Hf+hSZAnChcAQcezJBFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074605; c=relaxed/simple;
	bh=a+s6sZNkgEmBhyZ1wdOGRI7wiOUgOGhVQHVBCdK4J8Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eUqmUGaRSWtUjhAE08k+6cE5l42RkJaWUom2qfRtzPKHJ2JHVZC2Cg4hBh7MPqWkftRYmYOaH1qHcBwP4Rlbre7hdx88euPlXoFfeKLZoV0Qhpylc5Av/GeYa0lPzuvbb0zd83NZTfNIDeYxxNl3i1/Yv0MnKt0M0OBQ9MIA+jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XLF/H1se; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-298389232c4so16254615ad.2
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 14:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763074603; x=1763679403; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mHz4oN+bRmjr/Tq43pRV+YXBpy16+hTvzgAeUQ/5hJU=;
        b=XLF/H1sefUQgRYonaKzLHXfznh62AUf/0YB9jSmqZTcAkl7VhloeCFlB2ERuiZPfs4
         y8WI96oxdZ1ITX3nZnuhOISOrrR42wAXoTifeLtqxPZNZM1XixfhWqbaKho46bpDeIMX
         sLzI0+gSxhbxqUupSCDnmD1UUtjCWRPB0I9MeddDeVYmC92gjDfMzGbAxpimaHJsnvgJ
         Qm2JPWaUjjQRYH2oQxj21XlEZKCH7bfZ7XcPdUCX8DqxCmcQCXH6dRflCar68VVlIfbN
         McxW/ChMNMaPD82QZB0IZUJJP1Xg/N3k4azzN5VPJF2rbfUjoxjJw5TFEWqZHFe0g0IS
         tw7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763074603; x=1763679403;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mHz4oN+bRmjr/Tq43pRV+YXBpy16+hTvzgAeUQ/5hJU=;
        b=rNUAANd0juLG6fTqWAiICnL/tVUo05KU3sArROccasta9zCDOqk4cqZUU0zyJJF87/
         Sl1J/9u3tUtBNIPeQ5MefAuy8y2Q/7GLAuQTaO560G44zxLjiJwMH2mNxk5Ppxgiw1sM
         tH+gdVbF6thOcLME3fBvTUn26pmqa/S2yT1iYxMPlsn3XGCUAN1sGvmz7d3Y+6kTou3h
         Zhu2YplV9GaILUqr+KJXU+nZAi47esl9db0N7o1XC/zCvcM3fMlaArNvV0f+4z3d/z9q
         j50TkodNABuKYnx0Ep+gyJfSHHTiKKL1D4TdrCJPz8nmGT3228amBRAH0HD74aoKgEA4
         cjGQ==
X-Gm-Message-State: AOJu0YxL279vpBMvYhvKXX7/6igO0leIWcIJ8krutLd7lC7Rvilru+8l
	4K8ey2/76MHC8Ndry1FWMUa/G9YA6qkfahFRDhkN3LVRWQT17/Kq+oXHo2r7wnxgEInYc9A1++T
	b/P6pVg==
X-Google-Smtp-Source: AGHT+IEO37c5pwPK2cMLUV9F0xRjUgNCC9Jy0Xa4OyxYda5fCXX6UpbBlg6x0BhMofP9nToBEj/Ouj9X0QU=
X-Received: from plot13.prod.google.com ([2002:a17:902:8c8d:b0:295:fb8:7fb1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d502:b0:295:586d:677d
 with SMTP id d9443c01a7336-2986a74185fmr6475565ad.41.1763074603172; Thu, 13
 Nov 2025 14:56:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 14:56:21 -0800
In-Reply-To: <20251113225621.1688428-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113225621.1688428-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113225621.1688428-10-seanjc@google.com>
Subject: [PATCH 9/9] KVM: SVM: Harden exit_code against being used in
 Spectre-like attacks
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>
Cc: kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Explicitly clamp the exit code used to index KVM's exit handlers to guard
against Spectre-like attacks, mainly to provide consistency between VMX
and SVM (VMX was given the same treatment by commit c926f2f7230b ("KVM:
x86: Protect exit_reason from being used in Spectre-v1/L1TF attacks").

For normal VMs, it's _extremely_ unlikely the exit code could be used to
exploit a speculation vulnerability, as the exit code is set by hardware
and unexpected/unknown exit codes should be quite well bounded (as is/was
the case with VMX).  But with SEV-ES+, the exit code is guest-controlled
as it comes from the GHCB, not from hardware, i.e. an attack from the
guest is at least somewhat plausible.

Irrespective of SEV-ES+, hardening KVM is easy and inexpensive, and such
an attack is theoretically possible.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 85bc99f93275..308c70b6924e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3467,6 +3467,7 @@ int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 __exit_code)
 	if (exit_code >= ARRAY_SIZE(svm_exit_handlers))
 		goto unexpected_vmexit;
 
+	exit_code = array_index_nospec(exit_code, ARRAY_SIZE(svm_exit_handlers));
 	if (!svm_exit_handlers[exit_code])
 		goto unexpected_vmexit;
 
-- 
2.52.0.rc1.455.g30608eb744-goog


