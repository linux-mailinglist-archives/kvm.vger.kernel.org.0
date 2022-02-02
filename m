Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5634A77C0
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 19:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346600AbiBBSSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 13:18:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23063 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346501AbiBBSSU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Feb 2022 13:18:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643825900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BDwDrTJibr0ixLq4IwTrhHp/x9KXkNMTG4kmC+Qy0og=;
        b=BIN4dx4Dna4lxXn6bC7tx+alaHdascPRD89+EqqNSTzlkOY7i6C2YqBLxyMtmTBot5iwt0
        h2EehFneY+sA+zMmC2f1XEtIllkHXuWy6YGbCir3a+e9NqRfXl3GowJA00wF4wxzHpKKmo
        R4R3WWd/tetC6K9vZn676U2FMqjfuGk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-UcQvy9JTOwCeUo0EFRFVkQ-1; Wed, 02 Feb 2022 13:18:17 -0500
X-MC-Unique: UcQvy9JTOwCeUo0EFRFVkQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21647180FD60;
        Wed,  2 Feb 2022 18:18:16 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BFC567744F;
        Wed,  2 Feb 2022 18:18:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 3/5] KVM: x86: warn on incorrectly NULL static calls
Date:   Wed,  2 Feb 2022 13:18:11 -0500
Message-Id: <20220202181813.1103496-4-pbonzini@redhat.com>
In-Reply-To: <20220202181813.1103496-1-pbonzini@redhat.com>
References: <20220202181813.1103496-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the newly corrected KVM_X86_OP annotations to warn about possible
NULL pointer dereferences as soon as the vendor module is loaded.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c371ee7e45f7..61faeb57889c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1544,9 +1544,10 @@ extern struct kvm_x86_ops kvm_x86_ops;
 
 static inline void kvm_ops_static_call_update(void)
 {
-#define KVM_X86_OP(func) \
+#define KVM_X86_OP_NULL(func) \
 	static_call_update(kvm_x86_##func, kvm_x86_ops.func);
-#define KVM_X86_OP_NULL KVM_X86_OP
+#define KVM_X86_OP(func) \
+	WARN_ON(!kvm_x86_ops.func); KVM_X86_OP_NULL(func)
 #include <asm/kvm-x86-ops.h>
 }
 
-- 
2.31.1


