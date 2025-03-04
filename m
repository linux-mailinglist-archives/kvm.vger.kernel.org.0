Return-Path: <kvm+bounces-39974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 165C4A4D368
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 07:07:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED28F3ADC05
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 06:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7DF21F55E0;
	Tue,  4 Mar 2025 06:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UkF4eMcQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798081F4288
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 06:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741068420; cv=none; b=Vrxfo3AISwLKtYWvE4UPl9zpEDzbEApXOxTzJtkhWJDcpNvVz5arFIduk2gImJeovwdM//bQw3tVKX2kuRlOdsUf1oMmQhxJFzkpMurOsjf/AUj8wxfURF+2L1DYu3mbwd9tvAO7RwxZEZ1MG3hvAfLGlaC1xFBlc36t30obfsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741068420; c=relaxed/simple;
	bh=0sb/hD8oINT9lkuYBUoBp4E3X5gQMevuRlwIED7GWHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HVy2o5jDLe0v6K1frqRfzQXdifv5Wh7/tOPS3fY/MR3grNclW/00hNiOXjOqWBHmR2xv1Evl4KeB+dzo8i9ndPf9MQK1OOyPmwQIGwJmojbOczg1gps9CAtWuiZC6y77Sj2jMZn7Ha6TM+D2jkg0M4COcjOR6wGeTPp0Jesk6Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UkF4eMcQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741068417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q2Vvr/cO3wUf0Kz88TyRw+lIjfjAzPrQQ0xrqBAlkeI=;
	b=UkF4eMcQPs3ZlIuKPrnlF6HMs82TB3RgcSZG3TuUlGYGG/14quqJ/1ZLrtsBLoAZ1f25nT
	oyBGhHhXjn7vf0lYd6Jx7qw4rx/wC+HEPyTNpJNIxMWW390ptc7ZEXT38AmgwQb3pyzWRQ
	0zUkGkhjwyuppiH+eohTDe7cNPSMAKc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-286-5lelA8F_PUytPJyCx8J5sg-1; Tue,
 04 Mar 2025 01:06:53 -0500
X-MC-Unique: 5lelA8F_PUytPJyCx8J5sg-1
X-Mimecast-MFC-AGG-ID: 5lelA8F_PUytPJyCx8J5sg_1741068412
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B908F180036F;
	Tue,  4 Mar 2025 06:06:52 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 99F9F1956048;
	Tue,  4 Mar 2025 06:06:51 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: xiaoyao.li@intel.com,
	seanjc@google.com,
	yan.y.zhao@intel.com
Subject: [PATCH v3 3/6] KVM: x86: Introduce supported_quirks to block disabling quirks
Date: Tue,  4 Mar 2025 01:06:44 -0500
Message-ID: <20250304060647.2903469-4-pbonzini@redhat.com>
In-Reply-To: <20250304060647.2903469-1-pbonzini@redhat.com>
References: <20250304060647.2903469-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

From: Yan Zhao <yan.y.zhao@intel.com>

Introduce supported_quirks in kvm_caps; it starts with KVM_X86_VALID_QUIRKS
and bits can be removed to force-enable quirks according to platform-specific
logic.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Message-ID: <20250224070832.31394-1-yan.y.zhao@intel.com>
[Remove unsupported quirks at KVM_ENABLE_CAP time. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 7 ++++---
 arch/x86/kvm/x86.h | 2 ++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5abea6c73a38..062c1b58b223 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4782,7 +4782,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = enable_pmu ? KVM_CAP_PMU_VALID_MASK : 0;
 		break;
 	case KVM_CAP_DISABLE_QUIRKS2:
-		r = KVM_X86_VALID_QUIRKS;
+		r = kvm_caps.supported_quirks;
 		break;
 	case KVM_CAP_X86_NOTIFY_VMEXIT:
 		r = kvm_caps.has_notify_vmexit;
@@ -6521,11 +6521,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	switch (cap->cap) {
 	case KVM_CAP_DISABLE_QUIRKS2:
 		r = -EINVAL;
-		if (cap->args[0] & ~KVM_X86_VALID_QUIRKS)
+		if (cap->args[0] & ~kvm_caps.supported_quirks)
 			break;
 		fallthrough;
 	case KVM_CAP_DISABLE_QUIRKS:
-		kvm->arch.disabled_quirks |= cap->args[0];
+		kvm->arch.disabled_quirks |= cap->args[0] & kvm_caps.supported_quirks;
 		r = 0;
 		break;
 	case KVM_CAP_SPLIT_IRQCHIP: {
@@ -9775,6 +9775,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		kvm_host.xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 		kvm_caps.supported_xcr0 = kvm_host.xcr0 & KVM_SUPPORTED_XCR0;
 	}
+	kvm_caps.supported_quirks = KVM_X86_VALID_QUIRKS;
 	kvm_caps.inapplicable_quirks = KVM_X86_CONDITIONAL_QUIRKS;
 
 	rdmsrl_safe(MSR_EFER, &kvm_host.efer);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 221778792c3c..287dac35ed5e 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -34,6 +34,8 @@ struct kvm_caps {
 	u64 supported_xcr0;
 	u64 supported_xss;
 	u64 supported_perf_cap;
+
+	u64 supported_quirks;
 	u64 inapplicable_quirks;
 };
 
-- 
2.43.5



