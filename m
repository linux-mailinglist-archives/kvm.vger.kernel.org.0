Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27933437A1C
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 17:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbhJVPjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 11:39:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20288 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233516AbhJVPiv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 11:38:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634916993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6pDVBK3tKFOCe3j1KA9rtn173ZoAK7okWWJpm9DtEwc=;
        b=GwztqHySz56HhQtyWaE1HutBudA2AQ6cB6iQRZkmcmY8aFbEX5Do8xG8VIfitssYH92eV3
        uu3PbIgyuy7PHiXKW+z+KH/Kbj/tB5e/DrvF0KlPBnamjMUqbdASOhk0QhB0Zu5SshH/vd
        KOZM/lInYE1xfCapxbpW30Q+FmlbVYs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-Wrpd-dynMyOp-DGRnaR5BA-1; Fri, 22 Oct 2021 11:36:30 -0400
X-MC-Unique: Wrpd-dynMyOp-DGRnaR5BA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7419A19253C0;
        Fri, 22 Oct 2021 15:36:29 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4BC95D9DE;
        Fri, 22 Oct 2021 15:36:28 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com
Subject: [PATCH 13/13] KVM: SEV-ES: reuse advance_sev_es_emulated_ins for OUT too
Date:   Fri, 22 Oct 2021 11:36:16 -0400
Message-Id: <20211022153616.1722429-14-pbonzini@redhat.com>
In-Reply-To: <20211022153616.1722429-1-pbonzini@redhat.com>
References: <20211022153616.1722429-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
index c3a2f479604d..b9ce4cfec121 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12365,6 +12365,12 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
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
 
@@ -12388,8 +12394,7 @@ static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
 		int ret = emulator_pio_out(vcpu, size, port, vcpu->arch.sev_pio_data, count);
 
 		/* memcpy done already by emulator_pio_out.  */
-		vcpu->arch.sev_pio_count -= count;
-		vcpu->arch.sev_pio_data += count * vcpu->arch.pio.size;
+		advance_sev_es_emulated_pio(vcpu, count, size);
 		if (!ret)
 			break;
 
@@ -12405,12 +12410,6 @@ static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
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
@@ -12418,7 +12417,7 @@ static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
 	int port = vcpu->arch.pio.port;
 
 	complete_emulator_pio_in(vcpu, vcpu->arch.sev_pio_data);
-	advance_sev_es_emulated_ins(vcpu, count, size);
+	advance_sev_es_emulated_pio(vcpu, count, size);
 	if (vcpu->arch.sev_pio_count)
 		return kvm_sev_es_ins(vcpu, size, port);
 	return 1;
@@ -12434,7 +12433,7 @@ static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
 			break;
 
 		/* Emulation done by the kernel.  */
-		advance_sev_es_emulated_ins(vcpu, count, size);
+		advance_sev_es_emulated_pio(vcpu, count, size);
 		if (!vcpu->arch.sev_pio_count)
 			return 1;
 	}
-- 
2.27.0

