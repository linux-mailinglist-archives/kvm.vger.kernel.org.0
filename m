Return-Path: <kvm+bounces-39373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7039AA46B8B
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:58:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 758B53ADC4E
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACF33267F64;
	Wed, 26 Feb 2025 19:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vy3r5Gmq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADB9266B4C
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599754; cv=none; b=JOfuSNsZHrZfw3SwiPPEzMKJN798PvLyFJdRqdLZgHr8YF9n8kI312tjt9POm5VbaloqyeAz/kiMtG4zgPLXEAK4RhmWNgSpX0QKxviBnJ4IfiGAhE+ixIYDZJdZCFEmy6uCro/9YFECkh6FxCcFediUg8H82BLoOOGjrL6DpCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599754; c=relaxed/simple;
	bh=3orAe8jekjI8BkEIQtuhWJlbMMIReRv2qLBvQ16HpA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LL5VVxzrBLfJ+58629KuCipRKbtlWiSQ4ap6bwNY59y8w6eOHvoFcA460WmX+KE7phaYIUmNF5uT+eHiAo+2IQveQGrXK8oVYOMROVwy1RNTwWFrmqFleirJOEKdIE2Atq4V6VFm5O9bYAld7nS6wpZ0AYaQB7FmHOljpiyh12s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vy3r5Gmq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YUMbv+V8CYR6UPN0wtPtSTtVxX9cStGwiQQlkrC9phM=;
	b=Vy3r5GmqC3EozhVlyNg1Akhtozdta3MG7LKZv0N/yt/s97OwOAr3zSA9OJFlw93O4L0lgi
	ZtG+DH658Qf7mbIzmOqHIyRYbHVjgGnwgVS5biQH6WxJgwX7hZ4lgjxY8FfpunJFpaP4J2
	XEs+jPX0+jVbNY17TaOiitfjo/RK6M4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-645-jBwAYo_KMJqMbS9meJUbGQ-1; Wed,
 26 Feb 2025 14:55:47 -0500
X-MC-Unique: jBwAYo_KMJqMbS9meJUbGQ-1
X-Mimecast-MFC-AGG-ID: jBwAYo_KMJqMbS9meJUbGQ_1740599746
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EC9681800871;
	Wed, 26 Feb 2025 19:55:45 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2130C300018D;
	Wed, 26 Feb 2025 19:55:45 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH 10/29] KVM: VMX: Teach EPT violation helper about private mem
Date: Wed, 26 Feb 2025 14:55:10 -0500
Message-ID: <20250226195529.2314580-11-pbonzini@redhat.com>
In-Reply-To: <20250226195529.2314580-1-pbonzini@redhat.com>
References: <20250226195529.2314580-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Teach EPT violation helper to check shared mask of a GPA to find out
whether the GPA is for private memory.

When EPT violation is triggered after TD accessing a private GPA, KVM will
exit to user space if the corresponding GFN's attribute is not private.
User space will then update GFN's attribute during its memory conversion
process. After that, TD will re-access the private GPA and trigger EPT
violation again. Only with GFN's attribute matches to private, KVM will
fault in private page, map it in mirrored TDP root, and propagate changes
to private EPT to resolve the EPT violation.

Relying on GFN's attribute tracking xarray to determine if a GFN is
private, as for KVM_X86_SW_PROTECTED_VM, may lead to endless EPT
violations.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Message-ID: <20241112073539.22056-1-yan.y.zhao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/common.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 78ae39b6cdcd..7a592467a044 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -6,6 +6,12 @@
 
 #include "mmu.h"
 
+static inline bool vt_is_tdx_private_gpa(struct kvm *kvm, gpa_t gpa)
+{
+	/* For TDX the direct mask is the shared mask. */
+	return !kvm_is_addr_direct(kvm, gpa);
+}
+
 static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 					     unsigned long exit_qualification)
 {
@@ -28,6 +34,9 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 		error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) ?
 			      PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
 
+	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa))
+		error_code |= PFERR_PRIVATE_ACCESS;
+
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
 }
 
-- 
2.43.5



