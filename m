Return-Path: <kvm+bounces-69559-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SLowMbd9e2kQFAIAu9opvQ
	(envelope-from <kvm+bounces-69559-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 16:33:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 87DB6B17C2
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 16:33:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 33FE83022927
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 15:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB3B7315793;
	Thu, 29 Jan 2026 15:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uBC3IBWu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B961F26560D
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 15:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769700777; cv=none; b=FfHUtuN4isxlC7sZJQeJuUciXdby5PjSMvlgpoUGMUyQtejw5ABkiwL6vwwj1/NKe+/gSEw1p39FyhSoqyQxk0TeHsegHM/ZY8m87zGDUgIkZik3eiM/c3mJXKnp5Sbfv9ju12SxT9MjChAKOrAooB1r7Tgdsfg0ApTO5hrzG5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769700777; c=relaxed/simple;
	bh=9S2As/HXzHxL2v62TjOZCZxd2DQ7lWQ3rjtr/Gdhi8c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=BkELukiFAxyeR3lcpIA70xh6mAeTV3vb7f3LojUUhA+iblEc1qcjp4GLtLb2djlfRcQxdNLjJw9JkW2db7djrQJw9UjAJnD33Dc93F03rvVSnpDNAit8TDcjeiwtT/YVZyPLm/vX58Y81QEW5EaTzqvf75IyorfmjBuTUbiNdAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uBC3IBWu; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-81ed3e6b917so982947b3a.1
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 07:32:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769700775; x=1770305575; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pUYJw4c3pdE7hwG9tr+c2v9CH1+8NBV9hRmRkDwEMLY=;
        b=uBC3IBWu+I5Oo6rXFv0OIL4cdA6PKbOFjoFI1aUeIVbCRFnGAsO8y5NfsQFcJxEWsl
         SRLcvaQ5ndWUT1mm46nNvIlfSuDYQP6W3/j7UlfPzfwl3y/8aUNxQ90mUdRgfS+Inv2g
         Ll9HpG8Pf5lJxlwqqC4Rx4zMug2I23Y/WhtRNNeAR2fJvVSSPBfSv1GZEKTL0n8L7sAT
         wzrGUKc0vBYF1fo+7qUDoRI6MNM0PvwzLzVQxSmdp9MMXmNzdwxcl8YxJ4/thVA4djP1
         KRjia1ezE2K9eGPDYSEx62uW4KBAC1ux78Xp2mb8FDZX6Sa8Fkb1MMxc0+owCCVfvYFV
         gvPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769700775; x=1770305575;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pUYJw4c3pdE7hwG9tr+c2v9CH1+8NBV9hRmRkDwEMLY=;
        b=m0D2+IUbsjubwvRzOqW2HP+FRM+/RWY8OEQScxunVD+WHbA2MAuzEOdtXVvFZXVO2s
         VmMQGLRWveWCR8qmeVdncvBO1z9odu6i//BU35glR06UqoFCXw/tg7qTVCEDmiBcHdPQ
         lThMu9w0jxLn6UPmhp2iCxLMYGNs1l9V6YXyzd0kk7UE15V9VuiebHwB+UTOYXW/g3eJ
         1HmGVrovPLqw79gpQBeGZ7WVEJLxy8U9voH4LLpDGUYerc5TPaHwts3m5mtgZUpOU+K2
         7I1Wo4tH4QuvwrKQtPbYX4rjnjTdqMXWH7dKQCzjvwdRIFuLhGkRbQvSQYsL675iIXrK
         DACg==
X-Forwarded-Encrypted: i=1; AJvYcCXLUt+ewipZzn6uxSSFGum7Npd1rDae5pEOWmaKPHBzTFdzpdLjFUgMHQpVsAwmPKw29fM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZl8kimi9N46ofSz0N1ucebvM2vRyBlm/WnntngL8czmg++6pN
	Ibq4FPIdpZn7XFyrFdC+n+MzUbBBPGoFPHMUHPw8HfyR95iqpRrp5RTtFvP+WzfhwqkdXgK3r/Y
	QhWfrCQ==
X-Received: from pfbi1-n1.prod.google.com ([2002:a05:6a00:a501:10b0:7b8:e204:9940])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3a1a:b0:7ac:edc4:fb82
 with SMTP id d2e1a72fcca58-8236915f3eemr8019448b3a.5.1769700774790; Thu, 29
 Jan 2026 07:32:54 -0800 (PST)
Date: Thu, 29 Jan 2026 07:32:53 -0800
In-Reply-To: <20260129011517.3545883-42-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-42-seanjc@google.com>
Message-ID: <aXt9pfN8uGLX2c-o@google.com>
Subject: Re: [RFC PATCH v5 41/45] KVM: TDX: Honor the guest's accept level
 contained in an EPT violation
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Sagi Shahar <sagis@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69559-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 87DB6B17C2
X-Rspamd-Action: no action

On Wed, Jan 28, 2026, Sean Christopherson wrote:
> +int kvm_tdp_mmu_split_huge_pages(struct kvm_vcpu *vcpu, gfn_t start, gfn_t end,
> +				 int target_level)
> +{
> +	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);

This is wrong, mmu->root.hpa is the shared root, not the mirror root.  Dittof for
the sanity check in tdx_handle_mismatched_accept().

Rather than operate on the vCPU's root, I think it makes sense to add an API to
operate on all mirror roots.  In practice, there can only be one valid mirror
root, so KVM isn't actually doing more work.  Then TDX can reuse that API for
splitting the head+tail pages when preparing for a partial shared=>private
conversion.

Slotted in before this patch:

---
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 Jan 2026 15:21:30 +0000
Subject: [PATCH] KVM: x86/mmu: Add a TDP MMU API to split hugepages for mirror
 roots

Add an exported API to split hugepages in mirror roots for a given gfn
range.  TDX will use the API to split hugepages in preparation for
partially converting a hugepage from private to shared, and for splitting
a hugepage to match the guest's ACCEPT level.

For all intents and purposes, no functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 39 ++++++++++++++++++++++++++++----------
 arch/x86/kvm/mmu/tdp_mmu.h |  2 ++
 2 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e32034bfca5a..a45d8ee91481 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1597,6 +1597,26 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 	return 0;
 }
 
