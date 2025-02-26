Return-Path: <kvm+bounces-39387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C6C83A46BB2
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:02:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 83369188D064
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0209428136E;
	Wed, 26 Feb 2025 19:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VbENp89X"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDDA280A44
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599773; cv=none; b=rUf41lZEkd0so54qwY6RI965soHSF9yrxZi8LSlCq6MI9ILfMAI1yDrBV3IBdJvXWnf+x1GmCT7K3LRNhUYOz5rRPCHlmp5Giolt/RXCdnpCLE2B+bqedZvvPZwbjRhs8A9/+E2Nif84yuZr1DrU6sMBoFBH9hs56sYI496NgD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599773; c=relaxed/simple;
	bh=ewztqQ95IRPQy7XSpC72R651qzafJayEHez0KrwzBR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mr3X7DZnNJ+MWwNzN0W5FJ6MfmGF6nRnVcKejoHMYlr9PcWZWEws+eTi2JYmmFRzI6PabTufOm72T3KthRzTqRpwr6YVCCOT506zEjKIkhz2IA1eByYIybuNRuLAdrQOgKVJoNShVm/dtqk1/cOG/hp2ZUdUCByyJB7YFucsTTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VbENp89X; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KcPmGgG2rwYM0IbeRzRvsJ5ZHW+iyZcOLPwbtL9kX3o=;
	b=VbENp89Xj/YlCmf726oiwV5dbLZIJ8aDgHzXnCsxS8IXdkzrysYZT3kOf+dg8JMhvBWE3i
	fdtAc+6BbW2UOxGPBj7DTAPFR0/U8aOCs8khH5slTr7TbtYwVQ1/27WYmhwrrfwFaTwYv/
	79dbd6AuANhA0ag0EHaFhD/3IxPSaB8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-536-KZhp_1UOMyumCh7OOQ_CwQ-1; Wed,
 26 Feb 2025 14:56:09 -0500
X-MC-Unique: KZhp_1UOMyumCh7OOQ_CwQ-1
X-Mimecast-MFC-AGG-ID: KZhp_1UOMyumCh7OOQ_CwQ_1740599768
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C9B919030B0;
	Wed, 26 Feb 2025 19:56:08 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 723DB19560AE;
	Wed, 26 Feb 2025 19:56:07 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH 28/29] KVM: TDX: Skip updating CPU dirty logging request for TDs
Date: Wed, 26 Feb 2025 14:55:28 -0500
Message-ID: <20250226195529.2314580-29-pbonzini@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Wrap vmx_update_cpu_dirty_logging so as to ignore requests to update
CPU dirty logging for TDs, as basic TDX does not support the PML feature.
Invoking vmx_update_cpu_dirty_logging() for TDs would cause an incorrect
access to a kvm_vmx struct for a TDX VM, so block that before it happens.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/main.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index ba3a23747bb1..ec8223ee9d28 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -129,6 +129,18 @@ static void vt_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	vmx_vcpu_load(vcpu, cpu);
 }
 
+static void vt_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Basic TDX does not support feature PML. KVM does not enable PML in
+	 * TD's VMCS, nor does it allocate or flush PML buffer for TDX.
+	 */
+	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
+		return;
+
+	vmx_update_cpu_dirty_logging(vcpu);
+}
+
 static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu)) {
@@ -322,7 +334,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
 
-	.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
+	.update_cpu_dirty_logging = vt_update_cpu_dirty_logging,
 
 	.nested_ops = &vmx_nested_ops,
 
-- 
2.43.5



