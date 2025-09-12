Return-Path: <kvm+bounces-57470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30D6AB55A32
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:32:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31DED5C45EA
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:32:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7374D2E040E;
	Fri, 12 Sep 2025 23:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zjZPEKI2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F382DF6F5
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719458; cv=none; b=evocfxeNqmGU1sGXBxzl/zZRkJgsFw5vklCw8SVKkG1Th9ZcqPsN9huayUo5ZicnaRowEgg+X5pd3RCByUbSzjlaK65lxl4LPzzk3237U58o90Y7X2wQMH/A7AAGzAWLlb7LH1IgnWqnszUJCzwv1/TrjgPjkF2BbtSxGk/+sIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719458; c=relaxed/simple;
	bh=fBM++utOUJHtYvpSjDE2iy0S74USVtNMtgRTB+NUul4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EgtioD5mHJ2BMh1eNCypJD1PtNs9f+KIqrynzFNcFMs5FK1CBvPXLpxl42ne8Tds3haBdNLt3O8goJ9SDrqRiyfCfkY1j2ajRlqjXXF2pAR6R7SXE1dUvX+B7Mejw7MRw8WC9+eT3yHjopTjzwsvN3/ZlTGP0l7fWONeApNSm6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zjZPEKI2; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24ce3e62946so34430815ad.2
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719454; x=1758324254; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xwixwi/pq7WJn2ZqYO6o3aXpIOBO0K9ZG0HFJymmGLE=;
        b=zjZPEKI2372tcAxov6mMsu5K+ENONtNKBkDbA8cNk4NOfsYU7EB93J9gm9XHAksUfU
         pvKH/gTQQhBCfHfqHF8MqWEps8l32ULSgxuOH6UGaEbJqaoqUehXNDHGupHpNCFlKjCu
         sZqQfER0TjuFgMOdMm7FBagYDo/lCmA5JsOqQjd0x2hcTbbvj4XDm8PkfDNdOTHekB3u
         QTtklgeiIxQNc9+daV+wGK2vxltIp6zD4BjenBBFyB1b6bO/AaX609CPdiouixXr2B1A
         IMcKW5aHxiEK/17y+/UzqqZ/hpgP1m3zctIsvN1/p1WaSkaxXJhno4xlAYd13RqRMqQ7
         7AqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719454; x=1758324254;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xwixwi/pq7WJn2ZqYO6o3aXpIOBO0K9ZG0HFJymmGLE=;
        b=ALsZ9Iob61cJqBCJAC6z37prQTbfZULXTbWn7x86bU7/lIRiy2r1zMIALm9jXpvmsK
         sn9+7sPEWMoqz1c7l/4bZH4POxwdYVwNM/Q4PuYih7nPziUf1oT27bQ+NCCohGVuJE0J
         NBnatkHsbN1KkbGUNtNaYMmTOO4MuK1FZSftSLdhSiZfHEbqrg8Rb8S4yGgjq2MnceGA
         4gg0MOFhTX2x7T3O7Go46mk9ZH+l3IKgkn4qNCz5rRm7TA+1ULcnCVzWsV6TyK047TXu
         P4t8hjWxXyoUNY//LDgP86YDQDY9n7wU2PcjuysT1owMD4Fxo8WZDwvp/cPpfj3Cq9JB
         aJcQ==
X-Gm-Message-State: AOJu0YzJH8Vb8zWlY/tyl7GHILq4Isik3y+OUjaU5p4BeT3/B70zq0HM
	lBk+hZsRC36SaXP21cJF6u/PKKdZI/rPVqdUJYDGzdh5WoEj7hz3Hq2emNeYqaaP/BHaCAaFSwP
	I6KcKWw==
X-Google-Smtp-Source: AGHT+IEwe2z/CoghXdq5pw1tWeWTUfTaSNa0gKl/TqYG+LRtVUmBsUYMFAiW+9zgOymlGloFYvugvYSX/9k=
X-Received: from plnd12.prod.google.com ([2002:a17:903:198c:b0:24c:cd65:485c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ebd2:b0:25e:37ed:d15d
 with SMTP id d9443c01a7336-25e37edd357mr33268295ad.0.1757719454481; Fri, 12
 Sep 2025 16:24:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:23:05 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-28-seanjc@google.com>
Subject: [PATCH v15 27/41] KVM: x86: SVM: Update dump_vmcb with shadow stack
 save area additions
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: John Allen <john.allen@amd.com>

Add shadow stack VMCB fields to dump_vmcb. PL0_SSP, PL1_SSP, PL2_SSP,
PL3_SSP, and U_CET are part of the SEV-ES save area and are encrypted,
but can be decrypted and dumped if the guest policy allows debugging.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: John Allen <john.allen@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0c0115b52e5c..c0a16481b9c3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3410,6 +3410,10 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	       "rip:", save->rip, "rflags:", save->rflags);
 	pr_err("%-15s %016llx %-13s %016llx\n",
 	       "rsp:", save->rsp, "rax:", save->rax);
+	pr_err("%-15s %016llx %-13s %016llx\n",
+	       "s_cet:", save->s_cet, "ssp:", save->ssp);
+	pr_err("%-15s %016llx\n",
+	       "isst_addr:", save->isst_addr);
 	pr_err("%-15s %016llx %-13s %016llx\n",
 	       "star:", save01->star, "lstar:", save01->lstar);
 	pr_err("%-15s %016llx %-13s %016llx\n",
@@ -3434,6 +3438,13 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 		pr_err("%-15s %016llx\n",
 		       "sev_features", vmsa->sev_features);
 
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "pl0_ssp:", vmsa->pl0_ssp, "pl1_ssp:", vmsa->pl1_ssp);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "pl2_ssp:", vmsa->pl2_ssp, "pl3_ssp:", vmsa->pl3_ssp);
+		pr_err("%-15s %016llx\n",
+		       "u_cet:", vmsa->u_cet);
+
 		pr_err("%-15s %016llx %-13s %016llx\n",
 		       "rax:", vmsa->rax, "rbx:", vmsa->rbx);
 		pr_err("%-15s %016llx %-13s %016llx\n",
-- 
2.51.0.384.g4c02a37b29-goog


