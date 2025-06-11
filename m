Return-Path: <kvm+bounces-49164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76445AD6322
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:53:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3FEE57A7CFD
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:52:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 931542D3A6C;
	Wed, 11 Jun 2025 22:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vdhp2R6N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36E12D323E
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682049; cv=none; b=EOPAJ5gVCBO9iKMmeE/IsPJXSJ7TQUuoo7HAbuz1kzxAoM3rjgdW5miaymyoHbH/khFROlAK7p/VX6bKLiU94G4Z9rYJrE64qiw4XqMrmgpOPxf7A4ovLnv5nVQWOWAkNcXjVrNF+bI+istbxIm9XCarU9JrS3oh7QXFQZCDEaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682049; c=relaxed/simple;
	bh=J6zOinbkdgKylugz+qVBm+Q6AqKeqc/V4kq3h/NovvU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PrnTG4HWpl0AgOhNbvkQp7KoJPzTlVJnX8zNG14DktqftSN+Wt0mgPxXYTq5VXbviaY7agNryHB0mmLRigzcfIszX+a7PNxmyABf7cumaDNJGHmTktYM3veVLovjno1HVUrmGbUsQNJHiRptr70Zn7PAgFA2gSJCPRPp5SO19k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vdhp2R6N; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3132c1942a1so443326a91.2
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682047; x=1750286847; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=trIKCr3BKTnnj1sqkKg+yTyCPFnaZ4cJOVW948+vsJc=;
        b=vdhp2R6NpU0yGZ6XlW4fm6oMNxjjpRR+osrTo6k3LExLWC0bk73EEkkuSaIkf+9PMv
         v/FNBOje5/87qsL5BC+pRcxfsewdSBR3DHIGAt2NSra+eUpCYOFr7eHmKQZ9OXKM7Oir
         WK78V/IEch2EcWK+xjQUvAn7uLkCkl6ImKryfX4StepRP2OcTvBaAl59JF6yXxpQ+w2w
         ANyD/DxsW0OU26x8QfeEXeEWeuH3z6uYm+yy4MqPPneETExxLi3cAyxaA4fFK/8Dcyt2
         oU/WQ+PKIt61vV5cQamD7zeJD12wYMiaZ+FwADG/uUt/MdNy+psf6vtXYS3I1IOt+6qx
         XtfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682047; x=1750286847;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=trIKCr3BKTnnj1sqkKg+yTyCPFnaZ4cJOVW948+vsJc=;
        b=PRtsi4D6Wwj8aF1Vq+vMef6TMFL800vuykuCCQ3kKrCDAA9TR397s+pwxjl41h9vla
         h5h1BqUod0LlA2LGRZcg2y6Iy+IHV/jKIkFtRniMMPjJpu7CNPiu3bWyOysn9nuHbgii
         MZ9WjLLR2CtWeuO6c7fGyc0e0lbNLYcWgX8xvAqE1pFA9VSgCSCIH7kyWjdBgtCaT4Da
         /+ESPEsmsiVpceNIybzdwGcjJt/d+yvsdIfTh6xhPAB9eYNiyME4X1XKnxMhsrdZvcOy
         oxHc/wPjWAjZYXqPiqhBuoh4IKv/f+5C+2Y9s9Y6dLHY3GRDeWu4fX1MQVfkxhPGR9ck
         EFtA==
X-Forwarded-Encrypted: i=1; AJvYcCXYe5XNUpV8uVIZ09vVH/WZlWyNTO6XM3X1PeQYoiitOCkCMUDpIKCfi7v2SjHBLTa5Ths=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPrLejHVQucfXTXp5bgzDN8DU5BafZnBTxpjHc6vVHJmMIjNx9
	4H2k+T8Pu1qq8oZltVsN4P0WcjVZP7RBtX/TcfaQQhQV2O/Zj/A1VZ4QLoRsFEwC23bJa+zg1Lz
	W2cVGig==
X-Google-Smtp-Source: AGHT+IF+r3WoBv41JnZ3zMdtBzjsIX3MU1bEitF46j7ZacLy0t9sYOOvunU4WNhpDLaXzfE8bRA/KcgnWWk=
X-Received: from pji7.prod.google.com ([2002:a17:90b:3fc7:b0:312:3b05:5f44])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3508:b0:312:eaea:afa1
 with SMTP id 98e67ed59e1d1-313c08cfd2emr946409a91.29.1749682047052; Wed, 11
 Jun 2025 15:47:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:21 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-20-seanjc@google.com>
Subject: [PATCH v3 18/62] KVM: SVM: Disable (x2)AVIC IPI virtualization if CPU
 has erratum #1235
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Maxim Levitsky <mlevitsk@redhat.com>

Disable IPI virtualization on AMD Family 17h CPUs (Zen2 and Zen1), as
hardware doesn't reliably detect changes to the 'IsRunning' bit during ICR
write emulation, and might fail to VM-Exit on the sending vCPU, if
IsRunning was recently cleared.

The absence of the VM-Exit leads to KVM not waking (or triggering nested
VM-Exit) of the target vCPU(s) of the IPI, which can lead to hung vCPUs,
unbounded delays in L2 execution, etc.

To workaround the erratum, simply disable IPI virtualization, which
prevents KVM from setting IsRunning and thus eliminates the race where
hardware sees a stale IsRunning=1.  As a result, all ICR writes (except
when "Self" shorthand is used) will VM-Exit and therefore be correctly
emulated by KVM.

Disabling IPI virtualization does carry a performance penalty, but
benchmarkng shows that enabling AVIC without IPI virtualization is still
much better than not using AVIC at all, because AVIC still accelerates
posted interrupts and the receiving end of the IPIs.

Note, when virtualizaing Self-IPIs, the CPU skips reading the physical ID
table and updates the vIRR directly (because the vCPU is by definition
actively running), i.e. Self-IPI isn't susceptible to the erratum *and*
is still accelerated by hardware.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
[sean: rebase, massage changelog, disallow user override]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 48c737e1200a..bf8b59556373 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1187,6 +1187,14 @@ bool avic_hardware_setup(void)
 	if (x2avic_enabled)
 		pr_info("x2AVIC enabled\n");
 
+	/*
+	 * Disable IPI virtualization for AMD Family 17h CPUs (Zen1 and Zen2)
+	 * due to erratum 1235, which results in missed GA log events and thus
+	 * missed wake events for blocking vCPUs due to the CPU failing to see
+	 * a software update to clear IsRunning.
+	 */
+	enable_ipiv = enable_ipiv && boot_cpu_data.x86 != 0x17;
+
 	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
 
 	return true;
-- 
2.50.0.rc1.591.g9c95f17f64-goog


