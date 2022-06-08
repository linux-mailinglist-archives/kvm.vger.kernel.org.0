Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5838E54300A
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 14:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238899AbiFHMNo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 08:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238915AbiFHMNF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 08:13:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D18F225F919
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 05:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654690377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7hkgfT4Y/KkWaSvKTff3vE46TyR/ZoWx2c0NUGxnBns=;
        b=KZ62abVIC8bRWLn548+peHlQiEDFybve/pnsU3fYDFlrTWnQh5cqUhPoIGjGljeS4uOg43
        ZRrJScwQ15qYsj14vBPBDgYq4AP7YTsNBRdNaRVEVl4S79lZuR/EX5YPzr4o0Vg0EMWnoK
        1wG4XM5I1HmYHXghv82WaIPxsYFTra4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-0AgD7xcWMfGBFK-CtPi1tw-1; Wed, 08 Jun 2022 08:12:54 -0400
X-MC-Unique: 0AgD7xcWMfGBFK-CtPi1tw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B893101AA4D;
        Wed,  8 Jun 2022 12:12:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F7701415100;
        Wed,  8 Jun 2022 12:12:54 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 1/6] KVM: x86: inline kernel_pio into its sole caller
Date:   Wed,  8 Jun 2022 08:12:48 -0400
Message-Id: <20220608121253.867333-2-pbonzini@redhat.com>
In-Reply-To: <20220608121253.867333-1-pbonzini@redhat.com>
References: <20220608121253.867333-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 79efdc19b4c8..2f9100f2564e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7415,37 +7415,32 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
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
2.31.1


