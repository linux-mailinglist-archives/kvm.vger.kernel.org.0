Return-Path: <kvm+bounces-53383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 972ACB10D6C
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 16:25:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C5251CE0A83
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 14:23:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51EAE2DFA46;
	Thu, 24 Jul 2025 14:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=raymakers.nl header.i=@raymakers.nl header.b="CD2NeEmS"
X-Original-To: kvm@vger.kernel.org
Received: from dane.soverin.net (dane.soverin.net [185.233.34.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEAC2DEA89
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 14:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.233.34.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753366967; cv=none; b=cCKzdjwi1iIqjPUunIyYB+vv6gn1gS1WT1Tc9G/mCPZL3pmt0k9i5Ja1j6y+aLV5veKM0V1404vu+E6yemoFiXKVClC2DIomnO7bs0Tp4JsObggaDdP5LsO0mJk4M/v5G/k0f9o6EZ8aL0WZWWRv28i9rTcy3vV9p88/G8DecwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753366967; c=relaxed/simple;
	bh=6RfCsd4uO5UzrJ+JJwU47VxmTTRMJuwIVSlSsMLpjwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNYu42ClIT4IgesVGyokCwSmlQ2OEFv3y3hwWOk/GW9/eGBKirSFugG5e4wJqnQ1czHsPFd71G96Y7PSnYkQipMROE6BDS7nqPo89cGcQaD0PEw4G7/qIvW/QS8I7gf+EQF+7dGa8DzxoezMJ6KA+3e2V+DBWyVQ3rir++AnKvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=raymakers.nl; spf=pass smtp.mailfrom=raymakers.nl; dkim=pass (2048-bit key) header.d=raymakers.nl header.i=@raymakers.nl header.b=CD2NeEmS; arc=none smtp.client-ip=185.233.34.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=raymakers.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raymakers.nl
Received: from smtp.soverin.net (unknown [10.10.4.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(No client certificate requested)
	by dane.soverin.net (Postfix) with ESMTPS id 4bntWG6j6Yz1c3J;
	Thu, 24 Jul 2025 14:22:34 +0000 (UTC)
Received: from smtp.soverin.net (smtp.soverin.net [10.10.4.100]) by soverin.net (Postfix) with ESMTPSA id 4bntWG16HMzN0;
	Thu, 24 Jul 2025 14:22:34 +0000 (UTC)
Authentication-Results: smtp.soverin.net;
	dkim=pass (2048-bit key; unprotected) header.d=raymakers.nl header.i=@raymakers.nl header.a=rsa-sha256 header.s=soverin1 header.b=CD2NeEmS;
	dkim-atps=neutral
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raymakers.nl;
	s=soverin1; t=1753366954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zxse9duWiMlDl5+Oe6iQFKIQJQfZkY0A+GfDWbB5YpE=;
	b=CD2NeEmStF1bAKpnMD3PcAsdEFQIriwdJ++AIQv2d7ihZma0zSdUzxxEdXifkSAbCBquKA
	MzvWJBXPyOeDdB2sBEGeBcGHs16JGqBOQHDB98Rs4D3gDNQFNSpIwVGpiQ6RqTMzX57v3y
	F69l/hx3WsDHfGF/dlk1GpHVXc8r8dAIikG2nE7Pnt8buywbbsxSoa90LhyvSw0ZEq0Qj2
	9+NprY0zw2vst7FHUPOmDYOcO12H5Bvg9fHEaV2xiUsi7Iwa9GQhh91WtiHAhJzB2NTW7F
	qcLH236ndFhS/1N7pL+3rfCL7RcO/+JxM2VXR5Nr4TQi2OeeHx0dAyJgJV0ppw==
X-CM-Analysis: v=2.4 cv=I7afRMgg c=1 sm=1 tr=0 ts=688241aa a=sdlsAmwVdOUCvHs/DD9Mhw==:117 a=sdlsAmwVdOUCvHs/DD9Mhw==:17 a=eMcEbXDZAAAA:8 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=20KFwNOVAAAA:8 a=ag1SF4gXAAAA:8 a=kBzxIHrP6LMpPIqOwp0A:9 a=Ff6uVGclmHxgYidJvOUY:22 a=Yupwre4RP9_Eg_Bd0iYG:22
X-CM-Envelope: MS4xfLC075EEEZyfJo7eix1aYYRLlLEAJiemhiLGrQacNDKwWTOHnL7VhbQPXqMU7aH7qpmD0vPjDA0UKAvT2CS2oA21yjPX09ZHDhrOA1B9HHy83mF8cF91 XMZGEmTDXDrBSRkFRn8J/cjVBpwBOV532NJkdloci6LAMbuQmJ1ptiGPhYCFsq8QObxWCAxdKW2prc0fdEoGyJGLN2scmGMiggQ7vi3IfDFLWT+JzFtM2Y1i iL9MHiFv1bdWFt3ovDHOH0tUCFdUDS2CJTGgGI+BWzlMgR5gY8MlGxcZo3MeVLLruZ3blvfrzqVQHnVhZkAPf5gbrl1OtjDW/tRgaBnCU4c=
From: Thijs Raymakers <thijs@raymakers.nl>
To: seanjc@google.com
Cc: kvm@vger.kernel.org,
	Thijs Raymakers <thijs@raymakers.nl>,
	stable <stable@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2] KVM: x86: use array_index_nospec with indices that come from guest
Date: Thu, 24 Jul 2025 16:22:27 +0200
Message-ID: <20250724142227.61337-1-thijs@raymakers.nl>
In-Reply-To: <aII3WuhvJb3sY8HG@google.com>
References: <aII3WuhvJb3sY8HG@google.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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


