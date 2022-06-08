Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BE1543000
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 14:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238888AbiFHMNC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 08:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238724AbiFHMM6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 08:12:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1EB1F25BF8C
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 05:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654690376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/cd0pfqoZ+Edyksi+uqsAtQqSZ+Labql7FxF90QuYp4=;
        b=ibqvGe/gBTsjo9O6GlM1FFMAwDPVrupexqw6nFzSYas71P5JfcKfbpwO6yP27hYVtmIvo/
        hkC/wHpx9vUvqY/KhbCyX36Rfm7veZRrZzvgvEHh2cPRs7y2fgqu14r0Ne83L31PqUCF6L
        Kf6qxMonbxQE+Z4VPb9/1U02TEUUTZk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-8IKirdguNSeXiLotzos6Ew-1; Wed, 08 Jun 2022 08:12:55 -0400
X-MC-Unique: 8IKirdguNSeXiLotzos6Ew-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF30685A588;
        Wed,  8 Jun 2022 12:12:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1D1F1415100;
        Wed,  8 Jun 2022 12:12:54 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 5/6] KVM: x86: de-underscorify __emulator_pio_in
Date:   Wed,  8 Jun 2022 08:12:52 -0400
Message-Id: <20220608121253.867333-6-pbonzini@redhat.com>
In-Reply-To: <20220608121253.867333-1-pbonzini@redhat.com>
References: <20220608121253.867333-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index aefcc71a7040..fd4382602f65 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7456,7 +7456,7 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 	return 0;
 }
 
-static int __emulator_pio_in(struct kvm_vcpu *vcpu, int size,
+static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
 			     unsigned short port, void *val, unsigned int count)
 {
 	int r = emulator_pio_in_out(vcpu, size, port, val, count, true);
@@ -7475,9 +7475,11 @@ static void complete_emulator_pio_in(struct kvm_vcpu *vcpu, void *val)
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
 		/*
 		 * Complete a previous iteration that required userspace I/O.
@@ -7489,18 +7491,10 @@ static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
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
@@ -8707,7 +8701,7 @@ static int kvm_fast_pio_in(struct kvm_vcpu *vcpu, int size,
 	/* For size less than 4 we merge, else we zero extend */
 	val = (size < 4) ? kvm_rax_read(vcpu) : 0;
 
-	ret = __emulator_pio_in(vcpu, size, port, &val, 1);
+	ret = emulator_pio_in(vcpu, size, port, &val, 1);
 	if (ret) {
 		kvm_rax_write(vcpu, val);
 		return ret;
@@ -13078,7 +13072,7 @@ static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
 	for (;;) {
 		unsigned int count =
 			min_t(unsigned int, PAGE_SIZE / size, vcpu->arch.sev_pio_count);
-		if (!__emulator_pio_in(vcpu, size, port, vcpu->arch.sev_pio_data, count))
+		if (!emulator_pio_in(vcpu, size, port, vcpu->arch.sev_pio_data, count))
 			break;
 
 		/* Emulation done by the kernel.  */
-- 
2.31.1


