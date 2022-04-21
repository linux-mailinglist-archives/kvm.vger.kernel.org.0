Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06AC50A7C1
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 20:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391236AbiDUSHp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 14:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391208AbiDUSHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 14:07:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6EE6A4B1DE
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 11:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650564286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E6dh0F8rlY2iLG036JSLaiRrNHBRLRC4zYjjDnhEuYs=;
        b=epNfau9x0wuZ7IbGN0McyNXtJa46JRtvNMEyCtg0HrlELTMPAHz103RNJPHjMQG2+pm+DB
        XIm24eHq71D7Pw87hOU6KwY4J749JsGe3EuC2ZdRwDHQwmfljhDr/kdZMOyhe7bGLbA3PQ
        0N8LDh4GY+ByomN3JEwTmK5Z270OR6U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-YrqlrF3aPsmwb-9ZeiHAQA-1; Thu, 21 Apr 2022 14:04:45 -0400
X-MC-Unique: YrqlrF3aPsmwb-9ZeiHAQA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 604E43C0F09E;
        Thu, 21 Apr 2022 18:04:44 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B47A40E80F5;
        Thu, 21 Apr 2022 18:04:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     will@kernel.org, maz@kernel.org, apatel@ventanamicro.com,
        atishp@rivosinc.com, seanjc@google.com, pgonda@google.com
Subject: [PATCH 2/4] KVM: ARM: replace system_event.flags with ndata and data[0]
Date:   Thu, 21 Apr 2022 14:04:41 -0400
Message-Id: <20220421180443.1465634-3-pbonzini@redhat.com>
In-Reply-To: <20220421180443.1465634-1-pbonzini@redhat.com>
References: <20220421180443.1465634-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The flags datum for KVM_EXIT_SYSTEM_EVENT exits has been
removed because it was defined incorrectly; no padding was
introduced between the 32-bit type and the 64-bit flags,
resulting in different definitions for 32-bit and 64-bit
userspace.

The replacement is a pair of fields, ndata and data[],
with ndata saying how many items are valid in the data array.
In the case of ARM that's one, as flags can be simply moved
to data[0].

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm64/kvm/psci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index baac2b405f23..708d80e8e60d 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -181,7 +181,8 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
 
 	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
 	vcpu->run->system_event.type = type;
-	vcpu->run->system_event.flags = flags;
+	vcpu->run->system_event.ndata = 1;
+	vcpu->run->system_event.data[0] = flags;
 	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
 }
 
-- 
2.31.1


