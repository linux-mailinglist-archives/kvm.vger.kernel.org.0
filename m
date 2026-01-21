Return-Path: <kvm+bounces-68668-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iJakI8MicGlRVwAAu9opvQ
	(envelope-from <kvm+bounces-68668-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 01:50:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 08A784EB2D
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 01:50:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0C0D456ED0F
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 00:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C41B2DECC6;
	Wed, 21 Jan 2026 00:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MdXI6nFo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1890D2D6E61
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 00:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768956555; cv=none; b=CiBwnoNQsuljrKnTY9lDOoJo6JrwootwDXa1CodGGFFI2RaRtr1pKdNgetTs/UaBBQzP+XVzFuyGmcD1mMwSqstmGc4ctKAgimHa8SI+Lfxm3rv+Q/pTpL2C+iaaM+b5HGLEVtiXpWraD0CczZ4nylAD6xIZuEDxN2tXAMPgSnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768956555; c=relaxed/simple;
	bh=8+uIZSqlXXQKdn+9D43f0JkLNHcfQpFz3iTtSwts8F4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aizlK9LrRtylfFvBPC2oiKB6Pp/s53Ca7bxMOoJmJ0mog7kxxnyRcAS/Oxrrqj7ZNiouSkIjBl4NgKG/a97HaEl02RvkaFpMIDaYuPvjfxvBF6TJXp5Ymdv1ckBWcab7k3cT0llSOplVkzXhGyJKdw8uLOn+0nI+Oheo9XU7FeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MdXI6nFo; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a7701b6328so17918085ad.2
        for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 16:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768956553; x=1769561353; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B9A0uaN2rgkGfdKNQFfg8E7Wg30wKU7IVFo7DdNgHmw=;
        b=MdXI6nFo7suXV/eDwFF6xFtMlUF/A0aULQMVvEewTIfBQULOap73YsKgn0C1f2Tprx
         2tDzZhNxxvf+QpGtp5e+CeJ4RnlScARcxFE6bXf95QxNTDSgeOpXM7OEOazI6wYyPBi6
         VREydTn7+C1KCtIM+HnkuW66mVN/ZzJp49LUhv/L4jyoU98SFmGQIYBBOBaWUIVSZyP0
         4l+rmkuKlixhWFiY9435MvtZIB425wfWkd/d178t25jtkZMwArTpEKCorkCmyuwPC8jD
         PVVN9ZmpVsWC/FJMe1rLyq8SMouf+WCJWk5vS2t98cy0JTbfGNXOuizyQF46Qhh0az3s
         G2zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768956553; x=1769561353;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B9A0uaN2rgkGfdKNQFfg8E7Wg30wKU7IVFo7DdNgHmw=;
        b=UzW50virsVzjiiaIjfxYIjOp0ZzhXRjktp/QQjzxTKCxtpwrkIyQxtZ2uONnRZATrH
         ZyBIE1iE+Epu1nzhy90mM0mY87NcDIpII0DET+uleek3f4StEontFjFFGem8PSZyJalk
         FcgluRDkkBJzTtxpyk1upxrwA5yYa8NWBECdd3IIW/DWVF+tqvebvyU4sYfVf9WC74tY
         zS90Ao9AwwljrmJmhU8xbN55uVYuPmRsBkXbb3Q4IjMSA0KCWNIwOAUKbGPsoLz+c80U
         TQMMQf5+ucTm1joxUvFQJISX9jcQXVrDjS77ZsmuULKKljL179U5H6biveosLcLmCcJ/
         jwNQ==
X-Gm-Message-State: AOJu0Yy5IIwqDKm7PZs2pZgm49sU1jq1Vt5gN2F206wQtX/IeNmUxLhB
	le05EohyJYxC5XnwqDj++hb82YVN5GxWeF+4/NK73bJWxKAUK/jCIKFVjQQhMcu7vEU248hG3pz
	ugaDAQpHfu8zBuw==
X-Received: from plgu10.prod.google.com ([2002:a17:902:e80a:b0:2a0:7f81:6066])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:178e:b0:2a0:d692:5681 with SMTP id d9443c01a7336-2a7698f6d19mr28698605ad.24.1768956553486;
 Tue, 20 Jan 2026 16:49:13 -0800 (PST)
Date: Wed, 21 Jan 2026 00:49:05 +0000
In-Reply-To: <20260121004906.2373989-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260121004906.2373989-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260121004906.2373989-3-chengkev@google.com>
Subject: [PATCH 2/3] KVM: selftests: Add TDP unmap helpers
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.46 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68668-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 08A784EB2D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add __virt_pg_unmap(), __tdp_unmap(), and tdp_unmap() as counterparts
to the existing __virt_pg_map(), __tdp_map(), and tdp_map() functions.
These helpers allow tests to selectively unmap pages from the TDP/NPT,
enabling testing of NPT faults for unmapped pages.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 .../selftests/kvm/include/x86/processor.h     |  6 +++
 .../testing/selftests/kvm/lib/x86/processor.c | 53 +++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 6bfffc3b0a332..23ec5030a1d1f 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1487,6 +1487,12 @@ void tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr, uint64_t
 void tdp_identity_map_default_memslots(struct kvm_vm *vm);
 void tdp_identity_map_1g(struct kvm_vm *vm,  uint64_t addr, uint64_t size);
 
+void __virt_pg_unmap(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
+		     int level);
+void __tdp_unmap(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t size,
+		 int level);
+void tdp_unmap(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t size);
+
 /*
  * Basic CPU control in CR0
  */
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index ab869a98bbdce..8cb0d74aaa41e 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -338,6 +338,40 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	}
 }
 
