Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12104559F67
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 19:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiFXRTB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 13:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiFXRSx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 13:18:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BDDA041983
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 10:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656091130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jGYFcUhWUfpQReKmOabENcUHhZ3P86Vd8MgvEnhAkXA=;
        b=bTcAArtgn7qhSPDHjDEyvJd1CyW/AsZ/msjPZf0oC2YpHyLP4QBhgDDB94Mq/1Hh9fgtbX
        TsotmcTKA677QM8rpUuNhseLFOX7qK/aAp7HMzl7OHl+IWKTnz7t8w/CHM4UAVjPV0ve2X
        LX78L/JEYkYMvLNK4EN7hjURwIqL3Lg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-zn4jSehBNpiJla3JuzhOvA-1; Fri, 24 Jun 2022 13:18:49 -0400
X-MC-Unique: zn4jSehBNpiJla3JuzhOvA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 539322919EC1;
        Fri, 24 Jun 2022 17:18:49 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C9A1492C3B;
        Fri, 24 Jun 2022 17:18:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH v2 2/8] KVM: x86: inline kernel_pio into its sole caller
Date:   Fri, 24 Jun 2022 13:18:42 -0400
Message-Id: <20220624171848.2801602-3-pbonzini@redhat.com>
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

The caller of kernel_pio already has arguments for most of what kernel_pio
fishes out of vcpu->arch.pio.  This is the first step towards ensuring that
vcpu->arch.pio.* is only used when exiting to userspace.

No functional change intended.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d66a873f4427..524a96d26399 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7575,37 +7575,31 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
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
 	vcpu->run->exit_reason = KVM_EXIT_IO;
 	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
 	vcpu->run->io.size = size;
-- 
2.31.1


