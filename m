Return-Path: <kvm+bounces-24247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0596B952E54
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 14:35:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8517DB26C31
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 12:34:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BB5217C9AD;
	Thu, 15 Aug 2024 12:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tmr8z87j"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BB519D068
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 12:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723725260; cv=none; b=VTQ/byzKhpkyfYRVxDGYjmCetYMzvdOWlV/pl5kRXHgJeov6K8aZr4m5hpFgjGju7sUmq09o9ARdBcZ0AyF5Fu+FE0cKuXt1+YWWfxjFEy3B1Y1AcZDZc4P+ls0WfMyxE5/wHUOsSRYUfrMGjlCXNQTbEXJnjjn7l68m50lD3fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723725260; c=relaxed/simple;
	bh=qA/vjHiFuW33Gns/1do2oaIyFzXBTSLeYtUza0ruWTA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RHbHkPO6QwS4lBOoQLLVBDTcLrFx0fxUeCPmaI1kcNinf6nK2XkKbWwK8Tqhgs/dQwEgWR8srjP4kdm270vWZA1GkoxJfiXULV7Hav5m9SJnLbzN0ae75WfXf1aF0jOP5zrGfyk6bHLY/8s5P8dQerucOAZjvyDQuN5/YqPkDK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tmr8z87j; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723725258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5zYUq9vCVBL/ellLmExJameIYyfLb7npz24FshDuo5o=;
	b=Tmr8z87j5kLsO49odBaXX3exos9XMTblWpMpq9elbtcv8+je6R+JgVBTpPlvsQ7BNeuGsq
	EOnOPEV4b3n681BzEiGPF4e/M6h+0V3bWm8fy/9zKZ0mWO56sk3SISpHkVdS/vazcE5qmV
	urnjQA9QeEU0x+uVHXa5HVSygZnTz4w=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-656-l6v2RgwSPcWBheuRwWqcqA-1; Thu,
 15 Aug 2024 08:34:17 -0400
X-MC-Unique: l6v2RgwSPcWBheuRwWqcqA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 66E991956048;
	Thu, 15 Aug 2024 12:34:15 +0000 (UTC)
Received: from intellaptop.lan (unknown [10.47.238.120])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F007C300019C;
	Thu, 15 Aug 2024 12:34:10 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>,
	linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 2/4] KVM: x86: add X86_FEATURE_LA57 to governed_features
Date: Thu, 15 Aug 2024 15:33:47 +0300
Message-Id: <20240815123349.729017-3-mlevitsk@redhat.com>
In-Reply-To: <20240815123349.729017-1-mlevitsk@redhat.com>
References: <20240815123349.729017-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Guest support for X86_FEATURE_LA57 will need to be tested to determine
canonical width check for nested VMX VM entries.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/cpuid.c             | 2 ++
 arch/x86/kvm/governed_features.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2617be544480..1a2d3fbe9a59 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -373,6 +373,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	if (allow_gbpages)
 		kvm_governed_feature_set(vcpu, X86_FEATURE_GBPAGES);
 
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_LA57);
+
 	best = kvm_find_cpuid_entry(vcpu, 1);
 	if (best && apic) {
 		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
index ad463b1ed4e4..475171f2fd49 100644
--- a/arch/x86/kvm/governed_features.h
+++ b/arch/x86/kvm/governed_features.h
@@ -17,6 +17,7 @@ KVM_GOVERNED_X86_FEATURE(PFTHRESHOLD)
 KVM_GOVERNED_X86_FEATURE(VGIF)
 KVM_GOVERNED_X86_FEATURE(VNMI)
 KVM_GOVERNED_X86_FEATURE(LAM)
+KVM_GOVERNED_X86_FEATURE(LA57)
 
 #undef KVM_GOVERNED_X86_FEATURE
 #undef KVM_GOVERNED_FEATURE
-- 
2.40.1