+static int tdp_mmu_split_huge_pages(struct kvm *kvm, int as_id,
+				    enum kvm_tdp_mmu_root_types type,
+				    gfn_t start, gfn_t end,
+				    int target_level, bool shared)
+{
+	struct kvm_mmu_page *root;
+	int r;
+
+	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
+
+	__for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, type) {
+		r = tdp_mmu_split_huge_pages_root(kvm, root, start, end,
+						  target_level, shared);
+		if (r) {
+			kvm_tdp_mmu_put_root(kvm, root);
+			return r;
+		}
+	}
+	return 0;
+}
 
 /*
  * Try to split all huge pages mapped by the TDP MMU down to the target level.
@@ -1606,18 +1626,17 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
 				      gfn_t start, gfn_t end,
 				      int target_level, bool shared)
 {
-	struct kvm_mmu_page *root;
-	int r = 0;
+	tdp_mmu_split_huge_pages(kvm, slot->as_id, KVM_VALID_ROOTS, start, end,
+				 target_level, shared);
+}
 
-	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
-	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id) {
-		r = tdp_mmu_split_huge_pages_root(kvm, root, start, end, target_level, shared);
-		if (r) {
-			kvm_tdp_mmu_put_root(kvm, root);
-			break;
-		}
-	}
+int kvm_tdp_mmu_mirrors_split_huge_pages(struct kvm *kvm, gfn_t start,
+					 gfn_t end, int target_level)
+{
+	return tdp_mmu_split_huge_pages(kvm, 0, KVM_MIRROR_ROOTS, start, end,
+					target_level, false);
 }
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_tdp_mmu_mirrors_split_huge_pages);
 
 static bool tdp_mmu_need_write_protect(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index bd62977c9199..a6919de10ca2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -97,6 +97,8 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
 				      const struct kvm_memory_slot *slot,
 				      gfn_t start, gfn_t end,
 				      int target_level, bool shared);
+int kvm_tdp_mmu_mirrors_split_huge_pages(struct kvm *kvm, gfn_t start,
+					 gfn_t end, int target_level);
 
 static inline void kvm_tdp_mmu_walk_lockless_begin(void)
 {

base-commit: 86c3bb72bf5c6201636529ee4609334b0887c6e3
--

