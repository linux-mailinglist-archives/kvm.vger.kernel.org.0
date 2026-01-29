Return-Path: <kvm+bounces-69489-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KHSbGAK3emkr9gEAu9opvQ
	(envelope-from <kvm+bounces-69489-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:25:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DC388AAB02
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:25:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0C2FF30F85F7
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:20:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C0E1377563;
	Thu, 29 Jan 2026 01:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eq19XCw9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BAF37646B
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649401; cv=none; b=F4CMQ3CZEUwl839IL7CKRV9VjKd79pLtE9tOMN5WhlTEuQfPkxWKEYw/OZqtlAJdmeh/HVp9eul42/YHL9AohzU5G+PdUeJYEB9794Rouzyr763SO85fKww3lxtyu8ryfSVqtTGf0WGEtTNxhemWsqxLIrwEGMAjYddF9u2V3EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649401; c=relaxed/simple;
	bh=E81ZhmT2t0PJD5dbqVBjf6xweJIj6b/NPrrZPd0lj4k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sSiv2w2MQuYR6MOcUWXwRLyV15HCGA5lXGKZ9HRPz4edgsumFn5+eFjL67gWQJJTGLHXVq51tRTp1orNqAIUrj2xQHjB5sDIs45duro97Y/BMq0W5jroIitgYWsRULHtmNvAVifiIJ6+5Qot8/6innNTensoFAUo5CpYacNN9Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eq19XCw9; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-81f3fb8c8caso1171337b3a.1
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649400; x=1770254200; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4KWczVW3BK+JCRmXurxu5hKVHytxWOCNoKeowZmDwwM=;
        b=eq19XCw9ByLa0Fhtodu7upOCibpeL/vACstyYEa+YcjJoAkedHpXo2AxfvjseOQu2D
         WIKp3SL3FTnew9zbjYBAr5tsAeCr9+aKmH8g0b5M4wFG+sa0kSCkTdKAxyGa59Gc5Huk
         wuP6yayJ9s9iYCQf2hpWU1Wvs+S/EFRmipvHnhlEK10VpSjtUo23KDEHeWgrQApcK9fd
         xcv7G2nGsv84MPfJygHnH6pgPcJ/P6dSKbR5q4hZUjHk9KWHEx8Y4GwACDa5j1wDXazE
         r57SjR62f9E6pyUMALl7aDHgCnAnbhd3WJzml5QEfZDgz31eHwzRU5G0NIVfvwolIStz
         tsvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649400; x=1770254200;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4KWczVW3BK+JCRmXurxu5hKVHytxWOCNoKeowZmDwwM=;
        b=o2E2n5AmOeZT0PVHgi8aY6GeRrI6BrYpKFQA4IBRBlh53pP7vFxpRuAz3rVnAm+N2n
         Kk5Cjfhj/QS39DSaJiXxdv/KmpXLFfkgoOTPo/3j2sizrCu8jh36K4kLX23Gz0sIfGio
         e67hmpFs5PtmcXrdhKRiJfG5mHFYCUQZv5GzSkDPls6jfz3NFL1evgaJQcUkDRduUL6z
         UgGWFfcCnzZrOV675Lyh8rSRPsZM4fGYwDYsDL5j7XmKmSpuc0ZgGHxjTOEA6ijuPRER
         9XgQ1w0FmfuOrhVCJMwdtXaPcNi7FtZFqeiutFyYX4mKEFL52D+xJFn7TzNYmAQOkWRZ
         4izA==
X-Forwarded-Encrypted: i=1; AJvYcCW/uHFOvVQUJVxx0H1pHF3qa2OlqP9QwMrgHrOQo19RkG+Fy0vn3Ea8D7dPeEs4Ad+L7wE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLNDQxdWR/YTaA3QfsQJmKZQvTg84kkPrlV/ivj4no5en3vFHs
	cG9y4IjZWihdqzzeCzTOczu3EAYPUv/aRvcY0cCPBV/SyymO0k/zzXmf0yUoOJFmB291kdqOTXe
	MSsNU7g==
X-Received: from pfcy16.prod.google.com ([2002:a05:6a00:93d0:b0:823:747:7567])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3d14:b0:81b:1a87:9eb9
 with SMTP id d2e1a72fcca58-823691866damr6265136b3a.25.1769649399557; Wed, 28
 Jan 2026 17:16:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:15:10 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-39-seanjc@google.com>
Subject: [RFC PATCH v5 38/45] KVM: x86/mmu: Add Dynamic PAMT support in TDP
 MMU for vCPU-induced page split
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Kai Huang <kai.huang@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69489-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: DC388AAB02
X-Rspamd-Action: no action

Extend the TDP MMU to support vCPU-induced hugepage splits in mirror roots
when Dynamic PAMT is enabled.  I.e. top-up the PAMT cache when allocating
a new child page table, so that if the split is successful, there will be
a PAMT paging waiting to associated with the new less/non-huge mapping.

Note, the allocation is for the guest memory, not the S-EPT page, as PAMT
pages are accounted up front by .alloc_external_sp().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 25 ++++++++++++++++---------
 arch/x86/kvm/vmx/tdx.c     |  3 +++
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4f5b80f0ca03..e32034bfca5a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1456,21 +1456,28 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct tdp_iter *iter)
 		return NULL;
 
 	sp->spt = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
-	if (!sp->spt) {
-		kmem_cache_free(mmu_page_header_cache, sp);
-		return NULL;
-	}
+	if (!sp->spt)
+		goto err_spt;
 
 	if (is_mirror_sptep(iter->sptep)) {
 		sp->external_spt = (void *)kvm_x86_call(alloc_external_sp)(GFP_KERNEL_ACCOUNT);
-		if (!sp->external_spt) {
-			free_page((unsigned long)sp->spt);
-			kmem_cache_free(mmu_page_header_cache, sp);
-			return NULL;
-		}
+		if (!sp->external_spt)
+			goto err_external_spt;
+
+		if (kvm_x86_call(topup_external_cache)(kvm_get_running_vcpu(), 1))
+			goto err_external_split;
 	}
 
 	return sp;
+
+err_external_split:
+	kvm_x86_call(free_external_sp)((unsigned long)sp->external_spt);
+err_external_spt:
+	free_page((unsigned long)sp->spt);
+err_spt:
+	kmem_cache_free(mmu_page_header_cache, sp);
+	return NULL;
+
 }
 
 /* Note, the caller is responsible for initializing @sp. */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 59b7ba36d3d9..e90610540a0b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1625,6 +1625,9 @@ static int tdx_topup_external_pamt_cache(struct kvm_vcpu *vcpu, int min)
 	if (!tdx_supports_dynamic_pamt(tdx_sysinfo))
 		return 0;
 
+	if (WARN_ON_ONCE(!vcpu))
+		return -EIO;
+
 	return tdx_topup_pamt_cache(&to_tdx(vcpu)->pamt_cache, min);
 }
 
-- 
2.53.0.rc1.217.geba53bf80e-goog


