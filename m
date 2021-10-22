Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F131B437A13
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 17:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbhJVPiy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 11:38:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233499AbhJVPit (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 11:38:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634916991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QUJUjq13tjYXQyDQQKVv+RscKB2nBl+eLpD9DJqwOiM=;
        b=VqYh/hNjvSI0qtlWeyTIsUqglxpVfGLparqLLhUMNx4u8GC3hJgQKBcJExOVXVUtrTcm46
        n9/ZxQnMFwsbQfOXxfaQyFCxTIGcnpYE6Gz0+FKhRHLHwdJwyCnbQOgiskqCGndrPITpr8
        vut2FsmRL4L5pIsEv6DBeL0H0s2xORk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-hMIQzX_hMZqAzPn5QlIVnw-1; Fri, 22 Oct 2021 11:36:28 -0400
X-MC-Unique: hMIQzX_hMZqAzPn5QlIVnw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0467F1006AA3;
        Fri, 22 Oct 2021 15:36:27 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9975C60C04;
        Fri, 22 Oct 2021 15:36:26 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com
Subject: [PATCH 09/13] KVM: x86: move all vcpu->arch.pio* setup in emulator_pio_in_out
Date:   Fri, 22 Oct 2021 11:36:12 -0400
Message-Id: <20211022153616.1722429-10-pbonzini@redhat.com>
In-Reply-To: <20211022153616.1722429-1-pbonzini@redhat.com>
References: <20211022153616.1722429-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For now, this is basically an excuse to add back the void* argument to
the function, while removing some knowledge of vcpu->arch.pio* from
its callers.  The WARN that vcpu->arch.pio.count is zero is also
extended to OUT operations.

We cannot do more as long as we have __emulator_pio_in always followed
by complete_emulator_pio_in, which uses the vcpu->arch.pio* fields.
But after fixing that, it will be possible to only populate the
vcpu->arch.pio* fields on userspace exits.

No functional change intended.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/trace.h |  2 +-
 arch/x86/kvm/x86.c   | 18 ++++++++++--------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 03ebe368333e..1b0167ae9e24 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -152,7 +152,7 @@ TRACE_EVENT(kvm_xen_hypercall,
 
 TRACE_EVENT(kvm_pio,
 	TP_PROTO(unsigned int rw, unsigned int port, unsigned int size,
-		 unsigned int count, void *data),
+		 unsigned int count, const void *data),
 	TP_ARGS(rw, port, size, count, data),
 
 	TP_STRUCT__entry(
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d6b8df7cea80..7c421d9fbcb6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6887,17 +6887,22 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 }
 
 static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
-			       unsigned short port,
+			       unsigned short port, void *data,
 			       unsigned int count, bool in)
 {
-	void *data = vcpu->arch.pio_data;
 	unsigned i;
 	int r;
 
+	WARN_ON_ONCE(vcpu->arch.pio.count);
 	vcpu->arch.pio.port = port;
 	vcpu->arch.pio.in = in;
 	vcpu->arch.pio.count = count;
 	vcpu->arch.pio.size = size;
+	if (in)
+		memset(vcpu->arch.pio_data, 0, size * count);
+	else
+		memcpy(vcpu->arch.pio_data, data, size * count);
+	data = vcpu->arch.pio_data;
 
 	for (i = 0; i < count; i++) {
 		if (in)
@@ -6925,9 +6930,7 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 static int __emulator_pio_in(struct kvm_vcpu *vcpu, int size,
 			     unsigned short port, unsigned int count)
 {
-	WARN_ON(vcpu->arch.pio.count);
-	memset(vcpu->arch.pio_data, 0, size * count);
-	return emulator_pio_in_out(vcpu, size, port, count, true);
+	return emulator_pio_in_out(vcpu, size, port, NULL, count, true);
 }
 
 static void complete_emulator_pio_in(struct kvm_vcpu *vcpu, void *val)
@@ -6971,9 +6974,8 @@ static int emulator_pio_out(struct kvm_vcpu *vcpu, int size,
 {
 	int ret;
 
-	memcpy(vcpu->arch.pio_data, val, size * count);
-	trace_kvm_pio(KVM_PIO_OUT, port, size, count, vcpu->arch.pio_data);
-	ret = emulator_pio_in_out(vcpu, size, port, count, false);
+	trace_kvm_pio(KVM_PIO_OUT, port, size, count, val);
+	ret = emulator_pio_in_out(vcpu, size, port, (void *)val, count, false);
 	if (ret)
                 vcpu->arch.pio.count = 0;
 
-- 
2.27.0


