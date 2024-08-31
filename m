Return-Path: <kvm+bounces-25589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A1688966D42
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:17:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5698F1F24507
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFE301CABA;
	Sat, 31 Aug 2024 00:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u4V+jB3D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617BF3D76
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063352; cv=none; b=ZO6hQgtCaeFa9WVK6xy2KGEXaZrOIYMH91JdlP3+lRrJTPm8RWYmwk4OouDQ8AfDjtUWb9K5NZkI4H1VYHDkXTeUE8dPZu5yd5Gczde8d4UL+jmSmGgQ3/IjjvrPyJ8rD5jd9xYo2h2hDvbOi/ZZfYYaj2aujC0xPdQodr9UD4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063352; c=relaxed/simple;
	bh=aTVAVwczKEP1sfRbeojsquqSLoy7yQdZzgoVJkxL3Hw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qj5x0EH6uFRiIpJmfUFRU1yxcOW2WCmwc9+/ep8Ew23GRt5oaoYo2FhDcHRuKx3zcZoSsIVmIPBa6PTwRi/8VHYgHJH9KQFiTPVBRZcWvY+DxQBBhqZqxLv6TNZgYxJjtbOKZ9vxOXMK/PDv8LsHlqp/E76tkt8B5jShKOMyUFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u4V+jB3D; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-69a0536b23aso47526657b3.3
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063350; x=1725668150; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7EhMqLEmX3n6K2WXzV5Gm2EiCppXNLHfvg1qXCILft0=;
        b=u4V+jB3D9zcTcjsW2UOL9Mi5Ej3Pv9n02ZNBcq5tIbc4wZIy/Y3/sJ+/ZSwQj8k0I5
         EMLdI+q2PRAZ2fX/OxAviCUbmL71FPgg24GEDkZUNcrLuOiSrLI4OREv9y8Js45pSDQm
         fsxr5Cp90dQ+pZ2FR+7PBnhKW8ZPQ17COOPVVzO1Kx+zk3Ou/5v2AFX6pvJhdhCCG/4R
         z+pdHAEsrOCsYrfjcMaQCvG6zrajXbciEPIic0cEVn8Hqekssum+l2S6/P1Z8d2RNnKM
         Gq/8biLDca4ndrxJKYO8nT5GT/tolSAlia0WvAvpfIa/h4XLH96zBsHctnT/f1EvHItN
         4PTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063350; x=1725668150;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7EhMqLEmX3n6K2WXzV5Gm2EiCppXNLHfvg1qXCILft0=;
        b=ts08GSIh6YHiiH99a+URD9h2Vrub7ZNmPwbxEvNbFuvISx9w7DJTeal3DUryPu3yQt
         GnMnKw1l3hBAokpth5kjUmiimAKOvO0Gu4KN7jl/yKIxVNEobAR26fgTA3jxCRSBbzyP
         Xe3nd5GSvjzI+ykAFjVV5Rsr9KOprDs3usZTYqVH3gS1hlGS73dp+qHGPO9cESFmP1X/
         5E6NwGq+A0ZAbb3u5+DAiR7IF9c2Phj6NH8QFiIfhH3K9IqBr+7AsMQVtf1NMw0iXKuf
         f3rXgcpxwT2bDXcY4oFVtV4Z0h70DOS3k24PvC3ialKIy9koOVJQp1fcoKnyMYyewldQ
         vvfw==
X-Gm-Message-State: AOJu0Yw1tFM0hsD/5+mwYT5k1Wanvy5yZmRN8Km3jMxhLYO/B7QLaHXI
	hgp3nY6n68QKWJ1UG6TApol7ohAl+TAITtexut3Q0V+PthPY3+xcoLvC17mcZy31MBQHZYHXPsV
	rqg==
X-Google-Smtp-Source: AGHT+IH772L2wnK+bJh/Re03anXSfmUsTgTWEqSK2F8xhRla6k8xN8TqIB6/NPP9fx/gq1A3FL1yJgAK9+o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4490:b0:650:a16c:91ac with SMTP id
 00721157ae682-6d411290d2emr966657b3.8.1725063350558; Fri, 30 Aug 2024
 17:15:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 30 Aug 2024 17:15:20 -0700
In-Reply-To: <20240831001538.336683-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240831001538.336683-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240831001538.336683-6-seanjc@google.com>
Subject: [PATCH v2 05/22] KVM: x86: Retry to-be-emulated insn in "slow"
 unprotect path iff sp is zapped
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuan Yao <yuan.yao@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Resume the guest and thus skip emulation of a non-PTE-writing instruction
if and only if unprotecting the gfn actually zapped at least one shadow
page.  If the gfn is write-protected for some reason other than shadow
paging, attempting to unprotect the gfn will effectively fail, and thus
retrying the instruction is all but guaranteed to be pointless.  This bug
has existed for a long time, but was effectively fudged around by the
retry RIP+address anti-loop detection.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 966fb301d44b..c4cb6c6d605b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8961,14 +8961,14 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 	if (ctxt->eip == last_retry_eip && last_retry_addr == cr2_or_gpa)
 		return false;
 
+	if (!vcpu->arch.mmu->root_role.direct)
+		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
+
+	if (!kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa)))
+		return false;
+
 	vcpu->arch.last_retry_eip = ctxt->eip;
 	vcpu->arch.last_retry_addr = cr2_or_gpa;
-
-	if (!vcpu->arch.mmu->root_role.direct)
-		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
-
-	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
-
 	return true;
 }
 
-- 
2.46.0.469.g59c65b2a67-goog


