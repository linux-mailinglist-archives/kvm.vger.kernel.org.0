Return-Path: <kvm+bounces-53339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4875DB10057
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 08:00:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 086587AABB9
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 05:58:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B9152066CE;
	Thu, 24 Jul 2025 06:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahdbtywe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3245A1EF09D
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 06:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753336815; cv=none; b=S4Ba9t20+erKpoelztz+wgeWlqU3lRlrhtlhNA7/Bi8M2fcgKLeNZ504131Z2K30bSgUPqsGigqfseOAQVxINdHcu5YR+TW/L2yNoX3UL/kuwiyMH1tTEprAP7SeFOB7l7ap/Q6VNYijAW5Gx43eukwRTPJxthscr0gHUclYJXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753336815; c=relaxed/simple;
	bh=eIz6uS+8mB80pqpwxk/5dqXtuEfFgSoqBf3iBAZGyM8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HPwcjA2DRnU9ex7OfIPv5k1HsN+d8wQx25dtHfTq/6CfKZIg4d/IkN2e+9HjphaiT4LOeNz+vPuG+dTlJnvLuLPufJn+d2ROT41NDKBBkTQfBVE19Hx6t9lP7bqUh/+SPdO4DqZDjxyQ7AY7AOIGKOnpbEJ7dlB5vvsAOupd/yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahdbtywe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400C1C4CEED;
	Thu, 24 Jul 2025 06:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753336814;
	bh=eIz6uS+8mB80pqpwxk/5dqXtuEfFgSoqBf3iBAZGyM8=;
	h=From:To:Cc:Subject:Date:From;
	b=ahdbtyweXEtojvkQviwzk85hCqQAl2udegR3Gb1i2ilDU0AnRH/tZLEmlb6wP9cry
	 pWj594sdCPUwL+YPdafD07EZb39G6a/1r12fw30ehYdTCn07AJ6vituVuJSIcVQzI+
	 uq8RQbxCF8aYsIIFiQO9XGTDkixQkGjWIDKFQzzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: kvm@vger.kernel.org
Cc: Thijs Raymakers <thijs@raymakers.nl>,
	stable <stable@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] KVM: x86: use array_index_nospec with indices that come from guest
Date: Thu, 24 Jul 2025 08:00:01 +0200
Message-ID: <2025072400-amendment-thieving-675f@gregkh>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Lines: 47
X-Developer-Signature: v=1; a=openpgp-sha256; l=1694; i=gregkh@linuxfoundation.org; h=from:subject:message-id; bh=gBJZ7Da7I0+bpB+Lgkf71eA/o3x1Ka3i813NpPBoo+o=; b=owGbwMvMwCRo6H6F97bub03G02pJDBmNpx/oaS/hafMK49/LYH7R9kqNjJLc9SPJbzVXatzet 2it6Sq+jlgWBkEmBlkxRZYv23iO7q84pOhlaHsaZg4rE8gQBi5OAZhIuxPDPOPb7Gb/d6x+6ch7 UvRExNJlvq/ieBnmF+XczjVY7fh7/xbj3Yyr1y/Q3Hk5BQA=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit

From: Thijs Raymakers <thijs@raymakers.nl>

min and dest_id are guest-controlled indices. Using array_index_nospec()
after the bounds checks clamps these values to mitigate speculative
execution side-channels.

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
index 73418dc0ebb2..e10d6ad236c9 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -852,6 +852,8 @@ static int __pv_send_ipi(unsigned long *ipi_bitmap, struct kvm_apic_map *map,
 	if (min > map->max_apic_id)
 		return 0;
 
+	min = array_index_nospec(min, map->max_apic_id);
+
 	for_each_set_bit(i, ipi_bitmap,
 		min((u32)BITS_PER_LONG, (map->max_apic_id - min + 1))) {
 		if (map->phys_map[min + i]) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 93636f77c42d..872e43defa67 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10051,8 +10051,11 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 	rcu_read_lock();
 	map = rcu_dereference(vcpu->kvm->arch.apic_map);
 
-	if (likely(map) && dest_id <= map->max_apic_id && map->phys_map[dest_id])
-		target = map->phys_map[dest_id]->vcpu;
+	if (likely(map) && dest_id <= map->max_apic_id) {
+		dest_id = array_index_nospec(dest_id, map->max_apic_id);
+		if (map->phys_map[dest_id])
+			target = map->phys_map[dest_id]->vcpu;
+	}
 
 	rcu_read_unlock();
 
-- 
2.50.1


