Return-Path: <kvm+bounces-23764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B61E094D6E6
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:07:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2BE8DB224FD
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:07:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9091919A294;
	Fri,  9 Aug 2024 19:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sq0OnCz7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A428199E8C
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723230232; cv=none; b=XMjsYgJwfwf9Gepse6RprLOAhYu2GJLtd1DHqe+k7sec+Su7XNCp944fEhRf1jxiD468nBALK1w9nUDzxxw0HE0vwWuoa6SmpEi7NlO2NIjY0ZE5SpO6R98mXk3MnE8gSOXgTG0D+OgY/te5r/s4bR1JrgHaeE79zb6km8ghW90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723230232; c=relaxed/simple;
	bh=y4e2ws5CmA6QmgH+LrpuQNDyjhqqtDpNs/vzxZUhBOE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g/cpbvdcREOvlV0FLlF3Q/LJv8xCESdQ2yH1N87x6wl+yMXxr7Li63vgW/n8b3ww+pRb/d9ss47B+TaOOVQ2wspevbkr8sPCeM5Rp9BnlrD+cc5PVHO5kts2a/7UDafs/0RLxpuwdfxlcpENbIGVAjzDUUKLGLrTYUNmgXa9mkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sq0OnCz7; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1ff3dfaa090so23190605ad.3
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723230231; x=1723835031; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pC7nnCclNkH1a5h1FMz2WKmoD/v8iKeyKDxG+elCokA=;
        b=sq0OnCz7sU2kNc8p13jeYxANoV9w2vLjOiZteOoCUVOk+mYL/O1IXIqJGmf5h8Z3wP
         VfG1Ir0KzPv17c0kRHJNssfh4ISnU9PuQiqS596wL2OPHQJ+anjX8VRIUNAwLDFdYdn9
         qaWvOgzUSB6wOiQ780GdhSFjWGQYuyp209WxRsM+O8IR8mVreZPfm89AHlSSBrEGHypQ
         8yGLrq3OxtrBiZuiU2i7mFWKw6qHVonMfPysQCtd3QXiR9S1ZI7LjgbZFEROZJpuHLx3
         QANAnlF/fP/3pZ9boW1hd9VonCCPIHdI7swWw4002tFvvBDNFsYFEKIUcFLQyGk9+MRO
         BFjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723230231; x=1723835031;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pC7nnCclNkH1a5h1FMz2WKmoD/v8iKeyKDxG+elCokA=;
        b=DXgO65aa0c28LiVaVe1WNvteNpOu0unDpOEGFVDIhYmiI/Jiw2ejlb2VfdrRowbpzO
         keZnK0pJn7LROdpLgCc/OHCw7hdmJKvGfE9t171M6RYR7bzXpSfrmwHGt3ePJB+3Lrki
         z2lpjzMiykKtPxUS3C6U090CEXWbN5GFKlxpwTQPurERZ0AvmSHsy/jDhnx8hAtIIlBR
         1tqUGfvYxUMQSTZwc3EYFxf4NkoP98Y2wD6otPkk46xbmIMcxCJsjyUqrNeExAsXa+gQ
         HlJaFGeeqml0st2PcPrYX495oaJ8F0omENZDEEbvtwt2HLA7RM+CCocCmD+5wozbb+H6
         Ua8Q==
X-Gm-Message-State: AOJu0Yx1FsRRexgQS+8U/EWk6yXRqPfZ9zREWnAFY+/GednfZkp8yoVe
	KzmtGuNFvwln660cY8xF66ijeUMWq5oCdBf4Ir9RsrkPZQ11gAgg9wmvuEzoX0hdEtB/2V80f31
	m2g==
X-Google-Smtp-Source: AGHT+IEV0guIC48ohvagF6zYB+z3BO6oJse2IrkM1+rRSypDawH8Vs0UpeVAtkLq4rZ1vhdOd0D1zEgBHxo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2445:b0:1f9:cbe5:e422 with SMTP id
 d9443c01a7336-200ae56e4f1mr55825ad.8.1723230230668; Fri, 09 Aug 2024 12:03:50
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:03:10 -0700
In-Reply-To: <20240809190319.1710470-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809190319.1710470-14-seanjc@google.com>
Subject: [PATCH 13/22] KVM: x86/mmu: Don't try to unprotect an INVALID_GPA
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

If getting the gpa for a gva fails, e.g. because the gva isn't mapped in
the guest page tables, don't try to unprotect the invalid gfn.  This is
mostly a performance fix (avoids unnecessarily taking mmu_lock), as
for_each_gfn_valid_sp_with_gptes() won't explode on garbage input, it's
simply pointless.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 065bb6180988..a5d1f6232f8c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2739,8 +2739,11 @@ bool kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa)
 	if (!vcpu->kvm->arch.indirect_shadow_pages)
 		return false;
 
-	if (!vcpu->arch.mmu->root_role.direct)
+	if (!vcpu->arch.mmu->root_role.direct) {
 		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
+		if (gpa == INVALID_GPA)
+			return false;
+	}
 
 	r = kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
 	if (r) {
@@ -2759,6 +2762,8 @@ static int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 		return 0;
 
 	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
+	if (gpa == INVALID_GPA)
+		return 0;
 
 	r = kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
 
-- 
2.46.0.76.ge559c4bf1a-goog


