Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F33437A1B
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 17:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbhJVPjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 11:39:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48708 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233511AbhJVPiu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 11:38:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634916992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5OkuTkikhh7CYVgsIhFafniH+GVNeK9+PGVxNAudF/A=;
        b=ITvDJkGGhYlBAYMHQQ/JZQwFU6Ucn19ACF73Lmz1c1vutL0Od1KtVbzz2brJaB/rN8GDfR
        6s5pLv8Y7GMaLXNLFCgs08HZLIuJg5sCqU0Jqano4E/BGCgMvDjooWdAXjmXWmRt+qs24e
        K+c+4Wt/NRDCmxMuSVg0BxlXSmi9qOM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-pm8oOZBjNKOqAHiBcJY3lg-1; Fri, 22 Oct 2021 11:36:28 -0400
X-MC-Unique: pm8oOZBjNKOqAHiBcJY3lg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CEC5F806688;
        Fri, 22 Oct 2021 15:36:27 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E68A5D9DE;
        Fri, 22 Oct 2021 15:36:27 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com
Subject: [PATCH 10/13] KVM: x86: wean in-kernel PIO from vcpu->arch.pio*
Date:   Fri, 22 Oct 2021 11:36:13 -0400
Message-Id: <20211022153616.1722429-11-pbonzini@redhat.com>
In-Reply-To: <20211022153616.1722429-1-pbonzini@redhat.com>
References: <20211022153616.1722429-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make emulator_pio_in_out operate directly on the provided buffer
as long as PIO is handled inside KVM.

For input operations, this means that, in the case of in-kernel
PIO, __emulator_pio_in does not have to be always followed
by complete_emulator_pio_in.  This affects emulator_pio_in and
kvm_sev_es_ins; for the latter, that is why the call moves from
advance_sev_es_emulated_ins to complete_sev_es_emulated_ins.

For output, it means that vcpu->pio.count is never set unnecessarily
and there is no need to clear it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 63 +++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7c421d9fbcb6..e3d3c13fe803 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6894,16 +6894,6 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 	int r;
 
 	WARN_ON_ONCE(vcpu->arch.pio.count);
-	vcpu->arch.pio.port = port;
-	vcpu->arch.pio.in = in;
-	vcpu->arch.pio.count = count;
-	vcpu->arch.pio.size = size;
-	if (in)
-		memset(vcpu->arch.pio_data, 0, size * count);
-	else
-		memcpy(vcpu->arch.pio_data, data, size * count);
-	data = vcpu->arch.pio_data;
-
 	for (i = 0; i < count; i++) {
 		if (in)
 			r = kvm_io_bus_read(vcpu, KVM_PIO_BUS, port, size, data);
@@ -6917,6 +6907,16 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 
 userspace_io:
 	WARN_ON(i != 0);
+	vcpu->arch.pio.port = port;
+	vcpu->arch.pio.in = in;
+	vcpu->arch.pio.count = count;
+	vcpu->arch.pio.size = size;
+
+	if (in)
+		memset(vcpu->arch.pio_data, 0, size * count);
+	else
+		memcpy(vcpu->arch.pio_data, data, size * count);
+
 	vcpu->run->exit_reason = KVM_EXIT_IO;
 	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
 	vcpu->run->io.size = size;
@@ -6928,9 +6928,13 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 }
 
 static int __emulator_pio_in(struct kvm_vcpu *vcpu, int size,
-			     unsigned short port, unsigned int count)
+			     unsigned short port, void *val, unsigned int count)
 {
-	return emulator_pio_in_out(vcpu, size, port, NULL, count, true);
+	int r = emulator_pio_in_out(vcpu, size, port, val, count, true);
+	if (r)
+		trace_kvm_pio(KVM_PIO_IN, port, size, count, val);
+
+	return r;
 }
 
 static void complete_emulator_pio_in(struct kvm_vcpu *vcpu, void *val)
@@ -6947,17 +6951,12 @@ static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
 {
 	if (vcpu->arch.pio.count) {
 		/* Complete previous iteration.  */
+		WARN_ON(count != vcpu->arch.pio.count);
+		complete_emulator_pio_in(vcpu, val);
+		return 1;
 	} else {
-		int r = __emulator_pio_in(vcpu, size, port, count);
-		if (!r)
-			return r;
-
-		/* Results already available, fall through.  */
+		return __emulator_pio_in(vcpu, size, port, val, count);
 	}
-
-	WARN_ON(count != vcpu->arch.pio.count);
-	complete_emulator_pio_in(vcpu, val);
-	return 1;
 }
 
 static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
@@ -6972,14 +6971,8 @@ static int emulator_pio_out(struct kvm_vcpu *vcpu, int size,
 			    unsigned short port, const void *val,
 			    unsigned int count)
 {
-	int ret;
-
 	trace_kvm_pio(KVM_PIO_OUT, port, size, count, val);
-	ret = emulator_pio_in_out(vcpu, size, port, (void *)val, count, false);
-	if (ret)
-                vcpu->arch.pio.count = 0;
-
-        return ret;
+	return emulator_pio_in_out(vcpu, size, port, (void *)val, count, false);
 }
 
 static int emulator_pio_out_emulated(struct x86_emulate_ctxt *ctxt,
@@ -12422,20 +12415,20 @@ static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
 static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
 			  unsigned int port);
 
-static void advance_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
+static void advance_sev_es_emulated_ins(struct kvm_vcpu *vcpu, unsigned count, int size)
 {
-	unsigned count = vcpu->arch.pio.count;
-	complete_emulator_pio_in(vcpu, vcpu->arch.sev_pio_data);
 	vcpu->arch.sev_pio_count -= count;
-	vcpu->arch.sev_pio_data += count * vcpu->arch.pio.size;
+	vcpu->arch.sev_pio_data += count * size;
 }
 
 static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
 {
+	unsigned count = vcpu->arch.pio.count;
 	int size = vcpu->arch.pio.size;
 	int port = vcpu->arch.pio.port;
 
-	advance_sev_es_emulated_ins(vcpu);
+	complete_emulator_pio_in(vcpu, vcpu->arch.sev_pio_data);
+	advance_sev_es_emulated_ins(vcpu, count, size);
 	if (vcpu->arch.sev_pio_count)
 		return kvm_sev_es_ins(vcpu, size, port);
 	return 1;
@@ -12447,11 +12440,11 @@ static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
 	for (;;) {
 		unsigned int count =
 			min_t(unsigned int, PAGE_SIZE / size, vcpu->arch.sev_pio_count);
-		if (!__emulator_pio_in(vcpu, size, port, count))
+		if (!__emulator_pio_in(vcpu, size, port, vcpu->arch.sev_pio_data, count))
 			break;
 
 		/* Emulation done by the kernel.  */
-		advance_sev_es_emulated_ins(vcpu);
+		advance_sev_es_emulated_ins(vcpu, count, size);
 		if (!vcpu->arch.sev_pio_count)
 			return 1;
 	}
-- 
2.27.0


