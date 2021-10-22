Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59638437A0F
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 17:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233525AbhJVPiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 11:38:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58931 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233486AbhJVPis (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 11:38:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634916990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mILBj8cFSB0vPqT5FV/Ogq6wuN7S5utl2eWZSKdJpzw=;
        b=YB2QIVgZsK4c/+UifTVuP9NvWwCOycU8p7sXTLnBI9F2YSjK5JcD6T8RmuxJOo6sZ2pIER
        VCiXXEmzZip+bJxVCWURAOyoy12DgSBDt+w4NebljwN21hpmdB2SFQRkcni7PBCW0hxi09
        EoDX88/iAwkKfqAS2+D5RXIH3iz7x+g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-HCrSzYtdNECAHnPbW7Oylw-1; Fri, 22 Oct 2021 11:36:29 -0400
X-MC-Unique: HCrSzYtdNECAHnPbW7Oylw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 529D58030B7;
        Fri, 22 Oct 2021 15:36:28 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E888F5D9DE;
        Fri, 22 Oct 2021 15:36:27 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com
Subject: [PATCH 11/13] KVM: x86: wean fast IN from emulator_pio_in
Date:   Fri, 22 Oct 2021 11:36:14 -0400
Message-Id: <20211022153616.1722429-12-pbonzini@redhat.com>
In-Reply-To: <20211022153616.1722429-1-pbonzini@redhat.com>
References: <20211022153616.1722429-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that __emulator_pio_in already fills "val" for in-kernel PIO, it
is both simpler and clearer not to use emulator_pio_in.
Use the appropriate function in kvm_fast_pio_in and complete_fast_pio_in,
respectively __emulator_pio_in and complete_emulator_pio_in.

emulator_pio_in_emulated is now the last caller of emulator_pio_in.

No functional change intended.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e3d3c13fe803..42826087afd9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8061,11 +8061,7 @@ static int complete_fast_pio_in(struct kvm_vcpu *vcpu)
 	/* For size less than 4 we merge, else we zero extend */
 	val = (vcpu->arch.pio.size < 4) ? kvm_rax_read(vcpu) : 0;
 
-	/*
-	 * Since vcpu->arch.pio.count == 1 let emulator_pio_in perform
-	 * the copy and tracing
-	 */
-	emulator_pio_in(vcpu, vcpu->arch.pio.size, vcpu->arch.pio.port, &val, 1);
+	complete_emulator_pio_in(vcpu, &val);
 	kvm_rax_write(vcpu, val);
 
 	return kvm_skip_emulated_instruction(vcpu);
@@ -8080,7 +8076,7 @@ static int kvm_fast_pio_in(struct kvm_vcpu *vcpu, int size,
 	/* For size less than 4 we merge, else we zero extend */
 	val = (size < 4) ? kvm_rax_read(vcpu) : 0;
 
-	ret = emulator_pio_in(vcpu, size, port, &val, 1);
+	ret = __emulator_pio_in(vcpu, size, port, &val, 1);
 	if (ret) {
 		kvm_rax_write(vcpu, val);
 		return ret;
-- 
2.27.0


