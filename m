Return-Path: <kvm+bounces-25601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F4CD966D5C
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:20:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FF271C20916
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:20:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A03DE1448DC;
	Sat, 31 Aug 2024 00:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AfMQ2ACM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B95613B5B7
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063378; cv=none; b=LcYPr7CnOaXYF2MkMom1l/oAUn6yi2AR4yjdyN7mE1DrpB2Rw4jTFxn47GADaZUIojN/O+QnprRFzVS4JYWmy18Ueox7r1yUUpjNU/cybj4yJjxcBe7/pM/KsgrujDMIUGxi6FV4YaAQPoVL7gCQBKgwlEenwpnhFyQ3imHe1oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063378; c=relaxed/simple;
	bh=QaJOICfdwQ30ELkiG5OwkLM3NF9kzLFQgtTBFvcj7SY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l50dp6EYs1JaUodDnVMg41V+ShZlF+9YWKN+g61JXOx77hpsIBFQ5oH1BxLezDNmei6MIopcNlBZAT9lLKDkRRt0g4xjTLU+AeruG3YSiMUdRpRtFepziy2vefjvgzSSGZbCk4edMelkBRDV6s2SifATzveXLTtvDZhAo3iCbQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AfMQ2ACM; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e03b3f48c65so4455477276.0
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063376; x=1725668176; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WjHitxqWq6khw0o+yUtW8qx1qHM1xiloEtLNGgpGHyQ=;
        b=AfMQ2ACMQmx1Uc7lboshFETqa+gcvHqtsdxWZSxx1DXbCbX6BEUV4zrKF0vFxNVxIk
         KuSgRougIoYa8Pw4/+jTXAhttinwklYSNuRgW0fioobIanvSH+wxOv2zL1FV4OB4NUi/
         focr48ZselAyGouzsrtnlDjZZk+2UnKjsdSowEAIqfSFVnZRIpjrJvAm6cGTv/2w18qB
         L0T4dBMgboCKE9unK4I1aBOkfKUAh7HpL++cDe+ex7xFcPhnWqhK9JmZ8tLxosIaXUFx
         1A45gIIr0bXxFipPU+gPG3iP6g2Lo0I+QcW3aRcE35l33our+3vQCS6b24V/m+xnHxOW
         ufUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063376; x=1725668176;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WjHitxqWq6khw0o+yUtW8qx1qHM1xiloEtLNGgpGHyQ=;
        b=g2RvT/3ExPbcFeJIICeCT1xCOqVE2pqO4GWgcb/DCvjBMg6P013gBoFD/AFBJ4Kq8c
         XrS1v7s+T2yJnsCv3kb3n/13JZV8E/xkXWLUTawYJDb3joe062dPIYn5oqjA5JnPe2dI
         SybbDvnDHcBW6IftHox0hZxoF19JOzERoMkFg7MokREYnnOT51rHz6C0OjtH5t0WeCx3
         WmD3LOvfL+zQK1Px8SlFgjWTupZLXi8cXw1n3+0vkAblIE6vbzIA1RV4JR5S0jFCAXEJ
         Ld3uDp930jJrsF0D+mnyZYUcAwFDwWF9r6GsojNslRg/KYo7kxmbVkFshtMupMpo0VaU
         qKWg==
X-Gm-Message-State: AOJu0Yy8aizQmuC2v3d3fKxhbLE1iGK8JlCoQdSDScsRHjS4eyUhNFXU
	xq4AXxV1ucY+47mt4y6T2qS+riMgSvnwc6Co+wqmlELhAHekL6tNKwEWa5TPD5c0zyhLQRyb4mk
	pSg==
X-Google-Smtp-Source: AGHT+IGo0xQgoGTC0KvVhguAmOCzE28x29RmlZpo2tFA6rgbVMj8w/GoFAp/vSeEnp4ivUddGUq0H+jFDzk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:7156:0:b0:e11:5da7:337 with SMTP id
 3f1490d57ef6-e1a79ff9892mr8887276.3.1725063375993; Fri, 30 Aug 2024 17:16:15
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 30 Aug 2024 17:15:32 -0700
In-Reply-To: <20240831001538.336683-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240831001538.336683-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240831001538.336683-18-seanjc@google.com>
Subject: [PATCH v2 17/22] KVM: x86: Apply retry protection to "unprotect on
 failure" path
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuan Yao <yuan.yao@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Use kvm_mmu_unprotect_gfn_and_retry() in reexecute_instruction() to pick
up protection against infinite loops, e.g. if KVM somehow manages to
encounter an unsupported instruction and unprotecting the gfn doesn't
allow the vCPU to make forward progress.  Other than that, the retry-on-
failure logic is a functionally equivalent, open coded version of
kvm_mmu_unprotect_gfn_and_retry().

Note, the emulation failure path still isn't fully protected, as KVM
won't update the retry protection fields if no shadow pages are zapped
(but this change is still a step forward).  That flaw will be addressed
in a future patch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ad457487971c..09fc43699b15 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8860,8 +8860,6 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				  int emulation_type)
 {
-	gpa_t gpa = cr2_or_gpa;
-
 	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
 		return false;
 
@@ -8878,29 +8876,13 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	if (emulation_type & EMULTYPE_WRITE_PF_TO_SP)
 		return false;
 
-	if (!vcpu->arch.mmu->root_role.direct) {
-		/*
-		 * Write permission should be allowed since only
-		 * write access need to be emulated.
-		 */
-		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
-
-		/*
-		 * If the mapping is invalid in guest, let cpu retry
-		 * it to generate fault.
-		 */
-		if (gpa == INVALID_GPA)
-			return true;
-	}
-
 	/*
 	 * If emulation may have been triggered by a write to a shadowed page
 	 * table, unprotect the gfn (zap any relevant SPTEs) and re-enter the
 	 * guest to let the CPU re-execute the instruction in the hope that the
 	 * CPU can cleanly execute the instruction that KVM failed to emulate.
 	 */
-	if (vcpu->kvm->arch.indirect_shadow_pages)
-		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
+	kvm_mmu_unprotect_gfn_and_retry(vcpu, cr2_or_gpa);
 
 	/*
 	 * Retry even if _this_ vCPU didn't unprotect the gfn, as it's possible
-- 
2.46.0.469.g59c65b2a67-goog


