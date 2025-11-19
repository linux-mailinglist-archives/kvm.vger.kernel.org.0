Return-Path: <kvm+bounces-63757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 28A32C71585
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 23:47:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 111C2351A2C
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 22:45:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F6AA332EA3;
	Wed, 19 Nov 2025 22:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="gn5UXjfE"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E533126D1;
	Wed, 19 Nov 2025 22:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763592169; cv=none; b=Xra7MNfwTOHbZtItmeaHdOO3KyE5veOj4xmZiX1QDQ2q66Nrw6BiE62e2whtSzt3CzAiO4/fI6QHLe3BbwKRbN4TRSZsOvD72cUERrvnD+N0ZPQuz9EI0Jc8jprjkPlukH+WvM0nM48n6msg4puUl4ielM2fQE1WXBnW8T5Y3cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763592169; c=relaxed/simple;
	bh=sKT1pp0kXgC9eDN7tUsZHEvBOw4i30duGD5WD7ELpo4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AIKb63FNdMYxYeonPMCGaD/ayR0MNC2GWn2EH5sLMOmLwBM/E7/YO5LJiEm9QIZ/GndsPXtEFrfV+7tItXWK850vMAZNFR75ixpzrFFuHvrTePSKD1ufFnwivkOnbk3gV2jnzAYgkEx0lWLuOzQFtujxRUsk5kQ/Ld8FOpaMYXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=gn5UXjfE; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1vLqso-006yp4-NH; Wed, 19 Nov 2025 23:42:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
	:Message-Id:Date:Subject:Cc:To:From;
	bh=Qm5JY2mMJkohgmQ/bUwBjPkYq8QhcEnzUcW/mrBnhJ4=; b=gn5UXjfEU2284sEBoGiWjavm4X
	EB/7NLMjxofZMbQwQ91xNRSXeDP9YESyj5W6el8R8X67GJZcrt4gQ7YUktrH+S2U/CKIxfIqVe1iV
	cXgnNU/7iCR1YeGdq0yZ/KeZJJtd4/GfIx/2oivr/VBcaX77HairvKASZTS3dCv3w8SbA65a1gSgh
	k+dyHhG+YX1OSY7ZCIrZBEJa32bXvlm9NmoMDuLl0CpHvxF+qhJkC8aue6C/EpCksC31xgHceJggI
	uNvDHxRp876h66LBm63lxSMlyc1T1fF04qODV2lwPrwnlWWP0EziKUq1TlQx40u2xtitRwKCOljEk
	/bwFtaiA==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1vLqsn-00007D-Es; Wed, 19 Nov 2025 23:42:38 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vLqsZ-00Fos6-Mj; Wed, 19 Nov 2025 23:42:23 +0100
From: david.laight.linux@gmail.com
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	x86@kernel.org,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH 11/44] arch/x96/kvm: use min() instead of min_t()
Date: Wed, 19 Nov 2025 22:41:07 +0000
Message-Id: <20251119224140.8616-12-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251119224140.8616-1-david.laight.linux@gmail.com>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

min_t(unsigned int, a, b) casts an 'unsigned long' to 'unsigned int'.
Use min(a, b) instead as it promotes any 'unsigned int' to 'unsigned long'
and so cannot discard significant bits.

In this case the 'unsigned long' value is small enough that the result
is ok.

(Similarly for max_t() and clamp_t().)

Use min3() in __do_insn_fetch_bytes().

Detected by an extra check added to min_t().

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
 arch/x86/kvm/emulate.c | 3 +--
 arch/x86/kvm/lapic.c   | 2 +-
 arch/x86/kvm/mmu/mmu.c | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 4e3da5b497b8..9596969f4714 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -861,8 +861,7 @@ static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
 	if (unlikely(rc != X86EMUL_CONTINUE))
 		return rc;
 
-	size = min_t(unsigned, 15UL ^ cur_size, max_size);
-	size = min_t(unsigned, size, PAGE_SIZE - offset_in_page(linear));
+	size = min3(15U ^ cur_size, max_size, PAGE_SIZE - offset_in_page(linear));
 
 	/*
 	 * One instruction can only straddle two pages,
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0ae7f913d782..b6bdb76efe3a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1894,7 +1894,7 @@ static inline void __wait_lapic_expire(struct kvm_vcpu *vcpu, u64 guest_cycles)
 	} else {
 		u64 delay_ns = guest_cycles * 1000000ULL;
 		do_div(delay_ns, vcpu->arch.virtual_tsc_khz);
-		ndelay(min_t(u32, delay_ns, timer_advance_ns));
+		ndelay(min(delay_ns, timer_advance_ns));
 	}
 }
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 667d66cf76d5..989d96f5ec23 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5768,7 +5768,7 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 	root_role = cpu_role.base;
 
 	/* KVM uses PAE paging whenever the guest isn't using 64-bit paging. */
-	root_role.level = max_t(u32, root_role.level, PT32E_ROOT_LEVEL);
+	root_role.level = max(root_role.level + 0, PT32E_ROOT_LEVEL);
 
 	/*
 	 * KVM forces EFER.NX=1 when TDP is disabled, reflect it in the MMU role.
-- 
2.39.5


