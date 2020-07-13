Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09746218574
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 13:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgGHLDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 07:03:55 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41503 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728454AbgGHLDy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jul 2020 07:03:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594206234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=X7JqGrX6+FRCRSoYELtArJatwC752X2T97lt6/es+Gg=;
        b=ZNnzLjcr1WJMYz5qNvBlcrHtqJymhlP64CopFAXQ6ixHKgQk0nuiWWG3CZZXLkoHTrTMRG
        rqx31CGwyHMwLmurdxDpW3qSwgKwMCqPhsgwXDciWEsKsNIpDVJxleurG3byS22Y0/Cmfe
        9G+GVe7599b1wvxa54I1rfhYKnYIL4c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-89poVGgePnqb6q3haNmrDw-1; Wed, 08 Jul 2020 07:03:52 -0400
X-MC-Unique: 89poVGgePnqb6q3haNmrDw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91EDD8015F5;
        Wed,  8 Jul 2020 11:03:51 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 402DB7848A;
        Wed,  8 Jul 2020 11:03:51 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: x86: Make CR4.VMXE reserved for the guest
Date:   Wed,  8 Jul 2020 07:03:50 -0400
Message-Id: <20200708110350.848997-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CR4.VMXE is reserved unless the VMX CPUID bit is set.  On Intel,
it is also tested by vmx_set_cr4, but AMD relies on kvm_valid_cr4,
so fix it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 56975c6c1e15..224670d7c245 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -392,6 +392,8 @@ bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu);
 		__reserved_bits |= X86_CR4_LA57;        \
 	if (!__cpu_has(__c, X86_FEATURE_UMIP))          \
 		__reserved_bits |= X86_CR4_UMIP;        \
+	if (!__cpu_has(__c, X86_FEATURE_VMX))           \
+		__reserved_bits |= X86_CR4_VMXE;        \
 	__reserved_bits;                                \
 })
 
-- 
2.26.2

