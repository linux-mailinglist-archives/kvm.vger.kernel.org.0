Return-Path: <kvm+bounces-46358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A663AB5A06
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 18:35:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7E0716F283
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 16:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78DF22BF990;
	Tue, 13 May 2025 16:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K+5RBGr2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5E72BE7A3
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 16:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747154092; cv=none; b=ZtFBtRfDGN95lnsqdxCrSjZnhX/nuE0lqA+/7FjusNS1dMx9YFWe7kCFZI+ic1ViM/DXfRMewugY1zThEAmbPZ/pcSmJMHSlaLtT/shRXMn62lz2MDKFOhJxmvzVaxjjHt5ihas3DBkJCpTUqwsnPdDrYrjpHRX03+8fRnuBskI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747154092; c=relaxed/simple;
	bh=58ev2u1BDl4Ee9rPaPwyjuTFZN6CiQQdYykTB1lgYAI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lnyo9XH6kOAaKtDHs/9cOg2ZCBlABxFK2bfs2Ywpnx8ojRiWDDbFb4DEZLaBU/TYSpzpL+uQBKujpjCoopDiarPqjrPyLuWUghgIeagBDEOAnAtxULWU08B/Jq5R7tWqCv6P5ozaiMKCIuVMgPuf1TmSFJiAKkKOFS5WO25/i1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K+5RBGr2; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-440a4e2bad7so111845e9.0
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 09:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747154089; x=1747758889; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RemcVjZbjZ9ZPgu+3d5I80Ik2FoSdKLzJPcqSfEXd4g=;
        b=K+5RBGr2jx3cPI1kQ/VfOrM6iFTnVaOWAbXGDCVInyDdyKzHhhAtemdoCTggfaGWyz
         xL0+8JBtJus1eYSqSMHq56+Fmq8EVaJtDcnFRNHrZryCAjXW5Os4M4TpGx2vGI7pAulM
         fEwGs9ef4VGeh5FgyKv/BZFjfT+/qGjWvJBe8qrxCE/6Xxxc76ftsG8DDuCbTFVvG8UQ
         yxeFGnAYAgNHLDEJwa0oqdHukaSoy+MImANhID0wcOddq+KpkdhGa5NjiqCFmEkcUQE7
         ybxZEQqEXABtVYhcjDNfVz8kclRGeqhCj/p58bfeY+x2E8BZxPNv0nqIb8tZp/R69SW4
         pFJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747154089; x=1747758889;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RemcVjZbjZ9ZPgu+3d5I80Ik2FoSdKLzJPcqSfEXd4g=;
        b=FWlsYz86baEr03Mg6CAMey+5N/kmEcYm/0UZ93Ml+3gLrwUWmdWuQ3MTvZLbKg+0DO
         +gn7+0GNQdaKscjf4uaT2RkH4HjusNCIU03pWnhZN4I+FiCzW2whqlcDLJdDtfdDPv4m
         13oNpzmBr6TEr7v9m1+fmkDezgNq1lJGQSSECHnK4gtSDKrbJFt8o6t5re8q0as92gbX
         ptCMGjiO+mhsGVelbLJ6Yup4+YpFP2naHMO0Q2FYaCNPG6ALKMm2SRcxcc/+pD2MMuqe
         nMN5PphOle3LDn14u5q1vFIoybzTZEt+QNALB+RRaQgJOuP8JGqM0SSxTr9it1UyMTB7
         FMig==
X-Gm-Message-State: AOJu0YzDBj0hzOPD7ahLDLuNSqQ4epqCpms4QrmFn2T9S+JfbuwkEgzp
	RONjeEdp+/Sdx5bLXskUmwZ5laN65CZpkC0TcT/o3VbL061FVXoGyag3q5/vKu3iGn7VJQEZs08
	tVRaWv8sK3bzoRDbw5UaMiktOeaZw1jgHJrVbSJz8RYA5ZDI8PVtZqyHIrHvJx07SH08bvIErZJ
	Fpaamuasyo9TQnDBMFm6As5bo=
X-Google-Smtp-Source: AGHT+IFxEwob+8byXmXMbz/khknkrLHMGFrF9iGceLErqSy/3DALfFa6E4jLemK1/8N7omYL7d0nchlvjg==
X-Received: from wmbhj10.prod.google.com ([2002:a05:600c:528a:b0:442:cdb9:da41])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1ca0:b0:43d:5264:3cf0
 with SMTP id 5b1f17b1804b1-442eb8855bcmr27319875e9.11.1747154089111; Tue, 13
 May 2025 09:34:49 -0700 (PDT)
Date: Tue, 13 May 2025 17:34:25 +0100
In-Reply-To: <20250513163438.3942405-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <20250513163438.3942405-5-tabba@google.com>
Subject: [PATCH v9 04/17] KVM: x86: Rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The bool has_private_mem is used to indicate whether guest_memfd is
supported. Rename it to supports_gmem to make its meaning clearer and to
decouple memory being private from guest_memfd.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++--
 arch/x86/kvm/mmu/mmu.c          | 2 +-
 arch/x86/kvm/svm/svm.c          | 4 ++--
 arch/x86/kvm/x86.c              | 3 +--
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4a83fbae7056..709cc2a7ba66 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1331,7 +1331,7 @@ struct kvm_arch {
 	unsigned int indirect_shadow_pages;
 	u8 mmu_valid_gen;
 	u8 vm_type;
-	bool has_private_mem;
+	bool supports_gmem;
 	bool has_protected_state;
 	bool pre_fault_allowed;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
@@ -2254,7 +2254,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
 
 #ifdef CONFIG_KVM_GMEM
-#define kvm_arch_supports_gmem(kvm) ((kvm)->arch.has_private_mem)
+#define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
 #else
 #define kvm_arch_supports_gmem(kvm) false
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b66f1bf24e06..69bf2ef22ed0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3486,7 +3486,7 @@ static bool page_fault_can_be_fast(struct kvm *kvm, struct kvm_page_fault *fault
 	 * on RET_PF_SPURIOUS until the update completes, or an actual spurious
 	 * case might go down the slow path. Either case will resolve itself.
 	 */
-	if (kvm->arch.has_private_mem &&
+	if (kvm->arch.supports_gmem &&
 	    fault->is_private != kvm_mem_is_private(kvm, fault->gfn))
 		return false;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a89c271a1951..a05b7dc7b717 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5110,8 +5110,8 @@ static int svm_vm_init(struct kvm *kvm)
 			(type == KVM_X86_SEV_ES_VM || type == KVM_X86_SNP_VM);
 		to_kvm_sev_info(kvm)->need_init = true;
 
-		kvm->arch.has_private_mem = (type == KVM_X86_SNP_VM);
-		kvm->arch.pre_fault_allowed = !kvm->arch.has_private_mem;
+		kvm->arch.supports_gmem = (type == KVM_X86_SNP_VM);
+		kvm->arch.pre_fault_allowed = !kvm->arch.supports_gmem;
 	}
 
 	if (!pause_filter_count || !pause_filter_thresh)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9896fd574bfc..12433b1e755b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12716,8 +12716,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		return -EINVAL;
 
 	kvm->arch.vm_type = type;
-	kvm->arch.has_private_mem =
-		(type == KVM_X86_SW_PROTECTED_VM);
+	kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
 	/* Decided by the vendor code for other VM types.  */
 	kvm->arch.pre_fault_allowed =
 		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
-- 
2.49.0.1045.g170613ef41-goog


