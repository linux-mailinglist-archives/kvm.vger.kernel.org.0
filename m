Return-Path: <kvm+bounces-10197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10BBF86A6C6
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:45:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF011289513
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 02:45:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61E201D522;
	Wed, 28 Feb 2024 02:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="edga/too"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED65A2C1B5
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 02:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709088133; cv=none; b=fBQNrF+omhWZwYV97uPKm9VOLDaU9wiiXJ8CCEHq1nwO12AjayMTGqjP+veWBZN8fICgJxIrnWPN9TZzyzFRX09vCYM1vDDxRH2uzl9lfFiQSMf1KrGO13dsHqqSjFpXRXhBX7ylbGRJrMpuVEo3Mb7yR8p1I3Z9vttzhTNSnQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709088133; c=relaxed/simple;
	bh=UGrkpK716aAHiw66iG1/DSWpe947kr0y+y0Afd7BmIg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R75X57zlT/wsPEnVSMh1PRUJppzIhq7B9Tke5tDOdLnUKhPz1zOmeKzkK9cM/wGp0wblnN+XEMd7QtgRB5azleBt7vvPihj0kmWsv0Vhx/ZA6yYmkUmCGzxAR4BuSpZxXKgzKI3QQIJDZPi4IAj+lgzIR6+UPF/MBbAzhUH5Q+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=edga/too; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6093a9ac959so5897007b3.3
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 18:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709088131; x=1709692931; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=f2pVTuxLJ1bF5JkBExEt38LFzKRRlG2j//10dt1o0l8=;
        b=edga/tooo62Ub6On2m2O1NUOjTM2zXNHq6BsT4vn89Q2jP+XHb+ii9oxXDO7TKkLjc
         13mriBUiCJxtVKEbtq/+zZwEjfoQ4FIyY3atcTIZNTtS8ZQ9+X2d4IQcTeAT2IUln9OW
         X78TUvtzeZRJasqIg8qZwN8OMCMjCb7najP9MHk2NyWJ6eABftNwdvGr3F89Rm0pdZBF
         p174c5aDsey9R2lbEcAcQWsii4f5iQk4bK/d3gBF8P18P6YhW4Yh3yxbpxm3hRklAzfD
         fvy9LitG5Ncnhldf7ThRBbCetaCHq54huVnsRuWzEjACNXFtbMI+zLBR8IQd4UEtEIwC
         +/Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709088131; x=1709692931;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f2pVTuxLJ1bF5JkBExEt38LFzKRRlG2j//10dt1o0l8=;
        b=M+ztLvXrZMyRpWPEJwbJAgEyTbrTzT9CyT3X3i/P8HGlwhELFQkZlmMiKWCJvcRDX1
         Jy1OmlnOmhe7GKTtwONNGeuXgcsL9CbZDTspYuXPz3rtE9a9j+WwfAqmpq3cq/V4yisQ
         PfeT3mCQWCpYMR6+933WoMyGi1PRmh2G6XkOWJHbPTx1/JNloGPw+3VOxBD86inSylCI
         TlUVFhMpH4fTm3Tz3BexGJso50Q8wqGSUrh8Oj66JpbP+N1HMPWmn7R6O5BCznmfJF3+
         RXZRfn7U9JhxCwc2P8yS70C0G5blmAZkfgtCPdqd4/kuR1s9iw48QLH9HJCCpL7UX7Yt
         i53Q==
X-Gm-Message-State: AOJu0Ywf70KSq+SKUxfdUNWVNhm44xoMmcx/4+1gpF6HXLmqel0gpedd
	oqWgYSAHB/u1YmapcX4YZv2I+mrFE/ZMnRzB0PsvacOcoJC2tn51N9T2nz5QD/u6l9qr9+T/m71
	q+w==
X-Google-Smtp-Source: AGHT+IGV2/KMUT+5DS/RD3rbrnNhsUrJO/9cIjXu+5lli9rKXWp0tnf2EC/ZhZvoUmnwAPQ8D4qdy5ETdeA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:5714:0:b0:609:3bd3:31fd with SMTP id
 l20-20020a815714000000b006093bd331fdmr118940ywb.2.1709088131111; Tue, 27 Feb
 2024 18:42:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Feb 2024 18:41:42 -0800
In-Reply-To: <20240228024147.41573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240228024147.41573-12-seanjc@google.com>
Subject: [PATCH 11/16] KVM: x86/mmu: Explicitly disallow private accesses to
 emulated MMIO
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly detect and disallow private accesses to emulated MMIO in
kvm_handle_noslot_fault() instead of relying on kvm_faultin_pfn_private()
to perform the check.  This will allow the page fault path to go straight
to kvm_handle_noslot_fault() without bouncing through __kvm_faultin_pfn().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5c8caab64ba2..ebdb3fcce3dc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3314,6 +3314,11 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
 {
 	gva_t gva = fault->is_tdp ? 0 : fault->addr;
 
+	if (fault->is_private) {
+		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+		return -EFAULT;
+	}
+
 	vcpu_cache_mmio_info(vcpu, gva, fault->gfn,
 			     access & shadow_mmio_access_mask);
 
-- 
2.44.0.278.ge034bb2e1d-goog


