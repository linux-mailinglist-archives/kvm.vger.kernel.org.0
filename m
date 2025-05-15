Return-Path: <kvm+bounces-46622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 41B61AB7ACB
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 02:55:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 326897B4D30
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 00:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C044224A07F;
	Thu, 15 May 2025 00:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iQeTaEae"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DBE248F67
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 00:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747270454; cv=none; b=oSvbSsfB1VLxVa81nQfO2J4op0NGzBFmw8pkbeApFU7a0aY4SBc4SeAKDa3EBOsPmafdhNG76X6N2UzpeBqH9zg8s22ZV8/iJ3ogtcmxRhtHhfoTMD79NhDcR/UhG/ZN+IRbrUasktZN0sWMLugXaOWEj56ZAZm1WVKaVQObWsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747270454; c=relaxed/simple;
	bh=yQn3v78qKM/JrhwBsDxAwD7W9zAzwRq53Ji/dOtqL7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSdE8mThCbpXwlr5A6KS0KS/HG181VNDNwmqs2Z3P2lx9fbtTjtawQ1Aqpe7Tc0uoHDh+AIKFjqR+abEHZ/Z8lROMkxpmjHLz9DecrwxShBVh+YxB9+9sI+kMk02dLz68w6OUGSudNtqOS+Z8LJfjDv5Thd5GRYnUdjkYYazFtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iQeTaEae; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747270451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dynCNOVl4k0bBoQF1+pfEcGgMamPPv556WKa3QSOewo=;
	b=iQeTaEaew8Z+XFu70M7voOEDxPuX7xOFBiFaIQywYditrulvg0pa+XU4V8fe4UpVx4w5OL
	EQNwWLgcMGq29jQH/Hn0DKN+xA4wz0LGgPDYgV2D57fJ6DR676KOtWMpK5Z++euIlfkc/e
	cPIb6wnbwJLVWiR4MWcF6kqt+SvjiQk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-5-J29wIzS8Ob2UvSGH2wDP7w-1; Wed,
 14 May 2025 20:54:07 -0400
X-MC-Unique: J29wIzS8Ob2UvSGH2wDP7w-1
X-Mimecast-MFC-AGG-ID: J29wIzS8Ob2UvSGH2wDP7w_1747270445
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 93597180035F;
	Thu, 15 May 2025 00:54:05 +0000 (UTC)
Received: from intellaptop.lan (unknown [10.22.80.5])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D0AF419560A7;
	Thu, 15 May 2025 00:54:02 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Sean Christopherson <seanjc@google.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 3/4] x86: nVMX: check vmcs12->guest_ia32_debugctl value given by L2
Date: Wed, 14 May 2025 20:53:52 -0400
Message-ID: <20250515005353.952707-4-mlevitsk@redhat.com>
In-Reply-To: <20250515005353.952707-1-mlevitsk@redhat.com>
References: <20250515005353.952707-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Check the vmcs12 guest_ia32_debugctl value before loading it, to avoid L2
being able to load arbitrary values to hardware IA32_DEBUGCTL.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 4 ++++
 arch/x86/kvm/vmx/vmx.c    | 2 +-
 arch/x86/kvm/vmx/vmx.h    | 2 ++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e073e3008b16..0bda6400e30a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3193,6 +3193,10 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	     CC((vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_RSVD))))
 		return -EINVAL;
 
+	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
+	     CC(vmcs12->guest_ia32_debugctl & ~vmx_get_supported_debugctl(vcpu, false)))
+		return -EINVAL;
+
 	if (nested_check_guest_non_reg_state(vmcs12))
 		return -EINVAL;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9953de0cb32a..9046ee2e9a04 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2179,7 +2179,7 @@ static u64 nested_vmx_truncate_sysenter_addr(struct kvm_vcpu *vcpu,
 	return (unsigned long)data;
 }
 
-static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated)
+u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated)
 {
 	u64 debugctl = 0;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 6d1e40ecc024..1b80479505d3 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -413,7 +413,9 @@ static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
 		vmx_disable_intercept_for_msr(vcpu, msr, type);
 }
 
+
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
+u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated);
 
 /*
  * Note, early Intel manuals have the write-low and read-high bitmap offsets
-- 
2.46.0


