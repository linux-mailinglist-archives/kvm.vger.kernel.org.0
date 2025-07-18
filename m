Return-Path: <kvm+bounces-52861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D1C6B09B4D
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 08:25:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 288933ADC15
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 06:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 069A41F4C9F;
	Fri, 18 Jul 2025 06:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hTNgh+38"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A4319E97C
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 06:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752819916; cv=none; b=u8SFj0NVbLFw0+DcBIlRkCl0LMG3BcIZzo9lVQtoe6eIvAjvUCHUkPVQpo71gjCgO5C3qySVcEUbLyanKjAJsuYvlro67uC5W73Rm1WzQRCJ/UicwXfwOLrLM5gse2YcWOC6U+8rLG59nChf2Xl6C50eUdr5lcSCHtgTi9mXyak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752819916; c=relaxed/simple;
	bh=Js+lVIECA+MlpwBwikv6Sh9BN+SgNuc+l3FHZUeQABg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=t2JgBBZTF2j75FugHJwtO/7s23l5UmIHsM9ku1rOl0X+vx+P7Mp89253kuefo1vqTC8x5a8JGd9Ornhh+Cqddvdl0mQVmyFB26M4F81VOojP0J44MBUPSeeC7owVnTzPoYy34VcIJqA5yuAy9Y7V3vBHwx8126RdMoW4D26vr5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hTNgh+38; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752819912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=a7673uBYPxlpUD9zTGRiH5JAVGUBZV+mL2ewwlCRHbA=;
	b=hTNgh+38tV/cvNy3P9FJOU41vSJzB030BcWfVLrsK4l8M7hbRzx+jMFQalRu6dRKd80NVa
	1l7F0S0uIbhqxEEbYXiEiBtzF+Hp0PyufCb6pcRxMiNTJLSIWrTQZQ4+AIFha756Ji8fw0
	0Wdk0IKgF4Y3bRITRnsrzH2MQx3a74s=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-444-sUPP16efOQKmySaaf90OyQ-1; Fri,
 18 Jul 2025 02:25:09 -0400
X-MC-Unique: sUPP16efOQKmySaaf90OyQ-1
X-Mimecast-MFC-AGG-ID: sUPP16efOQKmySaaf90OyQ_1752819907
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A71AB1800165;
	Fri, 18 Jul 2025 06:24:59 +0000 (UTC)
Received: from server.redhat.com (unknown [10.72.112.34])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AB44E195608D;
	Fri, 18 Jul 2025 06:24:50 +0000 (UTC)
From: Cindy Lu <lulu@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Kirill A. Shutemov" <kas@kernel.org>,
	"Xin Li (Intel)" <xin@zytor.com>,
	Rik van Riel <riel@surriel.com>,
	Jason Wang <jasowang@redhat.com>,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	kvm@vger.kernel.org (open list:KVM PARAVIRT (KVM/paravirt)),
	linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
	lulu@redhat.com
Subject: [PATCH v1] kvm: x86: implement PV send_IPI method
Date: Fri, 18 Jul 2025 14:24:00 +0800
Message-ID: <20250718062429.238723-1-lulu@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

From: Jason Wang <jasowang@redhat.com>

We used to have PV version of send_IPI_mask and
send_IPI_mask_allbutself. This patch implements PV send_IPI method to
reduce the number of vmexits.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Tested-by: Cindy Lu <lulu@redhat.com>
---
 arch/x86/kernel/kvm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 921c1c783bc1..b920cfd10441 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -557,6 +557,11 @@ static void __send_ipi_mask(const struct cpumask *mask, int vector)
 	local_irq_restore(flags);
 }
 
+static void kvm_send_ipi(int cpu, int vector)
+{
+	__send_ipi_mask(cpumask_of(cpu), vector);
+}
+
 static void kvm_send_ipi_mask(const struct cpumask *mask, int vector)
 {
 	__send_ipi_mask(mask, vector);
@@ -628,6 +633,7 @@ late_initcall(setup_efi_kvm_sev_migration);
  */
 static __init void kvm_setup_pv_ipi(void)
 {
+	apic_update_callback(send_IPI, kvm_send_ipi);
 	apic_update_callback(send_IPI_mask, kvm_send_ipi_mask);
 	apic_update_callback(send_IPI_mask_allbutself, kvm_send_ipi_mask_allbutself);
 	pr_info("setup PV IPIs\n");
-- 
2.45.0


