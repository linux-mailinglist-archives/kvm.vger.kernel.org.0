Return-Path: <kvm+bounces-47332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1F14AC0199
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 02:57:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 543714A7F49
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 00:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C58141624E1;
	Thu, 22 May 2025 00:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c3jbJIts"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527BE3F9FB
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 00:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747875374; cv=none; b=eCouzT5/wIc3cp7rFR9m7CjXcofyofPFt4BhrUD8++EjIh9H1p7Bni1V8ANyXQpCWMPykBHBTjBVARlDAHk9Q+947/D8FabqahSlGAoTvNXOPGpDAWTm3kqfjZ05DlS2asLNiQ49YWOGtI8pMsSNcDV39dm9tznZQ3/PLkMACKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747875374; c=relaxed/simple;
	bh=SBcTFOWblvTRZV0ciy3LajIn+btKaXHcFRkSjK2ep3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVtWQQkIRJDwtfuFJdpVxb5Cis2ysapvG2PE97VWMKhDwp2sUqe3BKGQ4Dl9PLlvuR8bEkWMduZqCEc7iSB0es0HJ4T4nFt6GbkE/myO45WoK2z3TRZHwN/bynMfX+aQsdAFbj2dmvzF7bFw6Bws56fOMX0E4py8Nz2DVdUn63A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c3jbJIts; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747875372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RSF3Pw04XxAwlf8ujRRM/pIVlPZ9S+nu3dIi3wffJjI=;
	b=c3jbJItsdzitr7gUn3Y72PezsWRMnTMtk35AWVQxnX7/BlL2aWzb8cFhz/Pq0wGgkKUIGG
	OB84NcWu2/IGe59+brU/s4iq2KVdpmPWGkOnI5sM6xqHYMk1NQhh/cC/8M5oHaszng10oW
	8eer0DWn+tU3fPQSX0DhEAS+5nlvOss=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-396-YvDoV24LNX-atWdyhcQ15g-1; Wed,
 21 May 2025 20:56:08 -0400
X-MC-Unique: YvDoV24LNX-atWdyhcQ15g-1
X-Mimecast-MFC-AGG-ID: YvDoV24LNX-atWdyhcQ15g_1747875367
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E30C180098C;
	Thu, 22 May 2025 00:56:06 +0000 (UTC)
Received: from intellaptop.lan (unknown [10.22.80.5])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 765DA19560B7;
	Thu, 22 May 2025 00:56:04 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Chao Gao <chao.gao@intel.com>
Subject: [PATCH v5 3/5] KVM: nVMX: check vmcs12->guest_ia32_debugctl value given by L2
Date: Wed, 21 May 2025 20:55:53 -0400
Message-ID: <20250522005555.55705-4-mlevitsk@redhat.com>
In-Reply-To: <20250522005555.55705-1-mlevitsk@redhat.com>
References: <20250522005555.55705-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Check the vmcs12 guest_ia32_debugctl value before loading it, to avoid L2
being able to load arbitrary values to hardware IA32_DEBUGCTL.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 3 ++-
 arch/x86/kvm/vmx/vmx.c    | 2 +-
 arch/x86/kvm/vmx/vmx.h    | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e073e3008b16..00f2b762710c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3146,7 +3146,8 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
-	    CC(!kvm_dr7_valid(vmcs12->guest_dr7)))
+	    (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
+	     CC(vmcs12->guest_ia32_debugctl & ~vmx_get_supported_debugctl(vcpu, false))))
 		return -EINVAL;
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
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
index 6d1e40ecc024..eb924c2acfd0 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -414,6 +414,7 @@ static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
 }
 
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
+u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated);
 
 /*
  * Note, early Intel manuals have the write-low and read-high bitmap offsets
-- 
2.46.0


