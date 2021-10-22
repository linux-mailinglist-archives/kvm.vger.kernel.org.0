Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48AD3437A11
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 17:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbhJVPiv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 11:38:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31837 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233403AbhJVPis (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 11:38:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634916990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qEjgWJbpNIJZQvyAdA2aZae0irmK7CDWwgTx4nE6Fnc=;
        b=i6wE7pbVzRXKMfYmV7KI3Z56p03F10ozNh+ZIA3MdIdZ8fgArHkVHzuobXAVxjZfxOhKJt
        bLSXI5R4aoBBe+a9X6uJ2jUBU2L4SSqvyFl4virnhEgQ9JggEfip+meBPe2ocXYVTehH24
        G2o5OGAeG0mRICQdAdbjL6T/VTxvVOM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-GxHlLUyqMmKzl0yEBHmAqw-1; Fri, 22 Oct 2021 11:36:27 -0400
X-MC-Unique: GxHlLUyqMmKzl0yEBHmAqw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E9E3362FE;
        Fri, 22 Oct 2021 15:36:26 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FE6C60C04;
        Fri, 22 Oct 2021 15:36:26 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com
Subject: [PATCH 08/13] KVM: x86: inline kernel_pio into its sole caller
Date:   Fri, 22 Oct 2021 11:36:11 -0400
Message-Id: <20211022153616.1722429-9-pbonzini@redhat.com>
In-Reply-To: <20211022153616.1722429-1-pbonzini@redhat.com>
References: <20211022153616.1722429-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The caller of kernel_pio already has arguments for most of what kernel_pio
fishes out of vcpu->arch.pio.  This is the first step towards ensuring that
vcpu->arch.pio.* is only used when exiting to userspace.

We can now also WARN if emulated PIO performs successful in-kernel iterations
before having to fall back to userspace.  The code is not ready for that, and
it should never happen.

No functional change intended.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b26647a5ea22..d6b8df7cea80 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6886,37 +6886,32 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	return emulator_write_emulated(ctxt, addr, new, bytes, exception);
 }
 
-static int kernel_pio(struct kvm_vcpu *vcpu, void *pd)
-{
-	int r = 0, i;
-
-	for (i = 0; i < vcpu->arch.pio.count; i++) {
-		if (vcpu->arch.pio.in)
-			r = kvm_io_bus_read(vcpu, KVM_PIO_BUS, vcpu->arch.pio.port,
-					    vcpu->arch.pio.size, pd);
-		else
-			r = kvm_io_bus_write(vcpu, KVM_PIO_BUS,
-					     vcpu->arch.pio.port, vcpu->arch.pio.size,
-					     pd);
-		if (r)
-			break;
-		pd += vcpu->arch.pio.size;
-	}
-	return r;
-}
-
 static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 			       unsigned short port,
 			       unsigned int count, bool in)
 {
+	void *data = vcpu->arch.pio_data;
+	unsigned i;
+	int r;
+
 	vcpu->arch.pio.port = port;
 	vcpu->arch.pio.in = in;
-	vcpu->arch.pio.count  = count;
+	vcpu->arch.pio.count = count;
 	vcpu->arch.pio.size = size;
 
-	if (!kernel_pio(vcpu, vcpu->arch.pio_data))
-		return 1;
+	for (i = 0; i < count; i++) {
+		if (in)
+			r = kvm_io_bus_read(vcpu, KVM_PIO_BUS, port, size, data);
+		else
+			r = kvm_io_bus_write(vcpu, KVM_PIO_BUS, port, size, data);
+		if (r)
+			goto userspace_io;
+		data += size;
+	}
+	return 1;
 
+userspace_io:
+	WARN_ON(i != 0);
 	vcpu->run->exit_reason = KVM_EXIT_IO;
 	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
 	vcpu->run->io.size = size;
-- 
2.27.0


