Return-Path: <kvm+bounces-22261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C466B93C7D9
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 19:53:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6FEAF1F23144
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 17:53:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 101C919EEB0;
	Thu, 25 Jul 2024 17:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="asLLendh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9085519DF64
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 17:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721929970; cv=none; b=koySg0kdQBzPWTU39F4xVeqFcw9vXjF+VXVhB5PqTtoEjzLu+X4irwhn76aw5aDlEZmfLvxbxeTeaBR2lDEo4imxOueNZkbOzxKXRT/Zr5s7TcnHLFcggn4jcxroym2Dw5QkFFyYJ+ScTrHDld0tlWlwH4QA0gLlnUugM96F5kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721929970; c=relaxed/simple;
	bh=kogYHPCgxN7fVrHV2V6WfLHhmvshqqvcwuBfjpINjn4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JdiS7W7PROLSFUWTEefB16/NpsjmpKZmfcasA4XXAp55F/2XIrmTXKYwvvglUhgaYIgpONBSEVUU6f39Z7cZzLByuziEOTzPWuDbbz6hPHQ7Ilf8h0gDrgwaGUwKHLttVQkC3cTAFQCuHYxxsH07RX3QqrHzx3iHgP2WouSJ6cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=asLLendh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721929967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n4xS6yIc5oxvEfAdcJ79xBrXoA14Q486xMadqCJ+TwM=;
	b=asLLendhE+vHsvq6WeZnovfb6XKIIktptY6qKZwqMhulyEP8wMha4aLoLiS7SRbfJ24Jvl
	5rJmw+8Yeow+KiSAfUUSUY11Zwv6vZ4UNelJMvawN6xpXV58COUtmJMLYuMvj8UZyUYbYF
	D3zBc8RcnbtrNaoJFeYNGwqav/TOYUo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-217-uX3tpQZUOi2OqskcgXN3cg-1; Thu,
 25 Jul 2024 13:52:42 -0400
X-MC-Unique: uX3tpQZUOi2OqskcgXN3cg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 909E91955EB3;
	Thu, 25 Jul 2024 17:52:40 +0000 (UTC)
Received: from starship.lan (unknown [10.22.8.132])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F1C52300019A;
	Thu, 25 Jul 2024 17:52:37 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 2/2] VMX: reset the segment cache after segment initialization in vmx_vcpu_reset
Date: Thu, 25 Jul 2024 13:52:32 -0400
Message-Id: <20240725175232.337266-3-mlevitsk@redhat.com>
In-Reply-To: <20240725175232.337266-1-mlevitsk@redhat.com>
References: <20240725175232.337266-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

reset the segment cache after segment initialization in vmx_vcpu_reset
to avoid stale uninitialized data being cached in the segment cache.

In particular the following scenario is possible when full preemption
is enabled:

- vCPU is just created, and the vCPU thread is preempted before SS.AR_BYTES
is written in vmx_vcpu_reset.

- During preemption, the kvm_arch_vcpu_in_kernel is called which
reads SS's segment AR byte to determine if the CPU was in the kernel.

That caches 0 value of SS.AR_BYTES, then eventually the vCPU thread will be
preempted back, then set the correct SS.AR_BYTES value in the vmcs
and the cached value will remain stale, and could be read e.g via
KVM_GET_SREGS.

Usually this is not a problem because VMX segment cache is reset on each
vCPU run, but if the userspace (e.g KVM selftests do) reads the segment
registers just after the vCPU was created, and modifies some of them
but passes through other registers and in this case SS.AR_BYTES,
the stale value of it will make it into the vmcs,
and later lead to a VM entry failure due to incorrect SS segment type.

Fix this by moving the vmx_segment_cache_clear() call to be after the
segments are initialized.

Note that this still doesn't fix the issue of kvm_arch_vcpu_in_kernel
getting stale data during the segment setup, and that issue will
be addressed later.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fa9f307d9b18..d43bb755e15c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4870,9 +4870,6 @@ void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx->hv_deadline_tsc = -1;
 	kvm_set_cr8(vcpu, 0);
 
-	vmx_segment_cache_clear(vmx);
-	kvm_register_mark_available(vcpu, VCPU_EXREG_SEGMENTS);
-
 	seg_setup(VCPU_SREG_CS);
 	vmcs_write16(GUEST_CS_SELECTOR, 0xf000);
 	vmcs_writel(GUEST_CS_BASE, 0xffff0000ul);
@@ -4899,6 +4896,9 @@ void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmcs_writel(GUEST_IDTR_BASE, 0);
 	vmcs_write32(GUEST_IDTR_LIMIT, 0xffff);
 
+	vmx_segment_cache_clear(vmx);
+	kvm_register_mark_available(vcpu, VCPU_EXREG_SEGMENTS);
+
 	vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
 	vmcs_write32(GUEST_INTERRUPTIBILITY_INFO, 0);
 	vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS, 0);
-- 
2.26.3