+void __virt_pg_unmap(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
+		     int level)
+{
+	uint64_t *pte = &mmu->pgd;
+	int current_level;
+
+	TEST_ASSERT(level >= PG_LEVEL_4K && level <= mmu->pgtable_levels,
+		    "Invalid level %d", level);
+
+	/* Walk down to target level */
+	for (current_level = mmu->pgtable_levels;
+	     current_level > level;
+	     current_level--) {
+		pte = virt_get_pte(vm, mmu, pte, vaddr, current_level);
+
+		TEST_ASSERT(is_present_pte(mmu, pte),
+			    "Entry not present at level %d for vaddr 0x%lx",
+			    current_level, vaddr);
+		TEST_ASSERT(!is_huge_pte(mmu, pte),
+			    "Unexpected huge page at level %d for vaddr 0x%lx",
+			    current_level, vaddr);
+	}
+
+	/* Get the PTE at target level */
+	pte = virt_get_pte(vm, mmu, pte, vaddr, level);
+
+	TEST_ASSERT(is_present_pte(mmu, pte),
+		    "Entry not present at level %d for vaddr 0x%lx",
+		    level, vaddr);
+
+	/* Clear the PTE */
+	*pte = 0;
+}
+
 static bool vm_is_target_pte(struct kvm_mmu *mmu, uint64_t *pte,
 			     int *level, int current_level)
 {
@@ -541,6 +575,25 @@ void tdp_identity_map_1g(struct kvm_vm *vm, uint64_t addr, uint64_t size)
 	__tdp_map(vm, addr, addr, size, PG_LEVEL_1G);
 }
 
+void __tdp_unmap(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t size,
+		 int level)
+{
+	size_t page_size = PG_LEVEL_SIZE(level);
+	size_t npages = size / page_size;
+
+	TEST_ASSERT(nested_paddr + size > nested_paddr, "Address overflow");
+
+	while (npages--) {
+		__virt_pg_unmap(vm, &vm->stage2_mmu, nested_paddr, level);
+		nested_paddr += page_size;
+	}
+}
+
+void tdp_unmap(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t size)
+{
+	__tdp_unmap(vm, nested_paddr, size, PG_LEVEL_4K);
+}
+
 /*
  * Set Unusable Segment
  *
-- 
2.52.0.457.g6b5491de43-goog


