Return-Path: <kvm+bounces-53883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BD33B19BAC
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 08:45:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DE89175ACA
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 06:44:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAFF3230BF8;
	Mon,  4 Aug 2025 06:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=raymakers.nl header.i=@raymakers.nl header.b="ljriQIfU"
X-Original-To: kvm@vger.kernel.org
Received: from dane.soverin.net (dane.soverin.net [185.233.34.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCEA22F762
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 06:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.233.34.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754289880; cv=none; b=YRYX/tju1Vwljg9tJGyY9pGoZaDtdy02cmZiPyhQOTmNKSCgp0uEr5FsRifLWj6RUS+RW/cRygepfYhc+gfZEBeIsyL2FbuLRuaUH8v0fVYPLM1vEHE46eLZizGaRm9RlL6GdmSFIXhYQBdJImTOvr5jBM9+HuRF8SGmokgak0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754289880; c=relaxed/simple;
	bh=wozeUlwN/Lku5dt1tm6eW49oJ+4U8/mgut92ET2TvIA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jyu4ImjujxufLton1gxav8rJj7skv1qUoQ1V6gfD3S3bXnQ/Zi1CMDnUa3M9VwKx3QpZ1VTrKvG6duBygqMcXr0mK0y9vLeVJybd7DoNV1ftQkudZTo2CRmjuLwKP3UDkMrx8T3CooIK1ubkfanad5yQP3rjndPriJFEo5ohV14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=raymakers.nl; spf=pass smtp.mailfrom=raymakers.nl; dkim=pass (2048-bit key) header.d=raymakers.nl header.i=@raymakers.nl header.b=ljriQIfU; arc=none smtp.client-ip=185.233.34.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=raymakers.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raymakers.nl
Received: from smtp.soverin.net (unknown [10.10.4.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(No client certificate requested)
	by dane.soverin.net (Postfix) with ESMTPS id 4bwRqd2kStz1B2Z;
	Mon,  4 Aug 2025 06:44:29 +0000 (UTC)
Received: from smtp.soverin.net (smtp.soverin.net [10.10.4.99]) by soverin.net (Postfix) with ESMTPSA id 4bwRqc50Gqz6D;
	Mon,  4 Aug 2025 06:44:28 +0000 (UTC)
Authentication-Results: smtp.soverin.net;
	dkim=pass (2048-bit key; unprotected) header.d=raymakers.nl header.i=@raymakers.nl header.a=rsa-sha256 header.s=soverin1 header.b=ljriQIfU;
	dkim-atps=neutral
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raymakers.nl;
	s=soverin1; t=1754289869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ifira4om5kYW3pZY0Zj1C+H2aWyqpWnLUsETtTp9N+8=;
	b=ljriQIfUuzKMmIS4YAO5Jxl5CmAGcTnwzt8IsZMULiKGmlFuPWai7qI7g1rbGpwPDomkz2
	IqMRdBZGKQmJH55314iQ12mG2xe1uKhu5WjgaIi/X/Vhq04xgzeZW57JQ0uznWP9rtnS9r
	/3iO8Ni+WgHP9ssP6kb7ZVKc1YsShxxTxet1uejAIEbGO03+Un6W9OOlmIyUmh7GRyR87c
	APn8n6eGwVc1XzyFUVyRnFJ6ICGiEzmqHQkm+9+wCNqv/ud87O0fO9mlPaB/SkSkzOTQtC
	MfDy4A1FcWh2KlidQ04mEVi2RcbkPbWZd3oakSAUikfF5aynHmncLdohxSP1hw==
X-CM-Analysis: v=2.4 cv=I7afRMgg c=1 sm=1 tr=0 ts=689056cd a=eMcEbXDZAAAA:8 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=20KFwNOVAAAA:8 a=ag1SF4gXAAAA:8 a=POubyX8G1R7Sw8sTc0oA:9 a=Ff6uVGclmHxgYidJvOUY:22 a=Yupwre4RP9_Eg_Bd0iYG:22
From: Thijs Raymakers <thijs@raymakers.nl>
To: kvm@vger.kernel.org
Cc: Thijs Raymakers <thijs@raymakers.nl>,
	stable <stable@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v3] KVM: x86: use array_index_nospec with indices that come from guest
Date: Mon,  4 Aug 2025 08:44:05 +0200
Message-ID: <20250804064405.4802-1-thijs@raymakers.nl>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spampanel-Class: ham

min and dest_id are guest-controlled indices. Using array_index_nospec()
after the bounds checks clamps these values to mitigate speculative execution
side-channels.

Signed-off-by: Thijs Raymakers <thijs@raymakers.nl>
Cc: stable <stable@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Sean C. correctly pointed out that max_apic_id is inclusive, while
array_index_nospec is not.

Changes in v3:
- Put the diff and the changes to the feedback in a single patch, instead
  of spreading it out over multiple emails.
- Remove premature SoB.
- Not sent as a In-Reply-To the previous version.

Changes in v2:
- Add one to the length argument of array_index_nospec, so it becomes
  inclusive with max_apic_id.

---
 arch/x86/kvm/lapic.c | 2 ++
 arch/x86/kvm/x86.c   | 7 +++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 73418dc0ebb2..0725d2cae742 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -852,6 +852,8 @@ static int __pv_send_ipi(unsigned long *ipi_bitmap, struct kvm_apic_map *map,
 	if (min > map->max_apic_id)
 		return 0;
 
+	min = array_index_nospec(min, map->max_apic_id + 1);
+
 	for_each_set_bit(i, ipi_bitmap,
 		min((u32)BITS_PER_LONG, (map->max_apic_id - min + 1))) {
 		if (map->phys_map[min + i]) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 93636f77c42d..43b63f1d1594 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10051,8 +10051,11 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 	rcu_read_lock();
 	map = rcu_dereference(vcpu->kvm->arch.apic_map);
 
-	if (likely(map) && dest_id <= map->max_apic_id && map->phys_map[dest_id])
-		target = map->phys_map[dest_id]->vcpu;
+	if (likely(map) && dest_id <= map->max_apic_id) {
+		dest_id = array_index_nospec(dest_id, map->max_apic_id + 1);
+		if (map->phys_map[dest_id])
+			target = map->phys_map[dest_id]->vcpu;
+	}
 
 	rcu_read_unlock();
 
-- 
2.50.1


