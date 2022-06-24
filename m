Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD76E559F97
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 19:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbiFXRTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 13:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbiFXRSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 13:18:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E23B3522D9
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 10:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656091132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VvU7t8xFORBUFemBDoOZqJ1ShL7jV39QnUV8wtDd2Po=;
        b=ESbTidcLFYaIimm9He2csKx3ooucfjCS5vV4WVEw59FpnEXYNfL1AVHluoCAA5JGMo7nyF
        cbFFln6EiJxDeVlfBDHaKJAIxnBDjfGk0wtKKHLiZaqnAmsyElHHCjy2SEQ0b2wYa3c+9g
        pCK45jeRfhtanjUWXH1DohzsayIVQyY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-_-PGNz0UO3maiMH9t1iTtw-1; Fri, 24 Jun 2022 13:18:50 -0400
X-MC-Unique: _-PGNz0UO3maiMH9t1iTtw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DF9F3C0E22E;
        Fri, 24 Jun 2022 17:18:50 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 063BF492C3B;
        Fri, 24 Jun 2022 17:18:50 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH v2 8/8] KVM: SEV-ES: reuse advance_sev_es_emulated_ins for OUT too
Date:   Fri, 24 Jun 2022 13:18:48 -0400
Message-Id: <20220624171848.2801602-9-pbonzini@redhat.com>
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

complete_emulator_pio_in() only has to be called by
complete_sev_es_emulated_ins() now; therefore, all that the function does
now is adjust sev_pio_count and sev_pio_data.  Which is the same for
both IN and OUT.

No functional change intended.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1a017a5a680b..567d13405445 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13206,6 +13206,12 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
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
 
@@ -13229,8 +13235,7 @@ static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
 		int ret = emulator_pio_out(vcpu, size, port, vcpu->arch.sev_pio_data, count);
 
 		/* memcpy done already by emulator_pio_out.  */
-		vcpu->arch.sev_pio_count -= count;
-		vcpu->arch.sev_pio_data += count * size;
+		advance_sev_es_emulated_pio(vcpu, count, size);
 		if (!ret)
 			break;
 
@@ -13246,12 +13251,6 @@ static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
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
@@ -13259,7 +13258,7 @@ static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
 	int port = vcpu->arch.pio.port;
 
 	complete_emulator_pio_in(vcpu, vcpu->arch.sev_pio_data);
-	advance_sev_es_emulated_ins(vcpu, count, size);
+	advance_sev_es_emulated_pio(vcpu, count, size);
 	if (vcpu->arch.sev_pio_count)
 		return kvm_sev_es_ins(vcpu, size, port);
 	return 1;
@@ -13275,7 +13274,7 @@ static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
 			break;
 
 		/* Emulation done by the kernel.  */
-		advance_sev_es_emulated_ins(vcpu, count, size);
+		advance_sev_es_emulated_pio(vcpu, count, size);
 		if (!vcpu->arch.sev_pio_count)
 			return 1;
 	}
-- 
2.31.1

