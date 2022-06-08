Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7D2543005
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 14:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238911AbiFHMNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 08:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238875AbiFHMM6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 08:12:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF58D25D5E9
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 05:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654690376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rgGwuxnu2XznHcyK86tFDRI4P8omTRGQ5ct2XA85Ky0=;
        b=QplyQUyxb0ktHRUnGEY7T2gfkSNuPrmJ0MizG/84DvNXyMnCGGNXk+3JpmhtolEW+njVuW
        2Bm+7jMOZKXA5+RVuofUsRfsx+OlL6VBbbxrIHE/Ue7bh/XE8qoBxOLG4klv/WWLBErcoL
        P43nz2yyPFO6ZxwTQFR6y46HmyESm8c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-471-hCayFzAGO-Sw-RzWpq7kpQ-1; Wed, 08 Jun 2022 08:12:55 -0400
X-MC-Unique: hCayFzAGO-Sw-RzWpq7kpQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E41D53C02B7B;
        Wed,  8 Jun 2022 12:12:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C78BE1415100;
        Wed,  8 Jun 2022 12:12:54 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 6/6] KVM: SEV-ES: reuse advance_sev_es_emulated_ins for OUT too
Date:   Wed,  8 Jun 2022 08:12:53 -0400
Message-Id: <20220608121253.867333-7-pbonzini@redhat.com>
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

complete_emulator_pio_in only has to be called by
complete_sev_es_emulated_ins now; therefore, all that the function does
now is adjust sev_pio_count and sev_pio_data.  Which is the same for
both IN and OUT.

No functional change intended.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fd4382602f65..a3651aa74ed7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13007,6 +13007,12 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_mmio_read);
 
+static void advance_sev_es_emulated_pio(struct kvm_vcpu *vcpu, unsigned count, int size)
+{
+	vcpu->arch.sev_pio_count -= count;
+	vcpu->arch.sev_pio_data += count * size;
+}
+
 static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
 			   unsigned int port);
 
@@ -13030,8 +13036,7 @@ static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
 		int ret = emulator_pio_out(vcpu, size, port, vcpu->arch.sev_pio_data, count);
 
 		/* memcpy done already by emulator_pio_out.  */
-		vcpu->arch.sev_pio_count -= count;
-		vcpu->arch.sev_pio_data += count * vcpu->arch.pio.size;
+		advance_sev_es_emulated_pio(vcpu, count, size);
 		if (!ret)
 			break;
 
@@ -13047,12 +13052,6 @@ static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
 static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
 			  unsigned int port);
 
-static void advance_sev_es_emulated_ins(struct kvm_vcpu *vcpu, unsigned count, int size)
-{
-	vcpu->arch.sev_pio_count -= count;
-	vcpu->arch.sev_pio_data += count * size;
-}
-
 static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
 {
 	unsigned count = vcpu->arch.pio.count;
@@ -13060,7 +13059,7 @@ static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
 	int port = vcpu->arch.pio.port;
 
 	complete_emulator_pio_in(vcpu, vcpu->arch.sev_pio_data);
-	advance_sev_es_emulated_ins(vcpu, count, size);
+	advance_sev_es_emulated_pio(vcpu, count, size);
 	if (vcpu->arch.sev_pio_count)
 		return kvm_sev_es_ins(vcpu, size, port);
 	return 1;
@@ -13076,7 +13075,7 @@ static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
 			break;
 
 		/* Emulation done by the kernel.  */
-		advance_sev_es_emulated_ins(vcpu, count, size);
+		advance_sev_es_emulated_pio(vcpu, count, size);
 		if (!vcpu->arch.sev_pio_count)
 			return 1;
 	}
-- 
2.31.1

