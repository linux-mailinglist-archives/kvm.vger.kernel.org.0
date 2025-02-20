Return-Path: <kvm+bounces-38746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20596A3E1F5
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:13:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39F141619E3
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7A1421E0BC;
	Thu, 20 Feb 2025 17:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UjssQ1C3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D45D21CA19
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740071206; cv=none; b=PZMzrTVoQcxv6aWk4K6EDumJWWiybb7BX+uftYpuzImy7Kk3GofvcFrWQBjIEip2lUMQe7fqTcddPbqL70O1Yv2oUbPbm9KwH4o2Ze+29OW6g/5mJZv03jAjMPxUzgrxLMTBjLNFVONsOz+TPg2TUc7hG8GRbZMQWkHsR1i0cu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740071206; c=relaxed/simple;
	bh=JTIueOdIZjLRIp8mvEGEeO1r+hV/rIoc0ekRdL3GToY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A2wPJ5gGU9AQH81iIbX4MSBpNaiZ0M3lzB+zJNWVcMVY9f5mK3s5GZtzUBqpn1hj55DWJ3CEraC0HeLB/BGXq51VPE+3NND5Mn015S0pEix/StH1M/81fP4Je52SQn2Ib8L60bvgNx9/J2VBt2q1DgoZLBpQH8vfOG1au9XXwU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UjssQ1C3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740071204;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4s21mY2ewISavR7XKbsSV9LgFnztnGJJFOSKeFooxvc=;
	b=UjssQ1C36EQFwQ6rDJijAPaYrcDkXSmBxwsM/R4Z736Ui8emT0/qzhdHLiLgW5vDI0b8F8
	roTb3IXvcKcukVBTBDbq4u4a+6/F5z613BcArPCzmzfLCW3ZcrGd/CDce57C/frlxVNkBu
	xQPoUskzAmGso6j1cKct7c0NSiDi2/g=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-577-6ArPZJClOsubQxR5qp_dfA-1; Thu,
 20 Feb 2025 12:06:41 -0500
X-MC-Unique: 6ArPZJClOsubQxR5qp_dfA-1
X-Mimecast-MFC-AGG-ID: 6ArPZJClOsubQxR5qp_dfA_1740071199
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A4631180087D;
	Thu, 20 Feb 2025 17:06:39 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C543E19412A4;
	Thu, 20 Feb 2025 17:06:38 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH 22/30] KVM: x86: expose cpuid_entry2_find for TDX
Date: Thu, 20 Feb 2025 12:05:56 -0500
Message-ID: <20250220170604.2279312-23-pbonzini@redhat.com>
In-Reply-To: <20250220170604.2279312-1-pbonzini@redhat.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 19 +++++++++++--------
 arch/x86/kvm/cpuid.h |  2 ++
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8eb3a88707f2..936c5dd13bd5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -86,13 +86,13 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
  * Magic value used by KVM when querying userspace-provided CPUID entries and
  * doesn't care about the CPIUD index because the index of the function in
  * question is not significant.  Note, this magic value must have at least one
- * bit set in bits[63:32] and must be consumed as a u64 by cpuid_entry2_find()
+ * bit set in bits[63:32] and must be consumed as a u64 by kvm_find_cpuid_entry2()
  * to avoid false positives when processing guest CPUID input.
  */
 #define KVM_CPUID_INDEX_NOT_SIGNIFICANT -1ull
 
-static struct kvm_cpuid_entry2 *cpuid_entry2_find(struct kvm_vcpu *vcpu,
-						  u32 function, u64 index)
+struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(
+	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u64 index)
 {
 	struct kvm_cpuid_entry2 *e;
 	int i;
@@ -109,8 +109,8 @@ static struct kvm_cpuid_entry2 *cpuid_entry2_find(struct kvm_vcpu *vcpu,
 	 */
 	lockdep_assert_irqs_enabled();
 
-	for (i = 0; i < vcpu->arch.cpuid_nent; i++) {
-		e = &vcpu->arch.cpuid_entries[i];
+	for (i = 0; i < nent; i++) {
+		e = &entries[i];
 
 		if (e->function != function)
 			continue;
@@ -141,23 +141,26 @@ static struct kvm_cpuid_entry2 *cpuid_entry2_find(struct kvm_vcpu *vcpu,
 
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry2);
 
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
 						    u32 function, u32 index)
 {
-	return cpuid_entry2_find(vcpu, function, index);
+	return kvm_find_cpuid_entry2(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent,
+				     function, index);
 }
 EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry_index);
 
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 					      u32 function)
 {
-	return cpuid_entry2_find(vcpu, function, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
+	return kvm_find_cpuid_entry2(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent,
+				     function, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
 }
 EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
 
 /*
- * cpuid_entry2_find() and KVM_CPUID_INDEX_NOT_SIGNIFICANT should never be used
+ * kvm_find_cpuid_entry2() and KVM_CPUID_INDEX_NOT_SIGNIFICANT should never be used
  * directly outside of kvm_find_cpuid_entry() and kvm_find_cpuid_entry_index().
  */
 #undef KVM_CPUID_INDEX_NOT_SIGNIFICANT
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 67d80aa72d50..91bde94519f9 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -12,6 +12,8 @@ void kvm_set_cpu_caps(void);
 
 void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu);
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
+struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(struct kvm_cpuid_entry2 *entries,
+					       int nent, u32 function, u64 index);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
 						    u32 function, u32 index);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
-- 
2.43.5



