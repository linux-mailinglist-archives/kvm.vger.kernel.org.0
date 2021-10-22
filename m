Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E68437A1F
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 17:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbhJVPjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 11:39:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27197 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233512AbhJVPiw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 11:38:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634916993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yesM4bnbuvBHDWYvVbHcSrG9nd5F7AWAvu39qQ3Mm10=;
        b=Hps1WmJjC2XCeL0r/NcTM44BquJuFThQxjjFfOIwyENVFQHr0JdAkPmsYYoS3klOlLzIlI
        BlI6M/qyhVPWY0P+ysKgc20ac1SOavlS6/RliMxMUZh9vSMWAHN/XgzFqexwZe4NiKwBJ/
        QceMMRui0wHF/t0Kz8IbDMDVs4dFQRY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-Rj4dV-H5PfWpQ1Evl38qbw-1; Fri, 22 Oct 2021 11:36:29 -0400
X-MC-Unique: Rj4dV-H5PfWpQ1Evl38qbw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAA4110A8E04;
        Fri, 22 Oct 2021 15:36:28 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C8F25D9DE;
        Fri, 22 Oct 2021 15:36:28 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com
Subject: [PATCH 12/13] KVM: x86: de-underscorify __emulator_pio_in
Date:   Fri, 22 Oct 2021 11:36:15 -0400
Message-Id: <20211022153616.1722429-13-pbonzini@redhat.com>
In-Reply-To: <20211022153616.1722429-1-pbonzini@redhat.com>
References: <20211022153616.1722429-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now all callers except emulator_pio_in_emulated are using
__emulator_pio_in/complete_emulator_pio_in explicitly.
Move the "either copy the result or attempt PIO" logic in
emulator_pio_in_emulated, and rename __emulator_pio_in to
just emulator_pio_in.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 42826087afd9..c3a2f479604d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6927,7 +6927,7 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 	return 0;
 }
 
-static int __emulator_pio_in(struct kvm_vcpu *vcpu, int size,
+static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
 			     unsigned short port, void *val, unsigned int count)
 {
 	int r = emulator_pio_in_out(vcpu, size, port, val, count, true);
@@ -6946,27 +6946,21 @@ static void complete_emulator_pio_in(struct kvm_vcpu *vcpu, void *val)
 	vcpu->arch.pio.count = 0;
 }
 
-static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
-			   unsigned short port, void *val, unsigned int count)
+static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
+				    int size, unsigned short port, void *val,
+				    unsigned int count)
 {
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	if (vcpu->arch.pio.count) {
 		/* Complete previous iteration.  */
 		WARN_ON(count != vcpu->arch.pio.count);
 		complete_emulator_pio_in(vcpu, val);
 		return 1;
 	} else {
-		return __emulator_pio_in(vcpu, size, port, val, count);
+		return emulator_pio_in(vcpu, size, port, val, count);
 	}
 }
 
-static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
-				    int size, unsigned short port, void *val,
-				    unsigned int count)
-{
-	return emulator_pio_in(emul_to_vcpu(ctxt), size, port, val, count);
-
-}
-
 static int emulator_pio_out(struct kvm_vcpu *vcpu, int size,
 			    unsigned short port, const void *val,
 			    unsigned int count)
@@ -8076,7 +8070,7 @@ static int kvm_fast_pio_in(struct kvm_vcpu *vcpu, int size,
 	/* For size less than 4 we merge, else we zero extend */
 	val = (size < 4) ? kvm_rax_read(vcpu) : 0;
 
-	ret = __emulator_pio_in(vcpu, size, port, &val, 1);
+	ret = emulator_pio_in(vcpu, size, port, &val, 1);
 	if (ret) {
 		kvm_rax_write(vcpu, val);
 		return ret;
@@ -12436,7 +12430,7 @@ static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
 	for (;;) {
 		unsigned int count =
 			min_t(unsigned int, PAGE_SIZE / size, vcpu->arch.sev_pio_count);
-		if (!__emulator_pio_in(vcpu, size, port, vcpu->arch.sev_pio_data, count))
+		if (!emulator_pio_in(vcpu, size, port, vcpu->arch.sev_pio_data, count))
 			break;
 
 		/* Emulation done by the kernel.  */
-- 
2.27.0


