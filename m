Return-Path: <kvm+bounces-9412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A821A85FDC3
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:13:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 06235B265A8
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:13:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 365621534F6;
	Thu, 22 Feb 2024 16:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s5QAh8H2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCCA1552FF
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618292; cv=none; b=I9+AsC+I22mdg2C1bgyk9MjH5jb4f5XOefdLQaxB9fphLbvVf7Zi+j97xnWDwUmudK1EZzP4nVIS3o4jMCnryyQoxt/uIkH0o9e36T0yU4YS44uIB+/WRWM5gF2v66W57OxAAQwF9RCfv8ZVF8pf9cnyY0zD6B4/AjN1siMdbqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618292; c=relaxed/simple;
	bh=P3DcGgFx1Esbt3sQL+P8sgYw965ej+0hqQQdppF2RNk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fSVb9w+6/mSiukk/RVAoVFf8NKLVoybkLl/MjXG8hqEa7XCLOZrWeAUGwibsGBjGrNe45qcfCoQkTjBCQSsZ48nSPIUkSBzOGNKU1RonKfReQwF63pCXoWKbOfY/iszA+7T53cgVe+NSML10cMFS3nPQX7fCgbiOXtdeTf59n6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s5QAh8H2; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-33d4cf786a2so2046077f8f.1
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 08:11:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618289; x=1709223089; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cv9AuM4saXbATXwsstWXJV9w/3pxWYR1H2v53ay0HfU=;
        b=s5QAh8H2Vn/+U7kXL8BaDY4Q6v7tS8WD7wPFj7wQ04TJodkZfNGoaA4ao06lnoI4j4
         3qrQSh8sTB0fKQOShRvTENBH7oyL9MLSJAg71A98CA2XgJ6QJ2zpRalLdfpqpPyj0QWf
         5C5GQZt9jIgCLox94fuFXKWoJdduNv1Ribck2fqFhDntweeCPmHz3xkRFgtLyA9d50gg
         +uoVktjJqf9MbfH/i4U9oBEvAqOgvC8xiGWzqGfbhv00LV4dtOzDP0TrdPdixRn1yjHY
         DWS9KGPfTmzltPDMg6Z7F2EY6nugB+Iad2EIJXec7aj6XE0uckoaOzxQsnOTkLdfiJah
         IHrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618289; x=1709223089;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cv9AuM4saXbATXwsstWXJV9w/3pxWYR1H2v53ay0HfU=;
        b=O41pxI8XsaC09J+fOKRt4JhT7dM8A//0ozU213U+87wT1VbpmbfKcns6Hct472wacL
         naFwc7yP3kaaAYqXMCNoKfZomvJu0eGctLzr1Ns8ErOqhVmhgbup/ZWMVCN+vfYuvXl8
         tyGpIWQUZtUsZtrtAmtJ+SfcGc0qVZYetkjX9WUjc3Jb7xUZ6Wb9BT7wQwidPhSowXBN
         yrHzu1RkApR/ZBzpmXwyTK31zVyYJ3pJ3gLO8D9xSI6+PZZz3Z2jI1acemJ833YqSTze
         cb2Wh5RqOEtCCJZ+rz9EjeHOHtdUnJGWFUuSXwJkWACyn2Ww/xqCtImBfqsEQN1ytV20
         nOXA==
X-Gm-Message-State: AOJu0YwMiSTkVfOiu5R6n0vfNsMoKBJY8NIUgiFF60FwK5lQBoO8q9+F
	MEQJE8nfrd6BwAdnRowLOGjkMy5Rr9jY17s7gWo0h0SxpltZjDdkBQOFjcaHd+BGVwNW8uX4K6X
	jJYEFvq/FkOJWjr5yfKyXs681iV3tONlGI99/oSUusCOx5gpmhRcbDScIAa2BLQ52TsulnJJuI1
	+HHue+uDMQevut6hBpz5L8f9o=
X-Google-Smtp-Source: AGHT+IHZJHrajzF3EdpiiEZnjfvNIhoCy7C/iyvPxzB5DChrxwU0aVBoojhrAAAyoesSkpogr4EI2GCUFg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:b613:0:b0:33d:19b6:30b0 with SMTP id
 f19-20020adfb613000000b0033d19b630b0mr34674wre.8.1708618288892; Thu, 22 Feb
 2024 08:11:28 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:37 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-17-tabba@google.com>
Subject: [RFC PATCH v1 16/26] KVM: arm64: Add a field to indicate whether the
 guest page was pinned
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

This is needed only during the transition phase from pinning to
using guestmem. Once pKVM moves to guestmem, this field will be
removed.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/mmu.c              | 1 +
 arch/arm64/kvm/pkvm.c             | 6 ++++--
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 99bf2b534ff8..ab61c3ecba0c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -210,6 +210,7 @@ struct kvm_guest_page {
 	struct rb_node		node;
 	struct page		*page;
 	u64			ipa;
+	bool			is_pinned;
 };
 
 typedef unsigned int pkvm_handle_t;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ae6f65717178..391d168e95d0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1502,6 +1502,7 @@ static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	ppage->page = page;
 	ppage->ipa = fault_ipa;
+	ppage->is_pinned = true;
 	WARN_ON(insert_ppage(kvm, ppage));
 	write_unlock(&kvm->mmu_lock);
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 0dbde37d21d0..bfd4858a7bd1 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -271,7 +271,8 @@ void pkvm_destroy_hyp_vm(struct kvm *host_kvm)
 					  page_to_pfn(ppage->page)));
 		cond_resched();
 
-		unpin_user_pages_dirty_lock(&ppage->page, 1, true);
+		if (ppage->is_pinned)
+			unpin_user_pages_dirty_lock(&ppage->page, 1, true);
 		node = rb_next(node);
 		rb_erase(&ppage->node, &host_kvm->arch.pkvm.pinned_pages);
 		kfree(ppage);
@@ -362,6 +363,7 @@ void pkvm_host_reclaim_page(struct kvm *host_kvm, phys_addr_t ipa)
 				  page_to_pfn(ppage->page)));
 
 	account_locked_vm(mm, 1, false);
-	unpin_user_pages_dirty_lock(&ppage->page, 1, true);
+	if (ppage->is_pinned)
+		unpin_user_pages_dirty_lock(&ppage->page, 1, true);
 	kfree(ppage);
 }
-- 
2.44.0.rc1.240.g4c46232300-goog


