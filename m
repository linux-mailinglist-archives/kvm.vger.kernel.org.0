Return-Path: <kvm+bounces-49222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 972D9AD66EE
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 06:49:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 521C6171568
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 04:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 561421624EA;
	Thu, 12 Jun 2025 04:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q1utYGID"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD257DA82
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 04:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749703793; cv=none; b=V6OSzFzur7CC4GZyGHDAWHr+VkrI4woi54hhasT0EripUv0vvg0F62NFwR0M2DXT6OykP04d+1iAOPO4YFlDlz4OqFMqbYvL2yaeZwRaAxNsHe3Fpqr/vq+GJNSSc9UkaZ2RkdujImeMGecFXAyk3PX+AkwSYLJOJIjGIiE1+ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749703793; c=relaxed/simple;
	bh=GR66hGVXdlKu7SEarFLErk8993y72ho0y/Vqw0tX3WU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gL1nwZAEkfyKbl2tmued0nCyEXM4JkidBJmDrZWA0YUjifWVp5sZvMnB0rUdaYJGPf4nghIib29coONL9qMMMZ5Fq1I+0qtJ8iWNuV0kh/AdIyU/eMJJsVGPUF5ehFhoCaABu8sFTagpMiPwkAPXtBeJzEKaSvdbGiLj/ML/EN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q1utYGID; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749703790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OBYtJIhsv8X1JURlzf2kgMeWsta7f4jIzlInsevvCtw=;
	b=Q1utYGIDelEDRWoeGQSkIfO5LQ2SJSESToBA1zGe35wMvaz+7R8IoVLjEjt6KpN0o99IQ4
	KFoRcINtKwP0Bg1ujYyd+K+H1szUvDCY23Y+TAffncKmkzlX1vqTmvHjShTO/fjkM5fdCO
	TmvMpeJ+C9/Rznid5bD9SPXHkwrn9VM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-547-r1I6eT35O1Kf6RL3nzOTaQ-1; Thu,
 12 Jun 2025 00:49:46 -0400
X-MC-Unique: r1I6eT35O1Kf6RL3nzOTaQ-1
X-Mimecast-MFC-AGG-ID: r1I6eT35O1Kf6RL3nzOTaQ_1749703785
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29F3D195608A;
	Thu, 12 Jun 2025 04:49:45 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 43E1119560AF;
	Thu, 12 Jun 2025 04:49:44 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	xiaoyao.li@intel.com,
	yan.y.zhao@intel.com
Subject: [PATCH] KVM: x86/mmu: Reject direct bits in gpa passed to KVM_PRE_FAULT_MEMORY
Date: Thu, 12 Jun 2025 00:49:43 -0400
Message-ID: <20250612044943.151258-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Only let userspace pass the same addresses that were used in KVM_SET_USER_MEMORY_REGION
(or KVM_SET_USER_MEMORY_REGION2); gpas in the the upper half of the address space
are an implementation detail of TDX and KVM.

Extracted from a patch by Sean Christopherson <seanjc@google.com>.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a4040578b537..4e06e2e89a8f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4903,6 +4903,9 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 	if (!vcpu->kvm->arch.pre_fault_allowed)
 		return -EOPNOTSUPP;
 
+	if (kvm_is_gfn_alias(vcpu->kvm, gpa_to_gfn(range->gpa)))
+		return -EINVAL;
+
 	/*
 	 * reload is efficient when called repeatedly, so we can do it on
 	 * every iteration.
-- 
2.43.5


