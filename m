Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09521C5480
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 13:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgEELe5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 07:34:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49260 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728233AbgEELe5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 07:34:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588678496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=kf2bz/b6u5ATikbzlOoZD3Be2rrM+5Ro0erR1f3eNfM=;
        b=PFoA7c2Rxj+KRXe4vYUs8AjTZOg6wpMChDdlK2cMueELWtqqaVV7tv02msat7TDp4vurTy
        wLifBTSywS7wiCq5zj4uoQsV89c6fX/dhthptG6r3sKWnAbL0/eyXiTk5M6icB4UCMeVwg
        aqkiqXed6Kx+F8dsaEkJvzUx3qQJhXo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-TiiQpC0sMOaoVXL-Jk0a2Q-1; Tue, 05 May 2020 07:34:54 -0400
X-MC-Unique: TiiQpC0sMOaoVXL-Jk0a2Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98682835B40;
        Tue,  5 May 2020 11:34:53 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5930A5C1B2;
        Tue,  5 May 2020 11:34:50 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jmattson@google.com, peterx@redhat.com
Subject: [PATCH] KVM: x86: fix DR6 delivery for emulated hardware breakpoint
Date:   Tue,  5 May 2020 07:34:49 -0400
Message-Id: <20200505113449.18478-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Go through kvm_queue_exception_p so that the payload is correctly delivered
through the exit qualification, and add a kvm_update_dr6 call to
kvm_deliver_exception_payload that is needed on AMD.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c5835f9cb9ad..8f61cb15f147 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -473,6 +473,7 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
 		 * breakpoint), it is reserved and must be zero in DR6.
 		 */
 		vcpu->arch.dr6 &= ~BIT(12);
+		kvm_update_dr6(vcpu);
 		break;
 	case PF_VECTOR:
 		vcpu->arch.cr2 = payload;
@@ -6731,9 +6732,7 @@ static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
 					   vcpu->arch.db);
 
 		if (dr6 != 0) {
-			vcpu->arch.dr6 &= ~DR_TRAP_BITS;
-			vcpu->arch.dr6 |= dr6 | DR6_RTM;
-			kvm_queue_exception(vcpu, DB_VECTOR);
+			kvm_queue_exception_p(vcpu, DB_VECTOR, dr6);
 			*r = 1;
 			return true;
 		}
-- 
2.18.2

