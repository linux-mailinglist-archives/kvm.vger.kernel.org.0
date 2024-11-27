Return-Path: <kvm+bounces-32621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 017BA9DAFF5
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 00:53:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8431BB21735
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 23:53:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD2BF199391;
	Wed, 27 Nov 2024 23:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UVu59g6Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DA615E5CA
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 23:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732751596; cv=none; b=eisMuC5zITLNIZ/NGywDyRAPg0B+R5YQSgAl4faFgbwqP7XSRnl9VZc7UVgaZxT8tXO3+N+OhAMb2UvN/6sC1/KWS/WO1UMUBDZfBRZfpZDgcl3KufzQfVu4WaUL7u5Npr6S6aiFZ1UlS9TKBred30vAWa+5fTjwbWDVzBJ3LaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732751596; c=relaxed/simple;
	bh=B+guaGM8zNDjHAblKR3rNrz7k+exZxvr6Z32NHXfp78=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=W9YLKF/s5kmpoEOHLc5KczIe9uISfZqhrtWRhHK5q2s+AQjyxwg+hZbgxk8sZ5uGnKnvN9GMNShcH8PvnD+bCn3AgA/yQ9qTTBF7ibzC4q0mkz7kTEvGixHMS7Jy5FK5ZaqS/Zc9tshWUf4aLaW6+Rq3cvu3ugzlMYRTRvMMT+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UVu59g6Z; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea4291c177so228577a91.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 15:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732751595; x=1733356395; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jNdPCBLD98K20zOO6Bao1YI0NO02p0JCW7gr9Ds1ueM=;
        b=UVu59g6ZBOjQvWmBnPSDdqfB/5FbEBFQ+3yX5SJ+uNsP2Dh0zYhmJQySHJzHNfMeXD
         DMAr2Ewx0cShCHFdbn/Sl5aZaa6P/hr2zHc0ZJZI0+xuAuCaaMy1m2jk8kwl7bpeju4v
         q5E+aofuyJWb1xlQ/j7aqW7NjRmWiVZvXYMPuUN6vaIYuU0LqBJGDWmYZ3+AtdjgoIhW
         9XRBsvSZZu7D0FY7aTIXms2+68IHv+VcA+4Bogof1q91Y/gBdqI1l8gPYMUtwhHxJ36l
         1CpkwFv8qyPreRbPPjNoOeebrvDMowkTNTzmSXMzyXfyBp0AE9mCDTDxrK1hyCftGrrZ
         /szA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732751595; x=1733356395;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jNdPCBLD98K20zOO6Bao1YI0NO02p0JCW7gr9Ds1ueM=;
        b=VE2yUcxo5DXPN5R3WJ7QljtAAp8YuXZ/ZtzrjYXdU1gpopKgWQmHMVA+tdvbcRhR7c
         iXqhCp5KQm6K1192Q2eD1Fz0Kjjd9YzPOjfx/ESsgvrKr1nzFdzX/04JyTAPV5NrJGhS
         0pKIuk/SnWKSdrkHtnmPt5qs6STcpcFsb1mDuCm7VpsydjyAr6bvkS28X0SZ+VC6hqDI
         3VNudPBEKqJKApXL5gDni3T87ynkD/888Our2R+KujGZ3lhQbxAEHq16R9Forqp4gPJJ
         1f69jfQcIoVgQxVa9fQbBinn1apbqbogRxhaFRKVQgLjLW7uoE5x+TuigPlJP9fkFTJ7
         RLlg==
X-Gm-Message-State: AOJu0Yx3E4CX8NpS7U9M2IiUaktH/PgjuJqZWAtTweTyGijJEgmDuHBz
	nFbO5zlGTt6kBKLzYH37dFTfC0yaf+LKKYz4iQnCDcrOkFB6q+W+wln+uAm85sOi+skQU6jd2C3
	nFg==
X-Google-Smtp-Source: AGHT+IHR7A/TQXvzV6P238Oe4bPKg8Edeq87kZfXAl9SSGx/sR0jXBPGRSpiDg11scozZoz1hS5NEDgHQmo=
X-Received: from pjtd6.prod.google.com ([2002:a17:90b:46:b0:2ea:c64d:fccb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b51:b0:2ea:5054:6c44
 with SMTP id 98e67ed59e1d1-2ee097e51b4mr6538986a91.31.1732751594839; Wed, 27
 Nov 2024 15:53:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 15:53:12 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241127235312.4048445-1-seanjc@google.com>
Subject: [PATCH] KVM: SVM: Remove redundant TLB flush on guest CR4.PGE change
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Drop SVM's direct TLB flush when CR4.PGE is toggled and NPT is enabled, as
KVM already guarantees TLBs are flushed appropriately.

For the call from cr_trap(), kvm_post_set_cr4() requests TLB_FLUSH_GUEST
(which is a superset of TLB_FLUSH_CURRENT) when CR4.PGE is toggled,
regardless of whether or not KVM is using TDP.

The calls from nested_vmcb02_prepare_save() and nested_svm_vmexit() are
checking guest (L2) vs. host (L1) CR4, and so a flush is unnecessary as L2
is defined to use a different ASID (from L1's perspective).

Lastly, the call from svm_set_cr0() passes in the current CR4 value, i.e.
can't toggle PGE.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dd15cc635655..f39724bf26be 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -284,8 +284,6 @@ u32 svm_msrpm_offset(u32 msr)
 	return MSR_INVALID;
 }
 
-static void svm_flush_tlb_current(struct kvm_vcpu *vcpu);
-
 static int get_npt_level(void)
 {
 #ifdef CONFIG_X86_64
@@ -1921,9 +1919,6 @@ void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	unsigned long host_cr4_mce = cr4_read_shadow() & X86_CR4_MCE;
 	unsigned long old_cr4 = vcpu->arch.cr4;
 
-	if (npt_enabled && ((old_cr4 ^ cr4) & X86_CR4_PGE))
-		svm_flush_tlb_current(vcpu);
-
 	vcpu->arch.cr4 = cr4;
 	if (!npt_enabled) {
 		cr4 |= X86_CR4_PAE;

base-commit: 4d911c7abee56771b0219a9fbf0120d06bdc9c14
-- 
2.47.0.338.g60cca15819-goog


