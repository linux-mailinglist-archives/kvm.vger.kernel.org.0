Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E84A559F4F
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 19:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbiFXRTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 13:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbiFXRSx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 13:18:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 34CF548898
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 10:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656091131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1hrqZhznmf7in1ihxZqdR3dERc2u3SLv+rWTvwfVqKo=;
        b=Izfk2pJGKaETEmB9ZB/YmHVlet3dQy5tWVmS1Ge7KmueO6tGC7cncLcb2/63AORzlrh7cg
        QYqTERhkoVMsk74EH0huiOo81KseGv5NOUSQWgy7C3zmPcZlY3e5zBhROH7wOjJ8+gf5fW
        Oam1baG+duQ+15hd/O5DK+EeT7vUXpg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203-xDrcKZkpNrW1sS-BI2gNnQ-1; Fri, 24 Jun 2022 13:18:49 -0400
X-MC-Unique: xDrcKZkpNrW1sS-BI2gNnQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9472E81D9DA;
        Fri, 24 Jun 2022 17:18:49 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B040492C3B;
        Fri, 24 Jun 2022 17:18:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH v2 4/8] KVM: x86: move all vcpu->arch.pio* setup in emulator_pio_in_out()
Date:   Fri, 24 Jun 2022 13:18:44 -0400
Message-Id: <20220624171848.2801602-5-pbonzini@redhat.com>
In-Reply-To: <20220624171848.2801602-1-pbonzini@redhat.com>
References: <20220624171848.2801602-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For now, this is basically an excuse to add back the void* argument to
the function, while removing some knowledge of vcpu->arch.pio* from
its callers.  The WARN that vcpu->arch.pio.count is zero is also
extended to OUT operations.

The vcpu->arch.pio* fields still need to be filled even when the PIO is
handled in-kernel as __emulator_pio_in() is always followed by
complete_emulator_pio_in().  But after fixing that, it will be possible to
to only populate the vcpu->arch.pio* fields on userspace exits.

No functional change intended.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/trace.h |  2 +-
 arch/x86/kvm/x86.c   | 21 +++++++++++++--------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index bc85622e28b2..2120d7c060a9 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -154,7 +154,7 @@ TRACE_EVENT(kvm_xen_hypercall,
 
 TRACE_EVENT(kvm_pio,
 	TP_PROTO(unsigned int rw, unsigned int port, unsigned int size,
-		 unsigned int count, void *data),
+		 unsigned int count, const void *data),
 	TP_ARGS(rw, port, size, count, data),
 
 	TP_STRUCT__entry(
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5a56d39bd81f..368d0d4d56ff 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7576,17 +7576,25 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
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
+	if (in) {
+		/* The buffer is only used in complete_emulator_pio_in().  */
+		WARN_ON(data);
+		memset(vcpu->arch.pio_data, 0, size * count);
+	} else {
+		memcpy(vcpu->arch.pio_data, data, size * count);
+	}
+	data = vcpu->arch.pio_data;
 
 	for (i = 0; i < count; i++) {
 		if (in)
@@ -7623,9 +7631,7 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 static int __emulator_pio_in(struct kvm_vcpu *vcpu, int size,
 			     unsigned short port, unsigned int count)
 {
-	WARN_ON(vcpu->arch.pio.count);
-	memset(vcpu->arch.pio_data, 0, size * count);
-	return emulator_pio_in_out(vcpu, size, port, count, true);
+	return emulator_pio_in_out(vcpu, size, port, NULL, count, true);
 }
 
 static void complete_emulator_pio_in(struct kvm_vcpu *vcpu, void *val)
@@ -7674,9 +7680,8 @@ static int emulator_pio_out(struct kvm_vcpu *vcpu, int size,
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
2.31.1


